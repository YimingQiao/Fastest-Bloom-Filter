"""Synthetic data only; never imports a producer audit or measured records."""
import copy
import json
import unittest
from unittest import mock

import summarize as s


def fixture():
    cases = json.loads((s.PLAN / 'ledger.json').read_text())
    records = []
    for case in cases:
        n, q = 1 << case['n_exponent'], 1 << 22
        seed, hit, batch = case['seed'], case['hit_percent'], case['batch']
        present = q // 100 * hit + min(q % 100, hit)
        values = [float(i + 1) for i in range(8)]
        factor = {0: .75, 50: 1., 100: 1.25}[hit]
        # Preserve a real direction change in both rounds for the same inputs.
        if hit == 0 and case['round'] == 2:
            factor = 1.125
        rows = []
        for arm in case['api_order']:
            row = dict(filter=arm, keys=n, queries=q, actual_bytes=n * 3,
                       hit=hit, batch=batch, repeats=8, seed=seed,
                       order=int(case['api_order'][0] == 'Candidate'), measure=True,
                       key_base=seed, present=present, absent=q-present,
                       false_positives=0 if hit == 100 else 3,
                       inserted_digest=n+seed, bitmap_digest=n+seed+1,
                       inserted_hash_digest=n+seed+2, query_digest=n+seed+hit+100,
                       query_hash_digest=n+seed+hit+101, result_digest=n+seed+hit+102,
                       phase_order=[v for step in (s.FOUR if batch == 1 else s.TWO) * 2
                                    for v in step],
                       samples={mode: [v * (factor if arm == 'Candidate' else 1.) for v in values]
                                if index < 2 or batch == 1 else []
                                for index, mode in enumerate(s.MODES)})
            rows.append(row)
        records.append(dict(case=copy.deepcopy(case), rows=rows))
    return cases, records


class SummaryTests(unittest.TestCase):
    def test_all_counts_values_and_ties(self):
        cases, records = fixture()
        result = s.calculate(records, cases)
        self.assertEqual({k: len(v) for k, v in result.items()},
                         dict(pairs=240, vectors=480, samples=3840,
                              round_sensitivity=120, seed_round_ranges=60))
        self.assertEqual({r['outcome'] for r in result['pairs']}, {'faster', 'slower', 'tie'})
        self.assertEqual(sum(len(r['values_ns_per_key']) for r in result['vectors']), 3840)
        self.assertTrue(all(r['median_ns_per_key'] == 4.5
                            for r in result['vectors'] if r['arm'] == 'Control'))
        self.assertEqual(len([r for r in result['pairs'] if r['batch'] == 1]), 96)
        self.assertTrue(all('machine code not assumed identical' in r['source_path_scope']
                            for r in result['pairs'] if r['batch'] >= 4))

    def test_same_input_round_sensitivity_retains_reversal(self):
        cases, records = fixture()
        result = s.calculate(records, cases)
        changed = [r for r in result['round_sensitivity'] if r['hit'] == 0]
        self.assertEqual(len(changed), 40)
        for row in changed:
            self.assertEqual(row['round1_latency_ratio'], .75)
            self.assertEqual(row['round2_latency_ratio'], 1.125)
            self.assertEqual(row['ratio_of_ratios_round2_over_round1'], 1.5)
            self.assertTrue(row['direction_changed'])
            self.assertEqual(row['round1_api_order'], list(reversed(row['round2_api_order'])))
        self.assertTrue(all(len(r['points']) == 4 for r in result['seed_round_ranges']))
        self.assertTrue(all(r['minimum_latency_ratio'] == .75 and r['maximum_latency_ratio'] == 1.125
                            for r in result['seed_round_ranges'] if r['hit'] == 0))

    def test_ledger_order_and_missing_rows_rejected(self):
        cases, records = fixture()
        with self.assertRaisesRegex(ValueError, 'incomplete'):
            s.calculate(records[:-1], cases)
        records[0], records[1] = records[1], records[0]
        with self.assertRaisesRegex(ValueError, 'record order'):
            s.calculate(records, cases)
        broken = copy.deepcopy(cases)
        broken[48]['api_order'].reverse()
        with self.assertRaisesRegex(ValueError, 'not reversed'):
            s.validate_ledger(broken)

    def test_semantics_and_hit_count_rejected(self):
        for field, value in (('result_digest', 1), ('actual_bytes', 2), ('present', 1)):
            cases, records = fixture()
            records[0]['rows'][0][field] = value
            with self.assertRaises(ValueError):
                s.calculate(records, cases)
        cases, records = fixture()
        for row in records[-1]['rows']:
            row['query_digest'] += 1
        with self.assertRaisesRegex(ValueError, 'identity changed'):
            s.calculate(records, cases)

    def test_paired_mutation_cannot_hide_across_batches(self):
        cases, records = fixture()
        for row in records[1]['rows']:
            row['bitmap_digest'] += 9
        with self.assertRaisesRegex(ValueError, 'identity changed'):
            s.calculate(records, cases)

    def test_every_vector_and_schedule_checked(self):
        for value in (float('nan'), float('inf'), 0, True):
            cases, records = fixture()
            records[-1]['rows'][-1]['samples'][s.MODES[0]][7] = value
            with self.assertRaisesRegex(ValueError, 'invalid trial'):
                s.calculate(records, cases)
        cases, records = fixture()
        records[-1]['rows'][-1]['phase_order'][0] = 99
        with self.assertRaisesRegex(ValueError, 'phase order'):
            s.calculate(records, cases)
        cases, records = fixture()
        records[1]['rows'][0]['samples'][s.MODES[2]] = [1.] * 8
        with self.assertRaisesRegex(ValueError, 'trial count'):
            s.calculate(records, cases)

    def test_reordered_api_and_extra_field_rejected(self):
        cases, records = fixture()
        records[0]['rows'].reverse()
        with self.assertRaisesRegex(ValueError, 'API row order'):
            s.calculate(records, cases)
        cases, records = fixture()
        records[0]['rows'][0]['invented_field'] = 0
        with self.assertRaisesRegex(ValueError, 'schema'):
            s.calculate(records, cases)

    def test_no_pending_loader_can_read_data(self):
        with mock.patch.object(s.Path, 'is_file', return_value=False):
            with self.assertRaisesRegex(ValueError, 'anchor not available'):
                s.load()


if __name__ == '__main__':
    unittest.main()
