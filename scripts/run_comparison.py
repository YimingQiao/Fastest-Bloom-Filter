#!/usr/bin/env python3
"""Run serial, CPU-pinned comparisons and retain inputs, raw rows, and provenance."""
import argparse
import csv
import hashlib
import io
import json
import os
from pathlib import Path
import platform
import subprocess
import time


def capture(argv):
    result = subprocess.run(argv, text=True, capture_output=True)
    return result.stdout.strip() if result.returncode == 0 else result.stderr.strip()


def numbers(value):
    return [int(x) for x in value.split(',')]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--executable', default='build/native/compare_benchmark')
    parser.add_argument('--output-dir', required=True)
    parser.add_argument('--key-powers', type=numbers, default=[12, 16, 20, 24, 25])
    parser.add_argument('--bits-per-key', type=numbers, default=[16])
    parser.add_argument('--hits', type=numbers, default=[0, 50, 100])
    parser.add_argument('--batches', type=numbers, default=[4096])
    parser.add_argument('--seeds', type=numbers, default=[42, 43, 44])
    parser.add_argument('--query-power', type=int, default=22)
    parser.add_argument('--repeats', type=int, default=5)
    parser.add_argument('--cpu', type=int, default=min(os.sched_getaffinity(0)))
    parser.add_argument('--filters', default='', help='Comma-separated exact class names; empty selects all')
    args = parser.parse_args()
    if args.cpu not in os.sched_getaffinity(0):
        parser.error('CPU is not in the allowed affinity set')
    executable = Path(args.executable).resolve()
    output = Path(args.output_dir)
    output.mkdir(parents=True, exist_ok=False)
    repo = Path(__file__).resolve().parents[1]
    metadata = {
        'arguments': vars(args), 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
        'platform': platform.platform(), 'cpu': capture(['lscpu']),
        'revision': capture(['git', '-C', str(repo), 'rev-parse', 'HEAD']),
        'status': capture(['git', '-C', str(repo), 'status', '--short']),
        'executable_sha256': hashlib.sha256(executable.read_bytes()).hexdigest(),
        'cpu_affinity': [args.cpu], 'runs': [],
    }
    (output / 'source.patch').write_text(capture(['git', '-C', str(repo), 'diff', 'HEAD']))
    commands = executable.parent / 'compile_commands.json'
    if commands.exists():
        (output / 'compile_commands.json').write_bytes(commands.read_bytes())
    for compiler in ('clang++', 'g++'):
        metadata[compiler] = capture([compiler, '--version'])
    with (output / 'results.csv').open('w', newline='') as f:
        writer = None
        for n in args.key_powers:
            for bits in args.bits_per_key:
                for hit in args.hits:
                    for batch in args.batches:
                        for seed in args.seeds:
                            cmd = ['taskset', '-c', str(args.cpu), str(executable), str(n), str(bits),
                                   str(hit), str(args.query_power), str(batch), str(args.repeats), str(seed),
                                   args.filters]
                            print(f'keys=2^{n} bpk={bits} hit={hit}% batch={batch} seed={seed}', flush=True)
                            started = time.monotonic()
                            run = subprocess.run(cmd, text=True, capture_output=True)
                            tag = f'k{n}-b{bits}-h{hit}-q{batch}-s{seed}'
                            (output / f'{tag}.csv').write_text(run.stdout)
                            if run.stderr:
                                (output / f'{tag}.stderr').write_text(run.stderr)
                            metadata['runs'].append({'command': cmd, 'returncode': run.returncode,
                                                     'seconds': time.monotonic() - started})
                            (output / 'metadata.json').write_text(json.dumps(metadata, indent=2)+'\n')
                            run.check_returncode()
                            reader = csv.DictReader(io.StringIO(run.stdout))
                            if writer is None:
                                writer = csv.DictWriter(f, fieldnames=reader.fieldnames)
                                writer.writeheader()
                            for row in reader:
                                writer.writerow(row)
                            f.flush()


if __name__ == '__main__':
    main()
