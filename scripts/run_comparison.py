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


def selected_filters(value):
    if not value:
        return None
    names = value.split(',')
    if any(not name or name != name.strip() for name in names):
        raise ValueError('filter names must be nonempty and have no surrounding whitespace')
    if len(set(names)) != len(names):
        raise ValueError('duplicate filter name')
    return set(names)


def validate_rows(rows, expected_filters, expected_fields):
    """Reject incomplete selections and mismatched workloads before aggregation."""
    if not rows:
        raise ValueError('benchmark returned no result rows')
    names = [row['filter'] for row in rows]
    if len(set(names)) != len(names):
        raise ValueError('benchmark returned duplicate filter rows')
    if len({row['language'] for row in rows}) != 1:
        raise ValueError('one executable must return one language')
    actual = set(names)
    if expected_filters is not None and actual != expected_filters:
        raise ValueError(f'filter selection mismatch: missing={sorted(expected_filters - actual)}, '
                         f'unexpected={sorted(actual - expected_filters)}')
    for row in rows:
        for field, expected in expected_fields.items():
            if int(row[field]) != expected:
                raise ValueError(f'{row["filter"]}: {field}={row[field]}, expected {expected}')
    return actual


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
    parser.add_argument('--filters', default='', help='Comma-separated exact class names; empty keeps the default suite. Native optional names: Split64RangeBloomFilter,FourSectorRange12BloomFilter')
    parser.add_argument('--binary-source-revision', help='Explicit source commit for an already-built, frozen executable; launch workspace provenance is retained separately')
    parser.add_argument('--insert-batch', type=int, default=None, help='Independent build batch size; 0=all inserted keys; default equals query batch')
    parser.add_argument('--calibration-power', type=int, default=0, help='Extra untimed disjoint negative probes; 0=disabled; requires a current calibrated harness')
    args = parser.parse_args()
    try:
        expected_filters = selected_filters(args.filters)
    except ValueError as error:
        parser.error(str(error))
    if args.cpu not in os.sched_getaffinity(0):
        parser.error('CPU is not in the allowed affinity set')
    executable = Path(args.executable).resolve()
    output = Path(args.output_dir)
    output.mkdir(parents=True, exist_ok=False)
    repo = Path(__file__).resolve().parents[1]
    binary_revision = None
    if args.binary_source_revision:
        if not (7 <= len(args.binary_source_revision) <= 40) or any(c not in '0123456789abcdefABCDEF' for c in args.binary_source_revision):
            parser.error('--binary-source-revision must be a commit hash')
        binary_revision = subprocess.check_output(['git', '-C', str(repo), 'rev-parse', '--verify', args.binary_source_revision + '^{commit}'], text=True).strip()
    metadata = {
        'arguments': vars(args), 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
        'platform': platform.platform(), 'cpu': capture(['lscpu']),
        'revision': capture(['git', '-C', str(repo), 'rev-parse', 'HEAD']),
        'status': capture(['git', '-C', str(repo), 'status', '--short']),
        'executable_sha256': hashlib.sha256(executable.read_bytes()).hexdigest(),
        'cpu_affinity': [args.cpu], 'runs': [],
        'binary_source_revision': binary_revision,
    }
    (output / 'source.patch').write_text(capture(['git', '-C', str(repo), 'diff', 'HEAD']))
    commands = executable.parent / 'compile_commands.json'
    if commands.exists():
        (output / 'compile_commands.json').write_bytes(commands.read_bytes())
    upstreams = executable.parent / 'upstreams.json'
    if upstreams.exists():
        metadata['upstreams'] = json.loads(upstreams.read_text())
    metadata['RUSTFLAGS'] = os.environ.get('RUSTFLAGS', '')
    metadata['rustc'] = capture(['rustc', '-Vv'])
    metadata['cargo'] = capture(['cargo', '--version'])
    metadata['rust_build_fingerprints'] = {str(p): json.loads(p.read_text()) for p in executable.parent.glob('.fingerprint/fastest-bloom-filter-*/bin-compare_benchmark.json')}
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
                            if args.insert_batch is not None or args.calibration_power:
                                cmd.append(str((args.insert_batch or (1 << n)) if args.insert_batch is not None else batch))
                            if args.calibration_power:
                                cmd.append(str(args.calibration_power))
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
                            rows = list(reader)
                            expected = {'keys': 1 << n, 'queries': 1 << args.query_power,
                                        'requested_bpk': bits, 'hit_percent': hit, 'batch': batch,
                                        'repeats': args.repeats, 'seed': seed}
                            if args.insert_batch is not None:
                                expected['insert_batch'] = args.insert_batch or (1 << n)
                            if args.calibration_power:
                                expected['calibration_absent_queries'] = 1 << args.calibration_power
                            expected_filters = validate_rows(rows, expected_filters, expected)
                            if writer is None:
                                writer = csv.DictWriter(f, fieldnames=reader.fieldnames, lineterminator='\n')
                                writer.writeheader()
                            for row in rows:
                                writer.writerow(row)
                            f.flush()


if __name__ == '__main__':
    main()
