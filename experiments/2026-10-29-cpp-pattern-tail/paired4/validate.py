#!/usr/bin/env python3
"""Build and validate the isolated policy; run this entire script under flock."""
import hashlib,json,subprocess,time
from pathlib import Path
HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
BUILD=REPO/'build/cpp-pattern-tail-paired4'
INCLUDE=str(HERE/'snapshot/include')
CHECK=str(HERE/'check.cpp')
commands=[
 ('configure',['taskset','-c','3','cmake','-S',str(HERE),'-B',str(BUILD),'-DCMAKE_CXX_COMPILER=clang++']),
 ('build',['taskset','-c','3','cmake','--build',str(BUILD),'--parallel','1']),
 ('ctest',['taskset','-c','3','ctest','--test-dir',str(BUILD),'--output-on-failure']),
 ('minimal-build',['taskset','-c','3','clang++','-std=c++17','-O3','-mavx2','-mavx512f','-mno-avx512vl','-mno-avx512bw','-mno-avx512dq','-I',INCLUDE,CHECK,'-o',str(BUILD/'check_minimal')]),
 ('minimal-check',['taskset','-c','3',str(BUILD/'check_minimal')]),
 ('asan-build',['taskset','-c','3','clang++','-std=c++17','-O1','-g','-march=native','-fsanitize=address,undefined','-fno-omit-frame-pointer','-I',INCLUDE,CHECK,'-o',str(BUILD/'check_asan')]),
 ('asan-check',['taskset','-c','3',str(BUILD/'check_asan')]),
]
logdir=HERE/'validation';logdir.mkdir(exist_ok=False)
records=[]
for name,command in commands:
 start=time.monotonic()
 result=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,cwd=REPO)
 (logdir/(name+'.log')).write_text(result.stdout)
 records.append({'name':name,'command':command,'returncode':result.returncode,'seconds':time.monotonic()-start})
 print(name,result.returncode,round(records[-1]['seconds'],2),flush=True)
 if result.returncode: print(result.stdout);raise SystemExit(result.returncode)
expected='14935109807921651589'
for name in ['minimal-check','asan-check']:
 assert expected in (logdir/(name+'.log')).read_text()
assert (BUILD/'Testing/Temporary/LastTest.log').read_text().count(expected)==2
sources=[f for f in HERE.rglob('*') if f.is_file() and '__pycache__' not in str(f) and not f.is_relative_to(logdir)]
x={'commands':records,'source_sha256':{str(f.relative_to(HERE)):hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted(sources)},'checksum':expected,'binaries':{str(f.relative_to(REPO)):hashlib.sha256(f.read_bytes()).hexdigest() for f in [BUILD/'compare_benchmark',BUILD/'check',BUILD/'check_scalar',BUILD/'check_minimal',BUILD/'check_asan']}}
(logdir/'validation.json').write_text(json.dumps(x,indent=2)+'\n')
