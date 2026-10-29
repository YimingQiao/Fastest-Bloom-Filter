"""Read-only source/ledger/derivation checks; no compiler or Bloom execution."""
from pathlib import Path
import hashlib,importlib.util,json,subprocess
import derive
HERE=Path(__file__).resolve().parent
PLAN=HERE.parent
ROOT=HERE.parents[2]
PLAN_COMMIT='9f0ebb2f5b75c3be493e562024d01bbfc4a4c749'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    prep=PLAN/'PREPARATION.json'
    assert prep.read_bytes()==subprocess.check_output(['git','show',PLAN_COMMIT+':'+str(prep.relative_to(ROOT))],cwd=ROOT)
    for name,item in json.loads(prep.read_text())['files'].items():
        path=PLAN/name;assert sha(path)==item['sha256']and path.stat().st_size==item['bytes']
        assert path.read_bytes()==subprocess.check_output(['git','show',PLAN_COMMIT+':'+str(path.relative_to(ROOT))],cwd=ROOT)
    spec=importlib.util.spec_from_file_location('fixed_plan',PLAN/'plan.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    ledger=json.loads((PLAN/'ledger.json').read_text());assert module.validate(ledger['cases'])==ledger['counts']
    generated=derive.sources();record=json.loads((HERE/'DERIVATION.json').read_text())
    assert record['parent_commit']==derive.PARENT and record['files']=={name:hashlib.sha256(data).hexdigest()for name,data in generated.items()}
    for name,data in generated.items():assert(HERE/name).read_bytes()==data,name
    cpp=(HERE/'cpp/main.cpp').read_text();rust=(HERE/'rust/src/main.rs').read_text()
    assert cpp.count('else Trial<Range,0>')==1 and cpp.count('__attribute__((noinline)) void Trial')==1
    assert rust.count('else { trial::<Before>')==1 and rust.count('#[inline(never)]\nfn trial<')==1
    assert 'serial_pair_abba4'not in cpp+rust and 'bool serial'not in cpp and 'serial: bool'not in rust
    assert 'measure?32:4'in cpp and 'if measure { 32 } else { 4 }'in rust
    assert 'seed==74381'in cpp and 'seed == 74381'in rust
    for source in (cpp,rust):
        assert '--caller-check'in source and '--measure'in source and 'wrong stage input seed'in source
    print('PASS',len(generated),'exact derived sources; fixed40-case plan and shared A0/A1 source path; no compilation')
if __name__=='__main__':main()
