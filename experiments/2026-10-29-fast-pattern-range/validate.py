#!/usr/bin/env python3
"""Correctness-only backend matrix; run under the root-granted socket0 lease."""
import argparse,hashlib,json,os,re,shlex,subprocess,time
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',default='validation-v1');args=p.parse_args()
assert os.sched_getaffinity(0)=={2},'Pin correctness process to CPU2'
out=HERE/args.output;out.mkdir(exist_ok=False)
initial=json.loads((HERE/'initial-record/PREPARATION.json').read_text())['files_sha256']
for name,digest in initial.items():
 assert sha(HERE/'initial-record'/name)==digest,name
 assert sha(HERE/name)==digest,('initial source changed before first build',name)
source={str((HERE/name).relative_to(ROOT)):digest for name,digest in initial.items()}
(out/'source-before.json').write_text(json.dumps(source,indent=2)+'\n')
commands=[];records=[]
def execute(command,log,env=None):
 commands.append(dict(command=command,cwd=str(ROOT),log=str(log.relative_to(ROOT))))
 (out/'commands.json').write_text(json.dumps(commands,indent=2)+'\n')
 with log.open('w') as stream:subprocess.run(command,cwd=ROOT,env=env,stdout=stream,stderr=subprocess.STDOUT,check=True)
for backend in ('native','avx2','scalar','avx512f-min'):
 for sanitizer in (False,True):
  mode=backend+('-asan' if sanitizer else '')
  build=ROOT/('build/fast-pattern-range-correctness-'+mode)
  execute(['cmake','-S',str(HERE),'-B',str(build),'-DCMAKE_CXX_COMPILER=clang++','-DCMAKE_BUILD_TYPE=Release','-DBF_BACKEND='+backend,'-DBF_SANITIZERS='+('ON' if sanitizer else 'OFF')],out/(mode+'-configure.log'))
  compile_commands=json.loads((build/'compile_commands.json').read_text())
  (out/(mode+'-compile-command.json')).write_text(json.dumps(compile_commands,indent=2)+'\n')
  raw=shlex.split(compile_commands[0]['command']);macro=[];i=0
  while i<len(raw):
   if raw[i] in ('-o','-c','-MF','-MT','-MQ'):i+=2;continue
   macro.append(raw[i]);i+=1
  macro+=['-dM','-E','-x','c++','/dev/null']
  execute(macro,out/(mode+'-macros.log'))
  definitions={line.split()[1] for line in (out/(mode+'-macros.log')).read_text().splitlines() if line.startswith('#define ')}
  features={name:name in definitions for name in ('__AVX2__','__AVX512F__','__AVX512VL__','__AVX512DQ__','__AVX512BW__')}
  if backend=='avx512f-min':assert features=={'__AVX2__':True,'__AVX512F__':True,'__AVX512VL__':False,'__AVX512DQ__':False,'__AVX512BW__':False},features
  if backend=='avx2':assert features['__AVX2__'] and not features['__AVX512F__'],features
  if backend=='scalar':assert not features['__AVX2__'] and not features['__AVX512F__'],features
  execute(['cmake','--build',str(build),'-j1'],out/(mode+'-build.log'))
  env=dict(os.environ);env['ASAN_OPTIONS']='detect_leaks=1'
  execute(['ctest','--test-dir',str(build),'-V','--output-on-failure'],out/(mode+'-test.log'),env)
  text=(out/(mode+'-test.log')).read_text();assert '100% tests passed' in text
  checksum=int(re.search(r'passed checksum=(\d+)',text).group(1))
  records.append(dict(mode=mode,features=features,binary=str((build/'check').relative_to(ROOT)),binary_sha256=sha(build/'check'),checksum=checksum))
  print('Passed',mode,'checksum',checksum,flush=True)
assert len({record['checksum'] for record in records})==1
for name,digest in source.items():assert sha(ROOT/name)==digest,name
result=dict(scope='Correctness only; no calibrated FPR or throughput measurements',source_commit='bcd66d8',
 initial_source_unchanged=True,initial_record='initial-record/',source_sha256=source,backend_results=records,
 all_eight_backends_passed=True,same_full_output_and_bitmap_digest=True,cpu=2,
 utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
(out/'validation.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS all eight native/AVX2/scalar/F-minimum modes and sanitizer counterparts; exact same bitmap/output digest')
