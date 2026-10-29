"""Exact source/proof pins for the additive untimed public caller."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
from contract import HERE,need
from derive_selection import derive

STAGE=HERE.parent;ROOT=HERE.parents[2]
SHARED=ROOT/'benchmarks/vldb-raw32-stage3'
ORIGINAL=ROOT/'benchmarks/vldb-original-external'
PARENT=ROOT/'benchmarks/vldb-raw32-stage2'
NEARBY_PROOF='11584813b8f300d0405c58d458bbf901c996468b'
NEARBY_SOURCE='9ece4af4db5089417aac119fe5166266b2716821'
SHARED_SOURCE='6baeaeb88c89b9a4eed71f0a0aa1263c613289bd'
sys.path.insert(0,str(STAGE))
from nearby_guard import verify as geometry_verify

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def exact(commit,path):
    need(Path(path).read_bytes()==subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT),
         'Committed source/proof drift '+str(path))
def verify(commit):
    need(__debug__ and re.fullmatch(r'[0-9a-f]{40}',commit)is not None,'Exact full source commit and active checks required')
    prep=HERE/'PREPARATION.json';exact(commit,prep)
    for name,digest in json.loads(prep.read_text())['files'].items():
        path=HERE/name;need(sha(path)==digest,'New caller source drift');exact(commit,path)
    archives=geometry_verify(NEARBY_SOURCE)
    descriptor=STAGE/'PREFLIGHT_ARCHIVE.json';exact(NEARBY_PROOF,descriptor)
    need(sha(descriptor)==json.loads((HERE/'selection.json').read_text())['nearby93_archive_sha256'],'Wrong geometry proof')
    for name,digest in json.loads(descriptor.read_text())['files'].items():
        path=STAGE/name;need(sha(path)==digest,'Geometry proof drift');exact(NEARBY_PROOF,path)
    need(derive()==json.loads((HERE/'selection.json').read_text()),'Fixed geometry selection changed')
    inputs=json.loads((HERE/'bindings.json').read_text())
    need(inputs['source_commit']==SHARED_SOURCE,'Wrong shared caller source')
    for name,digest in inputs['files'].items():
        path=ROOT/name;need(sha(path)==digest,'Shared caller drift');exact(SHARED_SOURCE,path)
    freeze=SHARED/'WORKER_FREEZE.json';exact(SHARED_SOURCE,freeze)
    old=json.loads(freeze.read_text())['binaries']
    for backend in ('native','native-asan'):
        item=old[backend+'/legacy'];need(item==inputs['reference_binaries'][backend],'Wrong reference binary')
        need(sha(item['path'])==item['sha256'],'Reference binary drift')
    return archives,inputs

def validate_inputs(headers,source_files):
    need(headers['boost']['version']=='1_83'and len(headers['compile_commands'])==1,'Wrong compiler/header context')
    files=headers['consumed_files']
    required=[HERE/'worker.cpp',STAGE/'nearby_geometry.hpp',SHARED/'common.hpp',
              SHARED/'query_loop.hpp',SHARED/'legacy-adapters.hpp',ORIGINAL/'raw32_workload.hpp']
    need(all(str(p)in files for p in required),'Actual caller did not consume its frozen shared contract')
    for name,digest in files.items():
        p=Path(name);need(sha(p)==digest,'Consumed file changed')
        need(not p.is_relative_to(ROOT/'include'),'Unfrozen live native header used')
        if p.is_relative_to(SHARED):
            need(source_files.get(str(p.relative_to(ROOT)))==digest,'Unbound shared input')
    return files
