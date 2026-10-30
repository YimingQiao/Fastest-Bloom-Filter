"""Offline report guard tests; synthetic times never become benchmark data."""
import copy
import json
from pathlib import Path
import statistics
import unittest

import summarize

HERE = Path(__file__).resolve().parent


def fixture():
    protocol = json.loads((HERE / "protocol.json").read_text())
    preflight = json.loads((HERE / "validation/preflight.json").read_text())
    cases = []
    rows = copy.deepcopy(preflight["rows"])
    for bpk in (8, 16):
        chosen = [row for row in rows if row["requested_bpk"] == bpk]
        first = chosen[0]
        n, q = first["keys"], first["queries"]
        base = first["calibration_raw_interval"][0] - n - q
        case = dict(id=f"test-{bpk}", keys=n, queries=q, seed=42, requested_bpk=bpk,
                    payload_bytes=first["filter_bytes"], actual_bpk=first["actual_bpk"],
                    inserted_raw_interval=[base, base+n], query_negative_raw_bounds=[base+n, base+n+q],
                    calibration_raw_interval=first["calibration_raw_interval"],
                    constructions={row["filter"]: row["spec"] for row in chosen if row["language"] == "numba"})
        cases.append(case)
        for row in chosen:
            row["case"] = case["id"]
            row["throughput_enabled"] = True
            for trial in row["query_trials"]:
                trial["elapsed_ns"] = 1000 + trial["trial"]*10 + trial["position"]
            row["query_ns_per_key"] = {mode: statistics.median(trial["elapsed_ns"] for trial in row["query_trials"]
                                                               if trial["mode"] == mode) / q for mode in summarize.guard.MODES}
    protocol["cases"] = cases
    result = dict(metadata=dict(complete=True, throughput_enabled=True, rows=24, preflights=16), rows=rows,
                  preflights=[dict(case=case["id"], filter=config["filter"]) for case in cases
                              for config in protocol["configs"] if config["family"] == "blowchoc"])
    return protocol, result


class SummaryTests(unittest.TestCase):
    def setUp(self):
        self.protocol, self.result = fixture()

    def test_complete_scope(self):
        self.assertEqual(len(summarize.validate_matrix(self.protocol, self.result)), 24)

    def test_wilson_endpoints(self):
        self.assertEqual(summarize.upper95(16777216, 16777216), 1.)
        self.assertGreater(summarize.upper95(0, 16777216), 0)

    def test_missing_row(self):
        self.result["rows"].pop()
        with self.assertRaises(ValueError):
            summarize.validate_matrix(self.protocol, self.result)

    def test_duplicate_row(self):
        self.result["rows"][-1] = self.result["rows"][0]
        with self.assertRaises(ValueError):
            summarize.validate_matrix(self.protocol, self.result)

    def test_duplicate_preflight(self):
        self.result["preflights"][-1] = self.result["preflights"][0]
        with self.assertRaises(ValueError):
            summarize.validate_matrix(self.protocol, self.result)

    def test_family_ownership(self):
        self.result["rows"][0]["language"] = "numba"
        with self.assertRaises(ValueError):
            summarize.validate_matrix(self.protocol, self.result)

    def test_build_metadata(self):
        self.result["rows"][0]["build_repeats"] = 6
        with self.assertRaises(ValueError):
            summarize.validate_matrix(self.protocol, self.result)

    def test_last_mode_sample(self):
        self.result["rows"][-1]["query_trials"][-1]["elapsed_ns"] = None
        with self.assertRaises(ValueError):
            summarize.validate_matrix(self.protocol, self.result)

    def test_calibration_count_integer(self):
        self.result["rows"][0]["calibration_false_positives"] = .5
        with self.assertRaises(ValueError):
            summarize.validate_matrix(self.protocol, self.result)

    def test_memory_cap_and_independent_modes(self):
        def row(name, family, bpk, times, upper):
            return dict(filter=name, family=family, keys=65536, filter_bytes=65536*bpk//8, actual_bpk=bpk,
                        query_ns_per_key=dict(zip(summarize.guard.MODES, times)), calibration_wilson95_upper=upper)
        rows = [row("native16", "native", 16, (1, 4, 3), .0005),
                row("native32", "native", 32, (2, 2, 2), .00005),
                row("external16", "blowchoc", 16, (3, 3, 3), .0005),
                row("external32", "blowchoc", 32, (2, 1, 2), .00005),
                row("fast_but_ineligible", "blowchoc", 16, (.01, .01, .01), .1)]
        indexed = {(r["cap_bpk"], r["fpr_target"], r["mode"]): r for r in summarize.comparisons(rows)}
        self.assertEqual(indexed[32, "0.1%", "prehashed"]["native_filter"], "native16")
        self.assertEqual(indexed[32, "0.1%", "common-fused"]["native_filter"], "native32")
        self.assertEqual(indexed[16, "0.1%", "common-fused"]["external_filter"], "external16")
        self.assertEqual(indexed[16, "0.01%", "prehashed"]["native_filter"], "")
        self.assertEqual(indexed[32, "0.01%", "prehashed"]["native_filter"], "native32")
        self.assertEqual(indexed[32, "0.1%", "prehashed"]["external_over_native"], 2)


if __name__ == "__main__":
    unittest.main()
