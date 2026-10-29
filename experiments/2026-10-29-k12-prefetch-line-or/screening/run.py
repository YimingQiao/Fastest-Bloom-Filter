#!/usr/bin/env python3
"""Run only the prespecified24-process/72-row conditional confirmation."""
import argparse,json,subprocess,traceback
from datetime import datetime,timezone
from pathlib import Path
if not __debug__:raise SystemExit('Python -O unsupported')
from freeze import HERE,ROOT,verify,sha
from screen_contract import plan,command,parse,csv_text,complete,audit,intervals,need
from placement import require,PREFIX

def now():return datetime.now(timezone.utc).isoformat()
def main():
    p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);p.add_argument('--execute-frozen',action='store_true');a=p.parse_args()
    need(a.execute_frozen,'Explicit frozen execution required')
    lease=require();frozen=verify(a.source_commit);binary=Path(frozen['binary']['path']);output=HERE/'results-v1'
    need(not output.exists()and not output.is_symlink(),'Preserve earlier outcomes');output.mkdir()
    metadata=dict(complete=False,source_commit=a.source_commit,freeze=frozen,binary=frozen['binary'],lease=lease,
        child_prefix=PREFIX,numactl_sha256=sha('/usr/bin/numactl'),plan=plan(),cases=[],started=now(),compiler_runs=0,
        query_ranking=False,analysis_rules_sha256=sha(HERE/'ANALYSIS_RULES.json'))
    def save():(output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    save()
    try:
        rows=[]
        for item in plan():
            need(require()==lease,'Lease changed');label=f"case-{item['index']:02d}"
            record=dict(case=item,command=command(binary,item),raw_intervals=intervals(item),complete=False,started=now(),stdout=label+'.stdout',stderr=label+'.stderr')
            metadata['cases'].append(record);save()
            with(output/record['stdout']).open('w')as out,(output/record['stderr']).open('w')as err:
                result=subprocess.run(record['command'],cwd=ROOT,stdout=out,stderr=err,pass_fds=tuple(lease['inherited_lock_descriptors']))
            record.update(returncode=result.returncode,finished=now(),stdout_sha256=sha(output/record['stdout']),stderr_sha256=sha(output/record['stderr']));save()
            need(result.returncode==0 and not(output/record['stderr']).read_bytes(),'Failed outcome retained')
            rows.extend(parse((output/record['stdout']).read_text(),item));record['complete']=True;save()
            print(f"{item['index']+1}/24 processes complete",flush=True)
        counts=complete(rows)
        (output/'rows.json').write_text(json.dumps(rows,indent=2)+'\n');(output/'results.csv').write_text(csv_text(rows))
        need(verify(a.source_commit)==frozen and require()==lease,'Final source/binary/lease changed')
        need(sha('/usr/bin/numactl')==metadata['numactl_sha256'],'Placement executable changed')
        metadata.update(complete=True,finished=now(),counts=counts);save();audit(output,metadata,binary,a.source_commit,sha)
        files={p.name:dict(sha256=sha(p),bytes=p.stat().st_size)for p in sorted(output.iterdir())if p.is_file()}
        (output/'RAW_ARCHIVE.json').write_text(json.dumps(dict(source_commit=a.source_commit,files=files),indent=2)+'\n')
        print(json.dumps(counts))
    except BaseException as error:
        metadata.update(complete=False,error=repr(error),finished=now());save();(output/'FAILURE.txt').write_text(traceback.format_exc());raise
if __name__=='__main__':main()
