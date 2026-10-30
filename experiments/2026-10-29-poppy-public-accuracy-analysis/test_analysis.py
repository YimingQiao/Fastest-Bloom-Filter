import unittest
from analyze import constructors, tables, wilson
from test_contract import row


class AnalysisTests(unittest.TestCase):
    def test_wilson_boundary_samples(self):
        low, high = wilson(0, 100)
        self.assertAlmostEqual(low, 0, places=14)
        self.assertAlmostEqual(high, 0.03699349820698568, places=14)
        low, high = wilson(100, 100)
        self.assertAlmostEqual(low, 0.9630065017930143, places=14)
        self.assertAlmostEqual(high, 1, places=14)

    def test_zero_fp_never_overrides_actual_byte_budget(self):
        specs = constructors()
        quality, views, alternatives = tables([row(s, False) for s in specs], specs)
        self.assertEqual(len(quality), 86)
        self.assertTrue(any(not a["within_cap"] for a in alternatives))
        for item in alternatives:
            self.assertTrue(item["passes_quality"])
            self.assertEqual(
                item["eligible"],
                item["actual_bytes"] * 8 <= item["keys"] * item["cap_bpk"],
            )
        self.assertEqual({q["calibration_negatives"] for q in quality}, {1 << 26})
        self.assertEqual(
            sum(len(v["eligible_ids"]) + len(v["over_budget"]) for v in views), 1032
        )

    def test_failed_quality_retains_every_row_and_alternative(self):
        specs = constructors()
        rows = [row(s, False) for s in specs]
        for r in rows:
            r["calibration_false_positives"] = r["calibration_queries"]
        quality, views, alternatives = tables(rows, specs)
        self.assertEqual(len(quality), 86)
        self.assertEqual(len(alternatives), 1032)
        self.assertTrue(all(not a["eligible"] for a in alternatives))
        self.assertTrue(all(not v["eligible_ids"] for v in views))
        self.assertEqual({q["calibration_negatives"] for q in quality}, {1 << 26})


if __name__ == "__main__":
    unittest.main()
