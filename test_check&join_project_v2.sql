-- 1. 查出这个数据库里所有的“表名”
SELECT name 
FROM sqlite_master 
WHERE type = 'table' AND name NOT LIKE 'sqlite_%';

-- 2. 查看两张表的结构图纸（分两次看）
PRAGMA table_info('labeling_tasks');
PRAGMA table_info('supplier_info');

-- 3. 抽样看两张表的货物（确认数据都灌进去了）
SELECT * FROM labeling_tasks;
SELECT * FROM supplier_info;

-- 4. 核心统计：查看任务状态分布
SELECT status, COUNT(*) AS total FROM labeling_tasks GROUP BY status;

-- 5. 跨表缝合 (LEFT JOIN)
SELECT 
    t.task_id,
    t.game_name,
    t.task_type,
    t.data_volume * t.unit_price AS 预估结算金额,  -- 让数据库直接帮你算钱
    t.supplier,
    s.contact_name,
    s.phone,
    s.rating AS 评级,
    t.status
FROM labeling_tasks AS t
LEFT JOIN supplier_info AS s 
    ON t.supplier = s.supplier_name;

-- 6. 供应商绩效分析
WITH supplier_performance AS (
    -- 第一步：先算出每个供应商的统计数据
    SELECT 
        supplier AS 供应商,
        COUNT(*) AS 总任务数,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS 已完成,
        -- 计算通过率数值（浮点数，方便后面做数学比较）
        ROUND(CAST(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) AS 通过率数值
    FROM labeling_tasks
    GROUP BY supplier
)
-- 第二步：只筛选出通过率低于 80% 的倒霉蛋
SELECT * FROM supplier_performance 
WHERE 通过率数值 < 80;