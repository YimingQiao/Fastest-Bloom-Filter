#!/usr/bin/env python3
"""Lease-gated, correctness-only larger/MAGIC proof; no timing matrix."""
import argparse,json,shlex,subprocess,sys,time
from pathlib import Path
from contract import need,validate,geometry_cases,validate_geometry
from source_guard import HERE,ROOT,PARENT,sha,verify
from startup_guards import require_new_build_root,require_inherited_write_lock
sys.path.insert(0,str(PARENT))
from validate import lease,tuner_file
from capture_headers import capture

def main():
    need(__debug__,'Python -O is unsupported')
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source-commit',required=True)
    p.add_argument('--cpu',type=int,required=True);p.add_argument('--lease',required=True)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--build',type=Path,required=True)
    p.add_argument('--backends',nargs='+',default=['native','avx2','native-asan'],choices=['native','avx2','native-asan'])
    a=p.parse_args()
    inherited=require_inherited_write_lock(a.cpu,a.lease)
    held=lease(a.cpu,a.lease)
    need(sorted(held['inherited_lock_descriptors'])==inherited,'Lease descriptor set changed')
    held['inherited_write_verified']=True
    require_new_build_root(a.build)
    need(len(set(a.backends))==len(a.backends),'Duplicate backend')
    inventory=verify(a.source_commit)
    protocol=validate(json.loads((HERE/'protocol.json').read_text()))
    archives=json.loads((HERE/'archives.json').read_text())['archives']
    initial_tuner=tuner_file()
    a.build.mkdir(parents=True,exist_ok=False)
    a.output.mkdir(parents=True,exist_ok=False)
    metadata=dict(scope='Correctness-only; no throughput/FPR calibration',source_commit=a.source_commit,
                  preparation_sha256=sha(HERE/'PREPARATION.json'),lease=held,commands=[],binaries={},
                  tuner_file_before=initial_tuner,backend_rows={},complete=False)
    for relative in inventory['files']:
        dst=a.output/'source-snapshot'/relative;dst.parent.mkdir(parents=True,exist_ok=True)
        dst.write_bytes((ROOT/relative).read_bytes())
    def save(): (a.output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    def run(label,command):
        command=[str(x) for x in command];start=time.monotonic()
        result=subprocess.run(command,cwd=ROOT,capture_output=True,text=True)
        (a.output/(label+'.stdout')).write_text(result.stdout)
        (a.output/(label+'.stderr')).write_text(result.stderr)
        metadata['commands'].append(dict(label=label,command=command,returncode=result.returncode,
                                        diagnostic_elapsed_seconds=time.monotonic()-start));save()
        need(result.returncode==0,label+' failed; source/logs retained')
        return result.stdout
    save();run('compiler',['g++','--version']);reference=None
    for backend in a.backends:
        build=a.build/backend;archive=archives[backend]
        run(backend+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_CXX_COMPILER=g++',
             '-DVLDB_BACKEND='+backend,'-DVLDB_ARCHIVE='+str(ROOT/archive['path']),
             '-DVLDB_ARCHIVE_SHA256='+archive['sha256']])
        run(backend+'-build',['cmake','--build',build,'-j1'])
        binary=(build/'vldb_geometry_check').resolve()
        destination=a.output/'binaries'/backend/binary.name
        destination.parent.mkdir(parents=True,exist_ok=True);destination.write_bytes(binary.read_bytes());destination.chmod(binary.stat().st_mode)
        metadata['binaries'][backend]=dict(path=str(binary),sha256=sha(binary),retained=str(destination.resolve()))
        headers=capture(build)
        need(headers['boost']['version']=='1_83','Mixed or wrong legacy Boost root')
        (a.output/(backend+'-consumed-headers.json')).write_text(json.dumps(headers,indent=2)+'\n')
        database=json.loads((build/'compile_commands.json').read_text())
        need(len(database)==1 and Path(database[0]['file']).name=='geometry_check.cpp','Unexpected rebuild of original library')
        entry=database[0];command=entry.get('arguments') or shlex.split(entry['command'])
        stripped=[];i=0
        while i<len(command):
            arg=command[i]
            if arg=='-o': i+=2;continue
            if arg not in ('-c',entry['file']):stripped.append(arg)
            i+=1
        macros=run(backend+'-macros',stripped+['-dM','-E','-x','c++','/dev/null'])
        need('#define __AVX2__ 1' in macros,'Missing AVX2 backend')
        need(('__AVX512' in macros)==(backend!='avx2'),'AVX512 backend boundary')
        need(('__SANITIZE_ADDRESS__' in macros)==(backend=='native-asan'),'Sanitizer backend boundary')
        rows=[]
        for case in geometry_cases(protocol):
            label=backend+'-'+case[0]+'-n'+str(case[1])+'-b'+str(case[2])
            raw=run(label,[binary,*case]);parsed=[json.loads(x) for x in raw.splitlines() if x.strip()]
            need(len(parsed)==1,'Expected exactly one original geometry row')
            rows.append(validate_geometry(parsed[0],case))
            need(tuner_file()==initial_tuner,'Existing tuner file changed')
        need(len(rows)==56,'Missing registered geometry')
        if reference is None:reference=rows
        need(rows==reference,'Backend bitmap/output/geometry mismatch')
        metadata['backend_rows'][backend]=rows;save()
        verify(a.source_commit)
    metadata.update(complete=True,tuner_file_after=tuner_file(),all_sources_unchanged=True)
    save();print('Complete larger/MAGIC public API proof; no throughput or FPR result')

if __name__=='__main__':main()
