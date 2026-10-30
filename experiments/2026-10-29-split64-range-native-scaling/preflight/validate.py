#!/usr/bin/env python3
"""Focused new-harness normal/ASan checks only; no formal performance matrix."""
import sys
if not __debug__:raise SystemExit('Python -O is forbidden before any execution')
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import time
from contract import need,parse,validate,semantic
from lease import require_lease
HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=STAGE.parents[1]

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def dump(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def command(binary,cap,t):
    cpus=','.join(map(str,(3,5,7)[:t]));names='Split64Range'if cap==24 else'Split64,Split64Range'
    return ['taskset','-c',cpus,'numactl','--physcpubind='+cpus,'--membind=1',str(binary),'16',str(cap),'14',str(t),'4','42','50','12',names,cpus]

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True);parser.add_argument('--execute-correctness',action='store_true');args=parser.parse_args()
    need(args.execute_correctness and re.fullmatch('[0-9a-f]{40}',args.source_commit),'Exact reviewed commit and execution flag required')
    lease=require_lease(3);prep=STAGE/'PREPARATION.json';descriptor=json.loads(prep.read_text());sources={str((STAGE/r).relative_to(ROOT)):v['sha256']for r,v in descriptor['files'].items()};sources[str(prep.relative_to(ROOT))]=sha(prep)
    for rel,digest in sources.items():
        need(sha(ROOT/rel)==digest,'Changed prepared source '+rel)
        blob=subprocess.check_output(['git','show',args.source_commit+':'+rel],cwd=ROOT);need(hashlib.sha256(blob).hexdigest()==digest,'Uncommitted source '+rel)
    out=STAGE/'validation-v1';out.mkdir(exist_ok=False);meta=dict(complete=False,performance_run=False,source_commit=args.source_commit,lease=lease,source_sha256=sources,commands=[],binaries_sha256={})
    dump(out/'commands.json',meta)
    def run(name,argv,extra=None,success=True):
        env=os.environ.copy();env.update(CARGO_BUILD_JOBS='1',RUSTFLAGS='',RUSTDOCFLAGS='',ASAN_OPTIONS='detect_leaks=1:halt_on_error=1');env.update(extra or {})
        start=time.monotonic();result=subprocess.run(list(map(str,argv)),cwd=ROOT,env=env,capture_output=True,pass_fds=tuple(lease['inherited_lock_descriptors']))
        (out/(name+'.stdout')).write_bytes(result.stdout);(out/(name+'.stderr')).write_bytes(result.stderr)
        meta['commands'].append(dict(name=name,argv=list(map(str,argv)),env=extra or {},returncode=result.returncode,expected_success=success,wall_seconds=time.monotonic()-start));dump(out/'commands.json',meta)
        print(name,result.returncode,flush=True)
        need(result.returncode==0 if success else result.returncode!=0 and not result.stdout,'Unexpected command result '+name)
        return result.stdout.decode()
    run('source-only',[sys.executable,STAGE/'verify_source.py']);run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_contract.py'])
    run('clang-version',['clang++','--version']);run('rust-version',['rustc','-Vv']);run('nightly-version',['rustc','+nightly','-Vv'])
    reference={};all_rows=[]
    for mode in ('normal','asan'):
        cpp=ROOT/'build'/('native-range-scaling-v1-'+mode);need(not cpp.exists() and not cpp.is_symlink(),'Preserve previous C++ build')
        run(mode+'-cpp-configure',['cmake','-S',STAGE,'-B',cpp,'-DCMAKE_CXX_COMPILER=clang++','-DCMAKE_BUILD_TYPE=Release','-DCMAKE_EXPORT_COMPILE_COMMANDS=ON','-DNATIVE_SCALING_ASAN='+('ON'if mode=='asan'else'OFF')])
        run(mode+'-cpp-build',['cmake','--build',cpp,'--parallel','1']);cpp_binary=cpp/'benchmark'
        target=Path('/tmp/fastest-bf-native-range-scaling-v1')/mode;need(not target.exists() and not target.is_symlink(),'Preserve previous Rust target')
        flags='-C target-cpu=native -C symbol-mangling-version=v0'+(' -Zsanitizer=address'if mode=='asan'else'')
        cargo=['cargo']+(['+nightly']if mode=='asan'else[])
        text=run(mode+'-rust-build',cargo+['build','--locked','--offline','--release','--manifest-path',STAGE/'rust/Cargo.toml','--target','x86_64-unknown-linux-gnu','--message-format=json'],dict(CARGO_TARGET_DIR=str(target),RUSTFLAGS=flags))
        artifacts=[r['executable']for r in map(json.loads,text.splitlines())if r.get('reason')=='compiler-artifact'and r.get('target',{}).get('name')=='benchmark'and r.get('executable')]
        need(len(artifacts)==1,'Expected one structured native Rust executable');rust_binary=Path(artifacts[0]);need(rust_binary.is_relative_to(target),'Rust binary outside prescribed target')
        for language,binary in (('cpp',cpp_binary),('rust',rust_binary)):
            meta['binaries_sha256'][str(binary)]=sha(binary)
            for cap in (16,24,32):
                for t in (1,3):
                    name=f'{mode}-{language}-p{cap}-t{t}';rows=validate(parse(run(name,command(binary,cap,t))),language,cap,t)
                    for row in rows:
                        key=(row['filter'],cap);value=semantic(row)
                        need(key not in reference or reference[key]==value,'Cross-language/backend/T semantic mismatch')
                        reference[key]=value;all_rows.append(dict(mode=mode,**row))
            if mode=='normal':
                base=command(binary,16,1)
                for i,(index,value) in enumerate(((-2,'missing'),(-2,'Split64,Split64'),(-2,'Split64,'),(-6,'6'),(-4,'101'))):
                    bad=list(base);bad[index]=value;run(f'{language}-invalid-{i}',bad,success=False)
        # Preserve actual compiler paths and prove every local consumed header/source was prepared.
        consumed={}
        paths=list(cpp.rglob('*.o.d'))+list(target.rglob('*.d'))
        need(paths,'Missing compiler dependency evidence')
        for i,path in enumerate(paths):
            text=path.read_text();(out/f'{mode}-dependency-{i}.d').write_text(text)
            for token in text.replace('\\\n',' ').split():
                file=Path(token);file=file.resolve() if file.is_absolute() else (ROOT/file).resolve()
                if file.is_file() and file.is_relative_to(ROOT):
                    rel=str(file.relative_to(ROOT));need(rel in sources and sha(file)==sources[rel],'Unprepared actual consumed source '+rel);consumed[rel]=sha(file)
        required=('cpp/main.cpp','cpp/native/split64_bloom.h','cpp/range/split64_bloom.h','cpp/range/parallel_split64_range.h','rust/src/main.rs','rust/native/src/lib.rs','rust/native/src/split64.rs','rust/native/src/split64_range.rs','rust/native/src/layout_parallel.rs','rust/native/src/range_parallel.rs')
        need(all(str((STAGE/rel).relative_to(ROOT)) in consumed for rel in required),'Missing actual harness/native dependency')
        meta.setdefault('consumed_sources',{})[mode]=consumed
        (out/(mode+'-compile_commands.json')).write_bytes((cpp/'compile_commands.json').read_bytes());dump(out/'commands.json',meta)
    need(len(all_rows)==40 and len(reference)==5,'Wrong focused40 row coverage')
    for rel,digest in sources.items():need(sha(ROOT/rel)==digest,'Source changed during preflight')
    for path,digest in meta['binaries_sha256'].items():need(sha(path)==digest,'Binary changed during preflight')
    need(require_lease(3)==lease,'Lease changed')
    dump(out/'small-fixtures.json',dict(rows=all_rows,timings_claimed=False,reference_geometries=5,real_multiworker_fixture='n65536/q16384/T3'))
    meta.update(complete=True,rows=40,semantic_geometries=5,malformed_cli_cases=10,source_after_equal=True);dump(out/'commands.json',meta)
    print('PASS focused40 normal/ASan rows; public W3 exercised; no formal performance run',flush=True)

if __name__=='__main__':main()
