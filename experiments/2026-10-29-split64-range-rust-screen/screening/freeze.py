#!/usr/bin/env python3
"""Freeze completed correctness/ASM evidence and the unchanged timing executable."""
if not __debug__:
    raise ValueError('Run without Python -O')
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tomllib

from guard import require, validate_protocol

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
FROZEN = HERE / 'freeze.json'
ARCHIVE = STAGE / 'ARCHIVE.json'
EXCLUDED = {'target', '__pycache__', 'screen'}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')


def committed(path, revision, digest):
    require(re.fullmatch('[0-9a-f]{40}', revision) is not None, 'Full commit required')
    blob = subprocess.check_output(['git', 'show', revision + ':' + path], cwd=ROOT)
    require(hashlib.sha256(blob).hexdigest() == digest and sha(ROOT / path) == digest, 'Committed/live mismatch: ' + path)
    return blob


def descriptor(protocol):
    binding = protocol['parent_descriptor']
    raw = committed(binding['path'], binding['revision'], binding['sha256'])
    saved = STAGE / 'validation-v1/parent-dependency-descriptor.json'
    require(saved.read_bytes() == raw, 'Retrospective descriptor copy differs')
    dependencies = json.loads(raw)['external_dependencies']
    for name in ('validation-v1/commands.json', 'allocation-large/validation/metadata.json'):
        require(json.loads((STAGE / name).read_text())['external_dependencies'] == dependencies, 'Saved dependency descriptors differ')
    initial_lock = str((STAGE / 'benchmark/Cargo.lock').relative_to(ROOT))
    committed(initial_lock, protocol['initial_source_commit'], sha(ROOT / initial_lock))
    locked = tomllib.loads((ROOT / initial_lock).read_text())
    packages = [{field: p.get(field) for field in ('name', 'version', 'source', 'checksum')}
                for p in locked['package'] if 'source' in p]
    evidence = json.loads((STAGE / 'validation-v1/descriptor-check.json').read_text())
    require(packages == evidence['cargo_external_packages'], 'Cargo package/source checksum pins changed')
    return dependencies


def verify(frozen, dependencies=True, all_binaries=True):
    require(__debug__, 'Run without Python -O')
    for name, digest in frozen['source_sha256'].items():
        require(sha(ROOT / name) == digest, 'Changed source/evidence: ' + name)
    binaries = frozen['binaries'] if all_binaries else frozen['binaries'][:1]
    for binary in binaries:
        require(sha(Path(binary['path'])) == binary['sha256'], 'Changed executable: ' + binary['path'])
    if dependencies:
        protocol = json.loads((HERE / 'protocol.json').read_text())
        require(descriptor(protocol) == frozen['external_dependencies'], 'Frozen dependency descriptor differs')
        for dep in frozen['external_dependencies']:
            for name, digest in dep['sha256'].items():
                require(sha(Path(dep['directory']) / name) == digest, 'Changed dependency: ' + dep['name'] + '/' + name)


def verify_archive():
    manifest = json.loads(ARCHIVE.read_text())
    for name, info in manifest['files'].items():
        path = STAGE / name
        require(path.stat().st_size == info['bytes'] and sha(path) == info['sha256'], 'Changed local archive: ' + name)
    actual = {str(p.relative_to(STAGE)) for p in STAGE.rglob('*') if p.is_file() and p != ARCHIVE
              and not set(p.relative_to(STAGE).parts) & EXCLUDED}
    require(actual == set(manifest['files']), 'Unlisted/missing local archive artifact')
    return manifest


def verify_commit(revision, frozen):
    names = dict(frozen['source_sha256'])
    names[str(FROZEN.relative_to(ROOT))] = sha(FROZEN)
    names[str(ARCHIVE.relative_to(ROOT))] = sha(ARCHIVE)
    for path, digest in names.items():
        committed(path, revision, digest)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    if args.verify:
        frozen = json.loads(FROZEN.read_text())
        verify(frozen)
        archive = verify_archive()
        print('PASS frozen', len(frozen['source_sha256']), 'inputs,', len(frozen['external_dependencies']), 'dependency sets,', len(frozen['binaries']), 'binaries;', len(archive['files']), 'local archive artifacts')
        return
    protocol = json.loads((HERE / 'protocol.json').read_text())
    registry = json.loads((STAGE / 'registry.json').read_text())
    validate_protocol(protocol, registry, (STAGE / 'benchmark/src/main.rs').read_text())
    for script in (STAGE / 'verify_source.py', STAGE / 'preflight/verify_preparation.py'):
        subprocess.run(['python3', str(script)], cwd=ROOT, check=True)
    preflight = json.loads((STAGE / 'validation-v1/commands.json').read_text())
    allocation = json.loads((STAGE / 'allocation-large/validation/metadata.json').read_text())
    require(preflight['complete'] and allocation['complete'] and allocation['rows'] == 48, 'Incomplete validation evidence')
    dependencies = descriptor(protocol)
    sources = {str(p.relative_to(ROOT)): sha(p) for p in STAGE.rglob('*') if p.is_file()
               and p not in (FROZEN, ARCHIVE) and not set(p.relative_to(STAGE).parts) & EXCLUDED}
    cpp = ROOT / 'experiments/2026-10-29-split64-range-native/validation-v1/cpp-native-parity.stdout'
    require(sha(cpp) == preflight['cpp_fixture_sha256'], 'Changed C++ parity oracle')
    for path in (ROOT / protocol['parent_descriptor']['path'], cpp):
        sources[str(path.relative_to(ROOT))] = sha(path)
    binaries = [dict(path=protocol['binary'], sha256=protocol['binary_sha256'], role='unchanged120-row public benchmark')]
    binaries.extend(dict(path=path, sha256=digest, role='correctness/reference executable')
                    for path, digest in preflight['binaries_sha256'].items() if path != protocol['binary'])
    binaries.append(dict(path=allocation['binary'], sha256=allocation['binary_sha256'], role='allocation-only audit'))
    require(len(binaries) == len({x['path'] for x in binaries}) == 12, 'Wrong exact executable set')
    frozen = dict(status='Correctness complete, performance not executed; requires separate committed-source authorization',
                  source_sha256=dict(sorted(sources.items())), external_dependencies=dependencies, binaries=binaries,
                  compiler_flags=protocol['compiler_flags'], rustc=(STAGE / 'validation-v1/rustc.stdout').read_text(),
                  parent_descriptor=protocol['parent_descriptor'], performance_run=False, production_changed=False)
    verify(frozen)
    save(FROZEN, frozen)
    files = {str(p.relative_to(STAGE)): dict(sha256=sha(p), bytes=p.stat().st_size) for p in STAGE.rglob('*')
             if p.is_file() and p != ARCHIVE and not set(p.relative_to(STAGE).parts) & EXCLUDED}
    save(ARCHIVE, dict(scope='Complete initial/additive sources, correctness/allocation/ASM evidence and proposed timing preparation; no performance results', files=dict(sorted(files.items()))))
    verify_archive()
    print('FROZEN', len(sources), 'inputs,', len(dependencies), 'dependency sets,', len(binaries), 'binaries;', len(files), 'local artifacts; archive SHA', sha(ARCHIVE))


if __name__ == '__main__':
    main()
