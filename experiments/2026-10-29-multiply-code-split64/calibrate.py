#!/usr/bin/env python3
"""Run only the fixed committed24-row accuracy matrix after an explicit lease."""
import argparse,csv,hashlib,io,json,os,re,subprocess,time
from pathlib import Path
from freeze import HERE,ROOT,FROZEN,sha,verify
from lease import require_lease
from quality_guard import require,validate,wilson

def verify_commit(commit):
    require(bool(re.fullmatch(r'[0-9a-f]{40}',commit)),'Full immutable source commit required')
    manifest=json.loads((HERE/'manifest.json').read_text())
    for name,want in {**manifest['files'],'manifest.json':sha(HERE/'manifest.json')}.items():
        path=(HERE/name).resolve();require(path.is_relative_to(HERE),'Manifest path escape')
        require(sha(path)==want,'Archive drift: '+name)
        blob=subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
        require(hashlib.sha256(blob).hexdigest()==want,'Uncommitted archive: '+name)
    frozen=json.loads(FROZEN.read_text());verify(frozen)
    return frozen

def main():
    require(__debug__,'Run without Python -O')
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--source-commit',required=True);ap.add_argument('--output',type=Path,default=HERE/'accuracy');a=ap.parse_args()
    protocol=json.loads((HERE/'protocol.json').read_text());lease=require_lease(protocol['cpu']);frozen=verify_commit(a.source_commit)
    require(frozen['cpu']==protocol['cpu'] and lease['lock_path']==protocol['socket_lock'],'Wrong frozen CPU/lease')
    binary=Path(frozen['accuracy_executable']);require(str(binary) in frozen['binary_sha256'],'Missing frozen executable')
    a.output.mkdir(exist_ok=False)
    meta=dict(scope='Accuracy only; fixed constant, no speed measurement or retuning',source_commit=a.source_commit,freeze_sha256=sha(FROZEN),manifest_sha256=sha(HERE/'manifest.json'),binary_sha256=sha(binary),command=[str(binary)],lease=lease,started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),complete=False)
    (a.output/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    result=subprocess.run([str(binary)],cwd=ROOT,capture_output=True,text=True)
    (a.output/'results.csv').write_text(result.stdout);(a.output/'stderr.log').write_text(result.stderr)
    require(result.returncode==0,'Accuracy process failed; logs retained')
    rows=list(csv.DictReader(io.StringIO(result.stdout)));validate(rows)
    require(verify_commit(a.source_commit)==frozen,'Source/binary archive changed during accuracy')
    values=[]
    for row in rows:
        fp,n=int(row['false_positives']),int(row['calibration_negatives']);low,high=wilson(fp,n)
        values.append(dict(**row,observed_fpr=fp/n,wilson_lower=low,wilson_upper=high,qualifies_1_percent=high<=.01,qualifies_point1_percent=high<=.001,qualifies_point01_percent=high<=.0001,reproduced_parent_control=row['filter']!='MultiplyCodeSplit64Range'))
    (a.output/'quality.json').write_text(json.dumps(values,indent=2,allow_nan=False)+'\n')
    meta.update(complete=True,rows=24,results_sha256=sha(a.output/'results.csv'),finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    (a.output/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    print('PASS:24 accuracy rows;16 pinned control reproductions; all source/binary hashes unchanged; no speed measurement')
if __name__=='__main__':main()
