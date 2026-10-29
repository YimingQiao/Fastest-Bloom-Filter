"""Only extend source provenance; the measured worker/runner paths stay exact."""
import hashlib,json,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
BASE=HERE.parent
RETRY=BASE/'retry-v2'
sys.path.insert(0,str(BASE));sys.path.insert(0,str(RETRY))
from contract import ROOT,need
from source_guard import sha,committed
from source_guard_v2 import verify as retry_verify

def verify(commit,live=True):
    result=retry_verify(commit,live=live)
    inventory=json.loads((HERE/'PREPARATION.json').read_text())
    for name,want in inventory['files'].items():
        path=ROOT/name
        need(sha(path)==want and hashlib.sha256(committed(commit,path)).hexdigest()==want,'Uncommitted screen-entry guard: '+name)
    need(committed(commit,HERE/'PREPARATION.json')==(HERE/'PREPARATION.json').read_bytes(),'Screen-entry inventory drift')
    return result

def check_proof(freeze,metadata,retry_sha,reused_binary_sha,modern_source_sha):
    need(metadata['complete'] and metadata['all_sources_unchanged'],'Incomplete v2 proof')
    need(metadata['source_commit']==freeze['preparation_commit'],'Wrong proof preparation commit')
    need(metadata['retry_preparation_sha256']==retry_sha,'V2 source inventory differs from successful proof')
    need(metadata['binaries']==freeze['binaries'],'Proof and frozen binaries disagree')
    need(freeze['binaries']['native/legacy']['sha256']==reused_binary_sha,'Native legacy was not reused exactly')
    need(freeze['consumed_inputs'][str(RETRY/'modern.cpp')]==modern_source_sha,'Modern did not consume the one-line retry source')

def checked_freeze(original,commit):
    freeze=original(commit)
    metadata=json.loads((ROOT/freeze['proof_metadata']).read_text())
    reuse=json.loads((RETRY/'reuse.json').read_text())
    check_proof(freeze,metadata,sha(RETRY/'PREPARATION.json'),reuse['files'][reuse['native_legacy_binary']],sha(RETRY/'modern.cpp'))
    retry_verify(freeze['preparation_commit'],live=False)
    return freeze
