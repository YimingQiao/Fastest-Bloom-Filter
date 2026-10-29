#!/usr/bin/env python3
"""Finite K12 Rust correctness/byte-parity proof; source commit and lease required."""
if not __debug__:raise RuntimeError('Use Python without -O')
import argparse,json,os,platform,re,shutil,subprocess,sys,time
from pathlib import Path
from checks import need,sha,save,artifact,fixture,dependencies,CPUS,topology,execution_stderr,check_environment
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1]
OLD=ROOT/'experiments/2026-10-29-four-sector-range12-screen'
sys.path.insert(0,str(OLD/'preflight'))
from lease import require_lease
PROOF='e150be33b95a22dca9b75175e6174b9555c82393'
BUILD=Path('/tmp/fastest-bf-k12-rust-port-v1-cpu3')
TRIPLE='x86_64-unknown-linux-gnu'

def blob(path,commit):return subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
def verify(commit):
    need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full source commit required');pins={}
    for folder in(STAGE,HERE):
        descriptor=folder/'PREPARATION.json';need(descriptor.read_bytes()==blob(descriptor,commit),'Uncommitted descriptor')
        for name,item in json.loads(descriptor.read_text())['files'].items():
            path=folder/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,commit),'Changed prepared source '+name);pins[str(path.resolve())]=item['sha256']
        pins[str(descriptor.resolve())]=sha(descriptor)
    cpp=OLD/'CALLER_FREEZE.json';need(cpp.read_bytes()==blob(cpp,PROOF),'Changed prior compiled dependency closure');old=json.loads(cpp.read_text())
    for name,digest in old['consumed_inputs_sha256'].items():need(sha(Path(name))==digest,'Changed frozen C++ input '+name)
    pins.update(old['consumed_inputs_sha256'])
    return pins

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True);args=p.parse_args();lease=require_lease(3);pins=verify(args.source_commit)
    ambient=check_environment(os.environ);worker_topology=topology()
    need(not BUILD.exists()and not BUILD.is_symlink(),'Fresh target required, including dangling symlink');out=STAGE/'validation-v1';need(not out.exists()and not out.is_symlink(),'Preserve prior attempts');BUILD.mkdir();out.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,host=platform.uname()._asdict(),lease=lease,affinity=sorted(os.sched_getaffinity(0)),commands=[],ambient_environment=ambient,worker_topology=worker_topology,execution_affinity=CPUS,source_sha256=pins,binaries={},consumed_inputs={},performance_runs=0)
    save(out/'metadata.json',meta)
    def run(label,cmd,env=None,binary_output=False,execute=False):
        need(require_lease(3)==lease,'Lease drift');environment=os.environ.copy();environment.update(CARGO_BUILD_JOBS='1',RUST_TEST_THREADS='1',RUSTFLAGS='',RUSTDOCFLAGS='');environment.update(env or {})
        original=[str(x)for x in cmd]
        actual=['taskset','-c',','.join(map(str,CPUS)),sys.executable,str(HERE/'exec_affinity.py'),*original]if execute else original
        record=dict(label=label,command=actual,program=original,executes_filter=execute,environment={k:environment.get(k)for k in('RUSTFLAGS','RUSTDOCFLAGS','ASAN_OPTIONS','CARGO_TARGET_DIR','RUST_TEST_THREADS','CARGO_BUILD_JOBS')},complete=False);meta['commands'].append(record);save(out/'metadata.json',meta)
        start=time.monotonic();r=subprocess.run(record['command'],cwd=ROOT,env=environment,capture_output=True);record.update(returncode=r.returncode,diagnostic_seconds=time.monotonic()-start,stdout_sha256=__import__('hashlib').sha256(r.stdout).hexdigest(),stdout_bytes=len(r.stdout),stderr_sha256=__import__('hashlib').sha256(r.stderr).hexdigest())
        (out/(label+'.stderr')).write_bytes(r.stderr)
        if binary_output:save(out/(label+'.stdout-summary.json'),dict(bytes=len(r.stdout),sha256=record['stdout_sha256'],raw_payload_retained=False))
        else:(out/(label+'.stdout')).write_bytes(r.stdout)
        save(out/'metadata.json',meta);need(r.returncode==0,'Failed '+label+'; retained attempt')
        if execute:record['actual_execution'],r.stderr=execution_stderr(r.stderr,original[0])
        record['complete']=True;save(out/'metadata.json',meta);print(label+' passed',flush=True);return r
    try:
        run('derive',[sys.executable,STAGE/'derive.py'])
        run('guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_checks.py'])
        meta['tools']={}
        for label,args2 in [('rustc',[]),('cargo',[]),('rustc-nightly',['--toolchain','nightly']),('cargo-nightly',['--toolchain','nightly'])]:
            name=label.split('-')[0];found=run('which-'+label,['rustup','which',*args2,name]);path=Path(found.stdout.decode().strip());need(path.is_absolute()and path.is_file(),'Actual toolchain path');meta['tools'][str(path)]=sha(path)
        for label,cmd in [('rustc',['rustc','-Vv']),('nightly-rustc',['rustc','+nightly','-Vv']),('cargo',['cargo','-V'])]:run(label,cmd)
        compiler=Path(shutil.which('clang++')).absolute();meta['compiler']=dict(path=str(compiler),sha256=sha(compiler));meta['tools'][str(compiler)]=sha(compiler);run('clang-version',[compiler,'--version'])
        cpp=BUILD/'cpp-fixture';dep=BUILD/'cpp-fixture.d';run('cpp-build',[compiler,'-std=c++17','-O3','-march=native','-MD','-MF',dep,'-I',ROOT/'include',STAGE/'cpp_fixture.cpp','-o',cpp]);meta['binaries'][str(cpp)]=sha(cpp)
        cppdeps=dependencies(dep,ROOT)
        need(str((OLD/'four_sector_range12.h').resolve())in cppdeps,'Wrong actual C++ K12 header')
        for name,digest in cppdeps.items():need(pins.get(name)==digest,'Unpinned actual C++ input '+name)
        meta['consumed_inputs']['cpp']=cppdeps;save(out/'metadata.json',meta)
        modes={}
        for mode in('normal','disable','asan'):
            target=BUILD/mode;need(not target.exists()and not target.is_symlink(),'Fresh Rust target required');cargo=['cargo']+(['+nightly']if mode=='asan'else[])
            flags='-C target-cpu=x86-64'+(' -Zsanitizer=address'if mode=='asan'else'');env=dict(CARGO_TARGET_DIR=str(target),RUSTFLAGS=flags)
            if mode=='asan':env['ASAN_OPTIONS']='detect_leaks=1:halt_on_error=1'
            common=['--release','--locked','--offline','--target',TRIPLE,'--manifest-path',STAGE/'native/Cargo.toml','--message-format=json']+(['--features','disable-avx512']if mode=='disable'else[])
            tests=run(mode+'-tests-no-run',cargo+['test',*common,'--lib','--no-run'],env);text=tests.stdout.decode();testbin,crate=artifact(text,target,'four_sector_range12_isolated',True,STAGE/'native/Cargo.toml');meta['binaries'][str(testbin)]=sha(testbin)
            built=run(mode+'-build',cargo+['build',*common,'--bin','fixture'],env);binary,fixture_crate=artifact(built.stdout.decode(),target,'fixture',False,STAGE/'native/Cargo.toml');need(fixture_crate==crate,'Different test/fixture crate roots');meta['binaries'][str(binary)]=sha(binary)
            rustdeps={};depfiles=sorted(target.rglob('*.d'));need(depfiles,'Missing actual Rust depfiles')
            for path in depfiles:rustdeps.update(dependencies(path,crate))
            for name,digest in rustdeps.items():need(Path(name).is_relative_to(crate)and pins.get(name)==digest,'Unpinned/noncrate actual Rust input '+name)
            for name in('four_sector_range12.rs','layout_parallel.rs','parallel.rs','tests.rs','bin/fixture.rs'):need(str((STAGE/'native/src'/name).resolve())in rustdeps,'Missing representative consumed Rust module '+name)
            meta['consumed_inputs'][mode]=rustdeps;save(out/'metadata.json',meta)
            modes[mode]=dict(binary=binary,testbin=testbin,env=env,crate=str(crate),structured_package='path+'+crate.as_uri()+'#four-sector-range12-isolated@0.0.0')
        need(verify(args.source_commit)==pins,'Compiled closure changed before any BF')
        reference={};checks=[]
        for lines in(3,17,32769):
            for hot in(0,1):
                label=f'cpp-L{lines}-hot{hot}';r=run(label,[cpp,str(lines*64),str(hot)],binary_output=True,execute=True);info=fixture(r.stdout,r.stderr,lines,None,'avx512');reference[(lines,hot)]=r.stdout;checks.append(dict(label=label,**info))
        for mode,compiled in modes.items():
            binary=compiled['binary'];env=compiled['env']
            tests=run(mode+'-tests',[compiled['testbin'],'--test-threads=1'],env,execute=True);need(re.search(r'test result: ok\. 5 passed; 0 failed;',tests.stdout.decode())is not None,'Incomplete five focused tests')
            for lines in(3,17,32769):
                for hot in(0,1):
                    for workers in(3,7):
                        label=f'{mode}-L{lines}-hot{hot}-T{workers}';r=run(label,[binary,str(lines*64),str(workers),str(hot)],env,binary_output=True,execute=True)
                        expected=reference[(lines,hot)]
                        if r.stdout!=expected:
                            actual_path=BUILD/(label+'.actual.bin');reference_path=BUILD/(label+'.reference.bin');actual_path.write_bytes(r.stdout);reference_path.write_bytes(expected)
                            first=next((i for i,(a,b)in enumerate(zip(r.stdout,expected))if a!=b),min(len(r.stdout),len(expected)))
                            mismatch=dict(label=label,first_different_byte=first,actual_bytes=len(r.stdout),reference_bytes=len(expected),actual_path=str(actual_path),reference_path=str(reference_path),actual_sha256=sha(actual_path),reference_sha256=sha(reference_path),actual_byte=r.stdout[first]if first<len(r.stdout)else None,reference_byte=expected[first]if first<len(expected)else None)
                            save(out/'byte-mismatch.json',mismatch);meta['byte_mismatch']=mismatch;need(False,'Complete CPP/Rust byte mismatch; both local payloads preserved')
                        info=fixture(r.stdout,r.stderr,lines,workers,'avx2'if mode=='disable'else'avx512');checks.append(dict(label=label,complete_byte_equality=True,cpp_reference=f'cpp-L{lines}-hot{hot}',**info))
        need(len(checks)==42 and sum(x.get('complete_byte_equality',False)for x in checks)==36,'Wrong six reference/36 equality coverage');save(out/'fixture-checks.json',checks)
        need(verify(args.source_commit)==pins and require_lease(3)==lease,'Final source/lease drift')
        for name,digest in meta['tools'].items():need(sha(Path(name))==digest,'Toolchain drift')
        for name,digest in meta['binaries'].items():need(sha(Path(name))==digest,'Binary drift')
        for group in meta['consumed_inputs'].values():
            for name,digest in group.items():need(sha(Path(name))==digest,'Actual compiler input drift')
        meta.update(complete=True,rust_tests=15,cpp_reference_streams=6,full_cross_language_comparisons=36,final_inputs_equal=True);save(out/'metadata.json',meta);save(out/'ARCHIVE.json',dict(files={p.name:dict(sha256=sha(p),bytes=p.stat().st_size)for p in sorted(out.iterdir())if p.is_file()}));print('PASS15 focused tests +36 full byte comparisons; no timing',flush=True)
    except BaseException as e:meta.update(complete=False,failure=repr(e));save(out/'metadata.json',meta);raise
if __name__=='__main__':main()
