#!/usr/bin/env python3
"""Run only the declared correctness/assembly preflight after a CPU lease."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import shlex
import subprocess
import traceback

if not __debug__:
    raise SystemExit('Python -O is not supported')
from contract import CASES, SEMANTICS, TYPES, command, need, rows
from lease import require
from source_guard import HERE, ROOT, sha
from repair_guard import verify

MINIMAL = ['-march=x86-64','-mavx512f','-mno-avx512vl','-mno-avx512dq','-mno-avx512bw','-mno-avx512bitalg','-mno-avx512vbmi']
PROFILES = ('native','minimal-f','asan')

def now(): return datetime.now(timezone.utc).isoformat()
def new_path(path):
    need(not path.exists() and not path.is_symlink(), 'Preserve prior path: '+str(path))

def dependencies(build, output, profile):
    collected = {}; records = []
    for source in sorted(build.rglob('*.o.d')):
        text = source.read_text(); flat = text.replace('\\\n',' ')
        need(':' in flat, 'Invalid compiler dependency file')
        tokens = shlex.split(flat.split(':',1)[1])
        need(tokens, 'Empty compiler dependency file')
        paths = []
        for token in tokens:
            path = Path(token)
            if not path.is_absolute(): path = build/path
            path = path.resolve()
            need(path.is_file(), 'Missing consumed compiler input: '+str(path))
            collected[str(path)] = sha(path); paths.append(str(path))
        name = profile + '-' + source.parent.name + '-' + source.name
        (output/name).write_text(text)
        records.append(dict(original_path=str(source), archived=name, sha256=sha(source), inputs=paths))
    need(len(records)==2, 'Expected the two actual C++ translation units')
    required = [HERE/'check.cpp', HERE/'compare_benchmark.cpp', HERE/'geometry.hpp']
    required += [HERE.parent/n for n in ('control.hpp','candidate.hpp','base.h','range_size.hpp')]
    need(all(str(p.resolve()) in collected for p in required), 'Missing representative actual source input')
    return collected, records

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True)
    parser.add_argument('--cpu',type=int,choices=(2,3),required=True)
    parser.add_argument('--execute-correctness',action='store_true');args=parser.parse_args()
    need(args.execute_correctness, 'Explicit correctness execution required; no performance mode exists')
    output=HERE/'validation-v2';new_path(output);output.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,started=now(),commands=[],profiles={},performance_run=False)
    def save(): (output/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    save()
    def run(label,cmd,success=True,env=None):
        row=dict(label=label,command=list(map(str,cmd)),cwd=str(ROOT),started=now(),expected_success=success,
                 stdout=label+'.stdout',stderr=label+'.stderr',environment_delta=env or {},complete=False)
        meta['commands'].append(row);save()
        with (output/row['stdout']).open('w') as out,(output/row['stderr']).open('w') as err:
            process=subprocess.run(row['command'],cwd=ROOT,stdout=out,stderr=err,env={**os.environ,**(env or {})})
        row.update(returncode=process.returncode,finished=now(),complete=True,
                   stdout_sha256=sha(output/row['stdout']),stderr_sha256=sha(output/row['stderr']));save()
        need((process.returncode==0)==success, 'Unexpected command outcome: '+label)
        return (output/row['stdout']).read_text()
    try:
        meta['lease']=require(args.cpu);meta['source_sha256']=verify(args.source_commit);save()
        run('proposal-derivation',['python3',str(HERE.parent/'derive.py')])
        run('caller-derivation',['python3',str(HERE/'derive.py')])
        compiler=Path('/usr/bin/clang++');meta['compiler']=dict(path=str(compiler),resolved_path=str(compiler.resolve()),sha256=sha(compiler))
        run('compiler-version',[str(compiler),'--version']);run('cmake-version',['cmake','--version'])
        all_inputs={};all_bins={};semantics={};oracle=None;all_rows=[]
        for profile in PROFILES:
            build=ROOT/'build'/f'k12-line-or-v2-cpu{args.cpu}-{profile}';new_path(build)
            isa='minimal-f' if profile=='minimal-f' else 'native'
            env={'ASAN_OPTIONS':'detect_leaks=1:halt_on_error=1','UBSAN_OPTIONS':'print_stacktrace=1:halt_on_error=1'} if profile=='asan' else {}
            run(profile+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_BUILD_TYPE=Release',
                '-DCMAKE_CXX_COMPILER='+str(compiler),'-DBF_ISA='+isa,'-DBF_SANITIZERS='+('ON' if profile=='asan' else 'OFF')])
            run(profile+'-build',['cmake','--build',build,'--parallel','1'])
            compiled=json.loads((build/'compile_commands.json').read_text())
            need(len(compiled)==2, 'Unexpected compilation units')
            (output/(profile+'-compile_commands.json')).write_text(json.dumps(compiled,indent=2)+'\n')
            consumed,dep_records=dependencies(build,output,profile)
            for path,digest in consumed.items(): need(all_inputs.get(path,digest)==digest, 'Compiler input changed');all_inputs[path]=digest
            bins={name:dict(path=str(build/name),sha256=sha(build/name))for name in ('check','compare_benchmark')}
            all_bins.update({record['path']:record['sha256']for record in bins.values()})
            meta['profiles'][profile]=dict(build=str(build),executables=bins,dependency_files=dep_records,compiler_consumed_input_sha256=consumed);save()
            result=json.loads(run(profile+'-bitmap-check',[build/'check'],env=env))
            need(result.get('complete') is True and result.get('cases')==1642, 'Incomplete bitmap proof')
            need(oracle is None or result==oracle, 'Backend bitmap digest disagreement');oracle=result
            meta['profiles'][profile]['oracle']=result
            for index,case in enumerate(CASES):
                parsed=rows(run(f'{profile}-caller-{index}',command(build/'compare_benchmark',case),env=env),case)
                for row in parsed:
                    key=(index,row['filter']);value=tuple(row[k]for k in SEMANTICS)
                    need(semantics.get(key,value)==value, 'Backend caller semantics differ');semantics[key]=value
                all_rows.extend(dict(profile=profile,case=index,**row)for row in parsed)
            if profile=='minimal-f':
                macros=run('minimal-f-macros',[compiler,*MINIMAL,'-dM','-E','-x','c++','/dev/null'])
                need('#define __AVX512F__ 1' in macros, 'Minimal profile did not enable AVX512F')
                for feature in ('VL','DQ','BW','BITALG','VBMI'):
                    need('__AVX512'+feature+'__' not in macros, 'Unexpected extra ISA feature '+feature)
            save()
        native=Path(meta['profiles']['native']['executables']['compare_benchmark']['path'])
        baseline=command(native,CASES[0])
        invalid=[]
        for slot,value in ((1,'4'),(8,'Unknown'),(8,TYPES[0]+','+TYPES[0]),(10,'1'),(11,'bad-mode'),(12,'0')):
            bad=baseline.copy();bad[slot]=value;invalid.append(bad)
        for index,bad in enumerate(invalid):run('invalid-'+str(index),bad,False)
        symbols=run('native-nm',['nm','-S','-C','--defined-only',native])
        run('native-nm-raw',['nm','-S','--defined-only',native])
        run('native-assembly',['objdump','-d','-C','--no-show-raw-insn',native])
        entries={}
        for kind in TYPES:
            matches=[]
            for line in symbols.splitlines():
                parts=line.split(maxsplit=3)
                if len(parts)==4 and parts[3].startswith('void insert<') and kind in parts[3] and '.cold' not in parts[3]:
                    matches.append(dict(address=int(parts[0],16),size=int(parts[1],16),symbol=parts[3]))
            need(len(matches)==1, 'Ambiguous/missing actual public insert caller '+kind);entries[kind]=matches[0]
        for index,(kind,entry)in enumerate(entries.items()):
            run(f'native-insert-{index}',['objdump','-d','-C','--no-show-raw-insn',
                '--start-address='+hex(entry['address']),'--stop-address='+hex(entry['address']+entry['size']),native])
        need(len(all_rows)==12, 'Caller row count drift')
        (output/'rows.json').write_text(json.dumps(all_rows,indent=2)+'\n')
        need(verify(args.source_commit)==meta['source_sha256'], 'Sources changed during preflight')
        for path,digest in all_inputs.items():need(sha(path)==digest, 'Consumed input changed')
        for path,digest in all_bins.items():need(sha(path)==digest, 'Compiled binary changed')
        need(require(args.cpu)==meta['lease'], 'Placement/environment changed')
        meta.update(complete=True,finished=now(),all_binary_sha256=all_bins,compiler_consumed_input_sha256=all_inputs,
                    assembly=dict(entries=entries,manual_review_required=True),
                    counts=dict(profiles=3,oracle_cases_per_profile=1642,caller_rows=12,invalid_cli=6,binaries=6))
        save();print(json.dumps(meta['counts']))
    except BaseException as error:
        meta.update(finished=now(),error=repr(error));save()
        (output/'FAILURE.txt').write_text(traceback.format_exc())
        raise

if __name__=='__main__':main()
