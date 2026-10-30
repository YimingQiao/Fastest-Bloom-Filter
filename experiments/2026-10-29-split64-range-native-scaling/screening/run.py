#!/usr/bin/env python3
"""Run the frozen36-command/60-row native public-API scaling matrix once."""
import sys
if not __debug__:raise SystemExit('Python -O is forbidden before any execution')
import argparse
import csv
import datetime
import json
import os
from pathlib import Path
import subprocess
import time
from contract import FIELDS,cases,command,complete,need,parse,validate
import placement
from source_guard import HERE,ROOT,STAGE,sha,verify

def dump(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def case_name(i,case):return f"case-{i:02d}-{case['language']}-n{case['key_power']}-p{case['budget_bpk']}-t{case['threads']}"

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True);p.add_argument('--execute-frozen',action='store_true');args=p.parse_args()
    need(args.execute_frozen,'Explicit frozen execution flag required')
    placed=placement.current();frozen=verify(args.source_commit);protocol=json.loads((HERE/'protocol.json').read_text());ledger=cases(protocol)
    out=STAGE/'screen';need(not out.exists()and not out.is_symlink(),'Preserve existing screen outcomes');out.mkdir()
    meta=dict(complete=False,started_utc=now(),source_commit=args.source_commit,protocol_sha256=sha(HERE/'protocol.json'),frozen_before=frozen,placement_before=placed,commands=[])
    dump(out/'metadata.json',meta);rows=[]
    try:
        for i,case in enumerate(ledger):
            name=case_name(i,case);binary=frozen['selected_normal_executables'][case['language']];argv=command(binary['path'],case,protocol)
            need(sha(binary['path'])==binary['sha256'],'Selected executable changed before child')
            start=time.monotonic();result=subprocess.run(argv,cwd=ROOT,env=os.environ.copy(),capture_output=True,pass_fds=tuple(placed['lease']['inherited_lock_descriptors']))
            stdout=out/(name+'.stdout');stderr=out/(name+'.stderr');stdout.write_bytes(result.stdout);stderr.write_bytes(result.stderr)
            meta['commands'].append(dict(index=i,case=case,argv=argv,returncode=result.returncode,wall_seconds=time.monotonic()-start,
              stdout=stdout.name,stdout_sha256=sha(stdout),stderr=stderr.name,stderr_sha256=sha(stderr)))
            dump(out/'metadata.json',meta);print(name,result.returncode,flush=True)
            need(result.returncode==0,'Failed frozen workload '+name)
            rows.extend(validate(parse(result.stdout.decode()),case,protocol))
            with(out/'results.csv').open('w',newline='')as f:
                writer=csv.DictWriter(f,fieldnames=FIELDS,lineterminator='\n');writer.writeheader();writer.writerows(rows)
        coverage=complete(rows,protocol)
        final=verify(args.source_commit);placed_after=placement.current();need(final==frozen and placed_after==placed,'Frozen inputs or placement changed during matrix')
        meta.update(complete=True,finished_utc=now(),frozen_after=final,placement_after=placed_after,coverage=coverage,results_sha256=sha(out/'results.csv'))
        dump(out/'metadata.json',meta);print('PASS36 commands/60 rows, all trial vectors and cross-language/T semantics; no cross-language timing ranking',flush=True)
    except BaseException as error:
        meta.update(finished_utc=now(),failure=repr(error));dump(out/'metadata.json',meta);raise

if __name__=='__main__':main()
