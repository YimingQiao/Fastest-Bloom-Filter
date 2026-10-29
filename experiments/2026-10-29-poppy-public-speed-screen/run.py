#!/usr/bin/env python3
"""One frozen36-process Poppy486 round pair; no rebuild/retry/filter search."""
import argparse,json,subprocess,traceback
from datetime import datetime,timezone
from pathlib import Path
if not __debug__:raise SystemExit('Python -O unsupported')
from plan import HERE,ROOT,need
from pins import verify,sha
from placement import require
from screen_contract import plan,command,parse,validate_records,aggregate_csv,row_protocol,raw_intervals,PREFIX,expected_stderr
from audit import audit
def now():return datetime.now(timezone.utc).isoformat()
def main():
    p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);p.add_argument('--execute-frozen',action='store_true');a=p.parse_args()
    need(a.execute_frozen,'Explicit frozen execution flag required');frozen=verify(a.source_commit);lease=require()
    binary=Path(frozen['binary']['path']);output=HERE/'results-v1';need(not output.exists()and not output.is_symlink(),'Preserve earlier outcome');output.mkdir()
    metadata=dict(complete=False,source_commit=a.source_commit,freeze=frozen,binary=frozen['binary'],lease=lease,child_prefix=PREFIX,
      numactl_sha256=sha('/usr/bin/numactl'),analysis_rules_sha256=sha(HERE/'ANALYSIS_RULES.json'),ledger=plan(),compiler_runs=0,cases=[],started=now())
    def save():(output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    save()
    try:
        records=[]
        for case in plan()['cases']:
            need(require()==lease,'Lease changed');label=f"case-{case['index']:02d}"
            record=dict(case=case,command=command(binary,case),source_derived_intervals=raw_intervals(case,row_protocol(case)),
                complete=False,started=now(),stdout=label+'.stdout',stderr=label+'.stderr');metadata['cases'].append(record);save()
            with(output/record['stdout']).open('w')as out,(output/record['stderr']).open('w')as err:
                process=subprocess.run(record['command'],cwd=ROOT,stdout=out,stderr=err,pass_fds=tuple(lease['inherited_lock_descriptors']))
            record.update(returncode=process.returncode,finished=now(),stdout_sha256=sha(output/record['stdout']),stderr_sha256=sha(output/record['stderr']));save()
            need(process.returncode==0 and(output/record['stderr']).read_bytes()==expected_stderr(),'Failed/unexpected-diagnostic outcome retained')
            records.append(dict(case=case,rows=parse((output/record['stdout']).read_text(),case)));validate_records(records,complete=False)
            record['complete']=True;save();print(f"{case['index']+1}/36 processes complete",flush=True)
        counts,quality,references=validate_records(records)
        for name,data in [('records.json',records),('quality.json',quality),('quality-links.json',references)]:(output/name).write_text(json.dumps(data,indent=2)+'\n')
        (output/'results.csv').write_text(aggregate_csv(records))
        need(verify(a.source_commit)==frozen and require()==lease,'Final source/binary/lease changed')
        need(sha('/usr/bin/numactl')==metadata['numactl_sha256'],'Placement executable changed')
        metadata.update(complete=True,finished=now(),counts=counts);save();audit(output,metadata,binary,a.source_commit,sha)
        files={p.name:dict(sha256=sha(p),bytes=p.stat().st_size)for p in sorted(output.iterdir())if p.is_file()}
        (output/'RAW_ARCHIVE.json').write_text(json.dumps(dict(source_commit=a.source_commit,files=files),indent=2)+'\n');print(json.dumps(counts))
    except BaseException as error:
        metadata.update(complete=False,error=repr(error),finished=now());save();(output/'FAILURE.txt').write_text(traceback.format_exc());raise
if __name__=='__main__':main()
