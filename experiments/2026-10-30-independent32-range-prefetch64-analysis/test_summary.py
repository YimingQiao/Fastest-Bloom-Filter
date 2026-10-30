"""Synthetic-only guards. No raw measurements, upstream imports, or BF calls."""
import unittest
import json
import tempfile
from pathlib import Path
import summarize as s


def fixture():
    points = []
    for n in s.SIZES:
        definitions = [('pipeline', 'candidate', 12, True, 'range12'),
                       ('control', 'range_control', 12, True, 'range12')]
        definitions += [(name, 'production_native', 16, False, name) for name in ('Fast', 'Four', 'Byte', 'Split')]
        definitions += ([('FastFilterFixed16', 'external', 16, False, 'FastFilterFixed16'),
                         ('FastFilterFixed16SingleV1', 'external', 16, False, 'FastFilterFixed16'),
                         ('externalB', 'external', 14, False, 'externalB')]
                        if n == 1 << 16 else [('externalLarge', 'external', 12, False, 'externalLarge')])
        for name, owner, bpk, data, mapping in definitions:
            backing = n * bpk // 8 - (name == 'externalLarge')
            points.append(dict(id=f'{n}/{name}', owner=owner, public_data_available=data,
                mapping_id=f'{n}/{mapping}', geometry=dict(filter=name, keys=n, requested_bpk=bpk,
                    budget_bytes=n*bpk//8, filter_bytes=backing, logical_bytes=backing,
                    unit_bytes=32, unit_count=backing//32, effective_probes=8,
                    constructor_argument=bpk, native_constructor_bpk=0,
                    geometry_kind='synthetic', probe_policy='fixed')))
    selection = {'points': points}
    ledger = s.build_ledger(points)
    by_id = {p['id']: p for p in points}
    mapping_num = {m: i for i, m in enumerate(dict.fromkeys(p['mapping_id'] for p in points))}
    records = []
    for case in ledger:
        rows = []
        for pid in case['point_ids']:
            p = by_id[pid]
            g = p['geometry']
            n, q = g['keys'], 1 << 22
            present = q // 100 * 50 + min(q % 100, 50)
            identity = mapping_num[p['mapping_id']] + 1
            seed = case['seed']
            row = {k: g[k] for k in s.GEOMETRY}
            row.update(point_id=pid, owner=p['owner'], actual_bytes=g['filter_bytes'],
                bitmap_available=p['public_data_available'], bitmap_digest=identity if p['public_data_available'] else None,
                queries=q, hit=50, batch=case['batch'], repeats=8, seed=seed,
                reverse_jobs=bool(case['order']), measure=True, key_base=s.input_order(points, case)[0],
                present=present, absent=q-present, query_scratch_bytes=case['batch']*8,
                inserted_digest=n+seed, inserted_hash_digest=n+seed+1,
                query_digest=n+seed+2, query_hash_digest=n+seed+3, result_digest=identity,
                false_positives=identity, calibration_negatives=(1 << 26) if case['calibration_power'] else 0,
                calibration_fp=1000 if case['calibration_power'] else 0,
                calibration_digest=identity if case['calibration_power'] else None,
                phase_order=[m for step in (s.FOUR if case['batch'] == 1 else s.TWO)*2 for m in step])
            value = 1.0 if g['filter'] == 'pipeline' else 3.0
            row['samples'] = {mode: [value]*8 if mode in s.modes(case['batch']) else [] for mode in s.MODES}
            rows.append(row)
        records.append(dict(case=case, rows=rows))
    return records, selection, ledger


class SummaryTests(unittest.TestCase):
    def setUp(self):
        self.records, self.selection, self.ledger = fixture()

    def result(self):
        return s.calculate(self.records, self.selection, self.ledger)

    def test_full_counts_and_single_denominator_alias(self):
        out = self.result()
        self.assertEqual(out['counts'], dict(rows=192, api_quality_records=32, known_mapping_records=26,
            quality_reuses=160, vectors=512, trial_values=4096, alternatives=512, envelopes=128,
            fixed_views=32, fixed_pairs=128, unconditional_control_pairs=64, round_pairs=256, primary_comparisons=24))
        self.assertEqual(out['decision']['faster'], 24)
        self.assertTrue(out['decision']['closed'])
        aliases = [q for q in out['mapping_quality'] if len(q['point_ids']) == 2]
        self.assertEqual(len(aliases), 6)
        self.assertTrue(all(q['representative_quality']['calibration_negatives'] == 1 << 26 for q in aliases))
        self.assertFalse(out['decision']['promotion_authorized'])

    def test_one_seed_failure_keeps_unconditional_controls(self):
        for rec in self.records:
            if rec['case']['calibration_power'] and rec['case']['seed'] == s.SEEDS[0]:
                for row in rec['rows']:
                    if row['keys'] == 1 << 25 and row['owner'] in ('candidate','range_control'):
                        row['calibration_fp'] = 1_000_000
        out = self.result()
        self.assertEqual(out['decision']['not_comparable'], 24)
        self.assertFalse(out['decision']['closed'])
        self.assertTrue(all(p['latency_ratio'] is not None and not p['qualification_required']
                            for p in out['control_pairs']))
        self.assertEqual(len(out['vectors']), 512)
        self.assertEqual(len(out['quality']), 32)

    def test_no_qualified_rival_is_not_a_win(self):
        for rec in self.records:
            if rec['case']['calibration_power']:
                for row in rec['rows']:
                    if row['filter'] == 'externalLarge':
                        row['calibration_fp'] = 1_000_000
        out = self.result()
        self.assertEqual(out['decision']['not_comparable'], 8)
        self.assertEqual(out['decision']['faster'], 16)
        self.assertFalse(out['decision']['closed'])
        self.assertTrue(all(r['rival_point_id'] is None for r in out['envelopes']
                            if r['keys'] == 1 << 25 and r['rival_owner'] == 'external'))

    def test_known_alias_corruption_rejected(self):
        next(r for r in self.records[0]['rows'] if r['filter'] == 'FastFilterFixed16SingleV1')['calibration_fp'] += 1
        with self.assertRaisesRegex(ValueError, 'mapping aliases'):
            self.result()

    def test_query_reuse_corruption_rejected(self):
        self.records[1]['rows'][0]['result_digest'] += 1
        with self.assertRaisesRegex(ValueError, 'query identit'):
            self.result()

    def test_public_data_capability_not_owner(self):
        out = self.result()
        self.assertTrue(all(q['insertion_identity']['bitmap_digest'] is None for q in out['quality']
                            if q['point_id'].endswith('/Four')))
        next(r for r in self.records[0]['rows'] if r['filter'] == 'Four')['bitmap_digest'] = 123
        with self.assertRaisesRegex(ValueError, 'public bitmap'):
            self.result()

    def test_incomplete_or_wrong_order_rejected(self):
        with self.assertRaisesRegex(ValueError, 'incomplete process'):
            s.calculate(self.records[:-1], self.selection, self.ledger)
        self.records[0]['rows'].reverse()
        with self.assertRaisesRegex(ValueError, 'raw row order'):
            self.result()

    def test_per_cell_envelope_exposes_fixed_leader_loss(self):
        cases = [c for c in self.ledger if c['power'] == 16 and c['batch'] == 1]
        special = max(cases, key=lambda c: (s.SEEDS.index(c['seed']), c['round']))['index']
        for rec in self.records:
            if rec['case']['power'] != 16 or rec['case']['batch'] != 1:
                continue
            for row in rec['rows']:
                name = row['filter']
                value = 10 if rec['case']['index'] == special else 2
                if name in ('FastFilterFixed16', 'FastFilterFixed16SingleV1'):
                    row['samples'][s.MODES[0]] = [value]*8
                if name == 'externalB':
                    row['samples'][s.MODES[0]] = [3]*8
                if name == 'pipeline' and rec['case']['index'] == special:
                    row['samples'][s.MODES[0]] = [4]*8
        out = self.result()
        def get(rows):
            return next(p for p in rows if p['case_index'] == special and
                        p['mode'] == s.MODES[0] and p['rival_owner'] == 'external')
        self.assertEqual(get(out['fixed_pairs'])['outcome'], 'faster')
        self.assertEqual(get(out['envelopes'])['outcome'], 'slower')

    def test_all_trial_values_and_control_losses_survive(self):
        row = next(r for r in self.records[0]['rows'] if r['filter'] == 'pipeline')
        row['samples'][s.MODES[0]] = [1, 2, 8, 9, 10, 11, 12, 13]
        out = self.result()
        vector = next(v for v in out['vectors'] if v['case_index'] == 0 and
                      v['point_id'] == row['point_id'] and v['mode'] == s.MODES[0])
        self.assertEqual(vector['median_ns_per_key'], 9.5)
        self.assertEqual(vector['values_ns_per_key'], row['samples'][s.MODES[0]])
        pair = next(p for p in out['control_pairs'] if p['case_index'] == 0 and p['mode'] == s.MODES[0])
        self.assertEqual(pair['outcome'], 'slower')
        self.assertEqual(len(out['control_pairs']),64)

    def test_every_case_pipeline_control_semantics_match(self):
        row = next(r for r in self.records[1]['rows'] if r['filter'] == 'pipeline')
        row['result_digest'] += 1
        with self.assertRaisesRegex(ValueError, 'query identit'):
            self.result()
        self.records, self.selection, self.ledger = fixture()
        row = next(r for r in self.records[0]['rows'] if r['filter'] == 'pipeline')
        row['bitmap_digest'] += 1
        with self.assertRaisesRegex(ValueError, 'mapped bitmap/query'):
            self.result()

    def test_wrong_alias_claim_rejected(self):
        pipeline = next(p for p in self.selection['points'] if p['geometry']['filter'] == 'pipeline')
        pipeline['mapping_id'] = 'invented independent pipeline mapping'
        with self.assertRaisesRegex(ValueError, 'pipeline/control mapping'):
            self.result()

    def test_single_primary_loss_or_tie_fails_only_its_group(self):
        rec = next(rec for rec in self.records if rec['case']['power']==25 and rec['case']['batch']==4096)
        row = next(r for r in rec['rows'] if r['filter']=='control')
        row['samples'][s.MODES[0]] = [1.0]*8
        out = self.result()
        group = {g['comparison_group']:g for g in out['decision']['groups']}
        self.assertFalse(group['range_control']['met'])
        self.assertEqual(group['range_control']['ties'],1)
        self.assertTrue(group['external']['met'])
        self.assertTrue(group['production_native']['met'])
        self.assertFalse(out['decision']['closed'])

    def test_invalid_unavailable_and_nonfinite_samples_rejected(self):
        self.records[1]['rows'][0]['samples'][s.MODES[2]] = [1.0]*8
        with self.assertRaisesRegex(ValueError, 'trial count'):
            self.result()
        self.records, self.selection, self.ledger = fixture()
        self.records[0]['rows'][0]['samples'][s.MODES[0]][0] = float('nan')
        with self.assertRaisesRegex(ValueError, 'invalid trial time'):
            self.result()

    def test_report_preserves_products_and_rejects_existing_directory(self):
        result = self.result()
        with tempfile.TemporaryDirectory() as temp:
            target = Path(temp) / 'report'
            s.write_report(result, target)
            self.assertEqual({p.name for p in target.iterdir()},
                             {name + '.json' for name in result} | {'REPORT.md'})
            for name, value in result.items():
                self.assertEqual(json.loads((target / (name + '.json')).read_text()), value)
            with self.assertRaisesRegex(ValueError, 'fresh report'):
                s.write_report(result, target)


if __name__ == '__main__':
    unittest.main()
