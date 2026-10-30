"""Offline malformed-fixture guards; no Bloom executable or incomplete data loaded."""
import copy
import json
from pathlib import Path
import subprocess
import sys
import unittest

from checks import NAMES, NATIVE, RANGE, validate_dense


def fixtures():
    current = []
    for name in sorted(NAMES):
        for n in (64, 1024, 65536):
            for cap in (16, 24, 32):
                actual = 16 if name in NATIVE and cap == 24 else cap
                current.append(dict(filter=name, keys=n, budget_bpk=cap, filter_bytes=n*actual//8,
                                    inserted_checked=n, insert_fingerprint=1, query_fingerprint=2,
                                    calibration_fingerprint=3, mixed_fp=0, calibration_fp=0,
                                    outputs=[int(i % 4 == 0) for i in range(4097)], calibration_outputs=[0]*4096))
    reference = [copy.deepcopy(r) for r in current if r["filter"] != RANGE and r["budget_bpk"] != 24]
    return current, reference


class Checks(unittest.TestCase):
    def test_complete_full_output_count(self):
        result = validate_dense(*fixtures())
        self.assertEqual(result["full_compared_answers"], 42 * 8193)

    def test_missing_new_twenty_four_api_rejected(self):
        current, old = fixtures()
        current.pop(next(i for i, r in enumerate(current) if r["filter"] == RANGE and r["budget_bpk"] == 24))
        with self.assertRaisesRegex(ValueError, "Incomplete"):
            validate_dense(current, old)

    def test_duplicate_reference_rejected(self):
        current, old = fixtures()
        old.append(old[0])
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            validate_dense(current, old)

    def test_one_unclaimed_negative_output_change_rejected(self):
        current, old = fixtures()
        current[0]["outputs"][4095] = 1
        current[0]["mixed_fp"] += 1
        with self.assertRaisesRegex(ValueError, "Complete old/current"):
            validate_dense(current, old)

    def test_wrong_allocation_rejected(self):
        current, old = fixtures()
        current[0]["filter_bytes"] += 64
        with self.assertRaisesRegex(ValueError, "geometry"):
            validate_dense(current, old)

    def test_original_source_anchor(self):
        here = Path(__file__).resolve().parent
        manifest = json.loads((here.parent / "manifest.json").read_text())
        self.assertEqual(len(manifest["files"]), 36)

    def test_optimized_mode_rejected_before_lease_or_compilation(self):
        script = Path(__file__).with_name("validate.py")
        result = subprocess.run([sys.executable, "-O", str(script)], capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("without Python -O", result.stderr)


if __name__ == "__main__":
    unittest.main()
