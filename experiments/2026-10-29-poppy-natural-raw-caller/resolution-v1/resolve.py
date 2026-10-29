#!/usr/bin/env python3
"""One isolated metadata/lock resolution; never requests build/test/run."""
import datetime
import hashlib
import json
import os
import shutil
import subprocess
import tomllib
from pathlib import Path

HERE=Path(__file__).resolve().parent
CALLER=HERE.parent
ROOT=CALLER.parents[1]
SOURCE='d3da7464052c4f3a5c298703654e2921b37b319a'
def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(name,value): (HERE/name).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def exact(path):
    assert path.read_bytes()==subprocess.check_output(['git','show',SOURCE+':'+str(path.relative_to(ROOT))],cwd=ROOT)

def packages(path):
    return {(p['name'],p['version'],p.get('source')):p for p in tomllib.loads(path.read_text())['package']}

def main():
    assert os.sched_getaffinity(0)=={3} and os.environ.get('BF_SOCKET_LEASE')=='socket1-cpu3'
    assert not (HERE/'metadata.json').exists()
    initial=CALLER/'PREPARATION.json';exact(initial);prep=json.loads(initial.read_text())
    for name,item in prep['files'].items():
        path=CALLER/name;exact(path);assert sha(path)==item['sha256'] and path.stat().st_size==item['bytes']
    parent=CALLER/'dependency-preparation/parent-raw8-Cargo.lock';exact(parent)
    target=CALLER/'benchmark/Cargo.lock';assert not target.exists() and not target.is_symlink()
    with target.open('xb') as f:f.write(parent.read_bytes())
    cargo=Path(shutil.which('cargo')).absolute() # retain rustup dispatch basename
    envkeys=['RUSTFLAGS','CARGO_ENCODED_RUSTFLAGS','RUSTC','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CARGO_TARGET_DIR']
    environment={k:os.environ.get(k)for k in envkeys}
    assert not any(environment[k] for k in envkeys),'Unexpected Cargo override'
    data=dict(complete=False,source_commit=SOURCE,started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
              cargo_path=str(cargo),cargo_sha256=sha(cargo),environment=environment,affinity=sorted(os.sched_getaffinity(0)),
              original_lock_sha256=sha(parent),compilation_requested=False,filter_executed=False,commands=[])
    save('metadata.json',data)
    commands=[('cargo-version',[str(cargo),'--version','--verbose']),
              ('cargo-metadata',[str(cargo),'metadata','--offline','--format-version','1','--manifest-path',str(CALLER/'benchmark/Cargo.toml')])]
    for label,command in commands:
        result=subprocess.run(command,cwd=CALLER/'benchmark',capture_output=True)
        (HERE/(label+'.stdout')).write_bytes(result.stdout);(HERE/(label+'.stderr')).write_bytes(result.stderr)
        data['commands'].append(dict(label=label,command=command,returncode=result.returncode,
                                     stdout_sha256=sha(HERE/(label+'.stdout')),stderr_sha256=sha(HERE/(label+'.stderr'))))
        save('metadata.json',data)
        assert result.returncode==0,label
    graph=json.loads((HERE/'cargo-metadata.stdout').read_text());old=packages(parent);new=packages(target)
    old_external={k:v for k,v in old.items()if k[2] is not None}
    removed=[dict(name=k[0],version=k[1],source=k[2])for k in old_external if k not in new]
    changed=[dict(name=k[0],version=k[1],source=k[2],old=old_external[k],new=new[k])for k in old_external if k in new and old_external[k]!=new[k]]
    added=[v for k,v in new.items()if k not in old]
    diff=dict(old_external_package_identities=len(old_external),removed_external_identities=removed,
              changed_existing_lock_records=changed,added_lock_records=added,
              old_root_identity='fastest-bloom-filter-raw8-public-caller',new_root_identity='fastest-bloom-filter-poppy-natural-raw-caller')
    save('package-diff.json',diff)
    # Existing identities/checksums must survive. Dependency-edge differences,
    # including version disambiguation strings, are retained for root review.
    assert not removed,'Existing raw8 dependency removed/replaced'
    for key,item in old_external.items(): assert new[key].get('checksum')==item.get('checksum'),'Existing checksum changed'
    manifests={p['manifest_path']:sha(p['manifest_path'])for p in graph['packages']}
    save('resolved-packages.json',dict(packages=graph['packages'],resolve=graph['resolve'],manifest_sha256=manifests))
    (HERE/'combined-Cargo.lock').write_bytes(target.read_bytes())
    for name,item in prep['files'].items():assert sha(CALLER/name)==item['sha256'],'Initial source changed during resolution'
    assert sha(parent)==data['original_lock_sha256'] and sha(cargo)==data['cargo_sha256']
    data.update(complete=True,finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                combined_lock_sha256=sha(target),package_count=len(graph['packages']),removed_external_packages=0,
                changed_existing_lock_records=len(changed),added_lock_records=len(added))
    save('metadata.json',data)
    print(json.dumps({k:data[k]for k in ('complete','package_count','combined_lock_sha256','removed_external_packages','changed_existing_lock_records','added_lock_records')}))

if __name__=='__main__':main()
