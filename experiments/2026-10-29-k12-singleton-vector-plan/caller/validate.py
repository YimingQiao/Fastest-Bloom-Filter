#!/usr/bin/env python3
"""One bounded correctness attempt; formal inputs are never executed here."""
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

if not __debug__: raise SystemExit('Python -O is unsupported')
from contract import CASES, arguments, need, rows, semantics
from lease import require

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
OUT=HERE/'validation-v1'
TARGET=Path('/tmp/fastest-bf-k12-singleton-vector-v1-cpu3')
PROFILES={
    'normal':['-O3','-march=native'],
    'minimal-f':['-O3','-march=x86-64','-mavx512f','-mno-avx512vl','-mno-avx512dq','-mno-avx512bw','-mno-avx512vbmi','-mno-avx512bitalg'],
    'asan':['-O1','-march=native','-g','-fno-omit-frame-pointer','-fsanitize=address,undefined']}

def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value): Path(path).write_text(json.dumps(value,indent=2)+'\n')
def blob(commit,path): return subprocess.check_output(['git','show',f'{commit}:{path}'],cwd=ROOT)
def source_check(commit):
    preparation=HERE/'PREPARATION.json'
    need(preparation.read_bytes()==blob(commit,str(preparation.relative_to(ROOT))),'preparation Git mismatch')
    result={}
    for name,entry in json.loads(preparation.read_text())['files'].items():
        p=HERE/name;data=p.read_bytes()
        need(len(data)==entry['bytes'] and hashlib.sha256(data).hexdigest()==entry['sha256'],'source SHA mismatch')
        need(data==blob(commit,str(p.relative_to(ROOT))),'source Git bytes mismatch')
        result[str(p)]=entry['sha256']
    result[str(preparation)]=sha(preparation)
    return result

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);parser.add_argument('--execute-correctness',action='store_true');args=parser.parse_args()
    need(args.execute_correctness,'explicit correctness grant flag required')
    source=source_check(args.source_commit);placement=require()
    for path in (OUT,TARGET): need(not path.exists() and not path.is_symlink(),'fresh output/target path required')
    OUT.mkdir();TARGET.mkdir()
    commands=[];meta=dict(complete=False,source_commit=args.source_commit,start=datetime.datetime.now(datetime.timezone.utc).isoformat(),source_sha256=source,placement=placement)
    compiler='/usr/bin/clang++' # Preserve C++ argv0; do not invoke its clang symlink target.
    tools={name:shutil.which(name)for name in ('nm','objdump','c++filt','numactl')}
    need(all(tools.values()) and Path(compiler).exists(),'required tools missing')
    meta['tools_sha256']={p:sha(p)for p in [compiler,*tools.values()]}
    meta['compiler_resolved_path']=str(Path(compiler).resolve())
    save(OUT/'metadata.json',meta)
    def run(label,argv,success=True,input_text=None):
        prefix=f'{len(commands):03d}-{label}'
        stdout=OUT/(prefix+'.stdout');stderr=OUT/(prefix+'.stderr')
        with stdout.open('wb') as out,stderr.open('wb') as err:
            completed=subprocess.run(argv,cwd=ROOT,stdout=out,stderr=err,input=None if input_text is None else input_text.encode())
        commands.append(dict(label=label,argv=list(map(str,argv)),cwd=str(ROOT),exit_code=completed.returncode,expected_success=success,
            stdout=str(stdout.relative_to(HERE)),stderr=str(stderr.relative_to(HERE)),stdout_sha256=sha(stdout),stderr_sha256=sha(stderr),
            input_sha256=None if input_text is None else hashlib.sha256(input_text.encode()).hexdigest()))
        save(OUT/'commands.json',commands)
        need((completed.returncode==0)==success,f'command outcome mismatch: {label}')
        return stdout,stderr
    try:
        binaries={};consumed={};all_rows={};asm={}
        def verify_tools():
            for path,expected in meta['tools_sha256'].items():need(sha(path)==expected,'tool changed')
        run('compiler-version',[compiler,'--version'])
        for profile,flags in PROFILES.items():
            verify_tools();need(source_check(args.source_commit)==source,'source changed before profile build')
            folder=TARGET/profile;folder.mkdir()
            for unit in ('check','main'):
                output=folder/unit;dep=folder/(unit+'.d')
                run(profile+'-build-'+unit,[compiler,'-std=c++17',*flags,'-pthread','-MD','-MF',str(dep),str(HERE/(unit+'.cpp')),'-o',str(output)])
                binaries[str(output)]=sha(output)
                dep_copy=OUT/(profile+'-'+unit+'.d');shutil.copyfile(dep,dep_copy)
                dependency_text=dep.read_text().replace('\\\n',' ')
                need(':' in dependency_text,'missing dependency target')
                inputs={}
                for value in shlex.split(dependency_text.split(':',1)[1]):
                    path=Path(value);path=path if path.is_absolute() else ROOT/path
                    need(path.is_file(),'missing consumed input')
                    canonical=path.resolve()
                    if canonical.is_relative_to(ROOT):
                        need(str(canonical)in source,'unprepared consumed repository source: '+str(path))
                        need(sha(path)==source[str(canonical)],'consumed source differs from preparation')
                    inputs[str(path)]=sha(path)
                for required in (unit+'.cpp','control.h','candidate.h','base.h','split64_range_size.h'):
                    need(str(HERE/required) in inputs,'required actual source absent: '+required)
                if unit=='check':need(str(HERE/'mapping_oracle.hpp')in inputs,'oracle absent')
                else:need(str(HERE/'query_helpers.hpp')in inputs,'public helper absent')
                consumed[profile+'-'+unit]=inputs
            # Close actual compiler-input and executable identities before any
            # checker/caller execution, then repeat the full closure at exit.
            verify_tools();need(source_check(args.source_commit)==source,'source changed before profile execution')
            for unit in ('check','main'):
                need(sha(folder/unit)==binaries[str(folder/unit)],'binary changed before execution')
                for path,expected in consumed[profile+'-'+unit].items():
                    need(sha(path)==expected,'consumed input changed before execution')
            prefix=[tools['numactl'],'--physcpubind=3','--membind=1']
            output,error=run(profile+'-checker',[*prefix,str(folder/'check')])
            need(error.read_bytes()==b'','checker unexpected diagnostic')
            need(json.loads(output.read_text())==dict(fixtures=9222,complete=True),'checker coverage mismatch')
            records=[]
            for index,case in enumerate(CASES):
                output,error=run(profile+f'-caller-{index}',[*prefix,str(folder/'main'),*arguments(case)])
                need(error.read_bytes()==b'','caller unexpected diagnostic')
                records.append(dict(case=case,rows=rows(output.read_text(),case)))
            all_rows[profile]=records
            save(OUT/'records.json',all_rows)
        normal=all_rows['normal']
        for profile,records in all_rows.items():
            for expected,record in zip(normal,records,strict=True):
                need(expected['case']==record['case'],'profile case drift')
                need([semantics(r)for r in expected['rows']]==[semantics(r)for r in record['rows']],'profile semantics drift')
            for i in range(0,len(records),2):
                need(semantics(records[i]['rows'][0])==semantics(records[i+1]['rows'][0]),'order semantics drift')
        prefix=[tools['numactl'],'--physcpubind=3','--membind=1',str(TARGET/'normal/main')]
        def rejected(label,command,diagnostic):
            output,error=run(label,[*prefix,*command],success=False)
            need(commands[-1]['exit_code']==1,'rejection was not the expected exception exit')
            need(output.read_bytes()==b'' and error.read_bytes()==(diagnostic+'\n').encode(),'wrong rejection diagnostic or partial stdout')
        for index in (0,4):rejected('fault-'+str(index),arguments(CASES[index],'--fault'),'full output mismatch')
        bad=[]
        for position,value,message in ((0,'--unknown','unknown mode'),(2,'25','unsupported grid'),(4,'2','unsupported grid'),
                (5,'0','proof grid mismatch'),(6,'16057','proof grid mismatch'),(7,'2','unsupported grid')):
            command=arguments(CASES[0]);command[position]=value;bad.append((command,message))
        bad.append((arguments(CASES[0])+['extra'],'expected mode power hit query_power batch repeats seed order'))
        bad.append((['--measure','16','50','22','1','8','74381','0'],'formal grid mismatch'))
        for index,(command,message) in enumerate(bad):rejected('invalid-'+str(index),command,message)
        for profile in ('normal','minimal-f'):
            binary=TARGET/profile/'main'
            output,_=run(profile+'-nm',[tools['nm'],'-S','--defined-only','--format=posix',str(binary)])
            symbols=[]
            for line in output.read_text().splitlines():
                fields=line.split()
                if len(fields)==4 and fields[1]in ('t','T','w','W'):
                    try: symbols.append((fields[0],int(fields[2],16),int(fields[3],16)))
                    except ValueError:pass
            output,_=run(profile+'-demangle',[tools['c++filt']],input_text='\n'.join(s[0]for s in symbols)+'\n')
            names=output.read_text().splitlines();need(len(names)==len(symbols),'demangle cardinality')
            selected=[]
            for (raw,start,size),display in zip(symbols,names,strict=True):
                if 'FourSectorRange12'not in display:continue
                role=next((r for r in ('lookup_kernel<','inline_single_kernel<','Run<','ContainsHash512(')if r in display),None)
                if role is None:continue
                need(size>0,'empty actual symbol')
                output,_=run(profile+f'-span-{len(selected)}',[tools['objdump'],'-d','--no-show-raw-insn',f'--start-address={start}',f'--stop-address={start+size}',str(binary)])
                pcs=[int(m.group(1),16)for m in re.finditer(r'^\s*([0-9a-f]+):\s+\S',output.read_text(),re.M)]
                need(pcs and pcs[0]==start and all(start<=pc<start+size for pc in pcs),'empty or out-of-span ASM capture')
                selected.append(dict(raw_symbol=raw,display_label=display,role=role,start=start,size=size,instructions=len(pcs),capture=str(output.relative_to(HERE)),sha256=sha(output)))
            for role,count in (('lookup_kernel<',2),('inline_single_kernel<',4),('Run<',2)):
                need(sum(s['role']==role for s in selected)==count,'missing actual caller role: '+role)
            asm[profile]=dict(binary=str(binary),sha256=sha(binary),elf_magic=binary.read_bytes()[:4].hex(),symbols=selected,manual_review_pending=True)
        need(source_check(args.source_commit)==source,'final source changed')
        verify_tools()
        need(require()==placement,'final lease changed')
        for path,expected in binaries.items():need(sha(path)==expected,'binary changed')
        union={}
        for inputs in consumed.values():
            for path,expected in inputs.items():need(sha(path)==expected,'consumed input changed');union[path]=expected
        meta.update(complete=True,end=datetime.datetime.now(datetime.timezone.utc).isoformat(),all_binary_sha256=binaries,
            compiler_consumed_input_sha256=union,compiler_inputs=consumed,assembly=asm,
            counts=dict(profiles=3,checker_fixtures=27666,caller_cases=24,rows=48,faults=2,invalid=8,formal_workloads=0),manual_review_pending=True)
    except BaseException as exc:
        meta.update(error=repr(exc),end=datetime.datetime.now(datetime.timezone.utc).isoformat());save(OUT/'metadata.json',meta);raise
    save(OUT/'metadata.json',meta)
    print('Focused correctness complete; actual ASM manual review remains required.')

if __name__=='__main__':main()
