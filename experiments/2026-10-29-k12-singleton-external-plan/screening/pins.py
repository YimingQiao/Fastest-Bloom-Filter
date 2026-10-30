"""Committed proposal/proof/source and exact executable/input closure."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
from screen_contract import need,read
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def blob(commit,path):
    need(type(commit)is str and re.fullmatch(r'[0-9a-f]{40}',commit),'full immutable40-hex commit required')
    return subprocess.check_output(['git','show',f'{commit}:{path}'],cwd=ROOT)
def verify_source(commit):
    preparation=HERE/'PREPARATION.json'
    need(preparation.read_bytes()==blob(commit,str(preparation.relative_to(ROOT))),'source preparation Git mismatch')
    files={}
    for name,entry in read(preparation)['files'].items():
        path=HERE/name;data=path.read_bytes()
        need(len(data)==entry['bytes']and sha(path)==entry['sha256'],'source preparation SHA mismatch')
        need(data==blob(commit,str(path.relative_to(ROOT))),'source Git bytes mismatch');files[str(path)]=entry['sha256']
    files[str(preparation)]=sha(preparation)
    return files
def verify(commit,live=True):
    source=verify_source(commit);binding=read(HERE/'proof-binding.json')
    proof_root=ROOT/binding['path'];archive=proof_root/'COMPLETE_PROOF_ARCHIVE.json'
    need(sha(archive)==binding['archive_sha256'],'proof archive SHA mismatch')
    need(archive.read_bytes()==blob(binding['commit'],str(archive.relative_to(ROOT))),'proof archive Git mismatch')
    proof_files={}
    for name,entry in read(archive)['files'].items():
        path=proof_root/name;data=path.read_bytes()
        need(len(data)==entry['bytes']and sha(path)==entry['sha256'],'proof artifact SHA mismatch')
        need(data==blob(binding['commit'],str(path.relative_to(ROOT))),'proof artifact Git mismatch');proof_files[str(path)]=entry['sha256']
    proof_files[str(archive)]=sha(archive)
    compiled_path=proof_root/'COMPILED_PROOF.json';need(sha(compiled_path)==binding['compiled_sha256'],'compiled proof SHA mismatch')
    compiled=read(compiled_path)
    need(compiled['complete']and compiled['manual_gate']['passed']and compiled['formal_workloads']==0,'proof gate incomplete')
    need(compiled['normal_executable']==binding['normal_executable'],'selected normal binary mismatch')
    for name in('ledger.json','protocol.json','selection.json','input-domains.json'):
        need((HERE/name).read_bytes()==blob(binding['proposal_commit'],binding['proposal_path']+'/'+name),'proposal bytes changed')
    verify_guard_derivation()
    closure=dict(source_sha256=source,proof_sha256=proof_files,all_binary_sha256=compiled['all_binary_sha256'],
        compiler_consumed_input_sha256=compiled['compiler_consumed_input_sha256'],prepared_input_sha256=compiled['prepared_input_sha256'],
        tools_sha256=compiled['tools_sha256'],normal_executable=compiled['normal_executable'])
    if live:
        for field in('all_binary_sha256','compiler_consumed_input_sha256','prepared_input_sha256','tools_sha256'):
            for path,expected in closure[field].items():need(sha(path)==expected,'live '+field+' mismatch: '+path)
    return closure


def verify_guard_derivation():
    import difflib
    binding=read(HERE/'row-guard-binding.json')
    original=blob(binding['parent_commit'],binding['parent_path']).decode()
    expected=original
    for item in binding['substitutions']:
        need(expected.count(item['before'])==1,'ambiguous row-guard derivation')
        expected=expected.replace(item['before'],item['after'])
    need((HERE/'row_guard.py').read_text()==expected,'row-guard derivation changed')
    patch=''.join(difflib.unified_diff(original.splitlines(True),expected.splitlines(True),fromfile='immutable-caller/contract.py',tofile='screening/row_guard.py'))
    need((HERE/'ROW_GUARD.patch').read_text()==patch,'row-guard patch changed')
