-- 1. 供应商通过率分析 (按供应商汇总)
SELECT 
    supplier AS 供应商,
    COUNT(*) AS 总任务数,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS 已完成数,
    ROUND(CAST(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) || '%' AS 通过率
FROM labeling_tasks
GROUP BY supplier;

-- 2. 游戏项目进度分析 (按游戏汇总)
SELECT 
    game_name AS 游戏项目,
    COUNT(*) AS 总任务数,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS 已通过数,
    SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS 打回数,
    SUM(CASE WHEN status = 'waiting_review' THEN 1 ELSE 0 END) AS 待审核数
FROM labeling_tasks
GROUP BY game_name;