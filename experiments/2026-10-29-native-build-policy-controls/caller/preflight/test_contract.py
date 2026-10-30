"""Synthetic row/source guards only; never invoke a compiler or Bloom filter."""
import ast
import copy
import json
import unittest
from pathlib import Path
from contract import HERE, QUERY_N, executed_order, fixtures, input_checksums, parse, reference_check, stats, validate


def row_for(case):
    reference = json.loads((HERE / "references.json").read_text())
    row = next(copy.deepcopy(row) for row in reference["records"]
               if all(row[key] == case[key] for key in ("language", "family", "scenario")))
    row.update(repeats=4, cycles=1, phase_order="four_arm_williams", time_unit="absolute_ns",
               cpus=[2 + 2 * i for i in range(case["requested"])], executed_order=executed_order(case),
               scheduler="caller_worker0" if case["language"] == "cpp" else "scoped_workers_plus_caller_or_serial_fallback")
    row["arms"] = {arm: dict(stats(case, arm), insert_ns=[1, 2, 3, 4],
                       allocate_insert_ns=[] if case["history_n"] else [4, 3, 2, 1],
                       insert_prefill_setup_ns=[1 if case["history_n"] else 0] * 4)
                   for arm in ("A0", "A1", "Clone", "Policy")}
    return row


class ContractTests(unittest.TestCase):
    def test_all_old_fixtures_and_counts(self):
        contracts = 0
        for language in ("cpp", "rust"):
            for case in fixtures(language):
                row = row_for(case)
                validate(row, case, row["cpus"]); reference_check(row)
                contracts += 1 if case["history_n"] else 2
        self.assertEqual(contracts * 4 * 4 * 2, 640)

    def reject(self, mutate, index=0):
        case = fixtures("cpp")[index]; row = row_for(case); mutate(row)
        with self.assertRaises((ValueError, KeyError)):
            validate(row, case, [2, 4, 6, 8])

    def test_schedule(self):
        self.reject(lambda row: row["executed_order"].reverse())
        self.reject(lambda row: row.update(cycles=8, repeats=32))

    def test_arm_vectors_and_ownership(self):
        self.reject(lambda row: row["arms"].pop("Clone"))
        self.reject(lambda row: row["arms"]["A1"]["insert_ns"].pop())
        self.reject(lambda row: row["arms"]["Policy"].update(workers=4))
        self.reject(lambda row: row["arms"]["Clone"].update(scratch_bytes=0))
        self.reject(lambda row: row["arms"]["A0"].update(allocate_insert_ns=[1, 2, 3, 4]), 2)

    def test_invalid_values_and_stream(self):
        self.reject(lambda row: row["arms"]["A0"]["insert_ns"].__setitem__(0, float("nan")))
        self.reject(lambda row: row.update(batch_checksum=row["batch_checksum"] ^ 1))
        self.reject(lambda row: row.update(positives=0))

    def test_duplicate_json(self):
        with self.assertRaises(ValueError): parse('{"a":1,"a":2}')
        with self.assertRaises(ValueError): parse('{"a":NaN}')

    def test_reference_mismatch(self):
        case = fixtures("rust")[1]; row = row_for(case); row["checksum"] ^= 1
        with self.assertRaises(ValueError): reference_check(row)

    def test_entrypoint_static_scope(self):
        tree = ast.parse((HERE / "validate.py").read_text())
        main = next(node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == "main")
        writes = [node for node in ast.walk(main) if isinstance(node, ast.Name) and node.id == "args" and isinstance(node.ctx, ast.Store)]
        self.assertEqual(len(writes), 1, "Do not overwrite the parsed CLI namespace")
        import validate as driver
        lease = {"child_cpus": [2 + 2 * i for i in range(8)], "node": 0}
        command = driver.command(Path("/tmp/does-not-execute"), fixtures("cpp")[0], lease)
        self.assertEqual(command[-1], "--caller-check")
        with self.assertRaises(ValueError): driver.command(Path("unused"), fixtures("cpp")[0], lease, "--measure")


if __name__ == "__main__":
    unittest.main()
