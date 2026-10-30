#!/usr/bin/env python3
"""Actual native packaging correctness/ASM only; no timing or FPR workloads."""
if not __debug__:raise RuntimeError('Python -O forbidden')
import argparse,json,os,re,shutil,subprocess,sys,traceback
from pathlib import Path
from bindings import *
from checks import CPUS,artifact,fixture,topology
from dependencies import collect
from source_guard import require_lease
REJECT=['RUSTFLAGS','RUSTDOCFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CARGO_TARGET_DIR','RUSTC','RUSTDOC','RUSTUP_TOOLCHAIN','CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER','LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','MALLOC_ARENA_MAX','ASAN_OPTIONS','UBSAN_OPTIONS','GLIBC_TUNABLES']
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);args=parser.parse_args()
 lease=require_lease(3);prepared=verify(args.source_commit);topology();need(not any(os.environ.get(k)for k in REJECT),'Unfrozen compiler/loader overrides')
 cargo_home=Path(os.environ.get('CARGO_HOME',Path.home()/'.cargo'))
 for directory in {ROOT,HERE,HERE/'caller',WORK,WORK/'rust',*ROOT.parents,*HERE.parents,*WORK.parents,cargo_home.parent}:
  for name in ['config','config.toml']:need(not(directory/'.cargo'/name).exists(),'Unfrozen Cargo configuration')
 for name in ['config','config.toml']:need(not(cargo_home/name).exists(),'Unfrozen Cargo home configuration')
 target=Path('/tmp/fastest-bf-native-rust-k12-port-v1-cpu3');output=HERE/'validation-v1'
 need(not target.exists()and not target.is_symlink()and not output.exists()and not output.is_symlink(),'Preserve prior attempts with fresh reviewed paths')
 output.mkdir();known=dict(prepared['inherited_sources']);known.update({str((HERE/n).resolve()):r['sha256']for n,r in prepared['local'].items()})
 repo_sources={str(Path(p).relative_to(ROOT)):digest for p,digest in known.items()if Path(p).is_relative_to(ROOT)}
 meta=dict(complete=False,source_commit=args.source_commit,native_commit=NATIVE,native_base=BASE,reference_commit=REFERENCE,lease=lease,compile_affinity=sorted(os.sched_getaffinity(0)),execution_cpus=CPUS,physical_topology=topology(),prepared_sha256=sha(HERE/'PREPARATION.json'),commands=[],binaries={},compiler_inputs={},fixtures={},timing=False,new_calibration_samples=0)
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
  stderr=(output/(label+'.stderr')).read_text();line=stderr.splitlines()[0];identity=json.loads(line)
  need(identity==dict(pre_exec_affinity=CPUS,executable=str(binary)),'Missing actual expanded execution mask');return text
 persist()
 try:
  run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_*.py'])
  checksums=[]
  for mode in ['normal','disable-avx512','asan']:
   cargo=['cargo']+(['+nightly']if mode=='asan'else[]);rustc=['rustc']+(['+nightly']if mode=='asan'else[])
   flags='-Zsanitizer=address'if mode=='asan'else'-C target-cpu=native -C symbol-mangling-version=v0'
   env=dict(CARGO_TARGET_DIR=str(target/mode),RUSTFLAGS=flags);extra=['--target','x86_64-unknown-linux-gnu']if mode=='asan'else[];features=['--features','disable-avx512']if mode=='disable-avx512'else[]
   run(mode+'-compiler',rustc+['-Vv'],env)
   package_text=run(mode+'-metadata',cargo+['metadata','--locked','--offline','--format-version=1','--manifest-path',HERE/'caller/Cargo.toml',*features],env);packages=metadata(package_text,known)
   need({p['name']for p in packages.values()}=={'fastest-bloom-filter','four-sector-range12-single-line-isolated','native-rust-k12-port-proof'},'Unexpected package graph')
   common=['--locked','--offline','--release',*extra,*features,'--message-format=json']
   tests=run(mode+'-native-test-build',cargo+['test',*common,'--manifest-path',WORK/'rust/Cargo.toml','--lib','--no-run'],env)
   caller=run(mode+'-caller-build',cargo+['build',*common,'--manifest-path',HERE/'caller/Cargo.toml','--bin','native-rust-k12-port-proof'],env)
   texts=[tests,caller]
   if mode=='normal':texts.append(run('normal-clippy',cargo+['clippy',*common,'--manifest-path',WORK/'rust/Cargo.toml','--all-targets','--','-D','warnings'],env))
   testbin=artifact(tests,'fastest-bloom-filter',True,target/mode,packages);binary=artifact(caller,'native-rust-k12-port-proof',False,target/mode,packages)
   for p in [testbin,binary]:meta['binaries'][str(p)]=sha(p)
   consumed,rules=collect(target/mode,target/mode,texts,repo_sources,ROOT,packages)
   for p,digest in consumed.items():need(known.get(p)==digest,'Unbound actual compiler input '+p)
   for p in [WORK/'rust/src/lib.rs',WORK/'rust/src/four_sector_range12.rs',WORK/'rust/src/k12_parallel.rs',WORK/'rust/src/four_sector_range12_tests.rs',REF/'src/four_sector_range12.rs',HERE/'caller/src/main.rs']:
    need(str(p.resolve())in consumed,'Missing actual package/module consumer '+str(p))
   for i,rule in enumerate(rules):(output/f'{mode}-dependencies-{i}.d').write_text(rule['text'])
   save(output/(mode+'-compiler-closure.json'),dict(inputs_sha256=consumed,rules=rules,package_metadata_sha256=sha(output/(mode+'-metadata.stdout'))))
   meta['compiler_inputs'][mode]=consumed;meta.setdefault('mode_binaries',{})[mode]=dict(test=str(testbin),caller=str(binary));persist()
   # Tests/BF execute only after every emitted dependency rule is bound.
   test_args=['--test-threads=1']if mode=='normal'else['four_sector_range12::tests::','--test-threads=1']
   result=execute(mode+'-native-tests',testbin,test_args,env)
   need('test result: ok.'in result and'0 failed'in result,'Native test result incomplete')
   need(len(re.findall(r'^test four_sector_range12::tests::.* \.\.\. ok$',result,re.M))==6,'Missing six K12 tests')
   features_host=Path('/proc/cpuinfo').read_text();backend='avx2'if mode=='disable-avx512'else'avx512'
   need('avx2'in features_host and'avx512f'in features_host,'Frozen x86 host backends unavailable')
   result=fixture(execute(mode+'-public-parity',binary,[],env),backend);meta['fixtures'][mode]=result;checksums.append(result['checksum']);persist()
  need(len(set(checksums))==1,'Cross-profile complete-output digest differs')
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
  verify(args.source_commit);need(require_lease(3)==lease,'Final lease drift')
  for p,d in meta['binaries'].items():need(sha(p)==d,'Executable changed')
  for group in meta['compiler_inputs'].values():
   for p,d in group.items():need(sha(p)==d,'Consumed source changed')
  meta.update(complete=True,profiles=3,native_test_runs=3,k12_test_executions=18,parity_cases=36,throughput_workloads=0);persist()
 except BaseException as error:
  meta['error']=repr(error);meta['traceback']=traceback.format_exc();persist();raise
if __name__=='__main__':main()
