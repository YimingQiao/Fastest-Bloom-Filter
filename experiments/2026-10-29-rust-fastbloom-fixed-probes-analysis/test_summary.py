import importlib.util
import json
from pathlib import Path
import unittest
from summarize import STAGE, quality_records, summarize

spec = importlib.util.spec_from_file_location("fixed_k_synthetic_fixture", STAGE / "calibration/test_calibration.py")
fixture = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fixture)


class Summary(unittest.TestCase):
    def test_diagnostic_integer_keys_follow_json_object_key_contract(self):
        quality = quality_records(fixture.synthetic())
        stored = json.loads(json.dumps(quality))
        self.assertNotEqual(quality, stored)
        self.assertIn("1", stored["diagnostic_K_neighborhoods"][0]["wilson_upper_by_K"])
        self.assertEqual(json.loads(json.dumps(quality)), stored)

    def test_all_fixed_points_and_six_groups_retained(self):
        fixed, groups = summarize(quality_records(fixture.synthetic()))
        self.assertEqual(len(fixed), 72)
        self.assertEqual(len(groups), 6)
        self.assertTrue(all(row["minimum_qualifying_K_0_01pct"] == 1 for row in groups))

    def test_nonmonotonic_quality_is_not_assumed(self):
        rows = fixture.synthetic()
        for row in rows:
            if row["filter"].startswith("Fastbloom017"):
                row["calibration_false_positives"] = "1" if row["filter"] in {"Fastbloom017K3", "Fastbloom017K7"} else row["calibration_absent_queries"]
        fixed, groups = summarize(quality_records(rows))
        self.assertEqual(len(fixed), 72)
        self.assertTrue(all(row["minimum_qualifying_K_0_01pct"] == 3 and row["all_qualifying_K_0_01pct"] == "3|7" for row in groups))

    def test_no_qualifier_remains_explicit(self):
        rows = fixture.synthetic()
        for row in rows: row["calibration_false_positives"] = row["calibration_absent_queries"]
        fixed, groups = summarize(quality_records(rows))
        self.assertEqual(len(fixed), 72)
        self.assertTrue(all(row["minimum_qualifying_K_1pct"] == "none" for row in groups))

    def test_proven_default_alias_is_required(self):
        rows = fixture.synthetic()
        next(row for row in rows if row["filter"] == "Fastbloom017K11" and row["requested_bpk"] == "16")["calibration_false_positives"] = "20"
        with self.assertRaises(ValueError): quality_records(rows)


if __name__ == "__main__": unittest.main()
