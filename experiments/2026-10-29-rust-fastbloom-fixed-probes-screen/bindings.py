"""Immutable public source/correctness/quality bindings; no Bloom execution."""
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PUBLIC = ROOT / 'experiments/2026-10-29-rust-fastbloom-fixed-probes'
TIMED_COMMIT = 'bbc3474cdd15b2e3301384dff4afdc12505cbfe9'
CORRECTNESS = '391b775c5c6e092230ef0954d59e802005dbcfce'
QUALITY = 'b94dc7b127ea9d26bd7f699aafc7f1d3caf76b6e'


def need(ok, message):
    if not ok: raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')


def blob(commit, path):
    return subprocess.check_output(['git', 'show', commit + ':' + str(path.relative_to(ROOT))], cwd=ROOT)


def original_inputs():
    freeze_path = PUBLIC / 'ACCURACY_COMPILED_FREEZE.json'
    need(freeze_path.read_bytes() == blob(CORRECTNESS, freeze_path), 'Changed compiled correctness anchor')
    frozen = json.loads(freeze_path.read_text())
    for path in [PUBLIC/'calibration-results/results.csv', PUBLIC/'calibration-results/quality.json', PUBLIC/'calibration-results/metadata.json']:
        need(path.read_bytes() == blob(QUALITY, path), 'Changed completed112 quality anchor')
    initial = json.loads((PUBLIC/'PREPARATION.json').read_text())['files']
    for name, info in initial.items():
        path = PUBLIC/name
        need(sha(path) == info['sha256'] and hashlib.sha256(blob(TIMED_COMMIT, path)).hexdigest() == info['sha256'], 'Changed initial timed/public adapter input')
    return frozen


def verify_preparation(commit=None):
    prep = HERE/'PREPARATION.json'
    declaration = json.loads(prep.read_text())
    pins = dict(declaration['inputs_sha256'])
    pins.update({str((HERE/name).relative_to(ROOT)): info['sha256'] for name, info in declaration['files'].items()})
    pins[str(prep.relative_to(ROOT))] = sha(prep)
    for name, digest in pins.items():
        path = ROOT/name
        need(sha(path) == digest, 'Changed prepared input ' + name)
        if commit: need(hashlib.sha256(blob(commit, path)).hexdigest() == digest, 'Uncommitted prepared input ' + name)
    frozen = original_inputs()
    for name, digest in frozen['preserved_source_sha256'].items(): need(sha(ROOT/name) == digest, 'Changed inherited source')
    for dep in frozen['external_dependencies']:
        for name, digest in dep['sha256'].items(): need(sha(Path(dep['directory'])/name) == digest, 'Changed pinned dependency')
    for name, digest in frozen['binaries_sha256'].items(): need(sha(Path(name)) == digest, 'Changed retained correctness binary')
    for dep in json.loads((HERE/'external-tree.json').read_text())['dependencies']:
        for name, digest in dep['sha256'].items(): need(sha(Path(dep['directory'])/name) == digest, 'Changed full dependency tree')
    return pins, frozen


def artifact(stdout, test):
    paths = []
    for line in stdout.splitlines():
        try: value = json.loads(line)
        except json.JSONDecodeError: continue
        if value.get('reason') == 'compiler-artifact' and value.get('target', {}).get('name') == 'compare_benchmark':
            need(value['target']['kind'] == ['bin'] and value['profile']['test'] == test, 'Wrong Cargo executable kind')
            if value.get('executable'): paths.append(Path(value['executable']).resolve())
    need(len(paths) == 1, 'Expected exactly one actual Cargo executable artifact')
    need(paths[0].is_file(), 'Missing reported Cargo executable')
    return paths[0]
