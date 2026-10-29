import hashlib,json,os,subprocess,time
from pathlib import Path
root=Path('/home/yiming/projects/fastest-bf-native-integration')
out=root/'build/range-integration-validation-v1'
assert not out.exists()
out.mkdir(parents=True)
commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()
assert commit=='e8b89cd3c7c090287d1d4222db981ec7f8fb86ab'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=root)
assert os.sched_getaffinity(0)=={2}
meta={'source_commit':commit,'complete':False,'cpu':2,'started':time.time(),'commands':[]}
def save(): (out/'commands.json').write_text(json.dumps(meta,indent=2)+'\n')
def run(label,args,extra=None):
 env=os.environ.copy();env.update(extra or {})
 rec={'label':label,'command':args,'cwd':str(root),'environment_overrides':extra or {}}
 meta['commands'].append(rec);save()
 p=subprocess.run(args,cwd=root,env=env,capture_output=True)
 for kind,data in [('stdout',p.stdout),('stderr',p.stderr)]:
  name=label+'.'+kind;(out/name).write_bytes(data);rec[kind]=name;rec[kind+'_sha256']=hashlib.sha256(data).hexdigest()
 rec['returncode']=p.returncode;save();print(label, p.returncode,flush=True)
 if p.returncode:raise RuntimeError(label+' failed; original logs retained')
run('clang-version',['clang++','--version'])
run('rust-version',['rustc','-Vv'])
for label,options in [('native',['-DBF_NATIVE=ON']),('avx2',['-DBF_NATIVE=OFF','-DUSE_AVX2=ON','-DUSE_AVX512=OFF']),('asan',['-DBF_NATIVE=ON','-DBF_SANITIZERS=ON'])]:
 directory='build/range-integration-'+label
 run(label+'-configure',['cmake','-S','.','-B',directory,'-DCMAKE_CXX_COMPILER=clang++','-DBUILD_TESTING=ON']+options)
 run(label+'-build',['cmake','--build',directory,'--target','test_split64_range','test_split64_range_portable','-j','1'])
 run(label+'-test',['ctest','--test-dir',directory,'--output-on-failure','-R','^split64_range(_portable)?$'])
run('rust-native',['cargo','test','--manifest-path','rust/Cargo.toml','--','--test-threads=1'],{'CARGO_TARGET_DIR':str(root/'build/range-rust-native'),'RUSTFLAGS':'-C target-cpu=native'})
run('rust-avx2',['cargo','test','--manifest-path','rust/Cargo.toml','--features','disable-avx512','--','--test-threads=1'],{'CARGO_TARGET_DIR':str(root/'build/range-rust-avx2'),'RUSTFLAGS':'-C target-cpu=x86-64-v3'})
run('rust-clippy',['cargo','clippy','--manifest-path','rust/Cargo.toml','--all-targets','--','-D','warnings'],{'CARGO_TARGET_DIR':str(root/'build/range-rust-native'),'RUSTFLAGS':'-C target-cpu=native'})
run('rust-asan',['cargo','+nightly','test','--manifest-path','rust/Cargo.toml','--lib','--target','x86_64-unknown-linux-gnu','split64_range::tests','--','--test-threads=1'],{'CARGO_TARGET_DIR':str(root/'build/range-rust-asan'),'RUSTFLAGS':'-Zsanitizer=address -C target-cpu=native','ASAN_OPTIONS':'detect_leaks=1'})
assert not subprocess.check_output(['git','status','--porcelain'],cwd=root)
meta.update(complete=True,finished=time.time());save();print('PASS complete optional Range integration checks',flush=True)
