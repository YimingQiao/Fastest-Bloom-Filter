#!/usr/bin/env python3
"""Fixed78 confirmation. Whole socket lock; never extend calibration or prune APIs."""
if not __debug__:raise RuntimeError('Use Python without -O')
import argparse
import csv
import json
import os
import platform
import subprocess
import time
from runtime import HERE,STAGE,ROOT,PROOF,BINARY,plan,need,sha,save,require_lease,protocol,cases,rows_from,validate_case,quality,audit
from pins import verify

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True);args=parser.parse_args()
    lease=require_lease(3);compiled,proof=verify(args.source_commit)
    need(platform.uname()._asdict()==proof['host'],'Changed tested host');environment={k:os.environ.get(k)for k in proof['environment']};need(environment==proof['environment'],'Changed tested environment')
    output=HERE/'results-v1';need(not output.exists()and not output.is_symlink(),'Preserve all earlier attempts');output.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,proof_commit=PROOF,executable=str(BINARY),executable_sha256=sha(BINARY),host=platform.uname()._asdict(),environment=environment,affinity=sorted(os.sched_getaffinity(0)),lease=lease,protocol_sha256=sha(STAGE/'protocol.json'),selection_sha256=sha(STAGE/'selection.json'),numa_policy='CPU affinity only; no explicit NUMA memory binding',started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),cases=[],counts=None)
    save(output/'metadata.json',meta);rows=[]
    try:
        for i,case in enumerate(cases()):
            need(require_lease(3)==lease,'Lease changed');need(case['command'][0]==str(BINARY),'Changed executable')
            record=dict(case=case,command=case['command'],expected_order=case['expected_order'],stdout=f'case-{i:02d}.stdout',stderr=f'case-{i:02d}.stderr',complete=False)
            meta['cases'].append(record);save(output/'metadata.json',meta);start=time.monotonic();process=subprocess.run(record['command'],cwd=ROOT,capture_output=True)
            for stream,data in [('stdout',process.stdout),('stderr',process.stderr)]:
                path=output/record[stream];path.write_bytes(data);record[stream+'_sha256']=sha(path)
            record.update(returncode=process.returncode,diagnostic_process_seconds=time.monotonic()-start);save(output/'metadata.json',meta)
            need(process.returncode==0 and not process.stderr,'Failed workload; preserve original attempt')
            current=rows_from(process.stdout.decode());validate_case(current,case);rows.extend(current)
            with(output/'results.csv').open('w',newline='')as file:
                writer=csv.DictWriter(file,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
            record.update(complete=True,rows=len(current));save(output/'metadata.json',meta)
            print(f'{i+1}/24 fixed cases validated ({len(rows)}/78 rows); no partial ranking or substitutions',flush=True)
        save(output/'quality.json',quality(rows));observed,counts=audit(output,meta,args.source_commit,final=False);need(observed==rows,'In-memory/archive disagreement')
        final_compiled,final_proof=verify(args.source_commit);need(final_compiled==compiled and final_proof==proof and require_lease(3)==lease,'Final source/binary/lease drift')
        meta.update(complete=True,counts=counts,final_frozen_inputs_equal=True,results_sha256=sha(output/'results.csv'),quality_sha256=sha(output/'quality.json'),finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
        save(output/'metadata.json',meta);audit(output,meta,args.source_commit)
        print('PASS24 fixed cases/78 rows;39 unpooled API samples,33 proven mapping samples,13 all-three-seed gates',flush=True)
    except BaseException as error:meta.update(complete=False,failure=repr(error));save(output/'metadata.json',meta);raise
if __name__=='__main__':main()
