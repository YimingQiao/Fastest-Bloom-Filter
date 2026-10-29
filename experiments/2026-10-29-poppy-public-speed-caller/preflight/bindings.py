"""Bind the new caller, prior actual executable, packages and emitted inputs."""
import hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;CALLER=HERE.parent;ROOT=CALLER.parents[1]
SOURCE='235090460f5bc063109c1cb3d40357673f36d50e'
OLD_SOURCE='72625673e6b5bb57874a5fa53e04d23ffb8c6ab2'
PROOF='a2d6f832a77d251ec44429ea7f13a37eafa2c0a6'
PLAN='4d2b7f69d941991f3a9f4cebeb2c7c87514cd8f0'
OLD=ROOT/'experiments/2026-10-29-four-sector-range12-rust-screen/caller'
PROOF_PATH=OLD.parent/'caller-proof/COMPILED_FREEZE.json'
SELECTION=ROOT/'experiments/2026-10-29-poppy-public-speed-plan/selection.json'
UPSTREAM=ROOT/'build/poppy-source'
UPSTREAM_COMMIT='992a13e27e8b09b2a832333a4ba3d160545fa866'
TARGET=Path('/tmp/fastest-bf-poppy-public-caller-v1-cpu2')
OUTPUT=CALLER/'validation-v1'
LOCAL_MANIFESTS={str((p/'Cargo.toml').resolve())for p in [CALLER/'benchmark',ROOT/'experiments/2026-10-29-split64-range-rust-screen/native',ROOT/'experiments/2026-10-29-four-sector-range12-rust-port/native',UPSTREAM/'poppy']}
def need(ok,message):
    if not ok:raise ValueError(message)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def exact(commit,path):
    need(re.fullmatch('[0-9a-f]{40}',commit),'Full immutable commit required')
    need(Path(path).read_bytes()==subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT),'Changed committed source '+str(path))
def old_proof():
    exact(PROOF,PROOF_PATH);p=json.loads(PROOF_PATH.read_text());binary=Path(p['performance_executable'])
    need(sha(binary)==p['performance_executable_sha256']=='dc6864c5cfb5324e4689e677705189fa5758be037530189a39e2bffafed2251e','Changed original caller')
    return p,binary
def upstream():
    need(subprocess.check_output(['git','rev-parse','HEAD'],cwd=UPSTREAM,text=True).strip()==UPSTREAM_COMMIT,'Wrong Poppy revision')
    need(not subprocess.check_output(['git','status','--porcelain','--untracked-files=all'],cwd=UPSTREAM),'Dirty Poppy source tree')
def source_inputs():
    """Source-only inventory before compilation; never import old timings."""
    upstream();proof,binary=old_proof();inputs={};anchors={}
    def anchor(commit,path):
        exact(commit,path);name=str(path.relative_to(ROOT));anchors[name]={'commit':commit,'sha256':sha(path)};inputs[str(path.resolve())]=sha(path)
    anchor(SOURCE,CALLER/'PREPARATION.json')
    for name,digest in json.loads((CALLER/'PREPARATION.json').read_text())['files'].items():
        path=CALLER/name;anchor(SOURCE,path);need(sha(path)==digest,'Caller source digest differs')
    anchor(PLAN,SELECTION);anchor(PROOF,PROOF_PATH)
    for filename in ['dependencies.py','source_guard.py','guard.py']:
        anchor(OLD_SOURCE,OLD/'preflight'/filename)
    for filename in ['benchmark/src/main.rs','benchmark/src/geometry.rs']:
        anchor(OLD_SOURCE,OLD/filename)
    # The committed prior proof pins all existing native modules, including
    # path dependencies. Their exact bytes remain the compilation contract.
    for name,digest in proof['prepared_input_sha256'].items():
        path=ROOT/name;need(sha(path)==digest,'Prior prepared source changed');inputs[str(path.resolve())]=digest
    metadata=json.loads((CALLER/'resolution-v1/stdout.json').read_text())
    packages={p['id']:p for p in metadata['packages']};need(len(packages)==76,'Resolved package count changed')
    for package in packages.values():
        base=Path(package['manifest_path']).resolve().parent
        if base==CALLER/'benchmark':continue
        # Every actual file of each frozen resolved package, not guessed
        # relative .d paths. Generated build outputs are tracked separately.
        for path in sorted(base.rglob('*')):
            if path.is_file()and '.git'not in path.relative_to(base).parts and 'target'not in path.relative_to(base).parts:
                inputs[str(path.resolve())]=sha(path)
    return {'anchors':anchors,'input_sha256':inputs,'original_binary':{'path':str(binary),'sha256':sha(binary)},'upstream_commit':UPSTREAM_COMMIT,'packages':{k:{'manifest_path':v['manifest_path'],'source':v['source'],'targets':v['targets']}for k,v in packages.items()}}
def verify(commit):
    exact(commit,HERE/'PREPARATION.json');prep=json.loads((HERE/'PREPARATION.json').read_text())
    files={str(p.relative_to(HERE))for p in HERE.rglob('*')if p.is_file()and '__pycache__'not in p.parts and p.name!='PREPARATION.json'}
    need(files==set(prep['files']),'Changed preflight source closure')
    for name,digest in prep['files'].items():
        path=HERE/name;exact(commit,path);need(sha(path)==digest,'Changed preflight source')
    inventory=json.loads((HERE/'INPUTS.json').read_text());upstream();old_proof()
    for name,item in inventory['anchors'].items():exact(item['commit'],ROOT/name);need(sha(ROOT/name)==item['sha256'],'Changed anchor')
    for name,digest in inventory['input_sha256'].items():need(sha(name)==digest,'Changed prepared input '+name)
    for new,old in [('dependencies.py','dependencies.py'),('parent_guard.py','guard.py')]:
        need((HERE/new).read_bytes()==(OLD/'preflight'/old).read_bytes(),'Copied verified helper changed')
    old=(OLD/'preflight/source_guard.py').read_text()
    expected=old.replace('socket1','socket0').replace('cpu3','cpu2').replace('CPU3','CPU2').replace('cpu != 3','cpu != 2').replace('{3}','{2}').replace('dict(cpu=3','dict(cpu=2')
    need((HERE/'lease.py').read_text()==expected,'Only declared socket placement may differ')
    return inventory
def cargo_packages(text,inventory):
    values=json.loads(text);packages={p['id']:p for p in values['packages']}
    projection={k:{'manifest_path':v['manifest_path'],'source':v['source'],'targets':v['targets']}for k,v in packages.items()}
    need(projection==inventory['packages'],'Resolved Cargo package graph changed')
    local={str(Path(p['manifest_path']).resolve())for p in packages.values()if p['source']is None};need(local==LOCAL_MANIFESTS,'Unexpected local package')
    for path in local:need(inventory['input_sha256'].get(path)==sha(path),'Unbound local manifest')
    return packages
def artifact(text,test,target,packages):
    found=[];manifest=(CALLER/'benchmark/Cargo.toml').resolve();main=manifest.parent/'src/main.rs'
    for line in text.splitlines():
        value=json.loads(line)
        if value.get('reason')!='compiler-artifact'or Path(value['manifest_path']).resolve()!=manifest:continue
        need(value['package_id']in packages,'Unknown root artifact')
        if value['target']['name']!='compare_benchmark'or value['target']['kind']!=['bin']or value['profile']['test']!=test:continue
        need(Path(value['target']['src_path']).resolve()==main,'Wrong root target')
        if value.get('executable'):found.append(Path(value['executable']).resolve())
    need(len(set(found))==1,'Expected one structured executable');path=found[0]
    need(path.is_file()and path.is_relative_to(target.resolve()),'Executable outside fresh target');return path
def generated_inputs(texts,target,packages,consumed,inventory):
    directories={}
    for text in texts:
        for line in text.splitlines():
            event=json.loads(line)
            if event.get('reason')!='build-script-executed':continue
            need(event['package_id']in packages,'Unknown build-script package')
            path=Path(event['out_dir']).resolve();need(path.is_relative_to(target.resolve()),'Build output escaped target')
            need(str(path)not in directories or directories[str(path)]==event,'Ambiguous build output origin');directories[str(path)]=event
    generated={}
    for name,digest in consumed.items():
        if inventory['input_sha256'].get(name)==digest:continue
        path=Path(name);owners=[v for k,v in directories.items()if path.is_relative_to(Path(k))]
        need(len(owners)==1,'Unbound compiler input '+name)
        generated[name]={'sha256':digest,'build_script_event':owners[0]}
    return generated
if __name__=='__main__':
    save(HERE/'INPUTS.json',source_inputs());print('Source-only package inventory written; no compiler or BF')
