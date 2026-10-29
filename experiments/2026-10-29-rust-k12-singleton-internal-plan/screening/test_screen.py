import copy
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import screen_contract as c
import audit
import pins
import placement

def records():
    result=[]
    for case in c.ledger():
        rows=[]
        for arm in case['api_order']:
            rows.append(dict(filter=arm,keys=case['keys'],queries=case['queries'],batch=case['batch'],hit=case['hit'],
                seed=case['seed'],repeats=8,filter_bytes=case['filter_bytes'],backend='avx512',
                input_digest=case['keys']+case['seed']+case['hit'],insert_digest=case['keys']+case['seed'],
                bitmap_digest=case['keys']+case['seed']+2,output_digest=case['keys']+case['seed']+case['hit']+3,
                scratch_bytes=min(case['batch'],case['queries'])*8,phase_order=copy.deepcopy((c.FOUR if case['batch']==1 else c.TWO)*2),
                trials_ns=[[1.0]*8 for _ in case['metrics']],round=case['round'],stage='measure',calibration_queries=0))
        result.append(dict(case=case,rows=rows))
    return result

class Guards(unittest.TestCase):
    def test_complete_fixed_grid(self):
        self.assertEqual(c.validate_records(records()),c.COUNTS)
    def test_row_order_and_partial_success(self):
        r=records()[0]
        for rows in [[],r['rows'][:1],list(reversed(r['rows']))]:
            with self.assertRaises(ValueError):c.parse('\n'.join(json.dumps(x) for x in rows),r['case'])
    def test_backend_geometry_phase_and_repeat(self):
        for key,value in [('backend','scalar'),('filter_bytes',12),('repeats',4),('stage','check'),('round',2),('phase_order',[[True]])]:
            r=records()[0];r['rows'][0][key]=value
            with self.subTest(key=key),self.assertRaises(ValueError):c.parse('\n'.join(json.dumps(x) for x in r['rows']),r['case'])
        r=records()[0];r['rows'][0]['phase_order'][0][0]=False
        with self.assertRaises(ValueError):c.parse('\n'.join(json.dumps(x) for x in r['rows']),r['case'])
    def test_nonfinite_and_bool_sample(self):
        for value in [0,-1,float('nan'),float('inf'),True]:
            r=records()[0];r['rows'][0]['trials_ns'][0][0]=value
            with self.assertRaises(ValueError):c.parse('\n'.join(json.dumps(x) for x in r['rows']),r['case'])
    def test_shared_query_and_bitmap(self):
        for field,index in [('input_digest',1),('bitmap_digest',4)]:
            r=records()
            for row in r[index]['rows']:row[field]+=1
            with self.assertRaises(ValueError):c.validate_records(r)
    def test_exact_commit_gate(self):
        for commit in ['HEAD','f23d93d','A'*40,'0'*39]:
            with self.assertRaises(ValueError):pins.blob(commit,'irrelevant')
        r=records()[0]
        text='\n'.join(json.dumps(row).replace('"keys":','"keys":0,"keys":',1) for row in r['rows'])
        with self.assertRaises(ValueError):c.parse(text,r['case'])
    def test_full_raw_replay_and_wrong_profile(self):
        r=records();source='a'*40
        closure=dict(executables={p:dict(path='/fixed/'+p,sha256=('b' if p=='native' else 'c')*64) for p in ['native','portable']})
        place=dict(cpu=3,socket=1,node=1,core=1,affinity=[3],lock_path='/tmp/fastest-bf-socket1.lock',lease_name='socket1-cpu3',
                   memory_policy=placement.DESCRIPTION,fd_evidence={'3':'lock: 1: FLOCK ADVISORY WRITE 123 00:01:2 0 EOF\n'},
                   environment={k:None for k in placement.FORBIDDEN})
        with tempfile.TemporaryDirectory() as temp:
            root=Path(temp);entries=[]
            for index,record in enumerate(r):
                out=root/f'case-{index:03d}.stdout';err=root/f'case-{index:03d}.stderr'
                out.write_text('\n'.join(json.dumps(x) for x in record['rows'])+'\n');err.write_bytes(b'')
                descriptor=closure['executables'][record['case']['profile']]
                entries.append(dict(case=record['case'],argv=audit.command(descriptor['path'],record['case']),inherited_lock_fds=[3],
                    exit_code=0,binary_sha256=descriptor['sha256'],stdout=out.name,stderr=err.name,stdout_sha256=pins.sha(out),stderr_sha256=pins.sha(err)))
            metadata=dict(complete=True,source_commit=source,initial_freeze=closure,final_freeze=closure,
                          placement=place,final_placement=place,cases=entries,counts=c.COUNTS)
            (root/'records.json').write_text(json.dumps(r));(root/'metadata.json').write_text(json.dumps(metadata))
            with patch.object(audit,'RESULTS',root),patch.object(audit,'verify',return_value=closure):
                self.assertEqual(len(audit.validate_directory(source)[1]),96)
                metadata['cases'][0]['argv'][6]='/fixed/portable'
                (root/'metadata.json').write_text(json.dumps(metadata))
                with self.assertRaises(ValueError):audit.validate_directory(source)
    def test_lease_metadata(self):
        bad=dict(cpu=3,socket=1,node=1,core=1,affinity=[3],lock_path='/tmp/fastest-bf-socket1.lock',lease_name='socket1-cpu3',
                 memory_policy=placement.DESCRIPTION,fd_evidence={'3':'pos: 0\n'},environment={k:None for k in placement.FORBIDDEN})
        with self.assertRaises(ValueError):placement.validate(bad)

if __name__=='__main__':unittest.main()
