"""Bind immutable proposal, compiled closure, completed tiny proof and new driver."""
import json
import re
from runtime import HERE,STAGE,PUBLIC,ROOT,PROOF,BINARY,need,sha,blob,plan
from bindings import verify as subset_verify
SUBSET_SOURCE='a620b721e92b8706c42aa25fd4be762724bc0107'
RAW='fd50847f2a4f414be8962f6e6a19039d9966ee6c'

def verify(commit):
    need(__debug__ and re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full immutable source commit without -O required')
    binaries,compiled=subset_verify(SUBSET_SOURCE);need(binaries['native']==BINARY,'Unexpected native executable')
    archive=STAGE/'PREFLIGHT_ARCHIVE.json';need(archive.read_bytes()==blob(archive,PROOF),'Changed tiny proof archive')
    files=json.loads(archive.read_text())['files'];need(len(files)==20,'Wrong focused proof cardinality')
    for name,item in files.items():
        path=STAGE/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,PROOF),'Changed passed subset proof '+name)
    proof=json.loads((STAGE/'validation-v1/metadata.json').read_text());need(proof['complete']is True and proof['tiny_rows']==16 and proof['semantic_geometries']==8 and proof['invalid_seed_CLIs']==2 and len(proof['commands'])==8 and all(x['complete']for x in proof['commands']),'Incomplete passed subset proof')
    need(proof['binaries']['native']==dict(path=str(BINARY),sha256=plan.BINARY_SHA),'Changed tested performance binary')
    raw=PUBLIC/'screening/results-v1/results.csv';need(raw.read_bytes()==blob(raw,RAW),'Changed training geometry source')
    prep=HERE/'PREPARATION.json';need(prep.read_bytes()==blob(prep,commit),'Changed formal source descriptor')
    for name,item in json.loads(prep.read_text())['files'].items():
        path=HERE/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,commit),'Changed formal source '+name)
    return compiled,proof
