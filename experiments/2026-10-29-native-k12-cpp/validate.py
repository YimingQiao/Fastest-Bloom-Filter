#!/usr/bin/env python3
"""Bounded C++ optional K12 integration checks; no performance measurements."""
import argparse,hashlib,json,os,re,shlex,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
WORKTREE=Path('/home/yiming/projects/fastest-bf-k12-integration')
CPUS=[2,4,6,8,10,12,14]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,obj):p.write_text(json.dumps(obj,indent=2)+'\n')
def need(ok,msg):
    if not ok:raise RuntimeError(msg)
def git(root,*args):return subprocess.check_output(['git',*args],cwd=root)
def verify(commit,root,files):
    need(re.fullmatch('[0-9a-f]{40}',commit)!=None,'full commit required')
    for name,digest in files.items():
        need(sha(root/name)==digest,'live source drift: '+name)
        need(hashlib.sha256(git(root,'show',commit+':'+name)).hexdigest()==digest,'committed source drift: '+name)
def main():
    p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);p.add_argument('--native-commit',required=True)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--build',type=Path,required=True);a=p.parse_args()
    need(not a.output.exists() and not a.build.exists(),'fresh output/build required')
    need(os.sched_getaffinity(0)=={2},'parent compiler CPU2 affinity required')
    locks=[]
    for fd in Path('/proc/self/fd').iterdir():
        try:
            if fd.resolve()==Path('/tmp/fastest-bf-socket0.lock'):
                info=Path('/proc/self/fdinfo',fd.name).read_text()
                if 'FLOCK  ADVISORY  WRITE' in info:locks.append(dict(fd=fd.name,info=info))
        except (FileNotFoundError,OSError):pass
    need(bool(locks),'inherited socket0 exclusive flock required')
    prep=json.loads((HERE/'SOURCE_PREPARATION.json').read_text())
    verify(a.native_commit,WORKTREE,prep['files'])
    local=json.loads((HERE/'PREPARATION.json').read_text());verify(a.source_commit,ROOT,local['files'])
    topology=[]
    for cpu in CPUS:
        top=Path('/sys/devices/system/cpu')/('cpu'+str(cpu))/'topology'
        topology.append(dict(cpu=cpu,socket=int((top/'physical_package_id').read_text()),core=int((top/'core_id').read_text())))
    need(all(x['socket']==0 for x in topology) and len({x['core'] for x in topology})==7,'seven socket0 physical cores required')
    a.output.mkdir(parents=True);a.build.mkdir(parents=True)
    meta=dict(complete=False,source_commit=a.source_commit,native_commit=a.native_commit,affinity=sorted(os.sched_getaffinity(0)),execution_cpus=CPUS,topology=topology,locks=locks,commands=[],binaries={},scope='correctness only; execution may migrate among seven allowed physical cores')
    write(a.output/'metadata.json',meta)
    def run(argv,name,expected=0,env=None):
        argv=list(map(str,argv));r=subprocess.run(argv,cwd=WORKTREE,stdout=subprocess.PIPE,stderr=subprocess.PIPE,env=env)
        (a.output/(name+'.stdout')).write_bytes(r.stdout);(a.output/(name+'.stderr')).write_bytes(r.stderr)
        meta['commands'].append(dict(argv=argv,cwd=str(WORKTREE),returncode=r.returncode,expected=expected,stdout=name+'.stdout',stderr=name+'.stderr',environment_overrides={k:v for k,v in (env or {}).items() if k in ('ASAN_OPTIONS','UBSAN_OPTIONS')}));write(a.output/'metadata.json',meta)
        need(r.returncode==expected if expected>=0 else r.returncode!=0,'unexpected exit: '+name)
        return r
    compiler='/usr/bin/g++'
    run([compiler,'--version'],'compiler');run(['uname','-a'],'uname');run(['lscpu','-J'],'lscpu')
    for profile,extra,targets in [('native',['-DBF_NATIVE=ON'],['test_four_sector_range12','test_four_sector_range12_portable']),('avx2',['-DBF_NATIVE=OFF','-DUSE_AVX2=ON'],['test_four_sector_range12']),('asan',['-DBF_NATIVE=ON','-DBF_SANITIZERS=ON'],['test_four_sector_range12'])]:
        build=a.build/profile
        run(['cmake','-S',WORKTREE,'-B',build,'-DCMAKE_CXX_COMPILER='+compiler,'-DCMAKE_BUILD_TYPE=Release','-DBUILD_TESTING=ON',*extra],profile+'-configure')
        run(['cmake','--build',build,'--parallel','1','--target',*targets],profile+'-build')
        for target in targets:
            kind='portable' if target.endswith('_portable') else profile
            flags=[] if kind=='portable' else ['-mavx2'] if kind=='avx2' else ['-march=native']
            macros=run([compiler,'-dM','-E','-x','c++',*flags,'/dev/null'],kind+'-macros').stdout.decode()
            need(('#define __AVX2__ 1' in macros)==(kind!='portable'),'AVX2 backend mismatch')
            need(('#define __AVX512F__ 1' in macros)==(kind in ('native','asan')),'AVX512 backend mismatch')
            binary=build/target;meta['binaries'][kind]=dict(path=str(binary),sha256=sha(binary))
            env=os.environ.copy()
            if profile=='asan':env.update(ASAN_OPTIONS='detect_leaks=1:abort_on_error=1',UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
            run(['taskset','-c',','.join(map(str,CPUS)),binary],kind+'-check',env=env)
    rejected=run([compiler,'-std=c++17','-fsyntax-only','-I',WORKTREE/'include',HERE/'unsafe_generic.cpp'],'unsafe-generic-rejected',expected=-1)
    need(b'private' in rejected.stderr and b'CacheLineCount' in rejected.stderr,'expected access-control diagnostic absent')
    inputs={};captures=[]
    for path in sorted(a.build.rglob('*')):
        if path.is_file() and (path.name=='compile_commands.json' or path.name=='CMakeCache.txt' or path.name=='flags.make' or path.name=='link.txt' or path.name.endswith('.d')):
            rel=path.relative_to(a.build);dest=a.output/'build-records'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(path.read_bytes());captures.append(str(rel))
            if path.name.endswith('.d'):
                text=path.read_text().replace('\\\n',' ');tokens=shlex.split(text.split(':',1)[1])
                for token in tokens:
                    src=Path(token);src=src if src.is_absolute() else WORKTREE/src
                    need(src.is_file(),'dependency missing: '+str(src));inputs[str(src.resolve())]=sha(src)
    inputs[str(Path(compiler).resolve())]=sha(Path(compiler).resolve())
    write(a.output/'compiler-inputs.json',inputs);meta['captured_build_records']=captures;meta['compiler_inputs']=len(inputs)
    verify(a.native_commit,WORKTREE,prep['files']);verify(a.source_commit,ROOT,local['files'])
    for info in meta['binaries'].values():need(sha(info['path'])==info['sha256'],'binary drift')
    meta['complete']=True;write(a.output/'metadata.json',meta)
    print('PASS: native, AVX2, portable, ASan/UBSan; seven physical cores; generic misuse rejected',flush=True)
if __name__=='__main__':main()
