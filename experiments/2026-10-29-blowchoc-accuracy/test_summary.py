"""Regression guards for complete, provenance-preserving accuracy reports."""
import copy
import json
from pathlib import Path
import unittest

from summarize import validated_rows

HERE = Path(__file__).resolve().parent


class SummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.protocol = json.loads((HERE / "protocol.json").read_text())
        cls.results = json.loads((HERE / "results/results.json").read_text())

    def reject_mutation(self, mutate):
        results = copy.deepcopy(self.results)
        mutate(results)
        with self.assertRaises(ValueError):
            validated_rows(self.protocol, results)

    def test_complete_fixed_matrix(self):
        self.assertEqual(len(validated_rows(self.protocol, self.results)), 48)

    def test_duplicate_configuration_rejected(self):
        self.reject_mutation(lambda r: r["records"].__setitem__(1, copy.deepcopy(r["records"][0])))

    def test_duplicate_oracle_preflight_rejected(self):
        self.reject_mutation(lambda r: r["preflights"].__setitem__(1, copy.deepcopy(r["preflights"][0])))

    def test_calibration_stream_mismatch_rejected(self):
        self.reject_mutation(lambda r: r["records"][0].__setitem__("calibration_raw_interval", [0, 1 << 24]))

    def test_pooled_or_doubled_samples_rejected(self):
        self.reject_mutation(lambda r: r["records"][0].__setitem__("calibration_absent_queries", 1 << 25))

    def test_backing_slack_omission_rejected(self):
        self.reject_mutation(lambda r: next(row for row in r["records"] if row["filter"].startswith("BlowChoc")).__setitem__("filter_bytes", 1))

    def test_hash_seed_change_rejected(self):
        def change(results):
            row = next(row for row in results["records"] if row["filter"].startswith("BlowChoc"))
            row["spec"]["construction_seed"] += 1
        self.reject_mutation(change)

    def test_speed_samples_rejected(self):
        self.reject_mutation(lambda r: r["records"][0]["query_trials"].append({"query_ns": 1}))


if __name__ == "__main__":
    unittest.main()
