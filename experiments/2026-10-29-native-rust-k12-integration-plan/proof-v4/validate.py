#!/usr/bin/env python3
"""No-build resume: pending ASan runtime and exact normal address-span capture."""
if not __debug__:raise RuntimeError('Python -O forbidden')
import argparse,json,os,re,shutil,subprocess,sys,traceback
from pathlib import Path
from bindings import *
from checks import CPUS,fixture,topology
from source_guard import require_lease
from audit_reuse import audit
REJECT=['RUSTFLAGS','RUSTDOCFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CARGO_TARGET_DIR','RUSTC','RUSTDOC','RUSTUP_TOOLCHAIN','CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER','LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','MALLOC_ARENA_MAX','ASAN_OPTIONS','UBSAN_OPTIONS','GLIBC_TUNABLES']
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);args=parser.parse_args()
 lease=require_lease(3);prepared=verify(args.source_commit);topology();need(not any(os.environ.get(k)for k in REJECT),'Unfrozen runtime overrides')
 reused=audit();need(reused==json.loads((HERE/'REUSE_CLOSURE.json').read_text()),'Retained closures changed')
 output=HERE/'validation-v1';need(not output.exists()and not output.is_symlink(),'Preserve prior attempt');output.mkdir()
 meta=dict(complete=False,source_commit=args.source_commit,native_commit=NATIVE,native_base=BASE,reference_commit=REFERENCE,lease=lease,compile_affinity=None,parent_affinity=sorted(os.sched_getaffinity(0)),execution_cpus=CPUS,physical_topology=topology(),prepared_sha256=sha(HERE/'PREPARATION.json'),prior_attempt=dict(source_commit=reused['source_commit'],archive_commit=reused['archive_commit'],original_complete=False),reused_closure_sha256=sha(HERE/'REUSE_CLOSURE.json'),commands=[],binaries={p:d for m in reused['modes'].values()for p,d in m['binaries'].items()},compiler_inputs={k:v['inputs_sha256']for k,v in reused['modes'].items()},mode_binaries={k:dict(test=v['test'],caller=v['caller'])for k,v in reused['modes'].items()},fixtures=dict(reused['prior_fixtures']),new_compiler_executions=0,timing=False,new_calibration_samples=0)
 def persist():save(output/'metadata.json',meta)
 def run(label,command,env=None):
  need(require_lease(3)==lease,'Parent lease drift')
  environment=os.environ.copy();environment.update(CARGO_BUILD_JOBS='1',RUST_TEST_THREADS='1',RUSTFLAGS='',RUSTDOCFLAGS='',ASAN_OPTIONS='detect_leaks=1:halt_on_error=1');environment.update(env or {})
  row=dict(label=label,command=list(map(str,command)),explicit_environment=env or {},complete=False);meta['commands'].append(row);persist()
  result=subprocess.run(row['command'],cwd=ROOT,env=environment,pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
  for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
   path=output/(label+'.'+stream);path.write_bytes(data);row[stream]=path.name;row[stream+'_sha256']=sha(path)
  row['returncode']=result.returncode;persist();print(label,result.returncode,flush=True);need(result.returncode==0,'Failed '+label+'; attempt preserved')
  row['complete']=True;persist();return result.stdout.decode()
 def execute(label,binary,extra,env):
  text=run(label,['taskset','-c',','.join(map(str,CPUS)),sys.executable,HERE/'exec_affinity.py',binary,*extra],env)
  identity=json.loads((output/(label+'.stderr')).read_text().splitlines()[0]);need(identity==dict(pre_exec_affinity=CPUS,executable=str(binary)),'Missing actual expanded execution mask');return text
 persist()
 try:
  run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_*.py'])
  for mode,value in reused['modes'].items():save(output/(mode+'-compiler-closure.json'),value)
  mode=reused['modes']['asan'];env=mode['explicit_environment']
  text=execute('asan-native-tests',Path(mode['test']),['four_sector_range12::tests::','--test-threads=1'],env)
  need('test result: ok. 6 passed; 0 failed;'in text and len(re.findall(r'^test four_sector_range12::tests::.* \.\.\. ok$',text,re.M))==6,'Incomplete ASan tests')
  data=fixture(execute('asan-public-parity',Path(mode['caller']),[],env),'avx512');meta['fixtures']['asan']=data;persist()
  need(len({v['checksum']for v in meta['fixtures'].values()})==1,'Cross-profile complete-output digest differs')
  binary=Path(meta['mode_binaries']['normal']['caller']);nm=Path(shutil.which('nm')or'/missing').absolute();objdump=Path(shutil.which('objdump')or'/missing').absolute()
  need(nm.is_file()and objdump.is_file(),'Symbol/disassembly tools missing')
  raw=run('normal-nm',[nm,'--defined-only',binary]);demangled=run('normal-nm-demangled',[nm,'--defined-only','--demangle',binary]);symbols=[]
  for line in raw.splitlines():
   parts=line.split(None,2)
   if len(parts)==3 and re.fullmatch('[0-9a-fA-F]+',parts[0]):symbols.append((int(parts[0],16),parts[1],parts[2]))
  selected=[];seen=set();required={'native_visible_pure','native_visible_fused','native_public_batch'}
  for line in demangled.splitlines():
   parts=line.split(None,2)
   if len(parts)!=3:continue
   begin=int(parts[0],16);name=parts[2]
   if name not in required and not('fastest_bloom_filter' in name and'FourSectorRange12BloomFilter'in name and any(x in name for x in ['lookup','contains','probe'])):continue
   if begin in seen:continue
   seen.add(begin);end=min(a for a,k,n in symbols if a>begin);label='normal-asm-'+str(len(selected))
   text=run(label,[objdump,'-d','--demangle','--no-show-raw-insn','--start-address='+hex(begin),'--stop-address='+hex(end),binary]);instructions=re.findall(r'^\s*([0-9a-f]+):\s+(\S+)',text,re.M)
   need(instructions and int(instructions[0][0],16)==begin and all(begin<=int(a,16)<end for a,m in instructions)and name in text,'Empty/wrong bounded assembly')
   selected.append(dict(name=name,begin=begin,end=end,instructions=len(instructions),file=label+'.stdout'))
  need(required<={x['name']for x in selected},'Missing actual public caller spans')
  meta['assembly']=dict(binary=str(binary),sha256=sha(binary),tools={str(nm):sha(nm),str(objdump):sha(objdump)},selected=selected,scope='Actual native caller capture; no inline/performance conclusion before text review')
  verify(args.source_commit);need(require_lease(3)==lease,'Final lease drift');need(audit()==reused,'Preserved artifacts changed')
  for p,d in meta['binaries'].items():need(sha(p)==d,'Executable changed')
  for group in meta['compiler_inputs'].values():
   for p,d in group.items():need(sha(p)==d,'Consumed source changed')
  meta.update(complete=True,profiles=3,native_test_runs=3,k12_test_executions=18,total_native_test_executions=52,parity_cases=36,throughput_workloads=0,new_native_test_runs=1,new_parity_cases=12);persist()
 except BaseException as error:
  meta['error']=repr(error);meta['traceback']=traceback.format_exc();persist();raise
if __name__=='__main__':main()
