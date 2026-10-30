"""Seal only the completed V2 evidence and additive final review."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
CALLER = HERE.parent

def main():
    proof = json.loads((CALLER / 'COMPILED_PROOF.json').read_text())
    assert proof['complete'] and proof['manual_assembly_review'] == 'passed'
    paths = [CALLER / 'COMPILED_PROOF.json']
    for name in ['repair-v2/validation-v1', 'assembly-review', 'proof-final']:
        paths.extend(p for p in (CALLER / name).rglob('*') if p.is_file() and '__pycache__' not in p.parts)
    files = {}
    for path in sorted(paths):
        assert not path.is_symlink()
        data = path.read_bytes()
        assert not data.startswith(b'\x7fELF'), 'executables must not be archived'
        files[path.relative_to(CALLER).as_posix()] = hashlib.sha256(data).hexdigest()
    manifest = dict(complete=True, source_commit=proof['source_commit'],
                    compiled_source_commit=proof['compiled_source_commit'],
                    previous_failure_commit=proof['failure_commit'],
                    previous_failure_manifest_sha256=proof['failure_manifest_sha256'],
                    files=files)
    path = CALLER / 'COMPLETE_PROOF_ARCHIVE.json'
    path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + '\n')
    print(json.dumps(dict(artifacts=len(files), manifest_sha256=hashlib.sha256(path.read_bytes()).hexdigest())))

if __name__ == '__main__':
    main()
