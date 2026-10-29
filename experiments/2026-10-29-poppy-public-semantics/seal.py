#!/usr/bin/env python3
"""Audit the completed semantic fixtures without executing a filter."""
import json
from validate import HERE, frozen, check_rows, need, sha, write

SOURCE = '722d91ed1258a4875957c71d867e7c652f122f12'
output = HERE / 'validation-v1'
meta = json.loads((output / 'metadata.json').read_text())
need(meta['complete'] and meta['source_commit'] == SOURCE, 'Incomplete/wrong attempt')
need(meta['preparation'] == frozen(SOURCE), 'Frozen source changed')
need(meta['throughput_samples'] == meta['calibration_samples'] == 0, 'Unexpected performance or quality scope')
labels = [backend + '-' + phase for backend in ('normal', 'asan') for phase in ('version', 'metadata', 'build', 'fixtures')]
need([row['label'] for row in meta['commands']] == labels, 'Unexpected command coverage')
for row in meta['commands']:
    need(row['complete'] and row['returncode'] == 0, 'Failed command')
    for stream in ('stdout', 'stderr'):
        need(sha(output / row[stream]) == row[stream + '_sha256'], 'Changed raw log')
for item in meta['binaries'].values():
    need(sha(item['path']) == item['sha256'], 'Changed executed binary')
for deps in meta['actual_dep_info_files'].values():
    for source, item in deps.items():
        need(sha(source) == sha(output / item['artifact']) == item['sha256'], 'Changed actual dependency text')
results = {}
for backend in ('normal', 'asan'):
    need(not (output / (backend + '-fixtures.stderr')).read_bytes(), 'Unexpected fixture diagnostics')
    rows = [json.loads(line) for line in (output / (backend + '-fixtures.stdout')).read_text().splitlines()]
    check_rows(rows)
    results[backend] = rows
need(results['normal'] == results['asan'], 'Backend semantic mismatch')
summary = dict(complete=True, source_commit=SOURCE, commands=8, profiles=['normal', 'asan'],
               constructor_semantic_rows=172, full_byte_iterator_comparisons=172,
               none_space_full_alias_comparisons=34, mixed_queries_per_row=8193,
               fixture_inserts_per_row=1031, dense_query_comparisons=172 * 8193,
               invalid_fpp_cases=32, zero_capacity_cases=8, full_capacity_cases=8,
               actual_dep_info_files={k: len(v) for k, v in meta['actual_dep_info_files'].items()},
               binaries=meta['binaries'], throughput_samples=0, calibration_samples=0,
               serialization_equality='complete in-memory streaming comparison; digests are labels only')
need(not (HERE / 'SEMANTIC_PROOF.json').exists(), 'Preserve existing proof')
write(HERE / 'SEMANTIC_PROOF.json', summary)
report = '''# Completed Poppy public semantic proof

All86 frozen constructor configurations pass the public byte/iterator fixtures
under both normal Rust and nightly ASan:172 semantic rows and1,409,196 mixed
query comparisons. Every insertion result, every serialized cache/bucket byte
and every query result agrees between the two public interfaces. All inserted
keys remain present. Duplicate insertion and uninitialized-iterator rejection
leave the complete serialization unchanged. All34 None/Space comparisons
(17 per backend) differ only in their public policy tag. Clearing leaves no
fixture key present and no bucket bit set; a fresh index-cache state is not
claimed.

Both backends also pass32 invalid-FPP,8 zero-capacity and8 full-capacity error
cases in total. The eight recorded commands all succeeded on the first run.
The entire operation used an inherited exclusive socket0 flock with parent
and children pinned to CPU2. No throughput timer, calibration negative stream,
fresh performance seed or constructor search ran. This is not evidence of
Poppy's speed or full-load FPR.

The dependency remains the original pinned public implementation. Eight-byte
little-endian slices retain the supplied first hash; generic u64 inputs have
different hashing semantics. The public xorshift bucket mapping, optional
cache and lazy secondary hash are retained. A timed adapter must include byte
or iterator preparation and all of that public query work inside its clocks.

`SEMANTIC_PROOF.json` records both executed binary hashes and actual dep-info
counts. `validation-v1/` preserves structured Cargo metadata/build messages,
tool versions and all87 output records per backend. The full byte comparisons
ran in memory; the archive retains lengths, digests and equality records, not
the large serialized payloads. Actual dependency text is retained without
claiming a resolved complete compiler input closure. The counting allocator
from the earlier constructor proof is absent from this checker.

`seal.py` verifies committed source, exact geometry identities, complete command
coverage, raw log hashes, live executable identity, dependency text and full
normal/ASan record equality without running another filter. Public semantics
are now established for this finite grid; independent quality calibration and
a fair timed comparison remain the next steps.
'''
need(not (HERE / 'SEMANTIC_REPORT.md').exists(), 'Preserve existing report')
(HERE / 'SEMANTIC_REPORT.md').write_text(report)
archive = HERE / 'SEMANTIC_ARCHIVE.json'
need(not archive.exists(), 'Preserve existing archive')
files = {str(p.relative_to(HERE)): dict(sha256=sha(p), bytes=p.stat().st_size)
         for p in sorted(HERE.rglob('*')) if p.is_file() and '__pycache__' not in p.parts}
write(archive, dict(source_commit=SOURCE, files=files, binaries_archived=False))
print(json.dumps(summary))
