"""Synthetic vectors only; no measured results or BF execution."""
import copy
import unittest
import summarize as s
from test_contract import row as synthetic


class Summary(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows = [synthetic(case) for case in s.PLAN.ledger()]

    def test_counts_and_no_unavailable_contract(self):
        result = s.calculate(self.rows)
        self.assertEqual(len(result["pairs"]), 160)
        self.assertEqual(len(result["serial"]), 320)
        self.assertEqual(len(result["ranges"]), 80)
        self.assertFalse(any(p["history_n"] and p["contract"] == "allocate_insert" for p in result["pairs"]))

    def test_pair_direction_and_serial_overhead(self):
        rows = copy.deepcopy(self.rows)
        rows[0]["arms"]["control"]["insert_ns"] = [200] * 4
        rows[0]["arms"]["candidate"]["insert_ns"] = [100] * 4
        rows[0]["arms"]["serial"]["insert_ns"] = [50] * 4
        result = s.calculate(rows)
        pair = result["pairs"][0]
        self.assertEqual(pair["control_over_candidate_speedup"], 2)
        self.assertEqual(pair["outcome"], "candidate_faster")
        overhead = next(p for p in result["serial"] if p["case_index"] == 0 and p["contract"] == "insert" and p["arm"] == "candidate")
        self.assertEqual(overhead["arm_over_serial_latency"], 2)
        self.assertEqual(overhead["outcome"], "slower_than_serial")

    def test_all_losses_and_ties_kept(self):
        rows = copy.deepcopy(self.rows)
        rows[0]["arms"]["candidate"]["insert_ns"] = [1000] * 4
        result = s.calculate(rows)
        self.assertEqual(result["pairs"][0]["outcome"], "candidate_slower")
        self.assertTrue(any(p["kind"] == "candidate_control" and p["case_index"] == 0 for p in result["losses"]))
        self.assertEqual(result["pairs"][1]["outcome"], "tie")

    def test_no_cross_scenario_language_or_request_pool(self):
        result = s.calculate(self.rows)
        keys = [(r["language"], r["family"], r["scenario"], r["requested"], r["contract"]) for r in result["ranges"]]
        self.assertEqual(len(set(keys)), 80)
        self.assertTrue(all(len(r["seed_results"]) == 2 for r in result["ranges"]))

    def test_no_zero_setup_claim(self):
        result = s.calculate(self.rows)
        self.assertTrue(all(r["median_ns_per_old_hash"] is None for r in result["setup"] if not r["measured_setup"]))


if __name__ == "__main__": unittest.main()
