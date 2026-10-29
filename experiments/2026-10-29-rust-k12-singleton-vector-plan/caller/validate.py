#!/usr/bin/env python3
"""Four bounded correctness profiles; no formal timing/calibration entrypoint."""
if not __debug__:raise RuntimeError('Python -O forbidden')
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import traceback
from guards import HERE,ROOT,need,sha,save,verify,packages,artifacts
from contract import cases,argv,validate_rows,invalid,SEMANTIC
from dependencies import collect
from lease import require_lease
from asm import capture

TARGET=Path('/tmp/fastest-bf-rust-k12-simd-caller-v1-cpu3')
OUTPUT=HERE/'validation-v1'
FORBIDDEN=['RUSTFLAGS','RUSTDOCFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS',
 'RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CARGO_TARGET_DIR','RUSTC','RUSTDOC','RUSTUP_TOOLCHAIN',
 'CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS',
 'CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER','LD_PRELOAD','LD_LIBRARY_PATH',
 'MALLOC_CONF','MALLOC_ARENA_MAX','GLIBC_TUNABLES','ASAN_OPTIONS','UBSAN_OPTIONS']
PROFILES=[('native','-C target-cpu=native',False,False),
          ('portable','-C target-cpu=x86-64',False,False),
          ('disabled','-C target-cpu=x86-64',True,False),
          ('asan','-C target-cpu=x86-64 -Zsanitizer=address',False,True)]

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);args=parser.parse_args()
    lease=require_lease(3);inventory=verify(args.source_commit)
    inherited={k:os.environ.get(k)for k in FORBIDDEN};need(not any(inherited.values()),'unfrozen environment override')
    cargo_home=Path(os.environ.get('CARGO_HOME',Path.home()/'.cargo'))
    for base in [p/'.cargo'for p in [HERE,*HERE.parents]]+[cargo_home]:
        for name in ['config','config.toml']:need(not(base/name).exists(),'unfrozen Cargo config')
    need(not TARGET.exists() and not TARGET.is_symlink() and not OUTPUT.exists() and not OUTPUT.is_symlink(),'preserve previous attempts')
    OUTPUT.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,lease=lease,affinity=sorted(os.sched_getaffinity(0)),
              environment=inherited,commands=[],binaries={},toolchains={},compiler_inputs={},cases=[],
              formal_measurements=0,calibration_queries=0,incidental_check_timings_not_ranked=True)
    def persist():save(OUTPUT/'metadata.json',meta)
    def run(label,command,env=None,reject=None,quiet=False):
        need(require_lease(3)==lease,'lease changed')
        environment=os.environ.copy();environment.update(CARGO_BUILD_JOBS='1',RUST_TEST_THREADS='1',
            RUSTFLAGS='',RUSTDOCFLAGS='',ASAN_OPTIONS='detect_leaks=1:halt_on_error=1')
        environment.update(env or {})
        rec=dict(label=label,command=list(map(str,command)),explicit_environment=env or {},expected_rejection=reject,complete=False)
        meta['commands'].append(rec);persist()
        done=subprocess.run(rec['command'],cwd=ROOT,env=environment,pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
        for stream,data in [('stdout',done.stdout),('stderr',done.stderr)]:
            path=OUTPUT/(label+'.'+stream);path.write_bytes(data);rec[stream]=path.name;rec[stream+'_sha256']=sha(path)
        rec['returncode']=done.returncode;persist();print(label,done.returncode,flush=True)
        if reject is not None:need(done.returncode==1 and not done.stdout and done.stderr==(reject+'\n').encode(),'wrong rejection/fault diagnostic')
        else:
            need(done.returncode==0,'command failed: '+label)
            if quiet:need(not done.stderr,'unexpected caller stderr')
        rec['complete']=True;persist();return done.stdout.decode()
    def closure():
        need(verify(args.source_commit)==inventory,'source changed')
        for mapping in [meta['binaries'],meta['toolchains'],*meta['compiler_inputs'].values()]:
            for path,digest in mapping.items():need(sha(path)==digest,'actual input/tool/binary changed: '+path)
    persist()
    try:
        run('source-derivation',[sys.executable,HERE/'derive.py'])
        run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_contract.py'])
        signatures={};executables={}
        for mode,flags,disabled,nightly in PROFILES:
            cargo=['cargo']+(['+nightly']if nightly else[])
            extra=['--target','x86_64-unknown-linux-gnu']if nightly else[]
            features=['--features','disable-avx512']if disabled else[]
            env=dict(CARGO_TARGET_DIR=str(TARGET/mode),RUSTFLAGS=flags+' -C symbol-mangling-version=v0')
            for tool in ['cargo','rustc']:
                path=run(mode+'-'+tool+'-path',['rustup','which',*(['--toolchain','nightly']if nightly else[]),tool],env).strip()
                need(Path(path).is_file(),'missing actual toolchain tool');meta['toolchains'][path]=sha(path)
            run(mode+'-rustc-version',['rustc']+(['+nightly']if nightly else[])+['-Vv'],env)
            closure()
            known=packages(run(mode+'-metadata',cargo+['metadata','--format-version=1','--locked','--offline','--manifest-path',HERE/'Cargo.toml',*features],env))
            common=['--release','--locked','--offline','--manifest-path',HERE/'Cargo.toml',*extra,*features,'--message-format=json']
            test_text=run(mode+'-tests-build',cargo+['test',*common,'--workspace','--lib','--no-run'],env)
            build_text=run(mode+'-caller-build',cargo+['build',*common,'--bin','rust-k12-simd-caller'],env)
            test_bins=artifacts(test_text,True,TARGET/mode,known)
            binary=artifacts(build_text,False,TARGET/mode,known)['rust-k12-simd-caller']
            for path in [*test_bins.values(),binary]:meta['binaries'][str(path)]=sha(path)
            consumed,rules=collect(TARGET/mode,TARGET/mode,[test_text,build_text],inventory,ROOT,known)
            required=[HERE/'main.rs',HERE/'query.rs']+[HERE/arm/'src'/name for arm in ['control','candidate']for name in ['lib.rs','four_sector_range12.rs','k12_parallel.rs','simd_singleton_focused.rs']]
            need(all(str(path.resolve())in consumed for path in required),'missing actual caller/native/test input')
            for index,rule in enumerate(rules):(OUTPUT/f'{mode}-dependency-{index}.d').write_text(rule['text'])
            save(OUTPUT/(mode+'-compiler-closure.json'),dict(inputs_sha256=consumed,rules=rules))
            meta['compiler_inputs'][mode]=consumed;executables[mode]=str(binary);meta['executables']=executables;persist();closure()
            for arm,path in sorted(test_bins.items()):
                text=run(mode+'-focused-'+arm,[path,'simd_singleton_focused','--test-threads=1'],env)
                need('test result: ok. 2 passed'in text,'focused tests missing')
            for index,case in enumerate(cases()):
                closure()
                rows=[json.loads(line)for line in run(f'{mode}-case-{index}',argv(binary,case),env,quiet=True).splitlines()]
                validate_rows(rows,case,disabled)
                signature=[{k:r[k]for k in SEMANTIC}for r in rows]
                key=(case['hit'],case['batch']);need(signatures.setdefault(key,signature)==signature,'cross-profile output/bitmap drift')
                meta['cases'].append(dict(profile=mode,case=case,rows=2));persist()
            for index,(command,diagnostic) in enumerate(invalid(binary)):run(f'{mode}-invalid-{index}',command,env,reject=diagnostic)
            for fault in ['generic-skip','visible-wrong']:
                run(mode+'-fault-'+fault,argv(binary,dict(hit=50,batch=1))+['--fault',fault],env,reject='full output mismatch')
            closure()
        need(len(meta['cases'])==48 and len(meta['binaries'])==12,'wrong finite proof coverage')
        meta['functional_complete']=True;persist()
        meta['assembly']={mode:capture(Path(executables[mode]),OUTPUT,run,mode+'-asm')for mode in ['native','portable']}
        closure()
        meta.update(complete=True,focused_test_executions=16,required_bit_hash_cases=73792,tail_cases=17024,
                    caller_rows=96,invalid_cli_cases=24,fault_cases=8,manual_assembly_review_pending=True);persist()
    except BaseException as error:
        meta.update(error=repr(error),traceback=traceback.format_exc());persist();raise

if __name__=='__main__':main()
