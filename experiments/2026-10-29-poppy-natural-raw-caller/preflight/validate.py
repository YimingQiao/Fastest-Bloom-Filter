#!/usr/bin/env python3
"""Bounded natural-Poppy caller correctness and actual consumption proof; no formal screen."""
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
    lease=require_lease(3);inventory=verify(args.source_commit)
    inherited={k:os.environ.get(k)for k in FORBIDDEN};need(not any(inherited.values()),'Unfrozen build/runtime override')
    cargo_home=Path(os.environ.get('CARGO_HOME',Path.home()/'.cargo'));configs={}
    for base in [p/'.cargo'for p in [CALLER/'benchmark',*(CALLER/'benchmark').parents]]+[cargo_home]:
        for name in ['config','config.toml']:
            path=base/name
            if path.is_file():configs[str(path)]=sha(path)
    need(not configs,'Unfrozen Cargo configuration')
    need(not TARGET.exists()and not TARGET.is_symlink()and not OUTPUT.exists()and not OUTPUT.is_symlink(),'Preserve earlier attempts')
    OUTPUT.mkdir();meta=dict(complete=False,source_commit=args.source_commit,caller_source_commit=SOURCE,resolution_commit=RESOLUTION,reference_commit=REFERENCE,lease=lease,affinity=sorted(os.sched_getaffinity(0)),environment=inherited,commands=[],binaries={},cases=[],performance_claim=False,formal_workloads=0)
    def persist():save(OUTPUT/'metadata.json',meta)
    def run(label,command,env=None,rejection=None,stderr=None):
        need(require_lease(3)==lease,'Lease drift');environment=os.environ.copy();environment.update(CARGO_BUILD_JOBS='1',RUST_TEST_THREADS='1',RUSTFLAGS='',RUSTDOCFLAGS='',ASAN_OPTIONS='detect_leaks=1:halt_on_error=1');environment.update(env or {})
        record=dict(label=label,command=list(map(str,command)),explicit_environment=env or {},expected_success=rejection is None,expected_rejection=rejection,complete=False);meta['commands'].append(record);persist()
        result=subprocess.run(record['command'],cwd=ROOT,env=environment,pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
        for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
            path=OUTPUT/(label+'.'+stream);path.write_bytes(data);record[stream]=path.name;record[stream+'_sha256']=sha(path)
        record['returncode']=result.returncode;persist();print(label,result.returncode,flush=True)
        validate_process(result.returncode,result.stdout,result.stderr,rejection)
        if stderr is not None:need(result.stderr==stderr.encode(),'Unexpected caller stderr')
        record['complete']=True;persist();return result.stdout.decode()
    persist()
    try:
        # Source validation only, before either Rust build; never regenerate frozen files.
        run('source-recipes',[sys.executable,CALLER/'derive.py'])
        run('source-guards',[sys.executable,CALLER/'test_source.py'])
        run('offline-preflight-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_*.py'])
        modes={};by_name={};total=0
        for mode in ['normal','asan']:
            cargo=['cargo']+(['+nightly']if mode=='asan'else[]);target_arg=['--target','x86_64-unknown-linux-gnu']if mode=='asan'else[]
            flags='-Zsanitizer=address -C symbol-mangling-version=v0'if mode=='asan'else'-C target-cpu=native -C symbol-mangling-version=v0'
            env=dict(CARGO_TARGET_DIR=str(TARGET/mode),RUSTFLAGS=flags)
            run(mode+'-rustc',['rustc']+(['+nightly']if mode=='asan'else[])+['-Vv'],env)
            for tool in ['cargo','rustc']:
                location=run(mode+'-'+tool+'-path',['rustup','which',*(['--toolchain','nightly']if mode=='asan'else[]),tool],env).strip();meta.setdefault('toolchains',{})[location]=sha(location)
            text=run(mode+'-metadata',cargo+['metadata','--locked','--offline','--format-version=1','--manifest-path',CALLER/'benchmark/Cargo.toml'],env)
            packages=cargo_packages(text,inventory)
            common=['--locked','--offline','--release','--manifest-path',CALLER/'benchmark/Cargo.toml',*target_arg,'--message-format=json']
            tests=run(mode+'-tests-build',cargo+['test',*common,'--no-run','--bin','poppy_raw_benchmark'],env)
            built=run(mode+'-caller-build',cargo+['build',*common,'--bin','poppy_raw_benchmark'],env)
            testbin=artifact(tests,True,TARGET/mode,packages);binary=artifact(built,False,TARGET/mode,packages)
            for path in [testbin,binary]:meta['binaries'][str(path)]=sha(path)
            repo={str(Path(name).relative_to(ROOT)):digest for name,digest in inventory['input_sha256'].items()if Path(name).is_relative_to(ROOT)}
            consumed,rules=collect(TARGET/mode,TARGET/mode,[tests,built],repo,ROOT,packages)
            generated=generated_inputs([tests,built],TARGET/mode,packages,consumed,inventory)
            required=[CALLER/'benchmark/src'/name for name in ['main.rs','reporter.rs','raw_contract.rs','poppy_raw.rs','poppy_geometry.rs','poppy_tests.rs','reporter_tests.rs']]
            required += [PARENT/'native/src/four_sector_range12.rs',PARENT/'native/src/split64_range.rs',PARENT/'upstream/fastbloom-rs/src/bloom.rs',ROOT/'build/poppy-source/poppy/src/bloom/v2.rs',ROOT/'build/poppy-source/poppy/src/hash.rs',ROOT/'build/poppy-source/poppy/src/hash/wyhash.rs']
            for path in required:need(str(path.resolve())in consumed,'Missing actual prepared module: '+str(path))
            for index,rule in enumerate(rules):(OUTPUT/f'{mode}-dependencies-{index}.d').write_text(rule['text'])
            save(OUTPUT/(mode+'-compiler-closure.json'),dict(inputs_sha256=consumed,generated_inputs=generated,rules=rules,package_metadata_sha256=sha(OUTPUT/(mode+'-metadata.stdout'))))
            meta.setdefault('compiler_inputs',{})[mode]=consumed;meta.setdefault('mode_executables',{})[mode]=str(binary);persist()
            # Actual input closure has now passed; only now may tests/BF execute.
            for index,name in enumerate(TESTS):
                text=run(f'{mode}-test-{index}',[testbin,name,'--exact','--test-threads=1'],env);need('test result: ok. 1 passed'in text,'Focused test missing')
            observed=[]
            for index,case in enumerate(cases()):
                rows=list(csv.DictReader(io.StringIO(run(f'{mode}-case-{index}',argv(binary,case),env,stderr=inventory['expected_stderr'][mode]['text']))))
                validate_rows(rows,case)
                if index==0:
                    reference=list(csv.DictReader(Path(inventory['parent_reference'][mode]['path']).read_text().splitlines()))
                    validate_reference(rows,reference)
                for row in rows:need(by_name.setdefault(row['filter'],semantic(row))==semantic(row),'Cross-batch/backend raw semantic drift')
                observed.extend(rows);total+=len(rows);meta['cases'].append(dict(mode=mode,case=case,rows=len(rows)));persist()
            for index,rejection in enumerate(invalid(binary)):run(f'{mode}-invalid-{index}',rejection['command'],env,rejection=rejection)
            modes[mode]=observed
        need(total==146 and len(modes['normal'])==len(modes['asan'])==73 and len(by_name)==59,'Wrong focused coverage')
        meta['functional_complete']=True;persist()
        meta['assembly']=capture(Path(meta['mode_executables']['normal']),OUTPUT,run)
        need(verify(args.source_commit)==inventory and require_lease(3)==lease,'Final source/lease changed')
        for values in [meta['binaries'],meta['toolchains'],*meta['compiler_inputs'].values()]:
            for path,digest in values.items():need(sha(path)==digest,'Actual compiler input/tool/binary changed')
        meta.update(complete=True,focused_test_executions=8,new_real_constructor_forms_per_mode=28,partial_load_inserted_keys_per_form=1031,new_small_full_load_rows_per_mode=28,parent_control_comparisons=90,caller_rows=146,invalid_cli_cases=12,manual_assembly_review_pending=True);persist()
    except BaseException as error:meta.update(error=repr(error),traceback=traceback.format_exc());persist();raise
if __name__=='__main__':main()
