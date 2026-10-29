#!/usr/bin/env python3
"""Minimal native/ASan actual caller proof; no formal195 performance execution."""
import argparse,json,os,shlex,subprocess,sys
from pathlib import Path
from source_guard import HERE,ROOT,sha,need,verify,lease
from checks import NAMES,SEMANTICS,parse,query_rows,public_row
CPUS=[2,4,6,8,10,12,14,16];TEXT=','.join(map(str,CPUS))
PREFIX=['taskset','-c',TEXT,'numactl','--physcpubind='+TEXT,'--membind=0']
def main():
 need(__debug__,'Python -O unsupported');p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);a=p.parse_args()
 descriptors=lease();pins=verify(a.source_commit)
 output=HERE/'validation-v1';build=ROOT/'build/native-k12-parallel-caller-v1'
 need(not output.exists()and not output.is_symlink()and not build.exists()and not build.is_symlink(),'fresh paths required')
 for name in ['CXXFLAGS','CFLAGS','CPPFLAGS','LDFLAGS','CXX','CC','LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','ASAN_OPTIONS','UBSAN_OPTIONS']:need(not os.environ.get(name),'unfrozen environment '+name)
 output.mkdir();meta={'complete':False,'source_commit':a.source_commit,'lease_fds':descriptors,'compiler_cpu':2,'execution_cpus':CPUS,'numa_node':0,'commands':[],'binaries':{},'compiler_inputs':{},'compiler':{'invocation':'/usr/bin/clang++','resolved_target':str(Path('/usr/bin/clang++').resolve()),'sha256':sha('/usr/bin/clang++')},'formal_performance_run':False,'incidental_timing_claimed':False}
 def save(): (output/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
 def run(name,argv,env=None,success=True):
  need(lease()==descriptors,'lease drift');argv=list(map(str,argv));e=os.environ.copy();e.update(env or {})
  result=subprocess.run(argv,cwd=ROOT,env=e,capture_output=True)
  (output/(name+'.stdout')).write_bytes(result.stdout);(output/(name+'.stderr')).write_bytes(result.stderr)
  meta['commands'].append({'label':name,'argv':argv,'cwd':str(ROOT),'environment_overrides':env or {},'returncode':result.returncode,'expected_success':success});save()
  need((result.returncode==0)==success,'command failed '+name)
  if not success:need(not result.stdout and result.stderr,'invalid CLI did not fail before CSV')
  print(name,'PASS',flush=True);return result.stdout.decode()
 save();reference=None;public_reference={}
 try:
  run('derivation',[sys.executable,HERE/'derive.py'])
  run('offline-contracts',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_*.py'])
  run('compiler',['/usr/bin/clang++','--version']);run('topology',['lscpu','-J'])
  for profile in ['native','asan']:
   directory=build/profile;env={'ASAN_OPTIONS':'detect_leaks=1:halt_on_error=1','UBSAN_OPTIONS':'halt_on_error=1:print_stacktrace=1'}if profile=='asan'else{}
   run(profile+'-configure',['cmake','-S',HERE,'-B',directory,'-DCMAKE_CXX_COMPILER=/usr/bin/clang++','-DCMAKE_BUILD_TYPE=Release','-DBF_NATIVE=ON','-DBF_SANITIZERS='+('ON'if profile=='asan'else'OFF'),'-DBF_PAGE_AES=OFF','-DFETCHCONTENT_FULLY_DISCONNECTED=ON','-DFETCHCONTENT_SOURCE_DIR_FASTFILTER='+str(ROOT/'build/cpp-external/_deps/fastfilter-src'),'-DFETCHCONTENT_SOURCE_DIR_PAGEBLOOM='+str(ROOT/'build/cpp-external/_deps/pagebloom-src')])
   run(profile+'-build',['cmake','--build',directory,'--parallel','1'],env)
   consumed={}
   for dep in sorted(directory.rglob('*.o.d')):
    dest=output/'dependencies'/profile/dep.relative_to(directory);dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(dep.read_bytes())
    for token in shlex.split(dep.read_text().replace('\\\n',' ').split(':',1)[1]):
     path=Path(token);path=(path if path.is_absolute()else directory/path).resolve();need(path.is_file(),'missing compiler input')
     h=sha(path)
     if path.is_relative_to(ROOT):need(str(path)in pins and pins[str(path)]==h,'unprepared repo input '+str(path))
     consumed[str(path)]=h
   need(str(HERE/'query.cpp')in consumed and str(HERE/'public_api.cpp')in consumed,'missing actual caller dependencies')
   meta['compiler_inputs'][profile]=consumed
   for name in ['compile_commands.json','CMakeCache.txt']:(output/(profile+'-'+name)).write_bytes((directory/name).read_bytes())
   for name in ['query','public_api','check_executor','check_phase']:meta['binaries'][profile+'-'+name]={'path':str(directory/name),'sha256':sha(directory/name)}
   save()
   run(profile+'-contracts',PREFIX+['ctest','--test-dir',directory,'--output-on-failure'],env)
   cmd=PREFIX+[directory/'query','15','24','50','15','4096','4','101',','.join(NAMES),'32768','12','8',TEXT]
   parsed=parse(run(profile+'-query',cmd,env));current=query_rows(parsed)
   if reference is not None:
    for name in NAMES:
     for field in SEMANTICS+['calibration_absent_queries','calibration_false_positives']:need(current[name][field]==reference[name][field],'backend semantic disagreement')
   reference=current
   for name in ['Split64BloomFilter','Split64RangeBloomFilter','FourSectorRange12BloomFilter']:
    rows=parse(run(profile+'-public-'+name,PREFIX+[directory/'public_api','15','24','15','2','101',name,TEXT],env));need(len(rows)==1,'wrong public row count');public_row(rows[0],current[name])
    if name in public_reference:
     for field in SEMANTICS+['inserted_hash_checksum','query_hash_checksum','raw_insert_checksum','raw_query_checksum']:need(rows[0][field]==public_reference[name][field],'public backend input/output disagreement')
    public_reference[name]=rows[0]
   for i,selection in enumerate(['FastPatternBF,typo','FastPatternBF,FastPatternBF','FastPatternBF,']):
    bad=list(cmd);bad[-5]=selection;run(profile+'-bad-query-'+str(i),bad,env,False)
   bad=list(cmd);bad[-7]='5';run(profile+'-bad-phase-count',bad,env,False)
   for i,args in enumerate([['15','24','15','2','101','typo',TEXT],['15','24','15','3','101','Split64BloomFilter',TEXT],['15','24','15','2','101','Split64BloomFilter','2,2,4,6,8,10,12,14']]):run(profile+'-bad-public-'+str(i),PREFIX+[directory/'public_api',*args],env,False)
  need(verify(a.source_commit)==pins and lease()==descriptors,'final source/lease drift')
  for b in meta['binaries'].values():need(sha(b['path'])==b['sha256'],'binary drift')
  for inputs in meta['compiler_inputs'].values():
   for name,h in inputs.items():need(sha(name)==h,'consumed input drift')
  meta.update(complete=True,shared_query_rows=30,public_api_rows=6,invalid_cli_cases=14,new_kernel_tests=False);save()
 except BaseException as error:meta['failure']=repr(error);save();raise
if __name__=='__main__':main()
