import copy
import unittest
import plan


class Plan(unittest.TestCase):
    def test_counts(self):
        counts = plan.validate(plan.ledger())
        self.assertEqual(counts["variant_rows"], 192)
        self.assertEqual(counts["paired_contracts"], 160)
        self.assertEqual(counts["timed_filter_lifetimes"], 1920)

    def test_missing_duplicate_and_changed_threshold(self):
        for mutate in (lambda c: c.pop(), lambda c: c.__setitem__(1, c[0]),
                       lambda c: c[0].__setitem__("bytes", 262208)):
            cases = copy.deepcopy(plan.ledger()); mutate(cases)
            with self.assertRaises(ValueError): plan.validate(cases)

    def test_no_populated_allocation_build(self):
        cases = plan.ledger()
        next(c for c in cases if c["history_n"])["contracts"].append("allocate_insert")
        with self.assertRaises(ValueError): plan.validate(cases)

    def test_reverse_case_order(self):
        cases = plan.ledger()
        key = lambda c: (c["language"], c["family"], c["scenario"], c["requested"])
        self.assertEqual(list(map(key, cases[:48])), list(reversed(list(map(key, cases[48:])))))

    def test_domains_are_disjoint(self):
        intervals = []
        for seed in plan.SEEDS:
            base = seed << 42
            intervals.extend([(base, base + 50331648), (base + (1 << 40), base + (1 << 40) + 65537),
                              (base + (2 << 40), base + (2 << 40) + 32771)])
        for i, a in enumerate(intervals):
            for b in intervals[i+1:]:
                self.assertTrue(a[1] <= b[0] or b[1] <= a[0])


if __name__ == "__main__": unittest.main()
