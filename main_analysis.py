import sqlite3
import pandas as pd
from datetime import datetime
import os

# --- 配置区域 ---
# 1. 获取当前脚本所在的文件夹路径
base_path = os.path.dirname(os.path.abspath(__file__))

# 2. 拼接数据库和输出文件的绝对路径
DB_NAME = os.path.join(base_path, 'project_v1.db')
# 把 Excel 也生成在同一个文件夹下
OUTPUT_NAME = os.path.join(base_path, f'供应商绩效分析报告_{datetime.now().strftime("%Y%m%d")}.xlsx')
# --- 配置结束 ---

def run_analysis():
    # 💡 进阶技巧：先检查数据库文件是否存在，不存在就直接结束，不浪费感情
    if not os.path.exists(DB_NAME):
        print(f"🚨 错误：找不到数据库文件！\n路径：{DB_NAME}\n请确保 .db 文件和本脚本在同一个文件夹。")
        return

    conn = None # 初始化连接变量
    try:
        # 1. 建立数据库连接
        conn = sqlite3.connect(DB_NAME)
        print(f"📡 已成功连接仓库: {DB_NAME}")

        # 2. 核心分析 SQL
        query = """
        SELECT 
            supplier AS 供应商,
            game_name AS 游戏项目,
            COUNT(*) AS 总任务数,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS 已完成,
            SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS 被打回,
            ROUND(CAST(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) || '%' AS 通过率
        FROM labeling_tasks
        GROUP BY supplier, game_name
        ORDER BY 通过率 DESC;
        """

        # 3. 执行分析并抓取数据
        print("📊 正在生成数据透视图...")
        df = pd.read_sql_query(query, conn)

        # 4. 导出为 Excel
        print(f"📥 正在导出报表至: {os.path.basename(OUTPUT_NAME)}")
        df.to_excel(OUTPUT_NAME, index=False)

        print("-" * 30)
        print("✨ 恭喜！报表已生成。")
        print(f"📁 文件位置: {OUTPUT_NAME}")

    except Exception as e:
        print(f"❌ 运行中出现意外: {e}")
    
    finally:
        if conn:
            conn.close()
            print("🔒 数据库连接已安全关闭。")

if __name__ == "__main__":
    run_analysis()