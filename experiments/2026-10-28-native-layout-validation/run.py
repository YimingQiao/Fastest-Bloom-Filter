#!/usr/bin/env python3
"""Rebuild correctness/sanitizer and frozen-layout parity checks; no speed measurements."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir', required=True, type=Path)
    parser.add_argument('--cpu', type=int, default=3)
    parser.add_argument('--cases', help='Comma-separated native-*/parity-* names; all by default')
    args = parser.parse_args()
    out = args.output_dir.resolve()
    out.mkdir(parents=True, exist_ok=False)
    chosen = None if args.cases is None else set(args.cases.split(','))
    cases = []
    for item in json.loads((HERE / 'native-tests.json').read_text()):
        cases.append(('native-' + item['name'], item['build_command']))
    for item in json.loads((HERE / 'frozen-parity.json').read_text()):
        cases.append(('parity-' + item['name'], item['command']))
    if chosen is not None and not chosen <= {name for name, _ in cases}:
        raise ValueError('Unknown case selection')
    source_files = json.loads((HERE / 'source-manifest.json').read_text())['sources']
    report = {
        'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
        'sources': {f: hashlib.sha256((REPO / f).read_bytes()).hexdigest() for f in source_files},
        'runs': [],
    }
    for name, old_cmd in cases:
        if chosen is not None and name not in chosen:
            continue
        cmd = old_cmd[:]
        cmd[2] = str(args.cpu)
        cmd = [str(HERE / 'parity.cpp') if x == '/tmp/bf-native-frozen-parity.cpp' else x for x in cmd]
        binary = out / name
        cmd[-1] = str(binary)
        build = subprocess.run(cmd, cwd=REPO, text=True, capture_output=True)
        item = {'name': name, 'build_command': cmd, 'compile_status': build.returncode, 'compile_stdout': build.stdout, 'compile_stderr': build.stderr}
        if build.returncode == 0:
            run_cmd = ['taskset', '-c', str(args.cpu), str(binary)]
            run = subprocess.run(run_cmd, cwd=REPO, text=True, capture_output=True)
            item.update(run_command=run_cmd, run_status=run.returncode, stdout=run.stdout, stderr=run.stderr, binary_sha256=hashlib.sha256(binary.read_bytes()).hexdigest())
            binary.unlink()
        report['runs'].append(item)
        (out / 'results.json').write_text(json.dumps(report, indent=2) + '\n')
        print(name, 'compile=', build.returncode, 'run=', item.get('run_status'), flush=True)
    if any(item['compile_status'] != 0 or item.get('run_status') != 0 for item in report['runs']):
        raise SystemExit(1)
    checksums = [item['stdout'] for item in report['runs'] if item['name'].startswith('parity-')]
    if checksums and any(value != checksums[0] for value in checksums):
        raise SystemExit('Parity checksums differ between ISA/compiler builds')


if __name__ == '__main__':
    main()
