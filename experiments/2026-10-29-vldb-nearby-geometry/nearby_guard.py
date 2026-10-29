"""Frozen proposal, parent proof and exact new source closure."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
from nearby_contract import need
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PARENT=ROOT/'benchmarks/vldb-raw32-stage2'
ORIGINAL=ROOT/'benchmarks/vldb-original-external'
PROPOSAL='360c89f284281f05bf4804f9a4ec4da1ea3e1694'
PARENT_SOURCE='ec21cf239ae01acd658b6cfae24a1464fa8f6c5a'
PARENT_PROOF='e6cc3cd99a28f8fc8e221d6e4481b94c541feab9'
def sha(path):
    h=hashlib.sha256()
    with Path(path).open('rb')as f:
        for block in iter(lambda:f.read(1<<20),b''):h.update(block)
    return h.hexdigest()
def exact(commit,path):
    need(Path(path).read_bytes()==subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT),'Committed artifact mismatch: '+str(path))
def verify(commit):
    need(__debug__ and re.fullmatch(r'[0-9a-f]{40}',commit)is not None,'Require exact source commit and active checks')
    proposal=ROOT/'experiments/2026-10-29-vldb-nearby-geometry-proposal.PREPARATION.json';exact(PROPOSAL,proposal)
    for name,e in json.loads(proposal.read_text())['files'].items():
        path=proposal.parent/name;exact(PROPOSAL,path);need(sha(path)==e['sha256'],'Proposal drift')
    prep=HERE/'PREPARATION.json';exact(commit,prep)
    for name,want in json.loads(prep.read_text())['files'].items():
        path=HERE/name;need(sha(path)==want,'New source drift');exact(commit,path)
    manifest=PARENT/'PREFLIGHT_ARCHIVE.json';exact(PARENT_PROOF,manifest)
    for name,want in json.loads(manifest.read_text())['files'].items():
        path=PARENT/name;need(sha(path)==want,'Passed parent proof drift');exact(PARENT_PROOF,path)
    # Isolate the frozen parent's generic module names in a separate process.
    command=[sys.executable,'-c','from source_guard import verify; verify("'+PARENT_SOURCE+'")']
    result=subprocess.run(command,cwd=PARENT,capture_output=True,text=True)
    need(result.returncode==0,'Original source/dependency/archive guard failed: '+result.stdout+result.stderr)
    return json.loads((PARENT/'archives.json').read_text())['archives']
