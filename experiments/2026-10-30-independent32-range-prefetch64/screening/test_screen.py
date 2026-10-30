"""Finite synthetic producer/row/raw audit guards; no actual filter or latency input."""
import copy
import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import audit
import pins
import placement
import screen_contract as c

def digest(*parts):return int.from_bytes(hashlib.sha256(repr(parts).encode()).digest()[:8],'little')
def fixtures():
    result=[]
    for case in c.ledger():
        points,base=c.guard.selected(case);q=1<<22;present=q//100*50+min(q%100,50);rows=[]
        for point in points:
            n=1<<case['power'];seed=case['seed'];mapping=point['mapping_id'];row=c.guard.geometry(point)
            row.update(queries=q,hit=50,batch=case['batch'],repeats=8,seed=seed,reverse_jobs=bool(case['order']),measure=True,
                key_base=base,present=present,absent=q-present,false_positives=0,
                inserted_digest=digest(n,seed,'insert'),inserted_hash_digest=digest(n,seed,'insert-hash'),
                query_digest=digest(n,seed,'query'),query_hash_digest=digest(n,seed,'query-hash'),
                result_digest=digest(mapping,seed,'result'),bitmap_digest=digest(mapping,seed,'bitmap')if point['public_data_available']else None,
                calibration_negatives=(1<<26)if case['calibration_power']else 0,calibration_fp=123 if case['calibration_power']else 0,
                calibration_digest=digest(mapping,seed,'calibration')if case['calibration_power']else None,
                query_scratch_bytes=case['batch']*8,
                phase_order=[mode for phase in (c.guard.FOUR if case['batch']==1 else c.guard.TWO)*2 for mode in phase],
                samples={mode:[1.0+i/10 for i in range(8)]if j<2 or case['batch']==1 else[]for j,mode in enumerate(c.guard.MODES)})
            rows.append(row)
        result.append(dict(case=case,rows=rows))
    return result

class ScreenGuards(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.good=fixtures()
    def test_complete_counts_known_groups_and_reuse(self):
        counts,quality=c.validate_records(self.good)
        self.assertEqual(counts,dict(processes=24,rows=192,query_vectors=512,query_samples=4096,
            calibration_rows=32,reuse_rows=160,api_quality_records=32,known_alias_records=26))
        self.assertEqual(sum(len(r['reuse_case_indices'])for r in quality['api_records']),160);self.assertFalse(quality['pooling'])
    def test_exact_ledger_and_row_order(self):
        for action in ('missing','empty','reversed','duplicate'):
            bad=copy.deepcopy(self.good)
            if action=='missing':bad.pop()
            elif action=='empty':bad[0]['rows']=[]
            elif action=='reversed':bad[0]['rows'].reverse()
            else:bad[0]['rows'].append(bad[0]['rows'][0])
            with self.assertRaises(ValueError):c.validate_records(bad)
    def test_reuse_identity_and_no_extra_calibration(self):
        for field in ('inserted_digest','result_digest','calibration_fp'):
            bad=copy.deepcopy(self.good)
            for row in bad[1]['rows']:row[field]^=1
            with self.assertRaises(ValueError):c.validate_records(bad)
    def test_alias_availability_actual_bytes(self):
        for action in ('alias','pipeline','opaque','bytes'):
            bad=copy.deepcopy(self.good)
            if action=='alias':
                row=next(r for r in bad[0]['rows']if r['filter']=='FastFilterFixed16SingleV1'and r['actual_bytes']==131072);row['calibration_fp']+=1
            elif action=='pipeline':
                row=next(r for r in bad[1]['rows']if r['owner']=='candidate');row['result_digest']^=1
            elif action=='opaque':
                row=next(r for r in bad[0]['rows']if not r['bitmap_available']);row['bitmap_digest']=123
            else:bad[0]['rows'][0]['actual_bytes']+=1
            with self.assertRaises(ValueError):c.validate_records(bad)
    def test_phase_samples_schema_and_duplicate_json(self):
        for action in ('phase','samples','nan','field'):
            bad=copy.deepcopy(self.good);row=bad[0]['rows'][0]
            if action=='phase':row['phase_order'].reverse()
            elif action=='samples':row['samples']['generic_pure'].pop()
            elif action=='nan':row['samples']['generic_pure'][0]=float('nan')
            else:row['unexpected']=1
            with self.assertRaises(ValueError):c.validate_records(bad)
        text=json.dumps(self.good[0]['rows'][0])[:-1]+',"keys":0}'
        with self.assertRaisesRegex(ValueError,'duplicate'):c.parse(text,self.good[0]['case'])
    def test_partial_prefix_not_complete_and_full_commit_required(self):
        c.validate_records(self.good[:1],complete=False)
        with self.assertRaises(ValueError):c.validate_records(self.good[:1])
        with patch.object(pins.subprocess,'check_output')as git:
            for ref in ('HEAD','aa21a91a','A'*40):
                with self.assertRaises(ValueError):pins.blob(ref,'unused')
            git.assert_not_called()
    def test_module_constants_remain_valid(self):
        self.assertEqual(c.guard.CASES[0]['seed'],74381)
        self.assertEqual(c.guard.CASES[0]['repeats'],4)
        self.assertEqual(self.good[0]['rows'][0]['seed'],982451653)
        self.assertEqual(self.good[0]['rows'][0]['repeats'],8)
    def test_exact_command_raw_and_lease_replay(self):
        binary='/frozen/normal/main';closure={'normal_executable':{'path':binary,'sha256':'a'*64}}
        lease=dict(cpu=3,socket=1,node=1,core=1,affinity=[3],lock_path='/tmp/fastest-bf-socket1.lock',lease_name='socket1-cpu3',
            memory_policy=placement.DESCRIPTION,fd_evidence={'3':'lock: 1: FLOCK ADVISORY WRITE 123 00:01:1 0 EOF\n'},environment={k:None for k in placement.FORBIDDEN})
        counts,quality=c.validate_records(self.good)
        with tempfile.TemporaryDirectory()as directory:
            out=Path(directory);cases=[]
            for index,record in enumerate(self.good):
                stdout=f'case-{index:03d}.stdout';stderr=f'case-{index:03d}.stderr'
                (out/stdout).write_text('\n'.join(map(json.dumps,record['rows']))+'\n');(out/stderr).write_text('')
                cases.append(dict(case=record['case'],argv=audit.command(binary,record['case']),exit_code=0,binary_sha256='a'*64,
                    inherited_lock_fds=[3],stdout=stdout,stderr=stderr,stdout_sha256=pins.sha(out/stdout),stderr_sha256=pins.sha(out/stderr)))
            good=dict(complete=True,source_commit='1'*40,initial_freeze=closure,final_freeze=closure,
                placement=lease,final_placement=lease,cases=cases,counts=counts)
            for name,data in (('metadata.json',good),('records.json',self.good),('quality.json',quality)):(out/name).write_text(json.dumps(data))
            with patch.object(audit,'RESULTS',out),patch.object(audit,'verify',return_value=closure):
                audit.validate_directory('1'*40)
                for action in ('argv','exit','fd','sha','lease','incomplete'):
                    bad=copy.deepcopy(good)
                    if action=='argv':bad['cases'][0]['argv'][2]='--membind=0'
                    elif action=='exit':bad['cases'][0]['exit_code']=1
                    elif action=='fd':bad['cases'][0]['inherited_lock_fds']=[]
                    elif action=='sha':bad['cases'][0]['stdout_sha256']='0'*64
                    elif action=='lease':bad['placement']['node']=0
                    else:bad['complete']=False
                    (out/'metadata.json').write_text(json.dumps(bad))
                    with self.assertRaises(ValueError):audit.validate_directory('1'*40)

if __name__=='__main__':unittest.main()
