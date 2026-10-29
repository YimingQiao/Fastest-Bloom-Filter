"""Untimed allocation, complete outputs and shared-query CSV contract checks."""
import hashlib
import json
import math
import re

GEOMETRY = ('filter_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes','probe_policy','page_level')
SEMANTICS = ('keys','queries','filter_bytes','hash_bits','hit_percent','present_queries','absent_queries',
             'result_checksum','false_positives','input_mode','calibration_absent_queries','calibration_false_positives','filter_build_scratch_bytes')
RANGE = 'Split64RangeNative'
RAW = 'PageBloom6Compact'
MASK = (1 << 64) - 1
STEP = 0x9e3779b97f4a7c15


def require(ok, message):
    if not ok:
        raise ValueError(message)


def source_registry(source):
    names = ['FastPatternBF'] + re.findall(r'ADD\((\w+), uint64_t\)', source)
    require(len(names) == len(set(names)) == 25, 'Wrong25 source registry')
    return names


def identity(row):
    name = row['filter']
    family = 'FastFilterFixed64' if name == RANGE else re.sub('(SingleV1|Bulk)$', '', name)
    if family.startswith('RocksDBFastLocalBloom64'):
        family = 'RocksDBFastLocalBloom64Core'
    canonical = dict(row)
    if name == RANGE:
        canonical['geometry_kind'] = 'fixed_range_buckets'
    geometry = tuple(row[key] for key in GEOMETRY)
    shared = tuple(canonical[key] for key in GEOMETRY)
    api = (name, row['keys']) + geometry
    sample = (family, row['keys']) + shared
    digest = lambda value: hashlib.sha256(json.dumps(value).encode()).hexdigest()[:24]
    return digest(api), digest(sample)


def validate_plan(rows, names, n, budget):
    require([row['filter'] for row in rows] == names, 'Incomplete/reordered25 allocation grid')
    for row in rows:
        require(None not in row and all(value is not None for value in row.values()), 'Malformed allocation CSV')
        require(row['status'] == 'supported' and not row['reason'], 'Unsupported proposed geometry')
        require(int(row['keys']) == n and int(row['requested_bpk']) == budget, 'Wrong actual allocation inputs')
        require(int(row['budget_bytes']) == n * budget // 8 and 0 < int(row['filter_bytes']) <= int(row['budget_bytes']), 'Over-budget allocation')
        require(0 < int(row['logical_bytes']) <= int(row['filter_bytes']) and int(row['unit_count']) > 0, 'Wrong logical geometry')
        if row['filter'] == RANGE:
            require(row['implementation_origin'] == 'project_experiment' and row['geometry_kind'] == 'project_range_buckets'
                    and int(row['effective_probes']) == 8, 'Wrong Range origin/probe mapping')


def select_grid(all_rows, proposal, names):
    require(len(all_rows) == 350, 'Expected350 actual allocation observations')
    by_case = {}
    for row in all_rows:
        by_case.setdefault((int(row['keys']), int(row['requested_bpk'])), []).append(row)
    require(set(by_case) == {(1 << power, cap) for power in (16,25) for cap in (12,14,16,20,24,28,32)}, 'Missing actual grid case')
    for (n, cap), rows in by_case.items():
        validate_plan(rows, names, n, cap)
    selected, seen = [], set()
    base = set(proposal['base_shortlist']) | {RANGE}
    require(len(base) == 24 and set(names) == base | {'Boost192ClassicK11'}, 'Changed shortlist union')
    def add(row):
        config, calibration = identity(row)
        if config in seen:
            return
        seen.add(config)
        selected.append(dict(row, key_power=int(row['keys']).bit_length()-1,
                             configuration_id=config, calibration_identity=calibration))
    for n in (1 << 16, 1 << 25):
        for cap in proposal['grid_budget_bpk']:
            for row in by_case[(n, cap)]:
                if row['filter'] in base:
                    add(row)
    require(len(selected) == proposal['expected_grid_unique_rows'] == 132, 'Wrong deduplicated grid132')
    for old in proposal['replay_fixed_external_geometries']:
        rows = by_case[(1 << old['key_power'], int(old['requested_bpk']))]
        row = next(row for row in rows if row['filter'] == old['filter'])
        config, calibration = identity(row)
        require(config == old['configuration_id'] and calibration == old['calibration_identity']
                and row['filter_bytes'] == old['filter_bytes'], 'Changed fixed external replay geometry')
        add(row)
    require(len(selected) == proposal['expected_total_rows'] == 142 and len(selected)-132 == proposal['expected_extra_external_rows'] == 10, 'Wrong142 selected geometries')
    groups = {}
    for row in selected:
        groups.setdefault((row['key_power'], int(row['requested_bpk'])), []).append(row)
    cases = [dict(key_power=n, budget_bpk=cap, filters=[name for name in names if name in {r['filter'] for r in rows}])
             for (n,cap), rows in sorted(groups.items())]
    return dict(scope='Allocation-only validated selection; no timings', actual_grid_rows=350, configurations=selected,
                cases=cases, rows=142, grid_rows=132, extra_rows=10, registry=names,
                quality_policy='Equivalent mapping/calibration identity reused once, never pooled across API/thread/batch aliases')


def validate_dense(current, reference, names):
    def indexed(rows):
        keys = [(r['filter'], r['keys'], r['budget_bpk']) for r in rows]
        require(len(keys) == len(set(keys)), 'Duplicate dense fixture')
        return dict(zip(keys, rows))
    a, b = indexed(current), indexed(reference)
    expected = {(name,n,cap) for name in names for n in (64,1024,65536) for cap in (16,24,32)}
    require(set(a) == expected and len(a) == 225, 'Incomplete current225 dense fixtures')
    require(set(b) == {key for key in expected if key[0] != RANGE} and len(b) == 216, 'Incomplete retained216 dense fixtures')
    for key, row in a.items():
        require(row['inserted_checked'] == row['keys'], 'Incomplete no-FN insertion check')
        require(len(row['outputs']) == 4097 and len(row['calibration_outputs']) == 4096, 'Incomplete dense arrays')
        require(all(value in (0,1) for value in row['outputs'] + row['calibration_outputs']), 'Nonboolean dense answer')
        require(all(row['outputs'][i] == 1 for i in range(0,4097,4)), 'Full-output false negative')
        if key in b:
            require(row == b[key], 'Retained old/current full-output mismatch')
        else:
            peer = dict(a[('FastFilterFixed64',key[1],key[2])], filter=RANGE)
            require(row == peer, 'Native Range / equivalent Fixed64 complete-output mismatch')
    return dict(current=225, reference=216, compared_answers=216*(4097+4096), range_alias_fixtures=9)


def shuffled_order(names, seed, n, q, hit):
    present = q // 100 * hit + min(q % 100, hit)
    state = (seed + STEP * (1+n-1+present+q-1)) & MASK
    names = list(names)
    for count in range(len(names),1,-1):
        state = (state + STEP) & MASK
        value = ((state ^ (state >> 30)) * 0xbf58476d1ce4e5b9) & MASK
        value = ((value ^ (value >> 27)) * 0x94d049bb133111eb) & MASK
        value ^= value >> 31
        index = value % count
        names[count-1], names[index] = names[index], names[count-1]
    return names


def vector(row, key, repeats, raw=False, positive=False, raw_count=None):
    values = [float(value) for value in row[key].split('|')]
    if raw:
        require(len(values) == (repeats if raw_count is None else raw_count) and all(math.isnan(value) for value in values), 'Raw-only adapter has wrong pure vector')
    else:
        require(len(values) == repeats and all(math.isfinite(value) and (value > 0 if positive else value >= 0) for value in values), 'Invalid full trial vector')
    return values


def median(values):
    values = sorted(values)
    return values[len(values)//2] if len(values)%2 else (values[len(values)//2-1]+values[len(values)//2])/2


def close(a,b):
    return math.isclose(float(a),float(b),rel_tol=1e-12,abs_tol=1e-12)


def validate_cli(rows, names, planned, cap, hit, batch, workers):
    n,q,repeats,seed,cal = 1024,16384,2,731,4096
    require([row['filter'] for row in rows] == shuffled_order(names,seed,n,q,hit), 'Wrong exact measured registry/order')
    present = q//100*hit+min(q%100,hit)
    for row in rows:
        require(None not in row and all(value is not None for value in row.values()), 'Malformed query CSV')
        name = row['filter']; raw = name == RAW
        values = dict(keys=n,queries=q,requested_bpk=cap,hash_bits=64,hit_percent=hit,present_queries=present,
                      absent_queries=q-present,batch=batch,repeats=repeats,seed=seed,insert_batch=n,
                      calibration_absent_queries=cal,threads=workers,spawned_threads=workers-1,
                      parallel_hash_scratch_bytes=workers*batch*8,harness_hash_scratch_bytes=max(n,batch)*8)
        for field,expected in values.items():
            require(int(row[field]) == expected,'Wrong '+field)
        geometry = planned[name]
        for field in ('filter_bytes','budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes',
                      'probe_policy','constructor_argument','page_level','native_constructor_bpk','implementation_origin'):
            require(row[field] == geometry[field], 'Changed actual geometry: '+name+'/'+field)
        require(close(row['actual_bpk'],8*int(row['filter_bytes'])/n), 'Wrong actual bpk')
        require(row['size_contract'] == 'exact_byte_ceiling_v1' and row['executor'] == 'caller_worker0'
                and row['query_phase_order'] == 'fixed_serial_pure_serial_hash_parallel_pure_parallel_hash'
                and row['input_mode'] == ('raw_bytes' if raw else 'prehashed'), 'Wrong timing/input contract')
        require(0 <= int(row['result_checksum']) <= MASK and 0 <= int(row['false_positives']) <= q-present
                and 0 <= int(row['calibration_false_positives']) <= cal, 'Invalid output counts')
        require(math.isnan(float(row['fpr'])) if present == q else close(row['fpr'],int(row['false_positives'])/(q-present)), 'Wrong mixed FPR')
        for prefix in ('lookup','hash_lookup'):
            missing = raw and prefix == 'lookup'
            trial = vector(row,prefix+'_trials_ns',repeats,missing,True)
            for field,expected in (('_ns',median(trial)),('_min_ns',min(trial)),('_max_ns',max(trial))):
                require(math.isnan(float(row[prefix+field])) if missing else close(row[prefix+field],expected),'Wrong direct serial trial summary')
        for prefix in ('parallel_lookup','parallel_hash_lookup'):
            missing = raw and prefix == 'parallel_lookup'
            trials = {part:vector(row,prefix+'_'+part+'_trials',repeats,missing,part in ('end_to_end','gated'),1)
                      for part in ('end_to_end','launch','gated','join')}
            if missing:
                require(all(math.isnan(float(row[prefix+'_'+field])) for field in ('end_to_end_ns','launch_ns','gated_ns','join_ns','end_to_end_min_ns','end_to_end_max_ns','gated_min_ns','gated_max_ns')), 'Raw-only adapter has pure summary')
                continue
            for part,values in trials.items():
                require(close(row[prefix+'_'+part+'_ns'],median(values)), 'Wrong parallel median')
            for part in ('end_to_end','gated'):
                require(close(row[prefix+'_'+part+'_min_ns'],min(trials[part])) and close(row[prefix+'_'+part+'_max_ns'],max(trials[part])),'Wrong parallel range')
            for i in range(repeats):
                require(close(trials['end_to_end'][i],sum(trials[p][i] for p in ('launch','gated','join'))), 'Incorrect thread lifetime decomposition')
        for field in ('insert_ns','allocate_insert_ns'):
            require(math.isnan(float(row[field])) if raw else math.isfinite(float(row[field])) and float(row[field])>0, 'Wrong pure-build label')
        require(all(math.isfinite(float(row[field])) and float(row[field])>0 for field in ('hash_insert_ns','allocate_hash_insert_ns')), 'Invalid raw serial build')


def compare_retained(current, old):
    lookup = {row['filter']:row for row in old}
    require(len(lookup) == len(old) == 25,'Wrong frozen serial25 selection')
    for row in current:
        name = 'Split64RangeExperiment' if row['filter'] == RANGE else row['filter']
        peer = lookup[name]
        for field in SEMANTICS + ('logical_bytes','unit_count','effective_probes','probe_policy'):
            require(row[field] == peer[field], 'Frozen serial semantic mismatch: '+row['filter']+'/'+field)
