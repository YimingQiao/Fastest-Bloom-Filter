"""Immutable proposal/producer proof for a no-rebuild subset preflight."""
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import subprocess
import sys

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=HERE.parents[2]
PARENT=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes-screen'
PUBLIC=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes'
PROPOSAL='87300b66d60e6f55d9b200bad10b2e0b527b5521'
PRODUCER='571186b420bf7e5fc08269ed4a65feab42ac8400'

def need(ok,message):
    if not ok:raise ValueError(message)
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def save(path,value):path.write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)

def load_module(name,path):
    spec=importlib.util.spec_from_file_location(name,path);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module

def verify(commit=None):
    if commit:need(re.fullmatch(r'[0-9a-f]{40}',commit)is not None,'Exact committed source required')
    original=json.loads((STAGE/'PREPARATION.json').read_text())
    need((STAGE/'PREPARATION.json').read_bytes()==blob(PROPOSAL,STAGE/'PREPARATION.json'),'Changed proposal descriptor')
    for name,entry in original['files'].items():
        path=STAGE/name;need(sha(path)==entry['sha256']and path.read_bytes()==blob(PROPOSAL,path),'Changed initial proposal '+name)
    plan=load_module('_strict24_initial_plan',STAGE/'plan.py')
    need(plan.derive()==json.loads((STAGE/'selection.json').read_text()),'Training-derived48-view union changed')
    from correct_order import derive
    need(derive()==json.loads((HERE/'corrected-selection.json').read_text()),'Corrected source-derived row-order ledger changed')
    declaration=json.loads((HERE/'PREPARATION.json').read_text())
    for name,entry in declaration['files'].items():
        path=HERE/name;need(sha(path)==entry['sha256']and path.stat().st_size==entry['bytes'],'Changed additive preflight '+name)
        if commit:need(path.read_bytes()==blob(commit,path),'Uncommitted additive source '+name)
    if commit:need((HERE/'PREPARATION.json').read_bytes()==blob(commit,HERE/'PREPARATION.json'),'Changed additive descriptor')
    # Run the already-frozen source/dependency/binary audit as a separate Python
    # process so this local bindings module cannot shadow its original imports.
    result=subprocess.run([sys.executable,str(PARENT/'screening/freeze.py'),'--source-commit',PRODUCER],capture_output=True,text=True,cwd=ROOT)
    need(result.returncode==0,'Original592-input freeze failed: '+result.stdout+result.stderr)
    compiled=json.loads((PARENT/'PERFORMANCE_COMPILED_FREEZE.json').read_text())
    binaries={'native':Path(compiled['performance_executable']),
        'asan':Path('/tmp/fastest-bf-fastbloom-fixed-k-performance/validation-v1/asan/x86_64-unknown-linux-gnu/release/compare_benchmark')}
    need(sha(binaries['native'])=='f499f5daa354f3db31c5cfa1e84640c890f96c81e2724456aa64bf7b6bc7ef05','Wrong native executable')
    need(sha(binaries['asan'])=='08cf317941fc5be367dac3de106ea2e204a239538d84922093eded8e8df4f7b8','Wrong retained ASan executable')
    return binaries

def verify_derivation():
    import difflib
    original=(PARENT/'guard.py').read_text();current=(HERE/'subset_guard.py').read_text()
    a,b=original.index('def selected_names('),original.index('\n\ndef expected_order')
    x,y=current.index('def selected_names('),current.index('\n\ndef expected_order')
    need(original[:a]==current[:x]and original[b:]==current[y:],'Changed per-row/timer/geometry guard outside the two declared subset functions')
    patch=''.join(difflib.unified_diff(original.splitlines(True),current.splitlines(True),fromfile='frozen336/guard.py',tofile='preflight/subset_guard.py'))
    need(patch==(HERE/'subset_guard.py.patch').read_text(),'Changed declared subset patch')
    return dict(parent_guard_sha256=sha(PARENT/'guard.py'),subset_guard_sha256=sha(HERE/'subset_guard.py'),only_functions=['selected_names','validate_protocol'])
