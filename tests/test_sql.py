import os
import sqlite3
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# 只读脚本（check/statistics）→ 可安全跑在已提交的 .db 上
READ_V1 = ["test_check_project_v1.sql", "test_statistics_project_v1.sql"]
READ_V2 = ["test_check&join_project_v2.sql"]
# 建表 + 运维脚本 → 会写数据，只能在临时新库上跑
CREAT_SCRIPTS = ["test_creat_project_v1.sql", "test_creat_project_v2.sql"]


class TestReadScripts(unittest.TestCase):
    """只读查询脚本应在已提交的 .db 上无错执行（不污染数据）。"""

    def _run(self, db_name, scripts):
        conn = sqlite3.connect(str(ROOT / db_name))
        try:
            for name in scripts:
                with self.subTest(db=db_name, script=name):
                    conn.executescript((ROOT / name).read_text(encoding="utf-8"))
        finally:
            conn.close()

    def test_v1_read_scripts(self):
        self._run("project_v1.db", READ_V1)

    def test_v2_read_scripts(self):
        self._run("project_v2.db", READ_V2)


class TestDataPresent(unittest.TestCase):
    def test_labeling_tasks_has_rows(self):
        for db_name in ("project_v1.db", "project_v2.db"):
            conn = sqlite3.connect(str(ROOT / db_name))
            try:
                n = conn.execute("SELECT COUNT(*) FROM labeling_tasks").fetchone()[0]
                self.assertGreater(n, 0, f"{db_name} 的 labeling_tasks 无数据")
            finally:
                conn.close()


class TestCreatOnFreshDb(unittest.TestCase):
    """建表脚本在全新临时库上执行，验证能产出表与数据。"""

    def test_creat_produces_data(self):
        tmp = tempfile.mkdtemp()
        db = os.path.join(tmp, "fresh.db")
        for name in CREAT_SCRIPTS:
            conn = sqlite3.connect(db)
            conn.executescript((ROOT / name).read_text(encoding="utf-8"))
            conn.close()
        conn = sqlite3.connect(db)
        try:
            n = conn.execute("SELECT COUNT(*) FROM labeling_tasks").fetchone()[0]
            self.assertGreater(n, 0, "建表脚本未产出 labeling_tasks 数据")
        finally:
            conn.close()


class TestExpectedValues(unittest.TestCase):
    """期望值断言：验证 SQL 计算正确（不只是能跑）。"""

    def test_supplier_pass_rate(self):
        conn = sqlite3.connect(str(ROOT / "project_v1.db"))
        try:
            rows = {
                r[0]: r[3]
                for r in conn.execute(
                    "SELECT supplier, COUNT(*), "
                    "SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END), "
                    "ROUND(CAST(SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2) || '%' "
                    "FROM labeling_tasks GROUP BY supplier"
                )
            }
        finally:
            conn.close()
        self.assertEqual(rows["A厂"], "60.0%")
        self.assertEqual(rows["B厂"], "40.0%")
        self.assertEqual(rows["C厂"], "50.0%")
        self.assertEqual(rows["D厂"], "0.0%")

    def test_game_progress(self):
        conn = sqlite3.connect(str(ROOT / "project_v1.db"))
        try:
            rows = {
                r[0]: r
                for r in conn.execute(
                    "SELECT game_name, COUNT(*), "
                    "SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END), "
                    "SUM(CASE WHEN status='rejected' THEN 1 ELSE 0 END), "
                    "SUM(CASE WHEN status='waiting_review' THEN 1 ELSE 0 END) "
                    "FROM labeling_tasks GROUP BY game_name"
                )
            }
        finally:
            conn.close()
        self.assertEqual(rows["hogwarts"], ("hogwarts", 5, 3, 1, 1))
        self.assertEqual(rows["dauntless"], ("dauntless", 5, 2, 1, 2))
        self.assertEqual(rows["new_game_01"], ("new_game_01", 2, 1, 0, 1))
        self.assertEqual(rows["new_game_02"], ("new_game_02", 1, 0, 1, 0))


class TestOpsOnFreshDb(unittest.TestCase):
    """运维脚本（UPDATE/DELETE）会写数据，只能跑在临时库上，避免污染已提交的 .db。"""

    def test_ops_script_runs(self):
        tmp = tempfile.mkdtemp()
        db = os.path.join(tmp, "ops.db")
        conn = sqlite3.connect(db)
        try:
            # 先建表（含 supplier_info，供 LEFT JOIN 使用）
            conn.executescript((ROOT / "test_creat_project_v2.sql").read_text(encoding="utf-8"))
            conn.executescript((ROOT / "test_ops_project_v1.sql").read_text(encoding="utf-8"))
            conn.commit()
            n = conn.execute("SELECT COUNT(*) FROM labeling_tasks").fetchone()[0]
            self.assertGreater(n, 0, "运维脚本执行后 labeling_tasks 应为空")
        finally:
            conn.close()


if __name__ == "__main__":
    unittest.main()
