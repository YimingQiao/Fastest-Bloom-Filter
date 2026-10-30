"""Exact derived source, committed reference rows and structured Cargo binding."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PROPOSAL = '9e7fb401ccd6bd55a151eb8cc32395a06375862a'
PROOF = 'd5049cdc15661bccbfbc875e21b3c8696be46036'
OLD = ROOT / 'experiments/2026-10-29-rust-k12-singleton-vector-plan/caller'

def need(ok, text):
    if not ok:
        raise ValueError(text)

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def save(path, value):
    Path(path).write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')

def exact(commit, path, digest=None):
    need(re.fullmatch('[0-9a-f]{40}', commit), 'full commit required')
    data = subprocess.check_output(['git', 'show', commit + ':' + path.relative_to(ROOT).as_posix()], cwd=ROOT)
    need(data == path.read_bytes() and (digest is None or sha(path) == digest), 'committed source/reference drift: ' + str(path))

def verify(commit):
    manifest = HERE / 'PREPARATION.json'
    exact(commit, manifest)
    prep = json.loads(manifest.read_text())
    for name, digest in prep['files'].items():
        path = HERE / name
        need(path.resolve().is_relative_to(HERE), 'source escape')
        exact(commit, path, digest)
    proposal = HERE.parent / 'PREPARATION.json'
    exact(PROPOSAL, proposal)
    for name, digest in json.loads(proposal.read_text())['files'].items():
        exact(PROPOSAL, HERE.parent / name, digest)
    proof_manifest = OLD / 'COMPLETE_PROOF_ARCHIVE.json'
    exact(PROOF, proof_manifest, '4f3b4a5d504c16241fec769c0e606f9ab7fd66e024c6bc4691d1cc80ed055e78')
    inventory = json.loads(proof_manifest.read_text())['files']
    exact(PROOF, OLD / 'COMPILED_PROOF.json', inventory['COMPILED_PROOF.json'])
    proof = json.loads((OLD / 'COMPILED_PROOF.json').read_text())
    need(proof['complete'] and proof['manual_assembly_review'] == 'passed', 'prior proof incomplete')
    for profile in ['native', 'portable']:
        for index in range(4, 8):
            name = f'repair-v2/validation-v1/{profile}-case-{index}.stdout'
            exact(PROOF, OLD / name, inventory[name])
    import derive
    for name, data in derive.derive().items():
        need((HERE / name).read_bytes() == data, 'derivation changed: ' + name)
    return {str((HERE / name).relative_to(ROOT)): digest for name, digest in prep['files'].items()}

def packages(text):
    data = json.loads(text)
    expected = {'rust-k12-simd-caller': HERE / 'Cargo.toml',
                'k12-simd-control': HERE / 'control/Cargo.toml',
                'k12-simd-candidate': HERE / 'candidate/Cargo.toml'}
    need(Path(data['workspace_root']).resolve() == HERE, 'unexpected workspace root')
    need(len(data['packages']) == 3 and {p['name'] for p in data['packages']} == set(expected), 'unexpected Cargo packages')
    known = {}
    for package in data['packages']:
        need(Path(package['manifest_path']).resolve() == expected[package['name']] and package.get('source') is None, 'package identity differs')
        package['_workspace_root'] = str(HERE)
        known[package['id']] = package
    need(set(data['workspace_members']) == set(known), 'workspace member identities differ')
    return known

def executable(text, target, known):
    found = set()
    for line in text.splitlines():
        row = json.loads(line)
        if row.get('reason') != 'compiler-artifact' or row.get('executable') is None:
            continue
        package = known.get(row['package_id'])
        need(package and package['name'] == 'rust-k12-simd-caller' and not row['profile']['test'], 'unexpected executable artifact')
        need(Path(row['manifest_path']).resolve() == HERE / 'Cargo.toml'
             and Path(row['target']['src_path']).resolve() == HERE / 'main.rs', 'caller artifact identity differs')
        path = Path(row['executable']).resolve()
        need(path.is_file() and path.is_relative_to(target), 'executable outside fresh target')
        found.add(path)
    need(len(found) == 1, 'missing/ambiguous caller executable')
    return next(iter(found))
