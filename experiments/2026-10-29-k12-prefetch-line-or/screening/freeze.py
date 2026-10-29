"""Verify committed proof/source and the existing executable; never rebuild."""
import json,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;BASE=HERE.parent;ROOT=BASE.parents[1]
REPAIR=BASE/'caller/repair-v2'
sys.path.insert(0,str(REPAIR))
from repair_guard import verify as repair_verify,sha,exact,need,OLD
PROOF='a2c52e9b34bcaaa68d11356d62a00bd73884dde9'
PROOF_SHA='18a57116db25188e5ae0b3fe90ac4fecb1d48fe6860596950d860881095a2632'
CALLER_SOURCE='d986c17dbe496c17627164283157e5a59c112639'

def verify(commit):
    pins=repair_verify(CALLER_SOURCE)
    for revision,directory,name in [(PROOF,BASE,'COMPLETE_PROOF_ARCHIVE.json'),(commit,HERE,'PREPARATION.json')]:
        manifest=directory/name;exact(revision,manifest)
        if name=='COMPLETE_PROOF_ARCHIVE.json':need(sha(manifest)==PROOF_SHA,'Changed completed proof manifest')
        document=json.loads(manifest.read_text())
        if name=='COMPLETE_PROOF_ARCHIVE.json':need(len(document['files'])==182,'Incomplete proof inventory')
        for relative,item in document['files'].items():
            path=directory/relative;need(path.resolve().is_relative_to(directory),'Manifest path escaped')
            need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Artifact changed');exact(revision,path)
            pins[str(path.resolve())]=sha(path)
        pins[str(manifest)]=sha(manifest)
    from proof_audit import audit
    audit(live=True)
    proof=json.loads((REPAIR/'COMPILED_PROOF.json').read_text());need(proof['complete'],'Incomplete compiled proof')
    merged={group:{}for group in ('all_binary_sha256','compiler_consumed_input_sha256')}
    for path in [OLD/'caller/COMPILED_PROOF.json',OLD/'caller/order-v3/COMPILED_PROOF.json',REPAIR/'COMPILED_PROOF.json']:
        metadata=json.loads(path.read_text())
        for group in merged:
            for name,digest in metadata[group].items():
                need(merged[group].get(name,digest)==digest,'Conflicting compiled identity');merged[group][name]=digest
    need(len(merged['all_binary_sha256'])==14 and len(merged['compiler_consumed_input_sha256'])==412,'Compiled closure changed')
    for values in merged.values():
        for name,digest in values.items():need(sha(name)==digest,'Compiled input/binary changed')
    return dict(proof_commit=PROOF,proof_sha256=PROOF_SHA,caller_source_commit=CALLER_SOURCE,
                source_sha256=pins,binary=proof['normal_executable'],**merged)
