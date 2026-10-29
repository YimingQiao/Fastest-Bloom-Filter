#!/usr/bin/env python3
"""Focused checks of the real timed20-API executable; no formal336 run."""
if not __debug__: raise RuntimeError('Use Python without -O')
import argparse
import csv
import io
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys

from anchor import compare
from bindings import HERE, PUBLIC, ROOT, artifact, need, save, sha, verify_preparation
from derive_guard import generate
from guard import selected_names, validate_protocol, validate_rows
from source_guard import require_lease


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit',required=True)
    parser.add_argument('--output',type=Path,default=HERE/'validation-v1')
    args=parser.parse_args()
    need(re.fullmatch(r'[0-9a-f]{40}',args.source_commit),'Exact source commit required')
    lease=require_lease(3)
    pins,parent=verify_preparation(args.source_commit)
    need((HERE/'guard.py').read_text()==generate(),'Changed guard derivation')
    protocol=json.loads((HERE/'protocol.json').read_text())
    registry=json.loads((PUBLIC/'registry.json').read_text())
    source=(PUBLIC/'benchmark/src/main.rs').read_text()
    validate_protocol(protocol,registry,source)
    target=Path('/tmp/fastest-bf-fastbloom-fixed-k-performance')/args.output.name
    need(not target.exists() and not target.is_symlink(),'Preserve older performance targets, including dangling symlinks; use a fresh versioned output')
    args.output.mkdir(parents=True,exist_ok=False)
    metadata=dict(complete=False,performance_run=False,formal_accuracy_run=False,source_commit=args.source_commit,
        lease=lease,prepared_input_sha256=pins,external_dependencies=parent['external_dependencies'],commands=[],binaries={},cases=[])
    save(args.output/'metadata.json',metadata)

    def run(name,command,env=None,valid=True):
        environment=os.environ.copy()
        environment.update(CARGO_BUILD_JOBS='1',RUST_TEST_THREADS='1',RUSTFLAGS='',RUSTDOCFLAGS='',ASAN_OPTIONS='detect_leaks=1:halt_on_error=1')
        environment.update(env or {})
        proc=subprocess.run([str(x)for x in command],cwd=ROOT,env=environment,capture_output=True)
        (args.output/(name+'.stdout')).write_bytes(proc.stdout)
        (args.output/(name+'.stderr')).write_bytes(proc.stderr)
        metadata['commands'].append(dict(name=name,command=[str(x)for x in command],env=env or {},returncode=proc.returncode,expected_success=valid))
        save(args.output/'metadata.json',metadata)
        print(name,proc.returncode,flush=True)
        if valid:need(proc.returncode==0,'Failed '+name+'; attempt preserved')
        else:need(proc.returncode!=0 and not proc.stdout and proc.stderr,'Invalid CLI accepted/emitted CSV')
        return proc.stdout.decode()

    run('initial-public-source',[sys.executable,PUBLIC/'verify_source.py'])
    run('derived-row-guard',[sys.executable,HERE/'derive_guard.py'])
    run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_*.py'])
    run('stable-rustc',['rustc','-Vv']);run('nightly-rustc',['rustc','+nightly','-Vv'])
    mode_rows={}
    for mode in ['native','asan']:
        cargo=['cargo']+(['+nightly']if mode=='asan'else[])
        target_arg=['--target','x86_64-unknown-linux-gnu']if mode=='asan'else[]
        flags='-Zsanitizer=address'if mode=='asan'else'-C target-cpu=native -C symbol-mangling-version=v0'
        env=dict(CARGO_TARGET_DIR=str(target/mode),RUSTFLAGS=flags)
        common=['--locked','--offline','--release','--manifest-path',PUBLIC/'benchmark/Cargo.toml',*target_arg,'--message-format=json']
        for test in ['actual_harness_detects_corrupt_last_output_in_every_timed_mode','four_mode_order_balances_positions_and_predecessors']:
            text=run(mode+'-test-'+test,cargo+['test',*common,test,'--','--test-threads=1'],env)
            need('test result: ok. 1 passed'in text,'Missing focused timed-helper test')
            path=artifact(text,True);need(path.is_relative_to(target/mode),'Test artifact outside target')
            metadata['binaries'][str(path)]=sha(path)
        text=run(mode+'-build',cargo+['build',*common],env)
        binary=artifact(text,False);need(binary.is_relative_to(target/mode),'Timing artifact outside target')
        metadata['binaries'][str(binary)]=sha(binary)
        metadata.setdefault('mode_executables',{})[mode]=str(binary)
        mode_rows[mode]=[]
        tiny=dict(protocol,query_power=12,calibration_power=12,repeats=4)
        for cap in [16,24,32]:
            for batch in [1,31,4096]:
                case=dict(key_power=10,budget_bpk=cap,batch=batch,seed=42,filters=selected_names(cap,source))
                command=[binary,'10',str(cap),'50','12',str(batch),'4','42',','.join(case['filters']),'1024','12']
                text=run(f'{mode}-p{cap}-b{batch}',command)
                rows=list(csv.DictReader(io.StringIO(text)))
                validate_rows(rows,case,tiny,source);compare(rows,tiny=True)
                mode_rows[mode].extend(rows)
                metadata['cases'].append(dict(mode=mode,case=case,rows=len(rows)))
        invalid=[['10','8','50','12','1','4','42','Fastbloom017K1','1024','12'],
            ['10','16','50','12','0','4','42','Fastbloom017K1','1024','12'],
            ['10','16','50','12','1','5','42','Fastbloom017K1','1024','12'],
            ['10','16','50','12','1','4','42','Fastbloom017K13','1024','12'],
            ['10','16','50','12','1','4','42','Fastbloom017K1,','1024','12'],
            ['10','16','50','12','1','4','42','Fastbloom017K1,Fastbloom017K1','1024','12'],
            ['10','16','50','12','1','4','42','Fastbloom017K1,missing','1024','12']]
        for i,rest in enumerate(invalid):run(f'{mode}-invalid-{i}',[binary,*rest],valid=False)
        consumed,external_consumed={},{}
        sources=dict(parent['preserved_source_sha256'],**pins)
        external={str((Path(dep['directory'])/name).resolve()):digest
            for dep in json.loads((HERE/'external-tree.json').read_text())['dependencies']
            for name,digest in dep['sha256'].items()}
        dependency_files=sorted((target/mode).rglob('*.d'))
        need(dependency_files,'Missing compiler dependency files')
        for i,path in enumerate(dependency_files):
            text=path.read_text();(args.output/f'{mode}-dependencies-{i}.d').write_text(text)
            first=text.replace('\\\n',' ').splitlines()[0]
            need(': 'in first,'Malformed dependency record')
            for value in shlex.split(first.split(': ',1)[1]):
                item=Path(value)
                if not item.is_absolute():item=PUBLIC/'benchmark'/item
                item=item.resolve()
                need(item.is_file(),'Missing consumed compiler dependency')
                digest=sha(item)
                if item.is_relative_to(ROOT):
                    relative=str(item.relative_to(ROOT))
                    need(sources.get(relative)==digest,'Unbound consumed repository source '+relative)
                    consumed[relative]=digest
                else:
                    need(external.get(str(item))==digest,'Unbound consumed external source '+str(item))
                    external_consumed[str(item)]=digest
        representative=[PUBLIC/'benchmark/src/main.rs',PUBLIC/'benchmark/src/fixed_fastbloom.rs',
            ROOT/'experiments/2026-10-29-split64-range-rust-screen/native/src/lib.rs',
            ROOT/'experiments/2026-10-29-split64-range-rust-screen/native/src/byte_split.rs',
            ROOT/'experiments/2026-10-29-split64-range-rust-screen/native/src/split64.rs',
            ROOT/'experiments/2026-10-29-split64-range-rust-screen/native/src/split64_range.rs']
        for item in representative:need(str(item.relative_to(ROOT))in consumed,'Native/public module missing from dependency proof')
        metadata.setdefault('compiler_consumed_source_sha256',{})[mode]=consumed
        metadata.setdefault('compiler_consumed_external_sha256',{})[mode]=external_consumed
        save(args.output/'metadata.json',metadata)
    need(len(mode_rows['native'])==len(mode_rows['asan'])==168,'Wrong tiny-mode row coverage')
    compare(mode_rows['native'],tiny=True);compare(mode_rows['asan'],tiny=True)
    verify_preparation(args.source_commit)
    for path,digest in metadata['binaries'].items():need(sha(Path(path))==digest,'Preflight binary drift')
    need(require_lease(3)==lease,'Final lease drift')
    save(args.output/'tiny-fixtures.json',dict(timings_claimed=False,rows_by_mode=mode_rows))
    metadata.update(complete=True,source_after_equal=True,tiny_rows=336,retained_untimed_semantic_comparisons=336,
        focused_timed_helper_test_cases=4,invalid_cli_cases=14,reused_bitmap_allocation_tests=True)
    save(args.output/'metadata.json',metadata)
    print('PASS real20-API performance binary preflight only; no formal336 timing matrix',flush=True)


if __name__=='__main__':main()
