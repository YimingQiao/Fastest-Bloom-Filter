"""Bind reviewed source/resolution and actual Cargo inputs before any filter execution."""
import hashlib,json,re,subprocess,tarfile,tomllib
from pathlib import Path
HERE=Path(__file__).resolve().parent;CALLER=HERE.parent;ROOT=CALLER.parents[1]
SOURCE='d3da7464052c4f3a5c298703654e2921b37b319a'
SOURCE_MANIFEST='e2d22400cc40e4a4ef23dd5abfeee238f90d0efbc891e1ccc6160b07b37cc623'
RESOLUTION='d441b2a9ce08fb3b8e5d64fda0b9808924edebe8'
RESOLUTION_MANIFEST='3c7e23981cf83fc23bd118eacd03848c97f612ba77babfaaf018eaba81eecefd'
PARENT=ROOT/'experiments/2026-10-29-fastbloom-rs-raw8-caller'
REFERENCE='73ff8ed51da5b54a3d19b76ab5da403291c4d51f'
PREFLIGHT_SOURCE='8d533d9711f5d4cb30f7496dcf29860b35359bca'
FAILED='35e22898d0a4afa23113b190617a7bce09e8660d'
TARGET=Path('/tmp/fastest-bf-poppy-natural-raw-v2-cpu3');OUTPUT=CALLER/'validation-v2'
LOCAL_MANIFESTS={str((p/'Cargo.toml').resolve())for p in [CALLER/'benchmark',PARENT/'native',PARENT/'upstream/fastbloom-rs',ROOT/'build/poppy-source/poppy']}
def need(ok,message):
    if not ok:raise ValueError(message)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def exact(commit,path):
    need(re.fullmatch('[0-9a-f]{40}',commit),'Full immutable commit required')
    path=Path(path).resolve();need(path.is_relative_to(ROOT),'Repository path escaped')
    need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),'Committed source changed: '+str(path))
def add_cc_source_members(tree):
    """Four original crate members omitted by a historical directory-name filter."""
    spec=json.loads((HERE/'CC_SOURCE_MEMBERS.json').read_text())
    need(set(spec['members'])=={'cc-1.10.0/src/target/'+n for n in ['apple.rs','generated.rs','llvm.rs','parser.rs']},'Only four prescribed cc source members allowed')
    package=tree['package_sources'][spec['package_id']];base=Path(package['manifest_path']).parent
    lock=tomllib.loads((CALLER/'benchmark/Cargo.lock').read_text())
    matches=[p for p in lock['package']if p['name']=='cc'and p['version']=='1.10.0'and p.get('source')=='registry+https://github.com/rust-lang/crates.io-index']
    need(len(matches)==1 and matches[0]['checksum']==spec['archive_sha256'],'Crate archive not bound to frozen lock')
    archive=Path(spec['archive_path']);need(sha(archive)==spec['archive_sha256'],'Crate archive checksum changed')
    with tarfile.open(archive,'r:gz')as compressed:
        for name,item in spec['members'].items():
            matching=[m for m in compressed.getmembers()if m.name==name]
            need(len(matching)==1 and matching[0].isfile(),'Missing/ambiguous regular crate member')
            data=compressed.extractfile(matching[0]).read();path=base/Path(name).relative_to('cc-1.10.0')
            need(len(data)==item['bytes']and hashlib.sha256(data).hexdigest()==item['sha256']and path.read_bytes()==data,'Crate member bytes differ')
            need(str(path)not in tree['file_sha256']and str(path)not in package['files'],'Expected omitted member was already inventoried')
            tree['file_sha256'][str(path)]=item['sha256'];package['files'].append(str(path))
    package['files'].sort();need(len(tree['file_sha256'])==4487,'Repaired source count differs')
    return {str(archive):spec['archive_sha256']}
def prepared_inputs():
    inputs={};anchors={}
    def anchor(commit,path,digest=None):
        exact(commit,path);actual=sha(path);need(digest is None or actual==digest,'Anchor digest changed')
        anchors[str(path.relative_to(ROOT))]={'commit':commit,'sha256':actual};inputs[str(path.resolve())]=actual
    for name,commit,digest,count in [('PREPARATION.json',SOURCE,SOURCE_MANIFEST,38),('RESOLUTION_ARCHIVE.json',RESOLUTION,RESOLUTION_MANIFEST,16)]:
        manifest=CALLER/name;anchor(commit,manifest,digest);value=json.loads(manifest.read_text());need(len(value['files'])==count,'Prepared archive coverage changed')
        for relative,item in value['files'].items():
            path=CALLER/relative;anchor(commit,path,item['sha256']);need(path.stat().st_size==item['bytes'],'Prepared artifact length changed')
    original=json.loads((CALLER/'INPUT_SOURCE_ANCHORS.json').read_text())
    for relative,item in original['parent'].items():anchor(item['commit'],ROOT/relative,item['sha256'])
    # Bind all original driver bytes and the zero-execution failure as ancestors.
    for directory,manifest_name,commit,count in [(CALLER/'preflight','PREPARATION.json',PREFLIGHT_SOURCE,13),(CALLER,'FAILED_V1_ARCHIVE.json',FAILED,7)]:
        descriptor=directory/manifest_name;anchor(commit,descriptor);prior=json.loads(descriptor.read_text());need(len(prior['files'])==count,'Prior evidence coverage changed')
        for name,item in prior['files'].items():anchor(commit,directory/name,item['sha256'])
    tree=json.loads((CALLER/'resolution-v1/prepared-package-trees.json').read_text())
    need(tree['package_count']==87 and tree['file_count']==4483,'Prepared dependency coverage changed')
    inputs.update(add_cc_source_members(tree))
    for name,digest in tree['file_sha256'].items():
        need(name not in inputs or inputs[name]==digest,'Prepared source descriptors disagree');inputs[name]=digest
    for record in json.loads((HERE/'HELPERS.json').read_text()):
        parent=ROOT/record['path'];anchor(record['commit'],parent,record['sha256'])
        need((HERE/record['destination']).read_bytes()==parent.read_bytes(),'Helper copy drift')
    references={};stderr={}
    for mode in ['normal','asan']:
        path=PARENT/'validation-v1'/f'{mode}-case-0.stdout';anchor(REFERENCE,path)
        references[mode]={'path':str(path),'sha256':sha(path)}
        path=path.with_suffix('.stderr');anchor(REFERENCE,path)
        stderr[mode]={'path':str(path),'sha256':sha(path),'text':path.read_text()}
    metadata=json.loads((CALLER/'resolution-v1/cargo-metadata.stdout').read_text())
    return dict(anchors=anchors,input_sha256=inputs,poppy=original['poppy'],package_sources=tree['package_sources'],
        packages={x['id']:{'manifest_path':x['manifest_path'],'source':x['source'],'targets':x['targets']}for x in metadata['packages']},
        resolve=metadata['resolve'],workspace_root=metadata['workspace_root'],workspace_members=metadata['workspace_members'],
        expected_stderr=stderr,parent_reference=references)
def verify(commit):
    exact(commit,HERE/'PREPARATION.json');prep=json.loads((HERE/'PREPARATION.json').read_text())
    names={str(p.relative_to(HERE))for p in HERE.rglob('*')if p.is_file()and '__pycache__'not in p.parts and p.name!='PREPARATION.json'}
    need(names==set(prep['files']),'Preflight source closure changed')
    for name,item in prep['files'].items():
        path=HERE/name;exact(commit,path);need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Preflight source changed')
    inventory=json.loads((HERE/'INPUTS.json').read_text());need(prepared_inputs()==inventory,'Prepared descriptor identity changed')
    for name,item in inventory['anchors'].items():exact(item['commit'],ROOT/name);need(sha(ROOT/name)==item['sha256'],'Pinned ancestor changed')
    for name,digest in inventory['input_sha256'].items():
        path=Path(name);need(path.is_file()and not path.is_symlink()and sha(path)==digest,'Prepared input changed: '+name)
    poppy=inventory['poppy'];base=Path(poppy['directory'])
    need(subprocess.check_output(['git','rev-parse','HEAD'],cwd=base,text=True).strip()==poppy['commit'],'Pinned Poppy HEAD changed')
    for name,digest in poppy['files'].items():
        path=base/name;need(sha(path)==digest and path.read_bytes()==subprocess.check_output(['git','show',poppy['commit']+':'+name],cwd=base),'Pinned Poppy source changed')
    for package in inventory['package_sources'].values():
        base=Path(package['manifest_path']).parent
        # Dependency package trees are closed. The root package has only its
        # fixed source files plus the lock; target/output live outside it.
        actual={str(p.resolve())for p in base.rglob('*')if p.is_file()and '.git'not in p.parts}
        need(actual==set(package['files']),'Package source file set changed: '+str(base))
    return inventory
def cargo_packages(text,inventory):
    value=json.loads(text);packages={p['id']:p for p in value['packages']}
    projection={k:{'manifest_path':v['manifest_path'],'source':v['source'],'targets':v['targets']}for k,v in packages.items()}
    need(projection==inventory['packages']and value['resolve']==inventory['resolve'],'Resolved package/feature graph changed')
    need(value['workspace_root']==inventory['workspace_root']and value['workspace_members']==inventory['workspace_members'],'Structured Cargo workspace changed')
    need({str(Path(p['manifest_path']).resolve())for p in packages.values()if p['source']is None}==LOCAL_MANIFESTS,'Unexpected local package')
    # Only structured members of this metadata workspace receive its alternative
    # relative-dep-info base. External/local dependencies retain package roots.
    for member in value['workspace_members']:packages[member]['_workspace_root']=value['workspace_root']
    return packages
def artifact(text,test,target,packages):
    matches=[];manifest=(CALLER/'benchmark/Cargo.toml').resolve()
    for line in text.splitlines():
        value=json.loads(line)
        if value.get('reason')!='compiler-artifact'or Path(value['manifest_path']).resolve()!=manifest:continue
        known=packages.get(value['package_id']);need(known is not None and Path(known['manifest_path']).resolve()==manifest,'Unknown root artifact package')
        need(any(value['target']==t for t in known['targets']),'Root artifact target absent from structured package')
        if value['target']['name']!='poppy_raw_benchmark'or value['target']['kind']!=['bin']or value['profile']['test']!=test:continue
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
