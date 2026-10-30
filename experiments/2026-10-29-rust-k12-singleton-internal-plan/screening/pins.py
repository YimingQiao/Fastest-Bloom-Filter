"""Exact committed producer, proposal, two rebuilt binaries and proof closure."""
import hashlib
from pathlib import Path
import re
import subprocess
from screen_contract import need,read

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
PROPOSAL='9e7fb401ccd6bd55a151eb8cc32395a06375862a'
PROOF='a2d508a5a93441e06e0b7776998916cdc53fd5b1'
CALLER_SOURCE='23e9b075a295deb11c3073cc3b4182b5810a9057'
CALLER=HERE.parent/'caller'
ARCHIVE_SHA='11f1c1e23529f09277c9314ac037cb1ee8669b22c199a2a0a6db9c5bd01766bb'
COMPILED_SHA='8298c9d19a19ba866f457da185a3e30784dbfed3733a99dbac56c4b638d59148'

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def blob(commit,path):
    need(type(commit) is str and re.fullmatch('[0-9a-f]{40}',commit),'full immutable40-hex commit required')
    return subprocess.check_output(['git','show',commit+':'+str(path)],cwd=ROOT)
def exact(commit,path,digest=None):
    need(path.read_bytes()==blob(commit,path.relative_to(ROOT)),'committed artifact differs: '+str(path))
    if digest is not None:need(sha(path)==digest,'artifact hash differs: '+str(path))

def verify(commit,live=True):
    source_manifest=HERE/'PREPARATION.json';exact(commit,source_manifest)
    source={str(source_manifest):sha(source_manifest)}
    for name,digest in read(source_manifest)['files'].items():
        path=HERE/name;need(path.resolve().is_relative_to(HERE),'source path escape')
        exact(commit,path,digest);source[str(path)]=digest
    proposal_manifest=HERE.parent/'PREPARATION.json';exact(PROPOSAL,proposal_manifest)
    proposal={str(proposal_manifest):sha(proposal_manifest)}
    for name,digest in read(proposal_manifest)['files'].items():
        path=HERE.parent/name;exact(PROPOSAL,path,digest);proposal[str(path)]=digest
    for name in ['ledger.json','protocol.json']:
        need((HERE/name).read_bytes()==(HERE.parent/name).read_bytes(),'copied fixed proposal differs')
    archive=CALLER/'COMPLETE_PROOF_ARCHIVE.json';exact(PROOF,archive,ARCHIVE_SHA)
    proof={str(archive):sha(archive)}
    for name,digest in read(archive)['files'].items():
        path=CALLER/name;need(path.resolve().is_relative_to(CALLER),'proof path escape')
        exact(PROOF,path,digest);proof[str(path)]=digest
    compiled_path=CALLER/'COMPILED_PROOF.json';need(sha(compiled_path)==COMPILED_SHA,'compiled descriptor differs')
    compiled=read(compiled_path)
    need(compiled['complete'] and compiled['manual_assembly_review']=='passed'
         and compiled['source_commit']==CALLER_SOURCE and compiled['formal_measurements']==0,'actual proof gate incomplete')
    need(set(compiled['executables'])=={'native','portable'},'wrong binary profiles')
    prepared={str(ROOT/name):digest for name,digest in compiled['prepared_input_sha256'].items()}
    prepared_manifest=CALLER/'PREPARATION.json';exact(CALLER_SOURCE,prepared_manifest,compiled['preparation_sha256'])
    for path,digest in prepared.items():exact(CALLER_SOURCE,Path(path),digest)
    tools={**compiled['toolchains_sha256'],**compiled['assembly_tools_sha256']}
    closure=dict(source_sha256=source,proposal_sha256=proposal,proof_sha256=proof,
                 prepared_input_sha256=prepared,actual_input_sha256=compiled['actual_input_sha256'],
                 all_binary_sha256=compiled['all_binary_sha256'],tools_sha256=tools,executables=compiled['executables'])
    if live:
        for field in ['prepared_input_sha256','actual_input_sha256','all_binary_sha256','tools_sha256']:
            for path,digest in closure[field].items():need(sha(path)==digest,'live '+field+' differs: '+path)
    return closure
