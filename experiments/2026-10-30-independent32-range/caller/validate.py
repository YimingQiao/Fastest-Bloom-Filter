#!/usr/bin/env python3
"""One finite actual-caller proof; no formal seeds and no performance ranking."""
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
TARGET=Path('/tmp/fastest-bf-independent32-range-caller-v1-cpu3')
def save(path,value):Path(path).write_text(json.dumps(value,indent=2)+'\n')

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True)
    parser.add_argument('--execute-correctness',action='store_true');args=parser.parse_args()
    need(args.execute_correctness,'explicit correctness flag required');placement=require()
    for name in ('CC','CXX','CMAKE_TOOLCHAIN_FILE','CMAKE_PREFIX_PATH'):
        need(not os.environ.get(name),'unfrozen build environment override')
    prepared=verify(args.source_commit)
    for path in (OUT,TARGET):need(not path.exists() and not path.is_symlink(),'fresh output/build paths required')
    # Preserve clang++ argv[0]; resolving it to clang breaks C++ runtime linking.
    compiler='/usr/bin/clang++'
    tools={name:shutil.which(name) for name in ('cmake','nm','objdump','readelf','c++filt','numactl')}
    need(all(tools.values()) and Path(compiler).is_file(),'required tools missing')
    tool_hashes={p:sha(p) for p in (compiler,sys.executable,*tools.values())}
    OUT.mkdir();TARGET.mkdir()
    metadata=dict(complete=False,source_commit=args.source_commit,
        start=datetime.datetime.now(datetime.timezone.utc).isoformat(),placement=placement,
        source_sha256=prepared,tools_sha256=tool_hashes,compiler=compiler,
        compiler_resolved_path=str(Path(compiler).resolve()),formal_workloads=0)
    commands=[];binaries={};inputs={};records={};allocations={};save(OUT/'metadata.json',metadata)

    def run(label,argv,success=True,input_text=None):
        need(require()==placement,'lease changed before command');recheck(tool_hashes)
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
        macros,_=run('native-backend-macros',[compiler,'-march=native','-dM','-E','-x','c++','/dev/null'])
        for name in ('__AVX512VBMI__','__AVX512VL__','__AVX2__'):
            need('#define '+name+' 1' in macros.read_text(),'required native backend missing: '+name)
        metadata['independent_backend']='avx512vbmi-vl'
        policy,_=run('numa-policy',[tools['numactl'],'--physcpubind=3','--membind=1','--show'])
        need('membind: 1' in policy.read_text(),'NUMA policy probe failed')
        for profile,sanitizers in (('normal','OFF'),('asan','ON')):
            check_live();folder=TARGET/profile
            run(profile+'-configure',[tools['cmake'],'-S',HERE,'-B',folder,'-DCMAKE_BUILD_TYPE=Release',
                '-DCMAKE_CXX_COMPILER='+compiler,'-DBF_SANITIZERS='+sanitizers])
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
            allocations[profile]=[];records[profile]=[]
            for i,case in enumerate(ALLOCATION_CASES):
                check_live();stdout,stderr=run(profile+f'-allocation-{i}',[*prefix,*arguments(case,'--geometry')])
                need(stderr.read_bytes()==b'','allocation diagnostic unexpected')
                allocations[profile].append(dict(case=case,rows=parse(stdout.read_text(),case,allocation=True)))
                save(OUT/'allocation-records.json',allocations)
            for i,case in enumerate(CASES):
                check_live();stdout,stderr=run(profile+f'-case-{i}',[*prefix,*arguments(case)])
                need(stderr.read_bytes()==b'','caller diagnostic unexpected')
                records[profile].append(dict(case=case,rows=parse(stdout.read_text(),case)))
                save(OUT/'records.json',records)
            cross_batch(records[profile]);old_reference(records[profile],profile)
        need(allocations['normal']==allocations['asan'],'backend allocation mismatch')
        for a,b in zip(records['normal'],records['asan'],strict=True):
            need(a['case']==b['case'] and [semantic(r)for r in a['rows']]==[semantic(r)for r in b['rows']],
                 'backend full semantic mismatch')
        prefix=[tools['numactl'],'--physcpubind=3','--membind=1',TARGET/'normal/main']
        def reject(label,argv,diagnostic):
            check_live();stdout,stderr=run(label,[*prefix,*argv],success=False)
            need(commands[-1]['returncode']==1 and stdout.read_bytes()==b'' and stderr.read_text()==diagnostic,
                 'wrong rejection, partial output or crash')
        for i in (0,1):reject('fault-'+str(i),arguments(CASES[i],'--fault'),'full output mismatch\n')
        for i,(argv,diagnostic)in enumerate(invalid_cases()):reject('invalid-'+str(i),argv,diagnostic)
        check_live();metadata['assembly']=capture(TARGET/'normal/main',tools,run)
        need(verify(args.source_commit)==prepared,'final committed source identity changed');check_live()
        metadata.update(complete=True,end=datetime.datetime.now(datetime.timezone.utc).isoformat(),
            manual_review_pending=True,counts=dict(profiles=2,caller_cases=6,caller_rows=66,
                allocation_cases=4,allocation_rows=36,old_semantic_rows=14,faults=2,invalid=6,formal_workloads=0))
    except BaseException as exc:
        metadata.update(error=repr(exc),end=datetime.datetime.now(datetime.timezone.utc).isoformat())
        save(OUT/'metadata.json',metadata);raise
    save(OUT/'metadata.json',metadata)
    print('Focused 66-row public caller proof complete; actual ASM/manual gate remains pending. No formal timing.')

if __name__=='__main__':main()
