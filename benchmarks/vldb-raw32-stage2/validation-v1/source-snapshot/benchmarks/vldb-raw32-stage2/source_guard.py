"""Read-only anchors for the additive preparation and reused original archives."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
from contract import need
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
PARENT=ROOT/'benchmarks/vldb-original-external'

def sha(path):
    h=hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda:stream.read(1<<20),b''):h.update(block)
    return h.hexdigest()

def verify(source_commit,live=True):
    need(__debug__,'Python -O is unsupported')
    need(re.fullmatch(r'[0-9a-f]{40}',source_commit) is not None,'Use a full source commit hash')
    inventory=json.loads((HERE/'PREPARATION.json').read_text())
    for relative,want in inventory['files'].items():
        path=ROOT/relative
        need(sha(path)==want,'Preparation input changed: '+relative)
        committed=subprocess.run(['git','show',source_commit+':'+relative],cwd=ROOT,capture_output=True,check=True).stdout
        need(hashlib.sha256(committed).hexdigest()==want,'Commit does not contain exact preparation: '+relative)
    # The inventory itself must also be an exact blob in the requested commit.
    rel=str((HERE/'PREPARATION.json').relative_to(ROOT))
    committed=subprocess.run(['git','show',source_commit+':'+rel],cwd=ROOT,capture_output=True,check=True).stdout
    need(committed==(HERE/'PREPARATION.json').read_bytes(),'Uncommitted preparation inventory')
    protocol=json.loads((HERE/'protocol.json').read_text())
    manifest=PARENT/'manifest.json'
    need(sha(manifest)==protocol['parent_manifest_sha256'],'Frozen original proof changed')
    for name,want in json.loads(manifest.read_text())['files'].items():
        need(sha(PARENT/name)==want,'Frozen parent artifact changed: '+name)
    old_rel=str(manifest.relative_to(ROOT))
    old=subprocess.run(['git','show',protocol['parent_commit']+':'+old_rel],cwd=ROOT,capture_output=True,check=True).stdout
    need(old==manifest.read_bytes(),'Parent proof commit mismatch')
    if live:
        sys.path.insert(0,str(PARENT))
        from verify_sources import verify as verify_upstream
        verify_upstream()
        for record in json.loads((HERE/'archives.json').read_text())['archives'].values():
            need(sha(ROOT/record['path'])==record['sha256'],'Original compiled archive changed')
        # Includes the exact consumed headers/system inputs of the old archives.
        frozen=json.loads((PARENT/'FREEZE.json').read_text())
        for path,want in frozen['consumed_compiler_inputs_sha256'].items():
            need(sha(Path(path))==want,'Original compiler input changed: '+path)
    return inventory
