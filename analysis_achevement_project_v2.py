import sqlite3
import pandas as pd
from datetime import datetime
import os

# --- 配置区域 ---
# 1. 定位文件夹：确保脚本能找到身边的 project_v2.db
base_path = os.path.dirname(os.path.abspath(__file__))

# 2. 修改点 1：将数据库指向 V2 版本
DB_NAME = os.path.join(base_path, 'project_v2.db')

# 3. 修改点 2：微调输出文件名，使其更符合业务描述
OUTPUT_NAME = os.path.join(base_path, f'供应商全维度绩效对账单_V2_{datetime.now().strftime("%Y%m%d")}.xlsx')
# --- 配置结束 ---

def run_analysis():
    # 安全检查：地基在不在？
    if not os.path.exists(DB_NAME):
        print(f"🚨 错误：找不到 V2 数据库文件！\n路径：{DB_NAME}")
        return

    conn = None
    try:
        # 1. 建立隧道
        conn = sqlite3.connect(DB_NAME)
        print(f"📡 已成功连接 V2 仓库: {DB_NAME}")

        # 2. 修改点 3：替换为我们刚刚练成的“跨表关联”高级 SQL
        # 💡 这里直接在 SQL 里完成了“算钱”和“信息拼装”
        query = """
        SELECT 
            s.supplier_name AS 供应商,
            s.contact_name AS 联系人,
            s.phone AS 联系电话,
            s.rating AS 初始评级,
            COUNT(t.task_id) AS 总承接任务数,
            SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END) AS 已完成数,
            -- 计算通过率
            ROUND(CAST(SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(t.task_id) * 100, 2) AS 通过率
        FROM supplier_info AS s
        LEFT JOIN labeling_tasks AS t 
            ON s.supplier_name = t.supplier
        GROUP BY s.supplier_name  
        -- 💡 核心点：执行过滤，只导出通过率低于 80 的
        HAVING 通过率 < 80
        ORDER BY 通过率 ASC;
        """

        # 3. 执行分析
        print("📊 正在执行跨表关联分析并抓取数据...")
        df = pd.read_sql_query(query, conn)

        # 4. 导出为 Excel
        if df.empty:
            print("⚠️ 提示：查询结果为空，请确认数据库中是否有数据。")
            return

        print(f"📥 正在导出全维度报表至: {os.path.basename(OUTPUT_NAME)}")
        df.to_excel(OUTPUT_NAME, index=False)

        print("-" * 30)
        print("✨ 恭喜！V2 自动化对账单已生成。")
        print(f"📁 文件位置: {OUTPUT_NAME}")

    except Exception as e:
        print(f"❌ 运行中出现意外崩溃: {e}")
    
    finally:
        if conn:
            conn.close()
            print("🔒 数据库连接已安全释放。")

if __name__ == "__main__":
    run_analysis()