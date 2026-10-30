#!/usr/bin/env python3
"""Two rebuilt callers; 20 tiny rows, 8 invalid CLIs, 4 faults; no formal run."""
if not __debug__:
    raise RuntimeError('Python -O forbidden')
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import traceback
from guards import HERE,ROOT,need,sha,save,verify,packages,executable
from contract import cases,argv,validate_rows,invalid,SEMANTIC
from dependencies import collect
from lease import require_lease
from asm import capture

TARGET=Path('/tmp/fastest-bf-rust-k12-simd-internal-v1-cpu3')
OUTPUT=HERE/'validation-v1'
FORBIDDEN=['RUSTFLAGS','RUSTDOCFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS',
 'RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CARGO_TARGET_DIR','RUSTC','RUSTDOC','RUSTUP_TOOLCHAIN',
 'CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS',
 'CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER','LD_PRELOAD','LD_LIBRARY_PATH',
 'MALLOC_CONF','MALLOC_ARENA_MAX','GLIBC_TUNABLES','ASAN_OPTIONS','UBSAN_OPTIONS']
PROFILES=[('native','-C target-cpu=native'),('portable','-C target-cpu=x86-64')]

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);args=parser.parse_args()
    lease=require_lease(3);inventory=verify(args.source_commit)
    inherited={k:os.environ.get(k) for k in FORBIDDEN};need(not any(inherited.values()),'unfrozen environment override')
    cpu=Path('/sys/devices/system/cpu/cpu3')
    topology=dict(cpu=3,socket=int((cpu/'topology/physical_package_id').read_text()),
                  core=int((cpu/'topology/core_id').read_text()),nodes=sorted(int(p.name[4:]) for p in cpu.glob('node[0-9]*')))
    need(topology['socket']==1 and topology['nodes']==[1],'unexpected CPU3 topology')
    tools={name:str(Path(shutil.which(name) or '/missing').absolute()) for name in ['taskset','numactl']}
    need(all(Path(p).is_file() for p in tools.values()),'placement tools unavailable')
    prefix=[tools['taskset'],'-c','3',tools['numactl'],'--physcpubind=3','--membind=1']
    cargo_home=Path(os.environ.get('CARGO_HOME',Path.home()/'.cargo'))
    for base in [p/'.cargo' for p in [HERE,*HERE.parents]]+[cargo_home]:
        for name in ['config','config.toml']:need(not(base/name).exists(),'unfrozen Cargo config')
    need(not TARGET.exists() and not TARGET.is_symlink() and not OUTPUT.exists() and not OUTPUT.is_symlink(),'preserve prior attempt')
    OUTPUT.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,lease=lease,affinity=sorted(os.sched_getaffinity(0)),
              topology=topology,workload_prefix=prefix,environment=inherited,commands=[],binaries={},
              toolchains={p:sha(p) for p in tools.values()},compiler_inputs={},cases=[],
              formal_measurements=0,calibration_queries=0,incidental_check_timings_not_ranked=True)
    def persist():save(OUTPUT/'metadata.json',meta)
    def run(label,command,env=None,reject=None,workload=False):
        need(require_lease(3)==lease,'lease changed')
        environment=os.environ.copy();environment.update(CARGO_BUILD_JOBS='1',RUSTFLAGS='',RUSTDOCFLAGS='')
        environment.update(env or {})
        rec=dict(label=label,command=list(map(str,(prefix if workload else [])+list(command))),
                 explicit_environment=env or {},expected_rejection=reject,complete=False)
        meta['commands'].append(rec);persist()
        done=subprocess.run(rec['command'],cwd=ROOT,env=environment,
                            pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
        for stream,data in [('stdout',done.stdout),('stderr',done.stderr)]:
            path=OUTPUT/(label+'.'+stream);path.write_bytes(data);rec[stream]=path.name;rec[stream+'_sha256']=sha(path)
        rec['returncode']=done.returncode;persist();print(label,done.returncode,flush=True)
        if reject is not None:
            need(done.returncode==1 and not done.stdout and done.stderr==(reject+'\n').encode(),'wrong failure diagnostic')
        else:
            need(done.returncode==0,'command failed: '+label)
            if workload:need(not done.stderr,'unexpected caller stderr')
        rec['complete']=True;persist();return done.stdout.decode()
    def closure():
        need(verify(args.source_commit)==inventory,'prepared source changed')
        for mapping in [meta['binaries'],meta['toolchains'],*meta['compiler_inputs'].values()]:
            for path,digest in mapping.items():need(sha(path)==digest,'actual input/tool/binary changed: '+path)
    persist()
    try:
        run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_contract.py'])
        signatures={};executables={}
        for mode,flags in PROFILES:
            env=dict(CARGO_TARGET_DIR=str(TARGET/mode),RUSTFLAGS=flags+' -C symbol-mangling-version=v0')
            for tool in ['cargo','rustc']:
                path=run(mode+'-'+tool+'-path',['rustup','which',tool],env).strip()
                need(Path(path).is_file(),'missing toolchain tool');meta['toolchains'][path]=sha(path)
            run(mode+'-rustc-version',['rustc','-Vv'],env);closure()
            known=packages(run(mode+'-metadata',['cargo','metadata','--format-version=1','--locked','--offline','--manifest-path',HERE/'Cargo.toml'],env))
            build_text=run(mode+'-caller-build',['cargo','build','--release','--locked','--offline','--manifest-path',HERE/'Cargo.toml',
                '--message-format=json','--bin','rust-k12-simd-caller'],env)
            binary=executable(build_text,TARGET/mode,known)
            meta['binaries'][str(binary)]=sha(binary);executables[mode]=str(binary);meta['executables']=executables;persist()
            consumed,rules=collect(TARGET/mode,TARGET/mode,[build_text],inventory,ROOT,known)
            required=[HERE/'main.rs',HERE/'query.rs']+[HERE/arm/'src'/name for arm in ['control','candidate'] for name in ['lib.rs','four_sector_range12.rs','k12_parallel.rs']]
            need(all(str(path.resolve()) in consumed for path in required),'required native/caller input missing')
            for index,rule in enumerate(rules):(OUTPUT/f'{mode}-dependency-{index}.d').write_text(rule['text'])
            save(OUTPUT/(mode+'-compiler-closure.json'),dict(inputs_sha256=consumed,rules=rules))
            meta['compiler_inputs'][mode]=consumed;persist();closure()
            for index,case in enumerate(cases()):
                closure()
                rows=[json.loads(line) for line in run(f'{mode}-case-{index}',argv(binary,case),env,workload=True).splitlines()]
                validate_rows(rows,case,mode)
                signature=[{k:r[k] for k in SEMANTIC} for r in sorted(rows,key=lambda r:r['filter'])]
                key=(case['batch'],case['reverse']);need(signatures.setdefault(key,signature)==signature,'cross-profile semantic drift')
                meta['cases'].append(dict(profile=mode,case=case,rows=2));persist()
            for index,(command,diagnostic) in enumerate(invalid(binary)):
                run(f'{mode}-invalid-{index}',command,env,reject=diagnostic,workload=True)
            for fault in ['generic-skip','visible-wrong']:
                run(mode+'-fault-'+fault,argv(binary,dict(batch=1,reverse=False))+['--fault',fault],env,
                    reject='full output mismatch',workload=True)
            closure()
        need(len(meta['cases'])==10 and len(meta['binaries'])==2,'wrong bounded proof coverage')
        meta['functional_complete']=True;persist()
        meta['assembly']={mode:capture(Path(executables[mode]),OUTPUT,run,mode+'-asm') for mode in ['native','portable']}
        closure()
        meta.update(complete=True,caller_rows=20,invalid_cli_cases=8,fault_cases=4,
                    kernel_matrix_reexecutions=0,manual_assembly_review_pending=True);persist()
    except BaseException as error:
        meta.update(error=repr(error),traceback=traceback.format_exc());persist();raise

if __name__=='__main__':main()
