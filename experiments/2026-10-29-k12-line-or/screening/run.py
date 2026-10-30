#!/usr/bin/env python3
"""Execute exactly the fixed eight workload screen with the checked binary."""
import argparse
from datetime import datetime,timezone
import json,os,subprocess,sys,traceback
from pathlib import Path
if not __debug__:raise SystemExit('Python -O unsupported')
from freeze import HERE,verify,sha
from screen_contract import plan,command,parse,csv_text,audit,need
sys.path.insert(0,str(HERE.parent/'caller'))
from lease import require

def now():return datetime.now(timezone.utc).isoformat()
def main():
    p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);p.add_argument('--execute-frozen',action='store_true');a=p.parse_args()
    need(a.execute_frozen,'Explicit frozen execution required')
    lease=require(3);frozen=verify(a.source_commit);binary=Path(frozen['binary']['path']);output=HERE/'results-v1'
    need(not output.exists()and not output.is_symlink(),'Preserve earlier screen');output.mkdir()
    metadata=dict(complete=False,source_commit=a.source_commit,freeze=frozen,binary=frozen['binary'],lease=lease,
                  memory_binding='numactl --physcpubind=3 --membind=1 per child',numactl_sha256=sha('/usr/bin/numactl'),
                  plan=plan(),cases=[],started=now(),compiler_runs=0,query_ranking=False)
    def save():(output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    save()
    try:
        values=[]
        for item in plan():
            need(require(3)==lease,'Lease changed')
            label=f"case-{item['index']:02d}";record=dict(case=item,command=command(binary,item),complete=False,started=now(),stdout=label+'.stdout',stderr=label+'.stderr')
            metadata['cases'].append(record);save()
            with(output/record['stdout']).open('w')as out,(output/record['stderr']).open('w')as err:
                process=subprocess.run(record['command'],stdout=out,stderr=err,cwd=HERE.parents[2],pass_fds=tuple(lease['inherited_lock_descriptors']))
            record.update(returncode=process.returncode,finished=now(),stdout_sha256=sha(output/record['stdout']),stderr_sha256=sha(output/record['stderr']));save()
            need(process.returncode==0 and not(output/record['stderr']).read_bytes(),'Failed case retained')
            values.extend(parse((output/record['stdout']).read_text(),item));record['complete']=True;save()
            print(f"{item['index']+1}/8 complete",flush=True)
        (output/'rows.json').write_text(json.dumps(values,indent=2)+'\n');(output/'results.csv').write_text(csv_text(values))
        need(verify(a.source_commit)==frozen and require(3)==lease,'Final source/binary/lease drift')
        need(sha('/usr/bin/numactl')==metadata['numactl_sha256'],'Placement executable changed')
        metadata.update(complete=True,finished=now(),counts=dict(cases=8,rows=16,build_trial_vectors=64,build_metric_samples=320,query_trial_vectors=32,query_metric_samples=64));save()
        audit(output,metadata,binary,a.source_commit,sha)
        files={f.name:dict(sha256=sha(f),bytes=f.stat().st_size)for f in sorted(output.iterdir())if f.is_file()}
        (output/'RAW_ARCHIVE.json').write_text(json.dumps(dict(source_commit=a.source_commit,files=files),indent=2)+'\n')
        print(json.dumps(metadata['counts']))
    except BaseException as error:
        metadata.update(complete=False,error=repr(error),finished=now());save();(output/'FAILURE.txt').write_text(traceback.format_exc());raise
if __name__=='__main__':main()
