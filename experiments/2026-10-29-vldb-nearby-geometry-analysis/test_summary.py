import copy
import unittest
from summarize import calculate, cases, quality


def fixture():
    rows = []
    for case in cases():
        row = dict(case['geometry'])
        row.update(unit_count='100', unit_bytes='32', constructor_argument='25600', address='magic',
                   false_positives='3', absent_queries='10', result_checksum='1', query_checksum='2',
                   calibration_checksum='3')
        rows.append(row)
    records = []
    for case in cases():
        q = {k: case[k] for k in ('filter', 'power', 'cap', 'policy', 'status')}
        q.update(filter_bytes=100, logical_bytes=100, negatives=1000,
                 false_positives=5 if case['policy'] == 'nearby_odd' else 10)
        records.append(q)
    return rows, records


class SummaryTests(unittest.TestCase):
    def test_all_originals_and_pairs(self):
        points, pairs = calculate(*fixture())
        self.assertEqual((len(points), len(pairs)), (36, 12))
        self.assertTrue(all(x['observed_fp_change'] == -5 and
                            x['nearby_over_original_observed_fp'] == 0.5 for x in pairs))

    def test_failures_and_increased_fp_are_retained(self):
        rows, q = fixture()
        q[1]['false_positives'] = 20
        _, pairs = calculate(rows, q)
        self.assertEqual(pairs[0]['observed_fp_change'], 10)
        self.assertEqual(pairs[0]['nearby_over_original_observed_fp'], 2)

    def test_changed_stream_rejected(self):
        rows, q = fixture()
        rows[1]['calibration_checksum'] = '999'
        with self.assertRaises(ValueError):
            calculate(rows, q)

    def test_changed_identity_and_missing_rows_rejected(self):
        rows, q = fixture()
        with self.assertRaises(ValueError):
            calculate(rows[:-1], q[:-1])
        q[1]['power'] = 17
        with self.assertRaises(ValueError):
            calculate(rows, q)

    def test_denominator_mismatch_rejected(self):
        rows, q = fixture()
        q[1]['negatives'] = 2000
        with self.assertRaises(ValueError):
            calculate(rows, q)


if __name__ == '__main__':
    unittest.main()
