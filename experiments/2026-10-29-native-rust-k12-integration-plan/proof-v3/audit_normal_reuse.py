"""Read-only complete dependency verification of preserved V2 normal artifacts."""
from bindings import *
from dependencies import collect
from checks import artifact

def audit():
 files,anchors=inherited();old=PLAN/'proof-v2';raw=old/'validation-v1';target=Path('/tmp/fastest-bf-native-rust-k12-port-v2-cpu3/normal')
 texts=[(raw/(n+'.stdout')).read_text()for n in ['normal-native-test-build','normal-caller-build','normal-clippy']]
 package_text=(raw/'normal-metadata.stdout').read_text();packages=metadata(package_text,files)
 repo={str(Path(p).relative_to(ROOT)):d for p,d in files.items()if Path(p).is_relative_to(ROOT)}
 inputs,rules=collect(target,target,texts,repo,ROOT,packages)
 for p,d in inputs.items():need(files.get(p)==d,'Unbound input '+p)
 for p in [WORK/'rust/src/lib.rs',WORK/'rust/src/four_sector_range12.rs',WORK/'rust/src/k12_parallel.rs',WORK/'rust/src/four_sector_range12_tests.rs',REF/'src/four_sector_range12.rs',old/'caller/src/main.rs']:
  need(str(p.resolve())in inputs,'Missing representative consumer '+str(p))
 test=artifact(texts[0],'fastest-bloom-filter',True,target,packages);caller=artifact(texts[1],'native-rust-k12-port-proof',False,target,packages)
 original=json.loads((raw/'metadata.json').read_text())
 expected=dict(CARGO_TARGET_DIR=str(target),RUSTFLAGS='-C target-cpu=native -C symbol-mangling-version=v0')
 need(all(c['explicit_environment']==expected for c in original['commands'][1:]),'Normal flags drift')
 return dict(complete=True,source_commit='2dd44627f85081dd8ba4f123992234f2dc09ac8f',failure_archive_commit='f4fcd112c6ac205442ee1927d2bcbf47a6da2e03',native_commit=NATIVE,tests_executed=0,BF_executions=0,clippy_returncode=0,explicit_environment=expected,inputs_sha256=inputs,rules=rules,package_metadata_sha256=sha(raw/'normal-metadata.stdout'),binaries={str(p):sha(p)for p in [test,caller]})
if __name__=='__main__':save(HERE/'NORMAL_REUSE_CLOSURE.json',audit())
