#!/usr/bin/env python3
"""Focused subset CLI/guard validation using already-frozen native/ASan binaries."""
if not __debug__:raise RuntimeError('Do not use Python -O')
import argparse
import csv
import io
import json
import os
from pathlib import Path
import platform
import subprocess
import time
from bindings import HERE,ROOT,PUBLIC,need,save,sha,verify,verify_derivation
from lease import require_lease
from subset_guard import validate_rows,validate_protocol

SEMANTICS=('filter_bytes','actual_bpk','logical_bytes','unit_count','effective_probes','probe_policy','constructor_argument',
    'result_checksum','false_positives','present_queries','absent_queries','calibration_false_positives','calibration_absent_queries')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit',required=True);parser.add_argument('--cpu',type=int,choices=[2,3],required=True)
    parser.add_argument('--output',type=Path,default=HERE.parent/'validation-v1');args=parser.parse_args()
    lease=require_lease(args.cpu);binaries=verify(args.source_commit);derivation=verify_derivation()
    need(not args.output.exists()and not args.output.is_symlink(),'Preserve prior validation attempts')
    protocol=json.loads((HERE/'runtime-protocol.json').read_text());source=(PUBLIC/'benchmark/src/main.rs').read_text()
    registry=json.loads((PUBLIC/'registry.json').read_text());validate_protocol(protocol,registry,source)
    for key in ['LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','RUSTFLAGS','RUSTDOCFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']:
        need(not os.environ.get(key),'Unfrozen environment override '+key)
    args.output.mkdir()
    metadata=dict(complete=False,source_commit=args.source_commit,lease=lease,host=platform.uname()._asdict(),
        derivation=derivation,binaries_sha256={mode:sha(path)for mode,path in binaries.items()},
        started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),commands=[])
    save(args.output/'metadata.json',metadata)
    def execute(label,command,expect_success):
        need(require_lease(args.cpu)==lease,'Lease changed')
        environment=os.environ.copy()
        options='detect_leaks=1:halt_on_error=1'if label.startswith('asan-')else None
        if options:environment['ASAN_OPTIONS']=options
        record=dict(label=label,command=command,ASAN_OPTIONS=options,complete=False);metadata['commands'].append(record);save(args.output/'metadata.json',metadata)
        result=subprocess.run(command,cwd=ROOT,capture_output=True,env=environment)
        for name,data in [('stdout',result.stdout),('stderr',result.stderr)]:
            path=args.output/(label+'.'+name);path.write_bytes(data);record[name]=path.name;record[name+'_sha256']=sha(path)
        record['returncode']=result.returncode;save(args.output/'metadata.json',metadata)
        need((result.returncode==0)==expect_success,'Unexpected CLI/test outcome; preserve attempt')
        if not expect_success:need(not result.stdout,'Invalid selection printed output')
        record['complete']=True;save(args.output/'metadata.json',metadata);return result
    observed=[];signatures={}
    for mode,binary in binaries.items():
        for batch in [31,4096]:
            case=dict(key_power=10,budget_bpk=24,batch=batch,seed=101,filters=protocol['filters'])
            small=dict(protocol,query_power=12,calibration_power=12,repeats=4)
            command=[str(binary),'10','24','50','12',str(batch),'4','101',','.join(case['filters']),'1024','12']
            result=execute(mode+'-batch'+str(batch),command,True)
            need(result.stderr.decode().strip()=='sbbf-rs 0.2.8 backend: Avx2Filter','Unexpected backend/sanitizer diagnostic')
            rows=list(csv.DictReader(io.StringIO(result.stdout.decode())));validate_rows(rows,case,small,source)
            for row in rows:
                signature=tuple(row[k]for k in SEMANTICS)
                need(row['filter']not in signatures or signatures[row['filter']]==signature,'Cross-mode/batch semantic drift')
                signatures[row['filter']]=signature
                observed.append(dict(mode=mode,batch=batch,filter=row['filter'],semantics=dict(zip(SEMANTICS,signature))))
    for index,selection in enumerate(['Split64RangeBloomFilter,missing','Fastbloom017K7,Fastbloom017K7','Fastbloom017K7,']):
        execute('invalid-'+str(index),[str(binaries['native']),'10','24','50','12','31','4','101',selection,'1024','12'],False)
    need(len(observed)==8 and len(metadata['commands'])==7,'Wrong bounded preflight coverage')
    verify(args.source_commit);need(require_lease(args.cpu)==lease,'Final lease changed')
    save(args.output/'semantic-records.json',observed)
    metadata.update(complete=True,tiny_rows=8,invalid_cli_cases=3,compiler_runs=0,heldout_cases_run=0,
        final_source_dependency_binary_checks=True,finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    save(args.output/'metadata.json',metadata)
    save(args.output/'archive-manifest.json',dict(files={p.name:dict(sha256=sha(p),bytes=p.stat().st_size)for p in sorted(args.output.iterdir())if p.is_file()}))
    print('PASS unchanged native/ASan subset8 tiny rows,3 malformed CLIs; no compilation or held-out input execution.')

if __name__=='__main__':main()
