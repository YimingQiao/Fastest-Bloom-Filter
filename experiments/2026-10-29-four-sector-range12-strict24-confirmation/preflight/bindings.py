"""No-rebuild immutable proposal plus passed native/ASan caller identities."""
import json
from pathlib import Path
import re
import sys
HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=STAGE.parents[1]
PUBLIC=ROOT/'experiments/2026-10-29-four-sector-range12-screen'
sys.path.insert(0,str(PUBLIC/'screening'))
import freeze as old_freeze
from contract import need,sha,save,blob,require_lease
sys.path.insert(0,str(STAGE))
import plan
INITIAL='9c9cd9a32a3fbd6dd025f62e1055084312a0ae4b'
OLD_SOURCE='a433e307c73b46e0c1e6f011cf6b6e0d8b2c2ef3'
def verify(commit):
    need(__debug__ and re.fullmatch('[0-9a-f]{40}',commit)is not None,'Exact committed source without -O required')
    prep=STAGE/'PREPARATION.json';need(prep.read_bytes()==blob(prep,INITIAL),'Changed fixed78 proposal')
    need(len(json.loads(prep.read_text())['files'])==11,'Wrong initial proposal closure')
    for name,item in json.loads(prep.read_text())['files'].items():
        path=STAGE/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,INITIAL),'Changed initial78 source '+name)
    proposal=plan.derive();need(proposal==json.loads((STAGE/'selection.json').read_text()),'Changed derived seeds/union/domains')
    native,proof=old_freeze.verify(OLD_SOURCE)
    asan=Path('/tmp/fastest-bf-k12-actual-caller-v2/asan/actual/benchmark')
    need(sha(native)==plan.BINARY_SHA and sha(asan)==proof['binary_sha256'][str(asan)]=='062802b286016cc20ee8a4ecea2d7a4cb11b6943fa798d65d446386a516c031e','Wrong tested binary')
    local=HERE/'PREPARATION.json';need(local.read_bytes()==blob(local,commit),'Changed committed subset preflight')
    for name,item in json.loads(local.read_text())['files'].items():
        path=HERE/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,commit),'Changed subset preflight source '+name)
    return dict(native=native,asan=asan),proof
