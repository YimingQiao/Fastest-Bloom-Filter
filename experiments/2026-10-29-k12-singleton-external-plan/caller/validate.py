#!/usr/bin/env python3
"""Single focused correctness attempt. Never executes the fresh formal seeds."""
import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys

if not __debug__:raise SystemExit('Python -O is unsupported')
from contract import CASES,ALLOCATION_CASES,arguments,need,parse,semantics,old_reference
from lease import require

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
OUT=HERE/'validation-v1'
TARGET=Path('/tmp/fastest-bf-k12-singleton-external-v1-cpu3')
PLAN_COMMIT='61f068907665fef2cb8ceafcc9c2f014f96b281e'


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):Path(path).write_text(json.dumps(value,indent=2)+'\n')
def blob(commit,path):
    need(bool(re.fullmatch('[0-9a-f]{40}',commit)),'full immutable commit required')
    return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)


def source_check(commit):
    result={}
    for folder,anchor in ((HERE,commit),(HERE.parent,PLAN_COMMIT)):
        preparation=folder/'PREPARATION.json'
        need(preparation.read_bytes()==blob(anchor,str(preparation.relative_to(ROOT))),'preparation Git mismatch')
        for name,entry in json.loads(preparation.read_text())['files'].items():
            path=folder/name;content=path.read_bytes()
            need(len(content)==entry['bytes'] and hashlib.sha256(content).hexdigest()==entry['sha256'],'prepared source differs')
            need(content==blob(anchor,str(path.relative_to(ROOT))),'prepared source Git differs')
            result[str(path.resolve())]=entry['sha256']
        result[str(preparation.resolve())]=sha(preparation)
    upstream=json.loads((HERE/'upstream-pins.json').read_text())
    descriptor=blob(upstream['descriptor_commit'],upstream['descriptor_path'])
    need(hashlib.sha256(descriptor).hexdigest()==upstream['descriptor_sha256'],'upstream descriptor differs')
    old=json.loads(descriptor)['source_sha256']
    for relative,expected in upstream['source_sha256'].items():
        path=ROOT/relative
        need(old.get(relative)==expected and sha(path)==expected,'frozen upstream changed')
        result[str(path.resolve())]=expected
    return result


def consumed_inputs(dep,prepared):
    text=dep.read_text().replace('\\\n',' ');need(':' in text,'missing dependency LHS')
    result={}
    for value in shlex.split(text.split(':',1)[1]):
        path=Path(value);path=path if path.is_absolute() else ROOT/path
        need(path.is_file(),'consumed source missing')
        canonical=path.resolve();observed=sha(path)
        if canonical.is_relative_to(ROOT):
            need(str(canonical) in prepared,'unprepared repository input: '+str(path))
            need(prepared[str(canonical)]==observed,'consumed repository input changed')
        result[str(path)]=observed
    canonical={str(Path(p).resolve()) for p in result}
    for name in ('main.cpp','points.inc','control.h','candidate.h','split64_range_bloom.h','fast_pattern_BF.h',
                 'four_sector_bloom.h','split64_bloom.h','byte_split_bloom.h','query_helpers.hpp','geometry.hpp',
                 'cpp-adapters.hpp','boost-adapters.hpp','rocks-adapters.hpp'):
        need(str((HERE/name).resolve()) in canonical,'required actual input absent: '+name)
    return result


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True)
    parser.add_argument('--execute-correctness',action='store_true');args=parser.parse_args()
    need(args.execute_correctness,'explicit correctness grant flag required')
    placement=require()
    for name in ('CC','CXX','CMAKE_TOOLCHAIN_FILE','CMAKE_PREFIX_PATH'):
        need(not os.environ.get(name),'unfrozen build environment override')
    prepared=source_check(args.source_commit)
    for path in (OUT,TARGET):need(not path.exists() and not path.is_symlink(),'fresh output and build paths required')
    compiler='/usr/bin/clang++'
    tools={name:shutil.which(name) for name in ('cmake','nm','objdump','c++filt','numactl')}
    need(all(tools.values()) and Path(compiler).is_file(),'required tools missing')
    tool_hashes={p:sha(p) for p in (compiler,*tools.values())}
    OUT.mkdir();TARGET.mkdir()
    metadata=dict(complete=False,source_commit=args.source_commit,plan_commit=PLAN_COMMIT,
                  start=datetime.datetime.now(datetime.timezone.utc).isoformat(),placement=placement,
                  source_sha256=prepared,tools_sha256=tool_hashes,compiler=compiler,
                  compiler_resolved_path=str(Path(compiler).resolve()),formal_workloads=0)
    commands=[];save(OUT/'metadata.json',metadata)

    def check_tools():
        for path,expected in tool_hashes.items():need(sha(path)==expected,'tool changed')

    def run(label,argv,success=True,input_text=None):
        need(require()==placement,'lease changed before command');check_tools()
        prefix=f'{len(commands):03d}-{label}';stdout=OUT/(prefix+'.stdout');stderr=OUT/(prefix+'.stderr')
        with stdout.open('wb') as out,stderr.open('wb') as err:
            result=subprocess.run(list(map(str,argv)),cwd=ROOT,stdout=out,stderr=err,
                input=None if input_text is None else input_text.encode(),
                pass_fds=tuple(map(int,placement['fd_evidence'])))
        commands.append(dict(label=label,argv=list(map(str,argv)),cwd=str(ROOT),returncode=result.returncode,
            expected_success=success,stdout=str(stdout.relative_to(HERE)),stderr=str(stderr.relative_to(HERE)),
            stdout_sha256=sha(stdout),stderr_sha256=sha(stderr),
            input_sha256=None if input_text is None else hashlib.sha256(input_text.encode()).hexdigest()))
        save(OUT/'commands.json',commands)
        need((result.returncode==0)==success,'unexpected command outcome: '+label)
        return stdout,stderr

    try:
        run('derive-source',[sys.executable,HERE/'derive.py'])
        run('compiler-version',[compiler,'--version'])
        binaries={};inputs={};records={};allocations={};assembly={}
        for profile,isa,sanitizers in (('normal','native','OFF'),('minimal-f','minimal-f','OFF'),('asan','native','ON')):
            need(source_check(args.source_commit)==prepared,'source drift before build')
            folder=TARGET/profile
            run(profile+'-configure',[tools['cmake'],'-S',HERE,'-B',folder,'-DCMAKE_BUILD_TYPE=Release',
                '-DCMAKE_CXX_COMPILER='+compiler,'-DBF_PROFILE='+isa,'-DBF_SANITIZERS='+sanitizers])
            run(profile+'-build',[tools['cmake'],'--build',folder,'--target','main','-j','1'])
            binary=folder/'main';binaries[str(binary)]=sha(binary)
            metadata['all_binary_sha256']=dict(binaries)
            save(OUT/'metadata.json',metadata)
            for name in ('compile_commands.json','CMakeCache.txt'):
                shutil.copyfile(folder/name,OUT/(profile+'-'+name))
            dep=folder/'CMakeFiles/main.dir/main.cpp.o.d'
            shutil.copyfile(dep,OUT/(profile+'-main.d'))
            inputs[profile]=consumed_inputs(dep,prepared)
            metadata['compiler_inputs']=dict(inputs)
            metadata['compiler_consumed_input_sha256']={path:expected for group in inputs.values() for path,expected in group.items()}
            save(OUT/'metadata.json',metadata)
            need(source_check(args.source_commit)==prepared,'source drift before execution');check_tools()
            for path,expected in inputs[profile].items():need(sha(path)==expected,'input drift before execution')
            need(sha(binary)==binaries[str(binary)],'binary drift before execution')
            prefix=[tools['numactl'],'--physcpubind=3','--membind=1',binary]
            allocations[profile]=[]
            for i,case in enumerate(ALLOCATION_CASES):
                stdout,stderr=run(profile+f'-allocation-{i}',[*prefix,*arguments(case,'--geometry')])
                need(stderr.read_bytes()==b'','allocation diagnostic unexpected')
                allocations[profile].append(dict(case=case,rows=parse(stdout.read_text(),case,allocation=True)))
                save(OUT/'allocation-records.json',allocations)
            records[profile]=[]
            for i,case in enumerate(CASES):
                stdout,stderr=run(profile+f'-case-{i}',[*prefix,*arguments(case)])
                need(stderr.read_bytes()==b'','caller diagnostic unexpected')
                records[profile].append(dict(case=case,rows=parse(stdout.read_text(),case)))
                save(OUT/'records.json',records)
            old_reference(records[profile],profile)
            save(OUT/'records.json',records);save(OUT/'allocation-records.json',allocations)
        for profile in records:
            for expected,actual in zip(records['normal'],records[profile],strict=True):
                need(expected['case']==actual['case'],'profile case changed')
                need([semantics(r) for r in expected['rows']]==[semantics(r) for r in actual['rows']],'backend semantic mismatch')
            need(allocations[profile]==allocations['normal'],'backend geometry mismatch')
            a={r['point_id']:semantics(r) for r in records[profile][0]['rows']}
            b={r['point_id']:semantics(r) for r in records[profile][1]['rows']}
            need(a==b,'same-input reversed order semantics mismatch')
        prefix=[tools['numactl'],'--physcpubind=3','--membind=1',TARGET/'normal/main']
        def reject(label,argv,message):
            stdout,stderr=run(label,[*prefix,*argv],success=False)
            need(commands[-1]['returncode']==1 and stdout.read_bytes()==b'' and stderr.read_bytes()==(message+'\n').encode(),
                 'wrong rejected outcome, partial stdout or crash')
        for index in (0,7):reject('fault-'+str(index),arguments(CASES[index],'--fault'),'full output mismatch')
        for index,(position,value,message) in enumerate(((0,'--unknown','unknown mode'),(2,'25','unsupported grid'),
            (4,'2','unsupported grid'),(5,'0','proof grid mismatch'),(6,'982451653','proof grid mismatch'),
            (7,'2','unsupported grid'),(8,'26','proof grid mismatch'))):
            argv=arguments(CASES[0]);argv[position]=value;reject('invalid-'+str(index),argv,message)
        reject('invalid-formal-seen',['--measure','16','50','22','1','8','74381','0','26'],'formal grid mismatch')
        reject('invalid-arity',arguments(CASES[0])+['extra'],'expected mode power hit query_power batch repeats seed reverse calibration_power')
        for profile in ('normal','minimal-f'):
            binary=TARGET/profile/'main'
            stdout,_=run(profile+'-nm',[tools['nm'],'-S','--defined-only','--format=posix',binary])
            symbols=[]
            for line in stdout.read_text().splitlines():
                fields=line.split()
                if len(fields)==4 and fields[1] in ('t','T','w','W'):
                    try:symbols.append((fields[0],int(fields[2],16),int(fields[3],16)))
                    except ValueError:pass
            stdout,_=run(profile+'-demangle',[tools['c++filt']],input_text='\n'.join(s[0] for s in symbols)+'\n')
            displays=stdout.read_text().splitlines();need(len(displays)==len(symbols),'demangle count mismatch')
            captures=[]
            for (raw,start,size),display in zip(symbols,displays,strict=True):
                role=next((r for r in ('Run<','lookup_kernel<','inline_single_kernel<') if r in display),None)
                if role is None or '.cold' in display:continue
                need(size>0,'empty actual caller symbol')
                stdout,_=run(profile+f'-asm-{len(captures)}',[tools['objdump'],'-d','--no-show-raw-insn',
                    f'--start-address={start}',f'--stop-address={start+size}',binary])
                pcs=[int(m.group(1),16) for m in re.finditer(r'^\s*([0-9a-f]+):\s+\S',stdout.read_text(),re.M)]
                need(pcs and pcs[0]==start and all(start<=pc<start+size for pc in pcs),'empty or out-of-span ASM')
                captures.append(dict(raw_symbol=raw,display_label=display,role=role,start=start,size=size,
                    instruction_count=len(pcs),stdout=str(stdout.relative_to(HERE)),sha256=sha(stdout)))
            for role,count in (('Run<',19),('lookup_kernel<',19),('inline_single_kernel<',38)):
                need(sum(s['role']==role for s in captures)==count,'missing actual typed role: '+role)
            assembly[profile]=dict(binary=str(binary),sha256=sha(binary),symbols=captures,manual_review_pending=True)
        need(source_check(args.source_commit)==prepared,'final source changed');check_tools()
        need(require()==placement,'final lease changed')
        union={}
        for group in inputs.values():
            for path,expected in group.items():need(sha(path)==expected,'final consumed source changed');union[path]=expected
        for path,expected in binaries.items():need(sha(path)==expected,'final executable changed')
        metadata.update(complete=True,end=datetime.datetime.now(datetime.timezone.utc).isoformat(),
            all_binary_sha256=binaries,compiler_inputs=inputs,compiler_consumed_input_sha256=union,
            assembly=assembly,manual_review_pending=True,
            counts=dict(profiles=3,caller_cases=24,caller_rows=366,allocation_cases=6,allocation_rows=192,
                        old_semantic_rows=6,faults=2,invalid=9,formal_workloads=0))
    except BaseException as exc:
        metadata.update(error=repr(exc),end=datetime.datetime.now(datetime.timezone.utc).isoformat())
        save(OUT/'metadata.json',metadata);raise
    save(OUT/'metadata.json',metadata)
    print('Focused actual public correctness complete; manual caller/callee ASM gate remains pending.')


if __name__=='__main__':main()
