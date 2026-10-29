#!/usr/bin/env python3
"""Reconstruct the completed constructor proof offline; never executes a binary."""
import json
from pathlib import Path
from validate import HERE, frozen, sha, need, check_rows, write

SOURCE = '82636d04e038d53c11cc96e5ce7f82cc7dc1ebb3'
output = HERE / 'validation-v1'
meta = json.loads((output / 'metadata.json').read_text())
need(meta['complete'] and meta['source_commit'] == SOURCE and meta['sources'] == frozen(SOURCE), 'Wrong complete source proof')
need(meta['filter_inserts'] == meta['throughput_samples'] == 0 and not meta['semantic_workload_run'], 'Wrong proof scope')
expected = ['rust-version', 'cargo-version', 'offline-planner-tests', 'cargo-metadata',
            'inspector-build', 'parser-test-build', 'parser-tests', 'constructors']
need([r['label'] for r in meta['commands']] == expected, 'Changed command coverage')
for record in meta['commands']:
    need(record['complete'] and record['returncode'] == 0, 'Failed constructor proof command')
    for stream in ('stdout', 'stderr'):
        need(sha(output / record[stream]) == record[stream + '_sha256'], 'Changed raw command output')
for key in ('binary', 'parser_test_binary'):
    need(sha(meta[key]['path']) == meta[key]['sha256'], 'Changed tested binary')
for source, item in meta['actual_dep_info_files'].items():
    need(sha(source) == item['sha256'] == sha(output / item['archive']), 'Changed actual compiler dependency evidence')
need('2 passed; 0 failed' in (output / 'parser-tests.stdout').read_text(), 'Incomplete parser tests')
need('Ran 7 tests' in (output / 'offline-planner-tests.stderr').read_text(), 'Incomplete offline tests')
rows = [json.loads(line) for line in (output / 'constructors.stdout').read_text().splitlines()]
check_rows(rows)
need(not (output / 'constructors.stderr').read_bytes(), 'Unexpected constructor diagnostic')
summary = dict(complete=True, source_commit=SOURCE, constructor_rows=len(rows),
               commands=len(expected), parser_tests=2, offline_tests=7,
               owned_byte_range=[min(r['owned_bytes'] for r in rows), max(r['owned_bytes'] for r in rows)],
               inline_object_bytes=sorted({r['inline_object_bytes'] for r in rows}),
               inspection_peak_bytes=sorted({r['inspection_peak_bytes'] for r in rows}),
               constructor_peaks_equal_owned=all(r['owned_bytes'] == r['constructor_peak_bytes'] for r in rows),
               actual_dep_info_files=len(meta['actual_dep_info_files']),
               binary=meta['binary'], parser_test_binary=meta['parser_test_binary'],
               filter_inserts=0, throughput_samples=0, semantic_workload_run=False)
summary_path = HERE / 'GEOMETRY_PROOF.json'
need(not summary_path.exists(), 'Preserve existing proof')
write(summary_path, summary)
archive = HERE / 'GEOMETRY_ARCHIVE.json'
need(not archive.exists(), 'Preserve existing archive')
files = {str(p.relative_to(HERE)): dict(sha256=sha(p), bytes=p.stat().st_size)
         for p in sorted(HERE.rglob('*')) if p.is_file() and '__pycache__' not in p.parts}
write(archive, dict(files=files, source_commit=SOURCE, binaries_archived=False))
print(json.dumps(summary))
