"""Synthetic regressions; no compiler, filter, worker or timing invocation."""
import copy,json,unittest
import checks as c

def fixture(case):
    canonical=c.canonical_case(case);g=c.original.geometry('modern',canonical['filter'],case['power'],case['cap'])
    r={k:str(v)for k,v in g.items()};r.update(worker=c.WORKER,filter=case['filter'])
    if case['filter']in c.ALIASES:r['surface']='upstream_raw4_input_pointer_single_v1'
    q=1<<case['qpower'];present=c.original.present(q,case['hit'])
    r.update(public_metadata=json.dumps({'key_bytes':4,'page_level':g['unit_bytes'].bit_length()-1})if case['filter'].startswith('Page')else'{}',
      queries=str(q),seed=str(case['seed']),hit_percent=str(case['hit']),present_queries=str(present),absent_queries=str(q-present),
      calibration_absent_queries=str(1<<case['calpower']),calibration_false_positives='0',false_positives='0',
      result_checksum='1',inserted_checksum='2',query_checksum='3',calibration_checksum='4',repeats='0',query_phase_order='untimed',
      build_repeats='0',insert_ns='nan',allocate_insert_ns='nan',hash_insert_ns='nan',allocate_hash_insert_ns='nan',
      build_hash_scratch_bytes=str(0 if case['filter'].startswith('Page')else g['keys']*8),filter_build_scratch_bytes='0',adapter_object_bytes='100')
    for i,m in enumerate(c.original.MODES):
        r.update({m+s:'nan'for s in ('_ns','_min_ns','_max_ns','_trials_ns')})
        r[m+'_scratch_bytes']=str(0 if case['filter'].startswith('Page')else (0,8,32768)[i])
    return r

class Checks(unittest.TestCase):
    def test_exact_grid(self):
        cases=c.cases();self.assertEqual(len(cases),48)
        self.assertEqual(len({tuple(sorted(x.items()))for x in cases}),48)
        self.assertEqual({x['filter']for x in cases},set(c.NAMES))
    def test_canonical_contract_preserves_geometry(self):
        for case in c.cases():
            row=fixture(case);self.assertIs(c.validate(row,case),row)
            broken=dict(row,filter_bytes=str(int(row['filter_bytes'])+1))
            with self.assertRaises(ValueError):c.validate(broken,case)
    def test_pointer_alias_parity_not_pooling(self):
        rows=[fixture(x)for x in c.cases()]
        self.assertEqual(c.parity(rows+copy.deepcopy(rows)),30)
        bad=copy.deepcopy(rows);next(r for r in bad if r['filter']in c.ALIASES)['calibration_false_positives']='1'
        with self.assertRaises(ValueError):c.parity(rows+bad)
    def test_surface_worker_and_scratch(self):
        case=next(x for x in c.cases()if x['filter']in c.ALIASES);row=fixture(case)
        for k,v in [('surface','upstream_raw4_byte_api'),('worker','modern'),('raw_single_scratch_bytes','4')]:
            with self.assertRaises(ValueError):c.validate(dict(row,**{k:v}),case)
    def test_old_baseline_semantics(self):
        rows=[fixture(x)for x in c.cases()];baseline=[c.canonical_row(x)for x in rows]
        self.assertEqual(c.compare_baseline(rows,baseline),30)
        baseline[0]=dict(baseline[0],adapter_object_bytes='101')
        with self.assertRaises(ValueError):c.compare_baseline(rows,baseline)

if __name__=='__main__':unittest.main()
