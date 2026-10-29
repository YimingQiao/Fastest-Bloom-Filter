"""Synthetic full296 and lineage corruption tests; no Bloom process."""
import copy
import csv
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
import contract as c
from freeze import PROOF,BINARY_SHA

def fake_rows():
    out=[]
    for case in c.cases():
        geometry=c.geometry(case)
        for name in c.order(case):
            base=geometry[name]
            if name==c.CANDIDATE:
                old=next(r for r in c.parent_rows()if int(r['keys'])==1<<case['key_power']and int(r['requested_bpk'])==case['budget_bpk']);row={k:old.get(k,'')for k in c.schema()};row.update(base);row.update(filter=name,false_positives='0',fpr='0',calibration_false_positives='0',result_checksum='444',input_mode='prehashed',filter_build_scratch_bytes='0')
            else:row={k:base.get(k,'')for k in c.schema()}
            row={k:row[k]for k in c.schema()}
            row.update(budget_mode='exact_backing_bytes',batch=str(case['batch']),repeats='6',query_repeats='6',build_repeats='0',measurement_mode='query_only',harness_hash_scratch_bytes=str(8*case['batch']),query_phase_order='P>H;H>P;P>H;H>P;P>H;H>P')
            for metric in('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns'):row[metric]='nan'
            for metric in('lookup','hash_lookup'):
                raw=metric=='lookup'and row['input_mode']=='raw_bytes'
                row[metric+'_trials_ns']='[null,null,null,null,null,null]'if raw else'[1,3,1,3,1,3]'
                row[metric+'_ns']='nan'if raw else'2';row[metric+'_min_ns']='nan'if raw else'1';row[metric+'_max_ns']='nan'if raw else'3'
            out.append(row)
    return out
class Tests(unittest.TestCase):
    def test_complete296_and_98_quality(self):
        rows=fake_rows();q=c.quality(rows);self.assertEqual(len(rows),296);self.assertEqual(len(q['mapping_records']),98);self.assertEqual(sum(r['candidate']for r in q['mapping_records']),6)
    def test_retained_changes_and_missing_cases(self):
        rows=fake_rows();rows[0]['result_checksum']='99'
        with self.assertRaises(ValueError):c.quality(rows)
        with self.assertRaises((ValueError,AssertionError)):c.quality(fake_rows()[:-1])
    def test_candidate_batch_drift(self):
        rows=fake_rows();next(r for r in rows if r['filter']==c.CANDIDATE)['calibration_false_positives']='1'
        with self.assertRaises(ValueError):c.quality(rows)
    def test_exact_tiny_rng_advance_oracle(self):
        # The skip-ahead is arithmetic only; compare to explicit frozen tiny generator.
        from checks import ordered,RNG
        r=RNG((731+(1024+4096+2050-1)*0x9e3779b97f4a7c15)&((1<<64)-1));names=c.names()
        shuffled=list(names)
        for i in range(len(shuffled),1,-1):j=r.next()%i;shuffled[i-1],shuffled[j]=shuffled[j],shuffled[i-1]
        self.assertEqual(shuffled,ordered(names))
    def test_phase_trial_nan_corruption(self):
        case=c.cases()[0]
        for field,value in[('query_phase_order','P>H;P>H'),('lookup_ns','99'),('hash_lookup_trials_ns','[1,1,1,1,1,1]'),('build_repeats','1')]:
            rows=[r for r in fake_rows()if int(r['keys'])==1<<case['key_power']and int(r['requested_bpk'])==case['budget_bpk']and int(r['batch'])==case['batch']];rows[0][field]=value
            with self.assertRaises((ValueError,AssertionError),msg=field):c.validate_case(rows,case)
    def test_complete_raw_metadata_audit_and_corruptions(self):
        with tempfile.TemporaryDirectory()as tmp:
            output=Path(tmp);rows=fake_rows();proof=json.loads((c.STAGE/'CALLER_FREEZE.json').read_text());binary=Path(proof['performance_binary']);commit='a'*40
            def write(path,items):
                with path.open('w',newline='')as stream:
                    writer=csv.DictWriter(stream,fieldnames=c.schema(),lineterminator='\n');writer.writeheader();writer.writerows(items)
            meta=dict(complete=True,final_frozen_inputs_equal=True,source_commit=commit,proof_commit=PROOF,executable=str(binary),executable_sha256=BINARY_SHA,host=proof['host'],environment=proof['environment'],affinity=[3],lease=proof['lease'],numa_policy='CPU3 affinity only; no explicit NUMA memory binding',protocol_sha256=c.sha(c.STAGE/'protocol.json'),driver_protocol_sha256=c.sha(c.HERE/'protocol.json'),cases=[],counts=dict(cases=26,rows=296,retained_control_rows=284,candidate_rows=12,retained_quality_records=92,candidate_quality_records=6,pooled=False))
            offset=0
            for i,case in enumerate(c.cases()):
                length=len(case['filters']);current=rows[offset:offset+length];offset+=length
                record=dict(case=case,command=c.command(binary,case),expected_order=c.order(case),complete=True,returncode=0,rows=length,stdout=f'case-{i:02d}.stdout',stderr=f'case-{i:02d}.stderr')
                write(output/record['stdout'],current);(output/record['stderr']).write_bytes(b'')
                for stream in('stdout','stderr'):record[stream+'_sha256']=c.sha(output/record[stream])
                meta['cases'].append(record)
            write(output/'results.csv',rows);c.save(output/'quality.json',c.quality(rows));c.save(output/'metadata.json',meta)
            meta.update(results_sha256=c.sha(output/'results.csv'),quality_sha256=c.sha(output/'quality.json'))
            self.assertEqual(len(c.audit(output,meta,binary,commit)[0]),296)
            for field,value in [('source_commit','b'*40),('proof_commit','b'*40),('executable_sha256','0'*64),('environment',{}),('host',{}),('affinity',[2]),('protocol_sha256','0'*64),('driver_protocol_sha256','0'*64),('cases',26),('complete',False)]:
                altered=copy.deepcopy(meta);altered[field]=value
                with self.assertRaises(ValueError,msg=field):c.audit(output,altered,binary,commit)
    def test_optimized_python_rejected(self):
        p=subprocess.run([sys.executable,'-O',str(c.HERE/'run.py'),'--help'],capture_output=True,text=True);self.assertNotEqual(p.returncode,0);self.assertFalse(p.stdout);self.assertIn('without -O',p.stderr)
if __name__=='__main__':unittest.main()
