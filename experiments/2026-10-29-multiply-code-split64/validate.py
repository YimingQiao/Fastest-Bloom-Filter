#!/usr/bin/env python3
"""Six backend/sanitizer correctness builds only, after a separate explicit lease."""
import argparse,hashlib,json,os,shutil,subprocess,sys,time
from pathlib import Path
from lease import require_lease
from verify_source import verify
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
BUILD=Path('/tmp/fastest-bf-multiply-code-split64')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    if not __debug__:raise ValueError('Run without Python -O')
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--cpu',type=int,choices=(2,3),required=True);ap.add_argument('--output',type=Path,default=HERE/'validation');a=ap.parse_args()
    lease=require_lease(a.cpu);verify();a.output.mkdir(exist_ok=False)
    paths=[HERE/'CMakeLists.txt',HERE/'provenance.json',HERE/'mask-changes.json',*sorted((HERE/'cpp').glob('*'))]
    inputs={str(p.relative_to(ROOT)):sha(p) for p in paths};records=[];binaries={};reference=None
    def run(name,command):
        start=time.monotonic()
        with (a.output/(name+'.stdout.log')).open('wb') as out,(a.output/(name+'.stderr.log')).open('wb') as err:r=subprocess.run([str(x) for x in command],cwd=ROOT,stdout=out,stderr=err)
        records.append(dict(name=name,command=[str(x) for x in command],returncode=r.returncode,diagnostic_wall_seconds=time.monotonic()-start));(a.output/'commands.json').write_text(json.dumps(records,indent=2)+'\n')
        print(name,r.returncode,flush=True)
        if r.returncode:raise RuntimeError(name+' failed; preserve this attempt')
    for mode in ('native','avx2','scalar'):
        for sanitize in (False,True):
            tag=mode+('-asan' if sanitize else '');build=BUILD/tag
            run(tag+'-configure',['cmake','-S',HERE,'-B',build,'-DCMAKE_CXX_COMPILER=clang++','-DMULTIPLY_ISA='+mode,'-DMULTIPLY_SANITIZERS='+('ON' if sanitize else 'OFF')])
            run(tag+'-build',['cmake','--build',build,'-j1']);run(tag+'-check',[build/'check'])
            output=(a.output/(tag+'-check.stdout.log')).read_bytes()
            if reference is None:reference=output
            if output!=reference:raise ValueError('Cross-backend full bitmap digest differs')
            for name in ('check','calibrate'):binaries[str(build/name)]=sha(build/name)
            shutil.copy2(build/'compile_commands.json',a.output/(tag+'-compile_commands.json'))
    run('quality-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_quality_guard.py']);run('native-assembly',['objdump','-Cd',BUILD/'native/calibrate']);run('compiler',['clang++','--version'])
    verify()
    for name,want in inputs.items():
        if sha(ROOT/name)!=want:raise ValueError('Compiled source changed: '+name)
    (a.output/'summary.json').write_text(json.dumps(dict(scope='Correctness and ASM only; no calibration or speed run',inputs_sha256=inputs,binary_sha256=binaries,checksum_output=reference.decode(),lease=lease,complete=True),indent=2)+'\n')
if __name__=='__main__':main()
