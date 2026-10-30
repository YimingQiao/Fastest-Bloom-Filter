"""Exact local source and structured Cargo identities, no workload execution."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
NATIVE='ba5530a4fc38930a9da4593f2a8af7d1de3c853a'
PROPOSAL='5ac4b63414d94f63b7f61304c09b7eb8d0459f0e'

def need(ok,message):
    if not ok:raise ValueError(message)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,sort_keys=True)+'\n')
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+str(path)],cwd=ROOT)
def verify(commit):
    need(re.fullmatch('[0-9a-f]{40}',commit),'full immutable commit required')
    manifest=HERE/'PREPARATION.json'
    need(blob(commit,manifest.relative_to(ROOT))==manifest.read_bytes(),'preparation manifest is not committed')
    prep=json.loads(manifest.read_text())
    for name,digest in prep['files'].items():
        path=HERE/name
        need(path.resolve().is_relative_to(HERE),'source escapes preparation')
        need(sha(path)==digest and hashlib.sha256(blob(commit,path.relative_to(ROOT))).hexdigest()==digest,'prepared source drift: '+name)
    for name,record in json.loads((HERE/'REUSED.json').read_text()).items():
        original=blob(record['commit'],record['path'])
        need(hashlib.sha256(original).hexdigest()==record['sha256'],'pinned helper drift')
        expected=original
        for old,new in record.get('substitutions',[]):expected=expected.replace(old.encode(),new.encode())
        need((HERE/name).read_bytes()==expected,'derived helper differs')
        need(sha(HERE/name)==record.get('derived_sha256',record['sha256']),'copied helper drift')
    # Deterministic byte derivation is checked independently before build too.
    import derive
    generated,expected=derive.derive()
    need((HERE/'DERIVED.json').read_bytes()==expected,'derivation manifest differs')
    for name,data in generated.items():need((HERE/name).read_bytes()==data,'native/candidate derivation differs')
    return {str((HERE/name).relative_to(ROOT)):digest for name,digest in prep['files'].items()}

def packages(text):
    value=json.loads(text)
    expected={'k12-simd-control':HERE/'control/Cargo.toml',
              'k12-simd-candidate':HERE/'candidate/Cargo.toml',
              'rust-k12-simd-caller':HERE/'Cargo.toml'}
    need(len(value['packages'])==3,'unexpected Cargo package')
    for p in value['packages']:
        need(p['name'] in expected and Path(p['manifest_path']).resolve()==expected[p['name']],'Cargo package path differs')
        need(p.get('source') is None,'registry dependencies are not permitted')
    need({p['name'] for p in value['packages']}==set(expected),'Cargo package set differs')
    return {p['id']:p for p in value['packages']}

def artifacts(text,test,target,known):
    result={}
    for line in text.splitlines():
        row=json.loads(line)
        if row.get('reason')!='compiler-artifact' or bool(row['profile']['test'])!=test or row.get('executable') is None:continue
        package=known.get(row['package_id']);need(package is not None,'unbound Cargo executable package')
        path=Path(row['executable']).resolve()
        need(path.is_file() and path.is_relative_to(target),'Cargo executable outside fresh target')
        need(Path(row['manifest_path']).resolve()==Path(package['manifest_path']).resolve(),'artifact manifest differs')
        key=package['name'];need(key not in result or result[key]==path,'ambiguous Cargo executable')
        result[key]=path
    expected={'k12-simd-control','k12-simd-candidate'} if test else {'rust-k12-simd-caller'}
    need(set(result)==expected,'missing/extra structured executable')
    return result
