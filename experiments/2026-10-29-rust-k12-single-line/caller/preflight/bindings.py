"""Immutable native, actual-caller, collector, external trees and source closure."""
import hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;CALLER=HERE.parent;STAGE=CALLER.parent;ROOT=STAGE.parents[1]
PARENT_SOURCE='72625673e6b5bb57874a5fa53e04d23ffb8c6ab2'
PARENT_PROOF='a2d6f832a77d251ec44429ea7f13a37eafa2c0a6'
K12_PROOF='645f397cd406fd7e89cc75020b0b6fe2f142b3ab'
OLD_STAGE=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes-screen'
PARENT=ROOT/'experiments/2026-10-29-four-sector-range12-rust-screen/caller'
OLD_NATIVE=ROOT/'experiments/2026-10-29-split64-range-rust-screen/native'
K12_NATIVE=ROOT/'experiments/2026-10-29-four-sector-range12-rust-port/native'
LOCAL_MANIFESTS={str((p/'Cargo.toml').resolve())for p in [CALLER/'benchmark',STAGE/'native',OLD_NATIVE,K12_NATIVE]}
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
    prep_path=PARENT/'PREPARATION.json';add(PARENT_SOURCE,prep_path);prep=json.loads(prep_path.read_text())
    for name in prep['files']:add(PARENT_SOURCE,PARENT/name)
    for name,r in prep['parents'].items():add(r['commit'],ROOT/name)
    for name in ['caller-proof/COMPILED_FREEZE.json','caller/validation-v1/metadata.json','caller/validation-v1/normal-case-0.stdout','caller-asm-v2/capture-v2/CAPTURE.json']:add(PARENT_PROOF,PARENT.parent/name)
    proposal='0c0eb382a817245e379b01339ecd71b747bd5cea';initial=STAGE/'PREPARATION.json';add(proposal,initial)
    for name in json.loads(initial.read_text())['files']:add(proposal,STAGE/name)
    return records

def local_files():
    return sorted(p for p in CALLER.rglob('*')if p.is_file()and '__pycache__'not in p.parts and not any(part.startswith(('validation-','capture-'))for part in p.relative_to(CALLER).parts)and p.name not in ['PREPARATION.json'])
def make_preparation():
    parents=parent_pins()
    return dict(scope='Original-hint safe single-line caller correctness and ASM; no performance/calibration',parents=parents,
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
    proof=json.loads((PARENT/'validation-v1/metadata.json').read_text());binary=Path(proof['mode_executables']['normal'])
    need(sha(binary)==proof['binaries'][str(binary)]=='dc6864c5cfb5324e4689e677705189fa5758be037530189a39e2bffafed2251e','Original actual caller changed')
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
    need(local==LOCAL_MANIFESTS,'Missing one of four local packages')
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

# Structured discovery for the one focused private-invariant test executable.
def invariant_artifact(text,target,packages):
    manifest=(STAGE/'native/Cargo.toml').resolve();source=(STAGE/'native/src/lib.rs').resolve();found=[]
    for line in text.splitlines():
        event=json.loads(line)
        if event.get('reason')!='compiler-artifact'or Path(event['manifest_path']).resolve()!=manifest:continue
        need(event['package_id']in packages and Path(packages[event['package_id']]['manifest_path']).resolve()==manifest,'Invariant artifact package drift')
        if event['target']['kind']!=['lib']or not event['profile']['test']:continue
        need(event['target']['name']=='four_sector_range12_single_line_isolated'and Path(event['target']['src_path']).resolve()==source,'Invariant artifact target drift')
        if event.get('executable'):found.append(Path(event['executable']).resolve())
    need(len(set(found))==1,'Expected exactly one native-invariant test executable')
    path=found[0];need(path.is_relative_to(target.resolve())and path.is_file(),'Native test executable outside fresh target');return path
