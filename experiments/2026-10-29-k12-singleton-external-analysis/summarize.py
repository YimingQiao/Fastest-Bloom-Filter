#!/usr/bin/env python3
"""Pre-data, finite descriptive calculation; no BF execution or partial loader."""
import csv
import json
import math
import statistics
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PLAN = ROOT / 'experiments/2026-10-29-k12-singleton-external-plan'
PLAN_COMMIT = '61f068907665fef2cb8ceafcc9c2f014f96b281e'
MODES = ('generic_pure', 'generic_staged_common_hash',
         'visible_public_pure', 'visible_public_fused_common_hash')
SEEDS = (982451653, 961748941)
CAPS = (16, 24, 32)
CEILINGS = (.01, .001, .0001)
OWNERS = ('candidate', 'old_k12', 'native_range', 'production_native',
          'all_native_composite', 'external')
CONTRASTS = (('candidate', 'external'), ('old_k12', 'external'),
             ('native_range', 'external'), ('production_native', 'external'),
             ('all_native_composite', 'external'), ('candidate', 'production_native'),
             ('candidate', 'native_range'))
FOUR = ((0, 1, 3, 2), (1, 2, 0, 3), (2, 3, 1, 0), (3, 0, 2, 1))
TWO = ((0, 1), (1, 0), (1, 0), (0, 1))
GEOMETRY = ('filter', 'keys', 'requested_bpk', 'budget_bytes', 'logical_bytes',
            'unit_bytes', 'unit_count', 'effective_probes', 'constructor_argument',
            'native_constructor_bpk', 'geometry_kind', 'probe_policy')
INSERT = ('keys', 'actual_bytes', 'key_base', 'inserted_digest', 'inserted_hash_digest', 'bitmap_digest')
QUERY = ('queries', 'hit', 'query_digest', 'query_hash_digest', 'result_digest',
         'present', 'absent', 'false_positives')
CAL = ('calibration_negatives', 'calibration_fp', 'calibration_digest')
FIELDS = set(('point_id', 'owner', 'actual_bytes', 'queries', 'hit', 'batch', 'repeats',
              'seed', 'reverse_jobs', 'measure', 'key_base', 'inserted_digest',
              'inserted_hash_digest', 'query_digest', 'query_hash_digest', 'result_digest',
              'bitmap_digest', 'present', 'absent', 'false_positives',
              'query_scratch_bytes', 'phase_order', 'samples') + GEOMETRY + CAL)


def need(value, message):
    if not value:
        raise ValueError(message)


def unique(pairs):
    result = {}
    for key, value in pairs:
        need(key not in result, 'duplicate JSON field')
        result[key] = value
    return result


def read(path):
    return json.loads(Path(path).read_text(), object_pairs_hook=unique)


def sources():
    values = {}
    for name in ('protocol.json', 'selection.json', 'ledger.json', 'input-domains.json'):
        path = PLAN / name
        data = subprocess.check_output(['git', 'show', PLAN_COMMIT + ':' +
                                        path.relative_to(ROOT).as_posix()], cwd=ROOT)
        need(data == path.read_bytes(), 'proposal bytes changed: ' + name)
        values[name] = json.loads(data, object_pairs_hook=unique)
    return values


def wilson_upper(fp, total):
    need(type(fp) is int and type(total) is int and total > 0 and 0 <= fp <= total,
         'invalid calibration count')
    z = 1.959963984540054
    p, zz = fp / total, z * z
    return (p + zz / (2 * total) + z * math.sqrt(p * (1 - p) / total +
            zz / (4 * total * total))) / (1 + zz / total)


def outcome(ratio):
    return 'not_comparable' if ratio is None else 'faster' if ratio < 1 else 'slower' if ratio > 1 else 'tie'


def geomean(values):
    need(bool(values) and all(math.isfinite(v) and v > 0 for v in values), 'invalid geometric mean')
    return math.exp(math.fsum(math.log(v) for v in values) / len(values))


def validate_row(row, case, point, domain):
    need(type(row) is dict and set(row) == FIELDS, 'wrong exact row schema')
    g = point['geometry']
    for key in GEOMETRY:
        expected = g.get(key, 0)
        if key not in ('filter', 'geometry_kind', 'probe_policy'):
            expected = int(expected)
        need(type(row[key]) is type(expected) and row[key] == expected, 'wrong geometry: ' + key)
    n, q, hit = 1 << case['key_power'], 1 << 22, case['hit']
    present = q // 100 * hit + min(q % 100, hit)
    expected = dict(point_id=point['id'], owner=point['owner'], actual_bytes=int(g['filter_bytes']),
        queries=q, hit=hit, batch=case['batch'], repeats=8, seed=case['seed'],
        reverse_jobs=case['reverse_jobs'], measure=True, key_base=domain['key_base'],
        present=present, absent=q-present, query_scratch_bytes=case['batch'] * 8,
        calibration_negatives=(1 << 26) if case['calibration_power'] else 0)
    need(row['keys'] == n, 'wrong size')
    for key, value in expected.items():
        need(type(row[key]) is type(value) and row[key] == value, 'wrong caller field: ' + key)
    for key, upper in (('false_positives', row['absent']), ('calibration_fp', row['calibration_negatives'])):
        need(type(row[key]) is int and 0 <= row[key] <= upper, 'invalid FP count')
    for key in ('inserted_digest', 'inserted_hash_digest', 'query_digest', 'query_hash_digest', 'result_digest'):
        need(type(row[key]) is int and 0 <= row[key] < 1 << 64, 'invalid full digest')
    for key in ('bitmap_digest', 'calibration_digest'):
        need(row[key] is None or (type(row[key]) is int and 0 <= row[key] < 1 << 64), 'invalid optional digest')
    need((row['calibration_digest'] is None) == (not case['calibration_power']), 'wrong calibration availability')
    need((row['bitmap_digest'] is not None) == (point['owner'] in ('candidate', 'old_k12', 'native_range')),
         'wrong public bitmap availability')
    schedule = FOUR if case['batch'] == 1 else TWO
    need(row['phase_order'] == [v for step in schedule * 2 for v in step], 'wrong phase schedule')
    need(type(row['samples']) is dict and set(row['samples']) == set(MODES), 'wrong modes')
    for index, mode in enumerate(MODES):
        values = row['samples'][mode]
        need(type(values) is list and len(values) == (8 if index < 2 or case['batch'] == 1 else 0), 'wrong sample count')
        need(all(type(v) in (int, float) and math.isfinite(v) and v > 0 for v in values), 'invalid trial time')


def calculate(records, source):
    """Only complete source-ledger records. Pure calculation; no raw-file reads."""
    cases = source['ledger.json']
    points = {p['id']: p for p in source['selection.json']['points']}
    domains = {(d['keys'], d['seed']): d for d in source['input-domains.json']}
    need(len(cases) == 48 and len(points) == 64 and len(domains) == 4, 'wrong proposal cardinality')
    need(type(records) is list and len(records) == 48, 'incomplete process ledger')
    quality, construction, query_seen, aliases = {}, {}, {}, {}
    vectors, samples, medians = [], [], {}
    row_count = reuse_count = 0
    for case, record in zip(cases, records, strict=True):
        need(set(record) == {'case', 'rows'} and record['case'] == case, 'wrong frozen case/order')
        rows = record['rows']
        need(type(rows) is list and len(rows) == len(case['point_ids']) and
             {r['point_id'] for r in rows} == set(case['point_ids']), 'wrong point set')
        canonical = None
        case_aliases = {}
        for row_index, row in enumerate(rows):
            point = points[row['point_id']]
            validate_row(row, case, point, domains[(1 << case['key_power'], case['seed'])])
            row_count += 1
            pid, seed = row['point_id'], row['seed']
            source_key = (pid, seed)
            insertion = tuple(row[k] for k in INSERT)
            need(construction.setdefault(source_key, insertion) == insertion, 'construction identity changed')
            qkey = (pid, seed, row['hit'])
            query = tuple(row[k] for k in QUERY)
            need(query_seen.setdefault(qkey, query) == query, 'same-input query identity changed')
            input_id = tuple(row[k] for k in ('inserted_digest', 'inserted_hash_digest', 'query_digest', 'query_hash_digest'))
            need(canonical is None or canonical == input_id, 'canonical raw/hash input differs')
            canonical = input_id
            alias_evidence = insertion + query + tuple(row[k] for k in CAL)
            need(case_aliases.setdefault(point['mapping_id'], alias_evidence) == alias_evidence,
                 'same-case known alias outputs differ')
            if case['calibration_power']:
                need(case['round'] == 1 and case['phase'] == 'primary_singleton' and source_key not in quality,
                     'unexpected fresh quality source')
                upper = wilson_upper(row['calibration_fp'], row['calibration_negatives'])
                quality[source_key] = dict(point_id=pid, mapping_id=point['mapping_id'],
                    seed=seed, keys=row['keys'], actual_bytes=row['actual_bytes'],
                    calibration_fp=row['calibration_fp'], calibration_negatives=row['calibration_negatives'],
                    calibration_digest=row['calibration_digest'], wilson_upper=upper,
                    source_case_index=case['index'], source_row_index=row_index, reuse_case_indices=[],
                    insertion_identity={k: row[k] for k in INSERT},
                    qualifies={str(f): upper <= f for f in CEILINGS})
                akey = (point['mapping_id'], seed)
                evidence = insertion + query + tuple(row[k] for k in CAL)
                need(aliases.setdefault(akey, evidence) == evidence, 'known alias identity differs')
            else:
                need(source_key in quality, 'quality reuse precedes source')
                quality[source_key]['reuse_case_indices'].append(case['index'])
                reuse_count += 1
            for mode in MODES if row['batch'] == 1 else MODES[:2]:
                values = row['samples'][mode]
                median = statistics.median(values)
                key = (case['index'], pid, mode)
                need(key not in medians, 'duplicate timing vector')
                medians[key] = median
                common = dict(case_index=case['index'], row_index=row_index, point_id=pid,
                    owner=point['owner'], keys=row['keys'], seed=seed, round=case['round'],
                    hit=row['hit'], batch=row['batch'], mode=mode, actual_bytes=row['actual_bytes'])
                vectors.append(dict(**common, values_ns_per_key=list(values), median_ns_per_key=median,
                    query_scratch_bytes=row['query_scratch_bytes'], phase_order=list(row['phase_order'])))
                samples.extend(dict(**common, repeat=i, ns_per_key=v) for i, v in enumerate(values))
    need((row_count, len(quality), len(aliases), reuse_count, len(vectors), len(samples)) ==
         (616, 128, 108, 488, 2032, 16256), 'wrong full record/quality/vector cardinalities')

    def quality_status(pid, ceiling):
        return all(quality[(pid, seed)]['wilson_upper'] <= ceiling for seed in SEEDS)

    def qualities(pid):
        return [quality[(pid, seed)] for seed in SEEDS]

    def latency(case, pid, mode):
        return medians[(case['index'], pid, mode)]

    def pair(common, numerator, rival, value, other):
        ratio = value / other if value is not None and other is not None else None
        return dict(**common, numerator_point_id=numerator, rival_point_id=rival,
                    numerator_ns_per_key=value, rival_ns_per_key=other, latency_ratio=ratio,
                    outcome=outcome(ratio))

    alternatives, views, cells, primary_pairs, primary_summary, envelopes = [], [], [], [], [], []
    for n in (1 << 16, 1 << 25):
        primary = sorted((c for c in cases if c['key_power'] == n.bit_length()-1 and
                          c['phase'] == 'primary_singleton'), key=lambda c: (c['seed'], c['round']))
        need(len(primary) == 4 and {(c['seed'], c['round']) for c in primary} ==
             {(s, r) for s in SEEDS for r in (1, 2)}, 'missing primary cell')
        selected = [p for p in points.values() if int(p['geometry']['keys']) == n]
        for cap in CAPS:
            for ceiling in CEILINGS:
                for mode in MODES:
                    common = dict(keys=n, cap_bpk=cap, fpr_ceiling=ceiling, mode=mode)
                    available = []
                    for point in selected:
                        pid = point['id']
                        actual = int(point['geometry']['filter_bytes'])
                        memory_ok = actual * 8 <= n * cap
                        quality_ok = quality_status(pid, ceiling)
                        values = [latency(c, pid, mode) for c in primary]
                        row = dict(**common, point_id=pid, owner=point['owner'], actual_bytes=actual,
                            memory_eligible=memory_ok, both_seed_quality_eligible=quality_ok,
                            eligible=memory_ok and quality_ok, geometric_mean_ns_per_key=geomean(values),
                            quality_records=qualities(pid), cells=[dict(case_index=c['index'], seed=c['seed'],
                                round=c['round'], median_ns_per_key=v) for c, v in zip(primary, values, strict=True)])
                        alternatives.append(row)
                        available.append(row)
                    leaders = {}
                    for owner in OWNERS:
                        choices = [r for r in available if r['eligible'] and
                            (r['owner'] == owner or (owner == 'all_native_composite' and r['owner'] != 'external'))]
                        winner = min(choices, key=lambda r: (r['geometric_mean_ns_per_key'], r['point_id']), default=None)
                        leaders[owner] = winner['point_id'] if winner else None
                    views.append(dict(**common, leaders=leaders))
                    observations = []
                    for case in primary:
                        cc = dict(**common, case_index=case['index'], seed=case['seed'], round=case['round'])
                        cells.append(dict(**cc, leaders=leaders))
                        for numerator, rival in CONTRASTS:
                            a, b = leaders[numerator], leaders[rival]
                            row = pair(dict(**cc, contrast=numerator+'/'+rival), a, b,
                                latency(case, a, mode) if a else None, latency(case, b, mode) if b else None)
                            primary_pairs.append(row)
                            observations.append(row)
                        for rival in ('external', 'production_native'):
                            choices = [r['point_id'] for r in available if r['eligible'] and r['owner'] == rival]
                            b = min(choices, key=lambda pid: (latency(case, pid, mode), pid), default=None)
                            a = leaders['candidate']
                            envelopes.append(pair(dict(**cc, rival_group=rival,
                                fixed_geomean_rival_point_id=leaders[rival]), a, b,
                                latency(case, a, mode) if a else None, latency(case, b, mode) if b else None))
                    for numerator, rival in CONTRASTS:
                        name = numerator+'/'+rival
                        chosen = [r for r in observations if r['contrast'] == name]
                        ratios = [r['latency_ratio'] for r in chosen]
                        comparable = all(r is not None for r in ratios)
                        primary_summary.append(dict(**common, contrast=name, numerator_point_id=leaders[numerator],
                            rival_point_id=leaders[rival], geometric_mean_latency_ratio=geomean(ratios) if comparable else None,
                            minimum_latency_ratio=min(ratios) if comparable else None,
                            maximum_latency_ratio=max(ratios) if comparable else None,
                            observations=[{k: r[k] for k in ('case_index', 'seed', 'round', 'latency_ratio', 'outcome')} for r in chosen]))

    same_byte = []
    for case in cases:
        native_points = [points[pid] for pid in case['point_ids'] if points[pid]['owner'] in ('candidate', 'old_k12', 'native_range')]
        for candidate in (p for p in native_points if p['owner'] == 'candidate'):
            a = candidate['id']
            actual = int(candidate['geometry']['filter_bytes'])
            for rival in ('old_k12', 'native_range'):
                matches = [p for p in native_points if p['owner'] == rival and int(p['geometry']['filter_bytes']) == actual]
                need(len(matches) == 1, 'same-byte rival is not unique')
                b = matches[0]['id']
                for mode in MODES if case['batch'] == 1 else MODES[:2]:
                    q = {owner: {str(f): dict(current_seed=quality[(pid, case['seed'])]['wilson_upper'] <= f,
                                              both_seeds=quality_status(pid, f)) for f in CEILINGS}
                         for owner, pid in (('candidate', a), (rival, b))}
                    same_byte.append(pair(dict(case_index=case['index'], keys=1 << case['key_power'],
                        seed=case['seed'], round=case['round'], hit=case['hit'], batch=case['batch'], mode=mode,
                        actual_bytes=actual, contrast='candidate/'+rival, quality=q), a, b,
                        latency(case, a, mode), latency(case, b, mode)))
    need((len(alternatives), len(views), len(cells), len(primary_pairs), len(primary_summary),
          len(envelopes), len(same_byte)) == (2304, 72, 288, 2016, 504, 576, 864), 'wrong contrast cardinalities')
    # Retain the original full construction/query identities without invented opaque bitmaps.
    identities = [dict(case_index=c['index'], row_index=i,
        **{k: v for k, v in r.items() if k != 'samples'}) for c, rec in zip(cases, records, strict=True)
        for i, r in enumerate(rec['rows'])]
    primary_sensitivity = round_sensitivity(primary_pairs, ('keys', 'cap_bpk', 'fpr_ceiling', 'mode', 'contrast', 'seed'))
    same_byte_sensitivity = round_sensitivity(same_byte, ('keys', 'actual_bytes', 'hit', 'batch', 'mode', 'contrast', 'seed'))
    need((len(primary_sensitivity), len(same_byte_sensitivity)) == (1008, 432), 'wrong paired-round counts')
    return dict(quality=list(quality.values()), alternatives=alternatives, views=views, cells=cells,
        primary_pairs=primary_pairs, primary_summary=primary_summary, envelopes=envelopes,
        same_byte=same_byte, vectors=vectors, samples=samples, identities=identities,
        primary_round_sensitivity=primary_sensitivity, same_byte_round_sensitivity=same_byte_sensitivity)


def round_sensitivity(rows, fields):
    groups = {}
    for row in rows:
        key = tuple(row[k] for k in fields)
        group = groups.setdefault(key, {})
        need(row['round'] not in group, 'duplicate paired round')
        group[row['round']] = row
    result = []
    for key, group in sorted(groups.items()):
        need(set(group) == {1, 2}, 'missing paired round')
        first, second = group[1], group[2]
        need(all(first[k] == second[k] for k in ('numerator_point_id', 'rival_point_id')), 'fixed comparison identity changed')
        a, b = first['latency_ratio'], second['latency_ratio']
        result.append(dict(zip(fields, key), numerator_point_id=first['numerator_point_id'],
            rival_point_id=first['rival_point_id'], round1_case_index=first['case_index'],
            round2_case_index=second['case_index'], round1_latency_ratio=a, round2_latency_ratio=b,
            round2_over_round1_ratio=b/a if a is not None and b is not None else None,
            round1_outcome=first['outcome'], round2_outcome=second['outcome'],
            direction_changed=first['outcome'] != second['outcome']))
    return result


def write_csv(path, rows):
    with Path(path).open('w', newline='') as output:
        writer = csv.DictWriter(output, fieldnames=list(rows[0]), lineterminator='\n')
        writer.writeheader()
        for row in rows:
            writer.writerow({k: json.dumps(v, separators=(',', ':'), allow_nan=False) if isinstance(v, (dict, list))
                             else v for k, v in row.items()})


def render(result):
    lines = ['# C++ singleton external comparison', '',
        'Ratios are named numerator latency / rival latency; below one is faster. '
        'Each point uses the median of its eight repetitions. Both fresh seed Wilson upper endpoints must pass; '
        'no seed/alias pooling and no historical quality or latency import. Every selected allocation remains in alternatives.csv.', '',
        'Leaders minimize the geometric mean across the four seed/round medians, then remain fixed for all four pairs. '
        'This is descriptive selection on the same data. Per-cell rival envelopes are separate and may choose another eligible point. '
        'The four observations are descriptive ranges, not confidence intervals or independent trials.', '',
        '| Keys | Cap bpk | FPR ceiling | Mode | Contrast | Numerator | Rival | Minimum ratio | Maximum ratio | Outcomes |',
        '|---:|---:|---:|---|---|---|---|---:|---:|---|']
    for row in result['primary_summary']:
        values = [row['minimum_latency_ratio'], row['maximum_latency_ratio']]
        formatted = ['NC' if v is None else f'{v:.6f}' for v in values]
        outcomes = '; '.join(f"{r['seed']}/r{r['round']}: {r['outcome']}" for r in row['observations'])
        lines.append(f"| {row['keys']} | {row['cap_bpk']} | {row['fpr_ceiling']} | {row['mode']} | {row['contrast']} | "
                     f"{row['numerator_point_id'] or 'none'} | {row['rival_point_id'] or 'none'} | {formatted[0]} | {formatted[1]} | {outcomes} |")
    lines += ['', 'All 864 same-byte candidate/old-K12 and candidate/Range pairs remain unconditional, with individual '
        'and both-seed quality flags. A Range win does not establish production-native or external leadership. '
        'All losses, ties, null leaders, 576 per-cell external/production envelopes, 2032 vectors and 16256 trial values are retained. '
        'Different modes and nested caps/ceilings share observations; their counts are not independent win rates. '
        'No external bulk, build, multithread, cross-language, causal single-instruction, or global-fastest claim follows.', '']
    return '\n'.join(lines)


def write_report(result, output):
    output = Path(output)
    need(not output.exists(), 'preserve prior report')
    output.mkdir(parents=True)
    for name, rows in result.items():
        write_csv(output / (name.replace('_', '-') + '.csv'), rows)
    (output / 'REPORT.md').write_text(render(result))
    summary = dict(plan_commit=PLAN_COMMIT, counts={k: len(v) for k, v in result.items()},
                   ratio_direction='named numerator latency / rival latency; below one faster',
                   ranking='descriptive same-data selection; not independent superiority evidence')
    (output / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    return summary


if __name__ == '__main__':
    raise SystemExit('No raw-data loader is bound. Freeze the producer and complete-data loader before formal execution.')
