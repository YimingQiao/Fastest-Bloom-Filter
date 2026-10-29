"""Synthetic analysis checks; do not execute a BF or read training timings."""
import copy
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import summarize as s

spec = importlib.util.spec_from_file_location("range120_frozen_fixture", s.STAGE / "screening/test_guard.py")
fixture = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fixture)


class AnalysisTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows = fixture.mock_rows()
        cls.q = s.quality(cls.rows)

    def test_query_and_build_full_counts(self):
        for metrics in (s.QUERY, s.BUILD):
            result = s.rank(self.rows, self.q, metrics)
            self.assertEqual([len(result[k]) for k in ("views", "alternatives", "range_alternatives")], [216, 4320, 648])

    def test_quality_keeps40_families_even_identical_counts(self):
        self.assertEqual(len(self.q), 40)
        self.assertTrue(all(r["negatives"] == 1 << 24 and r["cross_family_alias_assumed"] is False for r in self.q))

    def test_cap32_admits_every_smaller_allocation(self):
        result = s.rank(self.rows, self.q, s.QUERY)
        for view in result["views"]:
            self.assertEqual(view["feasible_allocations"], {16: 8, 24: 12, 32: 20}[view["cap_bpk"]])
            self.assertEqual(len(view["native_experimental_leaders"]), {16: 1, 24: 2, 32: 3}[view["cap_bpk"]])

    def test_same_owner_distinct_allocations_ties_preserved(self):
        result = s.rank(self.rows, self.q, s.QUERY)
        view = next(r for r in result["views"] if r["cap_bpk"] == 32)
        self.assertEqual(len(view["external_leaders"]), 9)
        self.assertEqual(len(view["production_native_leaders"]), 8)
        self.assertEqual(len(view["overall_leaders"]), 20)
        self.assertEqual(view["range_vs_external_outcome"], "tie")

    def test_modes_choose_allocations_independently(self):
        rows = copy.deepcopy(self.rows)
        for row in rows:
            if row["filter"] == s.RANGE:
                row["lookup_ns"] = {"16": "1", "24": "2", "32": "3"}[row["actual_bpk"]]
                row["inline_lookup_ns"] = {"16": "3", "24": "2", "32": "1"}[row["actual_bpk"]]
        result = s.rank(rows, self.q, s.QUERY)
        for view in result["views"]:
            if view["cap_bpk"] == 32 and view["metric"] in ("lookup_ns", "inline_lookup_ns"):
                self.assertEqual(view["native_experimental_leaders"][0]["actual_bpk"],
                                 16 if view["metric"] == "lookup_ns" else 32)

    def test_ineligible_fast_row_retained_but_never_leads(self):
        rows, q = copy.deepcopy(self.rows), copy.deepcopy(self.q)
        for record in q:
            if record["filter"] == s.RANGE:
                record["wilson95_high"] = .02
        for row in rows:
            if row["filter"] == s.RANGE:
                row["lookup_ns"] = ".01"
        result = s.rank(rows, q, s.QUERY)
        self.assertEqual(len(result["range_alternatives"]), 648)
        self.assertTrue(all(not r["eligible"] for r in result["range_alternatives"]))
        self.assertTrue(all(r["range_vs_external_outcome"] == "ineligible_or_missing" for r in result["views"]))

    def test_history_does_not_exclude_current_four(self):
        rows = copy.deepcopy(self.rows)
        for row in rows:
            if row["filter"] == "FourSectorBloomFilter":
                row["lookup_ns"] = ".1"
        result = s.rank(rows, self.q, s.QUERY)
        for view in result["views"]:
            if view["metric"] == "lookup_ns":
                self.assertTrue(all(r["filter"] == "FourSectorBloomFilter" for r in view["overall_leaders"]))

    def test_api_and_same_allocation_controls_preserve_counts(self):
        self.assertEqual(len(s.same_allocation_controls(self.rows)), 96)
        self.assertEqual(len(s.api_ratios(self.rows)), 240)
        self.assertTrue(all(not r["identical_hash_mapping_assumed"] for r in s.same_allocation_controls(self.rows)))

    def test_cross_batch_corruption_rejected(self):
        rows = copy.deepcopy(self.rows)
        rows[8]["calibration_false_positives"] = "123"
        with self.assertRaises(ValueError):
            s.quality(rows)

    def test_ownership_corruption_rejected(self):
        row = dict(next(r for r in self.rows if r["filter"] == s.RANGE))
        row["implementation_origin"] = "external"
        with self.assertRaises(ValueError):
            s.owner(row)

    def test_wilson_endpoints_and_counts(self):
        self.assertEqual(s.wilson(0, 100)[0], 0)
        self.assertEqual(s.wilson(100, 100)[1], 1)
        with self.assertRaises(ValueError):
            s.wilson(101, 100)

    def test_prior_context_tuples_bound_to_actual_sources(self):
        context = s.prior_quality()
        self.assertEqual(len(context["records"]), 14)
        context["records"][0]["seed"] += 1
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            (path / "prior-quality.json").write_text(json.dumps(context))
            with patch.object(s, "HERE", path), self.assertRaisesRegex(ValueError, "tuples"):
                s.prior_quality()


if __name__ == "__main__":
    unittest.main()
