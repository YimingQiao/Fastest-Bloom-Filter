"""Synthetic complete-ledger corruption guards; no Bloom process."""
import copy
import csv
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
import contract
from test_preflight import mock_rows

class Checks(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.addCleanup(self.tmp.cleanup);self.out=Path(self.tmp.name)
        self.rows=mock_rows();self.meta=dict(complete=True,final_frozen_inputs_equal=True,cases=[],counts=dict(rows=24,cases=12,family_geometry_size_seed_quality_records=8,pooled=False))
        self.binary=Path(contract.commands()[0]['command'][0]);self.commit='a'*40
        published=json.loads((contract.HERE/'protocol.json').read_text())
        self.meta.update(source_commit=self.commit,proof_commit=published['proof_commit'],executable=str(self.binary),executable_sha256=published['performance_executable_sha256'],protocol_sha256=contract.sha(contract.HERE/'protocol.json'),corrected_selection_sha256=contract.sha(contract.STAGE/'preflight/corrected-selection.json'),host=json.loads((contract.STAGE/'validation-v1/metadata.json').read_text())['host'],affinity=[3],numa_policy=published['numa_policy'],lease=dict(cpu=3,socket=1,lock_path=published['socket_lock'],inherited_lock_descriptors=[3]),environment={k:None for k in ['LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','RUSTFLAGS','RUSTDOCFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']})
        self.meta['environment']['BF_SOCKET_LEASE']='socket1-cpu3' 
        def csvfile(path,rows):
            with path.open('w',newline='')as stream:
                writer=csv.DictWriter(stream,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
        for i,item in enumerate(contract.commands()):
            record=dict(case=item['case'],command=item['command'],expected_filter_order=item['expected_filter_order'],raw_input_intervals=item['raw_intervals'],complete=True,returncode=0,rows=2)
            for stream in ['stdout','stderr']:record[stream]=f'case-{i:02d}.'+stream
            csvfile(self.out/record['stdout'],self.rows[2*i:2*i+2]);(self.out/record['stderr']).write_text('sbbf-rs 0.2.8 backend: Avx2Filter\n')
            for stream in ['stdout','stderr']:record[stream+'_sha256']=contract.sha(self.out/record[stream])
            self.meta['cases'].append(record)
        csvfile(self.out/'results.csv',self.rows);contract.save(self.out/'quality.json',contract.quality(self.rows))
        self.meta.update(results_sha256=contract.sha(self.out/'results.csv'),quality_sha256=contract.sha(self.out/'quality.json'))
        contract.save(self.out/'metadata.json',self.meta)
    def check(self):return contract.audit(self.out,self.meta,self.binary,self.commit)
    def test_complete24_and_nested_counts(self):
        self.assertEqual(len(self.check()[0]),24);self.assertIsInstance(self.meta['cases'],list)
        self.assertEqual(self.meta['counts']['cases'],12)
    def test_missing_duplicate_wrong_command_and_incomplete(self):
        original=copy.deepcopy(self.meta)
        for bad in ['missing','duplicate','command','incomplete']:
            self.meta=copy.deepcopy(original)
            if bad=='missing':self.meta['cases'].pop()
            elif bad=='duplicate':self.meta['cases'][1]=self.meta['cases'][0]
            elif bad=='command':self.meta['cases'][0]['command'][-1]='27'
            else:self.meta['complete']=False
            with self.assertRaises(ValueError,msg=bad):self.check()
    def test_bad_raw_aggregate_and_order(self):
        original=(self.out/'results.csv').read_bytes();(self.out/'results.csv').write_text('bad')
        with self.assertRaises(ValueError):self.check()
        (self.out/'results.csv').write_bytes(original)
        self.meta['cases'][0]['expected_filter_order'].reverse()
        with self.assertRaises(ValueError):self.check()
    def test_unpooled_quality_and_any_seed_failure(self):
        q=contract.quality(self.rows)
        self.assertEqual(len(q['api_size_seed_records']),8);self.assertEqual(len(q['family_size_all_seed_gates']),4)
        self.assertTrue(all(r['negatives']==1<<24 for r in q['api_size_seed_records']))
        changed=copy.deepcopy(self.rows);first=changed[0]
        for row in changed:
            if tuple(row[k]for k in ['filter','keys','seed'])==tuple(first[k]for k in ['filter','keys','seed']):row['calibration_false_positives']='2000'
        q=contract.quality(changed)
        self.assertEqual(sum(not r['current_seed_pass']for r in q['api_size_seed_records']),1)
        self.assertEqual(sum(not r['all_fresh_seeds_pass']for r in q['family_size_all_seed_gates']),1)
    def test_metadata_identity_corruption(self):
        original=copy.deepcopy(self.meta)
        changes=dict(source_commit='b'*40,proof_commit='b'*40,executable='/wrong',executable_sha256='0'*64,protocol_sha256='0'*64,corrected_selection_sha256='0'*64,host={},affinity=[2],numa_policy='membind',lease=dict(cpu=2,socket=0,lock_path='/tmp/fastest-bf-socket0.lock',inherited_lock_descriptors=[3]),environment={})
        for field,value in changes.items():
            self.meta=copy.deepcopy(original);self.meta[field]=value
            with self.assertRaises(ValueError,msg=field):self.check()
    def test_wilson_endpoints_and_optimized_python(self):
        self.assertEqual(contract.wilson(0,100)[0],0);self.assertEqual(contract.wilson(100,100)[1],1)
        result=subprocess.run([sys.executable,'-O',str(contract.HERE/'run.py'),'--help'],capture_output=True,text=True)
        self.assertNotEqual(result.returncode,0);self.assertIn('without -O',result.stderr);self.assertFalse(result.stdout)

if __name__=='__main__':unittest.main()
