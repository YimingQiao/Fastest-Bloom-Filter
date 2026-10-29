"""Bind passed actualcaller9ace and prior semantic controls to exact Git blobs."""
import json
import re
from pathlib import Path
from contract import HERE,STAGE,ROOT,PARENT,need,sha,blob,protocol
PROOF='e150be33b95a22dca9b75175e6174b9555c82393'
INITIAL='2263cf29ebc87d589b49ca015133312993b7db73'
BINARY_SHA='9aceea39f8f57564409806f911ddcf2ec6c17ff623a5132acbb609b11ad05149'
def verify(commit):
    need(__debug__ and re.fullmatch(r'[0-9a-f]{40}',commit)is not None,'Use exact source commit without -O')
    archive=STAGE/'CALLER_ARCHIVE.json';need(archive.read_bytes()==blob(archive,PROOF),'Changed completed caller archive')
    local=json.loads(archive.read_text())['files'];need(len(local)==194,'Wrong actualcaller archive')
    for name,item in local.items():
        path=STAGE/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,PROOF),'Changed compiled proof '+name)
    proof=json.loads((STAGE/'CALLER_FREEZE.json').read_text())
    need(proof['commands']==56 and proof['actual_tiny_rows']==234 and proof['reference_tiny_rows']==75 and proof['independent_oracle_records']==9,'Incomplete focused proof')
    for name,digest in proof['source_sha256'].items():need(sha(ROOT/name)==digest,'Changed prepared input '+name)
    for name,digest in proof['consumed_inputs_sha256'].items():need(sha(Path(name))==digest,'Changed actual compiler input '+name)
    for name,digest in proof['binary_sha256'].items():need(sha(Path(name))==digest,'Changed tested binary '+name)
    binary=Path(proof['performance_binary']);need(sha(binary)==proof['performance_binary_sha256']==BINARY_SHA,'Wrong actual measurement binary')
    for path in[PARENT/'screen/results.csv',PARENT/'SCREEN_RESULTS_ARCHIVE.json']:
        need(path.read_bytes()==blob(path,INITIAL),'Changed prior142 semantic anchor')
    parent_archive=json.loads((PARENT/'SCREEN_RESULTS_ARCHIVE.json').read_text())
    need(parent_archive['rows']==142 and parent_archive['case_count']==13,'Wrong previous semantic matrix')
    published=json.loads((HERE/'protocol.json').read_text())
    need(published['original_protocol']==protocol() and published['proof_commit']==PROOF and published['performance_binary_sha256']==BINARY_SHA,'Changed bounded runtime protocol')
    prep=HERE/'PREPARATION.json';need(prep.read_bytes()==blob(prep,commit),'Changed formal driver descriptor')
    for name,item in json.loads(prep.read_text())['files'].items():
        path=HERE/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,commit),'Changed formal source '+name)
    return binary,proof
