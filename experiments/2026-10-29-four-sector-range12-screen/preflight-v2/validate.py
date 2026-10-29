#!/usr/bin/env python3
"""Focused234 actual-caller rows+75 old25 controls+9 independent K12 records."""
if not __debug__:raise RuntimeError('Use Python without -O')
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent.parent/"preflight"))
import argparse
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import time
from source_guard import HERE,STAGE,ROOT,PARENT,need,sha,save,verify,consumed
from revision_guard import verify
from lease import require_lease
from checks import csvrows,validate_case,same,oracle,command

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True);parser.add_argument('--cpu',type=int,choices=[2,3],required=True)
    args=parser.parse_args();lease=require_lease(args.cpu);pins=verify(args.source_commit)
    out=STAGE/'caller-validation-v2';build_root=Path('/tmp/fastest-bf-k12-actual-caller-v2')
    need(not out.exists()and not out.is_symlink()and not build_root.exists()and not build_root.is_symlink(),'Preserve previous attempt; no stale/dangling target')
    env={k:os.environ.get(k)for k in ['BF_SOCKET_LEASE','LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','CXXFLAGS','CPPFLAGS','LDFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']}
    need(all(v is None for k,v in env.items()if k!='BF_SOCKET_LEASE'),'Unfrozen build/runtime environment')
    out.mkdir();build_root.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,lease=lease,affinity=sorted(os.sched_getaffinity(0)),host=platform.uname()._asdict(),environment=env,source_sha256=pins,commands=[],profiles={},started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    save(out/'metadata.json',meta)
    def run(label,cmd,expect=0,asan=False):
        need(require_lease(args.cpu)==lease,'Lease changed')
        record=dict(label=label,command=list(map(str,cmd)),complete=False,ASAN_OPTIONS='detect_leaks=1:halt_on_error=1'if asan else None)
        record.update(stdout=label+'.stdout',stderr=label+'.stderr');meta['commands'].append(record);save(out/'metadata.json',meta)
        child=os.environ.copy()
        if asan:child['ASAN_OPTIONS']=record['ASAN_OPTIONS']
        result=subprocess.run(record['command'],cwd=ROOT,env=child,capture_output=True)
        for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
            path=out/record[stream];path.write_bytes(data);record[stream+'_sha256']=sha(path)
        record['returncode']=result.returncode;save(out/'metadata.json',meta)
        need(result.returncode==0 if expect==0 else result.returncode!=0,'Unexpected command exit '+label)
        record['complete']=True;save(out/'metadata.json',meta);return result.stdout.decode(),result.stderr.decode()
    try:
        compiler=Path(shutil.which('clang++')).absolute();need(compiler.is_file(),'Missing compiler')
        run('compiler',[str(compiler),'--version']);run('cmake-version',['cmake','--version'])
        meta['compiler']=dict(path=str(compiler),sha256=sha(compiler))
        names=json.loads((STAGE/'registry.json').read_text());old_names=json.loads((PARENT/'registry.json').read_text());reference={};allrows=[];oracles=[];plans={};binary_hashes={}
        for profile,native,asan in [('native',True,False),('avx2',False,False),('asan',True,True)]:
            build=build_root/profile
            config=['cmake','-S',str(HERE),'-B',str(build),'-DCMAKE_BUILD_TYPE=Release','-DCMAKE_CXX_COMPILER='+str(compiler),'-DBF_NATIVE='+('ON'if native else'OFF'),'-DBF_SANITIZERS='+('ON'if asan else'OFF'),'-DFETCHCONTENT_SOURCE_DIR_FASTFILTER='+str(ROOT/'build/cpp-external/_deps/fastfilter-src'),'-DFETCHCONTENT_SOURCE_DIR_PAGEBLOOM='+str(ROOT/'build/cpp-external/_deps/pagebloom-src'),'-DFETCHCONTENT_FULLY_DISCONNECTED=ON']
            run(profile+'-configure',config);run(profile+'-build',['cmake','--build',str(build),'-j1'])
            proof=consumed(build,pins,reference=profile=='native');save(out/(profile+'-compiler-inputs.json'),proof)
            for name in ['CMakeCache.txt','compile_commands.json']:(out/(profile+'-'+name)).write_bytes((build/name).read_bytes())
            for name in proof['files_sha256']:
                target=out/profile/'depfiles'/name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes((build/name).read_bytes())
            paths={key:build/path for key,path in dict(benchmark='actual/benchmark',planner='planner',oracle='k12_oracle').items()}
            if profile=='native':paths['reference']=build/'reference'
            if native:paths['fixtures']=build/'fixtures'
            for path in paths.values():need(path.is_file(),'Missing actual executable');binary_hashes[str(path)]=sha(path)
            meta['profiles'][profile]=dict(executables={k:str(v)for k,v in paths.items()},compiler_inputs_sha256=sha(out/(profile+'-compiler-inputs.json')));save(out/'metadata.json',meta)
            for cap in [16,24,32]:
                text,err=run(f'{profile}-plan-{cap}',[paths['planner'],str(cap)],asan=asan);need(not err,'Planner diagnostics');plan=csvrows(text)
                need([r['filter']for r in plan]==names,'Planner26 registry drift')
                if profile=='native':plans[cap]=plan
                else:need(plan==plans[cap],'Backend geometry drift')
                text,err=run(f'{profile}-all-{cap}',command(paths['benchmark'],cap),asan=asan);need(not err,'Actual caller diagnostics')
                rows=csvrows(text);current=validate_case(rows,plan,cap,names);allrows.extend(dict(profile=profile,**r)for r in rows)
                if profile=='native':
                    text,err=run(f'reference-{cap}',command(paths['reference'],cap));need(not err,'Reference diagnostics');old=validate_case(csvrows(text),plan,cap,old_names);reference[cap]=old
                for name in old_names:same(current[name],reference[cap][name])
                text,err=run(f'{profile}-oracle-{cap}',[paths['oracle'],str(cap)],asan=asan);need(not err,'Oracle diagnostics');records=csvrows(text);need(len(records)==1,'Wrong oracle count');oracle(current['FourSectorRange12Experiment'],records[0]);oracles.append(dict(profile=profile,cap=cap,**records[0]))
            if native:
                fixtures=paths['fixtures']
                for name in ['QueryOnceFixture','LatePureFault','LateHashFault','LateGuardFault']:
                    text,err=run(profile+'-fixture-'+name,command(fixtures,14,name,4096,cal=0),expect=0 if name=='QueryOnceFixture'else 1,asan=asan)
                    if name=='QueryOnceFixture':
                        need(len(csvrows(text))==1 and not err,'One-build fixture')
                        _,err=run(profile+'-fixture-second-build',command(fixtures,14,name,4096,mode='full',builds=1,cal=0),expect=1,asan=asan);need('constructed more than one'in err,'Wrong second-build failure')
                    else:need(('output'in err or 'guard'in err)and len(text.splitlines())==1,'Fault not rejected before data')
            if profile=='native':
                bad=[dict(selection='FastPatternBF,missing'),dict(selection='FastPatternBF,FastPatternBF'),dict(selection='FastPatternBF,'),dict(repeats=3),dict(mode='query-only',builds=1),dict(mode='full',builds=0)]
                for i,kwargs in enumerate(bad):text,err=run('invalid-'+str(i),command(paths['benchmark'],**kwargs),expect=1);need(not text and bool(err),'Invalid CLI emitted data')
                for label,selection,batch in [('subset','FastPatternBF,FourSectorRange12Experiment',31),('bulk','FourSectorRange12Experiment',4096)]:
                    text,err=run('valid-'+label,command(paths['benchmark'],selection=selection,batch=batch));need(not err,'Valid subset diagnostics');subset=[name for name in names if name in selection.split(',')];rows=validate_case(csvrows(text),plans[16],16,subset,batch=batch)
                    for name,row in rows.items():
                        original=next(r for r in allrows if r['profile']=='native'and r['requested_bpk']=='16'and r['filter']==name);same(row,original)
        need(len(allrows)==234 and len(oracles)==9,'Wrong focused caller coverage')
        save(out/'semantic-rows.json',allrows);save(out/'oracle-rows.json',oracles);save(out/'reference-rows.json',reference)
        need(pins==verify(args.source_commit) and require_lease(args.cpu)==lease,'Final source/lease drift')
        for name,digest in binary_hashes.items():need(sha(Path(name))==digest,'Executable changed')
        for profile in meta['profiles']:
            proof=json.loads((out/(profile+'-compiler-inputs.json')).read_text())
            for name,digest in proof['consumed_sha256'].items():need(sha(Path(name))==digest,'Consumed compiler input changed')
        meta.update(complete=True,actual_rows=234,reference_rows=75,retained_semantic_comparisons=225,oracle_records=9,binary_sha256=binary_hashes,final_frozen_inputs_equal=True,finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
        save(out/'metadata.json',meta)
        save(out/'ARCHIVE.json',{'scope':'Focused correctness-only actual-caller evidence; no performance claim','files':{str(p.relative_to(out)):{'sha256':sha(p),'bytes':p.stat().st_size}for p in sorted(out.rglob('*'))if p.is_file()}})
        print('PASS234 actual rows+75 reference rows+9 full K12 bitmap/output oracle records; timings unclaimed',flush=True)
    except BaseException as error:meta.update(complete=False,error=repr(error));save(out/'metadata.json',meta);raise
if __name__=='__main__':main()
