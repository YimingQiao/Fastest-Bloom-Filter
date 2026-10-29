#!/usr/bin/env python3
"""Finite Rust internal query calculations. No producer import or data loader."""
import csv
import hashlib
import itertools
import json
import math
import statistics
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PLAN = ROOT / 'experiments/2026-10-29-rust-k12-singleton-internal-plan'
PLAN_COMMIT = '9e7fb401ccd6bd55a151eb8cc32395a06375862a'
CALLER_COMMIT = '23e9b075a295deb11c3073cc3b4182b5810a9057'
SEEDS = (6812364731, 9517218469)
PROFILES = ('native', 'portable')
CELLS = ((50, 1), (50, 3), (50, 31), (50, 4096), (0, 1), (100, 1))
MODES = ('generic_pure', 'generic_hash_query', 'visible_pure', 'visible_hash_query')
FOUR = ((0, 1, 3, 2), (1, 2, 0, 3), (2, 3, 1, 0), (3, 0, 2, 1))
TWO = ((0, 1), (1, 0), (1, 0), (0, 1))
DIGESTS = ('input_digest', 'insert_digest', 'bitmap_digest', 'output_digest')
ROW_FIELDS = set(('filter', 'keys', 'queries', 'batch', 'hit', 'seed', 'repeats',
                  'filter_bytes', 'backend', 'scratch_bytes', 'phase_order',
                  'trials_ns', 'round', 'stage', 'calibration_queries') + DIGESTS)


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


def first_mix(seed):
    mask = (1 << 64) - 1
    z = (seed + 0x9e3779b97f4a7c15) & mask
    z = ((z ^ (z >> 30)) * 0xbf58476d1ce4e5b9) & mask
    z = ((z ^ (z >> 27)) * 0x94d049bb133111eb) & mask
    return z ^ (z >> 31)


def expected_cases():
    """Independently reconstruct only the immutable source workload arithmetic."""
    first = []
    for profile, power, seed, (hit, batch) in itertools.product(PROFILES, (16, 25), SEEDS, CELLS):
        n, q = 1 << power, 1 << 22
        base = first_mix(seed) % ((1 << 32) - n - q)
        present = q // 100 * hit + min(q % 100, hit)
        first.append(dict(profile=profile, key_power=power, keys=n, queries=q,
                          seed=seed, hit=hit, batch=batch, filter_bytes=n * 3,
                          physical_lines=n * 3 // 64, raw_counter_envelope=[base, base + n + q],
                          present_queries=present, source_rng_draws=1 + present,
                          metrics=list(MODES if batch == 1 else MODES[:2])))
    result = []
    for round_, rows in ((1, first), (2, list(reversed(first)))):
        for row in rows:
            result.append(dict(case_index=len(result), round=round_, **row,
                               api_order=['Control', 'Candidate'] if round_ == 1
                               else ['Candidate', 'Control']))
    return result


def validate_ledger(cases):
    need(type(cases) is list and len(cases) == 96, 'expected complete 96-case ledger')
    # Canonical JSON comparison rejects bool/integer substitutions as well as changed order/fields.
    need(json.dumps(cases, sort_keys=True) == json.dumps(expected_cases(), sort_keys=True),
         'fixed case/order/domain ledger differs')


def ledger():
    """Only immutable local source reads; never read producer output."""
    inputs = read_json(HERE / 'source_inputs.json')
    need(inputs['plan_commit'] == PLAN_COMMIT and inputs['caller_commit'] == CALLER_COMMIT,
         'source commit anchors differ')
    for relative, record in inputs['files'].items():
        path = ROOT / relative
        need(path.resolve().is_relative_to(ROOT), 'input escaped repository')
        need(record['commit'] in (PLAN_COMMIT, CALLER_COMMIT), 'unexpected source anchor')
        data = path.read_bytes()
        need(hashlib.sha256(data).hexdigest() == record['sha256'] and len(data) == record['bytes'],
             'source input hash/length differs: ' + relative)
        blob = subprocess.check_output(['git', 'show', record['commit'] + ':' + relative], cwd=ROOT)
        need(blob == data, 'committed input differs: ' + relative)
    cases = read_json(PLAN / 'ledger.json')['cases']
    validate_ledger(cases)
    return cases


def validate_row(row, case):
    need(type(row) is dict and set(row) == ROW_FIELDS, 'actual caller row schema differs')
    fixed = dict(keys=case['keys'], queries=case['queries'], batch=case['batch'], hit=case['hit'],
                 seed=case['seed'], repeats=8, filter_bytes=case['filter_bytes'],
                 scratch_bytes=min(case['batch'], case['queries']) * 8,
                 round=case['round'], calibration_queries=0)
    need(all(type(row[k]) is int and row[k] == value for k, value in fixed.items()),
         'fixed geometry/workload/count field differs')
    need(row['filter'] in ('Control', 'Candidate') and row['stage'] == 'measure', 'not a formal API row')
    need(row['backend'] == 'avx512', 'required actual backend not exercised')
    for key in DIGESTS:
        need(type(row[key]) is int and 0 <= row[key] < 2**64, 'invalid full-output digest')
    schedule = [list(step) for step in (FOUR if case['batch'] == 1 else TWO) * 2]
    need(json.dumps(row['phase_order']) == json.dumps(schedule), 'changed phase schedule')
    values = row['trials_ns']
    need(type(values) is list and len(values) == len(case['metrics']), 'wrong metric count')
    for vector in values:
        need(type(vector) is list and len(vector) == 8, 'wrong sample count')
        need(all(type(x) in (int, float) and math.isfinite(x) and x > 0 for x in vector),
             'invalid trial latency')


def identity(row):
    return {k: v for k, v in row.items() if k not in ('filter', 'trials_ns')}


def outcome(ratio):
    return 'faster' if ratio < 1 else 'slower' if ratio > 1 else 'tie'


def calculate(records, cases):
    validate_ledger(cases)
    need(type(records) is list and len(records) == 96, 'incomplete record ledger')
    pairs, vectors, samples = [], [], []
    across_queries, bitmaps, across_rounds = {}, {}, {}
    for record, case in zip(records, cases):
        need(type(record) is dict and set(record) == {'case', 'rows'} and
             json.dumps(record['case'], sort_keys=True) == json.dumps(case, sort_keys=True),
             'record case/order differs')
        rows = record['rows']
        need(type(rows) is list and len(rows) == 2 and [r['filter'] for r in rows] == case['api_order'],
             'API row order differs')
        for row in rows:
            validate_row(row, case)
        r = rows[0]
        need(identity(r) == identity(rows[1]), 'paired semantic identity differs')
        # Same deterministic data/bitmap are intentionally reused across profiles, rounds and batches.
        qkey = (case['key_power'], case['hit'], case['seed'])
        query_fingerprint = {k: r[k] for k in ('keys', 'queries', 'seed', 'hit', 'filter_bytes') + DIGESTS}
        need(across_queries.setdefault(qkey, query_fingerprint) == query_fingerprint,
             'input/output identity differs across batch/round/profile')
        bkey = (case['key_power'], case['seed'])
        bitmap_fingerprint = {k: r[k] for k in ('keys', 'seed', 'filter_bytes', 'insert_digest', 'bitmap_digest')}
        need(bitmaps.setdefault(bkey, bitmap_fingerprint) == bitmap_fingerprint,
             'inserted bitmap identity differs across hits')
        common = dict(case_index=case['case_index'], profile=case['profile'], round=case['round'],
                      key_power=case['key_power'], keys=r['keys'], queries=r['queries'],
                      filter_bytes=r['filter_bytes'], hit=case['hit'], batch=case['batch'], seed=case['seed'],
                      api_order=case['api_order'], source_path_scope='changed tiny path' if case['batch'] < 4
                      else 'retained bulk source; machine-code equality not assumed')
        by_arm = {row['filter']: row for row in rows}
        for mode_index, mode in enumerate(case['metrics']):
            medians = {}
            for arm in ('Control', 'Candidate'):
                values = by_arm[arm]['trials_ns'][mode_index]
                medians[arm] = statistics.median(values)
                vectors.append(dict(**common, mode=mode, arm=arm, api_position=case['api_order'].index(arm),
                                    values_ns_per_key=list(values), median_ns_per_key=medians[arm],
                                    minimum_ns_per_key=min(values), maximum_ns_per_key=max(values)))
                samples.extend(dict(**common, mode=mode, arm=arm, repeat=i, ns_per_key=x)
                               for i, x in enumerate(values))
            ratio = medians['Candidate'] / medians['Control']
            pair = dict(**common, mode=mode, control_ns_per_key=medians['Control'],
                        candidate_ns_per_key=medians['Candidate'], latency_ratio=ratio, outcome=outcome(ratio),
                        semantic_fingerprints={k: v for k, v in identity(r).items() if k != 'round'})
            pairs.append(pair)
            key = (case['profile'], case['key_power'], case['hit'], case['batch'], case['seed'], mode)
            group = across_rounds.setdefault(key, {})
            need(case['round'] not in group, 'duplicate round')
            group[case['round']] = pair
    sensitivity = []
    for key, group in sorted(across_rounds.items()):
        need(set(group) == {1, 2}, 'missing opposite round')
        first, second = group[1], group[2]
        need(first['semantic_fingerprints'] == second['semantic_fingerprints'], 'same-input round mismatch')
        sensitivity.append(dict(profile=key[0], key_power=key[1], hit=key[2], batch=key[3], seed=key[4], mode=key[5],
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
        key = (pair['profile'], pair['key_power'], pair['hit'], pair['batch'], pair['mode'])
        grouped.setdefault(key, []).append(pair)
    ranges = []
    for key, group in sorted(grouped.items()):
        need(len(group) == 4 and {(r['seed'], r['round']) for r in group} ==
             {(s, r) for s in SEEDS for r in (1, 2)}, 'missing seed/round point')
        points = [dict(seed=r['seed'], round=r['round'], case_index=r['case_index'],
                       api_order=r['api_order'], latency_ratio=r['latency_ratio'], outcome=r['outcome'])
                  for r in sorted(group, key=lambda x: (x['seed'], x['round']))]
        ranges.append(dict(profile=key[0], key_power=key[1], hit=key[2], batch=key[3], mode=key[4],
                           minimum_latency_ratio=min(r['latency_ratio'] for r in group),
                           maximum_latency_ratio=max(r['latency_ratio'] for r in group), points=points))
    need((len(pairs), len(vectors), len(samples), len(sensitivity), len(ranges)) ==
         (288, 576, 4608, 144, 72), 'analysis cardinalities differ')
    need(sum(p['batch'] < 4 for p in pairs) == 224 and sum(p['batch'] >= 4 for p in pairs) == 64,
         'tiny/bulk contrast coverage differs')
    return dict(pairs=pairs, vectors=vectors, samples=samples,
                round_sensitivity=sensitivity, seed_round_ranges=ranges)


def load():
    raise ValueError('No finalized formal producer/raw binding; no data loaded')


def write_csv(path, rows):
    with Path(path).open('w', newline='') as output:
        writer = csv.DictWriter(output, fieldnames=list(rows[0]), lineterminator='\n')
        writer.writeheader()
        for row in rows:
            writer.writerow({k: json.dumps(v, separators=(',', ':')) if isinstance(v, (dict, list))
                             else v for k, v in row.items()})


def render(result):
    lines = ['# Fixed Rust singleton query comparison', '',
             'Ratios are candidate latency / control latency; below one is faster. Native and portable '
             'profiles are reported separately, with no pooled winner or cross-profile speed ranking. '
             'The 288 paired contrasts reuse inputs and constructions; they are not independent experiments.', '',
             'Every API/contract retains eight measured values. Four-point seed × round ranges are '
             'descriptive, not confidence intervals. Round 2 reverses the full process ledger and API order; '
             'environmental history changes too, so order is not isolated causally. Dynamic caller bounds '
             'and actual compiler boundaries belong to this experiment, not the earlier tiny proof.', '',
             '| Profile | n exponent | Hit % | Batch | Contract | Minimum ratio | Maximum ratio | Seed/round outcomes |',
             '|---|---:|---:|---:|---|---:|---:|---|']
    for row in result['seed_round_ranges']:
        outcomes = '; '.join(f"{p['seed']}/r{p['round']}: {p['outcome']}" for p in row['points'])
        lines.append(f"| {row['profile']} | {row['key_power']} | {row['hit']} | {row['batch']} | {row['mode']} | "
                     f"{row['minimum_latency_ratio']:.6f} | {row['maximum_latency_ratio']:.6f} | {outcomes} |")
    lines += ['', '## Every slower or tied comparison', '',
              '| Case | Profile | Round | n exponent | Hit % | Batch | Seed | Contract | Control ns/key | Candidate ns/key | Ratio | Outcome |',
              '|---:|---|---:|---:|---:|---:|---:|---|---:|---:|---:|---|']
    for row in result['pairs']:
        if row['outcome'] != 'faster':
            lines.append(f"| {row['case_index']} | {row['profile']} | {row['round']} | {row['key_power']} | {row['hit']} | "
                         f"{row['batch']} | {row['seed']} | {row['mode']} | {row['control_ns_per_key']:.6f} | "
                         f"{row['candidate_ns_per_key']:.6f} | {row['latency_ratio']:.6f} | {row['outcome']} |")
    lines += ['', 'Batch 31 and 4096 are regression controls; retained source does not imply identical machine '
              'code. Batch 31 has remainder 4 at q=2^22 and does not exercise a new 1–3-key remainder. '
              'Successful-path inlining, target boundaries, frame size and unrolling can change together. '
              'All wins, losses, ties, vectors and opposite-round sensitivities remain in the artifacts. '
              'There is no calibration, external comparison, build, multithread, significance, or global-fastest claim.', '']
    return '\n'.join(lines)
