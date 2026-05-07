-- ==========================================
-- 1. 创建并初始化供应商信息表 (右表)
-- ==========================================
DROP TABLE IF EXISTS supplier_info;
CREATE TABLE supplier_info (
    supplier_name TEXT PRIMARY KEY,
    contact_name TEXT,
    phone TEXT,
    rating TEXT,          -- 供应商评级 (S, A, B, C)
    billing_cycle INTEGER, -- 账期(天)
    join_date DATE         -- 合作起始日
);

INSERT INTO supplier_info (supplier_name, contact_name, phone, rating, billing_cycle, join_date) VALUES
('A厂', '张经理', '138-0000-0001', 'S', 30, '2023-01-15'),
('B厂', '李主管', '139-0000-0002', 'A', 45, '2023-06-20'),
('C厂', '王老板', '137-0000-0003', 'B', 60, '2024-02-10'),
('D厂', '赵组长', '136-0000-0004', 'C', 90, '2024-05-01');


-- ==========================================
-- 2. 升级并初始化标注任务表 (左表)
-- ==========================================
DROP TABLE IF EXISTS labeling_tasks;
CREATE TABLE labeling_tasks (
    task_id INTEGER PRIMARY KEY,
    game_name TEXT,
    task_type TEXT,        -- 新增：标注类型 (拉框/点云/分割)
    data_volume INTEGER,   -- 新增：数据量(张/帧/条)
    unit_price REAL,       -- 新增：单价(元)
    supplier TEXT,
    status TEXT,
    submit_time DATE       -- 新增：提交时间
);

INSERT INTO labeling_tasks (task_id, game_name, task_type, data_volume, unit_price, supplier, status, submit_time) VALUES
(1, 'hogwarts', '2D拉框', 5000, 0.5, 'A厂', 'completed', '2024-03-01'),
(2, 'hogwarts', '3D点云', 1000, 2.5, 'A厂', 'waiting_review', '2024-03-05'),
(3, 'hogwarts', '多边形分割', 2000, 1.2, 'B厂', 'rejected', '2024-03-02'),
(4, 'dauntless', '2D拉框', 8000, 0.4, 'A厂', 'completed', '2024-03-10'),
(5, 'dauntless', '语义分割', 3000, 1.5, 'B厂', 'completed', '2024-03-12'),
(6, 'dauntless', '2D拉框', 4000, 0.4, 'B厂', 'waiting_review', '2024-03-15'),
(7, 'hogwarts', '3D点云', 1500, 2.5, 'A厂', 'completed', '2024-03-18'),
(8, 'dauntless', '语义分割', 2500, 1.5, 'A厂', 'rejected', '2024-03-20'),
(9, 'dauntless', '多边形分割', 6000, 1.2, 'B厂', 'waiting_review', '2024-03-22'),
(10, 'hogwarts', '2D拉框', 10000, 0.5, 'B厂', 'completed', '2024-03-25'),
(11, 'new_game_01', 'NLP文本分类', 50000, 0.1, 'C厂', 'completed', '2024-04-01'),
(12, 'new_game_01', 'NLP实体识别', 20000, 0.2, 'C厂', 'waiting_review', '2024-04-05'),
(13, 'new_game_02', '视频关键帧', 800, 5.0, 'D厂', 'rejected', '2024-04-10'),
(14, 'new_game_02', '视频关键帧', 1200, 5.0, 'D厂', 'completed', '2024-04-12'),
(15, 'dauntless', '3D点云', 2000, 2.5, 'A厂', 'completed', '2024-04-15');

INSERT INTO labeling_tasks (game_name, task_type, data_volume, unit_price, supplier, status, submit_time) 
VALUES ('hogwarts', '2D拉框', 100, 1.0, 'A厂', 'rejected', '2026-04-28');