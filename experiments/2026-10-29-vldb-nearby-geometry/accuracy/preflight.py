#!/usr/bin/env python3
"""Compile and check the additive caller only; never launches the full36 pilot."""
import argparse
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import time
from contract import GEOMETRY,cases,command,comparable,names,need,parse,untimed
from nearby_accuracy_guard import HERE,ROOT,ORIGINAL,PARENT,sha,verify,validate_inputs
sys.path.insert(0,str(PARENT))
from startup_guards import require_new_build_root,require_inherited_write_lock
sys.path.insert(0,str(ORIGINAL))
from validate import lease,tuner_file
from capture_headers import capture

def main():
    need(__debug__,'Python -O is forbidden')
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit',required=True);parser.add_argument('--cpu',type=int,required=True)
    parser.add_argument('--lease',required=True);parser.add_argument('--build',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True);args=parser.parse_args()
    need((args.cpu,args.lease)==(2,'socket0'),'Caller preflight is fixed to CPU2/socket0')
    fds=require_inherited_write_lock(args.cpu,args.lease);held=lease(args.cpu,args.lease)
    need(sorted(held['inherited_lock_descriptors'])==fds,'Inherited lock mismatch')
    require_new_build_root(args.build)
    need(not args.output.exists()and not args.output.is_symlink(),'Preserve every prior attempt')
    environment={k:os.environ.get(k)for k in ['LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF',
        'MALLOC_ARENA_MAX','CFLAGS','CXXFLAGS','CPPFLAGS','LDFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']}
    need(not any(environment.values()),'Unfrozen compiler/loader/sanitizer environment')
    archives,inputs=verify(args.source_commit);before=tuner_file()
    args.build.mkdir(parents=True,exist_ok=False);args.output.mkdir(parents=True,exist_ok=False)
    meta=dict(complete=False,source_commit=args.source_commit,lease=held,environment=environment,
              commands=[],rows={},binaries={},reference_binaries=inputs['reference_binaries'],
              tuner_file_before=before,formal_pilot_run=False,throughput_samples=0)
    def save():(args.output/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    def run(label,argv,success=True,diagnostic=None):
        need(require_inherited_write_lock(args.cpu,args.lease)==fds,'Lease drift')
        record=dict(label=label,command=list(map(str,argv)),complete=False)
        meta['commands'].append(record);save();start=time.monotonic()
        result=subprocess.run(record['command'],cwd=ROOT,capture_output=True)
        for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
            path=args.output/(label+'.'+stream);path.write_bytes(data)
            record[stream]=path.name;record[stream+'_sha256']=sha(path)
        record.update(returncode=result.returncode,diagnostic_process_seconds=time.monotonic()-start);save()
        need((result.returncode==0)==success,'Unexpected result '+label)
        if success and '-case' in label:need(not result.stderr,'Unexpected public caller diagnostic')
        if not success:
            need(not result.stdout,'Rejected/fault invocation emitted a row')
            if diagnostic:need(diagnostic in result.stderr.decode(),'Wrong fault diagnostic')
        record['complete']=True;save();return result.stdout.decode()
    save()
    try:
        run('compiler',['g++','--version']);reference=None
        for backend in ('native','native-asan'):
            build=args.build/backend;archive=archives[backend]
            run(backend+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_CXX_COMPILER=g++',
                '-DVLDB_BACKEND='+backend,'-DVLDB_ARCHIVE='+str(ROOT/archive['path']),
                '-DVLDB_ARCHIVE_SHA256='+archive['sha256']])
            run(backend+'-build',['cmake','--build',build,'-j1']);binary=(build/'vldb_nearby_accuracy').resolve()
            meta['binaries'][backend]=dict(path=str(binary),sha256=sha(binary));save()
            headers=capture(build);validate_inputs(headers,inputs['files'])
            (args.output/(backend+'-consumed-inputs.json')).write_text(json.dumps(headers,indent=2)+'\n')
            database=json.loads((build/'compile_commands.json').read_text())
            need(len(database)==1 and Path(database[0]['file']).name=='worker.cpp','Unexpected upstream rebuild')
            entry=database[0];cmd=entry.get('arguments')or shlex.split(entry['command']);stripped=[];i=0
            while i<len(cmd):
                if cmd[i]=='-o':i+=2;continue
                if cmd[i]not in ('-c',entry['file']):stripped.append(cmd[i])
                i+=1
            macros=run(backend+'-macros',stripped+['-dM','-E','-x','c++','/dev/null'])
            need('#define __AVX2__ 1'in macros and '__AVX512'in macros and
                 ('__SANITIZE_ADDRESS__'in macros)==(backend=='native-asan'),'Wrong backend ISA/sanitizer')
            rows=[]
            for name in names():
                old=None
                for policy in ('original','nearby_odd'):
                    case=dict(filter=name,power=16,cap=24,policy=policy)
                    label=backend+'-case'+str(len(rows));row=parse(run(label,command(binary,case,tiny=True)))
                    untimed(row,power=16,qpower=12,calpower=10)
                    selected=[c for c in cases()if c['filter']==name and c['power']==16 and c['cap']==24 and c['policy']==policy]
                    need(len(selected)==1 and comparable({k:row[k]for k in GEOMETRY})==comparable(selected[0]['geometry']),'Actual caller differs from93-proved geometry')
                    rows.append(row)
                    if policy=='original':
                        old_binary=inputs['reference_binaries'][backend]['path']
                        old=parse(run(label+'-old',command(old_binary,case,tiny=True)[:-1]))
                        need(comparable(row)==comparable(old),'Frozen old caller parity failed')
                    need(tuner_file()==before,'User tuner file changed')
            if reference is None:reference=rows
            need(rows==reference,'Native/sanitizer full caller parity failed')
            meta['rows'][backend]=rows;save()
            base=command(binary,dict(filter=names()[0],power=16,cap=24,policy='nearby_odd'),tiny=True)
            invalid=[]
            for index,value in [(2,'missing'),(4,'32'),(1,'--measure'),(9,'6'),(10,'missing')]:
                argv=base.copy();argv[index]=value;invalid.append(argv)
            invalid.append(command(binary,dict(filter=names()[0],power=16,cap=24,policy='nearby_odd'),
                                   tiny=True,action='--check-bad-output'))
            for i,argv in enumerate(invalid):
                run(backend+'-invalid'+str(i),argv,False,'full output mismatch'if i==5 else None)
        need(verify(args.source_commit)==(archives,inputs)and tuner_file()==before,'Final frozen input drift')
        for item in meta['binaries'].values():need(sha(item['path'])==item['sha256'],'Tested binary drift')
        meta.update(complete=True,caller_rows=12,old_reference_rows=6,rejected_or_fault_cases=12,
                    tuner_file_after=tuner_file(),frozen_sources_unchanged=True,upstream_rebuilds=0)
        save();print('PASS12 caller rows/6old references/12 rejected-or-fault cases; no formal36 run or timing')
    except BaseException as error:
        meta.update(complete=False,failure=repr(error));save();raise

if __name__=='__main__':main()
