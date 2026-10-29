#!/usr/bin/env python3
"""Finite original-public-API geometry proof; no quality or throughput sample."""
import argparse,json,os,shlex,subprocess,sys,time
from pathlib import Path
from nearby_contract import need,cases,BACKENDS,validate,reference_row,CONFIGS
from nearby_guard import HERE,ROOT,PARENT,ORIGINAL,sha,verify
sys.path.insert(0,str(PARENT))
from startup_guards import require_new_build_root,require_inherited_write_lock
sys.path.insert(0,str(ORIGINAL))
from validate import lease,tuner_file
from capture_headers import capture

def main():
    need(__debug__,'Python -O unsupported')
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True)
    p.add_argument('--cpu',type=int,required=True);p.add_argument('--lease',required=True)
    p.add_argument('--build',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    fds=require_inherited_write_lock(a.cpu,a.lease);held=lease(a.cpu,a.lease)
    need(sorted(held['inherited_lock_descriptors'])==fds,'Inherited lock changed')
    require_new_build_root(a.build);need(not a.output.exists()and not a.output.is_symlink(),'Preserve previous attempt')
    for key in ['LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','CFLAGS','CXXFLAGS','LDFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']:
        need(not os.environ.get(key),'Unfrozen environment '+key)
    archives=verify(a.source_commit);before=tuner_file()
    a.build.mkdir(parents=True,exist_ok=False);a.output.mkdir(parents=True,exist_ok=False)
    meta=dict(complete=False,source_commit=a.source_commit,lease=held,commands=[],backend_rows={},binaries={},tuner_file_before=before,
              scope='93 finite actual-geometry public API correctness cases; no calibration or throughput')
    def save():(a.output/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    def run(label,command,success=True):
        need(require_inherited_write_lock(a.cpu,a.lease)==fds,'Lease changed')
        command=list(map(str,command));record=dict(label=label,command=command,complete=False);meta['commands'].append(record);save()
        start=time.monotonic();result=subprocess.run(command,cwd=ROOT,capture_output=True,text=True)
        for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
            path=a.output/(label+'.'+stream);path.write_text(data);record[stream]=path.name;record[stream+'_sha256']=sha(path)
        record.update(returncode=result.returncode,diagnostic_process_seconds=time.monotonic()-start);save()
        need((result.returncode==0)==success,label+' failed; source/logs preserved')
        if not success:need(not result.stdout,'Malformed CLI emitted a geometry')
        record['complete']=True;save();return result.stdout
    save();run('compiler',['g++','--version']);reference=None
    parent=json.loads((PARENT/'validation-v1/metadata.json').read_text())
    parent_cases=[(c,n,b)for c in CONFIGS for n in (16,25)for b in (12,16,24,32)]
    for backend in BACKENDS:
        build=a.build/backend;archive=archives[backend]
        run(backend+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_CXX_COMPILER=g++','-DVLDB_BACKEND='+backend,'-DVLDB_ARCHIVE='+str(ROOT/archive['path']),'-DVLDB_ARCHIVE_SHA256='+archive['sha256']])
        run(backend+'-build',['cmake','--build',build,'-j1']);binary=(build/'vldb_nearby_check').resolve()
        meta['binaries'][backend]=dict(path=str(binary),sha256=sha(binary));save()
        headers=capture(build);need(headers['boost']['version']=='1_83','Mixed/wrong Boost root')
        (a.output/(backend+'-consumed-headers.json')).write_text(json.dumps(headers,indent=2)+'\n')
        db=json.loads((build/'compile_commands.json').read_text());need(len(db)==1 and Path(db[0]['file']).name=='check.cpp','Unexpected upstream rebuild')
        entry=db[0];cmd=entry.get('arguments')or shlex.split(entry['command']);stripped=[];i=0
        while i<len(cmd):
            if cmd[i]=='-o':i+=2;continue
            if cmd[i]not in ('-c',entry['file']):stripped.append(cmd[i])
            i+=1
        macros=run(backend+'-macros',stripped+['-dM','-E','-x','c++','/dev/null'])
        need('#define __AVX2__ 1'in macros and ('__AVX512'in macros)==(backend!='avx2')and ('__SANITIZE_ADDRESS__'in macros)==(backend=='native-asan'),'Wrong backend macro boundary')
        rows=[]
        for index,case in enumerate(cases()):
            raw=run(backend+'-case'+str(index),[binary,*case]);lines=raw.splitlines();need(len(lines)==1,'Expected one exact geometry result')
            row=validate(json.loads(lines[0]),case);rows.append(row)
            if case[-1]=='original':need(reference_row(row)==parent['backend_rows'][backend][parent_cases.index(case[:3])],'Original control changed from passed stage2')
            need(tuner_file()==before,'Existing tuner file changed')
        need(len(rows)==31,'Wrong finite geometry coverage')
        if reference is None:reference=rows
        need(rows==reference,'Cross-backend geometry/full-bitmap/output mismatch')
        meta['backend_rows'][backend]=rows;save()
        for index,args in enumerate([['missing','16','24','nearby_odd'],['sector32-u1','16','16','nearby_odd'],['sector32-u1','16','24','missing']]):
            run(backend+'-invalid'+str(index),[binary,*args],False)
        verify(a.source_commit)
    need(tuner_file()==before,'Final tuner drift');meta.update(complete=True,tuner_file_after=tuner_file(),all_sources_unchanged=True,
        actual_geometry_cases=93,malformed_cli_cases=9,upstream_rebuilds=0,quality_samples=0,throughput_samples=0);save()
    print('PASS93 finite actual-geometry cases and9 malformed CLI checks; no quality/throughput sample')

if __name__=='__main__':main()
