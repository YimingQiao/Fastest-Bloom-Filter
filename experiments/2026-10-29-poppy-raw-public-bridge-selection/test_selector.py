import copy
import unittest
from selector import BUILD, QUERY, KEYS, calculate, compare_archived, identity


def fixture():
    points = []
    observations = []
    for n, count in zip(KEYS, (25, 22)):
        for j in range(count):
            ident = f'{n}:synthetic-{j}'
            cap = 16+8*(j % 3)
            size = n*cap//8
            constructor = dict(n=n, backing_bytes=size, cache_bytes=0, cache_bits=0,
                               buckets=size//4096, probes=7, fpp_bits='3f847ae147ae147b',
                               policy='none', id=ident, per_bucket_capacity=1000)
            points.append(dict(configuration_id=ident, filter=f'Poppy{j}', owner='poppy_external',
                               keys=n, actual_bytes=size, run_budget_bpk=cap, canonical_constructor=constructor,
                               source_mapping=[n, size//4096, 0, 7], source_alias_ids=[ident, ident+'-alias'],
                               prior_observation={'false_positives': 1 << 26}))
            observations.append(dict(configuration_id=ident, keys=n, filter=f'Poppy{j}', actual_bytes=size,
                                     absent=1 << 26, false_positives=100000 if j == 2 else 0, seed=42,
                                     case_index=0, semantics={}, intervals={}))
    records = []
    for rnd in (1, 2):
        for n in KEYS:
            for cap in (16, 24, 32):
                group = [p for p in points if p['keys'] == n and p['run_budget_bpk'] == cap]
                for batch in (1, 31, 4096):
                    case = dict(index=len(records), round=rnd, keys=n, batch=batch,
                                configuration_ids=[p['configuration_id'] for p in group])
                    rows = []
                    for p in group:
                        j = int(p['filter'].removeprefix('Poppy'))
                        value = 10 if j in (0, 3) else 20+j
                        row = dict(filter=p['filter'], filter_bytes=str(p['actual_bytes']))
                        row.update({metric: str(value) for metric in QUERY+BUILD})
                        rows.append(row)
                    records.append(dict(case=case, rows=rows))
    return dict(configurations=points, over_maximum_byte_cap=[{'reason': 'synthetic exclusion'}]), records, observations


class SelectionTests(unittest.TestCase):
    def test_full_coverage_and_all_ties(self):
        result = calculate(*fixture())
        self.assertEqual(result['counts']['alternatives'], 20304)
        self.assertEqual(result['counts']['views'], 864)
        self.assertEqual(len(result['union']), 4)
        self.assertTrue(all(len(v['leaders']) == 2 for v in result['views']))
        self.assertEqual(len(result['future_public_forms']), 8)

    def test_all_failed_quality_leaves_nulls(self):
        a, b, c = fixture()
        for q in c:
            q['false_positives'] = q['absent']
        result = calculate(a, b, c)
        self.assertEqual(result['counts']['null_views'], 864)
        self.assertEqual(result['union'], [])
        self.assertEqual(result['future_public_forms'], [])

    def test_smaller_allocations_compete_and_failures_stay(self):
        result = calculate(*fixture())
        view = next(v for v in result['views'] if v['cap_bpk'] == 32)
        winners = [a for a in result['alternatives'] if a['view_id'] == view['view_id'] and a['selected_in_view']]
        self.assertTrue(all(a['actual_bytes']*8 == a['keys']*16 for a in winners))
        self.assertTrue(any(a['failure_reasons'] == ['over_byte_cap', 'historical_quality_gate'] for a in result['alternatives']))
        self.assertTrue(any(a['failure_reasons'] == ['slower_eligible'] for a in result['alternatives']))

    def test_each_round_and_contract_can_add_a_constructor(self):
        a, b, c = fixture()
        for record in b:
            if record['case']['round'] == 2 and record['case']['batch'] == 31:
                for row in record['rows']:
                    if row['filter'] == 'Poppy4':
                        row['allocate_hash_insert_ns'] = '1'
        result = calculate(a, b, c)
        for n in KEYS:
            p = next(x for x in result['union'] if x['configuration_id'] == f'{n}:synthetic-4')
            support = [v for v in result['views'] if v['view_id'] in p['supporting_views']]
            self.assertTrue(all(v['round'] == 2 and v['batch'] == 31 and v['metric'] == 'allocate_hash_insert_ns' for v in support))

    def test_prior_audit_count_is_not_formal_quality(self):
        result = calculate(*fixture())
        self.assertTrue(any(q['historical_gates'][2]['passed'] for q in result['quality']))
        self.assertEqual(len(result['quality']), 47)
        self.assertTrue(all(q['absent'] == 1 << 26 for q in result['quality']))

    def test_future_forms_preserve_exact_constructor_without_qualification(self):
        a, b, c = fixture()
        before = copy.deepcopy(a)
        result = calculate(a, b, c)
        self.assertEqual(a, before)
        ids = [f['future_mapping_id'] for f in result['future_public_forms']]
        self.assertEqual(len(ids), len(set(ids)))
        for form in result['future_public_forms']:
            self.assertEqual(form['qualification_status'], 'unmeasured')
            self.assertNotIn('historical_wilson95_upper', form)
            source = next(p for p in a['configurations'] if p['configuration_id'] == form['configuration_id'])
            self.assertEqual(form['canonical_constructor'], source['canonical_constructor'])
            self.assertEqual(form['source_alias_ids'], source['source_alias_ids'])

    def test_missing_duplicate_quality_and_constructor_drift_rejected(self):
        for fault in ('missing_row', 'duplicate_quality', 'wrong_denominator', 'constructor'):
            with self.subTest(fault=fault):
                a, b, c = fixture()
                if fault == 'missing_row': b[0]['rows'].pop()
                if fault == 'duplicate_quality': c.append(copy.deepcopy(c[0]))
                if fault == 'wrong_denominator': c[0]['absent'] = 1 << 24
                if fault == 'constructor': a['configurations'][0]['canonical_constructor']['backing_bytes'] += 1
                with self.assertRaises(ValueError): calculate(a, b, c)

    def test_archived_ties_and_quality_provenance_are_checked(self):
        data = calculate(*fixture())
        by_view = {}
        for a in data['alternatives']:
            if a['selected_in_view']:
                by_view.setdefault(a['view_id'], []).append(dict(a, latency_ns=a['historical_latency_ns']))
        old = dict(views=[{**v, 'leaders': {'poppy_external': sorted(by_view.get(v['view_id'], []), key=lambda a: (a['actual_bytes'], a['configuration_id']))}} for v in data['views']],
                   quality=[dict(q, owner='poppy_external', wilson95_upper=q['historical_wilson95_upper']) for q in data['quality']])
        compare_archived(data, old)
        broken = copy.deepcopy(old)
        broken['views'][0]['leaders']['poppy_external'].pop()
        with self.assertRaises(ValueError): compare_archived(data, broken)
        broken = copy.deepcopy(old)
        broken['quality'][0]['false_positives'] += 1
        with self.assertRaises(ValueError): compare_archived(data, broken)


if __name__ == '__main__':
    unittest.main()
