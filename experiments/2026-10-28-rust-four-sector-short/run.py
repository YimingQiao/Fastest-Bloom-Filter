#!/usr/bin/env python3
"""Serial same-process Rust old-prototype/new-native short-batch confirmation."""
import argparse
import csv
import hashlib
import io
import json
import subprocess
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
EXP = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--cpu', type=int, default=3)
parser.add_argument('--executable', type=Path, default=Path('/tmp/fastest-bf-rust-short-confirmation/release/compare_benchmark'))
parser.add_argument('--output-dir', type=Path, required=True)
args = parser.parse_args()
args.output_dir.mkdir(parents=True, exist_ok=False)
files = ['rust/src/four_sector.rs', 'rust/src/layout_parallel.rs',
         'experiments/2026-10-28-rust-four-sector-short/benchmark/src/main.rs',
         'experiments/2026-10-28-rust-four-sector-short/benchmark/src/before.rs',
         'experiments/2026-10-28-rust-four-sector-short/benchmark/Cargo.toml',
         'experiments/2026-10-28-rust-four-sector-short/benchmark/Cargo.lock']
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
metadata = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'cpu': args.cpu,
            'revision': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
            'rustflags': '-C target-cpu=native', 'rustc': subprocess.check_output(['rustc', '-vV'], text=True),
            'binary_sha256': sha(args.executable), 'source_sha256': {p: sha(ROOT / p) for p in files},
            'commands': [], 'workloads': 12, 'expected_rows': 24}
fields = ['filter_bytes', 'result_checksum', 'false_positives', 'absent_queries']
with (args.output_dir / 'results.csv').open('w', newline='') as file:
    writer = None
    for power in [16, 24]:
        for batch in [8, 31, 4096]:
            for seed in [2053, 4099]:
                cmd = ['taskset', '-c', str(args.cpu), str(args.executable), str(power), '8', '50', '22',
                       str(batch), '5', str(seed), '', str(1 << power)]
                result = subprocess.run(cmd, check=True, capture_output=True, text=True)
                rows = list(csv.DictReader(io.StringIO(result.stdout)))
                assert {r['filter'] for r in rows} == {'FourSector16K8Experimental', 'FourSectorBloomFilter'}
                for field in fields:
                    assert len({r[field] for r in rows}) == 1, (cmd, field)
                if writer is None:
                    writer = csv.DictWriter(file, fieldnames=list(rows[0]))
                    writer.writeheader()
                writer.writerows(rows)
                file.flush()
                (args.output_dir / f'k{power}-b{batch}-s{seed}.csv').write_text(result.stdout)
                metadata['commands'].append(cmd)
                (args.output_dir / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
                print(f'keys=2^{power} batch={batch} seed={seed}: paired checksums/FP/bytes match', flush=True)
assert sha(args.executable) == metadata['binary_sha256'], 'binary changed during run'
assert all(sha(ROOT / p) == h for p, h in metadata['source_sha256'].items()), 'source changed during run'
print('PASS: 12 workloads / 24 rows; before/after answers and bytes match')
