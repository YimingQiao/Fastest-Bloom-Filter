#!/usr/bin/env python3
"""Three actual callers, one finite queue check and tiny public cases; never formal data."""
import argparse
import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
if not __debug__:raise SystemExit('Python -O is unsupported')
from contract import CASES,ALLOCATION_CASES,arguments,need,parse,semantic,cross_batch,old_reference,invalid_cases
from lease import require
from source_guard import HERE,ROOT,sha,verify,consumed,recheck
from asm import capture

OUT=HERE/'validation-v1'
TARGET=Path('/tmp/fastest-bf-independent32-prefetch64-caller-v1-cpu3')
PROFILES=(('normal','native','OFF','avx512vbmi-vl'),
          ('avx2','avx2','OFF','avx2'),('asan','native','ON','avx512vbmi-vl'))
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True)
    parser.add_argument('--execute-correctness',action='store_true');args=parser.parse_args()
    need(args.execute_correctness,'explicit correctness flag required');placement=require()
    for name in ('CC','CXX','CMAKE_TOOLCHAIN_FILE','CMAKE_PREFIX_PATH'):
        need(not os.environ.get(name),'unfrozen build environment override')
    prepared=verify(args.source_commit)
    for path in (OUT,TARGET):need(not path.exists() and not path.is_symlink(),'fresh output/build paths required')
    compiler='/usr/bin/clang++'  # Keep C++ argv[0], even when it is a clang symlink.
    tools={name:shutil.which(name) for name in ('cmake','nm','objdump','readelf','c++filt','numactl')}
    need(all(tools.values()) and Path(compiler).is_file(),'required tools missing')
    tool_hashes={p:sha(p) for p in (compiler,sys.executable,*tools.values())}
    OUT.mkdir();TARGET.mkdir()
    metadata=dict(complete=False,source_commit=args.source_commit,placement=placement,
        start=datetime.datetime.now(datetime.timezone.utc).isoformat(),source_sha256=prepared,
        tools_sha256=tool_hashes,compiler=compiler,compiler_resolved_path=str(Path(compiler).resolve()),
        formal_workloads=0,focused={},backend={},assembly={})
    commands=[];binaries={};inputs={};records={};allocations=[];save(OUT/'metadata.json',metadata)

    def run(label,argv,success=True,input_text=None):
        need(require()==placement,'whole lease changed');recheck(tool_hashes)
        prefix=f'{len(commands):03d}-{label}';stdout=OUT/(prefix+'.stdout');stderr=OUT/(prefix+'.stderr')
        with stdout.open('wb')as out,stderr.open('wb')as err:
            result=subprocess.run(list(map(str,argv)),cwd=ROOT,stdout=out,stderr=err,
                input=None if input_text is None else input_text.encode(),
                pass_fds=tuple(map(int,placement['fd_evidence'])))
        commands.append(dict(label=label,argv=list(map(str,argv)),cwd=str(ROOT),returncode=result.returncode,
            expected_success=success,stdout=str(stdout.relative_to(HERE)),stderr=str(stderr.relative_to(HERE)),
            stdout_sha256=sha(stdout),stderr_sha256=sha(stderr)))
        if input_text is not None:
            import hashlib
            commands[-1]['input_sha256']=hashlib.sha256(input_text.encode()).hexdigest()
        save(OUT/'commands.json',commands)
        need((result.returncode==0)==success,'unexpected command outcome: '+label)
        return stdout,stderr

    def check_live():
        recheck(prepared);recheck(tool_hashes);recheck(binaries)
        for group in inputs.values():recheck(group)
        need(require()==placement,'whole lease changed')

    try:
        run('derive-source',[sys.executable,HERE/'derive.py'])
        run('compiler-version',[compiler,'--version'])
        for isa,flag in (('native','-march=native'),('avx2','-march=x86-64-v3')):
            macros,_=run(isa+'-macros',[compiler,flag,'-dM','-E','-x','c++','/dev/null'])
            text=macros.read_text();need('#define __AVX2__ 1' in text,'AVX2 path required')
            if isa=='native':
                need(all('#define '+m+' 1' in text for m in ('__AVX512VBMI__','__AVX512VL__')),'native VBMI/VL missing')
            else:need('#define __AVX512F__ 1' not in text,'AVX2 profile unexpectedly enables AVX512')
        policy,_=run('numa-policy',[tools['numactl'],'--physcpubind=3','--membind=1','--show'])
        need('membind: 1' in policy.read_text(),'NUMA policy probe failed')
        for profile,isa,sanitizers,backend in PROFILES:
            check_live();folder=TARGET/profile
            run(profile+'-configure',[tools['cmake'],'-S',HERE,'-B',folder,'-DCMAKE_BUILD_TYPE=Release',
                '-DCMAKE_CXX_COMPILER='+compiler,'-DBF_ISA='+isa,'-DBF_SANITIZERS='+sanitizers])
            run(profile+'-build',[tools['cmake'],'--build',folder,'--target','main','-j','1'])
            binary=folder/'main';binaries[str(binary)]=sha(binary)
            metadata['all_binary_sha256']=dict(binaries);save(OUT/'metadata.json',metadata)
            for name in ('compile_commands.json','CMakeCache.txt'):
                shutil.copyfile(folder/name,OUT/(profile+'-'+name))
            dep=folder/'CMakeFiles/main.dir/main.cpp.o.d';shutil.copyfile(dep,OUT/(profile+'-main.d'))
            inputs[profile]=consumed(dep,prepared)
            metadata['compiler_inputs']=dict(inputs)
            metadata['compiler_consumed_input_sha256']={p:h for group in inputs.values()for p,h in group.items()}
            save(OUT/'metadata.json',metadata);check_live()
            prefix=[tools['numactl'],'--physcpubind=3','--membind=1',binary]
            stdout,stderr=run(profile+'-focused',[*prefix,'--prefetch-check'])
            expected='PASS backend='+backend+';4 geometry pairs;648 calls per arm;360 bulk requests;98304B representative allocation\n'
            need(stdout.read_text()==expected and stderr.read_bytes()==b'','focused backend/coverage failure')
            metadata['focused'][profile]=dict(calls_per_arm=648,bulk_requests=360,zero_null_per_arm=4)
            metadata['backend'][profile]=backend;save(OUT/'metadata.json',metadata)
            if profile=='normal':
                for i,case in enumerate(ALLOCATION_CASES):
                    check_live();stdout,stderr=run(profile+f'-allocation-{i}',[*prefix,*arguments(case,'--geometry')])
                    need(stderr.read_bytes()==b'','allocation diagnostic')
                    allocations.append(dict(case=case,rows=parse(stdout.read_text(),case,allocation=True)))
                    save(OUT/'allocation-records.json',allocations)
            records[profile]=[]
            for i,case in enumerate(CASES):
                check_live();stdout,stderr=run(profile+f'-case-{i}',[*prefix,*arguments(case)])
                need(stderr.read_bytes()==b'','caller diagnostic')
                records[profile].append(dict(case=case,rows=parse(stdout.read_text(),case)))
                save(OUT/'records.json',records)
            cross_batch(records[profile]);old_reference(records[profile],'asan' if profile=='asan' else 'normal')
        for profile in ('avx2','asan'):
            for a,b in zip(records['normal'],records[profile],strict=True):
                need(a['case']==b['case'] and [semantic(r)for r in a['rows']]==[semantic(r)for r in b['rows']],
                     'backend full semantic mismatch')
        prefix=[tools['numactl'],'--physcpubind=3','--membind=1',TARGET/'normal/main']
        def reject(label,argv,diagnostic):
            check_live();stdout,stderr=run(label,[*prefix,*argv],success=False)
            need(commands[-1]['returncode']==1 and stdout.read_bytes()==b'' and stderr.read_text()==diagnostic,
                 'wrong rejection, partial output or crash')
        for i in (0,2):reject('fault-'+str(i),arguments(CASES[i],'--fault'),'full output mismatch\n')
        for i,(argv,diagnostic)in enumerate(invalid_cases()):reject('invalid-'+str(i),argv,diagnostic)
        for profile in ('normal','avx2'):
            check_live();metadata['assembly'][profile]=capture(TARGET/profile/'main',tools,run,profile)
            save(OUT/'metadata.json',metadata)
        need(verify(args.source_commit)==prepared,'final committed source identity changed');check_live()
        metadata.update(complete=True,end=datetime.datetime.now(datetime.timezone.utc).isoformat(),
            manual_review_pending=True,counts=dict(profiles=3,binaries=3,focused_modes=3,
                focused_calls_per_arm=1944,focused_bulk_requests=1080,extra_zero_null_calls_per_arm=12,
                caller_cases=9,caller_rows=90,allocation_cases=2,allocation_rows=16,
                old_semantic_rows=21,faults=2,invalid=6,formal_workloads=0))
    except BaseException as exc:
        metadata.update(error=repr(exc),end=datetime.datetime.now(datetime.timezone.utc).isoformat())
        save(OUT/'metadata.json',metadata);raise
    save(OUT/'metadata.json',metadata)
    print('Three-profile focused/public proof complete; actual ASM/manual gate pending. No formal timing.')

if __name__=='__main__':main()
