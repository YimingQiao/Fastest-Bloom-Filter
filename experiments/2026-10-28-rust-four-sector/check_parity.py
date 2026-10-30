#!/usr/bin/env python3
"""Cross-language answer checks; emitted timing values are not performance evidence."""
import csv
import hashlib
import io
import json
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
CPP = ROOT / 'build/four-sector/compare_benchmark'
RUST = ROOT / 'benchmarks/rust-external/target/release/compare_benchmark'
FIELDS = ['keys', 'queries', 'requested_bpk', 'filter_bytes', 'hash_bits', 'hit_percent',
          'present_queries', 'batch', 'seed', 'absent_queries', 'false_positives',
          'result_checksum', 'input_mode', 'insert_batch', 'calibration_absent_queries',
          'calibration_false_positives']

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

# Exercise scalar and masked/vector batch tails, prepared insertion tails,
# three occupancy levels and hit rates, then both sides of the prefetch threshold.
cases = []
for bpk in [4, 8, 16]:
    for hit in [0, 50, 100]:
        for batch, insert_batch in [(1, 1), (4, 3), (17, 17)]:
            cases.append((12, bpk, hit, 12, batch, 1, 731, insert_batch, 16))
for batch, insert_batch in [(3, 4), (7, 7), (15, 15), (16, 16), (31, 31), (4096, 4096)]:
    cases.append((16, 8, 50, 14, batch, 1, 20261028, insert_batch, 16))
for batch, insert_batch in [(17, 17), (4096, 1048576)]:
    cases.append((20, 16, 50, 16, batch, 1, 8675309, insert_batch, 18))

rows = []
commands = []
for case in cases:
    pair = []
    for binary, name in [(CPP, 'FourSector16K8'), (RUST, 'FourSector16K8Experimental')]:
        args = [str(x) for x in case[:7]] + [name] + [str(x) for x in case[7:]]
        cmd = ['taskset', '-c', '3', str(binary), *args]
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        parsed = list(csv.DictReader(io.StringIO(result.stdout)))
        assert len(parsed) == 1
        pair.append(parsed[0])
        commands.append(cmd)
    for field in FIELDS:
        assert pair[0][field] == pair[1][field], (case, field, pair)
    for row in pair:
        # C++ alone emits scratch columns. Keep only common fields in this artifact.
        rows.append({key: row[key] for key in ['language', 'filter', *FIELDS]})
with (OUT / 'parity.csv').open('w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=list(rows[0]))
    writer.writeheader()
    writer.writerows(rows)
files = ['benchmarks/rust-external/src/four_sector.rs', 'benchmarks/rust-external/src/main.rs',
         'experiments/2026-10-28-four-sector/four_sector.h',
         'experiments/2026-10-28-four-sector/masks2-count16.txt', 'src/compare_benchmark.cpp']
metadata = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'cases': len(cases),
            'purpose': 'correctness parity only; no performance claim',
            'revision': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
            'rustc': subprocess.check_output(['rustc', '-vV'], text=True),
            'rustflags': '-C target-cpu=native',
            'binaries': {str(path.relative_to(ROOT)): digest(path) for path in [CPP, RUST]},
            'files': {path: digest(ROOT / path) for path in files}, 'commands': commands}
(OUT / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
print(f'PASS: {len(cases)} C++/Rust workloads; bytes, checksums and calibration counts match')
