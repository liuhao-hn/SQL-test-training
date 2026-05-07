-- 创建表结构 (如果表已存在可以注释掉下面几行)
CREATE TABLE IF NOT EXISTS labeling_tasks (
    task_id INTEGER PRIMARY KEY,
    game_name TEXT,
    supplier TEXT,
    status TEXT
);

-- 插入初始数据 (这是你原来的模板数据)
INSERT INTO labeling_tasks (task_id, game_name, supplier, status) VALUES
(1, 'hogwarts', 'A厂', 'completed'),
(2, 'hogwarts', 'A厂', 'waiting_review'),
(3, 'hogwarts', 'B厂', 'rejected'),
(4, 'dauntless', 'A厂', 'completed'),
(5, 'dauntless', 'B厂', 'completed'),
(6, 'dauntless', 'B厂', 'waiting_review'),
(7, 'hogwarts', 'A厂', 'completed'),
(8, 'dauntless', 'A厂', 'rejected'),
(9, 'dauntless', 'B厂', 'waiting_review'),
(10, 'hogwarts', 'B厂', 'completed'),
(11, 'new_game_01', 'C厂', 'completed'),
(12, 'new_game_01', 'C厂', 'waiting_review'),
(13, 'new_game_02', 'D厂', 'rejected');