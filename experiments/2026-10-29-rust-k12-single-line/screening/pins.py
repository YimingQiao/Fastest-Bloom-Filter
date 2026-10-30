"""Immutable proposal, passed actual caller and real source/binary identities."""
import hashlib,json,os,platform,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1]
PROPOSAL='0c0eb382a817245e379b01339ecd71b747bd5cea'
PROOF='2adefb87cd03051df163803e8710a5f0375573b1'
PRIOR_RAW='ab0b27067ae60f9e4a19c6c5aedfadbd8e5bb6e5'
PRIOR=ROOT/'experiments/2026-10-29-four-sector-range12-rust-screen/results-v1'
sys.path.append(str(STAGE/'caller/preflight'))
from source_guard import require_lease
ENV_KEYS=['LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','MALLOC_ARENA_MAX','ASAN_OPTIONS','UBSAN_OPTIONS','GLIBC_TUNABLES','RUSTFLAGS','CARGO_ENCODED_RUSTFLAGS','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER']

def need(ok,why):
    if not ok:raise ValueError(why)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):
    path=Path(path);temp=path.with_name(path.name+'.tmp');temp.write_text(json.dumps(value,indent=2,allow_nan=False)+'\n');temp.replace(path)
def full_commit(commit):need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full immutable source commit required')
def git_blob(commit,name):return subprocess.check_output(['git','show',commit+':'+name],cwd=ROOT)
def environment():
    values={k:os.environ.get(k)for k in ENV_KEYS};need(not any(values.values()),'Unfrozen loader/environment override');return values
def host():
    cpu=Path('/sys/devices/system/cpu/cpu3/topology');model=next(x.split(':',1)[1].strip()for x in Path('/proc/cpuinfo').read_text().splitlines()if x.startswith('model name'))
    return dict(uname=list(platform.uname()),cpu_model=model,cpu=3,physical_package_id=(cpu/'physical_package_id').read_text().strip(),core_id=(cpu/'core_id').read_text().strip(),numa_policy='not set by runner')
def local_files():return sorted(p for p in HERE.iterdir()if p.is_file()and p.name not in ['freeze.json'])
def inherited():
    inputs={};anchors={}
    def add(commit,path):
        name=str(path.relative_to(ROOT));digest=sha(path);need(hashlib.sha256(git_blob(commit,name)).hexdigest()==digest,'Committed parent drift '+name)
        if name in inputs:need(inputs[name]==digest,'Conflicting source pins')
        inputs[name]=digest;anchors[name]=commit
    archive=STAGE/'PREFLIGHT_ARCHIVE.json';add(PROOF,archive)
    for name,record in json.loads(archive.read_text())['files'].items():
        path=STAGE/name;need(sha(path)==record['sha256']and path.stat().st_size==record['bytes'],'Passed proof archive changed');add(PROOF,path)
    compiled=STAGE/'proof/COMPILED_FREEZE.json';data=json.loads(compiled.read_text())
    for name,digest in data['source_inputs_sha256'].items():
        path=ROOT/name;need(sha(path)==digest,'Prepared source changed');add(PROOF,path)
    # Prior completed inputs/quality only. No prior latency enters this protocol.
    for name in ['ARCHIVE.json','metadata.json','results.csv','quality.json']:
        add(PRIOR_RAW,PRIOR/name)
    external={}
    tree=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes-screen/external-tree.json'
    for dep in json.loads(tree.read_text())['dependencies']:
        for name,digest in dep['sha256'].items():
            path=(Path(dep['directory'])/name).resolve();need(sha(path)==digest,'External pinned tree changed');external[str(path)]=digest
    return inputs,anchors,external,data

def make_freeze():
    inputs,anchors,external,compiled=inherited()
    return dict(scope='Fixed72 internal K12 safe-single-line old/new/Range comparison; no calibration',proposal_commit=PROPOSAL,proof_commit=PROOF,prior_raw_commit=PRIOR_RAW,
      inherited_input_sha256=inputs,inherited_git_anchors=anchors,external_sources_sha256=external,
      files={p.name:dict(sha256=sha(p),bytes=p.stat().st_size)for p in local_files()},
      binary=compiled['performance_binary'],binary_sha256=compiled['performance_binary_sha256'],binaries_sha256=compiled['binaries_sha256'],compiled_inputs_sha256=compiled['compiler_consumed_inputs_sha256'],host=host(),environment=environment())

def verify(commit):
    need(__debug__,'Python -O forbidden');full_commit(commit);path=HERE/'freeze.json';need(path.read_bytes()==git_blob(commit,str(path.relative_to(ROOT))),'Uncommitted execution freeze')
    freeze=json.loads(path.read_text());need(set(freeze['files'])=={p.name for p in local_files()},'Changed formal runner source closure')
    for name,record in freeze['files'].items():
        p=HERE/name;need(sha(p)==record['sha256']and p.stat().st_size==record['bytes'],'Formal source changed');need(p.read_bytes()==git_blob(commit,str(p.relative_to(ROOT))),'Uncommitted formal source')
    for name,digest in freeze['inherited_input_sha256'].items():
        need(sha(ROOT/name)==digest and hashlib.sha256(git_blob(freeze['inherited_git_anchors'][name],name)).hexdigest()==digest,'Inherited exact source/evidence drift '+name)
    for name,digest in freeze['external_sources_sha256'].items():need(sha(Path(name))==digest,'External tree changed')
    for group in freeze['compiled_inputs_sha256'].values():
        for name,digest in group.items():need(sha(Path(name))==digest,'Actual compiled input changed')
    for name,digest in freeze['binaries_sha256'].items():need(sha(Path(name))==digest,'Passed actual executable changed')
    need(sha(Path(freeze['binary']))==freeze['binary_sha256']=='64ecc64b307f32dc5ff215720c608d9423abdc55d54536034ecbebe0334f91a3','Wrong performance executable')
    need(host()==freeze['host']and environment()==freeze['environment'],'Host/environment changed')
    return freeze
