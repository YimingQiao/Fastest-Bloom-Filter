#!/usr/bin/env python3
"""Focused wrapper correctness only:4 binaries,48 real cases, no formal timing."""
import sys
if not __debug__:raise SystemExit('Python -O is forbidden before any execution')
import argparse
import json
import os
from pathlib import Path
import shlex
import subprocess
from contract import accounting,need,semantic,validate_protocol,validate_real,validate_spy
from lease import require_lease
from source_guard import HERE,ROOT,STAGE,sha,verify

def dump(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def command(binary,mode,lease):
    cpus=','.join(map(str,lease['child_cpus']))
    return ['taskset','-c',cpus,'numactl','--physcpubind='+cpus,'--membind='+str(lease['node']),str(binary),mode]

def artifact(text,target):
    found=[]
    for line in text.splitlines():
        value=json.loads(line)
        if value.get('reason')=='compiler-artifact'and value.get('target',{}).get('name')=='policy_check'and value.get('executable'):
            need(value['target']['kind']==['bin']and not value['profile']['test'],'Wrong Cargo artifact kind');found.append(Path(value['executable']))
    need(len(found)==1 and found[0].is_file()and found[0].is_relative_to(target),'Expected one exact structured Cargo executable')
    return found[0]

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True);p.add_argument('--cpu',required=True,type=int,choices=(2,3));p.add_argument('--execute-correctness',action='store_true');args=p.parse_args()
    need(args.execute_correctness,'Explicit correctness execution flag required')
    lease=require_lease(args.cpu);sources=verify(args.source_commit)
    protocol=validate_protocol(json.loads((HERE/'protocol.json').read_text()))
    placement=next(item for item in protocol['lease_choices']if item['cpu']==args.cpu)
    need(lease['socket']==placement['socket']and lease['node']==placement['node']and lease['child_cpus']==placement['child_cpus']and lease['lock_path']==placement['lock'],'Placement differs from frozen protocol')
    out=STAGE/'validation-v1';need(not out.exists()and not out.is_symlink(),'Preserve prior outcomes');out.mkdir()
    metadata=dict(complete=False,performance_run=False,source_commit=args.source_commit,source_sha256=sources,protocol_sha256=sha(HERE/'protocol.json'),lease=lease,commands=[],binaries_sha256={},actual_compiler_inputs={},cases=[])
    dump(out/'commands.json',metadata)
    def run(name,argv,extra=None,valid=True):
        env=os.environ.copy();env.update(CARGO_BUILD_JOBS='1',RUSTFLAGS='',RUSTDOCFLAGS='',ASAN_OPTIONS='detect_leaks=1:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1');env.update(extra or {})
        process=subprocess.run(list(map(str,argv)),cwd=ROOT,env=env,capture_output=True,pass_fds=tuple(lease['inherited_lock_descriptors']))
        (out/(name+'.stdout')).write_bytes(process.stdout);(out/(name+'.stderr')).write_bytes(process.stderr)
        metadata['commands'].append(dict(name=name,argv=list(map(str,argv)),env=extra or {},returncode=process.returncode,expected_success=valid));dump(out/'commands.json',metadata)
        print(name,process.returncode,flush=True)
        need(process.returncode==0 if valid else process.returncode!=0 and not process.stdout,'Unexpected command outcome '+name)
        return process.stdout.decode()
    try:
        run('native-source',[sys.executable,STAGE/'verify_source.py'])
        run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_contract.py'])
        run('clang-version',['clang++','--version']);run('rust-version',['rustc','-Vv']);run('nightly-version',['rustc','+nightly','-Vv'])
        references={};worker_references={};reports=[]
        for mode in ('normal','asan'):
            cpp=ROOT/'build'/f'native-build-policy-v1-cpu{args.cpu}-{mode}'
            need(not cpp.exists()and not cpp.is_symlink(),'Preserve old C++ build')
            run(mode+'-cpp-configure',['cmake','-S',HERE,'-B',cpp,'-DCMAKE_CXX_COMPILER=clang++','-DCMAKE_BUILD_TYPE=Release','-DCMAKE_EXPORT_COMPILE_COMMANDS=ON','-DPOLICY_ASAN='+('ON'if mode=='asan'else'OFF')])
            run(mode+'-cpp-build',['cmake','--build',cpp,'--parallel','1'])
            target=Path(f'/tmp/fastest-bf-native-build-policy-v1-cpu{args.cpu}')/mode
            need(not target.exists()and not target.is_symlink(),'Preserve old Rust target')
            cargo=['cargo']+(['+nightly']if mode=='asan'else[])
            flags='-C target-cpu=native -C symbol-mangling-version=v0'+(' -Zsanitizer=address'if mode=='asan'else'')
            result=run(mode+'-rust-build',cargo+['build','--locked','--offline','--release','--manifest-path',HERE/'rust/Cargo.toml','--target','x86_64-unknown-linux-gnu','--message-format=json'],dict(CARGO_TARGET_DIR=str(target),RUSTFLAGS=flags))
            binaries={'cpp':cpp/'policy_check','rust':artifact(result,target)}
            for language,binary in binaries.items():
                metadata['binaries_sha256'][str(binary)]=sha(binary)
                spy=validate_spy(run(mode+'-'+language+'-spy',command(binary,'--spy',lease)),language)
                rows=validate_real(run(mode+'-'+language+'-real',command(binary,'--real',lease)),language)
                for row in rows:
                    key=(row['family'],row['case']);answer=semantic(row)
                    need(key not in references or references[key]==answer,'Cross-language/mode full-output or worker mismatch')
                    worker_key=(language,)+key;workers=accounting(row)
                    need(worker_key not in worker_references or worker_references[worker_key]==workers,'Same-language scheduler/scratch drift between modes')
                    worker_references[worker_key]=workers
                    references[key]=answer;reports.append(dict(mode=mode,**row))
                metadata['cases'].append(dict(mode=mode,language=language,real_cases=12,spy=spy));dump(out/'commands.json',metadata)
                if mode=='normal':run(language+'-invalid-mode',command(binary,'--unknown',lease),valid=False)
            consumed={}
            dependencies=list(cpp.rglob('*.o.d'))+list(target.rglob('*.d'));need(dependencies,'Missing actual compiler dependencies')
            for index,path in enumerate(dependencies):
                text=path.read_text();(out/f'{mode}-dependency-{index}.d').write_text(text)
                first=text.replace('\\\n',' ').splitlines()[0];need(': 'in first,'Malformed dependency rule')
                for value in shlex.split(first.split(': ',1)[1]):
                    item=Path(value)
                    if not item.is_absolute():item=(HERE/'rust'/item)if path.is_relative_to(target)else(ROOT/item)
                    item=item.resolve();need(item.is_file(),'Missing consumed compiler input '+str(item));digest=sha(item)
                    if item.is_relative_to(ROOT):need(sources.get(str(item.relative_to(ROOT)))==digest,'Unprepared repository compiler input '+str(item))
                    consumed[str(item)]=digest
            required=[HERE/'cpp/check.cpp',STAGE/'cpp/policy.hpp',STAGE/'cpp/bindings.hpp',HERE/'rust/src/main.rs',STAGE/'rust/src/lib.rs']
            frozen_native=ROOT/'experiments/2026-10-29-split64-range-native-scaling'
            required.extend(frozen_native/name for name in ('cpp/native/parallel_layout_bloom.h','cpp/range/parallel_split64_range.h','rust/native/src/lib.rs','rust/native/src/split64.rs','rust/native/src/split64_range.rs'))
            need(all(str(path)in consumed for path in required),'Missing actual wrapper/native consumption evidence')
            metadata['actual_compiler_inputs'][mode]=consumed
            (out/(mode+'-compile_commands.json')).write_bytes((cpp/'compile_commands.json').read_bytes());dump(out/'commands.json',metadata)
        need(len(reports)==48 and len(references)==12 and len(worker_references)==24 and len(metadata['cases'])==4,'Wrong minimal real coverage')
        need(verify(args.source_commit)==sources and require_lease(args.cpu)==lease,'Source or lease drift')
        for path,digest in metadata['binaries_sha256'].items():need(sha(path)==digest,'Changed validated executable')
        for consumed in metadata['actual_compiler_inputs'].values():
            for path,digest in consumed.items():need(sha(path)==digest,'Changed actual compiler input')
        dump(out/'real-fixtures.json',dict(rows=reports,performance_run=False))
        metadata.update(complete=True,real_cases=48,language_mode_runs=4,real_filter_lifetimes=144,spy_cases=1344,spy_forwarded_calls=8064,semantic_geometries=12,source_after_equal=True)
        dump(out/'commands.json',metadata);print('PASS48 real cases/4 binaries; full streamed old/new insertion checks, no performance',flush=True)
    except BaseException as error:
        metadata['failure']=repr(error);dump(out/'commands.json',metadata);raise

if __name__=='__main__':main()
