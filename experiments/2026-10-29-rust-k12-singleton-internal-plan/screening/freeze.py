"""Seal formal source only; no binary or workload execution."""
import hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

if __name__=='__main__':
    for name in ['protocol.json','ledger.json']:
        assert (HERE/name).read_bytes()==(HERE.parent/name).read_bytes()
    for name,record in json.loads((HERE/'REUSED.json').read_text()).items():
        data=subprocess.check_output(['git','show',record['commit']+':'+record['path']],cwd=ROOT)
        assert data==(HERE/name).read_bytes() and sha(HERE/name)==record['sha256']
    names=['run.py','audit.py','pins.py','screen_contract.py','placement.py','test_screen.py','freeze.py',
           'README.md','protocol.json','ledger.json','REUSED.json','offline-tests.stdout','offline-tests.stderr']
    files={name:sha(HERE/name) for name in names}
    path=HERE/'PREPARATION.json'
    path.write_text(json.dumps(dict(stage='prepared source only; no performance authorization',files=files),indent=2,sort_keys=True)+'\n')
    print(json.dumps(dict(files=len(files),sha256=sha(path))))
