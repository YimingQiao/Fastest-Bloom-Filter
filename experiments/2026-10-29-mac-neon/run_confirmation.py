#!/usr/bin/env python3
"""Fixed, held-out Mac bulk screen. Never run benchmark processes concurrently."""
import argparse
import csv
import hashlib
import io
import json
from pathlib import Path
import random
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
PRIMARY = ','.join((
    'ByteSplitBloomFilter', 'Split16BloomFilter', 'Word64BloomFilter', 'FastPatternBF', 'Split64BloomFilter',
    'MacOriginalByteSplit', 'MacOriginalPattern',
    'Boost192Block64K4', 'Boost192Block64K6', 'Boost192Block64K8',
    'Boost192Multi32K8', 'Boost192Multi64K4',
    'FastFilterArm16',
))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--binary', type=Path, default=ROOT / 'build/mac-confirm/compare_benchmark')
    parser.add_argument('--output', type=Path, default=Path(__file__).resolve().parent / 'confirmation.csv')
    parser.add_argument('--guardrails', action='store_true')
    args = parser.parse_args()
    binary = args.binary.resolve()
    if args.guardrails:
        cases = [(power, hit, batch, 8191) for power in (16, 22, 25)
                 for hit in (0, 50, 100) for batch in (1, 31, 4096)]
        selection = 'ByteSplitBloomFilter,Split16BloomFilter,Word64BloomFilter,FastFilterArm16,FastPatternBF,MacOriginalByteSplit,MacOriginalPattern'
    else:
        cases = [(power, 0, 4096, seed) for seed in (6007, 7001, 8009)
                 for power in (16, 20, 22, 24, 25)]
        selection = PRIMARY
    random.Random(20261029).shuffle(cases)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    provenance = {
        'binary': str(binary), 'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(),
        'base_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
        'compiler': subprocess.check_output(['clang++', '--version'], text=True),
        'hardware': subprocess.check_output(['sysctl', 'machdep.cpu.brand_string', 'hw.memsize',
                                             'hw.cachelinesize', 'hw.perflevel0.physicalcpu',
                                             'hw.perflevel0.l2cachesize'], text=True),
        'os': subprocess.check_output(['sw_vers'], text=True),
        'start_time_utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
        'selection': selection, 'commands': [],
        'contract': '16 actual bits/key; FPR ceiling 1%; prehashed and hash-inclusive; single thread; '
                    'allocation separately reported; five repetitions per randomized in-process job; '
                    '4096 insertion batch; 2^22 independent calibration negatives; no CPU pinning',
    }
    source_files = [
        'include/base.h', 'include/layout_detail.h', 'include/byte_split_bloom.h',
        'include/split16_bloom.h', 'include/word64_bloom.h', 'include/fast_pattern_BF.h', 'include/split64_bloom.h',
        'src/compare_benchmark.cpp', 'benchmarks/boost-external/adapters.hpp',
        'benchmarks/boost-external/upstream.json', 'benchmarks/cpp-external/upstreams.json',
    ]
    source_files += [str(path.relative_to(ROOT)) for path in Path(__file__).resolve().parent.iterdir()
                     if path.suffix in ('.h', '.hpp')]
    provenance['source_sha256'] = {path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
                                 for path in source_files}
    all_rows = []
    for power, hit, batch, seed in cases:
        command = [str(binary), str(power), '8', str(hit), '22', str(batch), '5', str(seed),
                   selection, '4096', '22']
        provenance['commands'].append(command)
        result = subprocess.run(command, text=True, capture_output=True, check=True)
        rows = list(csv.DictReader(io.StringIO(result.stdout)))
        assert {r['filter'] for r in rows} == set(selection.split(','))
        for row in rows:
            assert int(row['filter_bytes']) <= (1 << power) * 2
            assert int(row['calibration_absent_queries']) == 1 << 22
        by_name = {row['filter']: row for row in rows}
        for current, original in (('ByteSplitBloomFilter', 'MacOriginalByteSplit'),
                                  ('FastPatternBF', 'MacOriginalPattern')):
            if current in by_name and original in by_name:
                for field in ('filter_bytes', 'false_positives', 'calibration_false_positives', 'result_checksum'):
                    assert by_name[current][field] == by_name[original][field], (current, field)
        all_rows.extend(rows)
        with args.output.open('w') as stream:
            writer = csv.DictWriter(stream, fieldnames=all_rows[0])
            writer.writeheader()
            writer.writerows(all_rows)
        args.output.with_suffix('.json').write_text(
            json.dumps(provenance, indent=2).replace(str(ROOT), '$REPO') + '\n')
        best = min(rows, key=lambda row: float(row['lookup_ns']))
        print(f'n=2^{power} hit={hit} batch={batch} seed={seed}: '
              f'{best["filter"]} {best["lookup_ns"]} ns/query', flush=True)


if __name__ == '__main__':
    main()
