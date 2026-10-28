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
        evidence = json.loads((HERE / "validation/v0-preflight-results.json").read_text())
        self.rows = list(csv.DictReader(io.StringIO(evidence["records"][0]["stdout"])))
        self.registry = json.loads((HERE / "registry.json").read_text())
        self.protocol = json.loads((HERE / "protocol.json").read_text())
        self.protocol.update(query_power=12, repeats=4, hit_percent=0, calibration_power=12)
        # The retained tiny fixture used insert_batch37; model the preregistered full-input setting.
        for row in self.rows:
            row["insert_batch"] = row["keys"]

    def check(self, rows):
        validate_rows(rows, self.registry, self.protocol, (10, 8, 42))

    def test_valid(self):
        self.check(self.rows)

    def test_missing_duplicate_unknown(self):
        variants = [self.rows[:-1], self.rows[:-1] + [self.rows[0]], copy.deepcopy(self.rows)]
        variants[-1][0]["filter"] = "Unknown"
        for rows in variants:
            with self.assertRaises(ValueError):
                self.check(rows)

    def test_wrong_owner(self):
        self.registry["ByteSplitBloomFilter"]["owner"] = "external"
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
        from check_preflight import validate_row
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

    def test_invalid_build_time(self):
        rows = copy.deepcopy(self.rows)
        rows[0]["allocate_insert_ns"] = "0"
        with self.assertRaises(ValueError):
            self.check(rows)


if __name__ == "__main__":
    unittest.main()
