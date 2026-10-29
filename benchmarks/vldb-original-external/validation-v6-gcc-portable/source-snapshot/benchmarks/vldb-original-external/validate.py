#!/usr/bin/env python3
"""Lease-gated compile/public-API/accounting proof. No calibration or timing."""
import argparse,csv,fcntl,hashlib,io,json,os,pwd,shlex,subprocess,time
from pathlib import Path
from verify_sources import sha,verify
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]

def require(ok,message):
    if not ok:raise ValueError(message)

def lease(cpu,name):
    require((cpu,name) in ((2,'socket0'),(3,'socket1')),'Unsupported explicit CPU/socket pair')
    require(os.sched_getaffinity(0)=={cpu},'Pin the whole validation process')
    lock='/tmp/fastest-bf-'+name+'.lock';descriptors=[]
    for entry in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+entry)==lock:
                fd=int(entry);fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB);descriptors.append(fd)
        except FileNotFoundError:pass
    require(bool(descriptors),'Missing inherited whole-operation flock')
    return dict(cpu=cpu,lease=name,lock_path=lock,inherited_lock_descriptors=descriptors)

def tuner_file():
    root=os.environ.get('HOME')
    if root is None:root=pwd.getpwuid(os.getuid()).pw_dir
    path=Path(root)/'.dtl-filter.dat'
    if not path.exists():return dict(path=str(path),exists=False)
    stat=path.stat()
    require(path.is_file(),'Upstream tuner path is not a regular file')
    return dict(path=str(path),resolved_path=str(path.resolve()),exists=True,bytes=stat.st_size,
                device=stat.st_dev,inode=stat.st_ino,mtime_ns=stat.st_mtime_ns,sha256=sha(path))

def accounting(rows):
    expected={'DirectDynamic32W8S8K8U1','StaticLogic32W8S8K8U1','ArtifactPublic32W8S8K8U1',
              'DirectDynamic64W8S8K8U1','StaticLogic64W8S8K8U1','ArtifactPublic64W8S8K8U1',
              'DirectDynamic64W1S1K8U0','StaticLogic64W1S1K8U0','ArtifactPublic64W1S1K8U0'}
    require(len(rows)==9 and {r['filter'] for r in rows}==expected,'Wrong accounting registry')
    for r in rows:
        require(None not in r and None not in r.values(),'Malformed accounting CSV')
        require(r['owned_heap_released']=='true','Owned allocation leaked')
        for name,value in r.items():
            if name not in ('filter','owned_heap_released'):require(int(value)>=0,'Negative allocation count')
        require(int(r['backing_bitmap_bytes'])==int(r['bitmap_heap_live_bytes'])==4096,'Wrong bitmap backing account')
        require(int(r['logical_bitmap_bytes'])<=4096,'Wrong logical payload')
        require(int(r['position_scratch_bytes'])==4096*4,'Wrong compact physical capacity')
        require(int(r['api_requested_total_bytes'])==0,'Hidden query/build API scratch')
        require((int(r['control_heap_live_bytes'])>0)==(not r['filter'].startswith('StaticLogic')),'Wrong control-heap classification')
    return rows

def main():
    require(__debug__,'Python -O is not supported')
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--cpu',type=int,required=True);p.add_argument('--lease',required=True)
    p.add_argument('--output-dir',type=Path,required=True);p.add_argument('--build-root',type=Path,required=True)
    p.add_argument('--compiler',default='clang++');p.add_argument('--backends',nargs='+',choices=['native','avx2','scalar'],default=['native'])
    p.add_argument('--with-sanitizers',action='store_true')
    p.add_argument('--sanitizers-only',action='store_true')
    a=p.parse_args();lock=lease(a.cpu,a.lease)
    require(not(a.with_sanitizers and a.sanitizers_only),'Choose one sanitizer mode')
    require(len(a.backends)==len(set(a.backends)),'Duplicate backend')
    pinned=verify();initial_tuner=tuner_file()
    a.output_dir.mkdir(parents=True,exist_ok=False)
    sources={str(f.relative_to(ROOT)):sha(f) for f in HERE.iterdir() if f.is_file() and (f.suffix in ('.py','.cpp','.hpp','.md','.txt','.json') or f.name=='.gitignore')}
    # Native controls are included by the public adapter; anchor their complete
    # repository header set without changing any shared production file.
    sources.update({str(f.relative_to(ROOT)):sha(f) for f in (ROOT/'include').rglob('*') if f.is_file() and f.suffix in ('.h','.hpp','.inc')})
    for name in sources:
        destination=a.output_dir/'source-snapshot'/name
        destination.parent.mkdir(parents=True,exist_ok=True)
        destination.write_bytes((ROOT/name).read_bytes())
    metadata=dict(scope='Correctness/accounting only; no calibration or throughput',lease=lock,pins=pinned,
                  tuner_file_before=initial_tuner,source_sha256=sources,commands=[],binary_sha256={},complete=False)
    def save():
        (a.output_dir/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    def run(name,command):
        start=time.monotonic();proc=subprocess.run([str(x) for x in command],cwd=ROOT,text=True,capture_output=True)
        (a.output_dir/(name+'.stdout')).write_text(proc.stdout);(a.output_dir/(name+'.stderr')).write_text(proc.stderr)
        metadata['commands'].append(dict(name=name,command=[str(x) for x in command],returncode=proc.returncode,elapsed_seconds=time.monotonic()-start));save()
        require(proc.returncode==0,name+' failed; logs retained')
        return proc.stdout
    save();reference=None
    run("compiler",[a.compiler,"--version"])
    for backend in a.backends:
        for sanitized in ([True] if a.sanitizers_only else [False,True] if a.with_sanitizers else [False]):
            tag=backend+('-asan' if sanitized else '')
            build=a.build_root/tag
            run(tag+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_CXX_COMPILER='+a.compiler,
                                 '-DVLDB_BACKEND='+backend,'-DVLDB_SANITIZERS='+('ON' if sanitized else 'OFF')])
            run(tag+'-build',['cmake','--build',build,'-j1'])
            from capture_headers import capture
            header_provenance=capture(build)
            (a.output_dir/(tag+'-consumed-headers.json')).write_text(json.dumps(header_provenance,indent=2)+'\n')
            for binary_name in ['vldb_public_check']+([] if sanitized else ['vldb_accounting_check']):
                binary=build/binary_name
                metadata['binary_sha256'][str(binary.resolve())]=sha(binary)
                destination=a.output_dir/'binaries'/tag/binary_name
                destination.parent.mkdir(parents=True,exist_ok=True);destination.write_bytes(binary.read_bytes());destination.chmod(binary.stat().st_mode)
            save()
            output={}
            for case in ['sector32-u1','sector64-u1','register64-u0','sector32-u2','sector32-u4','sector64-u2','sector64-u4','native']:
                output[case]=run(tag+'-check-'+case,[build/'vldb_public_check',case])
                require(tuner_file()==initial_tuner,'Original tuner file changed')
            if reference is None:reference=output
            require(output==reference,'Full-output digest changed between backends')
            if not sanitized:
                rows=[]
                for case in ['sector32-u1','sector64-u1','register64-u0']:
                    parsed=list(csv.DictReader(io.StringIO(run(tag+'-accounting-'+case,[build/'vldb_accounting_check',case]))))
                    require(len(parsed)==3,'Wrong per-process accounting row count')
                    rows.extend(parsed)
                    require(tuner_file()==initial_tuner,'Original tuner file changed')
                rows=accounting(rows)
                (a.output_dir/(tag+'-accounting.json')).write_text(json.dumps(rows,indent=2)+'\n')
            database=json.loads((build/'compile_commands.json').read_text())
            (a.output_dir/(tag+'-compile_commands.json')).write_text(json.dumps(database,indent=2)+'\n')
            entry=next(r for r in database if Path(r['file']).name=='check.cpp')
            command=entry.get('arguments') or shlex.split(entry['command'])
            stripped=[];i=0
            while i<len(command):
                arg=command[i]
                if arg in ('-o','-c'):
                    i+=2 if arg=='-o' else 1;continue
                if arg!=entry['file']:stripped.append(arg)
                i+=1
            run(tag+'-macros',stripped+['-dM','-E','-x','c++','/dev/null'])
            require(tuner_file()==initial_tuner,'Original tuner file changed')
            verify()
            for name,digest in sources.items():require(sha(ROOT/name)==digest,'Source drift: '+name)
    metadata.update(complete=True,checksum_output=reference,tuner_file_after=tuner_file(),all_sources_unchanged=True)
    save();print('Public API correctness/accounting complete; no performance or FPR ranking')

if __name__=='__main__':main()
