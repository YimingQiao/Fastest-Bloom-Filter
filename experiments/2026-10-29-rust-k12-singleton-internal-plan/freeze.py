"""Seal finite source-only proposal and scoped immutable provenance."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TIP = 'a90c826a2be88dba38987a055dae2407be277fd4'
SCOPE = [
    'experiments/2026-10-29-rust-k12-singleton-vector-plan/PLAN.json',
    'experiments/2026-10-29-rust-k12-single-line/protocol.json',
    'experiments/2026-10-29-rust-k12-singleton-inline/protocol.json',
    'experiments/2026-10-29-k12-singleton-vector-plan/protocol.json',
    'experiments/2026-10-29-k12-singleton-vector-plan/ledger.json',
    'experiments/2026-10-29-k12-singleton-vector-plan/screening/protocol.json',
    'experiments/2026-10-29-k12-singleton-vector-plan/screening/ledger.json',
    'experiments/2026-10-29-k12-singleton-external-plan/protocol.json',
    'experiments/2026-10-29-k12-singleton-external-plan/ledger.json',
]

def digest(data):
    return hashlib.sha256(data).hexdigest()

def blob(commit, path):
    assert re.fullmatch('[0-9a-f]{40}', commit)
    return subprocess.check_output(['git', 'show', commit + ':' + path], cwd=ROOT)

def save(name, value):
    (HERE / name).write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')

def main():
    protocol = json.loads((HERE / 'protocol.json').read_text())
    prefix = 'experiments/2026-10-29-rust-k12-singleton-vector-plan/'
    references = {}
    for commit, names in [
        (protocol['proposal_commit'], ['PREPARATION.json', 'candidate.rs', 'control.rs', 'CHANGE.patch']),
        (protocol['caller_source_commit'], ['caller/PREPARATION.json', 'caller/main.rs', 'caller/query.rs', 'caller/contract.py']),
        (protocol['complete_proof_commit'], ['caller/COMPLETE_PROOF_ARCHIVE.json', 'caller/COMPILED_PROOF.json', 'caller/proof-final/REPORT.md']),
    ]:
        for name in names:
            path = prefix + name
            data = blob(commit, path)
            assert (ROOT / path).read_bytes() == data
            references[path] = dict(commit=commit, sha256=digest(data))
    assert references[prefix + 'caller/COMPLETE_PROOF_ARCHIVE.json']['sha256'] == protocol['proof_manifest_sha256']
    save('SOURCE_REFERENCES.json', references)
    checked = {}
    for path in SCOPE:
        data = blob(TIP, path)
        text = data.decode()
        matches = [seed for seed in protocol['seeds'] if re.search(r'(?<![0-9])' + str(seed) + r'(?![0-9])', text)]
        assert not matches, (path, matches)
        checked[path] = dict(sha256=digest(data), bytes=len(data), matched_seeds=matches)
    save('SEED_SCOPE.json', dict(tip=TIP, seeds=protocol['seeds'], files=checked,
        search='Exact decimal integer tokens in these committed tracked UTF-8 artifacts only.',
        limitation='No global freshness, statistical independence, or other repository/file scope is claimed.'))
    names = ['README.md', 'protocol.json', 'derive.py', 'ledger.json', 'freeze.py', 'SOURCE_REFERENCES.json', 'SEED_SCOPE.json']
    files = {name: digest((HERE / name).read_bytes()) for name in names}
    save('PREPARATION.json', dict(stage='source-only; no build/BF', files=files))
    print(json.dumps(dict(files=len(files), manifest_sha256=digest((HERE / 'PREPARATION.json').read_bytes()))))

if __name__ == '__main__':
    main()
