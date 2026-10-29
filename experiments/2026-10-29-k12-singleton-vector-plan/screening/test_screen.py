import copy
import json
import unittest
from unittest.mock import patch
from screen_contract import ledger,key_base,MODES,COUNTS,parse,validate_records
import placement

def synthetic():
    records=[]
    for case in ledger():
        n,q=1<<case['n_exponent'],1<<22;hit=case['hit_percent']
        schedule=((0,1,3,2),(1,2,0,3),(2,3,1,0),(3,0,2,1))if case['batch']==1 else((0,1),(1,0),(1,0),(0,1))
        present=q//100*hit+min(q%100,hit)
        row=dict(keys=n,queries=q,actual_bytes=n*3,hit=hit,batch=case['batch'],repeats=8,seed=case['seed'],
            order=0 if case['api_order'][0]=='Control'else 1,measure=True,key_base=key_base(case['seed'],n,q),
            inserted_digest=1,query_digest=2,inserted_hash_digest=3,query_hash_digest=4,bitmap_digest=5,result_digest=6,
            present=present,absent=q-present,false_positives=0,phase_order=[v for _ in range(2)for step in schedule for v in step],
            samples={mode:[1.0]*8 if index<2 or case['batch']==1 else []for index,mode in enumerate(MODES)})
        records.append(dict(case=case,rows=[dict(copy.deepcopy(row),filter=name)for name in case['api_order']]))
    return records
class Guards(unittest.TestCase):
    def test_immutable_commit(self):
        import pins
        with patch.object(pins.subprocess,'check_output')as call:
            for value in ('HEAD','42f5d62','A'*40,'0'*39,'0'*40+'\n',None):
                with self.assertRaises(ValueError):pins.blob(value,'unused')
            call.assert_not_called()
    def test_full_counts(self):self.assertEqual(validate_records(synthetic()),COUNTS)
    def test_missing_case(self):
        with self.assertRaises(ValueError):validate_records(synthetic()[:-1])
    def test_case_order(self):
        data=synthetic();data[0],data[1]=data[1],data[0]
        with self.assertRaises(ValueError):validate_records(data)
    def test_API_order(self):
        data=synthetic();data[0]['rows'].reverse()
        with self.assertRaises(ValueError):validate_records(data)
    def test_round_identity(self):
        data=synthetic();data[-1]['rows'][0]['query_digest']=91;data[-1]['rows'][1]['query_digest']=91
        with self.assertRaises(ValueError):validate_records(data)
    def test_unavailable_visible(self):
        data=synthetic();record=next(r for r in data if r['case']['batch']==3);record['rows'][0]['samples'][MODES[2]]=[1.0]*8
        with self.assertRaises(ValueError):validate_records(data)
    def test_phase_and_nonfinite(self):
        for which in ('phase','nan'):
            data=synthetic()
            if which=='phase':data[0]['rows'][0]['phase_order'][0]=3
            else:data[0]['rows'][0]['samples'][MODES[0]][0]=float('nan')
            with self.assertRaises(ValueError):validate_records(data)
    def test_duplicate_json(self):
        data=synthetic()[0];text='\n'.join(map(json.dumps,data['rows'])).replace('"measure": true','"measure": true,"measure": true',1)
        with self.assertRaises(ValueError):parse(text,data['case'])
    def test_archived_lease(self):
        value=dict(cpu=3,socket=1,node=1,core=1,affinity=[3],lock_path='/tmp/fastest-bf-socket1.lock',lease_name='socket1-cpu3',
            memory_policy=placement.DESCRIPTION,fd_evidence={'3':'lock: 1: FLOCK ADVISORY WRITE 123 00:00:1 0 EOF'},environment={k:None for k in placement.FORBIDDEN})
        placement.validate(value)
        for key,replacement in [('socket',0),('fd_evidence',{}),('affinity',[2]),('lease_name','socket0-cpu2')]:
            corrupted=copy.deepcopy(value);corrupted[key]=replacement
            with self.assertRaises(ValueError):placement.validate(corrupted)
if __name__=='__main__':unittest.main()
