"""Additive one-line Page constructor correction; original sources stay exact."""
import hashlib,json,re
from pathlib import Path
from source_guard import verify as original_verify,startup,sha,committed
from contract import ROOT,need
HERE=Path(__file__).resolve().parent

def reused_legacy():
    p=json.loads((HERE/'reuse.json').read_text());return (ROOT/p['native_legacy_binary']).resolve()

def verify(commit,live=True):
    original=original_verify(commit,live=live)
    inventory=json.loads((HERE/'PREPARATION.json').read_text())
    for name,want in inventory['files'].items():
        p=ROOT/name;need(sha(p)==want,'Retry preparation changed: '+name)
        need(hashlib.sha256(committed(commit,p)).hexdigest()==want,'Retry source not committed exactly: '+name)
    need(committed(commit,HERE/'PREPARATION.json')==(HERE/'PREPARATION.json').read_bytes(),'Uncommitted retry inventory')
    reuse=json.loads((HERE/'reuse.json').read_text())
    for name,want in reuse['files'].items():need(sha(ROOT/name)==want,'Reused native legacy provenance changed: '+name)
    return dict(files={**original['files'],**inventory['files']})
