import copy
import csv
import io
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from runtime import HERE,STAGE,PROOF,BINARY,plan,need,sha,save,protocol,cases,geometry,training,rows_from,validate_case,quality,audit
SOURCE='a'*40

def mock_case(case):
    originals={r['filter']:r for r in training()if int(r['keys'])==1<<case['key_power']and int(r['requested_bpk'])==case['budget_bpk']and int(r['batch'])==case['batch']};out=[]
    for name in case['expected_order']:
        row=dict(originals[name]);row['seed']=str(case['seed']);row['calibration_absent_queries']=str(1<<26);row['query_phase_order']=';'.join('H>P'if(case['seed']+i)&1 else'P>H'for i in range(6));out.append(row)
    return out

def encode(rows):
    s=io.StringIO();w=csv.DictWriter(s,fieldnames=list(rows[0]),lineterminator='\n');w.writeheader();w.writerows(rows);return s.getvalue()

def make_archive(output):
    proof=json.loads((STAGE/'validation-v1/metadata.json').read_text());meta=dict(complete=True,source_commit=SOURCE,proof_commit=PROOF,executable=str(BINARY),executable_sha256=plan.BINARY_SHA,host=proof['host'],environment=proof['environment'],lease=proof['lease'],affinity=[3],protocol_sha256=sha(STAGE/'protocol.json'),selection_sha256=sha(STAGE/'selection.json'),numa_policy='CPU affinity only; no explicit NUMA memory binding',cases=[],final_frozen_inputs_equal=True);allrows=[]
    for i,case in enumerate(cases()):
        current=mock_case(case);allrows.extend(current);out=f'case-{i:02d}.stdout';err=f'case-{i:02d}.stderr';(output/out).write_text(encode(current));(output/err).write_text('');meta['cases'].append(dict(case=case,command=case['command'],expected_order=case['expected_order'],complete=True,returncode=0,rows=len(current),stdout=out,stderr=err,stdout_sha256=sha(output/out),stderr_sha256=sha(output/err)))
    (output/'results.csv').write_text(encode(allrows));save(output/'quality.json',quality(allrows));save(output/'metadata.json',meta)
    _,counts=audit(output,meta,SOURCE,final=False);meta.update(counts=counts,results_sha256=sha(output/'results.csv'),quality_sha256=sha(output/'quality.json'));save(output/'metadata.json',meta);return meta

class Guards(unittest.TestCase):
    def test_complete78_archive_and_counts(self):
        with tempfile.TemporaryDirectory()as d:
            p=Path(d);m=make_archive(p);rows,c=audit(p,m,SOURCE);self.assertEqual((len(rows),c['case_count']),(78,24));self.assertIsInstance(m['cases'],list);self.assertEqual(len(list(p.iterdir())),51)
    def test_quality_alias_only_and_allseed(self):
        q=quality([r for c in cases()for r in mock_case(c)]);self.assertEqual((len(q['api_seed_records']),len(q['mapping_seed_records']),len(q['all_seed_gates'])),(39,33,13));self.assertEqual(sum(len(x['apis'])==2 for x in q['mapping_seed_records']),6)
    def test_late_trial_and_order(self):
        c=cases()[0];rows=mock_case(c);rows[0]['lookup_trials_ns']='[1,2,3,4,5,6]'
        with self.assertRaises(AssertionError):validate_case(rows,c)
        rows=mock_case(c);rows[0],rows[1]=rows[1],rows[0]
        with self.assertRaises(ValueError):validate_case(rows,c)
    def test_metadata_identity_rejected(self):
        with tempfile.TemporaryDirectory()as d:
            p=Path(d);m=make_archive(p)
            for key,value in [('source_commit','b'*40),('proof_commit','b'*40),('executable_sha256','b'*64),('protocol_sha256','b'*64),('affinity',[2]),('environment',{})]:
                bad=copy.deepcopy(m);bad[key]=value
                with self.assertRaises(ValueError,msg=key):audit(p,bad,SOURCE)
            bad=copy.deepcopy(m);bad['lease']['inherited_lock_descriptors']=[]
            with self.assertRaises(ValueError):audit(p,bad,SOURCE)
    def test_raw_aggregate_and_ledger_rejected(self):
        with tempfile.TemporaryDirectory()as d:
            p=Path(d);m=make_archive(p);bad=copy.deepcopy(m);bad['cases']=24
            with self.assertRaises(ValueError):audit(p,bad,SOURCE)
            bad=copy.deepcopy(m);bad['cases'][0]['command'][7]='42'
            with self.assertRaises(ValueError):audit(p,bad,SOURCE)
            rows=rows_from((p/'results.csv').read_text());rows[0]['false_positives']='1';(p/'results.csv').write_text(encode(rows))
            with self.assertRaises(ValueError):audit(p,m,SOURCE)
    def test_alias_or_repeated_batch_drift_rejected(self):
        rows=[r for c in cases()for r in mock_case(c)];target=next(r for r in rows if r['filter']=='FastFilterFixed64');target['result_checksum']=str(int(target['result_checksum'])^1)
        with self.assertRaises(ValueError):quality(rows)
    def test_allseed_failure_preserved(self):
        rows=[r for c in cases()for r in mock_case(c)];seed=protocol()['seeds'][0]
        for r in rows:
            if r['filter']==plan.CANDIDATE and int(r['keys'])==65536 and int(r['seed'])==seed:r['calibration_false_positives']='10000'
        q=quality(rows);g=next(r for r in q['all_seed_gates']if r['filter']==plan.CANDIDATE and r['keys']==65536);self.assertFalse(g['all_three_seeds_pass']);self.assertEqual(len(q['api_seed_records']),39)
    def test_optimized_python_rejected(self):
        r=subprocess.run([sys.executable,'-O',str(HERE/'run.py'),'--help'],capture_output=True,text=True);self.assertNotEqual(r.returncode,0);self.assertFalse(r.stdout);self.assertIn('Use Python without -O',r.stderr)
if __name__=='__main__':unittest.main()
