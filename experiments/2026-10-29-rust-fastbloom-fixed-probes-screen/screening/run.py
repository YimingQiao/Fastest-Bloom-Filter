#!/usr/bin/env python3
"""Run all336 prespecified real-timer rows; no quality-based configuration pruning."""
if not __debug__: raise RuntimeError('Use Python without -O')
import argparse
import csv
import io
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import time

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
sys.path.insert(0,str(STAGE))
from anchor import compare
from bindings import PUBLIC, ROOT, need, save, sha
from guard import expected_order, raw_intervals, validate_all, validate_protocol, validate_rows
from source_guard import require_lease
from freeze import verify


def command_for(case,protocol,binary):
    return [str(binary),str(case['key_power']),str(case['budget_bpk']),str(protocol['hit_percent']),
        str(protocol['query_power']),str(case['batch']),str(protocol['repeats']),str(case['seed']),
        ','.join(case['filters']),str(1<<case['key_power']),str(protocol['calibration_power'])]


def quality(rows):
    # Reused calibration observations are neither summed across batch tags nor
    # treated as independent samples. Source order follows the frozen112 matrix.
    unique={}
    for row in rows:
        key=(row['filter'],row['keys'],row['requested_bpk'])
        if key not in unique:unique[key]=row
    need(len(unique)==112,'Wrong API/geometry quality count')
    reference=list(csv.DictReader(io.StringIO((PUBLIC/'calibration-results/results.csv').read_text())))
    ordered=[unique[(r['filter'],r['keys'],r['requested_bpk'])]for r in reference]
    compare(ordered)
    # This immutable document already proves the sole two default16/K11 aliases
    # and retains every K outcome. It is copied byte-for-byte, not re-estimated.
    result=json.loads((PUBLIC/'calibration-results/quality.json').read_text())
    need(len(result['api_records'])==112 and len(result['mapping_records'])==110,'Changed quality cardinality')
    return result


def audit(output,metadata,protocol,source,registry,binary):
    need(len(metadata['cases'])==18,'Incomplete case ledger')
    rows=[]
    for i,(case,record)in enumerate(zip(protocol['cases'],metadata['cases'],strict=True)):
        need(record['case']==case and record['command']==command_for(case,protocol,binary),'Wrong recorded workload/command')
        need(record['complete'] and record['returncode']==0,'Incomplete/failed case')
        need(record['stdout']==f'case-{i:02d}.stdout' and record['stderr']==f'case-{i:02d}.stderr','Wrong raw filenames')
        raw,err=output/record['stdout'],output/record['stderr']
        need(sha(raw)==record['stdout_sha256'] and sha(err)==record['stderr_sha256'],'Raw evidence drift')
        need(err.read_text().strip()=='sbbf-rs 0.2.8 backend: Avx2Filter','Unexpected backend/diagnostic')
        current=list(csv.DictReader(io.StringIO(raw.read_text())))
        validate_rows(current,case,protocol,source);compare(current)
        need(record['rows']==len(current) and record['expected_filter_order']==[r['filter']for r in current],'Changed source-derived ordering')
        need(record['raw_input_intervals']==raw_intervals(case,protocol),'Changed raw domains')
        rows.extend(current)
    need(rows==list(csv.DictReader(io.StringIO((output/'results.csv').read_text()))),'Raw/aggregate values/order differ')
    result=validate_all(rows,protocol,registry,source)
    need(quality(rows)==json.loads((output/'quality.json').read_text()),'Quality copies/aliases differ')
    return rows,result


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source-commit',required=True)
    p.add_argument('--output',type=Path,default=STAGE/'screen')
    args=p.parse_args()
    lease=require_lease(3)
    frozen,compiled=verify(args.source_commit)
    protocol=json.loads((STAGE/'protocol.json').read_text())
    registry=json.loads((PUBLIC/'registry.json').read_text())
    source=(PUBLIC/'benchmark/src/main.rs').read_text()
    validate_protocol(protocol,registry,source)
    binary=Path(compiled['performance_executable'])
    need(not args.output.exists() and not args.output.is_symlink(),'Preserve existing output/target')
    args.output.mkdir(parents=True)
    env={k:os.environ.get(k)for k in ['BF_SOCKET_LEASE','LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','RUSTFLAGS','RUSTDOCFLAGS']}
    need(all(not value for key,value in env.items()if key!='BF_SOCKET_LEASE'),'Unfrozen loader/allocator/compiler override')
    metadata=dict(complete=False,source_commit=args.source_commit,preflight_source_commit=compiled['preflight_source_commit'],
        executable=str(binary),executable_sha256=sha(binary),freeze_sha256=sha(HERE/'freeze.json'),
        host=platform.uname()._asdict(),environment=env,lease=lease,affinity=sorted(os.sched_getaffinity(0)),
        numa_policy=protocol['numa_policy'],compiler_flags=protocol['compiler_flags'],
        input_sha256=frozen['inputs_sha256'],started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),cases=[])
    save(args.output/'metadata.json',metadata)
    rows=[]
    for i,case in enumerate(protocol['cases']):
        verify(light=True)
        need(require_lease(3)==lease,'Lease/affinity drift')
        command=command_for(case,protocol,binary)
        record=dict(case=case,command=command,complete=False,stdout=f'case-{i:02d}.stdout',stderr=f'case-{i:02d}.stderr',
            expected_filter_order=expected_order(case,protocol,source),raw_input_intervals=raw_intervals(case,protocol))
        metadata['cases'].append(record);save(args.output/'metadata.json',metadata)
        started=time.monotonic();process=subprocess.run(command,cwd=ROOT,capture_output=True)
        out,err=args.output/record['stdout'],args.output/record['stderr']
        out.write_bytes(process.stdout);err.write_bytes(process.stderr)
        record.update(returncode=process.returncode,stdout_sha256=sha(out),stderr_sha256=sha(err),elapsed_seconds=time.monotonic()-started)
        save(args.output/'metadata.json',metadata)
        need(process.returncode==0,'Failed benchmark; attempt preserved')
        need(process.stderr.decode().strip()=='sbbf-rs 0.2.8 backend: Avx2Filter','Unexpected backend/diagnostic')
        current=list(csv.DictReader(io.StringIO(process.stdout.decode())))
        validate_rows(current,case,protocol,source);compare(current)
        rows.extend(current)
        with (args.output/'results.csv').open('w',newline='')as stream:
            writer=csv.DictWriter(stream,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
        record.update(complete=True,rows=len(current));save(args.output/'metadata.json',metadata)
        print(f'case{i+1}/18 validated {len(current)} rows; all query phases/trials and112 semantics retained',flush=True)
    save(args.output/'quality.json',quality(rows))
    observed,counts=audit(args.output,metadata,protocol,source,registry,binary)
    need(observed==rows,'In-memory/raw drift')
    verify(args.source_commit)
    need(require_lease(3)==lease,'Final lease drift')
    metadata.update(complete=True,**counts,known_mapping_records=110,results_sha256=sha(args.output/'results.csv'),
        quality_sha256=sha(args.output/'quality.json'),final_sources_dependencies_binaries_equal=True,
        finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    save(args.output/'metadata.json',metadata)
    save(args.output/'archive-manifest.json',dict(files={f.name:dict(sha256=sha(f),bytes=f.stat().st_size)
        for f in sorted(args.output.iterdir())if f.is_file()}))
    print('Complete336 rows/18 cases,112 API and110 unpooled mapping records; allK1..12 retained',flush=True)


if __name__=='__main__':main()
