"""Fail-closed exact-capacity, source-order and four-public-contract guards."""
import collections
import itertools
import math
import re

NATIVE = {'FastPatternBF', 'ByteSplitBloomFilter', 'FourSectorBloomFilter', 'Split64BloomFilter'}
FIXED = {f'Fastbloom017K{k}' for k in range(1, 13)}
EXTERNAL = {'Fastbloom017', 'BloomsdayPinned', 'SbbfSafePinned'} | FIXED
RANGE = 'Split64RangeBloomFilter'
K12 = 'FourSectorRange12BloomFilter'
NAMES = NATIVE | EXTERNAL | {RANGE, K12}
METRICS = ('lookup', 'hash_lookup', 'inline_lookup', 'inline_hash_lookup')
BUILD = ('insert_ns', 'allocate_insert_ns', 'hash_insert_ns', 'allocate_hash_insert_ns')
MASK = (1 << 64) - 1
STEP = 0x9e3779b97f4a7c15


def require(condition, message):
    if not condition:
        raise ValueError(message)


def next_value(state):
    state = (state + STEP) & MASK
    value = ((state ^ (state >> 30)) * 0xbf58476d1ce4e5b9) & MASK
    value = ((value ^ (value >> 27)) * 0x94d049bb133111eb) & MASK
    return state, value ^ (value >> 31)


def shuffled(values, state):
    values = list(values)
    for count in range(len(values), 1, -1):
        state, value = next_value(state)
        index = value % count
        values[count - 1], values[index] = values[index], values[count - 1]
    return values


def source_registry(source):
    match = re.search(r'const FILTER_NAMES: &\[&str\] = &\[(.*?)\];', source, re.S)
    require(match is not None, 'Missing source registry')
    names = re.findall(r'"([A-Za-z0-9_]+)"', match[1])
    require(len(names) == len(set(names)) == 21 and set(names) == NAMES, 'Wrong source registry')
    return names


def csv_fields(source):
    match = re.search(r'println!\("(language,filter,keys,[^"\n]+)"\);', source)
    require(match is not None, 'Missing source CSV header')
    names = match[1].split(',')
    require(len(names) == len(set(names)), 'Duplicate source column')
    return names


def selected_names(cap, source):
    return [name for name in source_registry(source) if cap != 24 or name not in NATIVE]


def validate_protocol(protocol, registry, source):
    require(__debug__, 'Run without Python -O')
    require(protocol['key_powers'] == [16, 25] and protocol['budget_bpk'] == [16, 24, 32]
            and protocol['batches'] == [1, 31, 4096] and protocol['seeds'] == [42], 'Changed training grid')
    require(protocol['query_power'] == 22 and protocol['hit_percent'] == 50
            and protocol['calibration_power'] == 24 and protocol['repeats'] == 8
            and protocol['query_repeats'] == 8 and protocol['build_repeats'] == 8, 'Changed trial contract')
    require(protocol['filters'] == source_registry(source) == list(registry), 'Changed registry/source order')
    for name, info in registry.items():
        owner = 'production_native' if name in NATIVE else 'external' if name in EXTERNAL else 'native_experimental'
        policy = 'largest_fitting_native_pow2' if name in NATIVE else 'exact_blocks'
        api = 'may_match_hash' if name == 'BloomsdayPinned' else 'contains_hash'
        if name in FIXED:
            k = int(name.removeprefix('Fastbloom017K'))
            expected = dict(owner='external', public_api='contains_hash', constructor='with_num_bits(exact_bits).hashes(K)',
                fixed_K=k, capacity_policy='exact_words', mapping_family='Fastbloom017',
                calibration_alias='Fastbloom017 default at16bpk only' if k == 11 else None)
        else:
            expected = dict(owner=owner, public_api=api, capacity_policy=policy, mapping_family=name)
        require(info == expected, 'Wrong registry metadata')
    cases = [dict(key_power=n, budget_bpk=cap, batch=batch, seed=seed, filters=selected_names(cap, source))
             for n, cap, batch, seed in itertools.product(protocol['key_powers'], protocol['budget_bpk'], protocol['batches'], protocol['seeds'])]
    require(protocol['cases'] == cases and len(cases) == protocol['expected_cases'] == 18, 'Changed exact case/order selection')
    require(sum(len(case['filters']) for case in cases) == protocol['expected_rows'] == 336, 'Wrong expected rows')
    require(protocol['quality_records'] == 112 and protocol['known_mapping_records'] == 110, 'Wrong family/geometry/size/seed record count')


def expected_order(case, protocol, source):
    n, q = 1 << case['key_power'], 1 << protocol['query_power']
    hit = protocol['hit_percent']
    present = q // 100 * hit + min(q % 100, hit)
    # One key_base, n-1 insertion shuffle, present positive draws, q-1 query shuffle.
    state = (case['seed'] + STEP * (1 + n - 1 + present + q - 1)) & MASK
    return shuffled([name for name in source_registry(source) if name in case['filters']], state)


def expected_phases(seed, repeats):
    labels = shuffled(range(4), seed ^ 0x6a09e667f3bcc909)
    williams = ((0, 1, 3, 2), (1, 2, 0, 3), (2, 3, 1, 0), (3, 0, 2, 1))
    return ';'.join('|'.join(str(labels[x]) for x in williams[i % 4]) for i in range(repeats))


def expected_geometry(name, n, cap):
    actual = 16 if name in NATIVE and cap == 24 else cap
    backing, budget = n * actual // 8, n * cap // 8
    unit, kind, probes, policy, argument = 64, 'range_lines', 8, 'fixed', budget
    owner = 'native_experimental' if name == RANGE else 'external'
    if name == K12:
        kind, probes, owner = 'top24_range_lines', 12, 'K12_experiment'
    elif name in NATIVE:
        kind, argument, owner = 'native_pow2_lines', actual // 2, 'production_native'
        if name == 'ByteSplitBloomFilter':
            probes, policy = -1, 'variable_byte_mask_0_16'
    elif name == 'Fastbloom017':
        unit, kind, probes = 8, 'classical_words', {16: 11, 24: 17, 32: 22}[cap]
        policy, argument = 'upstream_expected_items_real_n', backing * 8
    elif name in FIXED:
        unit, kind, probes = 8, 'classical_words', int(name.removeprefix('Fastbloom017K'))
        policy, argument = 'public_fixed_hash_count', backing * 8
    elif name == 'BloomsdayPinned':
        unit, kind, argument = 32, 'public_split32_range', cap
    elif name == 'SbbfSafePinned':
        unit, kind = 32, 'public_sbbf_range_padded64'
    return dict(filter_bytes=backing, actual_bpk=actual, budget_bytes=budget, logical_bytes=backing,
                geometry_kind=kind, unit_bytes=unit, unit_count=backing // unit, effective_probes=probes,
                probe_policy=policy, constructor_argument=argument, implementation_origin=owner,
                size_contract='exact_byte_ceiling_v1')


def validate_rows(rows, case, protocol, source):
    require(__debug__, 'Run without Python -O')
    require(case['filters'] and len(case['filters']) == len(set(case['filters'])) and set(case['filters']) <= set(source_registry(source)), 'Wrong selected family set')
    require([row['filter'] for row in rows] == expected_order(case, protocol, source), 'Wrong exact source-derived row order/count')
    n, q = 1 << case['key_power'], 1 << protocol['query_power']
    hit, repeats = protocol['hit_percent'], protocol['repeats']
    present = q // 100 * hit + min(q % 100, hit)
    for row in rows:
        require(list(row) == csv_fields(source) and None not in row and all(value is not None for value in row.values()), 'Wrong CSV columns')
        expected = dict(keys=n, queries=q, requested_bpk=case['budget_bpk'], hash_bits=64,
                        hit_percent=hit, present_queries=present, absent_queries=q-present,
                        batch=case['batch'], repeats=repeats, seed=case['seed'], insert_batch=n,
                        calibration_absent_queries=1 << protocol['calibration_power'])
        expected.update(expected_geometry(row['filter'], n, case['budget_bpk']))
        for field, value in expected.items():
            if isinstance(value, int):
                require(int(row[field]) == value, 'Wrong ' + field + ': ' + row['filter'])
            else:
                require(row[field] == value, 'Wrong ' + field + ': ' + row['filter'])
        require(row['language'] == 'rust' and row['input_mode'] == 'prehashed'
                and row['scalar_track'] == 'optimizer_visible_public_single', 'Wrong public/input contract')
        require(0 <= int(row['result_checksum']) <= MASK, 'Invalid checksum')
        fp, absent = int(row['false_positives']), q - present
        require(0 <= fp <= absent and math.isclose(float(row['fpr']), fp / absent, rel_tol=1e-12, abs_tol=1e-15), 'Invalid mixed FPR')
        require(0 <= int(row['calibration_false_positives']) <= 1 << protocol['calibration_power'], 'Invalid independent FP count')
        phase = expected_phases(case['seed'], repeats)
        require(row['query_phase_order'] == phase, 'Wrong source-derived phase order')
        orders = [list(map(int, part.split('|'))) for part in phase.split(';')]
        positions = collections.Counter((position, mode) for order in orders for position, mode in enumerate(order))
        predecessors = collections.Counter(pair for order in orders for pair in zip(order, order[1:]))
        require(len(positions) == 16 and set(positions.values()) == {repeats // 4}
                and len(predecessors) == 12 and set(predecessors.values()) == {repeats // 4}, 'Unbalanced phase contract')
        for metric in METRICS:
            values = [float(value) for value in row[metric + '_trials'].split('|')]
            require(len(values) == repeats and all(math.isfinite(value) and value > 0 for value in values), 'Invalid trial vector')
            ordered = sorted(values)
            median = (ordered[repeats // 2 - 1] + ordered[repeats // 2]) / 2
            require(math.isclose(float(row[metric + '_ns']), median, rel_tol=1e-12), 'Wrong median')
            require(float(row[metric + '_min_ns']) == min(values) and float(row[metric + '_max_ns']) == max(values), 'Wrong trial range')
        require(all(math.isfinite(float(row[field])) and float(row[field]) > 0 for field in BUILD), 'Invalid serial build timing')
        require(float(row['allocate_insert_ns']) >= float(row['insert_ns'])
                and float(row['allocate_hash_insert_ns']) >= float(row['hash_insert_ns']), 'Invalid allocation-inclusive build')


def validate_all(rows, protocol, registry, source):
    validate_protocol(protocol, registry, source)
    require(len(rows) == protocol['expected_rows'], 'Incomplete aggregate')
    offset, seen = 0, {}
    fields = ('filter_bytes', 'actual_bpk', 'logical_bytes', 'result_checksum', 'false_positives',
              'present_queries', 'absent_queries', 'calibration_absent_queries', 'calibration_false_positives',
              'effective_probes', 'probe_policy', 'constructor_argument')
    for case in protocol['cases']:
        group = rows[offset:offset + len(case['filters'])]
        validate_rows(group, case, protocol, source)
        offset += len(group)
        for row in group:
            key = tuple(row[field] for field in ('filter', 'keys', 'filter_bytes', 'seed'))
            values = tuple(row[field] for field in fields)
            require(key not in seen or seen[key] == values, 'Cross-batch semantic/calibration mismatch')
            seen[key] = values
    require(offset == len(rows) and len(seen) == protocol['quality_records'], 'Wrong deduplicated family records')
    return dict(rows=len(rows), cases=len(protocol['cases']), family_geometry_size_seed_quality_records=len(seen), pooled=False)


def raw_intervals(case, protocol):
    n, q, cal = 1 << case['key_power'], 1 << protocol['query_power'], 1 << protocol['calibration_power']
    _, first = next_value(case['seed'])
    base = first % ((1 << 32) - n - q)
    return dict(inserted=[base, base + n], timed_negative_envelope=[base+n, base+n+q],
                independent_calibration=[base+n+q, base+n+q+cal], interval_convention='half-open raw integer keys; common hash applied afterward')
