import copy
import csv
import io
import json
from pathlib import Path
import subprocess
import sys
import unittest
from quality import STAGE, quality_records, wilson
from run import PARENT_CSV, retained_controls


def synthetic():
    rows = []
    for case in json.loads((STAGE / "proposal.json").read_text())["cases"]:
        n, cap = 1 << case["key_power"], case["budget_bpk"]
        for name in case["filters"]:
            rows.append(dict(filter=name, keys=str(n), requested_bpk=str(cap), actual_bpk=str(cap),
                filter_bytes=str(n * cap // 8), seed="42", calibration_absent_queries=str(1 << 24),
                calibration_false_positives="10"))
    return rows


class Calibration(unittest.TestCase):
    def test_exact112_to110_only_proven_aliases(self):
        result = quality_records(synthetic())
        self.assertEqual(len(result["api_records"]), 112)
        self.assertEqual(len(result["mapping_records"]), 110)
        aliases = [r for r in result["mapping_records"] if len(r["api_labels"]) == 2]
        self.assertEqual(len(aliases), 2)
        self.assertTrue(all(set(r["api_labels"]) == {"Fastbloom017", "Fastbloom017K11"} and r["budget_bpk"] == 16 for r in aliases))
        for name in ["SbbfSafePinned", "BloomsdayPinned"]:
            self.assertEqual(sum(r["mapping"] == name for r in result["mapping_records"]), 6)

    def test_missing_or_duplicate_fixed_k_is_rejected(self):
        rows = synthetic()
        for changed in [rows[:-1], rows[:-1] + [rows[0]]]:
            with self.assertRaises(ValueError): quality_records(changed)

    def test_known_alias_count_mismatch_rejected(self):
        rows = synthetic()
        next(r for r in rows if r["filter"] == "Fastbloom017K11" and r["requested_bpk"] == "16")["calibration_false_positives"] = "11"
        with self.assertRaises(ValueError): quality_records(rows)

    def test_failed_quality_points_remain(self):
        rows = synthetic()
        for row in rows: row["calibration_false_positives"] = row["calibration_absent_queries"]
        result = quality_records(rows)
        self.assertEqual(len(result["api_records"]), 112)
        self.assertTrue(all(not r["pass_1pct"] for r in result["api_records"]))
        self.assertTrue(all(not r["selected_fixed_K"] for r in result["diagnostic_K_neighborhoods"]))

    def test_retained_all40_semantics_and_changed_checksum(self):
        rows = [row for row in csv.DictReader(io.StringIO(PARENT_CSV.read_text())) if row["batch"] == "4096"]
        self.assertEqual(retained_controls(rows), 40)
        rows[0]["result_checksum"] = str(int(rows[0]["result_checksum"]) ^ 1)
        with self.assertRaises(ValueError): retained_controls(rows)

    def test_mathematical_wilson_endpoints(self):
        self.assertEqual(wilson(0, 100)[0], 0.0)
        self.assertEqual(wilson(100, 100)[1], 1.0)

    def test_python_O_stops_before_any_filter(self):
        result = subprocess.run([sys.executable, "-O", str(Path(__file__).with_name("run.py"))], capture_output=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(result.stdout)
        self.assertIn(b"Use Python without -O", result.stderr)


if __name__ == "__main__": unittest.main()
