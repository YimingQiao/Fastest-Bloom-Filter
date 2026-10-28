"""Offline selection and provenance regressions; no benchmark execution."""
import copy
import subprocess
import sys
import unittest
from pathlib import Path

from summarize import BEFORE, CANDIDATE, BYTE, controlled_groups, eligible, fastest, outcome, quality_records, rankings, ratios, wilson

METRICS = ["lookup_ns", "hash_lookup_ns", "inline_lookup_ns", "inline_hash_lookup_ns"]
REGISTRY = {
    CANDIDATE: dict(owner="native_experimental", original=CANDIDATE),
    BYTE: dict(owner="native_experimental", original="ByteSplitBloomFilter"),
    "ByteSplitBloomFilter": dict(owner="native", original="ByteSplitBloomFilter"),
    "External": dict(owner="external", original="External"),
}


def row(name, actual=16, fp=100, times=(4, 4, 4, 4), batch=1):
    result = dict(filter=name, keys="1024", requested_bpk=str(actual // 2), actual_bpk=str(actual),
                  filter_bytes=str(1024 * actual // 8), batch=str(batch), seed="42",
                  calibration_absent_queries=str(1 << 24), calibration_false_positives=str(fp))
    for metric, value in zip(METRICS, times):
        result.update({metric: str(value), metric[:-3] + "_min_ns": str(value * .9), metric[:-3] + "_max_ns": str(value * 1.1)})
        result[metric[:-3] + "_trials"] = "|".join([str(value)] * 4)
    return result


def protocol():
    return dict(seeds=[42], key_powers=[10], batches=[1], ranking=dict(metrics=METRICS, memory_caps_bpk=[32], fpr_ceilings=[.0001]))


class SummaryTests(unittest.TestCase):
    def test_shortcut_alias_dedup_and_every_pair_loss_retained(self):
        reg = copy.deepcopy(REGISTRY)
        reg[BEFORE] = dict(owner="native_experimental", original=BEFORE)
        reg[CANDIDATE]["original"] = BEFORE
        before = row(BEFORE, times=(2, 2, 2, 2))
        after = row(CANDIDATE, times=(4, 1, 2, 3))
        self.assertEqual(len(quality_records([before, after], reg)), 1)
        pairs, api = ratios([before, after], reg, protocol())
        self.assertEqual((len(pairs), len(api)), (4, 4))
        self.assertEqual([r["outcome"] for r in pairs], ["rival_faster", "candidate_faster", "exact_tie", "rival_faster"])
        self.assertEqual(pairs[0]["candidate_min_ns"], 3.6)
        self.assertEqual(pairs[0]["original_trials"], "2|2|2|2")
        self.assertTrue(all(not r["candidate_first"] for r in pairs))
        self.assertEqual(sum(r["original_faster"] for r in controlled_groups(pairs)), 2)
        after["calibration_false_positives"] = "101"
        with self.assertRaises(ValueError):
            quality_records([before, after], reg)

    def test_smaller_allocations_compete_under_larger_cap(self):
        rows = [row(CANDIDATE, 32, times=(2, 2, 2, 2)), row("External", 16, times=(1, 1, 1, 1)), row("External", 32, times=(3, 3, 3, 3))]
        ranked, individual = rankings(rows, REGISTRY, protocol())
        self.assertTrue(all(r["external"]["actual_bpk"] == 16 for r in ranked))
        self.assertTrue(all(r["external_over_independent32"] == .5 for r in ranked))
        self.assertTrue(all(r["outcome"] == "rival_faster" for r in individual))

    def test_each_contract_selects_its_own_rival(self):
        rows = [row(CANDIDATE, 32), row("External", 16, times=(1, 9, 2, 8)), row("External", 32, times=(9, 1, 8, 2))]
        ranked, _ = rankings(rows, REGISTRY, protocol())
        self.assertEqual([r["external"]["actual_bpk"] for r in ranked], [16, 32, 16, 32])

    def test_quality_gate_uses_upper_bound_and_backing_bytes(self):
        r = row(CANDIDATE)
        point = int(r["calibration_false_positives"]) / int(r["calibration_absent_queries"])
        self.assertFalse(eligible(r, 32, point))
        self.assertTrue(eligible(r, 32, .0001))
        r["filter_bytes"] = str(4097)
        self.assertFalse(eligible(r, 32, .0001))

    def test_clone_and_batch_quality_is_not_pooled(self):
        rows = [row("ByteSplitBloomFilter"), row(BYTE), row(BYTE, batch=31), row(CANDIDATE), row(CANDIDATE, batch=31)]
        result = quality_records(rows, REGISTRY)
        self.assertEqual(len(result), 2)
        self.assertEqual({r["calibration_negatives"] for r in result}, {1 << 24})
        self.assertEqual(next(r for r in result if r["calibration_family"] == "ByteSplitBloomFilter")["aliases"], "ByteLeafInlineV1|ByteSplitBloomFilter")

    def test_disagreeing_clone_or_batch_quality_rejected(self):
        rows = [row("ByteSplitBloomFilter"), row(BYTE)]
        rows[-1]["calibration_false_positives"] = "101"
        with self.assertRaisesRegex(ValueError, "stream disagrees"):
            quality_records(rows, REGISTRY)

    def test_distinct_seed_or_public_family_has_separate_confidence(self):
        r = row(CANDIDATE)
        second = copy.deepcopy(r)
        second["seed"] = "43"
        quality = quality_records([r, second, row("External")], REGISTRY)
        self.assertEqual(len(quality), 3)
        self.assertTrue(all(q["calibration_negatives"] == 1 << 24 for q in quality))

    def test_ineligible_candidate_retained_and_not_compared(self):
        ranked, individual = rankings([row(CANDIDATE, fp=10000), row("External")], REGISTRY, protocol())
        self.assertTrue(all(r["independent32"] is None and r["external_over_independent32"] is None for r in ranked))
        self.assertEqual(len(individual), 4)
        self.assertTrue(all(not r["eligible"] and r["outcome"] == "no_eligible_pair" for r in individual))

    def test_byte_leaf_kept_separate_from_experimental_winner(self):
        ranked, _ = rankings([row(CANDIDATE, times=(1, 1, 1, 1)), row(BYTE, times=(2, 2, 2, 2)), row("External")], REGISTRY, protocol())
        self.assertTrue(all(r["native_experimental"]["filter"] == CANDIDATE and r["byte_leaf"]["filter"] == BYTE and r["byte_leaf_over_independent32"] == 2 for r in ranked))

    def test_wilson_endpoints_and_exact_ties(self):
        self.assertEqual(wilson(0, 100)[0], 0)
        self.assertEqual(wilson(100, 100)[1], 1)
        self.assertEqual(outcome(1), "exact_tie")
        self.assertIsNone(fastest([], "lookup_ns"))
        for fp, n in ((-1, 100), (101, 100), (0, 0)):
            with self.assertRaises(ValueError):
                wilson(fp, n)

    def test_python_optimized_mode_rejected_before_loading_results(self):
        p = subprocess.run([sys.executable, "-O", str(Path(__file__).with_name("summarize.py"))], text=True, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("without Python -O", p.stderr)


if __name__ == "__main__":
    unittest.main()
