"""Bind the immutable proposal, corrected preflight, proof and formal runner."""
import json
from pathlib import Path
import re
from contract import HERE,STAGE,need,sha,blob,preflight_verify,protocol,commands

PREFLIGHT='0ed9079d933eff0a5f6b114fd2ca034e9c6d1c09'
PROOF='a81a9ab4fef493f575d4c3ecc1a6e42b2bcb6c8c'

def verify(commit):
    need(__debug__ and re.fullmatch(r'[0-9a-f]{40}',commit)is not None,'Use exact committed source without -O')
    binaries=preflight_verify(PREFLIGHT)
    manifest=STAGE/'PREFLIGHT_ARCHIVE.json'
    need(manifest.read_bytes()==blob(PROOF,manifest),'Changed completed preflight descriptor')
    for name,entry in json.loads(manifest.read_text())['files'].items():
        path=STAGE/name
        need(sha(path)==entry['sha256'] and path.stat().st_size==entry['bytes']and path.read_bytes()==blob(PROOF,path),'Changed preflight evidence')
    proof=json.loads((STAGE/'VALIDATED_BINARIES.json').read_text())
    need(proof['complete']and proof['source_commit']==PREFLIGHT and proof['tiny_rows']==8 and proof['compiler_runs']==proof['heldout_seed_runs']==0,'Incomplete/wrong proof')
    need(proof['binaries']['native']['path']==str(binaries['native']) and proof['binaries']['native']['sha256']==sha(binaries['native']),'Wrong actual native executable')
    published=json.loads((HERE/'protocol.json').read_text())
    need(published['runtime_protocol']==protocol() and published['corrected_cases']==commands(),'Published runtime/commands differ')
    need(published['proof_commit']==PROOF and published['cpu']==3 and published['socket']==1 and published['expected_rows']==24 and published['expected_cases']==12,'Changed finite execution scope')
    prep=HERE/'PREPARATION.json'
    need(prep.read_bytes()==blob(commit,prep),'Changed formal source descriptor')
    for name,entry in json.loads(prep.read_text())['files'].items():
        path=HERE/name
        need(sha(path)==entry['sha256']and path.stat().st_size==entry['bytes']and path.read_bytes()==blob(commit,path),'Changed formal source '+name)
    return binaries['native'],proof
