import copy
import json
import unittest
import tempfile
from pathlib import Path
import contract as c
import validate


def fixture(case,allocation=False):
    points,base=c.selected(case,allocation);rows=[]
    for p in points:
        g=p['geometry']
        row=dict(point_id=p['id'],filter=g['filter'],owner=p['owner'],keys=int(g['keys']),requested_bpk=int(g['requested_bpk']),
                 actual_bytes=int(g['filter_bytes']),budget_bytes=int(g['budget_bytes']),logical_bytes=int(g['logical_bytes']),
                 unit_bytes=int(g['unit_bytes']),unit_count=int(g['unit_count']),effective_probes=int(g['effective_probes']),
                 constructor_argument=int(g['constructor_argument']),native_constructor_bpk=int(g.get('native_constructor_bpk',0)),
                 geometry_kind=g['geometry_kind'],probe_policy=g['probe_policy'])
        if allocation:row['allocation_only']=True
        else:
            q=1<<case['query_power'];present=q//100*case['hit']+min(q%100,case['hit'])
            row.update(queries=q,hit=case['hit'],batch=case['batch'],repeats=4,seed=74381,reverse_jobs=bool(case['order']),
                       measure=False,key_base=base,present=present,absent=q-present,false_positives=0,
                       query_scratch_bytes=8*case['batch'],calibration_negatives=(1<<case['calibration_power']) if case['calibration_power'] else 0,
                       calibration_fp=0,calibration_digest=1 if case['calibration_power'] else None,
                       inserted_digest=1,query_digest=2,inserted_hash_digest=3,query_hash_digest=4,result_digest=5,
                       bitmap_digest=6 if p['owner'] in ('candidate','old_k12','native_range') else None,
                       phase_order=[v for r in (c.FOUR if case['batch']==1 else c.TWO) for v in r],
                       samples={m:[1.0]*4 if i<2 or case['batch']==1 else [] for i,m in enumerate(c.MODES)})
        rows.append(row)
    return rows


def lines(rows):return '\n'.join(json.dumps(r) for r in rows)+'\n'


class Guards(unittest.TestCase):
    def test_finite_counts_and_fake_rows(self):
        self.assertEqual(sum(len(c.parse(lines(fixture(x)),x)) for x in c.CASES),122)
        self.assertEqual(sum(len(c.parse(lines(fixture(x,True)),x,True)) for x in c.ALLOCATION_CASES),64)
        types={p['geometry']['filter'] for p in c.PLAN['points']};self.assertEqual(len(types),19)

    def test_exact_order_and_completeness(self):
        case=c.CASES[0];rows=fixture(case)
        for invalid in (rows[:-1],list(reversed(rows)),rows+[rows[0]]):
            with self.assertRaises(ValueError):c.parse(lines(invalid),case)
        a,_=c.selected(c.CASES[0]);b,_=c.selected(c.CASES[1]);self.assertEqual(a,list(reversed(b)))

    def test_geometry_cannot_be_replaced_by_budget(self):
        case=c.CASES[0];rows=fixture(case)
        row=next(r for r in rows if r['filter']=='Boost192Multi32K8')
        self.assertNotEqual(row['actual_bytes'],row['budget_bytes'])
        row['actual_bytes']=row['budget_bytes']
        with self.assertRaises(ValueError):c.parse(lines(rows),case)

    def test_no_missing_or_bad_trial_outputs(self):
        case=c.CASES[0]
        for value in ([],[1.0]*3,[1.0,1.0,float('nan'),1.0]):
            rows=fixture(case);rows[0]['samples'][c.MODES[0]]=value
            with self.assertRaises(ValueError):c.parse(lines(rows),case)

    def test_alias_false_positive_mismatch(self):
        case=c.CASES[0];rows=fixture(case)
        row=next(r for r in rows if r['owner']=='candidate');row['calibration_fp']=1
        with self.assertRaisesRegex(ValueError,'alias'):c.parse(lines(rows),case)

    def test_zero_calibration_and_duplicate_keys(self):
        case=c.CASES[2];rows=fixture(case);rows[0]['calibration_digest']=123
        with self.assertRaises(ValueError):c.parse(lines(rows),case)
        with self.assertRaisesRegex(ValueError,'duplicate'):c.unique([('x',1),('x',2)])

    def test_skip_matches_literal_rng(self):
        for count in (0,1,2,31,4096):
            a=c.Random(74381);b=c.Random(74381)
            for _ in range(count):a.next()
            b.advance(count);self.assertEqual(a.next(),b.next())

    def test_unknown_consumed_repository_input_rejected(self):
        with tempfile.TemporaryDirectory() as folder:
            dep=Path(folder)/'main.d';dep.write_text('main.o: '+str(validate.ROOT/'README.md')+'\n')
            with self.assertRaisesRegex(ValueError,'unprepared repository'):
                validate.consumed_inputs(dep,{})

    def test_full_source_commit_required(self):
        for value in ('HEAD','61f0689','a'*39,'F'*40):
            with self.assertRaisesRegex(ValueError,'full immutable'):
                validate.blob(value,'README.md')


if __name__=='__main__':unittest.main()
