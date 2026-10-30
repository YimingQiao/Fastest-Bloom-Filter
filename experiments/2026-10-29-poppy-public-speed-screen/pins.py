"""No accepted executable until committed proof/manual ASM and runner freeze."""
import hashlib,json,re,subprocess
from pathlib import Path
from plan import HERE,ROOT,CALLER,PLAN_DIR,PLAN_COMMIT,CALLER_COMMIT,need,exact,derive
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def verify(commit):
    need(re.fullmatch('[0-9a-f]{40}',commit),'Full runner commit required')
    binding=json.loads((HERE/'proof-binding.json').read_text());need(binding['complete']is True,'Caller proof is not accepted/frozen')
    need(re.fullmatch('[0-9a-f]{40}',binding['proof_commit']or''),'Full proof commit required')
    pins={}
    for revision,directory,name,expected in [(binding['proof_commit'],CALLER,'COMPLETE_PROOF_ARCHIVE.json',binding['archive_sha256']),
        (commit,HERE,'PREPARATION.json',None)]:
        manifest=directory/name;exact(revision,manifest)
        if expected:need(sha(manifest)==expected,'Changed proof archive')
        inventory=json.loads(manifest.read_text())
        if name=='COMPLETE_PROOF_ARCHIVE.json':need(inventory['complete']is True and len(inventory['files'])==329,'Incomplete actual proof archive')
        for relative,item in inventory['files'].items():
            path=directory/relative;need(path.resolve().is_relative_to(directory),'Manifest path escaped')
            digest=item if isinstance(item,str)else item['sha256']
            need(sha(path)==digest,'Frozen artifact changed');exact(revision,path)
            if isinstance(item,dict):need(path.stat().st_size==item['bytes'],'Changed artifact size')
            pins[str(path.resolve())]=digest
        pins[str(manifest)]=sha(manifest)
    need(binding['archive_path']==str((CALLER/'COMPLETE_PROOF_ARCHIVE.json').relative_to(ROOT))and
         binding['compiled_proof_path']==str((CALLER/'COMPILED_PROOF.json').relative_to(ROOT)),'Unexpected proof routing')
    proof_path=ROOT/binding['compiled_proof_path'];exact(binding['proof_commit'],proof_path)
    need(sha(proof_path)==binding['compiled_proof_sha256'],'Changed compiled proof descriptor')
    proof=json.loads(proof_path.read_text());need(proof['complete']is True,'Incomplete actual caller proof')
    need(proof['caller_source_commit']==CALLER_COMMIT and proof['formal_workloads']==0,'Wrong proof source/scope')
    for group in ('all_binary_sha256','compiler_consumed_input_sha256','prepared_input_sha256','tools_sha256'):
        need(proof[group],'Missing actual compiler/proof closure')
        for path,digest in proof[group].items():need(sha(path)==digest,'Changed actual compiled closure: '+path)
    need(len(proof['all_binary_sha256'])==4,'Wrong focused proof binary set')
    need(len(proof['compiler_consumed_input_sha256'])==1032 and len(proof['prepared_input_sha256'])==4320,'Wrong actual/prepared source closure')
    binary=proof['normal_executable'];need(proof['all_binary_sha256'].get(binary['path'])==binary['sha256']and sha(binary['path'])==binary['sha256'],'Normal executable mismatch')
    review=CALLER/binding['manual_assembly_review_path'];need(review.resolve().is_relative_to(CALLER),'Manual gate escaped proof')
    exact(binding['proof_commit'],review);need(sha(review)==proof['manual_assembly_review_sha256'],'Changed actual manual ASM gate')
    need(binding['normal_stderr_path']=='validation-v1/normal-case-0.stderr','Unexpected backend diagnostic source')
    diagnostic=CALLER/binding['normal_stderr_path'];exact(binding['proof_commit'],diagnostic)
    need(sha(diagnostic)==binding['normal_stderr_sha256'],'Changed frozen native diagnostic')
    for name in ('README.md','derive.py','selection.json'):
        path=PLAN_DIR/name;exact(PLAN_COMMIT,path);pins[str(path)]=sha(path)
    path=CALLER/'PREPARATION.json';exact(CALLER_COMMIT,path);pins[str(path)]=sha(path)
    for relative,digest in json.loads(path.read_text())['files'].items():
        item=CALLER/relative;need(item.resolve().is_relative_to(CALLER),'Caller source path escaped');exact(CALLER_COMMIT,item)
        need(sha(item)==digest,'Changed actual caller source');pins[str(item)]=digest
    need(json.loads((HERE/'ledger.json').read_text())==derive(),'Changed fixed source ledger')
    return dict(proof_commit=binding['proof_commit'],proof_archive_sha256=binding['archive_sha256'],binary=binary,source_sha256=pins,
        compiled_proof_sha256=sha(proof_path),all_binary_sha256=proof['all_binary_sha256'],compiler_consumed_input_sha256=proof['compiler_consumed_input_sha256'],
        prepared_input_sha256=proof['prepared_input_sha256'],tools_sha256=proof['tools_sha256'])
