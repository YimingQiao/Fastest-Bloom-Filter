"""Exact source/proof inventory and an inherited whole-operation lease."""
import hashlib,json,re,sys
from pathlib import Path
from checks import HERE,SOURCE,ROOT,BASE,need
from source_guard import sha,committed,startup,module
PARENT_COMMIT='6baeaeb88c89b9a4eed71f0a0aa1263c613289bd'
CALLER_COMMIT='e4f0455b4354ef5d06840cc226ede4b3a5ca4e60'

def inventory(directory,commit):
    manifest=directory/'PREPARATION.json'
    need(committed(commit,manifest)==manifest.read_bytes(),'Inventory is not committed exactly')
    obj=json.loads(manifest.read_text())
    for name,want in obj['files'].items():
        path=ROOT/name
        need(path.resolve().is_relative_to(ROOT),'Source inventory path escape')
        need(sha(path)==want and hashlib.sha256(committed(commit,path)).hexdigest()==want,
             'Source file differs from requested commit: '+name)
    return obj

def verify(commit,live=True):
    need(__debug__,'Python -O unsupported')
    need(re.fullmatch('[0-9a-f]{40}',commit) is not None,'Full source commit required')
    own=inventory(HERE,commit);caller=inventory(SOURCE,CALLER_COMMIT)
    inventory(SOURCE,commit)
    binding=json.loads((SOURCE/'bindings.json').read_text())
    need(binding['parent_producer_commit']==PARENT_COMMIT,'Wrong parent producer')
    for name,want in binding['sha256'].items():
        p=ROOT/name
        need(sha(p)==want and hashlib.sha256(committed(PARENT_COMMIT,p)).hexdigest()==want,'Parent binding changed')
    parent=module('page_parent_screen_guards',BASE/'screen-v2/guards.py')
    parent.verify(PARENT_COMMIT,live=live)
    # The parent's proof is already committed; no old library or worker is rebuilt.
    from run_screen import frozen
    proof=parent.checked_freeze(frozen,PARENT_COMMIT)
    need(proof['binaries']['native/modern']['sha256']=='f8006716cd2bf7777bcd06df74596330e65d400fdfbdc8a61a21b54b59effab8','Wrong baseline worker')
    return dict(files={**caller['files'],**own['files']}),proof
