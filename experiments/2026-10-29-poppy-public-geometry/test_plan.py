"""Geometry-only boundary and coverage tests. No upstream code or BF executes."""
import math
import struct
import unittest
from plan import POLICIES, bits, ceil_div, derive, interval, next_power, predict


class PlanTests(unittest.TestCase):
    def test_interval_endpoints(self):
        for power in (16, 25):
            n = 1 << power
            for policy in POLICIES:
                for cap in (12, 16, 24, 32):
                    w = interval(n, cap, policy)
                    low, high = w['first_capacity'], w['last_capacity']
                    count = lambda c: next_power(ceil_div(n, c)) if policy == 'speed' else ceil_div(n, c)
                    self.assertEqual(count(low), w['actual_buckets'])
                    self.assertEqual(count(high), w['actual_buckets'])
                    self.assertGreater(count(low - 1), w['fitting_bucket_limit'])
                    self.assertLess(count(high + 1), w['actual_buckets'])

    def test_public_formula_controls(self):
        # Independently hand-derived 65536 / 0.01 control: floor(15743.484.../4.605...)=3418.
        row = predict(65536, 0.01, 'none')
        self.assertEqual((row['per_bucket_capacity'], row['buckets'], row['probes']), (3418, 20, 7))
        self.assertEqual(row['backing_bytes'], 81920)
        row = predict(65536, 0.01, 'speed')
        self.assertEqual((row['buckets'], row['cache_bytes'], row['probes']), (32, 8192, 5))
        self.assertEqual(row['backing_bytes'], 139264)
        self.assertEqual(predict(65536, 0.01, 'best')['backing_bytes'], 90112)

    def test_complete_k_coverage_and_representatives(self):
        selection, ledger = derive()
        for w in selection['intervals']:
            pool = [r for r in ledger if (r['power'], r['policy'], r['cap_bpk']) == (w['power'], w['policy'], w['cap_bpk'])]
            self.assertEqual([r['capacity'] for r in pool], list(range(w['first_capacity'], w['last_capacity'] + 1)))
            selected = [r for r in pool if r['selected']]
            self.assertEqual({r['probes'] for r in selected}, {r['probes'] for r in pool})
            self.assertEqual(len(selected), len({r['probes'] for r in pool}))
            for r in selected:
                self.assertEqual(r['capacity'], min(x['capacity'] for x in pool if x['probes'] == r['probes']))

    def test_argument_roundtrip_and_overbudget_retention(self):
        selection, ledger = derive()
        for row in ledger:
            self.assertEqual(bits(float(row['fpp_decimal'])), row['fpp_bits'])
            self.assertEqual(bits(struct.unpack('>d', bytes.fromhex(row['fpp_bits']))[0]), row['fpp_bits'])
        controls = [r for r in selection['rows'] if r['kind'] == 'ordinary_fpp_control']
        self.assertEqual(len(controls), 24)
        self.assertTrue(any(not r['admissible_caps'] for r in controls))
        self.assertEqual(len(selection['intervals']), 32)

    def test_none_space_aliases_keep_labels(self):
        selection, _ = derive()
        rows = selection['rows']
        for row in [r for r in rows if r['policy'] == 'none']:
            other = [r for r in rows if r['policy'] == 'space' and r['n'] == row['n'] and r['fpp_bits'] == row['fpp_bits']]
            self.assertEqual(len(other), 1)
            self.assertEqual(other[0]['mapping_alias_group'], row['mapping_alias_group'])
            self.assertNotEqual(other[0]['parameter_fingerprint'], row['parameter_fingerprint'])


if __name__ == '__main__':
    unittest.main()
