"""Source inventory and immutable committed proposal binding."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
from contract import need

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PROPOSAL = '5cb840406f1b4c48763bd660246e51c03bfe56c2'

def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def exact(commit, path):
    need(re.fullmatch('[0-9a-f]{40}', commit) is not None, 'Immutable full commit required')
    need(path.read_bytes() == subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT), 'Committed source drift: '+str(path))

def verify(commit):
    manifest = HERE/'PREPARATION.json'; exact(commit,manifest)
    record = json.loads(manifest.read_text()); files = {}
    for name,item in record['files'].items():
        path = HERE/name
        need(path.resolve().is_relative_to(HERE), 'Source path escaped caller')
        need(path.stat().st_size == item['bytes'] and sha(path) == item['sha256'], 'Caller source SHA drift')
        exact(commit,path); files[str(path)] = sha(path)
    files[str(manifest)] = sha(manifest)
    proposal = HERE.parent/'PREPARATION.json'; exact(PROPOSAL,proposal)
    need(sha(proposal) == '92caa1478df3d281251905579fd5c27f1446b26753de691b800bdc9fd1235bcc', 'Proposal manifest drift')
    for name,item in json.loads(proposal.read_text())['files'].items():
        path=HERE.parent/name
        need(sha(path)==item['sha256'] and path.stat().st_size==item['bytes'], 'Proposal source drift')
        exact(PROPOSAL,path); files[str(path)] = sha(path)
    files[str(proposal)] = sha(proposal)
    need(record['proposal_commit']==PROPOSAL, 'Wrong proposal revision')
    return files
