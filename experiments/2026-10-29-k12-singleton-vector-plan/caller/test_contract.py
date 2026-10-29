import copy
import json
import unittest
from contract import CASES, MODES, FOUR, TWO, rows

def valid(case):
    n,q=1<<case['power'],1<<case['query_power']
    present=sum(i%100<case['hit']for i in range(q))
    item=dict(keys=n,queries=q,actual_bytes=n*3,hit=case['hit'],batch=case['batch'],repeats=4,
        seed=74381,order=case['order'],measure=False,key_base=17,present=present,absent=q-present,false_positives=0,
        inserted_digest=1,query_digest=2,inserted_hash_digest=3,query_hash_digest=4,bitmap_digest=5,result_digest=6,
        phase_order=[x for row in (FOUR if case['batch']==1 else TWO)for x in row],
        samples={m:[1.0]*4 if i<2 or case['batch']==1 else []for i,m in enumerate(MODES)})
    return [dict(copy.deepcopy(item),filter=name)for name in (['Control','Candidate']if case['order']==0 else ['Candidate','Control'])]

class Contract(unittest.TestCase):
    def test_all_cases(self):
        for case in CASES:rows('\n'.join(map(json.dumps,valid(case))),case)
    def test_order(self):
        with self.assertRaises(ValueError):rows('\n'.join(map(json.dumps,valid(CASES[0])[::-1])),CASES[0])
    def test_duplicate_field(self):
        text='\n'.join(map(json.dumps,valid(CASES[0]))).replace('"keys": 256','"keys": 256,"keys": 256',1)
        with self.assertRaises(ValueError):rows(text,CASES[0])
    def test_phase(self):
        data=valid(CASES[0]);data[0]['phase_order'][0]=2
        with self.assertRaises(ValueError):rows('\n'.join(map(json.dumps,data)),CASES[0])
    def test_unavailable_visible(self):
        data=valid(CASES[2]);data[0]['samples'][MODES[2]]=[1]*4
        with self.assertRaises(ValueError):rows('\n'.join(map(json.dumps,data)),CASES[2])
    def test_complete_semantics(self):
        data=valid(CASES[0]);data[1]['bitmap_digest']+=1
        with self.assertRaises(ValueError):rows('\n'.join(map(json.dumps,data)),CASES[0])
    def test_nonfinite(self):
        data=valid(CASES[0]);data[0]['samples'][MODES[0]][0]=float('nan')
        with self.assertRaises(ValueError):rows('\n'.join(map(json.dumps,data)),CASES[0])
    def test_rows_not_pruned(self):
        with self.assertRaises(ValueError):rows(json.dumps(valid(CASES[0])[0]),CASES[0])

if __name__=='__main__':unittest.main()
