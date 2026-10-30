#!/usr/bin/env python3
"""Validate the shipped data and regenerate only batch4096 query tables."""
import argparse
import csv
import io
import json
import math
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ALIASES = {
    'FourSectorRange12Experiment': 'FourSectorRange12',
    'FourSectorRange12BloomFilter': 'FourSectorRange12',
    'Split64RangeNative': 'Split64Range',
    'Split64RangeExperiment': 'Split64Range',
    'Split64RangeBloomFilter': 'Split64Range',
}
FIELDS = ['panel', 'keys', 'batch', 'cap_bpk', 'fpr_ceiling', 'metric', 'threads']
LABELS = {
    'CPP988': 'C++ · broad screen · one core',
    'CPP_K12_primary24': 'C++ · strict 24-bit/key confirmation · one core',
    'Rust786': 'Rust · raw public APIs · one core',
    'CPP_MT195': 'C++ · shared executor · eight physical cores',
}
METRICS = {
    'lookup_ns': 'Prehashed query',
    'hash_lookup_ns': 'Common hash + query',
    'raw_batched_public': 'Raw-key query, including required hashing',
    'parallel_lookup_end_to_end_ns': 'Prehashed query, including launch/join',
    'parallel_hash_lookup_end_to_end_ns': 'Common hash + query, including launch/join',
}


def key(row):
    return tuple(row[f] for f in FIELDS)


def name(row):
    return ALIASES.get(row['method'], row['method'])


def validate(data):
    assert len(data['scenarios']) == 30
    groups = defaultdict(list)
    for row in data['all_eligible_configurations']:
        assert row['batch'] == 4096 and row['metric'] in METRICS
        assert row['actual_bytes'] * 8 <= row['keys'] * row['cap_bpk']
        assert math.isclose(row['actual_bpk'], row['actual_bytes'] * 8 / row['keys'])
        assert len(row['cell_ns']) == row['cells']
        assert all(math.isfinite(v) and v > 0 for v in row['cell_ns'].values())
        gm = math.exp(math.fsum(math.log(v) for v in row['cell_ns'].values()) / row['cells'])
        assert math.isclose(gm, row['ns_per_key'], rel_tol=1e-12)
        groups[key(row)].append(row)
    assert set(groups) == {key(s) for s in data['scenarios']}
    for s in data['scenarios']:
        rows = sorted(groups[key(s)], key=lambda r: (r['ns_per_key'], r['method'], r['actual_bytes']))
        assert len(rows) == s['eligible_configurations']
        seen, top = set(), []
        for rank, r in enumerate(rows, 1):
            assert r['configuration_rank'] == rank
            assert math.isclose(r['relative_throughput'], rows[0]['ns_per_key'] / r['ns_per_key'], rel_tol=1e-12)
            if r['method'] not in seen:
                top.append(r)
                seen.add(r['method'])
        assert len(seen) == s['eligible_methods']
        for expected, actual in zip(top[:3], s['top3']):
            assert all(expected[k] == v for k, v in actual.items())
        assert len(s['top3']) == min(3, len(top))


def headline(data, panel, metric, paired=None):
    lines = ['| Inserted keys | Method | ' + ('Prehashed ns/key | Hash + query ns/key |' if paired else 'Raw query ns/key |'),
             '| ---: | :--- | ' + ('---: | ---: |' if paired else '---: |')]
    for s in data['scenarios']:
        if s['panel'] != panel or s['metric'] != metric or s['cap_bpk'] != 24 or s['fpr_ceiling'] != .0001:
            continue
        for row in s['top3']:
            if paired:
                pure = next(r for r in data['all_eligible_configurations'] if
                            r['panel'] == panel and r['keys'] == s['keys'] and r['metric'] == paired and
                            r['cap_bpk'] == 24 and r['fpr_ceiling'] == .0001 and
                            r['method'] == row['method'] and r['actual_bytes'] == row['actual_bytes'])
                values = f"{pure['ns_per_key']:.4f} | {row['ns_per_key']:.4f}"
            else:
                values = f"{row['ns_per_key']:.4f}"
            lines.append(f"| {s['keys']:,} | {name(row)} | {values} |")
    return '\n'.join(lines)


def report(data):
    rev = data['provenance']['research_revision']
    base = f'https://github.com/YimingQiao/Fastest-Bloom-Filter/tree/{rev}/'
    lines = ['# Query performance · batch4096', '',
        'Every result on this page uses batches of 4096 and reports query time in **ns/key**. Lower is faster. All panels use 50% mixed-query hits and 4,194,304 queries per timed pass. The two filter sizes contain 65,536 and 33,554,432 inserted keys.', '',
        '## Machine and timing contracts', '',
        'Intel Xeon Platinum 8474C, two sockets with 48 physical cores per socket and 97.5 MiB LLC per socket, Linux 6.1.0-45-amd64. C++ used Clang 23 native builds; Rust used rustc 1.92 native release builds. AVX-512 was available. Single-thread runs were pinned to a physical core; the parallel executor used eight physical cores on socket 0. These are the historical binaries actually measured, not a new timing run of the release package.', '',
        '| Panel | Timing samples | Construction seeds | Calibration negatives per construction | Context |',
        '| :--- | ---: | :--- | ---: | :--- |',
        '| CPP988 | 6 | One seen seed (42) | 2^24 | Broad capacity screen, CPU 2 |',
        '| CPP_K12_primary24 | 6 | Three fresh confirmation seeds | 2^26 | Fixed five-API strict24 shortlist, CPU 3 |',
        '| Rust786 | 8 | One seen seed (42) | 2^24 | Raw public APIs, CPU 2 / NUMA 0 |',
        '| CPP_MT195 | 6 | Three seen seeds | 2^26 | Shared executor, eight physical cores / NUMA 0 |', '',
        'A one-seed value is the original median. Three-seed summaries are the **geometric mean of the three per-seed medians**. Seed-level medians remain in the JSON. The tables are descriptive rankings of the measured data, without a timing significance test. Panels have different callers, selection histories and builds; do not combine them into a cross-language or cross-panel speed ratio.', '',
        'Prehashed queries consume caller-prepared 64-bit hashes. Common-hash-plus-query includes the common hash within each batch. Rust raw public APIs include their required hashing; direct byte APIs receive the original key encoded as eight little-endian bytes. A native API that requires hashes pays the common hash cost. The Rust whole-array visible-loop metric is excluded because it is a different API contract.', '',
        'The eight-core panel reports wall-clock time per total queried key and includes fresh thread creation/join for each whole pass. Workers issue 4096-key calls to each API. This common executor is separate from the native parallel-wrapper timings. Rust parallel APIs are available, but this page makes no Rust multithread performance claim.', '',
        'The large-table common-hash result can be faster than its prehashed result. They are separately timed kernels with different work and memory schedules; subtracting these measurements does not isolate hashing cost.', '',
        '## Admission and scope', '',
        'Each candidate must fit the **actual bitmap byte ceiling** and pass its construction-specific two-sided 95% Wilson upper bound at the FPR ceiling. All three constructions must pass in multi-seed panels. Calibration keys are disjoint from inserted and timed-query key domains. Aliased mappings do not add independent samples. The intervals are pointwise and finite-sample; requested bits/key and probe count are not FPR guarantees. Caller buffers, hash workspace, allocator metadata and thread stacks are separate from the bitmap cap.', '',
        'Top three means three public API methods, each at its fastest qualifying measured allocation. API variants remain separate even if they share a bitmap mapping. Thus some rows use fewer bits than the cap. The CSV/JSON retain every qualifying allocation. Quality failures and unavailable API contracts remain in the linked original evidence; they are not assigned zero latency or counted as wins.', '',
        'The strict24 confirmation tests a prespecified shortlist from an earlier screen, not every possible external implementation. It includes K12, Range, FastFilter Fixed64, Boost Multi64 K8, and RocksDB FastLocalBloom64 K8 Batch32. All five pass at both sizes. K12\'s worst three-seed FPR upper endpoints are 0.00929051% (small) and 0.00952436% (large). Rust also measures Fastbloom, fastbloom-rs, and Bloomsday configurations; its one-seed results are a screen, not independent confirmation.', '',
        'Display names FourSectorRange12 and Split64Range shorten the original method identifiers. JSON/CSV preserve those identifiers, including experimental names in historical binaries. The release promotes their tested native kernels; it does not claim every historical adapter or experimental layout is a shipping API.', '',
        '## Top three by condition', '',
        'Relative throughput is fastest ns/key divided by method ns/key: 1.000 is the leader, smaller values are slower. Actual bits/key are rounded for display; exact bytes are retained in the data.', '']
    for panel in LABELS:
        for metric in METRICS:
            scenarios = [s for s in data['scenarios'] if s['panel'] == panel and s['metric'] == metric]
            if not scenarios:
                continue
            lines += [f"### {LABELS[panel]} · {METRICS[metric]}", '',
                      '| Keys | Cap bits/key | FPR ceiling | Method | Actual bits/key | ns/key | Relative throughput |',
                      '| ---: | ---: | ---: | :--- | ---: | ---: | ---: |']
            for s in scenarios:
                for row in s['top3']:
                    lines.append(f"| {s['keys']:,} | {s['cap_bpk']:g} | {100*s['fpr_ceiling']:g}% | {name(row)} | {row['actual_bpk']:.4f} | {row['ns_per_key']:.4f} | {row['relative_throughput']:.3f} |")
            lines.append('')
    lines += ['## Data and frozen evidence', '',
              '[All qualifying configurations (CSV)](../benchmarks/results/batch4096.csv) · [Seed medians and provenance (JSON)](../benchmarks/results/batch4096.json) · [Reproduction](reproduce.md)', '',
              'The following immutable research sources include full calibration, trial vectors, producer details and historical work outside this publication slice. Main publishes only the batch4096 query subset.', '']
    for title, path in [
        ('C++ broad capacity screen', 'experiments/2026-10-29-exact-budget-range/'),
        ('C++ strict24 confirmation', 'experiments/2026-10-29-four-sector-range12-strict24-analysis/'),
        ('Rust raw public-API screen', 'experiments/2026-10-29-fastbloom-rs-raw8-analysis/'),
        ('C++ shared eight-core executor', 'experiments/2026-10-29-native-k12-parallel-analysis/'),
        ('Original ranking calculation and input hashes', 'docs/benchmark-top3-2026-10-30/')]:
        lines.append(f'- [{title}]({base}{path})')
    return '\n'.join(lines) + '\n'


def outputs(data):
    readme = (ROOT / 'README.md').read_text()
    for marker, args in {
        'CPP_RESULTS': ('CPP_K12_primary24', 'hash_lookup_ns', 'lookup_ns'),
        'RUST_RESULTS': ('Rust786', 'raw_batched_public'),
        'MT_RESULTS': ('CPP_MT195', 'parallel_hash_lookup_end_to_end_ns', 'parallel_lookup_end_to_end_ns'),
    }.items():
        begin, end = f'<!-- BEGIN {marker} -->', f'<!-- END {marker} -->'
        before, rest = readme.split(begin)
        _, after = rest.split(end)
        readme = before + begin + '\n' + headline(data, *args) + '\n' + end + after
    stream = io.StringIO(newline='')
    fields = FIELDS + ['cells', 'method', 'actual_bytes', 'actual_bpk', 'ns_per_key', 'configuration_rank', 'relative_throughput']
    writer = csv.DictWriter(stream, fieldnames=fields, extrasaction='ignore', lineterminator='\n')
    writer.writeheader()
    writer.writerows(data['all_eligible_configurations'])
    return {'README.md': readme, 'docs/performance.md': report(data), 'benchmarks/results/batch4096.csv': stream.getvalue()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Fail if generated tables differ')
    args = parser.parse_args()
    data = json.loads((ROOT / 'benchmarks/results/batch4096.json').read_text())
    validate(data)
    for path, content in outputs(data).items():
        target = ROOT / path
        if args.check:
            assert target.read_text() == content, f'Stale generated file: {path}'
        else:
            target.write_text(content)
    print(f"Validated 30 batch4096 scenarios and {len(data['all_eligible_configurations'])} qualifying configurations")


if __name__ == '__main__':
    main()
