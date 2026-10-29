#!/usr/bin/env python3
"""Frozen, leased empty-constructor inspection; never measures throughput."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from plan import HERE, ROOT, UPSTREAM, need, source_check, rendered


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def lease(cpu):
    need(cpu in (2, 3) and os.sched_getaffinity(0) == {cpu}, "Whole process must use declared CPU2 or CPU3")
    path = f"/tmp/fastest-bf-socket{cpu % 2}.lock"
    fds = []
    for entry in Path('/proc/self/fd').iterdir():
        try:
            if os.readlink(entry) == path:
                text = Path('/proc/self/fdinfo', entry.name).read_text()
                need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s', text, re.M), "Lease is not an inherited write lock")
                fds.append(int(entry.name))
        except FileNotFoundError:
            pass
    need(fds, "Missing socket lease")
    return sorted(fds)


def frozen(commit):
    need(re.fullmatch('[0-9a-f]{40}', commit) is not None, "Full source commit required")
    source_check()
    prep = HERE / 'PREPARATION.json'
    files = json.loads(prep.read_text())['files']
    for name, digest in {**files, 'PREPARATION.json': sha(prep)}.items():
        path = HERE / name
        need(sha(path) == digest, "Preparation digest changed: " + name)
        expected = subprocess.check_output(['git', 'show', commit + ':' + str(path.relative_to(ROOT))], cwd=ROOT)
        need(path.read_bytes() == expected, "Committed source changed: " + name)
    for name, text in rendered().items():
        need((HERE / name).read_text() == text, "Constructor ledger does not reproduce")
    return files


def artifact(output, test):
    found = []
    for line in output.splitlines():
        item = json.loads(line)
        if (item.get('reason') == 'compiler-artifact' and item['target']['name'] == 'poppy-public-geometry'
                and item['profile']['test'] == test and item.get('executable')):
            need(Path(item['manifest_path']).resolve() == HERE / 'Cargo.toml', 'Wrong inspector package')
            found.append(Path(item['executable']))
    need(len(found) == 1, "Missing unique structured inspector artifact")
    return found[0]


def check_rows(rows):
    selected = json.loads((HERE / 'selection.json').read_text())['rows']
    need(len(rows) == len(selected) == 86, "Incomplete fixed constructor coverage")
    for row, expected in zip(rows, selected):
        for observed, key in [('id', 'id'), ('n', 'n'), ('policy', 'policy'), ('fpp_bits', 'fpp_bits'),
                              ('capacity', 'per_bucket_capacity'), ('buckets', 'buckets'),
                              ('cache_bytes', 'cache_bytes'), ('probes', 'probes'), ('owned_bytes', 'backing_bytes')]:
            need(row[observed] == expected[key], 'Public geometry differs: ' + expected['id'])
        need(row['constructor_peak_bytes'] >= row['owned_bytes'], 'Invalid constructor peak')
        need(row['inspection_peak_bytes'] > 0 and row['retained_metadata_bytes'] == 56, 'Missing separate inspection scratch')
        need(row['serialized_bytes'] == 56 + row['owned_bytes'], 'Incorrect public serialization size')
        need(row['filter_inserts'] == 0 and row['timings'] is False, 'Scope exceeds empty constructor proof')


def main():
    need(__debug__, "Python -O is forbidden")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit', required=True)
    parser.add_argument('--cpu', type=int, required=True)
    args = parser.parse_args()
    fds = lease(args.cpu)
    sources = frozen(args.source_commit)
    rejected = ['RUSTFLAGS', 'RUSTDOCFLAGS', 'CARGO_ENCODED_RUSTFLAGS', 'RUSTC_WRAPPER', 'RUSTC_WORKSPACE_WRAPPER',
                'CARGO_TARGET_DIR', 'LD_PRELOAD', 'LD_LIBRARY_PATH', 'MALLOC_CONF', 'GLIBC_TUNABLES']
    environment = {key: os.environ.get(key) for key in rejected}
    need(not any(environment.values()), 'Unfrozen compiler/loader environment')
    output = HERE / 'validation-v1'
    target = ROOT / 'build/poppy-public-geometry-v1'
    need(not output.exists() and not output.is_symlink() and not target.exists() and not target.is_symlink(),
         'Preserve every prior build and output attempt')
    output.mkdir()
    env = os.environ.copy()
    env.update(CARGO_TARGET_DIR=str(target), CARGO_BUILD_JOBS='1', RUSTFLAGS='-C target-cpu=native')
    # Preserve any Cargo configuration Cargo can find; do not claim these files are all consumed.
    configs = {}
    ancestors = [HERE, *HERE.parents]
    cargo_home = Path(os.environ.get('CARGO_HOME', Path.home() / '.cargo'))
    for base in [p / '.cargo' for p in ancestors] + [cargo_home]:
        for name in ('config', 'config.toml'):
            path = base / name
            if path.is_file():
                configs[str(path)] = dict(sha256=sha(path))
    meta = dict(complete=False, source_commit=args.source_commit, sources=sources, cpu=args.cpu,
                inherited_lock_descriptors=fds, inherited_environment=environment,
                command_environment={'CARGO_TARGET_DIR': str(target), 'CARGO_BUILD_JOBS': '1', 'RUSTFLAGS': '-C target-cpu=native'},
                cargo_config_inventory=configs, commands=[], binary=None, filter_inserts=0, throughput_samples=0)
    def save(): write(output / 'metadata.json', meta)
    def run(label, argv):
        need(lease(args.cpu) == fds, 'Socket lease drift')
        record = dict(label=label, command=list(map(str, argv)), complete=False)
        meta['commands'].append(record); save()
        result = subprocess.run(record['command'], cwd=HERE, env=env, pass_fds=tuple(fds), capture_output=True)
        for stream, data in [('stdout', result.stdout), ('stderr', result.stderr)]:
            path = output / (label + '.' + stream); path.write_bytes(data)
            record[stream] = path.name; record[stream + '_sha256'] = sha(path)
        record['returncode'] = result.returncode; save()
        need(result.returncode == 0, 'Preserved failed command: ' + label)
        record['complete'] = True; save()
        return result.stdout.decode()
    save()
    try:
        run('rust-version', ['rustc', '-Vv'])
        run('cargo-version', ['cargo', '-V'])
        run('offline-planner-tests', [sys.executable, '-m', 'unittest', 'test_plan.py', 'test_validation.py'])
        run('cargo-metadata', ['cargo', 'metadata', '--locked', '--offline', '--format-version=1'])
        common = ['--locked', '--offline', '--release', '--message-format=json']
        build = run('inspector-build', ['cargo', 'build', '--bin', 'poppy-public-geometry', *common])
        binary = artifact(build, False)
        need(binary.is_relative_to(target) and binary.is_file(), 'Wrong inspector artifact location')
        meta['binary'] = dict(path=str(binary), sha256=sha(binary)); save()
        test_build = run('parser-test-build', ['cargo', 'test', '--no-run', '--bin', 'poppy-public-geometry', *common])
        test_binary = artifact(test_build, True)
        need(test_binary.is_relative_to(target) and test_binary.is_file(), 'Wrong parser test artifact location')
        meta['parser_test_binary'] = dict(path=str(test_binary), sha256=sha(test_binary)); save()
        test_text = run('parser-tests', [test_binary, '--test-threads=1'])
        need('2 passed; 0 failed' in test_text, 'Parser tests incomplete')
        raw = run('constructors', [binary, HERE / 'constructors.tsv'])
        rows = [json.loads(line) for line in raw.splitlines()]
        check_rows(rows)
        # Retain actual dep-info text without guessing relative Cargo source ownership.
        dependencies = {}
        dep_dir = output / 'dep-info'; dep_dir.mkdir()
        for i, path in enumerate(sorted(target.rglob('*.d'))):
            local = dep_dir / f'{i:03d}.d'; local.write_bytes(path.read_bytes())
            dependencies[str(path)] = dict(archive=str(local.relative_to(output)), sha256=sha(path))
        need(dependencies, 'Missing compiler dependency evidence')
        meta['actual_dep_info_files'] = dependencies
        need(frozen(args.source_commit) == sources and sha(binary) == meta['binary']['sha256'], 'Final source/binary drift')
        need(sha(test_binary) == meta['parser_test_binary']['sha256'], 'Final parser test binary drift')
        for path, item in configs.items(): need(sha(path) == item['sha256'], 'Cargo config changed during proof')
        meta.update(complete=True, constructor_rows=len(rows), actual_owned_allocation_verified=True,
                    semantic_workload_run=False, live_inputs_unchanged=True)
        save()
        print('PASS86 public empty constructors; allocation/geometry only, zero inserts and zero throughput samples')
    except BaseException as error:
        meta.update(complete=False, failure=repr(error)); save(); raise


if __name__ == '__main__':
    main()
