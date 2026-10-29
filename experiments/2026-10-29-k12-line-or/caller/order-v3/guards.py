"""Bind the passed kernel proof and this pre-data caller-only change."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;CALLER=HERE.parent;BASE=CALLER.parent;ROOT=HERE.parents[3]
sys.path.insert(0,str(CALLER))
from contract import need,CASES,SEMANTICS,TYPES,rows,command
from source_guard import sha,exact
PROOF='a029583a66936b1bf061df4ee8699cb3514117ca'
PROOF_SHA='95f56341cc1621f7996704cc70cf5086a168bd9008f85a39bdbebe293a55d01e'

def verify(commit):
    archive=BASE/'COMPLETE_PROOF_ARCHIVE.json';exact(PROOF,archive);need(sha(archive)==PROOF_SHA,'Old proof changed')
    pins={}
    for name,item in json.loads(archive.read_text())['files'].items():
        p=BASE/name;need(p.resolve().is_relative_to(BASE)and sha(p)==item['sha256']and p.stat().st_size==item['bytes'],'Old proof artifact changed');exact(PROOF,p);pins[str(p)]=sha(p)
    pins[str(archive)]=sha(archive)
    manifest=HERE/'PREPARATION.json';exact(commit,manifest)
    for name,item in json.loads(manifest.read_text())['files'].items():
        p=HERE/name;need(p.resolve().is_relative_to(HERE)and sha(p)==item['sha256']and p.stat().st_size==item['bytes'],'V3 source changed');exact(commit,p);pins[str(p)]=sha(p)
    pins[str(manifest)]=sha(manifest)
    proof=json.loads((CALLER/'COMPILED_PROOF.json').read_text())
    for group in ('all_binary_sha256','compiler_consumed_input_sha256'):
        for path,digest in proof[group].items():need(sha(path)==digest,'Reused proof input changed')
    return pins

def expected_order(case,reverse):
    n,q=1<<case['power'],1<<case['qp'];present=q//100*case['hit']+min(q%100,case['hit']);mask=(1<<64)-1
    z=(case['seed']+0x9e3779b97f4a7c15*(n+present+q))&mask
    z=((z^(z>>30))*0xbf58476d1ce4e5b9)&mask;z=((z^(z>>27))*0x94d049bb133111eb)&mask;z^=z>>31
    result=list(TYPES)if z&1 else list(reversed(TYPES))
    return list(reversed(result))if reverse else result

def validate(text,index,reverse):
    case=CASES[index];values=rows(text,case)
    need([r['filter']for r in values]==expected_order(case,reverse),'Wrong explicit filter order')
    old=rows((CALLER/'validation-v2'/f'native-caller-{index}.stdout').read_text(),case)
    previous={r['filter']:tuple(r[k]for k in SEMANTICS)for r in old}
    need(all(tuple(r[k]for k in SEMANTICS)==previous[r['filter']]for r in values),'Original workload/output changed')
    return values
