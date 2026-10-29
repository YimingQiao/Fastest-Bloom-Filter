"""Exact committed source, original executable, and external-tree bindings."""
import hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;CALLER=HERE.parent;STAGE=CALLER.parent;ROOT=STAGE.parents[1]
PROPOSAL='21c8202ab8b742579e45180c91de7e3582465ac3'
ORIGINAL='571186b420bf7e5fc08269ed4a65feab42ac8400'
OLD_PROOF='c5ed7d7d23f9c481dc61990544b0827502d187c4'
K12_PROOF='645f397cd406fd7e89cc75020b0b6fe2f142b3ab'
COLLECTOR='ec44c93cde22ea5c30ffd4d2bca5bc6e5eaaf63b'
OLD_STAGE=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes-screen'
OLD_NATIVE=ROOT/'experiments/2026-10-29-split64-range-rust-screen/native'
K12_NATIVE=ROOT/'experiments/2026-10-29-four-sector-range12-rust-port/native'
OLD_PUBLIC=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes/benchmark'
LOCAL_MANIFESTS={str((p/'Cargo.toml').resolve()) for p in [CALLER/'benchmark',OLD_NATIVE,K12_NATIVE]}

def need(ok,why):
    if not ok:raise ValueError(why)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT)
def anchor(commit,path):
    need(Path(path).read_bytes()==blob(commit,path),'Committed anchor changed: '+str(path))
    return sha(path)
def exact_commit(commit):need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full immutable source commit required')
def parent_pins():
    records={}
    def add(commit,path):records[str(path.relative_to(ROOT))]=dict(commit=commit,sha256=anchor(commit,path))
    for commit,path in [(PROPOSAL,STAGE/'PREPARATION.json'),(OLD_PROOF,OLD_STAGE/'PERFORMANCE_COMPILED_FREEZE.json'),(OLD_PROOF,OLD_STAGE/'external-tree.json'),(ORIGINAL,OLD_STAGE/'guard.py'),(ORIGINAL,OLD_STAGE/'source_guard.py'),(K12_PROOF,K12_NATIVE.parent/'PREFLIGHT_FREEZE.json'),(COLLECTOR,ROOT/'experiments/2026-10-29-native-build-policy-controls/caller/preflight/dependencies.py')]:add(commit,path)
    for name in json.loads((STAGE/'PREPARATION.json').read_text())['files']:add(PROPOSAL,STAGE/name)
    for commit,base in [(ORIGINAL,OLD_NATIVE),(K12_PROOF,K12_NATIVE),(ORIGINAL,OLD_PUBLIC)]:
        names=subprocess.check_output(['git','ls-tree','-r','--name-only',commit,'--',str(base.relative_to(ROOT))],cwd=ROOT,text=True).splitlines()
        for name in names:
            path=ROOT/name
            if path.suffix in ('.rs','.toml','.lock')or path.name.startswith('LICENSE')or path.name=='NOTICE':add(commit,path)
    return records

def local_files():
    return sorted(p for p in CALLER.rglob('*')if p.is_file()and '__pycache__'not in p.parts and not any(part.startswith('validation-')for part in p.relative_to(CALLER).parts)and p.name not in ['PREPARATION.json'])
def make_preparation():
    parents=parent_pins()
    return dict(scope='Actual public K12 caller focused preflight only; no fresh108 performance',parents=parents,
        files={str(p.relative_to(CALLER)):dict(sha256=sha(p),bytes=p.stat().st_size)for p in local_files()})
def external_sources():
    result={};roots=set()
    for dep in json.loads((OLD_STAGE/'external-tree.json').read_text())['dependencies']:
        base=Path(dep['directory']).resolve();roots.add(str(base))
        for name,digest in dep['sha256'].items():
            path=base/name;need(sha(path)==digest,'Pinned external source changed '+str(path));result[str(path.resolve())]=digest
    return result,roots

def verify(commit):
    exact_commit(commit);declaration=CALLER/'PREPARATION.json';anchor(commit,declaration);prep=json.loads(declaration.read_text())
    need(set(prep['files'])=={str(p.relative_to(CALLER))for p in local_files()},'Changed local source closure')
    pins={}
    for name,record in prep['files'].items():
        path=CALLER/name;need(sha(path)==record['sha256']and path.stat().st_size==record['bytes'],'Changed caller source '+name);anchor(commit,path);pins[str(path.relative_to(ROOT))]=record['sha256']
    for name,record in prep['parents'].items():
        path=ROOT/name;need(anchor(record['commit'],path)==record['sha256'],'Changed inherited source '+name);pins[name]=record['sha256']
    pins[str(declaration.relative_to(ROOT))]=sha(declaration)
    external,external_roots=external_sources()
    proof=json.loads((OLD_STAGE/'PERFORMANCE_COMPILED_FREEZE.json').read_text());binary=Path(proof['performance_executable'])
    need(sha(binary)==proof['performance_executable_sha256']=='f499f5daa354f3db31c5cfa1e84640c890f96c81e2724456aa64bf7b6bc7ef05','Original timing binary changed')
    return pins,external,external_roots,binary

def cargo_packages(text,repo_pins,external,external_roots):
    metadata=json.loads(text);packages={p['id']:p for p in metadata['packages']};local=set()
    for package in packages.values():
        manifest=Path(package['manifest_path']).resolve()
        if package['source'] is None:
            need(str(manifest)in LOCAL_MANIFESTS,'Unexpected local Cargo dependency');local.add(str(manifest))
            need(package['id'].startswith('path+file://'+str(manifest.parent)+'#'),'Local Cargo package identity changed')
            need(repo_pins.get(str(manifest.relative_to(ROOT)))==sha(manifest),'Unbound local Cargo manifest')
        elif str(manifest.parent)in external_roots:
            need(external.get(str(manifest))==sha(manifest),'Unbound external Cargo manifest')
        # Target-specific unused lock dependencies may be present in metadata;
        # every actually emitted artifact/dep input is checked below.
    need(local==LOCAL_MANIFESTS,'Missing one of the three local packages')
    return packages

def artifact(text,test,target,packages):
    found=[];main=(CALLER/'benchmark/src/main.rs').resolve();manifest=(CALLER/'benchmark/Cargo.toml').resolve()
    for line in text.splitlines():
        event=json.loads(line)
        if event.get('reason')!='compiler-artifact':continue
        if Path(event['manifest_path']).resolve()!=manifest:continue
        need(event['package_id']in packages and Path(packages[event['package_id']]['manifest_path']).resolve()==manifest,'Root artifact package mismatch')
        if event['target']['name']!='compare_benchmark'or event['target']['kind']!=['bin']or event['profile']['test']!=test:continue
        need(Path(event['target']['src_path']).resolve()==main,'Root target source mismatch')
        if event.get('executable'):found.append(Path(event['executable']).resolve())
    need(len(set(found))==1,'Expected exactly one actual executable artifact')
    path=found[0];need(path.is_relative_to(target.resolve())and path.is_file(),'Artifact outside fresh target');return path

if __name__=='__main__':
    import argparse
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args()
    need(a.write,'Only explicit source preparation supported');save(CALLER/'PREPARATION.json',make_preparation());print('Source preparation frozen')
