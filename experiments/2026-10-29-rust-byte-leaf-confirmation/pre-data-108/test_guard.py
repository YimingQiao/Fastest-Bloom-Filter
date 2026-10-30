"""Offline corruption checks using retained semantic-preflight rows, no benchmark runs."""
import copy
import csv
import io
import json
from pathlib import Path
import unittest

from guard import validate_rows

HERE = Path(__file__).resolve().parent


class Guards(unittest.TestCase):
    def setUp(self):
        evidence = json.loads((HERE.parent / "2026-10-29-rust-leaf-inline/validation/preflight-results.json").read_text())
        self.rows = [row for row in csv.DictReader(io.StringIO(evidence["records"][0]["stdout"])) if row["filter"] in {"ByteSplitBloomFilter", "ByteLeafInlineV1", "BloomsdayPinned"}]
        from guard import expected_filter_order
        order = expected_filter_order(42, 1024, 4096, 0, {row["filter"] for row in self.rows})
        self.rows.sort(key=lambda row: order.index(row["filter"]))
        self.registry = json.loads((HERE / "registry.json").read_text())
        self.protocol = json.loads((HERE / "protocol.json").read_text())
        self.protocol.update(query_power=12, repeats=4, hit_percent=0, calibration_power=12)
        # The retained tiny fixture used insert_batch37; model the preregistered full-input setting.
        for row in self.rows:
            row["insert_batch"] = row["keys"]

    def check(self, rows):
        validate_rows(rows, self.registry, self.protocol, (10, 8, 1, 42))

    def test_valid(self):
        self.check(self.rows)

    def test_missing_duplicate_unknown(self):
        variants = [self.rows[:-1], self.rows[:-1] + [self.rows[0]], copy.deepcopy(self.rows)]
        variants[-1][0]["filter"] = "Unknown"
        for rows in variants:
            with self.assertRaises(ValueError):
                self.check(rows)

    def test_wrong_owner(self):
        self.registry["ByteLeafInlineV1"]["owner"] = "external"
        with self.assertRaises(ValueError):
            self.check(self.rows)

    def test_wrong_workload_bytes_or_quality(self):
        for key, value in (("batch", "31"), ("filter_bytes", "1"), ("actual_bpk", "8"),
                           ("seed", "43"), ("calibration_false_positives", "4097"),
                           ("input_mode", "raw"), ("insert_batch", "37")):
            rows = copy.deepcopy(self.rows)
            rows[0][key] = value
            with self.assertRaises(ValueError):
                self.check(rows)

    def test_nonfinite_or_wrong_median(self):
        for key, value in (("inline_lookup_ns", "nan"), ("inline_hash_lookup_min_ns", "0"),
                           ("lookup_trials", "1|2|3|4")):
            rows = copy.deepcopy(self.rows)
            rows[0][key] = value
            with self.assertRaises(AssertionError):
                self.check(rows)

    def test_unbalanced_phase(self):
        rows = copy.deepcopy(self.rows)
        rows[0]["query_phase_order"] = "0|1|2|3;0|1|2|3;0|1|2|3;0|1|2|3"
        with self.assertRaises(AssertionError):
            self.check(rows)

    def test_balanced_but_wrong_seed_order(self):
        from guard import validate_row
        rows = copy.deepcopy(self.rows)
        original = rows[0]["query_phase_order"]
        # Rotating the four labels preserves every balance count, but violates seed42.
        rows[0]["query_phase_order"] = ";".join(
            "|".join(str((int(value) + 1) % 4) for value in order.split("|"))
            for order in original.split(";")
        )
        self.assertNotEqual(rows[0]["query_phase_order"], original)
        with self.assertRaises(AssertionError):
            self.check(rows)
        # The preserved original producer rows all satisfy the independent seed oracle.
        for row in self.rows:
            validate_row(row)

    def test_candidate_output_mismatch(self):
        rows = copy.deepcopy(self.rows)
        row = next(row for row in rows if row["filter"] == "ByteLeafInlineV1")
        row["result_checksum"] = str(int(row["result_checksum"]) ^ 1)
        with self.assertRaises(ValueError):
            self.check(rows)

    def test_native_regression_registry_and_count(self):
        from guard import CONTROLS, expected_names, workloads
        self.assertEqual(expected_names(31), set(CONTROLS) | set(CONTROLS.values()))
        protocol = json.loads((HERE / "protocol.json").read_text())
        self.assertEqual(len(workloads(protocol)), 48)
        self.assertEqual(sum(len(expected_names(batch)) for _, _, batch, _ in workloads(protocol)), 108)
        with self.assertRaises(ValueError):
            validate_rows(self.rows, self.registry, self.protocol, (10, 8, 31, 42))

    def test_invalid_build_time(self):
        rows = copy.deepcopy(self.rows)
        rows[0]["allocate_insert_ns"] = "0"
        with self.assertRaises(ValueError):
            self.check(rows)


    def test_filter_row_order_matches_all_initial_frozen_rows(self):
        from guard import expected_filter_order
        rows = list(csv.DictReader(io.StringIO((HERE.parent/'2026-10-29-rust-leaf-inline/screen/results.csv').read_text())))
        groups = {}
        for row in rows:
            key = tuple(int(row[k]) for k in ('keys','queries','hit_percent','seed','batch','requested_bpk'))
            groups.setdefault(key,[]).append(row['filter'])
        self.assertEqual(len(groups),16)
        for (n,q,hit,seed,_,_), names in groups.items():
            self.assertEqual(names,expected_filter_order(seed,n,q,hit,set(names)))

    def test_filter_row_order_corruption(self):
        with self.assertRaises(ValueError):self.check(self.rows[::-1])

if __name__ == "__main__":
    unittest.main()
