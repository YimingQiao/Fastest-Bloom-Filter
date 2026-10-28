#!/usr/bin/env python3
"""Run the optional shared-harness prototype screen; creates a new output directory."""
import argparse
import csv
import hashlib
import io
import itertools
import json
from pathlib import Path
import random
import subprocess
import time

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[1]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output-dir', type=Path, required=True)
    p.add_argument('--binary', type=Path, default=REPO / 'build/four-sector-probe/compare_benchmark')
    p.add_argument('--cpu', type=int, default=3)
    p.add_argument('--key-powers', default='16,20,24')
    p.add_argument('--requested-bpk', default='8,16')
    p.add_argument('--hits', default='50')
    p.add_argument('--seeds', default='42')
    p.add_argument('--batches', default='4096')
    p.add_argument('--repeats', type=int, default=5)
    p.add_argument('--query-power', type=int, default=22)
    p.add_argument('--filters', default='FourSectorFrozen,FourSectorGroup4,FourSectorGroup8,FourSectorPrefetch,FourSectorGroup4Prefetch,FourSectorGroup8Prefetch')
    args = p.parse_args()
    out = args.output_dir.resolve()
    out.mkdir(parents=True, exist_ok=False)
    binary = args.binary.resolve()
    sources = list(ROOT.glob('*.h')) + list(ROOT.glob('*.hpp')) + list(ROOT.glob('*.txt')) + list(ROOT.glob('*.cpp')) + list(ROOT.glob('*.py')) + list((REPO / 'include').glob('*.h'))
    sources += [REPO / 'src/compare_benchmark.cpp', ROOT.parent / '2026-10-28-split64/split64.hpp', REPO / 'benchmarks/boost-external/adapters.hpp']
    hashes = {str(f.relative_to(REPO)): hashlib.sha256(f.read_bytes()).hexdigest() for f in sources}
    metadata = {
        'arguments': {**vars(args), 'output_dir': str(out), 'binary': str(binary)},
        'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(),
        'sources': hashes,
        'git_head': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip(),
        'cpu': subprocess.check_output(['lscpu'], text=True),
        'compiler': subprocess.check_output(['clang++', '--version'], text=True),
        'compile_commands': json.loads((binary.parent / 'compile_commands.json').read_text()),
        'runs': [],
    }
    scenarios = list(itertools.product(*(v.split(',') for v in [args.key_powers, args.requested_bpk, args.hits, args.seeds, args.batches])))
    random.Random(42).shuffle(scenarios)
    writer = None
    with (out / 'timing.csv').open('w') as f:
        for power, bpk, hit, seed, batch in scenarios:
            cmd = ['taskset', '-c', str(args.cpu), str(binary), power, bpk, hit, str(args.query_power), batch, str(args.repeats), seed, args.filters, str(1 << int(power))]
            start = time.monotonic()
            result = subprocess.check_output(cmd, text=True)
            rows = list(csv.DictReader(io.StringIO(result)))
            assert len(rows) == len(args.filters.split(','))
            reference = next(r for r in rows if r['filter'] == 'FourSectorFrozen')
            for row in rows:
                for field in ('result_checksum', 'filter_bytes', 'false_positives', 'absent_queries', 'present_queries'):
                    assert row[field] == reference[field], (row['filter'], field)
            if writer is None:
                writer = csv.DictWriter(f, fieldnames=list(rows[0]), lineterminator='\n')
                writer.writeheader()
            writer.writerows(rows)
            f.flush()
            metadata['runs'].append({'command': cmd, 'seconds': time.monotonic() - start})
            print(f'finished n=2^{power}, bpk={bpk}, hit={hit}, seed={seed}, batch={batch}', flush=True)
    metadata['utc'] = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
    metadata['sources_changed_during_run'] = [str(f.relative_to(REPO)) for f in sources if hashlib.sha256(f.read_bytes()).hexdigest() != hashes[str(f.relative_to(REPO))]]
    (out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')


if __name__ == '__main__':
    main()
