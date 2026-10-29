"""Synthetic comparison tests; never invoke a benchmark or read fresh timings."""
import copy
import importlib.util
from pathlib import Path
import tempfile
import unittest

import summarize as s

spec = importlib.util.spec_from_file_location("multiply144_frozen_fixture", s.STAGE / "driver/test_contract.py")
fixture = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fixture)


class AnalysisTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.p, cls.reg, cls.rows = fixture.fixture()
        cls.q = fixture.c.validate_matrix(cls.rows, cls.p, cls.reg)

    def data(self):
        return copy.deepcopy(self.rows), copy.deepcopy(self.q)

    def test_complete_counts_and_exact_ties(self):
        result = s.compare(self.rows, self.q, self.p)
        self.assertEqual([len(result[k]) for k in ("pairs", "alternatives", "views", "pair_summaries", "order_summaries", "view_summaries")],
                         [252, 864, 324, 42, 84, 54])
        self.assertTrue(all(r["outcome"] == "tie" for r in result["pairs"]))
        view = next(r for r in result["views"] if r["policy"] == "main_all_fresh" and r["rival_class"] == "all_rivals")
        self.assertEqual(len(view["rival_leaders"]), 7)
        self.assertIn(s.FOUR, view["rival_leaders"])

    def test_four_leads_main_and_is_restricted_only_secondarily(self):
        rows, q = self.data()
        for row in rows:
            if row["filter"] == s.FOUR:
                row["lookup_ns"] = "1"
        result = s.compare(rows, q, self.p)
        for view in result["views"]:
            if view["metric"] == "lookup_ns" and view["rival_class"] == "all_rivals":
                if view["policy"] == "secondary_preregistered_restricted":
                    self.assertNotIn(s.FOUR, view["rival_leaders"])
                else:
                    self.assertEqual(view["rival_leaders"], [s.FOUR])
                    self.assertEqual(view["outcome"], "loss")

    def test_one_failed_seed_removes_main_but_retains_current_views(self):
        rows, q = self.data()
        gate = next(r for r in q["across_seed_gate"] if r["filter"] == s.MUL)
        gate.update(all_fresh_seeds_pass=False, main_competitive_eligible=False, robust_eligible=False)
        next(r for r in q["api_seed_records"] if r["filter"] == s.MUL and r["seed"] == self.p["seeds"][0])["current_pass"] = False
        result = s.compare(rows, q, self.p)
        self.assertTrue(all(not r["eligible_comparison"] for r in result["views"] if r["policy"] == "main_all_fresh"))
        summaries = [r for r in result["view_summaries"] if r["policy"] == "descriptive_current_seed"]
        self.assertTrue(all(r["eligible_observations"] == 5 for r in summaries))
        self.assertEqual(len(result["pairs"]), 252)

    def test_external_project_ownership_not_mixed(self):
        result = s.compare(self.rows, self.q, self.p)
        for view in result["views"]:
            if view["rival_class"] == "external":
                self.assertTrue(all(s.owner(name) == "external" for name in view["rival_leaders"]))
            elif view["rival_class"] == "retained_project":
                self.assertTrue(all(s.owner(name) != "external" and name != s.MUL for name in view["rival_leaders"]))

    def test_all_modes_and_order_strata_remain_separate(self):
        result = s.compare(self.rows, self.q, self.p)
        self.assertEqual({r["metric"] for r in result["pairs"]}, set(s.METRICS))
        self.assertEqual({r["batch"] for r in result["pairs"]}, {1, 31, 4096})
        self.assertTrue(all(r["observations"] == 3 for r in result["order_summaries"]))
        self.assertEqual({r["order_stratum"] for r in result["order_summaries"]}, {"multiply_first", "multiply_last"})

    def test_bad_ownership_rejected(self):
        with self.assertRaises(ValueError):
            s.owner("NativePosingAsExternal")

    def test_policy_relabelling_rejected(self):
        _, q = self.data()
        next(r for r in q["across_seed_gate"] if r["filter"] == s.FOUR)["main_competitive_eligible"] = False
        with self.assertRaises(ValueError):
            s.compare(self.rows, q, self.p)

    def test_incomplete_rows_rejected(self):
        with self.assertRaises(ValueError):
            s.compare(self.rows[:-1], self.q, self.p)

    def test_heterogeneous_ineligible_summary_csv(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "summary.csv"
            s.save_csv(path, [dict(eligible=0), dict(eligible=6, geometric_mean=1.2)])
            self.assertEqual(path.read_text().splitlines()[0], "eligible,geometric_mean")

    def test_descriptive_summary_retains_losses_and_exact_ties(self):
        summary = s.summarize_ratios([.5, 1, 2])
        self.assertEqual((summary["wins"], summary["losses"], summary["ties"]), (1, 1, 1))
        self.assertEqual(summary["geometric_mean"], 1)
        for values in ([], [0], [float("nan")]):
            with self.assertRaises(ValueError):
                s.summarize_ratios(values)


if __name__ == "__main__":
    unittest.main()
