#!/usr/bin/env python3
"""Only small old-input order-flag checks; no kernel matrix/formal timing."""
import argparse,importlib.util,json,os,re,shlex,subprocess,traceback
from pathlib import Path
if not __debug__:raise SystemExit('Python -O unsupported')
from guards import HERE,CALLER,ROOT,CASES,TYPES,command,validate,verify,sha,need
from lease import require

def main():
    p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);p.add_argument('--cpu',type=int,choices=(2,3),required=True);p.add_argument('--execute-correctness',action='store_true');a=p.parse_args()
    need(a.execute_correctness,'Only explicit correctness execution supported')
    lease=require(a.cpu);pins=verify(a.source_commit);out=HERE/'validation-v1'
    need(not out.exists()and not out.is_symlink(),'Preserve previous attempt');out.mkdir()
    meta=dict(complete=False,source_commit=a.source_commit,source_sha256=pins,lease=lease,commands=[],profiles={},kernel_matrix_rerun=False,formal_workloads_run=False)
    def save():(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    def run(label,argv,ok=True,env=None):
        record=dict(label=label,command=list(map(str,argv)),complete=False,expected_success=ok,stdout=label+'.stdout',stderr=label+'.stderr',environment_delta=env or {})
        meta['commands'].append(record);save()
        with(out/record['stdout']).open('w')as stdout,(out/record['stderr']).open('w')as stderr:
            process=subprocess.run(record['command'],cwd=ROOT,env={**os.environ,**(env or {})},stdout=stdout,stderr=stderr)
        record.update(returncode=process.returncode,complete=True,stdout_sha256=sha(out/record['stdout']),stderr_sha256=sha(out/record['stderr']));save()
        need((process.returncode==0)==ok,'Unexpected outcome '+label)
        if not ok:need(process.returncode==1 and not(out/record['stdout']).read_bytes()and(out/record['stderr']).read_bytes(),'Invalid CLI did not reject cleanly')
        return(out/record['stdout']).read_text()
    save()
    try:
        run('derive',['python3',HERE/'derive.py'])
        all_inputs={};all_bins={};answers=[]
        for profile in ('native','asan'):
            build=ROOT/'build'/f'k12-line-or-order-v3-cpu{a.cpu}-{profile}';need(not build.exists()and not build.is_symlink(),'Preserve old build')
            run(profile+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_BUILD_TYPE=Release','-DCMAKE_CXX_COMPILER=/usr/bin/clang++','-DBF_SANITIZERS='+('ON'if profile=='asan'else'OFF')])
            run(profile+'-build',['cmake','--build',build,'--parallel','1'])
            executable=build/'compare_benchmark';all_bins[str(executable)]=sha(executable)
            (out/(profile+'-compile_commands.json')).write_bytes((build/'compile_commands.json').read_bytes())
            deps=list(build.rglob('*.o.d'));need(len(deps)==1,'Wrong translation-unit count');dep=deps[0];text=dep.read_text();(out/(profile+'-actual.d')).write_text(text)
            consumed={}
            for token in shlex.split(text.replace('\\\n',' ').split(':',1)[1]):
                source=Path(token);source=(source if source.is_absolute()else build/source).resolve();need(source.is_file(),'Missing compiler input');consumed[str(source)]=sha(source)
            for source in [HERE/'compare_benchmark.cpp',CALLER/'geometry.hpp',CALLER.parent/'control.hpp',CALLER.parent/'candidate.hpp',CALLER.parent/'base.h',CALLER.parent/'range_size.hpp']:
                need(str(source.resolve())in consumed,'Required source absent from actual dependencies')
            for path,digest in consumed.items():need(all_inputs.get(path,digest)==digest,'Consumed source changed');all_inputs[path]=digest
            meta['profiles'][profile]=dict(executable=dict(path=str(executable),sha256=sha(executable)),original_dep_info=str(dep),consumed_inputs=consumed);save()
            env={'ASAN_OPTIONS':'detect_leaks=1:halt_on_error=1','UBSAN_OPTIONS':'print_stacktrace=1:halt_on_error=1'}if profile=='asan'else{}
            for index,case in enumerate(CASES):
                for flag in ('original','reverse'):
                    label=f'{profile}-case{index}-{flag}';records=validate(run(label,[*command(executable,case),flag],env=env),index,flag=='reverse')
                    answers.extend(dict(profile=profile,case=index,flag=flag,**r)for r in records)
            run(profile+'-bad-flag',[*command(executable,CASES[0]),'invalid'],False,env)
            run(profile+'-extra-argument',[*command(executable,CASES[0]),'original','extra'],False,env)
        need(len(answers)==16,'Wrong complete caller row count');(out/'rows.json').write_text(json.dumps(answers,indent=2)+'\n')
        binary=meta['profiles']['native']['executable']['path']
        run('native-symbols',['nm','-S','-C','--defined-only',binary])
        run('native-assembly',['objdump','-d','-C','--no-show-raw-insn',binary])
        need(verify(a.source_commit)==pins and require(a.cpu)==lease,'Source/placement drift')
        for path,digest in all_inputs.items():need(sha(path)==digest,'Consumed file drift')
        for path,digest in all_bins.items():need(sha(path)==digest,'Binary drift')
        meta.update(complete=True,all_binary_sha256=all_bins,compiler_consumed_input_sha256=all_inputs,counts=dict(profiles=2,caller_rows=16,invalid_cli=4,binaries=2),assembly_manual_review_pending=True);save()
        print(json.dumps(meta['counts']))
    except BaseException as error:
        meta.update(complete=False,error=repr(error));save();(out/'FAILURE.txt').write_text(traceback.format_exc());raise
if __name__=='__main__':main()
