#!/usr/bin/env python3
"""Fixed, all-outcome analysis. No BF execution or partial-data entry point."""
import argparse
import csv
import hashlib
import importlib.util
import json
import math
import statistics
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PLAN = ROOT / 'experiments/2026-10-29-k12-singleton-vector-plan'
PRODUCER = PLAN / 'screening'
PLAN_COMMIT = '42f5d62ce9a0a2ee7b6e7ce4586c96623c68bfb5'
CALLER_COMMIT = '2c85beb3d5c945a1e62465687eb547ccfa5098fb'
MODES = ('generic_pure', 'generic_staged_common_hash',
         'visible_public_pure', 'visible_public_fused_common_hash')
FOUR = ((0, 1, 3, 2), (1, 2, 0, 3), (2, 3, 1, 0), (3, 0, 2, 1))
TWO = ((0, 1), (1, 0), (1, 0), (0, 1))
DIGESTS = ('inserted_digest', 'query_digest', 'bitmap_digest',
           'inserted_hash_digest', 'query_hash_digest', 'result_digest')
ROW_FIELDS = set(('filter', 'keys', 'queries', 'actual_bytes', 'hit', 'batch',
                  'repeats', 'seed', 'order', 'measure', 'key_base', 'present',
                  'absent', 'false_positives', 'phase_order', 'samples') + DIGESTS)
CASE_FIELDS = {'case_index', 'seed', 'n_exponent', 'hit_percent', 'batch',
               'actual_bpk', 'api_order', 'round'}


def need(condition, message):
    if not condition:
        raise ValueError(message)


def unique(pairs):
    result = {}
    for key, value in pairs:
        need(key not in result, 'duplicate JSON field')
        result[key] = value
    return result


def read_json(path):
    return json.loads(Path(path).read_text(), object_pairs_hook=unique)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def full_commit(commit):
    need(isinstance(commit, str) and len(commit) == 40 and
         set(commit) <= set('0123456789abcdef'), 'full immutable commit required')


def committed(commit, path):
    full_commit(commit)
    path = Path(path).resolve()
    need(path.is_relative_to(ROOT), 'repository path escaped')
    blob = subprocess.check_output(['git', 'show',
        commit + ':' + path.relative_to(ROOT).as_posix()], cwd=ROOT)
    need(blob == path.read_bytes(), 'committed artifact bytes differ: ' + str(path))


def ledger():
    for name in ('ledger.json', 'protocol.json'):
        committed(PLAN_COMMIT, PLAN / name)
    committed(CALLER_COMMIT, PLAN / 'caller/main.cpp')
    result = read_json(PLAN / 'ledger.json')
    validate_ledger(result)
    return result


def validate_ledger(cases):
    need(type(cases) is list and len(cases) == 96, 'expected 96 cases')
    expected = {(n, hit, batch, seed) for n in (16, 25)
                for hit in (0, 50, 100) for batch in (1, 3, 31, 4096)
                for seed in (16057, 32029)}
    for index, case in enumerate(cases):
        need(set(case) == CASE_FIELDS, 'case schema differs')
        need(case['case_index'] == index and case['round'] == 1 + index // 48,
             'case or round order differs')
        need(case['actual_bpk'] == 24 and case['api_order'] in
             (['Control', 'Candidate'], ['Candidate', 'Control']), 'wrong geometry/API order')
    for round_ in (1, 2):
        subset = cases[(round_ - 1) * 48:round_ * 48]
        observed = [(c['n_exponent'], c['hit_percent'], c['batch'], c['seed'])
                    for c in subset]
        need(len(set(observed)) == 48 and set(observed) == expected,
             'fixed grid differs')
    for first, second in zip(cases[:48], reversed(cases[48:])):
        need(all(first[k] == second[k] for k in CASE_FIELDS -
                 {'case_index', 'round', 'api_order'}), 'second ledger is not reverse input order')
        need(second['api_order'] == list(reversed(first['api_order'])),
             'second API order is not reversed')


def identity(row):
    return {k: v for k, v in row.items() if k not in ('filter', 'order', 'samples')}


def query_identity(row):
    return {k: v for k, v in identity(row).items()
            if k not in ('batch', 'phase_order')}


def validate_row(row, case):
    need(type(row) is dict and set(row) == ROW_FIELDS, 'caller row schema differs')
    n, q = 1 << case['n_exponent'], 1 << 22
    expected = dict(keys=n, queries=q, actual_bytes=n * 3, hit=case['hit_percent'],
                    batch=case['batch'], repeats=8, seed=case['seed'],
                    order=int(case['api_order'][0] == 'Candidate'))
    for key, value in expected.items():
        need(type(row[key]) is int and row[key] == value, 'wrong row field: ' + key)
    need(row['measure'] is True, 'not a formal row')
    need(row['filter'] in ('Control', 'Candidate'), 'unknown API')
    present = q // 100 * case['hit_percent'] + min(q % 100, case['hit_percent'])
    need(type(row['present']) is int and type(row['absent']) is int and
         row['present'] == present and row['absent'] == q - present, 'wrong hit interval count')
    need(type(row['false_positives']) is int and
         0 <= row['false_positives'] <= row['absent'], 'invalid FP count')
    need(type(row['key_base']) is int and 0 <= row['key_base'] < (1 << 32) - n - q,
         'invalid source interval')
    for field in DIGESTS:
        need(type(row[field]) is int and 0 <= row[field] < (1 << 64), 'invalid digest')
    schedule = FOUR if case['batch'] == 1 else TWO
    need(row['phase_order'] == [v for step in schedule * 2 for v in step],
         'unbalanced or changed phase order')
    need(type(row['samples']) is dict and set(row['samples']) == set(MODES), 'metric set differs')
    for index, mode in enumerate(MODES):
        values = row['samples'][mode]
        need(type(values) is list and len(values) == (8 if index < 2 or case['batch'] == 1 else 0),
             'trial count differs')
        need(all(type(v) in (int, float) and math.isfinite(v) and v > 0 for v in values),
             'invalid trial time')


def outcome(ratio):
    return 'faster' if ratio < 1 else 'slower' if ratio > 1 else 'tie'


def calculate(records, cases):
    validate_ledger(cases)
    need(type(records) is list and len(records) == 96, 'incomplete record ledger')
    pairs, vectors, samples = [], [], []
    across_batches, across_rounds, bitmaps = {}, {}, {}
    for record, case in zip(records, cases):
        need(set(record) == {'case', 'rows'} and record['case'] == case, 'record order/case differs')
        rows = record['rows']
        need(type(rows) is list and len(rows) == 2 and
             [r['filter'] for r in rows] == case['api_order'], 'API row order differs')
        for row in rows:
            validate_row(row, case)
        need(identity(rows[0]) == identity(rows[1]), 'paired full semantic fingerprints differ')
        r = rows[0]
        qkey = (case['n_exponent'], case['hit_percent'], case['seed'])
        fingerprint = query_identity(r)
        need(across_batches.setdefault(qkey, fingerprint) == fingerprint,
             'input/output identity changed across batch/round')
        bitmap_key = (case['n_exponent'], case['seed'])
        bitmap_identity = {k: r[k] for k in ('keys', 'actual_bytes', 'key_base',
                           'bitmap_digest', 'inserted_digest', 'inserted_hash_digest')}
        need(bitmaps.setdefault(bitmap_key, bitmap_identity) == bitmap_identity,
             'inserted bitmap identity changed across hits/batches/rounds')
        common = dict(case_index=case['case_index'], round=case['round'],
                      n_exponent=case['n_exponent'], keys=r['keys'], queries=r['queries'],
                      actual_bytes=r['actual_bytes'], hit=case['hit_percent'],
                      batch=case['batch'], seed=case['seed'], api_order=case['api_order'],
                      source_path_scope='changed tiny path' if case['batch'] < 4
                                        else 'unchanged source path; machine code not assumed identical')
        by_name = {row['filter']: row for row in rows}
        for mode in MODES if case['batch'] == 1 else MODES[:2]:
            summary = {}
            for arm in ('Control', 'Candidate'):
                values = by_name[arm]['samples'][mode]
                median = statistics.median(values)
                summary[arm] = median
                vectors.append(dict(**common, mode=mode, arm=arm,
                                    api_position=case['api_order'].index(arm),
                                    values_ns_per_key=list(values), median_ns_per_key=median,
                                    minimum_ns_per_key=min(values), maximum_ns_per_key=max(values)))
                for index, value in enumerate(values):
                    samples.append(dict(**common, mode=mode, arm=arm, repeat=index,
                                        ns_per_key=value))
            ratio = summary['Candidate'] / summary['Control']
            pair = dict(**common, mode=mode, control_ns_per_key=summary['Control'],
                        candidate_ns_per_key=summary['Candidate'], latency_ratio=ratio,
                        outcome=outcome(ratio), semantic_fingerprints=identity(r))
            pairs.append(pair)
            key = (case['n_exponent'], case['hit_percent'], case['batch'], case['seed'], mode)
            group = across_rounds.setdefault(key, {})
            need(case['round'] not in group, 'duplicate round')
            group[case['round']] = pair
    sensitivity = []
    for key, group in sorted(across_rounds.items()):
        need(set(group) == {1, 2}, 'missing paired round')
        first, second = group[1], group[2]
        need(first['semantic_fingerprints'] == second['semantic_fingerprints'],
             'same-input round semantics differ')
        sensitivity.append(dict(n_exponent=key[0], hit=key[1], batch=key[2], seed=key[3], mode=key[4],
            round1_case_index=first['case_index'], round2_case_index=second['case_index'],
            round1_api_order=first['api_order'], round2_api_order=second['api_order'],
            round1_latency_ratio=first['latency_ratio'], round2_latency_ratio=second['latency_ratio'],
            ratio_of_ratios_round2_over_round1=second['latency_ratio'] / first['latency_ratio'],
            control_round2_over_round1=second['control_ns_per_key'] / first['control_ns_per_key'],
            candidate_round2_over_round1=second['candidate_ns_per_key'] / first['candidate_ns_per_key'],
            round1_outcome=first['outcome'], round2_outcome=second['outcome'],
            direction_changed=first['outcome'] != second['outcome']))
    grouped = {}
    for pair in pairs:
        key = (pair['n_exponent'], pair['hit'], pair['batch'], pair['mode'])
        grouped.setdefault(key, []).append(pair)
    ranges = []
    for key, group in sorted(grouped.items()):
        need(len(group) == 4 and {(r['seed'], r['round']) for r in group} ==
             {(s, r) for s in (16057, 32029) for r in (1, 2)}, 'missing seed/round cell')
        points = [dict(seed=r['seed'], round=r['round'], case_index=r['case_index'],
                       api_order=r['api_order'], latency_ratio=r['latency_ratio'], outcome=r['outcome'])
                  for r in sorted(group, key=lambda x: (x['seed'], x['round']))]
        ranges.append(dict(n_exponent=key[0], hit=key[1], batch=key[2], mode=key[3],
                           minimum_latency_ratio=min(r['latency_ratio'] for r in group),
                           maximum_latency_ratio=max(r['latency_ratio'] for r in group),
                           points=points))
    need((len(pairs), len(vectors), len(samples), len(sensitivity), len(ranges)) ==
         (240, 480, 3840, 120, 60), 'analysis cardinalities differ')
    return dict(pairs=pairs, vectors=vectors, samples=samples,
                round_sensitivity=sensitivity, seed_round_ranges=ranges)


def load():
    """Fail closed until the formal producer's exact audit interface is frozen."""
    path = HERE / 'completed-raw-anchor.json'
    need(path.is_file(), 'complete committed raw anchor not available')
    anchor = read_json(path)
    need(anchor.get('complete') is True and anchor.get('interface_finalized') is True,
         'formal producer/raw binding is pending')
    # Final import-closure and audit-interface binding is an additive pre-data
    # source step. This deliberately cannot load data from the current draft.
    raise ValueError('formal audit loader has not yet been bound; no data loaded')


def write_csv(path, rows):
    with path.open('w', newline='') as output:
        writer = csv.DictWriter(output, fieldnames=list(rows[0]), lineterminator='\n')
        writer.writeheader()
        for row in rows:
            writer.writerow({k: json.dumps(v, separators=(',', ':')) if isinstance(v, (dict, list))
                             else v for k, v in row.items()})


def render(result):
    lines = ['# Fixed C++ singleton query comparison', '',
             'Every ratio below is candidate latency / control latency; below one is faster. '
             'The 240 contrasts share inputs, constructions and phase schedules; they are not '
             '240 independent experiments. All eight values per API/contract remain in the artifacts.', '',
             'The four points per condition are descriptive seed × round ranges, not confidence intervals. '
             'Round 2 reverses the full launch ledger and API positions, but environmental history also changes. '
             'The candidate combines SIMD/body, inline/frame and sometimes unrolling changes; no single-instruction causal claim is made.', '',
             '| n exponent | Hit % | Batch | Contract | Minimum ratio | Maximum ratio | Seed/round outcomes |',
             '|---:|---:|---:|---|---:|---:|---|']
    for r in result['seed_round_ranges']:
        outcomes = '; '.join(f"{p['seed']}/r{p['round']}: {p['outcome']}" for p in r['points'])
        lines.append(f"| {r['n_exponent']} | {r['hit']} | {r['batch']} | {r['mode']} | "
                     f"{r['minimum_latency_ratio']:.6f} | {r['maximum_latency_ratio']:.6f} | {outcomes} |")
    lines += ['', '## Every slower or tied comparison', '',
              '| Case | Round | n exponent | Hit % | Batch | Seed | Contract | Control ns/key | Candidate ns/key | Ratio | Outcome |',
              '|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---|']
    for r in result['pairs']:
        if r['outcome'] != 'faster':
            lines.append(f"| {r['case_index']} | {r['round']} | {r['n_exponent']} | {r['hit']} | "
                         f"{r['batch']} | {r['seed']} | {r['mode']} | {r['control_ns_per_key']:.6f} | "
                         f"{r['candidate_ns_per_key']:.6f} | {r['latency_ratio']:.6f} | {r['outcome']} |")
    lines += ['', 'Batch 31 and 4096 retain the original source paths; their machine code and caller context '
              'are not assumed identical. No external, accuracy, insertion, parallel, significance, or global-fastest '
              'claim follows from this two-API query comparison. Every loss and exact tie remains in pairs.csv, '
              'alongside all round sensitivity records and original trial vectors.', '']
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    need(not args.output.exists(), 'preserve previous report')
    metadata, records, anchor = load()
    result = calculate(records, ledger())
    args.output.mkdir(parents=True)
    for name, rows in result.items():
        write_csv(args.output / (name.replace('_', '-') + '.csv'), rows)
    summary = dict(complete=True, plan_commit=PLAN_COMMIT, caller_commit=CALLER_COMMIT,
                   raw_anchor=anchor, counts={k: len(v) for k, v in result.items()},
                   scope='fixed per-condition observations; no pooled independent win rate')
    (args.output / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    (args.output / 'REPORT.md').write_text(render(result))
    print(json.dumps(summary))


if __name__ == '__main__':
    main()
