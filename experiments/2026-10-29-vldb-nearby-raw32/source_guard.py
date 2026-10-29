"""Pin reviewed source, inherited public proof, reusable archives and actual headers."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
from checks import HERE,ROOT,PROPOSAL,need
from derive import derive

ACCURACY=ROOT/'experiments/2026-10-29-vldb-nearby-geometry/accuracy'
SHARED=ROOT/'benchmarks/vldb-raw32-stage3'
ORIGINAL=ROOT/'benchmarks/vldb-original-external'
PARENT=ROOT/'benchmarks/vldb-raw32-stage2'
sys.path.insert(0,str(ACCURACY))
from nearby_accuracy_guard import verify as inherited_verify

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def exact(commit,path):
    need(Path(path).read_bytes()==subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT),'Committed source drift '+str(path))
def verify(commit):
    need(__debug__ and re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full immutable source commit and active guards required')
    prep=HERE/'PREPARATION.json';exact(commit,prep);local=json.loads(prep.read_text())['files']
    for name,digest in local.items():need(sha(HERE/name)==digest,'Local source drift');exact(commit,HERE/name)
    pins=json.loads((HERE/'bindings.json').read_text())
    proposal=PROPOSAL/'PREPARATION.json';exact(pins['proposal_commit'],proposal)
    need(sha(proposal)==pins['proposal_manifest_sha256'],'Wrong proposal')
    for name,digest in json.loads(proposal.read_text())['files'].items():need(sha(PROPOSAL/name)==digest,'Proposal drift');exact(pins['proposal_commit'],PROPOSAL/name)
    archives,inherited= inherited_verify(pins['accuracy_source_commit'])
    need(pins['reference_binaries']==inherited['reference_binaries'],'Wrong frozen original references')
    proof=ACCURACY/'CALLER_ARCHIVE.json';exact(pins['caller_proof_commit'],proof)
    for name,digest in json.loads(proof.read_text())['files'].items():need(sha(ACCURACY/name)==digest,'Caller proof drift');exact(pins['caller_proof_commit'],ACCURACY/name)
    need(pins['accuracy_binaries']==json.loads((ACCURACY/'WORKER_FREEZE.json').read_text())['binaries'],'Wrong tested nearby reference executables')
    for name,digest in pins['files'].items():need(sha(ROOT/name)==digest,'Shared caller drift');exact(pins['source_commit'],ROOT/name)
    for group in ('reference_binaries','accuracy_binaries'):
        for item in pins[group].values():need(sha(item['path'])==item['sha256'],'Reference executable drift')
    outputs,sources=derive();descriptor=json.loads((HERE/'DERIVED.json').read_text())
    need(descriptor['source']==sources and descriptor['files']=={name:hashlib.sha256(data).hexdigest()for name,data in outputs.items()},'Namespace/source derivation drift')
    for name,data in outputs.items():need((HERE/name).read_bytes()==data,'Derived body changed')
    return archives,pins,local
def validate_inputs(headers,pins,local):
    need(headers['boost']['version']=='1_83' and len(headers['compile_commands'])==2,'Wrong TU/Boost scope')
    need({Path(e['file']).name for e in headers['compile_commands']}=={'worker.cpp','check.cpp'},'Unexpected original source rebuild')
    consumed=headers['consumed_files']
    required=[HERE/'adapters.hpp',HERE/'snapshot/visible_raw_hash.hpp',HERE/'snapshot/k12/four_sector_range12.h',
              HERE/'snapshot/reference-k12/four_sector_range12.h',SHARED/'common.hpp',SHARED/'raw_hash.hpp',SHARED/'query_loop.hpp']
    need(all(str(p)in consumed for p in required),'Missing actual raw caller input')
    for name,digest in consumed.items():
        p=Path(name);need(sha(p)==digest,'Consumed source changed')
        need(not p.is_relative_to(ROOT/'include'),'Unfrozen live production source consumed')
        if p.is_relative_to(HERE):need(local.get(str(p.relative_to(HERE)))==digest,'Unbound local header')
        if p.is_relative_to(SHARED):need(pins['files'].get(str(p.relative_to(ROOT)))==digest,'Unbound shared input')
    return consumed
