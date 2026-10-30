"""Synthetic grids and a preformal API-schema guard; no proof-timing ranking."""
import copy
import json
import math
import hashlib
import subprocess
import tempfile
import unittest
from pathlib import Path

import summarize as s


def fixture():
    source = {name: s.read(s.PLAN / name) for name in
              ('protocol.json', 'selection.json', 'ledger.json', 'input-domains.json')}
    points = {p['id']: p for p in source['selection.json']['points']}
    mapping_ids = {name: i+1 for i, name in enumerate(sorted({p['mapping_id'] for p in points.values()}))}
    domains = {(d['keys'], d['seed']): d for d in source['input-domains.json']}
    bitmap_api = s.read(s.HERE / 'BITMAP_API.json')['types']
    records = []
    for case in source['ledger.json']:
        rows = []
        n, q, seed, hit, batch = 1 << case['key_power'], 1 << 22, case['seed'], case['hit'], case['batch']
        present = q//100*hit + min(q%100, hit)
        # Pure calculator preserves row position; exact RNG row-order replay is
        # the immutable producer audit's job. These are synthetic rows only.
        for pid in case['point_ids']:
            p = points[pid]
            g = p['geometry']
            m = mapping_ids[p['mapping_id']]
            row = {k: g.get(k, 0) if k in ('filter', 'geometry_kind', 'probe_policy') else int(g.get(k, 0)) for k in s.GEOMETRY}
            factor = dict(candidate=.8 if case['round'] == 1 else 1.2, old_k12=1.,
                          native_range=.8, production_native=1.1, external=.9)[p['owner']]
            values = [(i+1)*factor for i in range(8)]
            row.update(point_id=pid, owner=p['owner'], actual_bytes=int(g['filter_bytes']), queries=q,
                hit=hit, batch=batch, repeats=8, seed=seed, reverse_jobs=case['reverse_jobs'], measure=True,
                key_base=domains[(n, seed)]['key_base'], present=present, absent=q-present,
                false_positives=0 if hit == 100 else m, inserted_digest=n+seed,
                inserted_hash_digest=n+seed+1, query_digest=n+seed+hit+2,
                query_hash_digest=n+seed+hit+3, result_digest=n+seed+hit+m+4,
                bitmap_digest=n+seed+m if bitmap_api[g['filter']] else None,
                calibration_negatives=(1 << 26) if case['calibration_power'] else 0,
                calibration_fp=0, calibration_digest=n+seed+m if case['calibration_power'] else None,
                query_scratch_bytes=batch*8,
                phase_order=[v for step in (s.FOUR if batch == 1 else s.TWO)*2 for v in step],
                samples={mode: list(values) if i < 2 or batch == 1 else [] for i, mode in enumerate(s.MODES)})
            rows.append(row)
        records.append(dict(case=copy.deepcopy(case), rows=rows))
    return source, records


def set_fp(records, source, owner, seed, fp):
    mappings = {p['mapping_id'] for p in source['selection.json']['points'] if p['owner'] == owner}
    ids = {p['id'] for p in source['selection.json']['points'] if p['mapping_id'] in mappings}
    for record in records:
        if record['case']['calibration_power'] and record['case']['seed'] == seed:
            for row in record['rows']:
                if row['point_id'] in ids:
                    row['calibration_fp'] = fp


class SummaryTests(unittest.TestCase):
    def test_bitmap_availability_matches_preformal_public_caller(self):
        api = s.read(s.HERE / 'BITMAP_API.json')
        path = s.ROOT / api['proof_row_path']
        data = path.read_bytes()
        self.assertEqual(hashlib.sha256(data).hexdigest(), api['proof_row_sha256'])
        self.assertEqual(data, subprocess.check_output(['git', 'show',
            api['proof_commit']+':'+api['proof_row_path']], cwd=s.ROOT))
        actual = {}
        for line in data.decode().splitlines():
            row = json.loads(line)
            presence = row['bitmap_digest'] is not None
            self.assertEqual(actual.setdefault(row['filter'], presence), presence)
        self.assertEqual(actual, api['observed_types'])
        self.assertEqual(len(actual), 17)
        self.assertEqual(set(api['types']) - set(actual), {'Boost192Multi32K4', 'RocksDBFastLocalBloom64K8Batch32'})
        self.assertTrue(all(api['types'][name] == value for name, value in actual.items()))
        for name, digest in api['source_files'].items():
            source_data = (s.ROOT / name).read_bytes()
            self.assertEqual(hashlib.sha256(source_data).hexdigest(), digest)
            self.assertEqual(source_data, subprocess.check_output(['git', 'show', api['proof_commit']+':'+name], cwd=s.ROOT))
        self.assertEqual({name for name, present in api['types'].items() if present}, s.PUBLIC_BITMAP_FILTERS)
        source, records = fixture()
        s.calculate(records, source)
        # Missing a public Rocks bitmap and inventing an opaque Boost bitmap
        # must both reject; availability is a public API property, not owner class.
        for filter_name, replacement in (('RocksDBFastLocalBloom64K8', None),
                                         ('RocksDBFastLocalBloom64K8Batch32', None),
                                         ('Boost192Multi32K8', 99)):
            bad = copy.deepcopy(records)
            row = next(r for rec in bad for r in rec['rows'] if r['filter'] == filter_name)
            row['bitmap_digest'] = replacement
            with self.assertRaisesRegex(ValueError, 'bitmap availability'):
                s.calculate(bad, source)

    def test_cardinalities_values_rounds_and_render(self):
        source, records = fixture()
        result = s.calculate(records, source)
        self.assertEqual({k: len(v) for k, v in result.items()}, dict(quality=128, alternatives=2304,
            views=72, cells=288, primary_pairs=2016, primary_summary=504, envelopes=576,
            same_byte=864, vectors=2032, samples=16256, identities=616,
            primary_round_sensitivity=1008, same_byte_round_sensitivity=432))
        self.assertEqual(sum(len(r['values_ns_per_key']) for r in result['vectors']), 16256)
        self.assertEqual(sum(len(r['reuse_case_indices']) for r in result['quality']), 488)
        self.assertEqual(len({(r['mapping_id'], r['seed']) for r in result['quality']}), 108)
        pairs = [r for r in result['same_byte'] if r['contrast'] == 'candidate/old_k12']
        self.assertEqual({r['outcome'] for r in pairs}, {'faster', 'slower'})
        self.assertTrue(all(r['direction_changed'] for r in result['same_byte_round_sensitivity']
                            if r['contrast'] == 'candidate/old_k12'))
        self.assertTrue(all(r['outcome'] == 'tie' for r in result['same_byte']
                            if r['contrast'] == 'candidate/native_range' and r['round'] == 1))
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp) / 'report'
            summary = s.write_report(result, output)
            self.assertEqual(summary['counts']['samples'], 16256)
            self.assertEqual(len((output/'samples.csv').read_text().splitlines()), 16257)
            self.assertIn('same data', (output/'REPORT.md').read_text())
            with self.assertRaisesRegex(ValueError, 'preserve'):
                s.write_report(result, output)

    def test_wilson_endpoint_and_exact_boundary(self):
        self.assertAlmostEqual(s.wilson_upper(0, 100), .03699349820698568, places=14)
        self.assertAlmostEqual(s.wilson_upper(50, 100), .5961684696340044, places=14)
        self.assertAlmostEqual(s.wilson_upper(100, 100), 1.)
        for args in ((True, 100), (-1, 100), (101, 100), (0, 0)):
            with self.assertRaises(ValueError):
                s.wilson_upper(*args)

    def test_both_fresh_seeds_required_no_pooling_and_no_pair_deletion(self):
        source, records = fixture()
        # Mean FP rate across seeds is about .0051 (would pass .01 if pooled).
        # One fresh seed independently fails .01 and must disqualify every candidate.
        set_fp(records, source, 'candidate', s.SEEDS[0], 684511)
        result = s.calculate(records, source)
        candidates = [r for r in result['alternatives'] if r['owner'] == 'candidate']
        self.assertTrue(all(not r['both_seed_quality_eligible'] for r in candidates))
        self.assertTrue(all(r['leaders']['candidate'] is None for r in result['views']))
        self.assertEqual(len(result['same_byte']), 864)
        self.assertTrue(all(r['latency_ratio'] is not None for r in result['same_byte']))
        self.assertTrue(any(r['quality']['candidate']['0.01']['current_seed'] for r in result['same_byte']))
        self.assertTrue(all(not r['quality']['candidate']['0.01']['both_seeds'] for r in result['same_byte']))

    def test_actual_memory_and_smaller_allocations_compete(self):
        source, records = fixture()
        for rec in records:
            for row in rec['rows']:
                if row['owner'] == 'candidate':
                    factor = {16: .1, 24: 1., 32: 2.}[row['requested_bpk']]
                    row['samples'] = {k: [v*factor for v in values] for k, values in row['samples'].items()}
        result = s.calculate(records, source)
        self.assertTrue(all(r['leaders']['candidate'].endswith('-16') for r in result['views']))
        for alt in result['alternatives']:
            self.assertEqual(alt['memory_eligible'], alt['actual_bytes']*8 <= alt['keys']*alt['cap_bpk'])
        self.assertTrue(any(not r['memory_eligible'] for r in result['alternatives']))

    def test_fixed_geomean_rival_and_per_cell_envelope_are_distinct(self):
        source, records = fixture()
        chosen = sorted(p['id'] for p in source['selection.json']['points']
            if p['owner'] == 'external' and int(p['geometry']['keys']) == 65536
            and int(p['geometry']['filter_bytes'])*8 <= 65536*16)[:2]
        self.assertEqual(len(chosen), 2)
        for rec in records:
            for row in rec['rows']:
                if row['owner'] == 'external':
                    value = 100.
                    if row['point_id'] == chosen[0]:
                        value = 2.
                    elif row['point_id'] == chosen[1]:
                        value = 1. if rec['case']['round'] == 1 else 9.
                    row['samples'] = {k: [value]*len(v) for k, v in row['samples'].items()}
        result = s.calculate(records, source)
        subset = [r for r in result['envelopes'] if r['keys'] == 65536 and r['cap_bpk'] == 16 and r['rival_group'] == 'external']
        self.assertTrue(all(r['fixed_geomean_rival_point_id'] == chosen[0] for r in subset))
        self.assertTrue(all(r['rival_point_id'] == chosen[1] for r in subset if r['round'] == 1))
        self.assertTrue(all(r['rival_point_id'] == chosen[0] for r in subset if r['round'] == 2))

    def test_null_rivals_and_id_ties_are_retained(self):
        source, records = fixture()
        set_fp(records, source, 'external', s.SEEDS[0], 1 << 25)
        result = s.calculate(records, source)
        self.assertTrue(all(r['leaders']['external'] is None for r in result['views']))
        self.assertTrue(all(r['latency_ratio'] is None and r['outcome'] == 'not_comparable'
            for r in result['primary_pairs'] if r['contrast'].endswith('/external')))
        for view in result['views']:
            candidates = [r for r in result['alternatives'] if r['owner'] == 'production_native' and r['eligible']
                and all(r[k] == view[k] for k in ('keys', 'cap_bpk', 'fpr_ceiling', 'mode'))]
            self.assertEqual(view['leaders']['production_native'], min(r['point_id'] for r in candidates))

    def test_reject_incomplete_duplicate_invalid_and_changed_identity(self):
        source, records = fixture()
        changes = [lambda r: r.pop(), lambda r: r[0]['rows'].pop(),
            lambda r: r[0]['rows'].__setitem__(0, r[0]['rows'][1]),
            lambda r: r[0]['rows'][0]['samples'][s.MODES[0]].__setitem__(0, math.nan),
            lambda r: r[0]['rows'][0]['samples'][s.MODES[0]].__setitem__(0, 0),
            lambda r: r[0]['rows'][0].__setitem__('calibration_negatives', 1 << 24),
            lambda r: r[-1]['rows'][0].__setitem__('inserted_digest', 999),
            lambda r: r[-1]['rows'][0].__setitem__('result_digest', 999),
            lambda r: r[-1]['rows'][0].__setitem__('calibration_fp', 1),
            lambda r: r[0]['rows'][0].__setitem__('actual_bytes', 1),
            lambda r: r[0]['rows'][0].__setitem__('unexpected', True)]
        for change in changes:
            with self.subTest(change=change):
                bad = copy.deepcopy(records)
                change(bad)
                with self.assertRaises(ValueError):
                    s.calculate(bad, source)

    def test_duplicate_json_field_rejected(self):
        with self.assertRaisesRegex(ValueError, 'duplicate'):
            json.loads('{"x":1,"x":2}', object_pairs_hook=s.unique)


if __name__ == '__main__':
    unittest.main()
