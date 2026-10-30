import copy
import csv
import io
import json
from pathlib import Path
import tempfile
import unittest
from pilot_guard import STAGE,CALLER_PROOF,BINARY_SHA,audit,cases,command,quality,sha,validate

COMMIT='1'*40
BINARY=Path('/fixed/frozen-worker')
def mock_row(case):
    template=json.loads((STAGE/'validation-v1/metadata.json').read_text())['rows']['native'][0]
    original=next(c for c in cases()if c['filter']==case['filter']and c['power']==case['power']and
                  c['cap']==case['cap']and c['policy']=='original')
    row=dict(template);row.update(case['geometry']);row.update(original['old_semantics'])
    if case['policy']=='nearby_odd':row.update(calibration_false_positives='0',false_positives='0',result_checksum='1')
    return row
def fixture(output):
    rows=[];records=[]
    for i,case in enumerate(cases()):
        row=mock_row(case);validate(row,case);rows.append(row)
        stream=io.StringIO(newline='');writer=csv.DictWriter(stream,fieldnames=list(row),lineterminator='\n')
        writer.writeheader();writer.writerow(row)
        record=dict(case=case,command=command(BINARY,case),complete=True,returncode=0,row=row)
        for label,text in [('stdout',stream.getvalue()),('stderr','')]:
            path=output/(f'case-{i:02d}.'+label);path.write_text(text)
            record[label]=path.name;record[label+'_sha256']=sha(path)
        records.append(record)
    (output/'results.json').write_text(json.dumps(rows));(output/'quality.json').write_text(json.dumps(quality(rows)))
    meta=dict(complete=True,source_commit=COMMIT,caller_proof_commit=CALLER_PROOF,binary=str(BINARY),binary_sha256=BINARY_SHA,
              selection_sha256=sha(STAGE/'selection.json'),protocol_sha256=sha(STAGE/'protocol.json'),
              lease=dict(cpu=2,lease='socket0',lock_path='/tmp/fastest-bf-socket0.lock',inherited_lock_descriptors=[3]),
              affinity=[2],environment={'LD_PRELOAD':None},tuner_file_before={'exists':False},tuner_file_after={'exists':False},
              commands=records,all_frozen_inputs_unchanged=True,rows=36,old_reproductions=24,new_geometries=12,
              throughput_samples=0,pooled=False,results_sha256=sha(output/'results.json'),quality_sha256=sha(output/'quality.json'))
    (output/'metadata.json').write_text(json.dumps(meta));return meta

class Pilot(unittest.TestCase):
    def test_complete_synthetic36_replays(self):
        with tempfile.TemporaryDirectory()as directory:
            out=Path(directory);meta=fixture(out);rows,q=audit(out,meta,BINARY,COMMIT)
            self.assertEqual((len(rows),len(q)),(36,36));self.assertTrue(all(not r['pooled']for r in q))
    def test_missing_or_reordered_or_altered_commands(self):
        with tempfile.TemporaryDirectory()as directory:
            out=Path(directory);meta=fixture(out)
            for mode in range(4):
                bad=copy.deepcopy(meta)
                if mode==0:bad['commands'].pop()
                elif mode==1:bad['commands'][0],bad['commands'][1]=bad['commands'][1],bad['commands'][0]
                elif mode==2:bad['commands'][0]['command'][9]='6'
                else:bad['commands'][0]['row']['calibration_false_positives']='0'
                with self.assertRaises(ValueError):audit(out,bad,BINARY,COMMIT)
    def test_lease_source_or_completion_mutations(self):
        with tempfile.TemporaryDirectory()as directory:
            out=Path(directory);meta=fixture(out)
            for mode in range(7):
                bad=copy.deepcopy(meta)
                if mode==0:bad['source_commit']='2'*40
                elif mode==1:bad['caller_proof_commit']='2'*40
                elif mode==2:bad['binary_sha256']='0'*64
                elif mode==3:bad['lease']['inherited_lock_descriptors']=['3']
                elif mode==4:bad['affinity']=[3]
                elif mode==5:bad['complete']=False
                else:bad['pooled']=True
                with self.assertRaises(ValueError):audit(out,bad,BINARY,COMMIT)
    def test_extra_schema_or_timing_field_rejected(self):
        case=cases()[0];row=mock_row(case)
        bad=dict(row);bad['new_unreviewed_field']='1'
        with self.assertRaises(ValueError):validate(bad,case)
        bad=dict(row);bad['raw_single_ns']='1'
        with self.assertRaises(ValueError):validate(bad,case)
    def test_raw_or_quality_digest_corruption(self):
        with tempfile.TemporaryDirectory()as directory:
            out=Path(directory);meta=fixture(out)
            (out/'case-00.stdout').write_text('')
            with self.assertRaises(ValueError):audit(out,meta,BINARY,COMMIT)

if __name__=='__main__':unittest.main()
