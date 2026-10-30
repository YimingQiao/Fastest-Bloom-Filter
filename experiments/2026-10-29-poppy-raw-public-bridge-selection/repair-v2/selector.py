"""Pure historical within-Poppy selection; no file, process, or filter access."""
import copy
import math
from collections import Counter

KEYS = (65536, 33554432)
BATCHES = (1, 31, 4096)
ROUNDS = (1, 2)
CAPS = (16, 24, 32)
TARGETS = (.01, .001, .0001)
QUERY = ('lookup_ns', 'hash_lookup_ns', 'inline_lookup_ns', 'inline_hash_lookup_ns')
BUILD = ('insert_ns', 'allocate_insert_ns', 'hash_insert_ns', 'allocate_hash_insert_ns')
FORMS = ('natural_raw_u64_le_byte8', 'natural_typed_u64')
VIEW_FIELDS = ('category', 'round', 'keys', 'batch', 'cap_bpk', 'target_fpr', 'metric')


def need(condition, message):
    if not condition:
        raise ValueError(message)


def wilson(fp, n):
    need(type(fp) is int and type(n) is int and n > 0 and 0 <= fp <= n, 'Invalid quality counts')
    z = 1.959963984540054
    p = fp / n
    return min(1., (p + z*z/(2*n) + z*math.sqrt(p*(1-p)/n + z*z/(4*n*n))) / (1+z*z/n))


def identity(view):
    return tuple(view[key] for key in VIEW_FIELDS)


def construction(point):
    value = point['canonical_constructor']
    need(value['n'] == point['keys'] and value['backing_bytes'] == point['actual_bytes'], 'Constructor size/accounting drift')
    need(point['source_mapping'] == [point['keys'], value['buckets'], value['cache_bytes'], value['probes']], 'Constructor mapping drift')
    need(value['cache_bytes'] >= 0 and value['backing_bytes'] >= value['cache_bytes'], 'Negative backing allocation')
    need(value['buckets'] > 0 and value['probes'] > 0 and len(value['fpp_bits']) == 16, 'Invalid constructor parameters')
    need(value['id'] in point['source_alias_ids'], 'Canonical constructor missing from aliases')
    # Preserve exact public arguments; do not invert/recompute rounded f64 FPP.
    return dict(canonical_constructor=copy.deepcopy(value), source_alias_ids=copy.deepcopy(point['source_alias_ids']),
                source_mapping=copy.deepcopy(point['source_mapping']), bucket_bytes=value['backing_bytes']-value['cache_bytes'],
                cache_bytes=value['cache_bytes'], total_backing_bytes=value['backing_bytes'])


def calculate(catalog, records, observations):
    all_points = catalog['configurations']
    need(len(all_points) == len({p['configuration_id'] for p in all_points}), 'Duplicate source configuration')
    points = {p['configuration_id']: p for p in all_points if p['owner'] == 'poppy_external'}
    need(len(points) == 47 and Counter(p['keys'] for p in points.values()) == {KEYS[0]: 25, KEYS[1]: 22}, 'Changed complete Poppy catalog')
    constructors = {ident: construction(p) for ident, p in points.items()}
    quality = []
    qmap = {}
    for observed in observations:
        ident = observed['configuration_id']
        if ident not in points:
            continue
        need(ident not in qmap, 'Repeated formal calibration')
        p = points[ident]
        need(observed['keys'] == p['keys'] and observed['filter'] == p['filter'] and observed['actual_bytes'] == p['actual_bytes'], 'Quality geometry drift')
        need(observed['absent'] == 1 << 26 and observed['seed'] == 42, 'Only formal cal26 is a quality source')
        upper = wilson(observed['false_positives'], observed['absent'])
        q = dict(copy.deepcopy(observed), historical_wilson95_upper=upper,
                 historical_gates=[dict(target_fpr=t, passed=upper <= t) for t in TARGETS])
        quality.append(q)
        qmap[ident] = q
    need(set(qmap) == set(points), 'Missing formal Poppy quality')

    lookup = {}
    rows = []
    need(len(records) == 36, 'Incomplete original process records')
    for record in records:
        case = record['case']
        ids = {p['filter']: ident for ident, p in points.items() if ident in case['configuration_ids']}
        for position, row in enumerate(record['rows']):
            if row['filter'] not in ids:
                continue
            ident = ids[row['filter']]
            p, q = points[ident], qmap[ident]
            need(case['keys'] == p['keys'] and int(row['filter_bytes']) == p['actual_bytes'], 'Actual row geometry drift')
            key = (ident, case['round'], case['batch'])
            need(key not in lookup, 'Duplicate geometry/round/batch')
            values = {metric: float(row[metric]) for metric in QUERY+BUILD}
            need(all(math.isfinite(v) and v > 0 for v in values.values()), 'Invalid historical median')
            entry = dict(configuration_id=ident, filter=p['filter'], keys=p['keys'], actual_bytes=p['actual_bytes'],
                         round=case['round'], batch=case['batch'], case_index=case['index'], filter_position=position,
                         calibration_case_index=q['case_index'], false_positives=q['false_positives'], absent=q['absent'],
                         historical_wilson95_upper=q['historical_wilson95_upper'], metrics=values)
            rows.append(entry)
            lookup[key] = entry
    expected = {(ident, rnd, batch) for ident in points for rnd in ROUNDS for batch in BATCHES}
    need(set(lookup) == expected and len(rows) == 282, 'Incomplete Poppy historical coverage')

    views, alternatives = [], []
    support = {ident: [] for ident in points}
    for category, metrics in [('query', QUERY), ('build', BUILD)]:
        for rnd in ROUNDS:
            for n in KEYS:
                for batch in BATCHES:
                    for cap in CAPS:
                        for target in TARGETS:
                            for metric in metrics:
                                view_id = f'view-{len(views):03d}'
                                key = dict(category=category, round=rnd, keys=n, batch=batch, cap_bpk=cap, target_fpr=target, metric=metric)
                                local = []
                                for ident, p in points.items():
                                    if p['keys'] != n:
                                        continue
                                    row = lookup[(ident, rnd, batch)]
                                    fits = row['actual_bytes']*8 <= n*cap
                                    passes = row['historical_wilson95_upper'] <= target
                                    failures = ([] if fits else ['over_byte_cap']) + ([] if passes else ['historical_quality_gate'])
                                    local.append({k: v for k, v in row.items() if k != 'metrics'} | key |
                                                 dict(view_id=view_id, historical_latency_ns=row['metrics'][metric], fits_cap=fits,
                                                      historical_quality_pass=passes, eligible=fits and passes, failure_reasons=failures))
                                eligible = [a for a in local if a['eligible']]
                                minimum = min((a['historical_latency_ns'] for a in eligible), default=None)
                                leaders = sorted((a['configuration_id'] for a in eligible if a['historical_latency_ns'] == minimum),
                                                 key=lambda ident: (points[ident]['actual_bytes'], ident))
                                for alt in local:
                                    alt['selected_in_view'] = alt['configuration_id'] in leaders
                                    if alt['eligible'] and not alt['selected_in_view']:
                                        alt['failure_reasons'].append('slower_eligible')
                                alternatives.extend(local)
                                views.append(key | dict(view_id=view_id, eligible_count=len(eligible),
                                                        minimum_historical_latency_ns=minimum, leaders=leaders,
                                                        no_eligible=not leaders))
                                for ident in leaders:
                                    support[ident].append(view_id)
    complete_catalog = []
    for ident, p in points.items():
        complete_catalog.append(dict(configuration_id=ident, filter=p['filter'], keys=p['keys'], actual_bytes=p['actual_bytes'],
                                     run_budget_bpk=p['run_budget_bpk'], selected=bool(support[ident]), supporting_views=support[ident],
                                     **constructors[ident]))
    union = [copy.deepcopy(p) for p in complete_catalog if p['selected']]
    forms = []
    for p in union:
        for form in FORMS:
            forms.append(dict(configuration_id=p['configuration_id'], future_input_form=form,
                              future_mapping_id=p['configuration_id']+'::'+form,
                              qualification_status='unmeasured', proof_required=True, new_quality_required=True,
                              new_performance_required=True, public_common_hash=False, required_common_hash_scratch_bytes=0,
                              **{k: copy.deepcopy(p[k]) for k in ('keys', 'actual_bytes', 'canonical_constructor', 'source_alias_ids',
                                                                  'source_mapping', 'bucket_bytes', 'cache_bytes', 'total_backing_bytes', 'supporting_views')}))
    counts = dict(poppy_geometries=len(points), poppy_rows=len(rows), poppy_metric_observations=len(rows)*8,
                  poppy_quality_records=len(quality), views=len(views), alternatives=len(alternatives),
                  null_views=sum(v['no_eligible'] for v in views), selected_geometries=len(union), future_public_forms=len(forms))
    need((len(views), len(alternatives), len(quality), len(forms)) == (864, 20304, 47, 2*len(union)), 'Fixed output coverage changed')
    return dict(counts=counts, views=views, alternatives=alternatives, quality=quality, historical_rows=rows,
                catalog=complete_catalog, union=union, future_public_forms=forms,
                original_over_cap_exclusions=copy.deepcopy(catalog['over_maximum_byte_cap']))


def compare_archived(data, archived):
    """Independent reconstructed ties must equal the completed prior analysis."""
    expected = {identity(v): v for v in archived['views']}
    need(len(expected) == len(archived['views']) == len(data['views']) == 864, 'Archived view coverage changed')
    for view in data['views']:
        old = expected[identity(view)]['leaders']['poppy_external']
        need([r['configuration_id'] for r in old] == view['leaders'], 'Historical Poppy tie set differs')
        minimum = old[0]['latency_ns'] if old else None
        need(minimum == view['minimum_historical_latency_ns'], 'Historical Poppy minimum differs')
        for leader in old:
            candidates = [a for a in data['alternatives'] if a['view_id'] == view['view_id'] and a['configuration_id'] == leader['configuration_id']]
            need(len(candidates) == 1, 'Ambiguous historical winner')
            a = candidates[0]
            need(all(a[k] == leader[k] for k in ('keys', 'actual_bytes', 'round', 'batch', 'case_index', 'filter_position', 'calibration_case_index', 'false_positives')), 'Historical winner provenance differs')
    old_quality = {q['configuration_id']: q for q in archived['quality'] if q['owner'] == 'poppy_external'}
    need(set(old_quality) == {q['configuration_id'] for q in data['quality']}, 'Archived quality coverage differs')
    for q in data['quality']:
        old = old_quality[q['configuration_id']]
        need(all(q[k] == old[k] for k in ('keys', 'actual_bytes', 'seed', 'absent', 'false_positives', 'case_index', 'semantics', 'intervals')), 'Archived formal quality differs')
        need(q['historical_wilson95_upper'] == old['wilson95_upper'], 'Archived Wilson endpoint differs')
