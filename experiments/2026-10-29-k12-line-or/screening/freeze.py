"""Exact committed order-caller proof and already-built binary; never rebuild."""
import importlib.util,json,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;PARENT=HERE.parent
ORDER=PARENT/'caller/order-v3'
sys.path.insert(0,str(ORDER))
from guards import sha,exact,need,verify as verify_order
PROOF='422e2512932ac2d23b21ade9ae45e58e93bce6f2'
PROOF_SHA='72b5367eccbd29e1e6a9ca40bbf2f489d435aeff58f4717b902b84987ea4ff01'
ORDER_SOURCE='7546719bf38b77b4d12ca8d9cc829a09a96e459b'

def verify(commit):
    files=verify_order(ORDER_SOURCE)
    archive=ORDER/'PROOF_ARCHIVE.json';exact(PROOF,archive);need(sha(archive)==PROOF_SHA,'Order proof manifest changed')
    for name,item in json.loads(archive.read_text())['files'].items():
        path=ORDER/name;need(path.resolve().is_relative_to(ORDER),'Proof path escaped')
        need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Proof artifact changed');exact(PROOF,path)
        files[str(path)]=sha(path)
    files[str(archive)]=sha(archive)
    manifest=HERE/'PREPARATION.json';exact(commit,manifest)
    for name,item in json.loads(manifest.read_text())['files'].items():
        path=HERE/name;need(path.resolve().is_relative_to(HERE),'Runner path escaped')
        need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Runner source changed');exact(commit,path)
        files[str(path)]=sha(path)
    files[str(manifest)]=sha(manifest)
    spec=importlib.util.spec_from_file_location('line_or_order_proof_audit',ORDER/'proof_audit.py')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);module.audit(live=True)
    proof=json.loads((ORDER/'COMPILED_PROOF.json').read_text());need(proof['complete'],'Incomplete proof')
    old=json.loads((PARENT/'caller/COMPILED_PROOF.json').read_text())
    merged={}
    for group in ('all_binary_sha256','compiler_consumed_input_sha256'):
        merged[group]=dict(old[group])
        for path,digest in proof[group].items():
            need(merged[group].get(path,digest)==digest,'Inconsistent proof identity')
            merged[group][path]=digest
        for path,digest in merged[group].items():need(sha(path)==digest,'Live binary/compiler input changed')
    binary=proof['normal_executable'];need(sha(binary['path'])==binary['sha256'],'Normal binary changed')
    return dict(proof_commit=PROOF,proof_sha256=PROOF_SHA,order_source_commit=ORDER_SOURCE,source_sha256=files,binary=binary,**merged)
