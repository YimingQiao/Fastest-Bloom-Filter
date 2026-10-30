"""Exact additive sources, original archives and modern dependency anchors."""
import hashlib,importlib.util,json,re,subprocess,sys
from pathlib import Path
from contract import HERE,ROOT,need
PARENT=ROOT/'benchmarks/vldb-original-external'
STAGE2=ROOT/'benchmarks/vldb-raw32-stage2'
MODERN=ROOT/'experiments/2026-10-29-exact-budget-range'

def sha(path):
    h=hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda:f.read(1<<20),b''):h.update(block)
    return h.hexdigest()
def committed(commit,path):
    return subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT)
def module(name,path):
    spec=importlib.util.spec_from_file_location(name,path);result=importlib.util.module_from_spec(spec);spec.loader.exec_module(result);return result

def verify(commit,live=True):
    need(__debug__,'Python -O is unsupported')
    need(re.fullmatch('[0-9a-f]{40}',commit) is not None,'An exact full source commit is mandatory')
    inventory=json.loads((HERE/'PREPARATION.json').read_text())
    for name,want in inventory['files'].items():
        p=ROOT/name;need(p.resolve().is_relative_to(ROOT),'Preparation path escape')
        need(sha(p)==want,'Preparation drift: '+name)
        need(hashlib.sha256(committed(commit,p)).hexdigest()==want,'Requested commit differs: '+name)
    need(committed(commit,HERE/'PREPARATION.json')==(HERE/'PREPARATION.json').read_bytes(),'Inventory not committed exactly')
    bindings=json.loads((HERE/'bindings.json').read_text())
    for name,want in bindings['copied_inputs_sha256'].items():
        need(sha(ROOT/name)==want,'Reviewed derivation input changed: '+name)
    # This invokes the existing exact-blob/source/archive guard, not its build
    # driver. Stage1/Stage2 sources and proofs remain unchanged.
    old=module('stage2_source_guard',STAGE2/'source_guard.py')
    old.verify(bindings['stage2_source_commit'],live=live)
    need(sha(STAGE2/'PREFLIGHT_ARCHIVE.json')==bindings['stage2_archive_sha256'],'Stage2 proof changed')
    for name,want in json.loads((STAGE2/'PREFLIGHT_ARCHIVE.json').read_text())['files'].items():
        need(sha(STAGE2/name)==want,'Stage2 archived artifact changed: '+name)
    modern_commit=bindings['modern_source_commit']
    for name in ('freeze.json','planned-grid.json'):
        need(committed(modern_commit,MODERN/name)==(MODERN/name).read_bytes(),'Frozen modern geometry proof changed')
    if live:
        for name,want in json.loads((MODERN/'freeze.json').read_text())['source_sha256'].items():
            need(sha(ROOT/name)==want,'Modern pinned source changed: '+name)
    return inventory

def startup(cpu,lease,build):
    # Check fdinfo *before* the parent's helper can acquire a lock. A matching
    # but unlocked open descriptor is not a whole-operation inherited lease.
    guards=module('stage2_startup_guards',STAGE2/'startup_guards.py')
    inherited=guards.require_inherited_write_lock(cpu,lease)
    guards.require_new_build_root(build)
    sys.path.insert(0,str(PARENT))
    parent=module('original_validation',PARENT/'validate.py')
    record=parent.lease(cpu,lease)
    need(sorted(record['inherited_lock_descriptors'])==inherited,'Lease descriptor set changed')
    record['inherited_write_verified']=True
    return record,parent.tuner_file
