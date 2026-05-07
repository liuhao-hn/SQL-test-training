-- 1. 查出这个数据库里所有的“表名”
SELECT name 
FROM sqlite_master 
WHERE type = 'table' AND name NOT LIKE 'sqlite_%';

-- 2. 查看表结构（这是 SQLite 的原生“暗号”，不走 SELECT 逻辑，稳如泰山）
PRAGMA table_info('labeling_tasks');

-- 3. 查看所有数据（回归最简单的语法）
SELECT * FROM labeling_tasks;

-- 4. 查看标签分布（PM 最核心的统计需求）
SELECT status, COUNT(*) AS total FROM labeling_tasks GROUP BY status;