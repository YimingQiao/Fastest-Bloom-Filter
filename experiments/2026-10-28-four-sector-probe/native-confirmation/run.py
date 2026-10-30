#!/usr/bin/env python3
"""Same-process production FourSector before/after confirmation with frozen sources."""
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
REPO = ROOT.parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir', type=Path, required=True)
    parser.add_argument('--cpu', type=int, default=3)
    parser.add_argument('--binary', type=Path, default=REPO / 'build/four-sector-native-confirmation/compare_benchmark')
    args = parser.parse_args()
    output = args.output_dir.resolve()
    output.mkdir(parents=True, exist_ok=False)
    binary = args.binary.resolve()
    sources = [p for p in ROOT.iterdir() if p.is_file() and p.suffix in ('.h', '.hpp', '.cpp', '.py', '.txt')]
    hashes = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
    check_command = ['taskset', '-c', str(args.cpu), str(binary.parent / 'check')]
    check = subprocess.run(check_command, check=True, text=True, capture_output=True)
    print(check.stdout.strip(), flush=True)
    metadata = {
        'cpu': args.cpu,
        'compiler': subprocess.check_output(['clang++', '--version'], text=True),
        'machine': subprocess.check_output(['lscpu'], text=True),
        'source_snapshots': json.loads((ROOT / 'source-metadata.json').read_text()),
        'source_sha256': hashes,
        'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(),
        'compile_commands': json.loads((binary.parent / 'compile_commands.json').read_text()),
        'preflight_command': check_command,
        'preflight_output': check.stdout,
        'runs': [],
    }
    cases = list(itertools.product((16, 24), (8, 31, 4096), (2053, 4099)))
    random.Random(104729).shuffle(cases)
    writer = None
    with (output / 'timing.csv').open('w', newline='') as stream:
        for power, batch, seed in cases:
            command = ['taskset', '-c', str(args.cpu), str(binary), str(power), '8', '50', '22', str(batch), '5', str(seed), 'FourSectorBefore,FourSectorAfter', str(1 << power)]
            start = time.monotonic()
            result = subprocess.run(command, check=True, text=True, capture_output=True)
            rows = list(csv.DictReader(io.StringIO(result.stdout)))
            assert len(rows) == 2
            before = next(row for row in rows if row['filter'] == 'FourSectorBefore')
            after = next(row for row in rows if row['filter'] == 'FourSectorAfter')
            for field in ('result_checksum', 'filter_bytes', 'false_positives', 'absent_queries', 'present_queries', 'calibration_false_positives'):
                assert before[field] == after[field], (power, batch, seed, field)
            if writer is None:
                writer = csv.DictWriter(stream, rows[0].keys(), lineterminator='\n')
                writer.writeheader()
            writer.writerows(rows)
            stream.flush()
            metadata['runs'].append({'command': command, 'seconds': time.monotonic() - start})
            print(f'finished keys=2^{power}, batch={batch}, seed={seed}', flush=True)
    metadata['sources_changed_during_run'] = [p.name for p in sources if hashlib.sha256(p.read_bytes()).hexdigest() != hashes[p.name]]
    metadata['utc'] = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
    (output / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')


if __name__ == '__main__':
    main()
