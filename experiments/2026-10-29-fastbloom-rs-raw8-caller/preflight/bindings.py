"""Immutable source, package graph, actual artifact and generated-input binding."""
import hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;CALLER=HERE.parent;ROOT=CALLER.parents[1]
SOURCE='d23791243dabdda85a8ff2eb11ce2d9b3e5a6b47'
SOURCE_MANIFEST='ec466f8f2b10a3b14446cf02fd6325c73adf2525b724472d8b14b9ba9b82e51b'
TARGET=Path('/tmp/fastest-bf-raw8-public-caller-v1-cpu3')
OUTPUT=CALLER/'validation-v1'
LOCAL_MANIFESTS={str((CALLER/p/'Cargo.toml').resolve())for p in ['benchmark','native','upstream/fastbloom-rs']}
OLD_STDERR_COMMIT='0b2425682ad6435089aab89a84e55eedebbea86c'
OLD_STDERR=ROOT/'experiments/2026-10-29-four-sector-range12-rust-screen/caller/validation-v1'
def need(ok,message):
    if not ok:raise ValueError(message)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def exact(commit,path):
    need(re.fullmatch('[0-9a-f]{40}',commit),'Full immutable commit required')
    path=Path(path).resolve();need(path.is_relative_to(ROOT),'Repository path escaped')
    need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),'Committed source changed: '+str(path))
def prepared_inputs():
    """Assemble already-frozen descriptors; external tree verification runs under the lease."""
    manifest=CALLER/'PREPARATION.json';exact(SOURCE,manifest);need(sha(manifest)==SOURCE_MANIFEST,'Wrong initial source')
    prep=json.loads(manifest.read_text());need(len(prep['files'])==86,'Initial source coverage changed')
    inputs={str(manifest):sha(manifest)};anchors={str(manifest.relative_to(ROOT)):{'commit':SOURCE,'sha256':sha(manifest)}}
    for name,item in prep['files'].items():
        path=CALLER/name;exact(SOURCE,path);need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Initial artifact changed')
        inputs[str(path.resolve())]=item['sha256'];anchors[str(path.relative_to(ROOT))]={'commit':SOURCE,'sha256':item['sha256']}
    external=json.loads((CALLER/'dependency-preparation/external-trees.json').read_text());need(external['external_packages']==31 and external['files']==1856,'External coverage changed')
    for package in external['packages']:
        base=Path(package['manifest_path']).parent
        for name,item in package['files'].items():inputs[str((base/name).resolve())]=item['sha256']
    for record in json.loads((HERE/'HELPERS.json').read_text()):
        parent=ROOT/record['path'];exact(record['commit'],parent);need((HERE/record['destination']).read_bytes()==parent.read_bytes(),'Helper copy drift')
        anchors[record['path']]={'commit':record['commit'],'sha256':record['sha256']}
    stderr={}
    for mode,name in [('normal','normal-case-2.stderr'),('asan','asan-case-0.stderr')]:
        path=OLD_STDERR/name;exact(OLD_STDERR_COMMIT,path)
        anchors[str(path.relative_to(ROOT))]={'commit':OLD_STDERR_COMMIT,'sha256':sha(path)}
        stderr[mode]={'path':str(path),'sha256':sha(path),'text':path.read_text()}
    metadata=json.loads((CALLER/'dependency-preparation/metadata-v2.stdout').read_text())
    return {'anchors':anchors,'input_sha256':inputs,'packages':{x['id']:{'manifest_path':x['manifest_path'],'source':x['source'],'targets':x['targets']}for x in metadata['packages']},'resolve':metadata['resolve'],'expected_stderr':stderr,'external_packages':external['packages']}
def verify(commit):
    exact(commit,HERE/'PREPARATION.json');prep=json.loads((HERE/'PREPARATION.json').read_text())
    names={str(p.relative_to(HERE))for p in HERE.rglob('*')if p.is_file()and '__pycache__'not in p.parts and p.name!='PREPARATION.json'}
    need(names==set(prep['files']),'Preflight source closure changed')
    for name,item in prep['files'].items():
        path=HERE/name;exact(commit,path);need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Preflight source changed')
    inventory=json.loads((HERE/'INPUTS.json').read_text())
    need(prepared_inputs()==inventory,'Prepared descriptor identity changed')
    for name,item in inventory['anchors'].items():exact(item['commit'],ROOT/name);need(sha(ROOT/name)==item['sha256'],'Pinned ancestor changed')
    for name,digest in inventory['input_sha256'].items():
        path=Path(name);need(path.is_file()and not path.is_symlink()and sha(path)==digest,'Prepared compiler input changed: '+name)
    for package in inventory['external_packages']:
        base=Path(package['manifest_path']).parent
        actual={str(p.relative_to(base))for p in base.rglob('*')if p.is_file()and '.git'not in p.parts}
        need(actual==set(package['files']),'External package file set changed')
    return inventory
def cargo_packages(text,inventory):
    value=json.loads(text);packages={p['id']:p for p in value['packages']}
    projection={k:{'manifest_path':v['manifest_path'],'source':v['source'],'targets':v['targets']}for k,v in packages.items()}
    need(projection==inventory['packages']and value['resolve']==inventory['resolve'],'Resolved package/feature graph changed')
    need({str(Path(p['manifest_path']).resolve())for p in packages.values()if p['source']is None}==LOCAL_MANIFESTS,'Unexpected local package')
    return packages
def artifact(text,test,target,packages):
    matches=[];manifest=(CALLER/'benchmark/Cargo.toml').resolve()
    for line in text.splitlines():
        value=json.loads(line)
        if value.get('reason')!='compiler-artifact'or Path(value['manifest_path']).resolve()!=manifest:continue
        need(value['package_id']in packages,'Unknown root artifact package')
        if value['target']['name']!='raw8_benchmark'or value['target']['kind']!=['bin']or value['profile']['test']!=test:continue
        need(Path(value['target']['src_path']).resolve()==manifest.parent/'src/main.rs','Wrong root executable source')
        if value.get('executable'):matches.append(Path(value['executable']).resolve())
    need(len(set(matches))==1,'Expected exactly one structured executable')
    path=matches[0];need(path.is_file()and path.is_relative_to(target.resolve()),'Artifact escaped fresh target');return path
def generated_inputs(texts,target,packages,consumed,inventory):
    outputs={}
    for text in texts:
        for line in text.splitlines():
            event=json.loads(line)
            if event.get('reason')!='build-script-executed':continue
            need(event['package_id']in packages,'Unknown build script package')
            path=Path(event['out_dir']).resolve();need(path.is_relative_to(target.resolve()),'Generated path escaped target')
            need(str(path)not in outputs or outputs[str(path)]==event,'Ambiguous generated ownership');outputs[str(path)]=event
    generated={}
    for path,digest in consumed.items():
        if inventory['input_sha256'].get(path)==digest:continue
        owners=[event for directory,event in outputs.items()if Path(path).is_relative_to(Path(directory))]
        need(len(owners)==1,'Unbound compiler input: '+path)
        generated[path]={'sha256':digest,'build_script_event':owners[0]}
    return generated
if __name__=='__main__':save(HERE/'INPUTS.json',prepared_inputs());print('Prepared descriptor inventory; no compilation/BF')
