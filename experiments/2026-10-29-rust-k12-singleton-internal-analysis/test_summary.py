import copy
import math
import unittest
import summarize as s


def fixture():
    cases = s.expected_cases()
    records = []
    for case in cases:
        insertion_id = case['key_power'] * 10**10 + case['seed']
        query_id = insertion_id * 101 + case['hit']
        base = dict(keys=case['keys'], queries=case['queries'], batch=case['batch'], hit=case['hit'],
                    seed=case['seed'], repeats=8, filter_bytes=case['filter_bytes'], backend='avx512',
                    input_digest=query_id, insert_digest=insertion_id, bitmap_digest=insertion_id + 1,
                    output_digest=query_id + 1, scratch_bytes=case['batch'] * 8,
                    phase_order=[list(x) for x in (s.FOUR if case['batch'] == 1 else s.TWO) * 2],
                    round=case['round'], stage='measure', calibration_queries=0)
        rows = []
        for arm in case['api_order']:
            factor = 1 if arm == 'Control' else [0.5, 1, 2][case['case_index'] % 3]
            rows.append(dict(**copy.deepcopy(base), filter=arm,
                             trials_ns=[[factor * (2 + i / 10 + m) for i in range(8)]
                                        for m in range(len(case['metrics']))]))
        records.append(dict(case=copy.deepcopy(case), rows=rows))
    return cases, records


class SummaryTests(unittest.TestCase):
    def setUp(self):
        self.cases, self.records = fixture()

    def calculate(self):
        return s.calculate(self.records, self.cases)

    def test_complete_counts_and_profiles(self):
        result = self.calculate()
        self.assertEqual({k: len(v) for k, v in result.items()},
                         dict(pairs=288, vectors=576, samples=4608,
                              round_sensitivity=144, seed_round_ranges=72))
        for profile in s.PROFILES:
            self.assertEqual(sum(r['profile'] == profile for r in result['pairs']), 144)
            self.assertEqual(sum(r['profile'] == profile for r in result['seed_round_ranges']), 36)
        self.assertEqual(sum(r['batch'] >= 4 for r in result['pairs']), 64)

    def test_math_direction_trials_and_all_outcomes(self):
        result = self.calculate()
        self.assertEqual({r['outcome'] for r in result['pairs']}, {'faster', 'tie', 'slower'})
        first = result['pairs'][0]
        self.assertEqual(first['latency_ratio'], .5)
        self.assertAlmostEqual(first['control_ns_per_key'], 2.35)
        self.assertAlmostEqual(first['candidate_ns_per_key'], 1.175)
        vector = result['vectors'][0]
        self.assertEqual(vector['values_ns_per_key'], [2 + i / 10 for i in range(8)])
        self.assertEqual(vector['minimum_ns_per_key'], 2)
        self.assertEqual(vector['maximum_ns_per_key'], 2.7)
        text = s.render(result)
        self.assertIn('Every slower or tied comparison', text)
        for row in result['pairs']:
            if row['outcome'] != 'faster':
                self.assertIn(f"| {row['case_index']} | {row['profile']} |", text)

    def test_round_reverse_sensitivity(self):
        result = self.calculate()
        for row in result['round_sensitivity']:
            self.assertEqual(row['round1_case_index'] + row['round2_case_index'], 95)
            self.assertEqual(row['round2_api_order'], list(reversed(row['round1_api_order'])))
            self.assertAlmostEqual(row['ratio_of_ratios_round2_over_round1'],
                                   row['round2_latency_ratio'] / row['round1_latency_ratio'])
        self.assertTrue(any(r['direction_changed'] for r in result['round_sensitivity']))
        for row in result['seed_round_ranges']:
            values = [p['latency_ratio'] for p in row['points']]
            self.assertEqual(len(values), 4)
            self.assertEqual(row['minimum_latency_ratio'], min(values))
            self.assertEqual(row['maximum_latency_ratio'], max(values))

    def test_missing_duplicate_and_changed_ledger(self):
        for mutation in ('missing', 'duplicate', 'case', 'order', 'domain'):
            with self.subTest(mutation=mutation):
                self.cases, self.records = fixture()
                if mutation == 'missing': self.records.pop()
                if mutation == 'duplicate': self.records[-1] = self.records[0]
                if mutation == 'case': self.records[0]['case']['case_index'] = 1
                if mutation == 'order': self.records[0]['rows'].reverse()
                if mutation == 'domain': self.cases[0]['raw_counter_envelope'][0] += 1
                with self.assertRaises(ValueError): self.calculate()

    def test_phase_backend_scope_and_bytes(self):
        for key, value in [('backend', 'scalar'), ('stage', 'check'), ('filter_bytes', 1),
                           ('calibration_queries', 1), ('round', True), ('scratch_bytes', 0),
                           ('phase_order', [list(x) for x in s.FOUR[::-1] * 2])]:
            with self.subTest(key=key):
                self.cases, self.records = fixture()
                self.records[0]['rows'][0][key] = value
                with self.assertRaises(ValueError): self.calculate()

    def test_trial_length_and_nonfinite(self):
        for bad in ([1] * 7, [1] * 9, [1] * 7 + [0], [1] * 7 + [-1],
                    [1] * 7 + [float('nan')], [1] * 7 + [float('inf')], [1] * 7 + [True]):
            self.cases, self.records = fixture()
            self.records[0]['rows'][0]['trials_ns'][0] = bad
            with self.assertRaises(ValueError): self.calculate()

    def test_pair_and_reused_query_identity(self):
        for index, both in ((0, False), (1, True), (24, True), (95, True)):
            with self.subTest(index=index, both=both):
                self.cases, self.records = fixture()
                rows = self.records[index]['rows'] if both else self.records[index]['rows'][:1]
                for row in rows: row['output_digest'] += 1
                with self.assertRaises(ValueError): self.calculate()

    def test_bitmap_identity_across_hit_cells(self):
        # Change both arms at all profiles/rounds for hit=0: query-level checks alone cannot catch this.
        for record in self.records:
            if record['case']['hit'] == 0:
                for row in record['rows']: row['bitmap_digest'] += 1
        with self.assertRaisesRegex(ValueError, 'across hits'): self.calculate()

    def test_schema_digest_type_and_duplicate_json(self):
        for mutation in ('extra', 'bool', 'negative', 'overflow'):
            self.cases, self.records = fixture()
            row = self.records[0]['rows'][0]
            if mutation == 'extra': row['unknown'] = 0
            if mutation == 'bool': row['input_digest'] = True
            if mutation == 'negative': row['input_digest'] = -1
            if mutation == 'overflow': row['input_digest'] = 2**64
            with self.assertRaises(ValueError): self.calculate()
        with self.assertRaises(ValueError): s.unique([('a', 1), ('a', 2)])

    def test_loader_fail_closed(self):
        with self.assertRaisesRegex(ValueError, 'No finalized formal producer/raw binding'): s.load()


if __name__ == '__main__':
    unittest.main()
