#!/usr/bin/env python3
"""Correctness-only Clang preflight; caller owns socket1 and holds its flock."""
import hashlib,json,re,shutil,subprocess,time
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
records=[];builds=[]
for label,options in (('native',[]),('asan',['-DBF_SANITIZERS=ON'])):
    build=ROOT/('build/split64-bitshuffle-ktest-'+label);builds.append(build)
    for step,command in (
        ('configure',['cmake','-S',str(HERE),'-B',str(build),'-DCMAKE_CXX_COMPILER=clang++',*options]),
        ('build',['cmake','--build',str(build),'--parallel','1']),
        ('ctest',['ctest','--test-dir',str(build),'--output-on-failure','-V']),
    ):
        argv=['taskset','-c','3',*command];start=time.monotonic()
        with (HERE/(label+'-'+step+'.log')).open('w') as out:
            result=subprocess.run(argv,cwd=ROOT,stdout=out,stderr=subprocess.STDOUT)
        records.append(dict(label=label,step=step,argv=argv,returncode=result.returncode,seconds=time.monotonic()-start))
        (HERE/'validation.json').write_text(json.dumps(records,indent=2)+'\n')
        print(label,step,result.returncode,flush=True);result.check_returncode()
checksums=[]
for label in ('native','asan'):
    checksums+=re.findall(r'Split64 bitmap/oracle/bit-selection/tail checksum (\d+)',(HERE/(label+'-ctest.log')).read_text())
assert len(checksums)==8 and len(set(checksums))==1,checksums
sources={p for p in HERE.iterdir() if p.suffix in ('.cpp','.h','.hpp','.py') or p.name in ('CMakeLists.txt','source-base.json','feature-boundary.json')}
for build in builds:
    for p in build.rglob('*.o.d'):
        for token in p.read_text().replace('\\\n',' ').split():
            source=Path(token)
            if source.is_absolute() and source.is_file() and source.is_relative_to(ROOT):sources.add(source.resolve())
for p in sorted(sources):
    dest=HERE/'source-snapshot'/p.relative_to(ROOT);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,dest)
binaries=[build/name for build in builds for name in ('compare_benchmark','check','check_scalar','check_avx2','check_bitalg_min')]
freeze=dict(utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),source_sha256={str(p.relative_to(ROOT)):sha(p) for p in sorted(sources)},binary_sha256={str(p.relative_to(ROOT)):sha(p) for p in binaries},oracle_checksum=int(checksums[0]),
    source_revision=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),
    expected_registry=['FastPatternBF','Split64Original','Split64BitShuffleHybrid','Split64BitShuffleNarrow','Split64BitShuffleWide','Split64BitShuffleHybridKtest'],
    scope='Eight oracle modes passed: native/scalar/AVX2/no-VL-no-DQ BITALG, each normal and ASan+UBSan. No benchmark timing workloads run; query-loop assembly still to audit.')
(HERE/'freeze.json').write_text(json.dumps(freeze,indent=2)+'\n')
print('PASS eight oracle modes; checksum',checksums[0],'; sources/binaries frozen before timing',flush=True)
