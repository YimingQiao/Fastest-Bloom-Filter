#!/usr/bin/env python3
"""One four-profile correctness run; no accuracy/timing entry point."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / 'validation-v1'
LOCK = Path('/tmp/fastest-bf-socket1.lock')
PROFILES = [('native', 'native', False, 'avx512vbmi-vl'),
            ('avx2', 'avx2', False, 'avx2'),
            ('scalar', 'scalar', False, 'scalar-source'),
            ('native-asan', 'native', True, 'avx512vbmi-vl')]


def need(value, why):
    if not value:
        raise RuntimeError(why)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')


def source(commit):
    need(re.fullmatch('[0-9a-f]{40}', commit), 'full source commit required')
    prep = HERE / 'PREPARATION.json'
    manifest = json.loads(prep.read_text())
    for relative in list(manifest['files']) + ['PREPARATION.json']:
        p = HERE / relative
        need(p.resolve().is_relative_to(HERE) and not p.is_symlink(), 'source path escaped')
        data = subprocess.check_output(['git', 'show', commit + ':' + str(p.relative_to(ROOT))], cwd=ROOT)
        need(p.read_bytes() == data, 'committed source drift: ' + relative)
        if relative != 'PREPARATION.json':
            item = manifest['files'][relative]
            need(len(data) == item['bytes'] and hashlib.sha256(data).hexdigest() == item['sha256'], 'source inventory drift')
    return manifest


def placement():
    need(os.sched_getaffinity(0) == {3}, 'CPU3-only parent required')
    fds = []
    for entry in Path('/proc/self/fd').iterdir():
        try:
            if entry.resolve() == LOCK and 'FLOCK  ADVISORY  WRITE' in Path('/proc/self/fdinfo', entry.name).read_text():
                fds.append(int(entry.name))
        except FileNotFoundError:
            continue
    need(fds, 'inherited exclusive socket1 flock required')
    for key in ('LD_PRELOAD', 'LD_LIBRARY_PATH', 'CXXFLAGS', 'CPPFLAGS', 'LDFLAGS',
                'CMAKE_TOOLCHAIN_FILE', 'MALLOC_CONF', 'MALLOC_ARENA_MAX'):
        need(not os.environ.get(key), 'unexpected environment: ' + key)
    status = Path('/proc/self/status').read_text()
    mems = re.search(r'^Mems_allowed_list:\s*(.*)$', status, re.M).group(1)
    return {'affinity': [3], 'mems_allowed_list': mems, 'socket_lock': str(LOCK), 'flock_fds': fds}


def dependencies(build, manifest):
    raw = list(build.rglob('check.cpp.o.d'))
    need(len(raw) == 1, 'expected one actual checker depfile')
    data = raw[0].read_text().replace('\\\n', ' ')
    need(': ' in data or ':\n' in data, 'malformed depfile')
    rhs = data.split(':', 1)[1]
    paths = {Path(t) if Path(t).is_absolute() else build / t for t in shlex.split(rhs)}
    result = {}
    for p in paths:
        p = p.resolve()
        need(p.is_file(), 'missing actual input: ' + str(p))
        if p.is_relative_to(ROOT):
            need(p.is_relative_to(HERE) and str(p.relative_to(HERE)) in manifest['files'], 'unprepared repository dependency: ' + str(p))
        result[str(p)] = sha(p)
    for name in ('check.cpp', 'candidate.hpp', 'control.hpp', 'snapshot/base.h',
                 'snapshot/layout_detail.h', 'snapshot/split64_range_size.h'):
        need(str(HERE / name) in result, 'missing actual prepared input: ' + name)
    return raw[0], result


def main():
    need(__debug__, 'Python -O forbidden')
    p = argparse.ArgumentParser()
    p.add_argument('--source-commit', required=True)
    args = p.parse_args()
    manifest = source(args.source_commit)
    lease = placement()
    need(not OUT.exists(), 'preserve existing validation output')
    builds = {name: ROOT / ('build/independent32-range-v1-' + name) for name, *_ in PROFILES}
    need(all(not b.exists() for b in builds.values()), 'all build roots must be fresh')
    # Retain the clang++ invocation name: resolving it to clang changes linking.
    compiler = Path(shutil.which('clang++')).absolute()
    tool_paths = [compiler, Path(shutil.which('cmake')).absolute(), Path(shutil.which('numactl')).absolute()]
    tool_hashes = {str(t): sha(t) for t in tool_paths}
    OUT.mkdir()
    meta = {'complete': False, 'scope': 'four-profile correctness only; no accuracy or timings',
            'source_commit': args.source_commit, 'preparation_sha256': sha(HERE / 'PREPARATION.json'),
            'placement': lease, 'tools': tool_hashes, 'commands': [], 'profiles': {}}
    save(OUT / 'metadata.json', meta)

    def unchanged():
        source(args.source_commit)
        for path, digest in tool_hashes.items(): need(sha(Path(path)) == digest, 'tool drift')
        for value in meta['profiles'].values():
            need(sha(Path(value['binary'])) == value['sha256'], 'binary drift')
            for path, digest in value['compiler_inputs'].items(): need(sha(Path(path)) == digest, 'actual input drift')

    def run(name, command, expected=None):
        placement()
        result = subprocess.run(command, cwd=ROOT, capture_output=True, pass_fds=tuple(lease['flock_fds']))
        stdout = OUT / (name + '.stdout'); stderr = OUT / (name + '.stderr')
        stdout.write_bytes(result.stdout); stderr.write_bytes(result.stderr)
        meta['commands'].append({'command': command, 'returncode': result.returncode,
                                 'stdout': stdout.name, 'stdout_sha256': sha(stdout),
                                 'stderr': stderr.name, 'stderr_sha256': sha(stderr)})
        save(OUT / 'metadata.json', meta)
        need(result.returncode == 0, name + ' failed; stop with logs preserved')
        if expected is not None:
            need(result.stdout.decode() == expected and not result.stderr, name + ' unexpected backend/output')
        return result.stdout

    run('compiler-version', [str(compiler), '--version'])
    run('numa-placement', [str(tool_paths[2]), '--show'])
    for name, isa, sanitize, backend in PROFILES:
        build = builds[name]
        unchanged()
        run(name + '-configure', [str(tool_paths[1]), '-S', str(HERE), '-B', str(build),
            '-DCMAKE_CXX_COMPILER=' + str(compiler), '-DINDEPENDENT_ISA=' + isa,
            '-DINDEPENDENT_SANITIZERS=' + ('ON' if sanitize else 'OFF')])
        run(name + '-build', [str(tool_paths[1]), '--build', str(build), '--parallel', '1'])
        # Close actual compiler inputs and the executable before its first run.
        depfile, inputs = dependencies(build, manifest)
        (OUT / (name + '.d')).write_bytes(depfile.read_bytes())
        (OUT / (name + '-compile_commands.json')).write_bytes((build / 'compile_commands.json').read_bytes())
        (OUT / (name + '-CMakeCache.txt')).write_bytes((build / 'CMakeCache.txt').read_bytes())
        executable = build / 'check'
        meta['profiles'][name] = {'binary': str(executable), 'sha256': sha(executable), 'expected_backend': backend,
                                  'compiler_inputs': inputs, 'passed': False}
        save(OUT / 'metadata.json', meta)
        unchanged()
        expected = 'PASS backend=' + backend + '; 4 candidate + 2 control constructions; 324 tail/offset calls; 1024 required-bit cases; 5 invalid sizes\n'
        run(name + '-check', [str(executable)], expected)
        meta['profiles'][name]['passed'] = True
        save(OUT / 'metadata.json', meta)
        print('Passed ' + name, flush=True)
    unchanged()
    meta['complete'] = True
    save(OUT / 'metadata.json', meta)
    print('Complete four-profile correctness; no accuracy or timing run', flush=True)


if __name__ == '__main__':
    main()
