#!/usr/bin/env python3
"""Bounded public-caller preflight only; never launches the160 timing matrix."""
import argparse
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import time
from checks import NATIVE,cases,command,parse,validate,normalized,check_aliases,geometry_key,names,need
from source_guard import HERE,ROOT,ORIGINAL,PARENT,verify,validate_inputs,sha
sys.path.insert(0,str(PARENT))
from startup_guards import require_new_build_root,require_inherited_write_lock
sys.path.insert(0,str(ORIGINAL))
from validate import lease,tuner_file
from capture_headers import capture as capture_inputs
from capture_assembly import capture as capture_assembly

def main():
    need(__debug__,'Python -O forbidden')
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True)
    p.add_argument('--cpu',type=int,required=True);p.add_argument('--lease',required=True)
    p.add_argument('--build',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    need((a.cpu,a.lease)==(2,'socket0'),'Fixed CPU2/socket0 correctness lease')
    need(a.build.resolve()==ROOT/'build/vldb-nearby-raw32-v1' and a.output.resolve()==HERE/'validation-v1','Use declared fresh v1 paths')
    fds=require_inherited_write_lock(a.cpu,a.lease);held=lease(a.cpu,a.lease)
    need(sorted(held['inherited_lock_descriptors'])==fds,'Inherited lease mismatch');require_new_build_root(a.build)
    need(not a.output.exists()and not a.output.is_symlink(),'Preserve all prior proof attempts')
    environment={key:os.environ.get(key)for key in ['LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF',
        'MALLOC_ARENA_MAX','CFLAGS','CXXFLAGS','CPPFLAGS','LDFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']}
    need(not any(environment.values()),'Unfrozen compiler/runtime environment')
    archives,pins,local=verify(a.source_commit);before=tuner_file()
    a.build.mkdir(parents=True,exist_ok=False);a.output.mkdir(parents=True,exist_ok=False)
    meta=dict(complete=False,source_commit=a.source_commit,lease=held,affinity=sorted(os.sched_getaffinity(0)),
        environment=environment,commands=[],binaries={},rows={},public_payloads={},native_oracles={},
        tuner_file_before=before,performance_run=False,throughput_samples=0,upstream_rebuilds=0)
    def save():(a.output/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    def run(label,argv,success=True,diagnostic=None,binary=False):
        need(require_inherited_write_lock(a.cpu,a.lease)==fds,'Lease drift')
        record=dict(label=label,command=list(map(str,argv)),complete=False);meta['commands'].append(record);save();start=time.monotonic()
        result=subprocess.run(record['command'],cwd=ROOT,capture_output=True)
        for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
            path=a.output/(label+'.'+stream);path.write_bytes(data);record[stream]=path.name;record[stream+'_sha256']=sha(path)
        record.update(returncode=result.returncode,diagnostic_process_seconds=time.monotonic()-start);save()
        need((result.returncode==0)==success,'Unexpected command result '+label)
        if success and any(word in label for word in ('-case','-payload','-oracle','-reference','-names')):
            need(not result.stderr,'Unexpected public fixture diagnostic')
        if not success:
            need(not result.stdout,'Rejected/fault command emitted row')
            if diagnostic:need(diagnostic in result.stderr.decode(),'Wrong intended failure')
        record['complete']=True;save();return result.stdout if binary else result.stdout.decode()
    save()
    try:
        run('compiler',['g++','--version']);rows_reference=None;payload_reference={};oracle_reference=None
        for backend in ('native','native-asan'):
            build=a.build/backend;archive=archives[backend]
            run(backend+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_CXX_COMPILER=g++',
                '-DVLDB_BACKEND='+backend,'-DVLDB_ARCHIVE='+str(ROOT/archive['path']),'-DVLDB_ARCHIVE_SHA256='+archive['sha256']])
            run(backend+'-build',['cmake','--build',build,'-j1'])
            worker=(build/'nearby_raw32').resolve();checker=(build/'nearby_check').resolve()
            for name,binary in [('worker',worker),('checker',checker)]:meta['binaries'][backend+'/'+name]=dict(path=str(binary),sha256=sha(binary))
            save();headers=capture_inputs(build);validate_inputs(headers,pins,local)
            (a.output/(backend+'-consumed-inputs.json')).write_text(json.dumps(headers,indent=2)+'\n')
            need(run(backend+'-names',[worker,'--names']).splitlines()==names(),'Missing/reordered registered API')
            entry=next(e for e in headers['compile_commands']if Path(e['file']).name=='worker.cpp')
            argv=entry.get('arguments')or shlex.split(entry['command']);flags=[];i=0
            while i<len(argv):
                if argv[i]=='-o':i+=2;continue
                if argv[i]not in ('-c',entry['file']):flags.append(argv[i])
                i+=1
            macros=run(backend+'-macros',flags+['-dM','-E','-x','c++','/dev/null'])
            need('#define __AVX2__ 1'in macros and '__AVX512'in macros and
                 ('__SANITIZE_ADDRESS__'in macros)==(backend=='native-asan'),'Wrong ISA/sanitizer profile')
            rows=[];references=0
            for i,case in enumerate(cases()):
                row=parse(run(backend+'-case'+str(i),command(worker,case)));validate(row,case);rows.append(row)
                name=case['filter'];old_argv=None
                if name in NATIVE[:4]:old_argv=command(pins['reference_binaries'][backend]['path'],case)
                elif name not in NATIVE:
                    config,surface,policy=name.split('/')
                    old_case=dict(case,filter=config+'/'+surface)
                    if policy=='original':old_argv=command(pins['reference_binaries'][backend]['path'],old_case)
                    elif config in ('sector32-u1','sector64-u1','register64-u0'):
                        old_argv=command(pins['accuracy_binaries'][backend]['path'],old_case)+['nearby_odd']
                if old_argv:
                    old=parse(run(backend+'-reference'+str(i),old_argv));need(normalized(row)==normalized(old),'Old public caller complete row changed');references+=1
                need(tuner_file()==before,'User tuner file changed')
            need(references==28,'Expected28 exact old reference rows/backend');check_aliases(rows)
            if rows_reference is None:rows_reference=rows
            else:need(rows==rows_reference,'Native/ASan complete caller mismatch')
            meta['rows'][backend]=rows;save()
            payloads={};canonical={}
            for i,case in enumerate(cases()):
                if case['filter']in NATIVE:continue
                label=backend+'-payload'+str(i)
                data=run(label,[checker,'--public-bitmap',case['filter'],'16',str(case['cap'])],binary=True)
                need(len(data)==int(rows[i]['filter_bytes'])+8193*4,'Wrong full bitmap/output payload extent')
                key=geometry_key(case['filter'])+'/'+str(case['cap'])
                if key in canonical:need(data==canonical[key],'Full U-alias bitmap/output byte mismatch')
                else:canonical[key]=data
                if backend=='native':payload_reference[i]=data
                else:need(payload_reference[i]==data,'Native/ASan full public payload mismatch')
                payloads[str(i)]=dict(case=case,artifact=label+'.stdout',bytes=len(data),sha256=sha(a.output/(label+'.stdout')),
                                      mapping_identity=key,full_U_alias_equal=True)
            need(len(payloads)==28 and len(canonical)==12,'Expected28 API/12 U-deduplicated public payloads')
            meta['public_payloads'][backend]=payloads;save()
            oracles=[]
            for name in NATIVE[4:]:
                for power in (16,25):
                    for cap in (12,24):
                        row=parse(run(backend+'-oracle'+str(len(oracles)),[checker,'--native-oracle',name,str(power),str(cap)]))
                        need(row['filter']==name and int(row['keys'])==1<<power and int(row['cap'])==cap,'Oracle identity changed')
                        need(int(row['actual_bytes'])==(1<<power)*cap//8 and row['full_bitmap_equal']==row['full_outputs_equal']=='1','Incomplete full bitmap/output proof')
                        need(row['fixture_inserted']=='1031'and row['fixture_queries']=='8193'and row['filter_build_scratch_bytes']=='0'and
                             int(row['full_n_build_hash_scratch_bytes'])==8*(1<<power)and
                             int(row['fixture_build_hash_payload_bytes'])==1031*8,'Oracle scope/scratch changed')
                        oracles.append(row)
            if oracle_reference is None:oracle_reference=oracles
            else:need(oracles==oracle_reference,'Native/ASan original-type full bitmap oracle mismatch')
            meta['native_oracles'][backend]=oracles;save()
            base=command(worker,cases()[0]);bad=[]
            for index,value in [(2,'missing'),(4,'16'),(1,'--bogus'),(9,'1')]:
                argv=base.copy();argv[index]=value;bad.append(argv)
            bad.append([checker,'--public-bitmap',cases()[0]['filter'],'25','12'])
            bad.append(command(worker,cases()[0],action='--check-bad-output'))
            for i,argv in enumerate(bad):run(backend+'-invalid'+str(i),argv,False,'full output mismatch'if i==5 else None)
            if backend=='native':meta['assembly']=capture_assembly(worker,a.output/'assembly');save()
        need(verify(a.source_commit)==(archives,pins,local)and tuner_file()==before,'Final frozen source/tuner drift')
        for item in meta['binaries'].values():need(sha(item['path'])==item['sha256'],'Tested binary drift')
        meta.update(complete=True,caller_rows=80,old_reference_rows=56,public_bitmap_payloads=56,native_full_bitmap_oracles=16,
                    invalid_or_fault_cases=12,tuner_file_after=tuner_file(),frozen_sources_unchanged=True,
                    manual_assembly_review_required=True,formal160_launched=False)
        save();print('PASS80 callers/56 old references/56 public payloads/16 native full-byte oracles/12 badCLI; no timing matrix')
    except BaseException as error:meta.update(complete=False,failure=repr(error));save();raise
if __name__=='__main__':main()
