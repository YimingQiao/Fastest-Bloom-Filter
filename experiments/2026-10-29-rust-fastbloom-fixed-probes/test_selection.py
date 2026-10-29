import unittest
from selection_rule import select_neighborhood, wilson_upper


def rows(counts=None):
    counts = counts or {k: 0 for k in range(1, 13)}
    return [{"K": k, "false_positives": counts[k], "negatives": 1 << 24} for k in range(1, 13)]


class Selection(unittest.TestCase):
    def test_lowest_qualifier_and_immediate_neighbors_even_when_neighbor_fails(self):
        counts = {k: 100_000 for k in range(1, 13)}
        counts.update({5: 1000, 7: 100, 12: 1})
        result = select_neighborhood(rows(counts))
        self.assertEqual([t["minimum_qualifying_K"] for t in result["targets"]], [1, 5, 5])
        self.assertEqual(result["selected_fixed_K"], [1, 2, 4, 5, 6])
        self.assertNotIn(7, result["selected_fixed_K"])
        self.assertNotIn(12, result["selected_fixed_K"])
        self.assertGreater(result["wilson_upper_by_K"][4], 0.001)

    def test_all_fail_keeps_explicit_empty_choice(self):
        result = select_neighborhood(rows({k: 1 << 24 for k in range(1, 13)}))
        self.assertEqual(result["selected_fixed_K"], [])
        self.assertTrue(all(t["minimum_qualifying_K"] is None for t in result["targets"]))

    def test_endpoint_neighborhoods_stay_within_grid(self):
        self.assertEqual(select_neighborhood(rows())["selected_fixed_K"], [1, 2])
        counts = {k: 1 << 24 for k in range(1, 13)}
        counts[12] = 0
        self.assertEqual(select_neighborhood(rows(counts))["selected_fixed_K"], [11, 12])

    def test_input_order_has_no_effect(self):
        self.assertEqual(select_neighborhood(rows()), select_neighborhood(reversed(rows())))

    def test_missing_duplicate_or_wrong_grid_rejected(self):
        for value in [rows()[:-1], rows() + [rows()[0]], rows()[1:] + [dict(rows()[0], K=13)]]:
            with self.assertRaises(ValueError):
                select_neighborhood(value)

    def test_latency_or_extra_input_rejected(self):
        value = rows()
        value[0]["lookup_ns"] = 0.01
        with self.assertRaises(ValueError):
            select_neighborhood(value)

    def test_different_sample_counts_or_bad_counts_rejected(self):
        for field, value in [("negatives", 1000), ("false_positives", -1), ("false_positives", 1 << 25), ("K", True)]:
            changed = rows()
            changed[0][field] = value
            with self.assertRaises(ValueError):
                select_neighborhood(changed)

    def test_wilson_endpoints(self):
        self.assertEqual(wilson_upper(100, 100), 1.0)
        self.assertGreater(wilson_upper(0, 100), 0.0)


if __name__ == "__main__":
    unittest.main()
