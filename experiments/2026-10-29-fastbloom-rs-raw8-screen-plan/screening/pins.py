"""Immutable source, completed proof and actual executable binding."""
import hashlib,json,os,platform,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;PLAN=HERE.parent;ROOT=PLAN.parents[1]
CALLER=ROOT/'experiments/2026-10-29-fastbloom-rs-raw8-caller'
PROPOSAL='a52429020ae07b01c95fc33caf669b9a09162b32'
PROOF='73ff8ed51da5b54a3d19b76ab5da403291c4d51f'
DRIVER='efb5142fdc3e5cb62d68004b1f8ca1d75bd8728e'
ENV_KEYS=['LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','MALLOC_ARENA_MAX','GLIBC_TUNABLES','ASAN_OPTIONS','UBSAN_OPTIONS','RUSTFLAGS','RUSTDOCFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CARGO_TARGET_DIR','RUSTC','RUSTDOC','RUSTUP_TOOLCHAIN','CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER']
def need(ok,message):
 if not ok:raise ValueError(message)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,value):Path(p).write_text(json.dumps(value,indent=2)+'\n')
def blob(commit,p):return subprocess.check_output(['git','show',commit+':'+str(Path(p).relative_to(ROOT))],cwd=ROOT)
def host():return dict(node=platform.node(),system=platform.system(),machine=platform.machine(),release=platform.release())
def environment():return {key:os.environ.get(key)for key in ENV_KEYS}
def prepare():
 inputs={};anchors={}
 def anchor(path,commit,digest=None):
  path=Path(path);data=blob(commit,path);expected=hashlib.sha256(data).hexdigest();need(path.read_bytes()==data,'Changed committed input '+str(path));need(digest is None or digest==expected,'Manifest/Git hash disagreement')
  inputs[str(path)]=expected;anchors[str(path)]=dict(commit=commit,sha256=expected)
 for manifest,commit,base in [(PLAN/'PREPARATION.json',PROPOSAL,PLAN),(CALLER/'proof-final/MANIFEST.json',PROOF,CALLER)]:
  anchor(manifest,commit)
  for name,record in json.loads(manifest.read_text())['files'].items():anchor(base/name,commit,record['sha256'])
 descriptor=CALLER/'preflight/INPUTS.json';anchor(descriptor,DRIVER)
 d=json.loads(descriptor.read_text())
 for path,digest in d['input_sha256'].items():need(path not in inputs or inputs[path]==digest,'Conflicting prepared input');inputs[path]=digest
 for name,record in d['anchors'].items():anchor(ROOT/name,record['commit'],record['sha256'])
 pre=CALLER/'preflight/PREPARATION.json';anchor(pre,DRIVER)
 for name,record in json.loads(pre.read_text())['files'].items():anchor(pre.parent/name,DRIVER,record['sha256'])
 proof=json.loads((CALLER/'proof-final/freeze.json').read_text());need(proof['complete']and proof['manual_review_complete'],'Incomplete actual proof')
 for values in [proof['binaries_sha256'],proof['toolchains_sha256'],*proof['compiler_inputs_sha256'].values()]:
  for path,digest in values.items():need(path not in inputs or inputs[path]==digest,'Conflicting input proof');inputs[path]=digest
 p=json.loads((PLAN/'protocol.json').read_text());inputs[p['child_placement_prefix'][0]]=p['numactl_sha256']
 need(inputs[p['normal_binary']]==p['normal_binary_sha256'],'Wrong measured binary')
 reused=json.loads((HERE/'REUSED.json').read_text());original=blob(DRIVER,CALLER/'preflight/contract.py').decode()
 import difflib
 need(sha(HERE/'row_guard.py')==reused['derived_sha256'],'Derived guard hash')
 need(hashlib.sha256(original.encode()).hexdigest()==reused['parent_sha256'],'Parent guard hash')
 need(''.join(difflib.unified_diff(original.splitlines(True),(HERE/'row_guard.py').read_text().splitlines(True),fromfile='preflight/contract.py',tofile='screening/row_guard.py'))==(HERE/'row-guard.patch').read_text(),'Guard derivation patch drift')
 for path,digest in inputs.items():need(sha(path)==digest,'Prepared/actual input drift '+path)
 own={str(path.relative_to(HERE)):sha(path)for path in sorted(HERE.iterdir())if path.is_file()and path.name not in ['freeze.json','PREPARATION.json']}
 return dict(proposal_commit=PROPOSAL,proof_commit=PROOF,own_source_sha256=own,input_sha256=inputs,committed_anchors=anchors,host=host(),expected_environment={key:None for key in ENV_KEYS},binary=p['normal_binary'],binary_sha256=p['normal_binary_sha256'],expected_stderr=d['expected_stderr']['normal']['text'],no_measurement_yet=True)
def verify(source_commit):
 need(re.fullmatch('[0-9a-f]{40}',source_commit),'Full immutable source commit required')
 frozen=HERE/'freeze.json';need(frozen.read_bytes()==blob(source_commit,frozen),'Freeze is not exact committed source');d=json.loads(frozen.read_text())
 need(d['proposal_commit']==PROPOSAL and d['proof_commit']==PROOF,'Wrong source ancestry')
 for name,digest in d['own_source_sha256'].items():
  path=HERE/name;need(sha(path)==digest and hashlib.sha256(blob(source_commit,path)).hexdigest()==digest,'Formal source drift '+name)
 for path,record in d['committed_anchors'].items():need(hashlib.sha256(blob(record['commit'],Path(path))).hexdigest()==record['sha256'],'Committed ancestry drift '+path)
 for path,digest in d['input_sha256'].items():need(sha(path)==digest,'Actual input/binary/tool drift '+path)
 need(host()==d['host'],'Different measured host')
 return d
