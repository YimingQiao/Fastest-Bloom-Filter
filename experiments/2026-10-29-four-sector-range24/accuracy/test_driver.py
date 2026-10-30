import copy
import csv
import unittest
from driver import PRIOR, validate


class Tests(unittest.TestCase):
    def setUp(self):
        with (PRIOR / "accuracy/results.csv").open() as stream:
            self.old = list(csv.DictReader(stream))
        self.rows = []
        for row in self.old:
            if row["filter"] == "Split64Range" and int(row["actual_bpk"]) in (16, 24, 32):
                self.rows.extend([dict(row), dict(row, filter="FourSectorRange24")])

    def test_complete_fixed_grid(self):
        self.assertEqual(len(validate(self.rows, self.old)), 12)

    def test_incomplete_duplicate_reordered(self):
        for rows in (self.rows[:-1], self.rows + [self.rows[0]], self.rows[::-1]):
            with self.assertRaises(ValueError):
                validate(rows, self.old)

    def test_control_reproduction_is_required(self):
        rows = copy.deepcopy(self.rows)
        rows[0]["checksum"] = str(int(rows[0]["checksum"]) ^ 1)
        with self.assertRaises(ValueError):
            validate(rows, self.old)

    def test_new_candidate_counts_and_budget_are_checked(self):
        for field, value in (("false_positives", "-1"), ("false_positives", str(1 << 25)),
                             ("filter_bytes", "1"), ("calibration_negatives", "1"), ("seed", "43")):
            rows = copy.deepcopy(self.rows)
            rows[1][field] = value
            with self.assertRaises(ValueError):
                validate(rows, self.old)


if __name__ == "__main__":
    unittest.main()
