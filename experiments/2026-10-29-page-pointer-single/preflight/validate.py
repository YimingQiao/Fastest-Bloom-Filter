#!/usr/bin/env python3
"""Bounded Page caller correctness and assembly capture, never throughput."""
import argparse,json,re,subprocess,time
from pathlib import Path
from checks import HERE,SOURCE,ROOT,BASE,NAMES,WORKER,original,cases,validate,parity,compare_baseline,need
from guards import verify,startup,sha
from capture import inputs,macro_command
from capture_assembly import capture as assembly

def main():
    need(__debug__,'Python -O unsupported')
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source-commit',required=True);p.add_argument('--cpu',type=int,required=True)
    p.add_argument('--lease',required=True);p.add_argument('--build',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    held,tuner_file=startup(a.cpu,a.lease,a.build);inventory,proof=verify(a.source_commit)
    need(not a.output.exists()and not a.output.is_symlink(),'Output must be new')
    a.build.mkdir(parents=True,exist_ok=False);a.output.mkdir(parents=True,exist_ok=False)
    before=tuner_file();old=json.loads((ROOT/proof['proof_metadata']).read_text())['rows']['native']
    metadata=dict(scope='Page pointer-single caller correctness/ASM only; no throughput or FPR qualification',
      source_commit=a.source_commit,preparation_sha256=sha(HERE/'PREPARATION.json'),lease=held,
      parent_worker_freeze_sha256=sha(BASE/'WORKER_FREEZE.json'),caller_preparation_sha256=sha(SOURCE/'PREPARATION.json'),
      tuner_file_before=before,commands=[],binaries={},rows={},complete=False,
      assembly_review_complete=False,timing_authorized=False)
    for name in inventory['files']:
        dest=a.output/'source-snapshot'/name;dest.parent.mkdir(parents=True,exist_ok=True)
        dest.write_bytes((ROOT/name).read_bytes())
    def save():(a.output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    def run(label,cmd,failure=False,diagnostic=None):
        cmd=list(map(str,cmd));start=time.monotonic();r=subprocess.run(cmd,cwd=ROOT,text=True,capture_output=True)
        (a.output/(label+'.stdout')).write_text(r.stdout);(a.output/(label+'.stderr')).write_text(r.stderr)
        metadata['commands'].append(dict(label=label,command=cmd,returncode=r.returncode,
          diagnostic_process_seconds=time.monotonic()-start));save()
        if failure:
            need(r.returncode==2 and not r.stdout,'Invalid CLI/fault emitted success/CSV')
            if diagnostic:need(diagnostic in r.stderr,'Unexpected fault diagnostic')
        else:need(r.returncode==0,label+' failed; all logs retained')
        need(tuner_file()==before,'Existing tuner file changed')
        return r.stdout
    save();run('compiler',['g++','--version'])
    run('source-tests',['python3','-m','unittest','discover','-s',SOURCE,'-p','test_source.py','-v'])
    run('contract-tests',['python3','-m','unittest','discover','-s',HERE,'-p','test_checks.py','-v'])
    planned=cases();need(len(planned)==48,'Incorrect bounded fixture grid');allrows=[];consumed={}
    for backend in ('native','native-asan'):
        build=a.build/backend
        run(backend+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_CXX_COMPILER=g++','-DBACKEND='+backend])
        run(backend+'-build',['cmake','--build',build,'-j1'])
        database=json.loads((build/'compile_commands.json').read_text())
        need(len(database)==2 and {Path(c['file']).name for c in database}=={'main.cpp','caller_check.cpp'},'Unexpected original/public worker rebuild')
        paths=dict(page_pointer_control=(build/'worker/page_pointer_control').resolve(),pointer_caller_check=(build/'pointer_caller_check').resolve())
        for target,binary in paths.items():
            retained=a.output/'binaries'/backend/target;retained.parent.mkdir(parents=True,exist_ok=True)
            retained.write_bytes(binary.read_bytes());retained.chmod(binary.stat().st_mode)
            metadata['binaries'][backend+'/'+target]=dict(path=str(binary),sha256=sha(binary),retained=str(retained.resolve()))
            deps=inputs(build,target)
            (a.output/(backend+'-'+target+'-consumed-inputs.json')).write_text(json.dumps(deps,indent=2)+'\n')
            for name,want in deps['consumed_inputs'].items():
                need(name not in consumed or consumed[name]==want,'Consumed source changed between builds');consumed[name]=want
            macros=run(backend+'-'+target+'-macros',macro_command(deps['compile_commands'][0]))
            need('#define __AVX2__ 1'in macros and '#define __AVX512F__ 1'in macros,'Incorrect native ISA')
            need(('__SANITIZE_ADDRESS__'in macros)==(backend=='native-asan'),'Incorrect sanitizer boundary')
        caller=json.loads(run(backend+'-pointer-callers',[paths['pointer_caller_check']]))
        need(caller==dict(facades=6,query_checks=9810,null_zero=True,full_outputs=True,timed=False),'Pointer-specific coverage drift')
        binary=paths['page_pointer_control']
        need(run(backend+'-names',[binary,'--names']).splitlines()==NAMES,'Registry changed')
        invalid=[[],['--plan','Unknown',10,16],['--plan',NAMES[0],0,16],['--plan',NAMES[0],10,0],
          ['--check',NAMES[0],10,16,13,101,42,0,0],['--check',NAMES[-1],10,16,13,50,42,0,6],
          ['--measure',NAMES[-1],10,16,13,50,42,0,5]]
        for i,args in enumerate(invalid):run(backend+'-invalid'+str(i),[binary,*args],failure=True)
        for i,name in enumerate((NAMES[0],NAMES[4],NAMES[10])):
            run(backend+'-bad-output'+str(i),[binary,'--check-bad-output',name,10,16,8,50,42,0,0],failure=True,diagnostic='full output mismatch')
        rows=[]
        for i,c in enumerate(planned):
            raw=run(backend+'-case'+str(i).zfill(3),[binary,*original.arguments(c)])
            rows.append(validate(original.parse_one(raw),c))
        allrows.extend(rows);need(parity(allrows)==30,'Wrong canonical small-fixture identities')
        need(compare_baseline(rows,old)==30,'Missing original-facade baseline parity')
        metadata['rows'][backend]=rows;save()
        if backend=='native':
            audit=assembly(binary,a.output/'assembly')
            symbols='\n'.join(r['symbol']for r in audit['functions'])
            symbols=re.sub(r'(?<=\d)u\b','',symbols)
            for k in (4,6,8):
                for compact in ('false','true'):
                    for family in ('RawPage','RawPagePointer'):
                        need(f'{family}<{k}, {compact}>'in symbols,'Missing typed Page caller assembly')
            metadata['assembly_capture_complete']=True;save()
        verify(a.source_commit)
    for name,want in consumed.items():need(sha(Path(name))==want,'Actual consumed source changed')
    for record in metadata['binaries'].values():need(sha(Path(record['path']))==record['sha256'],'Built binary changed')
    metadata.update(complete=True,tuner_file_after=tuner_file(),all_sources_and_binaries_unchanged=True,
       caller_query_checks=19620,unpooled_fixture_identities=30,worker_rows=96)
    save()
    print('Native/ASan96 worker rows and19620 targeted caller checks passed; manual pointer-address ASM review remains required; no timings')

if __name__=='__main__':main()
