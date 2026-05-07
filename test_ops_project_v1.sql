-- ==========================================
-- 业务数据运维模板 (增删改查)
-- ==========================================

-- 1. 更新数据 (UPDATE)
-- 场景：供应商 A 厂申诉成功，需要将某个 rejected 的任务改为 completed
UPDATE labeling_tasks 
SET status = 'completed' 
WHERE task_id = 8; -- 💡 永远记得带上 WHERE 条件，防止误伤全表！


-- 2. 删除数据 (DELETE)
-- 场景：删除一些由于手抖插入的重复或错误数据
DELETE FROM labeling_tasks 
WHERE task_id = 13; -- 💡 建议删除前先 SELECT 确认一下


-- 3. 批量修改 (CASE WHEN 进阶)
-- 场景：所有 waiting_review 且是 B 厂的任务，统一改为 completed
UPDATE labeling_tasks
SET status = 'completed'
WHERE status = 'waiting_review' AND supplier = 'B厂';


-- 4. 插入单条数据 (备用)
INSERT INTO labeling_tasks (game_name, supplier, status) 
VALUES ('new_project', 'D厂', 'waiting_review');





-- 1.多表关联 (JOIN) —— 打破数据孤岛（LEFT JOIN 是 PM 用得最多的关联方式：以左表为准，右表有的就贴上去，没有的就留空）
SELECT 
    t.task_id,
    t.game_name,
    t.supplier,
    s.contact_name,  -- 这里的字段来自右表
    s.phone
FROM labeling_tasks AS t
LEFT JOIN supplier_info AS s 
    ON t.supplier = s.supplier_name; -- 匹配的桥梁



    WITH supplier_stats AS (
    -- 第一步：先算基础统计
    SELECT supplier, COUNT(*) AS total, SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) AS done
    FROM labeling_tasks
    GROUP BY supplier
)

-- 2. 临时表 / 积木思维 (WITH / CTE) —— 让复杂 SQL 变简单（基于上面的结果进行过滤和查询）
SELECT supplier, done, total 
FROM supplier_stats 
WHERE (done * 1.0 / total) > 0.8;



-- 3. 窗口函数 (Window Functions) —— 数据分析的“杀手锏”
SELECT 
    task_id, 
    supplier, 
    status,
    -- 核心魔法：按供应商分组，在组内按 task_id 倒序打上编号 1,2,3...
    ROW_NUMBER() OVER(PARTITION BY supplier ORDER BY task_id DESC) AS rank_num
FROM labeling_tasks;