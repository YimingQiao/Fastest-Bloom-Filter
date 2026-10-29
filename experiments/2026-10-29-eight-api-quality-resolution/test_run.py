import copy
import unittest
from run import SEMANTICS, fresh_record, distinct_records, interval


class Tests(unittest.TestCase):
    def fixture(self):
        old = {f: "0" for f in SEMANTICS}
        old.update(filter="fixture", seed="42", keys="65536", filter_bytes="131072",
                   calibration_absent_queries=str(1 << 24), calibration_false_positives="16000")
        total = dict(old, calibration_absent_queries=str(1 << 27), calibration_false_positives="128000")
        return old, total

    def test_suffix_only(self):
        old, total = self.fixture()
        r = fresh_record(old, total, old, {"calibration_identity": "a"})
        self.assertEqual((r["fresh_suffix_fp"], r["fresh_suffix_count"]), (112000, 117440512))
        self.assertEqual(r["fresh_wilson_upper"], interval(112000, 117440512)[1])

    def test_reject_prefix_and_semantic_drift(self):
        old, total = self.fixture()
        for field in (*SEMANTICS, "calibration_false_positives", "calibration_absent_queries"):
            prefix = dict(old)
            prefix[field] += "1"
            with self.assertRaises(ValueError):
                fresh_record(prefix, total, old, {"calibration_identity": "a"})

    def test_reject_invalid_total(self):
        old, total = self.fixture()
        for field, value in (("calibration_absent_queries", "1"), ("calibration_false_positives", "1"),
                             ("calibration_false_positives", str(1 << 29))):
            bad = dict(total)
            bad[field] = value
            with self.assertRaises(ValueError):
                fresh_record(old, bad, old, {"calibration_identity": "a"})

    def test_aliases_not_pooled(self):
        old, total = self.fixture()
        r = fresh_record(old, total, old, {"calibration_identity": "a"})
        alias = dict(r, filter="alias")
        self.assertEqual(distinct_records([r, alias]), 1)
        alias["fresh_suffix_fp"] += 1
        with self.assertRaises(ValueError):
            distinct_records([r, alias])


if __name__ == "__main__":
    unittest.main()
