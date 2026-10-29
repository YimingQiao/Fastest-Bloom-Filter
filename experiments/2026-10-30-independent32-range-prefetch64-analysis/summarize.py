#!/usr/bin/env python3
"""Finite pre-data calculation. No file loader, benchmark, or partial-data entry."""
import math
import statistics
import json
from pathlib import Path

SEEDS = (982451653, 961748941)
SIZES = (1 << 16, 1 << 25)
BATCHES = (1, 31, 4096)
MODES = ('generic_pure', 'generic_staged_common_hash',
         'visible_public_pure', 'visible_public_fused_common_hash')
RIVALS = ('external', 'production_native')
FOUR = ((0, 1, 3, 2), (1, 2, 0, 3), (2, 3, 1, 0), (3, 0, 2, 1))
TWO = ((0, 1), (1, 0), (1, 0), (0, 1))
MASK = (1 << 64) - 1
CAP, CEILING = 16, .01
GEOMETRY = ('filter', 'keys', 'requested_bpk', 'budget_bytes', 'logical_bytes',
            'unit_bytes', 'unit_count', 'effective_probes', 'constructor_argument',
            'native_constructor_bpk', 'geometry_kind', 'probe_policy')
INSERT = ('keys', 'actual_bytes', 'key_base', 'inserted_digest',
          'inserted_hash_digest', 'bitmap_available', 'bitmap_digest')
QUERY = ('queries', 'hit', 'query_digest', 'query_hash_digest', 'result_digest',
         'present', 'absent', 'false_positives')
CAL = ('calibration_negatives', 'calibration_fp', 'calibration_digest')
FIELDS = set(GEOMETRY) | set(('point_id owner actual_bytes queries hit batch repeats seed '
    'reverse_jobs measure key_base inserted_digest inserted_hash_digest query_digest '
    'query_hash_digest result_digest bitmap_available bitmap_digest present absent false_positives '
    'calibration_negatives calibration_fp calibration_digest query_scratch_bytes phase_order samples').split())
CASE_FIELDS = set(('index power query_power hit batch repeats seed order calibration_power round point_ids').split())


def need(value, message):
    if not value:
        raise ValueError(message)


class Random:
    def __init__(self, seed):
        self.state = seed

    def advance(self, n):
        self.state = (self.state + n * 0x9e3779b97f4a7c15) & MASK

    def next(self):
        self.advance(1)
        value = self.state
        value = ((value ^ (value >> 30)) * 0xbf58476d1ce4e5b9) & MASK
        value = ((value ^ (value >> 27)) * 0x94d049bb133111eb) & MASK
        return value ^ (value >> 31)


def input_order(points, case):
    n, q = 1 << case['power'], 1 << case['query_power']
    rng = Random(case['seed'])
    base = rng.next() % ((1 << 32) - n - q)
    present = q // 100 * case['hit'] + min(q % 100, case['hit'])
    rng.advance(n - 1 + present + q - 1)
    ids = [p['id'] for p in points if int(p['geometry']['keys']) == n]
    for i in range(len(ids) - 1, 0, -1):
        j = rng.next() % (i + 1)
        ids[i], ids[j] = ids[j], ids[i]
    if case['order']:
        ids.reverse()
    return base, ids


def modes(batch):
    return MODES if batch == 1 else MODES[:2]


def build_ledger(points):
    """Source-only finite command order; second launch round reverses all12 cases."""
    first = [dict(power=power, query_power=22, hit=50, batch=batch, repeats=8,
                  seed=seed, order=0, calibration_power=26 if batch == 1 else 0, round=1)
             for power in (16, 25) for seed in SEEDS for batch in BATCHES]
    second = [dict(case, order=1, calibration_power=0, round=2) for case in reversed(first)]
    result = []
    for index, case in enumerate(first + second):
        result.append(dict(case, index=index, point_ids=input_order(points, case)[1]))
    return result


def wilson_upper(fp, total):
    need(type(fp) is int and type(total) is int and total > 0 and 0 <= fp <= total,
         'invalid calibration counts')
    z = 1.959963984540054
    p, zz = fp / total, z * z
    return (p + zz / (2 * total) + z * math.sqrt(p * (1 - p) / total +
            zz / (4 * total * total))) / (1 + zz / total)


def geomean(values):
    need(bool(values) and all(math.isfinite(v) and v > 0 for v in values), 'invalid geometric mean')
    return math.exp(math.fsum(math.log(v) for v in values) / len(values))


def outcome(ratio):
    return 'not_comparable' if ratio is None else 'faster' if ratio < 1 else 'slower' if ratio > 1 else 'tie'


def validate_sources(selection, ledger):
    points = selection['points']
    need(len(points) == 16 and len({p['id'] for p in points}) == 16, 'exact16 point identities')
    need(len(ledger) == 24, 'exact24 process ledger')
    expected_aliases = []
    for n, count in zip(SIZES, (9, 7), strict=True):
        subset = [p for p in points if int(p['geometry']['keys']) == n]
        need(len(subset) == count, 'wrong size panel')
        owners = [p['owner'] for p in subset]
        need(owners.count('candidate') == 1 and owners.count('range_control') == 1 and
             owners.count('production_native') == 4 and owners.count('external') == count - 6,
             'wrong ownership panel')
        paired = [p for p in subset if p['owner'] in ('candidate', 'range_control')]
        need(all(int(p['geometry']['requested_bpk']) == 12 and
                 int(p['geometry']['filter_bytes']) == n * 12 // 8 and
                 p['public_data_available'] is True for p in paired), 'exact12-bpk pipeline/control geometry')
        need(len({p['mapping_id'] for p in paired}) == 1, 'pipeline/control mapping identity')
        expected_aliases.append(frozenset(p['id'] for p in paired))
        if n == SIZES[0]:
            ff = [p for p in subset if p['owner'] == 'external' and
                  p['geometry']['filter'] in ('FastFilterFixed16', 'FastFilterFixed16SingleV1') and
                  int(p['geometry']['filter_bytes']) == n * 16 // 8]
            need(len(ff) == 2 and {p['geometry']['filter'] for p in ff} ==
                 {'FastFilterFixed16', 'FastFilterFixed16SingleV1'}, 'exact known FastFilter alias')
            expected_aliases.append(frozenset(p['id'] for p in ff))
        for point in subset:
            need(type(point['public_data_available']) is bool, 'public Data capability must be Boolean')
    mapped = {}
    for point in points:
        mapped.setdefault(point['mapping_id'], set()).add(point['id'])
    alias_ids = set().union(*expected_aliases)
    expected_groups = expected_aliases + [frozenset({p['id']}) for p in points if p['id'] not in alias_ids]
    need(len(mapped) == 13 and {frozenset(v) for v in mapped.values()} == set(expected_groups),
         'exact known mapping groups; no invented alias')
    axes = set()
    for index, case in enumerate(ledger):
        need(type(case) is dict and set(case) == CASE_FIELDS, 'wrong case schema')
        need(case['index'] == index and all(type(case[k]) is int for k in CASE_FIELDS - {'point_ids'}),
             'case index/type')
        need(case['power'] in (16, 25) and case['query_power'] == 22 and case['hit'] == 50 and
             case['batch'] in BATCHES and case['repeats'] == 8 and case['seed'] in SEEDS and
             case['round'] in (1, 2) and case['order'] == case['round'] - 1, 'wrong finite workload')
        need(case['calibration_power'] == (26 if case['round'] == 1 and case['batch'] == 1 else 0),
             'wrong calibration source')
        need(case['point_ids'] == input_order(points, case)[1], 'source-derived API order')
        key = (case['power'], case['seed'], case['batch'], case['round'])
        need(key not in axes, 'duplicate process')
        axes.add(key)
    first, second = ledger[:12], ledger[12:]
    need(all(c['round'] == 1 for c in first) and all(c['round'] == 2 for c in second), 'round grouping')
    for a, b in zip(first, reversed(second), strict=True):
        need(all(a[k] == b[k] for k in ('power', 'seed', 'batch')), 'whole ledger reversal')
        need(a['point_ids'] == list(reversed(b['point_ids'])), 'whole API reversal')
    return points


def validate_row(row, case, point):
    need(type(row) is dict and set(row) == FIELDS, 'exact caller schema')
    g = point['geometry']
    for key in GEOMETRY:
        expected = g.get(key, 0)
        if key not in ('filter', 'geometry_kind', 'probe_policy'):
            expected = int(expected)
        need(type(row[key]) is type(expected) and row[key] == expected, 'geometry: ' + key)
    n, q = 1 << case['power'], 1 << 22
    present = q // 100 * 50 + min(q % 100, 50)
    expected = dict(point_id=point['id'], owner=point['owner'], keys=n,
        actual_bytes=int(g['filter_bytes']), bitmap_available=point['public_data_available'],
        queries=q, hit=50, batch=case['batch'], repeats=8, seed=case['seed'],
        reverse_jobs=bool(case['order']), measure=True, key_base=input_order([point], case)[0],
        present=present, absent=q-present, query_scratch_bytes=case['batch'] * 8,
        calibration_negatives=(1 << 26) if case['calibration_power'] else 0)
    for key, value in expected.items():
        need(type(row[key]) is type(value) and row[key] == value, 'caller: ' + key)
    for key, upper in (('false_positives', row['absent']), ('calibration_fp', row['calibration_negatives'])):
        need(type(row[key]) is int and 0 <= row[key] <= upper, 'invalid FP')
    for key in ('inserted_digest', 'inserted_hash_digest', 'query_digest', 'query_hash_digest', 'result_digest'):
        need(type(row[key]) is int and 0 <= row[key] <= MASK, 'invalid digest')
    for key in ('bitmap_digest', 'calibration_digest'):
        need(row[key] is None or (type(row[key]) is int and 0 <= row[key] <= MASK), 'invalid optional digest')
    need((row['bitmap_digest'] is not None) == row['bitmap_available'], 'actual public bitmap availability')
    need((row['calibration_digest'] is not None) == bool(case['calibration_power']), 'calibration availability')
    schedule = FOUR if case['batch'] == 1 else TWO
    need(row['phase_order'] == [m for step in schedule * 2 for m in step], 'balanced mode schedule')
    need(type(row['samples']) is dict and set(row['samples']) == set(MODES), 'exact modes')
    for mode in MODES:
        values = row['samples'][mode]
        need(type(values) is list and len(values) == (8 if mode in modes(case['batch']) else 0), 'trial count')
        need(all(type(v) in (int, float) and math.isfinite(v) and v > 0 for v in values), 'invalid trial time')


def calculate(records, selection, ledger):
    """Only a future complete, committed producer audit may supply real records."""
    points = validate_sources(selection, ledger)
    by_id = {p['id']: p for p in points}
    need(type(records) is list and len(records) == len(ledger), 'incomplete process ledger')
    quality, construction, queries, mappings, medians = {}, {}, {}, {}, {}
    vectors, trials = [], []
    rows_total = reused = 0
    for case, record in zip(ledger, records, strict=True):
        need(set(record) == {'case', 'rows'} and record['case'] == case, 'record/case mismatch')
        rows = record['rows']
        need([r['point_id'] for r in rows] == case['point_ids'], 'raw row order/count')
        shared = None
        case_mappings = {}
        for position, row in enumerate(rows):
            point = by_id[row['point_id']]
            validate_row(row, case, point)
            rows_total += 1
            key = (point['id'], case['seed'])
            insert = tuple(row[k] for k in INSERT)
            query = tuple(row[k] for k in QUERY)
            need(construction.setdefault(key, insert) == insert, 'construction changed across reuse')
            need(queries.setdefault(key, query) == query, 'dense query identity changed across reuse')
            canonical = tuple(row[k] for k in ('key_base', 'inserted_digest', 'inserted_hash_digest',
                                               'query_digest', 'query_hash_digest'))
            need(shared is None or shared == canonical, 'different same-case raw/hash inputs')
            shared = canonical
            need(case_mappings.setdefault(point['mapping_id'], insert + query) == insert + query,
                 'same-case mapped bitmap/query identities differ')
            if case['calibration_power']:
                need(key not in quality, 'duplicate fresh quality source')
                quality[key] = dict(point_id=point['id'], mapping_id=point['mapping_id'], seed=case['seed'],
                    keys=row['keys'], actual_bytes=row['actual_bytes'], source_case_index=case['index'],
                    source_row_index=position, reuse_case_indices=[],
                    calibration_fp=row['calibration_fp'], calibration_negatives=row['calibration_negatives'],
                    calibration_digest=row['calibration_digest'],
                    wilson_upper=wilson_upper(row['calibration_fp'], row['calibration_negatives']),
                    insertion_identity=dict(zip(INSERT, insert)), query_identity=dict(zip(QUERY, query)))
                mapping_key = (point['mapping_id'], case['seed'])
                evidence = insert + query + tuple(row[k] for k in CAL)
                entry = mappings.setdefault(mapping_key, dict(evidence=evidence, point_ids=[]))
                need(entry['evidence'] == evidence, 'known mapping aliases differ')
                entry['point_ids'].append(point['id'])
            else:
                need(key in quality, 'reuse before fresh quality')
                quality[key]['reuse_case_indices'].append(case['index'])
                reused += 1
            for mode in modes(case['batch']):
                values = list(row['samples'][mode])
                median = statistics.median(values)
                medians[(case['index'], point['id'], mode)] = median
                common = dict(case_index=case['index'], row_index=position, point_id=point['id'],
                    owner=point['owner'], keys=row['keys'], seed=case['seed'], round=case['round'],
                    batch=case['batch'], mode=mode, actual_bytes=row['actual_bytes'])
                vectors.append(dict(**common, values_ns_per_key=values, median_ns_per_key=median,
                    min_ns_per_key=min(values), max_ns_per_key=max(values),
                    phase_order=list(row['phase_order']), query_scratch_bytes=row['query_scratch_bytes']))
                trials.extend(dict(**common, repeat=i, ns_per_key=value) for i, value in enumerate(values))
    need((rows_total, len(quality), len(mappings), reused, len(vectors), len(trials)) ==
         (192, 32, 26, 160, 512, 4096), 'complete cardinalities')
    need(all(len(q['reuse_case_indices']) == 5 for q in quality.values()), 'exact five quality reuses')

    gates = {}
    for point in points:
        pid = point['id']
        qs = [quality[(pid, seed)] for seed in SEEDS]
        memory = int(point['geometry']['filter_bytes']) * 8 <= int(point['geometry']['keys']) * CAP
        quality_ok = all(q['wilson_upper'] <= CEILING for q in qs)
        gates[pid] = dict(point_id=pid, owner=point['owner'], mapping_id=point['mapping_id'],
            actual_bytes=int(point['geometry']['filter_bytes']), cap_bpk=CAP, fpr_ceiling=CEILING,
            memory_eligible=memory, both_seed_quality_eligible=quality_ok, eligible=memory and quality_ok,
            quality_records=qs)

    def timing(case, pid, mode):
        return medians[(case['index'], pid, mode)]

    def pair(common, numerator, denominator, case, mode, qualified=False):
        ratio = None
        a = timing(case, numerator, mode)
        b = timing(case, denominator, mode) if denominator is not None else None
        comparable = denominator is not None and gates[numerator]['eligible'] and gates[denominator]['eligible']
        if b is not None and (comparable or not qualified):
            ratio = a / b
        return dict(**common, numerator_point_id=numerator, rival_point_id=denominator,
            numerator_ns_per_key=a, rival_ns_per_key=b, latency_ratio=ratio, outcome=outcome(ratio),
            numerator_eligible=gates[numerator]['eligible'],
            rival_eligible=gates[denominator]['eligible'] if denominator is not None else None,
            both_eligible=comparable, qualification_required=qualified)

    alternatives, envelopes, fixed_views, fixed_pairs, control_pairs, primary_controls = [], [], [], [], [], []
    for n in SIZES:
        panel = [p for p in points if int(p['geometry']['keys']) == n]
        pipeline = next(p['id'] for p in panel if p['owner'] == 'candidate')
        control = next(p['id'] for p in panel if p['owner'] == 'range_control')
        for batch in BATCHES:
            cells = sorted((c for c in ledger if (1 << c['power']) == n and c['batch'] == batch),
                           key=lambda c: (SEEDS.index(c['seed']), c['round']))
            need(len(cells) == 4, 'exact four seed/round cells')
            for mode in modes(batch):
                fixed = {}
                for owner in RIVALS:
                    eligible = [p['id'] for p in panel if p['owner'] == owner and gates[p['id']]['eligible']]
                    means = {pid: geomean([timing(c, pid, mode) for c in cells]) for pid in eligible}
                    leader = min(eligible, key=lambda pid: (means[pid], pid)) if eligible else None
                    fixed[owner] = leader
                    fixed_views.append(dict(keys=n, batch=batch, mode=mode, rival_owner=owner,
                        candidate_point_id=pipeline, fixed_leader_point_id=leader,
                        geometric_mean_ns_per_key=means.get(leader), eligible_point_ids=sorted(eligible),
                        selection_scope='descriptive same-four-cell geometric mean; not independent validation'))
                for case in cells:
                    common = dict(case_index=case['index'], keys=n, batch=batch, mode=mode,
                                  seed=case['seed'], round=case['round'], cap_bpk=CAP, fpr_ceiling=CEILING)
                    for point in panel:
                        pid = point['id']
                        alternatives.append(dict(**common, point_id=pid, owner=point['owner'],
                            median_ns_per_key=timing(case, pid, mode), **{
                                k: gates[pid][k] for k in ('actual_bytes', 'memory_eligible',
                                                          'both_seed_quality_eligible', 'eligible')}))
                    control_tag = dict(**common, comparison_group='range_control')
                    control_pairs.append(pair(control_tag, pipeline, control, case, mode))
                    if n == SIZES[1] and batch == 4096:
                        primary_controls.append(pair(control_tag, pipeline, control, case, mode, qualified=True))
                    for owner in RIVALS:
                        eligible = [p['id'] for p in panel if p['owner'] == owner and gates[p['id']]['eligible']]
                        best = min(eligible, key=lambda pid: (timing(case, pid, mode), pid)) if eligible else None
                        tag = dict(**common, rival_owner=owner)
                        envelopes.append(pair(tag, pipeline, best, case, mode, qualified=True))
                        fixed_pairs.append(pair(tag, pipeline, fixed[owner], case, mode, qualified=True))

    round_pairs = []
    for a in vectors:
        if a['round'] != 1:
            continue
        c2 = next(c for c in ledger if c['round'] == 2 and c['seed'] == a['seed'] and
                  (1 << c['power']) == a['keys'] and c['batch'] == a['batch'])
        ratio = timing(c2, a['point_id'], a['mode']) / a['median_ns_per_key']
        round_pairs.append(dict(point_id=a['point_id'], keys=a['keys'], seed=a['seed'], batch=a['batch'],
            mode=a['mode'], round1_case_index=a['case_index'], round2_case_index=c2['index'],
            round2_over_round1_latency_ratio=ratio, outcome=outcome(ratio)))

    required = primary_controls + [dict(p, comparison_group=p['rival_owner']) for p in envelopes
                                  if p['keys'] == SIZES[1] and p['batch'] == 4096]
    need(len(required) == 24, 'exact large4096 primary panel')
    groups = []
    for name in ('range_control',) + RIVALS:
        subset = [p for p in required if p['comparison_group'] == name]
        need(len(subset) == 8, 'exact eight primary comparisons per group')
        groups.append(dict(comparison_group=name, required_comparisons=8,
            met=all(p['outcome'] == 'faster' for p in subset),
            faster=sum(p['outcome'] == 'faster' for p in subset),
            slower=sum(p['outcome'] == 'slower' for p in subset),
            ties=sum(p['outcome'] == 'tie' for p in subset),
            not_comparable=sum(p['outcome'] == 'not_comparable' for p in subset)))
    decision = dict(rule='large4096: all four seed/round cells in both generic contracts strictly faster in each of the three qualified comparison groups',
        required_comparisons=24, cap_bpk=CAP, fpr_ceiling=CEILING,
        closed=all(g['met'] for g in groups), groups=groups,
        faster=sum(p['outcome'] == 'faster' for p in required),
        slower=sum(p['outcome'] == 'slower' for p in required),
        ties=sum(p['outcome'] == 'tie' for p in required),
        not_comparable=sum(p['outcome'] == 'not_comparable' for p in required),
        promotion_authorized=False, comparisons=required)
    need((len(alternatives), len(envelopes), len(fixed_views), len(fixed_pairs), len(control_pairs), len(round_pairs)) ==
         (512, 128, 32, 128, 64, 256), 'analysis output counts')
    mapping_records = [dict(mapping_id=mid, seed=seed, point_ids=entry['point_ids'],
        representative_quality=quality[(entry['point_ids'][0], seed)]) for (mid, seed), entry in mappings.items()]
    return dict(counts=dict(rows=192, api_quality_records=32, known_mapping_records=26, quality_reuses=160,
        vectors=512, trial_values=4096, alternatives=512, envelopes=128, fixed_views=32, fixed_pairs=128,
        unconditional_control_pairs=64, round_pairs=256, primary_comparisons=24),
        quality=list(quality.values()), mapping_quality=mapping_records, gates=list(gates.values()),
        vectors=vectors, trials=trials, alternatives=alternatives, envelopes=envelopes,
        fixed_views=fixed_views, fixed_pairs=fixed_pairs, control_pairs=control_pairs,
        round_pairs=round_pairs, decision=decision)


def write_report(result, directory):
    """Publish every product to a fresh directory only after complete committed load."""
    directory = Path(directory)
    need(not directory.exists() and not directory.is_symlink(), 'fresh report directory required')
    directory.mkdir(parents=True)
    for name, value in result.items():
        (directory / (name + '.json')).write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')
    decision = result['decision']
    lines = ['# Independent32Range prefetch64 query screen', '',
        'The prespecified large4096 criterion is **' + ('met' if decision['closed'] else 'not met') +
        '** in this fixed panel. Its24 comparisons contain ' +
        f"{decision['faster']} faster, {decision['slower']} slower, {decision['ties']} ties and " +
        f"{decision['not_comparable']} not comparable. No promotion is authorized.", '',
        'n=2^16/2^25; q=2^22; requested hit50%; batches1/31/4096; eight trials; two seen construction seeds '
        'and two reverse launch rounds. Ratios are pipeline/rival latency: below1 is faster. '
        'External and production rivals must fit actual16 bpk and pass their pointwise1% Wilson upper gates in both seeds.', '',
        '| Required large4096 comparison group | Faster / slower / tie / NC | All eight strict wins |',
        '|---|---:|---|']
    for group in decision['groups']:
        values = [group[k] for k in ('faster', 'slower', 'ties', 'not_comparable')]
        lines.append('| ' + group['comparison_group'] + ' | ' + ' / '.join(map(str, values)) +
                     ' | ' + ('yes' if group['met'] else 'no') + ' |')
    lines += ['', 'All64 direct pipeline/control ratios remain unconditional with eligibility flags. '
        'The primary eight control comparisons additionally require qualification; an unavailable qualifier, tie or loss '
        'fails that group. Every one of the three groups must pass.', '',
        'The following table retains all contracts. The range-control rows are unconditional; owner rows choose the '
        'fastest eligible rival in each seed/round cell. Fixed geometric-mean leaders remain separate descriptive products.', '',
        '| Keys | Batch | Contract | Comparison | Faster / slower / tie / NC | Four-cell latency ratio range |',
        '|---:|---:|---|---|---:|---|']
    for n in SIZES:
        for batch in BATCHES:
            for mode in modes(batch):
                for group in ('range_control',) + RIVALS:
                    pool = result['control_pairs'] if group == 'range_control' else result['envelopes']
                    pairs = [p for p in pool if p['keys'] == n and p['batch'] == batch and p['mode'] == mode and
                             (group == 'range_control' or p['rival_owner'] == group)]
                    values = [p['latency_ratio'] for p in pairs if p['latency_ratio'] is not None]
                    counts = [sum(p['outcome'] == name for p in pairs)
                              for name in ('faster', 'slower', 'tie', 'not_comparable')]
                    bounds = f'{min(values):.6f}–{max(values):.6f}' if values else 'unavailable'
                    lines.append(f'| {n} | {batch} | {mode} | {group} | ' +
                                 ' / '.join(map(str, counts)) + f' | {bounds} |')
    lines += ['', 'All512 vectors,4096 values and256 round comparisons are retained. '
        'All32 API calibration records and26 known mapping groups reuse their original denominators without pooling; '
        'known groups are not asserted to be independent. Pipeline/control bitmap and full query fingerprints agree '
        'within every case, and fresh calibration agrees for the proved aliases.', '',
        'This screen contains no build, Rust or multithread timing. Round1/batch1 alone includes untimed calibration, '
        'and process/environment history also differs between rounds. Neither round ratios nor same-data leader selections '
        'isolate order causality or establish a universal winner. Small-table, singleton and batch31 losses remain '
        'explicit controls even though their source dispatch is unchanged.', '']
    (directory / 'REPORT.md').write_text('\n'.join(lines))


