#!/usr/bin/env python3
"""Run native/scalar/sanitizer oracles, then freeze inputs before calibration."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
records = []
builds = []
for label, compiler, options in (
    ('native', 'g++', []),
    ('asan', 'clang++', ['-DBF_SANITIZERS=ON']),
):
    build = ROOT / ('build/word16-' + label)
    builds.append(build)
    config = ['cmake', '-S', str(HERE), '-B', str(build), '-DCMAKE_CXX_COMPILER=' + compiler, *options]
    for dependency in ('fastfilter', 'pagebloom'):
        source = ROOT / 'build/all-external-confirmation/_deps' / (dependency + '-src')
        if source.is_dir():
            config.append('-DFETCHCONTENT_SOURCE_DIR_' + dependency.upper() + '=' + str(source))
    for step, command in (
        ('configure', config),
        ('build', ['cmake', '--build', str(build), '--parallel', '1']),
        ('ctest', ['ctest', '--test-dir', str(build), '--output-on-failure', '-V']),
    ):
        argv = ['taskset', '-c', '2', *command]
        started = time.monotonic()
        with (HERE / (label + '-' + step + '.log')).open('w') as output:
            result = subprocess.run(argv, cwd=ROOT, stdout=output, stderr=subprocess.STDOUT)
        records.append(dict(label=label, step=step, argv=argv, returncode=result.returncode, seconds=time.monotonic() - started))
        (HERE / 'validation.json').write_text(json.dumps(records, indent=2) + '\n')
        print(label, step, result.returncode, flush=True)
        result.check_returncode()
checksums = []
for label in ('native', 'asan'):
    checksums += re.findall(r'word16 oracle and tail checksum (\d+)', (HERE / (label + '-ctest.log')).read_text())
assert len(checksums) == 4 and len(set(checksums)) == 1, checksums
sources = {p for p in HERE.iterdir() if p.suffix in ('.cpp', '.hpp', '.py') or p.name in ('CMakeLists.txt', 'protocol.json')}
sources.update((ROOT / 'scripts/run_comparison.py', ROOT / 'benchmarks/cpp-external/dependencies.cmake', ROOT / 'benchmarks/cpp-external/upstreams.json', ROOT / 'third_party/FastFilter/LICENSE', ROOT / 'third_party/FastFilter/NOTICE'))
for build in builds:
    for depfile in build.rglob('*.o.d'):
        for token in depfile.read_text().replace('\\\n', ' ').split():
            path = Path(token)
            if path.is_absolute() and path.is_file() and path.is_relative_to(ROOT):
                sources.add(path.resolve())
snapshot = HERE / 'source-snapshot'
source_hashes = {}
for path in sorted(sources):
    relative = path.relative_to(ROOT)
    dest = snapshot / relative
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, dest)
    source_hashes[str(relative)] = sha(path)
binaries = [build / binary for build in builds for binary in ('check', 'check_scalar', 'compare_benchmark')]
freeze = dict(
    utc=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
    revision=subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
    binary='build/word16-native/compare_benchmark',
    binary_sha256=sha(builds[0] / 'compare_benchmark'),
    source_sha256=source_hashes,
    binaries={str(p.relative_to(ROOT)): sha(p) for p in binaries},
    oracle_checksum=int(checksums[0]),
    note='Frozen after all four oracle modes passed and before any calibration data. Source snapshots use repository-relative paths. All incidental harness timings are unclaimed.',
)
(HERE / 'freeze.json').write_text(json.dumps(freeze, indent=2) + '\n')
print('PASS four oracle modes; checksum', checksums[0], '; source freeze complete', flush=True)
