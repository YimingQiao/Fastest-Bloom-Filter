#!/usr/bin/env python3
"""Complete exactly the unfinished eighteenth case in a separate evidence tree."""
if not __debug__:raise RuntimeError('Use Python without -O')
import argparse
import copy
import csv
import io
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import time
from contract import (HERE,STAGE,ROOT,ORIGINAL,INTERRUPTED,BINARY_SHA,need,save,sha,verify,
    require_lease,producer,compare,validate_rows,combine_metadata)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit',required=True)
    parser.add_argument('--session-label',required=True)
    parser.add_argument('--output',type=Path,default=STAGE/'resume-results-v1')
    args=parser.parse_args()
    lease=require_lease(3)
    frozen,compiled,protocol,source,registry,binary,original,rows=verify(args.source_commit)
    need(not args.output.exists() and not args.output.is_symlink(),'Preserve all previous attempts')
    env={k:os.environ.get(k)for k in original['environment']}
    need(env==original['environment'],'Environment changed from the interrupted attempt')
    need(platform.uname()._asdict()==original['host'],'Host changed from the interrupted attempt')
    args.output.mkdir(parents=True)
    record=copy.deepcopy(original['cases'][17])
    meta=dict(complete=False,source_commit=args.source_commit,original_source_commit=ORIGINAL,
        interrupted_archive_commit=INTERRUPTED,session_label=args.session_label,
        metadata_path=str((args.output/'metadata.json').relative_to(ROOT)),
        executable=str(binary),executable_sha256=BINARY_SHA,lease=lease,environment=env,
        host=platform.uname()._asdict(),affinity=sorted(os.sched_getaffinity(0)),
        started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),case=record,
        input_sha256=frozen['inputs_sha256'],original_metadata_sha256=sha(STAGE/'screen/metadata.json'))
    save(args.output/'metadata.json',meta)
    started=time.monotonic()
    # Same executable, arguments, cwd and pipe capture contract as the original.
    process=subprocess.run(record['command'],cwd=ROOT,capture_output=True)
    stdout,stderr=args.output/record['stdout'],args.output/record['stderr']
    stdout.write_bytes(process.stdout);stderr.write_bytes(process.stderr)
    record.update(returncode=process.returncode,stdout_sha256=sha(stdout),stderr_sha256=sha(stderr),elapsed_seconds=time.monotonic()-started)
    save(args.output/'metadata.json',meta)
    need(process.returncode==0,'Resume failed; preserve this attempt')
    need(process.stderr.decode().strip()=='sbbf-rs 0.2.8 backend: Avx2Filter','Unexpected backend')
    current=list(csv.DictReader(io.StringIO(process.stdout.decode())))
    validate_rows(current,protocol['cases'][17],protocol,source);compare(current)
    need(len(current)==20,'Wrong resumed row count')
    record.update(complete=True,rows=20);rows.extend(current)
    save(args.output/'metadata.json',meta)
    combined=args.output/'combined';combined.mkdir()
    for previous in original['cases'][:17]:
        for stream in ['stdout','stderr']:
            shutil.copyfile(STAGE/'screen'/previous[stream],combined/previous[stream])
            need(sha(combined/previous[stream])==previous[stream+'_sha256'],'Copied prior raw changed')
    for stream in ['stdout','stderr']:shutil.copyfile(args.output/record[stream],combined/record[stream])
    with(combined/'results.csv').open('w',newline='')as output:
        writer=csv.DictWriter(output,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
    save(combined/'quality.json',producer.quality(rows))
    ledger=copy.deepcopy(original['cases']);ledger[17]=record
    observed,counts=producer.audit(combined,dict(cases=ledger),protocol,source,registry,binary)
    need(observed==rows,'Complete raw/aggregate mismatch')
    verify(args.source_commit)
    need(require_lease(3)==lease,'Final lease changed')
    meta.update(complete=True,finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),
                final_sources_dependencies_binaries_equal=True,combined_rows=336,combined_cases=18)
    save(args.output/'metadata.json',meta)
    derived=combine_metadata(original,meta,record,counts)
    derived.update(known_mapping_records=110,results_sha256=sha(combined/'results.csv'),quality_sha256=sha(combined/'quality.json'),
                   original_raw_unchanged=True,final_sources_dependencies_binaries_equal=True)
    save(combined/'metadata.json',derived)
    producer.audit(combined,derived,protocol,source,registry,binary)
    save(args.output/'archive-manifest.json',dict(scope='Original316 rows reused byte-identically plus one resumed20-row case; two sessions disclosed.',
        files={str(p.relative_to(args.output)):dict(sha256=sha(p),bytes=p.stat().st_size)for p in sorted(args.output.rglob('*'))if p.is_file()}))
    print('PASS sole pending case20 rows; combined18-case336 rows fully validated, original interrupted evidence unchanged.',flush=True)

if __name__=='__main__':main()
