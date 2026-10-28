#!/usr/bin/env python3
"""Verify archived hashes and paired semantic invariants without running timings."""
import csv
import hashlib
import json
from pathlib import Path

EXP = Path(__file__).resolve().parent
ROOT = EXP.parents[1]
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
manifest = json.loads((EXP / 'manifest.json').read_text())
for relative, expected in manifest['files'].items():
    assert sha(EXP / relative) == expected, relative
assert sha(EXP / 'native-lib-before.rs') == json.loads((EXP / 'base.json').read_text())['native_lib_sha256']
fields = ['filter_bytes', 'actual_bpk', 'result_checksum', 'false_positives', 'absent_queries', 'calibration_false_positives', 'calibration_absent_queries']
for directory, workloads, filters in [
    ('initial', 56, {'FastPatternBefore', 'FastPatternMaskedTail'}),
    ('confirmation', 72, {'FastPatternBefore', 'FastPatternMaskedTail', 'FastPatternGroupedTail'}),
]:
    metadata = json.loads((EXP / directory / 'metadata.json').read_text())
    assert len(metadata['commands']) == workloads
    for relative, expected in metadata['source_sha256'].items():
        assert sha(ROOT / relative) == expected, relative
    rows = list(csv.DictReader((EXP / directory / 'results.csv').open()))
    assert len(rows) == workloads * len(filters)
    groups = {}
    for row in rows:
        key = tuple(row[column] for column in ['keys', 'requested_bpk', 'batch', 'seed'])
        groups.setdefault(key, []).append(row)
    assert len(groups) == workloads
    for key, group in groups.items():
        assert len(group) == len(filters) and {row['filter'] for row in group} == filters, key
        for field in fields:
            assert len({row[field] for row in group}) == 1, (key, field)
    print(f'{directory}: {workloads} workloads / {len(rows)} rows; semantics and source hashes match')
for prefix in ['', 'selected-']:
    for mode in ['normal', 'disable', 'asan']:
        assert '6 passed; 0 failed' in (EXP / f'{prefix}{mode}-test.log').read_text()
print(f'PASS: {len(manifest["files"])} archived file hashes and all six validation logs')
