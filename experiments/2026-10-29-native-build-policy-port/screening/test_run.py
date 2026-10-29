"""Synthetic complete archives only; never invoke a filter or compiler."""
import copy
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from screen_contract import PLAN, audit, command, csv_text, original, sha, tables
from test_contract import row as synthetic_row
from freeze import ENVIRONMENT, validate_placement

LEASE = dict(cpu=2, socket=0, node=0, lock_path="/tmp/fastest-bf-socket0.lock",
             environment={}, inherited_lock_descriptors=[3], child_cpus=list(range(2, 17, 2)),
             topology=[dict(cpu=cpu, socket=0, nodes=[0], core=i) for i, cpu in enumerate(range(2, 17, 2))])
BINARIES = {language: dict(path="/frozen/" + language, sha256=language) for language in ("cpp", "rust")}


class Runner(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(); self.addCleanup(temp.cleanup)
        self.output = Path(temp.name)
        self.rows = []
        self.meta = dict(complete=True, cases=[])
        for i, case in enumerate(PLAN.ledger()):
            row = synthetic_row(case); row["cpus"] = LEASE["child_cpus"][:case["requested"]]
            self.rows.append(row)
            stdout, stderr = f"case-{i:03d}.stdout", f"case-{i:03d}.stderr"
            (self.output / stdout).write_text(json.dumps(row) + "\n"); (self.output / stderr).write_text("")
            self.meta["cases"].append(dict(case=case, complete=True, returncode=0,
                command=command(BINARIES[case["language"]]["path"], case, LEASE), stdout=stdout, stderr=stderr,
                stdout_sha256=sha(self.output / stdout), stderr_sha256=sha(self.output / stderr)))
        self.meta["counts"] = original.audit(self.rows, {t: LEASE["child_cpus"][:t] for t in (4, 8)})
        variants, serials = tables(self.rows)
        (self.output / "variant-results.csv").write_text(csv_text(variants))
        (self.output / "serial-reference.csv").write_text(csv_text(serials))
        (self.output / "paired-records.json").write_text(json.dumps(self.rows))
        (self.output / "metadata.json").write_text(json.dumps(self.meta))

    def check(self): return audit(self.output, self.meta, BINARIES, LEASE)

    def test_complete_and_serial_not_duplicated(self):
        self.assertEqual(self.check()[1]["variant_rows"], 192)
        variants, serials = tables(self.rows)
        self.assertEqual(len(serials), 96)
        self.assertNotIn("serial_insert_ns", variants[0])
        self.assertEqual(variants[0]["serial_reference_case_index"], variants[1]["serial_reference_case_index"])

    def test_case_list_collision_and_partial(self):
        self.meta["cases"] = 96
        with self.assertRaises(ValueError): self.check()
        self.meta["cases"] = []
        with self.assertRaises(ValueError): self.check()

    def test_command_or_returncode(self):
        old = copy.deepcopy(self.meta["cases"][0])
        self.meta["cases"][0]["command"][-3] = "42"
        with self.assertRaises(ValueError): self.check()
        self.meta["cases"][0] = old; self.meta["cases"][0]["returncode"] = 1
        with self.assertRaises(ValueError): self.check()

    def test_raw_and_aggregate_corruption(self):
        path = self.output / "case-000.stdout"; text = path.read_text(); path.write_text(text + " ")
        with self.assertRaises(ValueError): self.check()
        path.write_text(text)
        (self.output / "serial-reference.csv").write_text("corrupted")
        with self.assertRaises(ValueError): self.check()

    def test_duplicate_json_fields(self):
        from screen_contract import parse
        with self.assertRaises(ValueError): parse('{"arms": {}, "arms": {}}')

    def test_archived_placement(self):
        good = dict(lease=LEASE, affinity=[2], host={}, environment={x: None for x in ENVIRONMENT}, inherited_write_verified=True)
        validate_placement(good)
        for mutate in (lambda x: x.update(inherited_write_verified=False), lambda x: x.update(affinity=[3]),
                       lambda x: x["lease"].update(child_cpus=[2]), lambda x: x["environment"].update(LD_PRELOAD="bad"),
                       lambda x: x["lease"]["topology"][0].update(nodes=[1])):
            changed = copy.deepcopy(good); mutate(changed)
            with self.assertRaises(ValueError): validate_placement(changed)

    def test_optimized_python_rejected_before_execution(self):
        result = subprocess.run([sys.executable, "-O", str(Path(__file__).parent / "run.py"), "--help"], capture_output=True)
        self.assertNotEqual(result.returncode, 0); self.assertFalse(result.stdout)
        self.assertIn(b"before execution", result.stderr)


if __name__ == "__main__": unittest.main()
