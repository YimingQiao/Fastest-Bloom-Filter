"""Synthetic row/source guards only; never compile or construct a filter."""
import copy
import json
from pathlib import Path
import tempfile
import unittest
import contract as c
import source_guard as g

def fixture(case,allocation=False):
    points,base=c.selected(case,allocation);rows=[]
    for point in points:
        r=c.geometry(point)
        if allocation:r['allocation_only']=True;rows.append(r);continue
        q=1<<case['query_power'];present=q//100*case['hit']+min(q%100,case['hit'])
        r.update(queries=q,hit=case['hit'],batch=case['batch'],repeats=4,seed=74381,
            reverse_jobs=bool(case['order']),measure=False,key_base=base,present=present,absent=q-present,
            query_scratch_bytes=case['batch']*8,calibration_negatives=(1<<case['calibration_power'])if case['calibration_power']else 0,
            inserted_digest=11,query_digest=22,inserted_hash_digest=33,query_hash_digest=44,result_digest=55,
            false_positives=0,calibration_fp=0,calibration_digest=66 if case['calibration_power']else None,
            bitmap_digest=77 if point['public_data_available']else None,
            phase_order=[m for trial in (c.FOUR if case['batch']==1 else c.TWO)for m in trial],
            samples={name:[1.0]*4 if i<2 or case['batch']==1 else []for i,name in enumerate(c.MODES)})
        rows.append(r)
    return rows

def stream(rows):return '\n'.join(map(json.dumps,rows))+'\n'

class Guards(unittest.TestCase):
    def test_fixed_proof_counts_and_parity(self):
        records=[]
        for case in c.CASES:
            rows=c.parse(stream(fixture(case)),case);records.append(dict(case=case,rows=rows))
        self.assertEqual(sum(len(r['rows'])for r in records),30);c.cross_batch(records)
        self.assertEqual(sum(len(c.parse(stream(fixture(case,True)),case,True))for case in c.ALLOCATION_CASES),16)
    def test_empty_missing_duplicate_or_reordered_rows_reject(self):
        rows=fixture(c.CASES[0])
        for changed in ([],rows[:-1],rows+[rows[0]],list(reversed(rows))):
            with self.assertRaises(ValueError):c.parse(stream(changed),c.CASES[0])
    def test_data_trait_not_ownership(self):
        rows=fixture(c.CASES[0]);native=next(r for r in rows if r['owner']=='production_native')
        self.assertIs(native['bitmap_available'],False)
        for field,value in (('bitmap_digest',123),('bitmap_available',True)):
            bad=copy.deepcopy(rows);next(r for r in bad if r['point_id']==native['point_id'])[field]=value
            with self.assertRaises(ValueError):c.parse(stream(bad),c.CASES[0])
    def test_actual_capacity_and_present_count_reject(self):
        for field in ('actual_bytes','logical_bytes','unit_count','present'):
            rows=fixture(c.CASES[0]);rows[0][field]+=1
            with self.assertRaises(ValueError):c.parse(stream(rows),c.CASES[0])
    def test_schedule_trials_and_unguarded_output_reject(self):
        for change in ('phase','trial','digest','nan'):
            rows=fixture(c.CASES[0])
            if change=='phase':rows[0]['phase_order'].reverse()
            elif change=='trial':rows[0]['samples'][c.MODES[0]].pop()
            elif change=='digest':rows[0]['query_digest']+=1
            else:rows[0]['samples'][c.MODES[0]][0]=float('nan')
            with self.assertRaises(ValueError):c.parse(stream(rows),c.CASES[0])
    def test_proven_alias_and_cross_batch_drift_reject(self):
        rows=fixture(c.CASES[0]);row=next(r for r in rows if r['filter']=='FastFilterFixed16SingleV1' and r['actual_bytes']==131072)
        row['result_digest']+=1
        with self.assertRaises(ValueError):c.parse(stream(rows),c.CASES[0])
        records=[dict(case=case,rows=fixture(case))for case in c.CASES]
        records[1]['rows'][0]['result_digest']+=1
        with self.assertRaises(ValueError):c.cross_batch(records)
    def test_duplicate_json_and_bad_optional_digest_reject(self):
        text=stream(fixture(c.CASES[0])).replace('"keys": 65536','"keys": 65536, "keys": 65536',1)
        with self.assertRaises(ValueError):c.parse(text,c.CASES[0])
        rows=fixture(c.CASES[1]);rows[0]['calibration_digest']=1
        with self.assertRaises(ValueError):c.parse(stream(rows),c.CASES[1])
    def test_consumed_repository_input_requires_prepared_identity(self):
        with tempfile.TemporaryDirectory()as folder:
            dep=Path(folder)/'main.d';dep.write_text('main.o: '+str(c.HERE/'main.cpp')+'\n')
            with self.assertRaisesRegex(ValueError,'unprepared'):g.consumed(dep,{})
    def test_semantic_references_exclude_latency(self):
        references=json.loads((c.HERE/'old-reference.json').read_text())
        self.assertEqual(set(references),{'normal','asan'})
        for group in references.values():
            self.assertEqual(len(group['rows']),7)
            self.assertTrue(all('samples'not in row for row in group['rows']))

    def test_new_pipeline_mapping_alias_rejects_output_drift(self):
        rows=fixture(c.CASES[0])
        candidate=next(r for r in rows if r['owner']=='candidate')
        control=next(r for r in rows if r['owner']=='range_control')
        self.assertEqual(candidate['actual_bytes'],control['actual_bytes'])
        for field in ('bitmap_digest','false_positives','result_digest','calibration_fp'):
            bad=copy.deepcopy(rows)
            next(r for r in bad if r['owner']=='candidate')[field]+=1
            with self.assertRaises(ValueError):c.parse(stream(bad),c.CASES[0])

if __name__=='__main__':unittest.main()
