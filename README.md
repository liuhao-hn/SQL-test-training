# SQL 实战训练库

欢迎来到我的 SQL 训练与测试代码仓库

本项目记录了我进行 SQL 数据库操作与数据分析的完整实战过程。仓库内包含了从零开始的数据库搭建、增删改查（CRUD）操作、多表关联查询（Join）、聚合统计分析，以及结合 Python 进行自动化数据处理的全套代码。

## 仓库结构 (Repository Structure)

本项目按照文件类型和功能分为三大模块，所有文件均存放于 `main` 主分支下：

### 1. 数据库文件 (Databases)
本地 SQLite 数据库文件，作为所有 SQL 脚本和 Python 脚本的底层数据源。
* `project_v1.db`：V1 阶段的基础数据库。
* `project_v2.db`：V2 阶段进阶版数据库（包含更复杂的数据表结构）。

### 2. SQL 脚本 (SQL Scripts)
涵盖了 DDL（数据定义语言）、DML（数据操作语言）和 DQL（数据查询语言）的核心实战。
* **建表与初始化 (DDL)**
  * `test_creat_project_v1.sql`：V1 基础数据表创建与约束定义。
  * `test_creat_project_v2.sql`：V2 进阶数据表创建。
* **数据操作 (DML)**
  * `test_ops_project_v1.sql`：数据的增、删、改（Insert/Update/Delete）等日常运维操作。
* **高阶查询与统计 (DQL)**
  * `test_check_project_v1.sql`：V1 基础数据校验与查询。
  * `test_statistics_project_v1.sql`：常用聚合函数（Group by, Sum, Count 等）的统计训练。
  * `test_check&join_project_v2.sql`：V2 复杂多表关联（Inner/Left Join）与嵌套查询。

### 3. Python 自动化分析 (Python Analysis)
使用 Python 结合 SQLite 数据库进行自动化读取与高阶数据分析。
* `main_analysis.py`：主程序入口，负责调度各项分析任务。
* `analysis_project_v2.py`：针对 V2 数据库的核心分析逻辑。
* `analysis_achievement_project_v2.py`：特定业务场景（如：成绩/业绩）的数据深度提取与处理脚本。

## 核心技能栈 (Skills Demonstrated)
* **SQL:** Table Creation, CRUD, Multi-table Joins, Data Aggregation, Subqueries.
* **Database:** SQLite.
* **Programming:** Python (Data connection, Data manipulation).

---
* 持续更新与学习中 / Keep learning and coding!*
