#!/usr/bin/env python3
"""Execute only the initial26-case296-row K12 bulk training screen."""
if not __debug__:raise RuntimeError('Use Python without -O')
import argparse
import csv
import json
import os
import platform
import subprocess
import time
from contract import HERE,STAGE,ROOT,need,save,sha,cases,command,order,rows_from,validate_case,quality,audit,require_lease
from freeze import PROOF,BINARY_SHA,verify

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True);args=parser.parse_args()
    lease=require_lease(3);binary,proof=verify(args.source_commit)
    need(platform.uname()._asdict()==proof['host'],'Changed validated host')
    environment={k:os.environ.get(k)for k in proof['environment']}
    need(environment==proof['environment'],'Changed validated loader/allocator/compiler environment')
    output=HERE/'results-v1';need(not output.exists()and not output.is_symlink(),'Preserve previous attempt');output.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,proof_commit=PROOF,executable=str(binary),executable_sha256=BINARY_SHA,lease=lease,host=platform.uname()._asdict(),environment=environment,affinity=sorted(os.sched_getaffinity(0)),numa_policy='CPU3 affinity only; no explicit NUMA memory binding',protocol_sha256=sha(STAGE/'protocol.json'),driver_protocol_sha256=sha(HERE/'protocol.json'),started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),cases=[],counts=None)
    save(output/'metadata.json',meta);rows=[]
    try:
        for i,case in enumerate(cases()):
            need(require_lease(3)==lease,'Lease changed')
            record=dict(case=case,command=command(binary,case),expected_order=order(case),stdout=f'case-{i:02d}.stdout',stderr=f'case-{i:02d}.stderr',complete=False)
            meta['cases'].append(record);save(output/'metadata.json',meta)
            start=time.monotonic();process=subprocess.run(record['command'],cwd=ROOT,capture_output=True)
            for stream,data in [('stdout',process.stdout),('stderr',process.stderr)]:
                path=output/record[stream];path.write_bytes(data);record[stream+'_sha256']=sha(path)
            record.update(returncode=process.returncode,diagnostic_process_seconds=time.monotonic()-start);save(output/'metadata.json',meta)
            need(process.returncode==0 and not process.stderr,'Workload failure; preserve exact raw')
            current=rows_from(process.stdout.decode());validate_case(current,case);rows.extend(current)
            with(output/'results.csv').open('w',newline='')as file:
                writer=csv.DictWriter(file,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
            record.update(complete=True,rows=len(current));save(output/'metadata.json',meta)
            print(f'{i+1}/26 fixed cases validated; all selected configurations retained',flush=True)
        save(output/'quality.json',quality(rows));observed,counts=audit(output,meta,binary,args.source_commit,final=False);need(observed==rows,'Archived rows differ')
        final_binary,final_proof=verify(args.source_commit);need(final_binary==binary and final_proof==proof and require_lease(3)==lease,'Final frozen input/lease drift')
        meta.update(complete=True,final_frozen_inputs_equal=True,counts=counts,results_sha256=sha(output/'results.csv'),quality_sha256=sha(output/'quality.json'),finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
        save(output/'metadata.json',meta);audit(output,meta,binary,args.source_commit)
        print('PASS26 cases296 rows;284 retainedcontrol reproductions,6 new unpooled K12 quality samples; no partial ranking',flush=True)
    except BaseException as error:meta.update(complete=False,failure=repr(error));save(output/'metadata.json',meta);raise
if __name__=='__main__':main()
