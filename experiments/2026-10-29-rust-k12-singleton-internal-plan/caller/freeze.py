"""Freeze prepared source only; never configure, compile or execute a filter."""
import hashlib
import json
from pathlib import Path
import derive

HERE=Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

if __name__=='__main__':
    generated=derive.derive()
    for name,data in generated.items():assert (HERE/name).read_bytes()==data,name
    authored=['derive.py','guards.py','contract.py','validate.py','test_contract.py','README.md','freeze.py',
              'offline-guards.stdout','offline-guards.stderr']
    files={name:sha(HERE/name) for name in sorted(set(generated)|set(authored))}
    assert len(files)==55
    output=HERE/'PREPARATION.json'
    output.write_text(json.dumps(dict(stage='source-only bounded caller proof; no execution authorization',files=files),indent=2,sort_keys=True)+'\n')
    print(json.dumps(dict(files=len(files),sha256=sha(output))))
