"""Archive exact successful evidence; executables remain SHA-bound on disk."""
import hashlib,json
from pathlib import Path
HERE=Path(__file__).resolve().parent
CALLER=HERE.parent

if __name__=='__main__':
    proof=json.loads((CALLER/'COMPILED_PROOF.json').read_text())
    assert proof['complete'] and proof['manual_assembly_review']=='passed'
    paths=[CALLER/'COMPILED_PROOF.json',CALLER/'launch-v1.log']
    for name in ['validation-v1','assembly-review','proof-final']:
        paths.extend(p for p in (CALLER/name).rglob('*') if p.is_file() and '__pycache__' not in p.parts)
    files={}
    for path in sorted(paths):
        assert not path.is_symlink()
        data=path.read_bytes();assert not data.startswith(b'\x7fELF')
        files[path.relative_to(CALLER).as_posix()]=hashlib.sha256(data).hexdigest()
    value=dict(complete=True,source_commit=proof['source_commit'],proposal_commit=proof['proposal_commit'],
               prior_kernel_proof_commit=proof['prior_kernel_proof_commit'],files=files)
    path=CALLER/'COMPLETE_PROOF_ARCHIVE.json';path.write_text(json.dumps(value,indent=2,sort_keys=True)+'\n')
    print(json.dumps(dict(artifacts=len(files),sha256=hashlib.sha256(path.read_bytes()).hexdigest())))
