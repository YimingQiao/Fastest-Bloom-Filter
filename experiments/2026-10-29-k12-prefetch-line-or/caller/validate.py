#!/usr/bin/env python3
"""Focused conditional boundary/caller proof; no formal fresh inputs."""
import argparse,csv,io,json,os,shlex,subprocess,traceback
from pathlib import Path
if not __debug__:raise SystemExit('Python -O unsupported')
from source_guard import HERE,BASE,ROOT,OLD,sha,verify
from contract import CASES,TYPES,SEMANTICS,command,ordered_rows,need
from lease import require

def main():
 p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);p.add_argument('--execute-correctness',action='store_true');a=p.parse_args();need(a.execute_correctness,'Explicit correctness flag required')
 lease=require(2);pins=verify(a.source_commit);out=HERE/'validation-v1';need(not out.exists()and not out.is_symlink(),'Preserve previous attempt');out.mkdir()
 meta=dict(complete=False,source_commit=a.source_commit,source_sha256=pins,lease=lease,commands=[],profiles={},formal_workloads_run=False,kernel1642_matrix_rerun=False)
 def save():(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
 def run(label,argv,success=True,env=None):
  record=dict(label=label,command=list(map(str,argv)),complete=False,expected_success=success,stdout=label+'.stdout',stderr=label+'.stderr',environment_delta=env or {});meta['commands'].append(record);save()
  with(out/record['stdout']).open('w')as stdout,(out/record['stderr']).open('w')as stderr:process=subprocess.run(record['command'],cwd=ROOT,env={**os.environ,**(env or {})},stdout=stdout,stderr=stderr)
  record.update(returncode=process.returncode,complete=True,stdout_sha256=sha(out/record['stdout']),stderr_sha256=sha(out/record['stderr']));save()
  need((process.returncode==0)==success,'Unexpected outcome '+label)
  if not success:need(process.returncode==1 and not(out/record['stdout']).read_bytes()and(out/record['stderr']).read_bytes(),'Malformed CLI did not reject cleanly')
  print(label+' PASS',flush=True);return(out/record['stdout']).read_text()
 save()
 try:
  run('derivation',['python3',HERE/'derive.py']);run('proposal-derivation',['python3',BASE/'derive.py'])
  run('compiler',['/usr/bin/clang++','--version'])
  bins={};inputs={};answers=[];seen={};oracle=None
  old_rows=list(csv.DictReader(io.StringIO((OLD/'caller/validation-v2/native-caller-0.stdout').read_text())))
  old_control=next(r for r in old_rows if r['filter']=='K12ScalarOrControl')
  for profile in ('native','minimal-f','asan'):
   build=ROOT/'build'/f'k12-prefetch-line-or-v1-cpu2-{profile}';need(not build.exists()and not build.is_symlink(),'Preserve old build')
   run(profile+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_BUILD_TYPE=Release','-DCMAKE_CXX_COMPILER=/usr/bin/clang++','-DBF_ISA='+('minimal-f'if profile=='minimal-f'else'native'),'-DBF_SANITIZERS='+('ON'if profile=='asan'else'OFF')])
   run(profile+'-build',['cmake','--build',build,'--parallel','1'])
   (out/(profile+'-compile_commands.json')).write_bytes((build/'compile_commands.json').read_bytes())
   consumed={};deps=list(build.rglob('*.o.d'));need(len(deps)==2,'Wrong translation unit count')
   for dep in deps:
    dest=out/'dependencies'/profile/dep.relative_to(build);dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(dep.read_bytes())
    for token in shlex.split(dep.read_text().replace('\\\n',' ').split(':',1)[1]):
     path=Path(token);path=(path if path.is_absolute()else build/path).resolve();need(path.is_file(),'Missing compiler input')
     if path.is_relative_to(ROOT):need(str(path)in pins and sha(path)==pins[str(path)],'Unprepared repository compiler input '+str(path))
     consumed[str(path)]=sha(path)
   for path in [HERE/'compare_benchmark.cpp',HERE/'check.cpp',HERE/'geometry.hpp',BASE/'control.hpp',BASE/'conditional.hpp',BASE/'split64_range_bloom.h',BASE/'base.h',BASE/'range_size.hpp']:need(str(path)in consumed,'Missing required actual dependency')
   for path,digest in consumed.items():need(inputs.get(path,digest)==digest,'Compiler input changed');inputs[path]=digest
   executables={name:dict(path=str(build/name),sha256=sha(build/name))for name in ('check','compare_benchmark')}
   for b in executables.values():bins[b['path']]=b['sha256']
   meta['profiles'][profile]=dict(executables=executables,consumed_inputs=consumed);save()
   env={'ASAN_OPTIONS':'detect_leaks=1:halt_on_error=1','UBSAN_OPTIONS':'print_stacktrace=1:halt_on_error=1'}if profile=='asan'else{}
   proof=json.loads(run(profile+'-boundary-check',[build/'check'],env=env));need(proof['complete']and proof['cases']==18,'Wrong focused checker count');need(oracle is None or proof==oracle,'Backend bitmap oracle mismatch');oracle=proof;meta['profiles'][profile]['oracle']=proof;save()
   for index,case in enumerate(CASES):
    for rotation in range(3):
     rows=ordered_rows(run(f'{profile}-case{index}-latin{rotation}',[*command(build/'compare_benchmark',case),f'latin{rotation}'],env=env),case,rotation)
     for row in rows:
      key=(index,row['filter']);sem=tuple(row[k]for k in SEMANTICS);need(seen.get(key,sem)==sem,'Order/backend semantic drift');seen[key]=sem
      if index==0 and row['filter']=='K12ScalarOrControl':need(sem==tuple(old_control[k]for k in SEMANTICS),'Old tiny control changed')
      answers.append(dict(profile=profile,case=index,rotation=rotation,**row))
   run(profile+'-bad-order',[*command(build/'compare_benchmark',CASES[0]),'latin3'],False,env)
   run(profile+'-extra-argument',[*command(build/'compare_benchmark',CASES[0]),'latin0','extra'],False,env)
   selected=command(build/'compare_benchmark',CASES[0]);selected[8]=TYPES[0];run(profile+'-partial-registry',[*selected,'latin0'],False,env)
  need(len(answers)==54,'Incomplete three-profile caller rows');(out/'rows.json').write_text(json.dumps(answers,indent=2)+'\n')
  binary=meta['profiles']['native']['executables']['compare_benchmark']['path'];run('native-symbols',['nm','-S','-C','--defined-only',binary]);run('native-assembly',['objdump','-d','-C','--no-show-raw-insn',binary])
  need(verify(a.source_commit)==pins and require(2)==lease,'Final source/placement drift')
  for group in (bins,inputs):
   for path,digest in group.items():need(sha(path)==digest,'Final binary/input drift')
  meta.update(complete=True,all_binary_sha256=bins,compiler_consumed_input_sha256=inputs,counts=dict(profiles=3,boundary_cases=54,caller_rows=54,invalid_cli=9,binaries=6),assembly_manual_review_pending=True);save();print(json.dumps(meta['counts']))
 except BaseException as error:meta.update(complete=False,error=repr(error));save();(out/'FAILURE.txt').write_text(traceback.format_exc());raise
if __name__=='__main__':main()
