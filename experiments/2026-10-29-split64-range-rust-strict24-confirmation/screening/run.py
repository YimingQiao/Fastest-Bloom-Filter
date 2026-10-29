#!/usr/bin/env python3
"""Run only the fixed12 workloads/24 rows after reviewed source freeze."""
if not __debug__:raise RuntimeError('Use Python without -O')
import argparse
import csv
import io
import json
import os
from pathlib import Path
import platform
import subprocess
import time
from contract import HERE,STAGE,ROOT,need,save,sha,protocol,commands,source,registry,validate_protocol,validate_rows,quality,audit,require_lease
from freeze import PROOF,verify

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True)
    args=parser.parse_args();lease=require_lease(3);binary,proof=verify(args.source_commit)
    need(platform.uname()._asdict()==json.loads((STAGE/'validation-v1/metadata.json').read_text())['host'],'Host changed from the validated subset preflight')
    p=protocol();s=source();validate_protocol(p,registry(),s)
    env={k:os.environ.get(k)for k in ['BF_SOCKET_LEASE','LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','RUSTFLAGS','RUSTDOCFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']}
    need(all(v is None for k,v in env.items()if k!='BF_SOCKET_LEASE'),'Unfrozen loader/allocator/compiler environment')
    output=HERE/'results-v1';need(not output.exists()and not output.is_symlink(),'Preserve previous attempt');output.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,proof_commit=PROOF,executable=str(binary),executable_sha256=sha(binary),
        lease=lease,host=platform.uname()._asdict(),environment=env,affinity=sorted(os.sched_getaffinity(0)),
        numa_policy='CPU affinity only; no explicit NUMA memory binding',started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),
        corrected_selection_sha256=proof['corrected_selection_sha256'],protocol_sha256=sha(HERE/'protocol.json'),cases=[],counts=None)
    save(output/'metadata.json',meta);rows=[]
    try:
        for i,item in enumerate(commands()):
            need(require_lease(3)==lease,'Lease changed')
            need(item['command'][0]==str(binary),'Changed frozen command executable')
            record=dict(case=item['case'],command=item['command'],expected_filter_order=item['expected_filter_order'],
                raw_input_intervals=item['raw_intervals'],stdout=f'case-{i:02d}.stdout',stderr=f'case-{i:02d}.stderr',complete=False)
            meta['cases'].append(record);save(output/'metadata.json',meta)
            start=time.monotonic();process=subprocess.run(record['command'],cwd=ROOT,capture_output=True)
            for name,data in [('stdout',process.stdout),('stderr',process.stderr)]:
                path=output/record[name];path.write_bytes(data);record[name+'_sha256']=sha(path)
            record.update(returncode=process.returncode,diagnostic_process_seconds=time.monotonic()-start);save(output/'metadata.json',meta)
            need(process.returncode==0,'Workload failed; preserve the attempt')
            need(process.stderr.decode().strip()=='sbbf-rs 0.2.8 backend: Avx2Filter','Unexpected backend')
            current=list(csv.DictReader(io.StringIO(process.stdout.decode())));validate_rows(current,item['case'],p,s)
            rows.extend(current)
            with(output/'results.csv').open('w',newline='')as file:
                writer=csv.DictWriter(file,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
            record.update(complete=True,rows=len(current));save(output/'metadata.json',meta)
            print(f'{i+1}/12 fixed cases validated; no partial ranking or quality-based substitution',flush=True)
        save(output/'quality.json',quality(rows))
        observed,counts=audit(output,meta,binary,args.source_commit,final=False);need(observed==rows,'In-memory/archived outputs differ')
        final_binary,final_proof=verify(args.source_commit)
        need(final_binary==binary and final_proof==proof and require_lease(3)==lease,'Final source/lease drift')
        meta.update(complete=True,counts=counts,final_frozen_inputs_equal=True,
            results_sha256=sha(output/'results.csv'),quality_sha256=sha(output/'quality.json'),
            finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
        save(output/'metadata.json',meta);audit(output,meta,binary,args.source_commit)
        print('PASS12 cases/24 rows;8 unpooled API/size/seed samples,4 all-seed gates; all timings retained',flush=True)
    except BaseException as error:
        meta.update(complete=False,failure=repr(error));save(output/'metadata.json',meta);raise

if __name__=='__main__':main()
