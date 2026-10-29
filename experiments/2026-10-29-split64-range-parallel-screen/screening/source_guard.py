"""Bind this driver to exact committed artifacts and all consumed native inputs."""
import hashlib
import json
import subprocess
from pathlib import Path

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=HERE.parents[2]

def sha(path):
    h=hashlib.sha256()
    with Path(path).open('rb') as f:
        for chunk in iter(lambda:f.read(1024*1024),b''): h.update(chunk)
    return h.hexdigest()

def require(ok,message):
    if not ok: raise ValueError(message)

def verify(commit):
    commit=subprocess.check_output(['git','rev-parse',commit+'^{commit}'],cwd=ROOT,text=True).strip()
    freeze=json.loads((HERE/'freeze.json').read_text())
    local=dict(freeze['local_files_sha256'])
    local[str((HERE/'freeze.json').relative_to(ROOT))]=sha(HERE/'freeze.json')
    for rel,digest in local.items():
        require(sha(ROOT/rel)==digest,'Changed local artifact: '+rel)
        data=subprocess.check_output(['git','show',commit+':'+rel],cwd=ROOT)
        require(hashlib.sha256(data).hexdigest()==digest,'Artifact is not the exact committed blob: '+rel)
    preflight=json.loads((STAGE/'PREFLIGHT_FREEZE.json').read_text())
    sources=dict(preflight['source_sha256'])
    sources.update(preflight['reused_native_evidence_sha256'])
    for rel,digest in sources.items(): require(sha(ROOT/rel)==digest,'Changed consumed source/build evidence: '+rel)
    for rel,digest in preflight['binaries_sha256'].items(): require(sha(ROOT/rel)==digest,'Changed native/reference binary: '+rel)
    require(sha(preflight['benchmark'])==preflight['benchmark_sha256']==freeze['benchmark_sha256'],'Changed selected benchmark')
    return dict(commit=commit,local_files=len(local),source_and_build_evidence=len(sources),binaries=len(preflight['binaries_sha256']),
                freeze_sha256=sha(HERE/'freeze.json'),benchmark=preflight['benchmark'],benchmark_sha256=preflight['benchmark_sha256'])
