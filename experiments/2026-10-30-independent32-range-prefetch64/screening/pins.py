"""Committed finite ledger/analysis, actual caller proof, binaries and consumed inputs."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
from screen_contract import need,read
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def blob(commit,path):
    need(type(commit)is str and re.fullmatch('[0-9a-f]{40}',commit),'full immutable40-hex commit required')
    return subprocess.check_output(['git','show',commit+':'+str(path)],cwd=ROOT)

def verify(commit,live=True):
    source={}
    def anchor(revision,path,digest=None):
        path=Path(path);data=path.read_bytes();observed=hashlib.sha256(data).hexdigest()
        need(data==blob(revision,path.relative_to(ROOT)),'committed file drift: '+str(path))
        need(digest is None or observed==digest,'frozen SHA drift: '+str(path));source[str(path)]=observed
        return data
    def inventory(revision,folder,manifest,digest=None,count=None):
        data=anchor(revision,folder/manifest,digest);files=json.loads(data)['files']
        need(count is None or len(files)==count,'source inventory count')
        for relative,item in files.items():
            need(type(item)is dict and set(item)=={'bytes','sha256'},'sized source inventory required')
            raw=anchor(revision,folder/relative,item['sha256']);need(len(raw)==item['bytes'],'source byte count')
        return files
    inventory(commit,HERE,'PREPARATION.json')
    binding=read(HERE/'proof-binding.json')
    for name in('caller','analysis'):
        item=binding[name];inventory(item['commit'],ROOT/item['path'],'PREPARATION.json',item['preparation_sha256'],item['files'])
    proof=binding['proof'];folder=ROOT/proof['path'];archive=json.loads(anchor(proof['commit'],folder/'COMPLETE_PROOF_ARCHIVE.json',proof['archive_sha256']))
    need(archive['complete']is True and len(archive['files'])==272,'complete actual caller proof required')
    proof_files={}
    for relative,digest in archive['files'].items():
        need(type(digest)is str,'proof SHA-string inventory required');path=folder/relative
        anchor(proof['commit'],path,digest);proof_files[str(path)]=digest
    compiled_path=folder/'COMPILED_PROOF.json';need(sha(compiled_path)==proof['compiled_sha256'],'compiled descriptor drift')
    compiled=read(compiled_path)
    need(compiled['complete']is True and compiled['manual_review']['complete']is True,'actual proof/manual gate incomplete')
    need(compiled['source_commit']==binding['caller']['commit'],'actual caller source changed')
    need(compiled['counts']['caller_rows']==90 and compiled['counts']['formal_workloads']==0,'proof scope changed')
    need(compiled['normal_executable']==proof['normal_executable'],'selected normal binary changed')
    derivation=read(HERE/'DERIVATION.json')
    for item in derivation['parents']:anchor(item['commit'],ROOT/item['path'],item['sha256'])
    for name,digest in derivation['outputs'].items():need(sha(HERE/name)==digest,'derived producer/guard changed')
    need((HERE/'selection.json').read_bytes()==(ROOT/binding['caller']['path']/'selection.json').read_bytes(),'selection mismatch')
    need((HERE/'ledger.json').read_bytes()==(ROOT/binding['analysis']['path']/'ledger.json').read_bytes(),'exact analysis ledger mismatch')
    need((HERE/'ANALYSIS_RULES.json').read_bytes()==(ROOT/binding['analysis']['path']/'ANALYSIS_RULES.json').read_bytes(),'analysis rules mismatch')
    closure=dict(source_sha256=source,proof_sha256=proof_files,all_binary_sha256=compiled['all_binary_sha256'],
        compiler_consumed_input_sha256=compiled['compiler_consumed_input_sha256'],prepared_input_sha256=compiled['prepared_source_sha256'],
        tools_sha256=compiled['tools_sha256'],launcher_tools_sha256=binding['launcher_tools_sha256'],normal_executable=compiled['normal_executable'])
    need(len(closure['all_binary_sha256'])==3 and len(closure['compiler_consumed_input_sha256'])==572,'actual compiler closure count')
    if live:
        for field in('all_binary_sha256','compiler_consumed_input_sha256','prepared_input_sha256','tools_sha256','launcher_tools_sha256'):
            for path,digest in closure[field].items():need(sha(path)==digest,'live '+field+' changed: '+path)
    return closure
