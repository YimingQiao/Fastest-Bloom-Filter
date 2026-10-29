#!/usr/bin/env python3
"""No-research bounded actual-caller correctness and compiler-closure preflight."""
if not __debug__:raise RuntimeError('Python -O is forbidden')
import argparse,csv,hashlib,importlib.util,io,json,os,shutil,subprocess,sys,traceback
from pathlib import Path
from bindings import *
from contract import TINY,K12,cases,argv,compare,invalid
from dependencies import collect
from derive_guard import generate
from guard import validate_rows
from source_guard import require_lease

REJECT=['RUSTFLAGS','RUSTDOCFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CARGO_TARGET_DIR','RUSTC','RUSTDOC','RUSTUP_TOOLCHAIN','CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER','LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','GLIBC_TUNABLES']
TESTS=['actual_harness_detects_corrupt_last_output_in_every_timed_mode','four_mode_order_balances_positions_and_predecessors','k12_actual_public_adapter_allocation_and_dense_output']

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);args=parser.parse_args()
    lease=require_lease(3);pins,external,external_roots,original=verify(args.source_commit)
    need(not any(os.environ.get(k)for k in REJECT),'Unfrozen compiler/loader override')
    cargo_home=Path(os.environ.get('CARGO_HOME',Path.home()/'.cargo'));configs=[p/name for base in [ROOT,CALLER/'benchmark',*ROOT.parents,*CALLER.parents] for p in [base/'.cargo'] for name in ['config','config.toml']]+[cargo_home/name for name in ['config','config.toml']]
    need(not any(p.is_file()for p in configs),'Unfrozen Cargo configuration file')
    source=(CALLER/'benchmark/src/main.rs').read_text();need((HERE/'guard.py').read_text()==generate(),'Derived row guard drift')
    spec=importlib.util.spec_from_file_location('old_guard',OLD_STAGE/'guard.py');old_guard=importlib.util.module_from_spec(spec);spec.loader.exec_module(old_guard)
    old_source=(OLD_PUBLIC/'src/main.rs').read_text()
    target=Path('/tmp/fastest-bf-rust-k12-caller-v1-cpu3');output=CALLER/'validation-v1'
    need(not target.exists()and not target.is_symlink()and not output.exists()and not output.is_symlink(),'Preserve every prior attempt; use a reviewed new version')
    output.mkdir();meta=dict(complete=False,source_commit=args.source_commit,proposal_commit=PROPOSAL,kernel_proof_commit=K12_PROOF,lease=lease,affinity=sorted(os.sched_getaffinity(0)),prepared_input_sha256=pins,commands=[],binaries={},cases=[],performance_claim=False,fresh_inputs=False)
    def persist():save(output/'metadata.json',meta)
    def run(label,command,env=None,valid=True):
        need(require_lease(3)==lease,'Lease drift')
        environment=os.environ.copy();environment.update(CARGO_BUILD_JOBS='1',RUST_TEST_THREADS='1',RUSTFLAGS='',RUSTDOCFLAGS='',ASAN_OPTIONS='detect_leaks=1:halt_on_error=1');environment.update(env or {})
        record=dict(label=label,command=list(map(str,command)),explicit_environment=env or {},complete=False,expected_success=valid);meta['commands'].append(record);persist()
        result=subprocess.run(record['command'],cwd=ROOT,env=environment,pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
        for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
            path=output/(label+'.'+stream);path.write_bytes(data);record[stream]=path.name;record[stream+'_sha256']=sha(path)
        record['returncode']=result.returncode;persist();print(label,result.returncode,flush=True)
        if valid:need(result.returncode==0,'Failed '+label+'; attempt retained')
        else:need(result.returncode!=0 and not result.stdout and result.stderr,'Invalid CLI accepted or emitted output')
        record['complete']=True;persist();return result.stdout.decode()
    persist()
    try:
        run('caller-derivation',[sys.executable,CALLER/'derive.py']);run('guard-derivation',[sys.executable,HERE/'derive_guard.py'])
        run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_*.py'])
        references={};all_rows={};comparison_count=0
        for mode in ['normal','asan']:
            cargo=['cargo']+(['+nightly']if mode=='asan'else[]);target_arg=['--target','x86_64-unknown-linux-gnu']if mode=='asan'else[]
            flags='-Zsanitizer=address'if mode=='asan'else'-C target-cpu=native -C symbol-mangling-version=v0';env=dict(CARGO_TARGET_DIR=str(target/mode),RUSTFLAGS=flags)
            run(mode+'-rustc',['rustc']+(['+nightly']if mode=='asan'else[])+['-Vv'],env)
            metadata=run(mode+'-cargo-metadata',cargo+['metadata','--locked','--offline','--format-version=1','--manifest-path',CALLER/'benchmark/Cargo.toml'],env)
            packages=cargo_packages(metadata,pins,external,external_roots)
            common=['--locked','--offline','--release','--manifest-path',CALLER/'benchmark/Cargo.toml',*target_arg,'--message-format=json']
            tests_json=run(mode+'-tests-build',cargo+['test',*common,'--no-run','--bin','compare_benchmark'],env)
            binary_json=run(mode+'-caller-build',cargo+['build',*common,'--bin','compare_benchmark'],env)
            for text in [tests_json,binary_json]:
                for line in text.splitlines():
                    event=json.loads(line)
                    if event.get('reason')!='compiler-artifact':continue
                    manifest=Path(event['manifest_path']).resolve()
                    if manifest.is_relative_to(ROOT):need(pins.get(str(manifest.relative_to(ROOT)))==sha(manifest),'Unbound emitted local manifest')
                    else:need(str(manifest.parent)in external_roots and external.get(str(manifest))==sha(manifest),'Unbound emitted external manifest')
            testbin=artifact(tests_json,True,target/mode,packages);binary=artifact(binary_json,False,target/mode,packages)
            for path in [testbin,binary]:meta['binaries'][str(path)]=sha(path)
            # No test/filter execution before resolving every emitted dep-info.
            consumed,rules=collect(target/mode,target/mode,[tests_json,binary_json],pins,ROOT,packages)
            external_used={}
            for name,digest in consumed.items():
                path=Path(name)
                if not path.is_relative_to(ROOT):need(external.get(name)==digest,'Unbound external compiler input '+name);external_used[name]=digest
            representatives=[CALLER/'benchmark/src/main.rs',CALLER/'benchmark/src/k12_adapter.rs',OLD_NATIVE/'src/lib.rs',OLD_NATIVE/'src/split64_range.rs',K12_NATIVE/'src/lib.rs',K12_NATIVE/'src/four_sector_range12.rs']
            for path in representatives:need(str(path.resolve())in consumed,'Missing actual local-package/module consumer '+str(path))
            for index,rule in enumerate(rules):(output/f'{mode}-dependencies-{index}.d').write_text(rule['text'])
            save(output/f'{mode}-compiler-closure.json',dict(inputs_sha256=consumed,external_inputs_sha256=external_used,rules=rules,package_metadata_sha256=hashlib.sha256(metadata.encode()).hexdigest()))
            meta.setdefault('compiler_consumed_inputs_sha256',{})[mode]=consumed;meta.setdefault('mode_executables',{})[mode]=str(binary);persist()
            for test in TESTS:
                text=run(mode+'-test-'+test,[testbin,test,'--test-threads=1'],env);need('test result: ok. 1 passed'in text,'Missing focused test result')
            rows_all=[]
            for index,case in enumerate(cases(source)):
                rows=list(csv.DictReader(io.StringIO(run(f'{mode}-case-{index}',argv(binary,case),env))))
                validate_rows(rows,case,TINY,source);rows_all.extend(rows)
                old_case=dict(case,filters=[n for n in case['filters']if n!=K12])
                if mode=='normal':
                    old_rows=list(csv.DictReader(io.StringIO(run(f'reference-case-{index}',argv(original,old_case)))))
                    # Old validator is unchanged; its full-registry assumption is
                    # satisfied via an isolated subset registry only for order.
                    expected=old_guard.shuffled(old_case['filters'],(42+old_guard.STEP*((1<<10)+(1<<12)+((1<<12)//100*50+min((1<<12)%100,50))-1))&old_guard.MASK)
                    need([r['filter']for r in old_rows]==expected,'Old subset row order drift')
                    references[index]=old_rows
                comparison_count+=compare(rows,references[index]);meta['cases'].append(dict(mode=mode,index=index,case=case,rows=len(rows),old_semantic_rows=len(references[index])));persist()
            for index,command in enumerate(invalid(binary)):run(f'{mode}-invalid-{index}',command,env,False)
            all_rows[mode]=rows_all
        need(len(all_rows['normal'])==len(all_rows['asan'])==42 and comparison_count==76,'Wrong bounded coverage')
        for a,b in zip(all_rows['normal'],all_rows['asan']):
            from contract import semantic
            need(semantic(a)==semantic(b),'Normal/ASan complete row semantics differ')
        from asm import capture
        meta['assembly']=capture(Path(meta['mode_executables']['normal']),output,run,sha);persist()
        verify(args.source_commit);need(require_lease(3)==lease,'Final lease drift')
        for name,digest in meta['binaries'].items():need(sha(Path(name))==digest,'Executable changed')
        for group in meta['compiler_consumed_inputs_sha256'].values():
            for name,digest in group.items():need(sha(Path(name))==digest,'Consumed source changed')
        meta.update(complete=True,focused_test_executions=6,caller_rows=84,retained_reference_rows=38,retained_semantic_comparisons=76,invalid_cli_cases=12,throughput_workloads=0,kernel_matrix_repeated=False);persist()
    except BaseException as error:
        meta['error']=repr(error);meta['traceback']=traceback.format_exc();persist();raise
if __name__=='__main__':main()
