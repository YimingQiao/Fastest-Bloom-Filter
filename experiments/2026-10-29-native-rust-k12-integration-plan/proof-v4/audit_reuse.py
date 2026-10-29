"""Read-only closure audit of all existing normal/disabled/ASan binaries."""
from bindings import *
from dependencies import collect
from checks import artifact,fixture,CPUS

def audit():
 files,anchors=inherited();v2=PLAN/'proof-v2';v3=PLAN/'proof-v3';raw=v3/'validation-v1';old=json.loads((raw/'metadata.json').read_text());modes={}
 repo={str(Path(p).relative_to(ROOT)):d for p,d in files.items()if Path(p).is_relative_to(ROOT)}
 for mode in ['normal','disable-avx512','asan']:
  source=(v2/'validation-v1')if mode=='normal'else raw
  target=Path('/tmp/fastest-bf-native-rust-k12-port-v2-cpu3/normal')if mode=='normal'else Path('/tmp/fastest-bf-native-rust-k12-port-v3-cpu3')/mode
  labels=[mode+'-native-test-build',mode+'-caller-build']+(['normal-clippy']if mode=='normal'else[])
  texts=[(source/(n+'.stdout')).read_text()for n in labels];package_text=(source/(mode+'-metadata.stdout')).read_text();packages=metadata(package_text,files)
  inputs,rules=collect(target,target,texts,repo,ROOT,packages)
  for p,d in inputs.items():need(files.get(p)==d,'Unbound actual source '+p)
  for p in [WORK/'rust/src/lib.rs',WORK/'rust/src/four_sector_range12.rs',WORK/'rust/src/k12_parallel.rs',WORK/'rust/src/four_sector_range12_tests.rs',REF/'src/four_sector_range12.rs',v2/'caller/src/main.rs']:
   need(str(p.resolve())in inputs,'Missing representative consumer '+str(p))
  test=artifact(texts[0],'fastest-bloom-filter',True,target,packages);caller=artifact(texts[1],'native-rust-k12-port-proof',False,target,packages)
  need(all(old['binaries'].get(str(p))==sha(p)for p in [test,caller]),'Executable not bound by original V3 attempt')
  env=dict(CARGO_TARGET_DIR=str(target),RUSTFLAGS='-Zsanitizer=address'if mode=='asan'else'-C target-cpu=native -C symbol-mangling-version=v0')
  ledger=json.loads((source/'metadata.json').read_text())
  for label in labels+[mode+'-metadata',mode+'-compiler']:
   row=next(c for c in ledger['commands']if c['label']==label);need(row['explicit_environment']==env,'Preserved compiler flags drift')
  modes[mode]=dict(inputs_sha256=inputs,rules=rules,binaries={str(p):sha(p)for p in[test,caller]},test=str(test),caller=str(caller),explicit_environment=env,package_metadata_sha256=sha(source/(mode+'-metadata.stdout')))
  if mode!='asan':
   need(old['compiler_inputs'][mode]==inputs,'Prior verified input closure changed')
   for label in [mode+'-native-tests',mode+'-public-parity']:
    row=next(c for c in old['commands']if c['label']==label);expected= test if label.endswith('native-tests')else caller
    identity=json.loads((raw/row['stderr']).read_text().splitlines()[0]);need(identity==dict(pre_exec_affinity=CPUS,executable=str(expected)),'Prior actual affinity drift')
   result=(raw/(mode+'-native-tests.stdout')).read_text();count=40 if mode=='normal'else 6
   need(f'test result: ok. {count} passed; 0 failed;'in result,'Prior tests not complete')
   data=fixture((raw/(mode+'-public-parity.stdout')).read_text(),'avx512'if mode=='normal'else'avx2');need(data==old['fixtures'][mode],'Prior parity drift')
 return dict(complete=True,source_commit='d9afa73b2f4a1df60dc7bd8b02880a19f393e730',archive_commit='18b51be438b02ad46353b3cdae43f0a8a91a1496',native_commit=NATIVE,modes=modes,prior_fixtures=old['fixtures'],passed_test_counts=dict(normal=40,disable_avx512=6),normal_clippy_returncode=0,pending=['asan-native-tests','asan-public-parity','normal-symbol-assembly-capture'],new_BF_executions=0)
if __name__=='__main__':save(HERE/'REUSE_CLOSURE.json',audit())
