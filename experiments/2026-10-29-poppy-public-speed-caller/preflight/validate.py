#!/usr/bin/env python3
"""Bounded actual Poppy caller proof, never the formal486 comparison."""
if not __debug__:raise RuntimeError('Python -O forbidden')
import argparse,csv,io,json,os,subprocess,sys,traceback
from pathlib import Path
from bindings import *
from contract import *
from dependencies import collect
from lease import require_lease
from asm import capture
FORBIDDEN=['RUSTFLAGS','RUSTDOCFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CARGO_TARGET_DIR','RUSTC','RUSTDOC','RUSTUP_TOOLCHAIN','CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER','LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','MALLOC_ARENA_MAX','GLIBC_TUNABLES','ASAN_OPTIONS','UBSAN_OPTIONS']
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);args=parser.parse_args()
    lease=require_lease(2);inventory=verify(args.source_commit);original=Path(inventory['original_binary']['path'])
    inherited={k:os.environ.get(k)for k in FORBIDDEN};need(not any(inherited.values()),'Unfrozen build/runtime override')
    cargo_home=Path(os.environ.get('CARGO_HOME',Path.home()/'.cargo'));configs={}
    for base in [p/'.cargo'for p in [CALLER/'benchmark',*(CALLER/'benchmark').parents]]+[cargo_home]:
        for name in ['config','config.toml']:
            p=base/name
            if p.is_file():configs[str(p)]=sha(p)
    need(not configs,'Unfrozen Cargo configuration')
    need(not TARGET.exists()and not TARGET.is_symlink()and not OUTPUT.exists()and not OUTPUT.is_symlink(),'Preserve prior attempt')
    OUTPUT.mkdir();meta=dict(complete=False,source_commit=args.source_commit,caller_source_commit=SOURCE,lease=lease,affinity=sorted(os.sched_getaffinity(0)),environment=inherited,commands=[],binaries={},cases=[],performance_claim=False,formal_workloads=0)
    def persist():save(OUTPUT/'metadata.json',meta)
    def run(label,command,env=None,valid=True):
        need(require_lease(2)==lease,'Lease drift');environment=os.environ.copy();environment.update(CARGO_BUILD_JOBS='1',RUST_TEST_THREADS='1',RUSTFLAGS='',RUSTDOCFLAGS='',ASAN_OPTIONS='detect_leaks=1:halt_on_error=1');environment.update(env or {})
        record=dict(label=label,command=list(map(str,command)),explicit_environment=env or {},expected_success=valid,complete=False);meta['commands'].append(record);persist()
        r=subprocess.run(record['command'],cwd=ROOT,env=environment,pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
        for stream,data in [('stdout',r.stdout),('stderr',r.stderr)]:
            p=OUTPUT/(label+'.'+stream);p.write_bytes(data);record[stream]=p.name;record[stream+'_sha256']=sha(p)
        record['returncode']=r.returncode;persist();print(label,r.returncode,flush=True)
        need((r.returncode==0)==valid,'Unexpected command result; attempt preserved: '+label)
        if not valid:need(not r.stdout and r.stderr,'Invalid CLI emitted output or no diagnostic')
        record['complete']=True;persist();return r.stdout.decode()
    persist()
    try:
        run('caller-derivation',[sys.executable,CALLER/'derive.py'])
        run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_*.py'])
        source=(CALLER/'benchmark/src/main.rs').read_text();reference={};all_rows={};comparisons=0
        for mode in ['normal','asan']:
            cargo=['cargo']+(['+nightly']if mode=='asan'else[]);target_arg=['--target','x86_64-unknown-linux-gnu']if mode=='asan'else[]
            flags='-Zsanitizer=address -C symbol-mangling-version=v0'if mode=='asan'else'-C target-cpu=native -C symbol-mangling-version=v0'
            env=dict(CARGO_TARGET_DIR=str(TARGET/mode),RUSTFLAGS=flags)
            run(mode+'-rustc',['rustc']+(['+nightly']if mode=='asan'else[])+['-Vv'],env)
            for tool in ['cargo','rustc']:
                location=run(mode+'-'+tool+'-path',['rustup','which',*(['--toolchain','nightly']if mode=='asan'else[]),tool],env).strip();meta.setdefault('toolchains',{})[location]=sha(location)
            metadata=run(mode+'-metadata',cargo+['metadata','--locked','--offline','--format-version=1','--manifest-path',CALLER/'benchmark/Cargo.toml'],env)
            packages=cargo_packages(metadata,inventory)
            common=['--locked','--offline','--release','--manifest-path',CALLER/'benchmark/Cargo.toml',*target_arg,'--message-format=json']
            tests=run(mode+'-tests-build',cargo+['test',*common,'--no-run','--bin','compare_benchmark'],env)
            build=run(mode+'-caller-build',cargo+['build',*common,'--bin','compare_benchmark'],env)
            testbin=artifact(tests,True,TARGET/mode,packages);binary=artifact(build,False,TARGET/mode,packages)
            for p in [testbin,binary]:meta['binaries'][str(p)]=sha(p)
            repo={str(Path(n).relative_to(ROOT)):h for n,h in inventory['input_sha256'].items()if Path(n).is_relative_to(ROOT)}
            consumed,rules=collect(TARGET/mode,TARGET/mode,[tests,build],repo,ROOT,packages)
            generated=generated_inputs([tests,build],TARGET/mode,packages,consumed,inventory)
            representatives=[CALLER/'benchmark/src/main.rs',CALLER/'benchmark/src/poppy_adapter.rs',CALLER/'benchmark/src/poppy_geometry.rs',UPSTREAM/'poppy/src/bloom/v2.rs',ROOT/'experiments/2026-10-29-four-sector-range12-rust-port/native/src/four_sector_range12.rs']
            for p in representatives:need(str(p.resolve())in consumed,'Missing actual prepared compiler input '+str(p))
            for i,rule in enumerate(rules):(OUTPUT/f'{mode}-dependencies-{i}.d').write_text(rule['text'])
            save(OUTPUT/(mode+'-compiler-closure.json'),dict(inputs_sha256=consumed,generated_inputs=generated,rules=rules,package_metadata_sha256=sha(OUTPUT/(mode+'-metadata.stdout'))))
            meta.setdefault('compiler_inputs',{})[mode]=consumed;meta.setdefault('mode_executables',{})[mode]=str(binary);persist()
            for name in TESTS:
                text=run(mode+'-test-'+name,[testbin,name,'--test-threads=1'],env);need('test result: ok. 1 passed'in text,'Focused test missing')
            observed=[];by_batch={}
            for i,case in enumerate(cases(source)):
                rows=list(csv.DictReader(io.StringIO(run(f'{mode}-case-{i}',argv(binary,case),env))))
                validate_rows(rows,case,TINY,source);observed.extend(rows)
                if mode=='normal'and case['order']=='original':
                    old=list(csv.DictReader(io.StringIO(run('reference-batch-'+str(case['batch']),argv(original,case,True)))))
                    rc=dict(case,filters=[x for x in case['filters']if x!=P]);validate_rows(old,rc,TINY,source);reference[case['batch']]=old
                comparisons+=compare(rows,reference[case['batch']])
                prior=by_batch.setdefault(case['batch'],keyed(rows));need(prior==keyed(rows),'Order reversal changed row semantics')
                meta['cases'].append(dict(mode=mode,case=case,rows=len(rows)));persist()
            for i,command in enumerate(invalid(binary,source)):run(f'{mode}-invalid-{i}',command,env,False)
            all_rows[mode]=observed
        need(len(all_rows['normal'])==len(all_rows['asan'])==12 and comparisons==16,'Incorrect bounded coverage')
        need([semantic(r)for r in all_rows['normal']]==[semantic(r)for r in all_rows['asan']],'Normal/ASan semantic drift')
        meta['assembly']=capture(Path(meta['mode_executables']['normal']),OUTPUT,run,sha)
        need(verify(args.source_commit)==inventory and require_lease(2)==lease,'Final input/lease drift')
        for records in [meta['binaries'],meta['toolchains'],*meta['compiler_inputs'].values()]:
            for p,h in records.items():need(sha(p)==h,'Actual compiler input/tool/binary changed')
        meta.update(complete=True,focused_tests=8,real_capacity_fixtures=16,caller_rows=24,reference_invocations=2,reference_rows=4,semantic_reference_comparisons=16,invalid_cli_cases=12,manual_assembly_review_pending=True);persist()
    except BaseException as error:
        meta.update(error=repr(error),traceback=traceback.format_exc());persist();raise
if __name__=='__main__':main()
