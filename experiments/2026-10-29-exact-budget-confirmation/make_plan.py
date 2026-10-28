#!/usr/bin/env python3
"""Derive a fixed confirmation subset solely from the completed training archive."""
import argparse
import collections
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = ROOT / 'experiments/2026-10-29-exact-budget-range'
SLOTS = ('external', 'production_native', 'project_experiment', 'project_including_experiments')
ORIGINS = ('external', 'production_native', 'project_experiment')


def require(condition, message):
    if not condition:
        raise ValueError(message)


def build_plan(grid, summary, frontiers, seeds):
    require(len(seeds) == 3 and len(set(seeds)) == 3 and all(type(s) is int and 0 <= s < 2**64 and s != 42 for s in seeds), 'Exactly three distinct fresh u64 seeds required')
    require(len(summary['rankings']) == 24 and len(frontiers['frontiers']) == 126, 'Incomplete training rankings/frontiers')
    configs = {r['configuration_id']: r for r in grid['configurations']}
    require(len(configs) == len(grid['configurations']) == 988, 'Incomplete or duplicated training geometry grid')
    registry = grid['registry']
    require(len(registry) == 74 and len(set(registry)) == 74, 'Incomplete registry')
    order = {name: i for i, name in enumerate(registry)}
    reasons = collections.defaultdict(list)
    main, frontier = [], []

    def leader(value, keys, origin, reason):
        if value is None:
            return None
        cid = value['configuration_id']
        require(cid in configs, 'Leader geometry absent from original grid')
        r = configs[cid]
        require(int(r['keys']) == keys and r['filter'] == value['filter'] and int(r['filter_bytes']) == value['filter_bytes'], 'Leader geometry mismatch')
        require(r['implementation_origin'] in ({'production_native', 'project_experiment'} if origin == 'project_including_experiments' else {origin}), 'Leader ownership mismatch')
        reasons[cid].append(reason)
        return cid

    def setting(r):
        return {k: r[k] for k in ('keys', 'memory_cap_bpk', 'fpr_ceiling')}

    for i, r in enumerate(summary['rankings']):
        cell = setting(r) | {'source': 'main', 'training_record': i, 'metric': r['metric']}
        require(r['metric'] in ('lookup_ns', 'hash_lookup_ns'), 'Unknown main metric')
        cell['leaders'] = {slot: leader(r[slot], r['keys'], slot, {'source': 'main', 'record': i, 'slot': slot}) for slot in SLOTS}
        main.append(cell)
    require({(c['keys'],c['metric'],c['memory_cap_bpk'],c['fpr_ceiling']) for c in main} ==
            {(1<<p,m,b,f) for p in (16,25) for m in ('lookup_ns','hash_lookup_ns') for b in (16,32) for f in (0.01,0.001,0.0001)}, 'Missing or duplicate main comparison cell')
    main_ids = set(reasons)
    groups = {}
    for i, r in enumerate(frontiers['frontiers']):
        origin = r['origin']
        require(origin in ORIGINS, 'Unknown frontier ownership')
        cid = leader(r['winner'], r['keys'], origin, {'source': 'capacity_frontier', 'record': i, 'slot': origin})
        cell = setting(r) | {'source': 'capacity_frontier', 'training_record': i, 'metric': 'hash_lookup_ns', 'origin': origin, 'configuration_id': cid}
        frontier.append(cell)
        key = (r['keys'], r['memory_cap_bpk'], r['fpr_ceiling'])
        group = groups.setdefault(key, setting(r) | {'source': 'capacity_frontier', 'metric': 'hash_lookup_ns', 'leaders': {}})
        require(origin not in group['leaders'], 'Duplicate frontier origin/cell')
        group['leaders'][origin] = cid
    require(all(set(g['leaders']) == set(ORIGINS) for g in groups.values()), 'Missing frontier origin/cell')
    require(set(groups) == {(1<<p,b,f) for p in (16,25) for b in (12,14,16,20,24,28,32) for f in (0.01,0.001,0.0001)}, 'Missing frontier cap/size/quality cell')
    leader_ids = set(reasons)
    for cid, r in configs.items():
        if r['implementation_origin'] == 'production_native':
            reasons[cid].append({'source': 'native_control', 'rationale': 'Every originally measured production layout/actual allocation at the same real n, including quality failures'})
    selected = []
    seen_geometry = set()
    for cid in sorted(reasons, key=lambda c: (configs[c]['key_power'], int(configs[c]['requested_bpk']), order[configs[c]['filter']])):
        r = dict(configs[cid])
        # configuration_id already deduplicates repeated nominal budgets in the
        # original planner. Also reject a duplicate same-alias effective layout.
        identity = tuple(str(r[k]) for k in ('filter', 'keys', 'filter_bytes', 'logical_bytes', 'geometry_kind', 'unit_bytes', 'unit_count', 'effective_probes', 'probe_policy', 'constructor_argument', 'page_level', 'native_constructor_bpk'))
        require(identity not in seen_geometry, 'Duplicate alias/effective geometry')
        seen_geometry.add(identity)
        r['selection_reasons'] = reasons[cid]
        selected.append(r)
    cases = []
    for seed in seeds:
        for power, budget in sorted({(r['key_power'], int(r['requested_bpk'])) for r in selected}):
            members = [r for r in selected if r['key_power'] == power and int(r['requested_bpk']) == budget]
            cases.append({'case_id': f's{seed}-n{power}-b{budget}', 'seed': seed, 'key_power': power, 'budget_bpk': budget,
                          'filters': [r['filter'] for r in members], 'configuration_ids': [r['configuration_id'] for r in members]})
    counts = {'main_unique_leaders': len(main_ids), 'union_unique_leaders': len(leader_ids), 'additional_native_controls': len(set(reasons) - leader_ids),
              'configurations': len(selected), 'aliases': len({r['filter'] for r in selected}), 'cases': len(cases), 'rows': len(selected) * len(seeds),
              'by_origin': dict(sorted(collections.Counter(r['implementation_origin'] for r in selected).items())),
              'by_key_power': dict(sorted(collections.Counter(str(r['key_power']) for r in selected).items()))}
    return {'schema': 1, 'seeds': seeds, 'counts': counts, 'configurations': selected, 'cases': cases,
            'main_comparisons': main, 'frontier_records': frontier, 'frontier_comparisons': list(groups.values()),
            'selection_rule': 'Union every non-null external/production/range training leader in all 24 main rankings and 126 frontier records, plus every original production-native geometry. Preserve each original n and canonical requested budget; no Cartesian expansion across n, holdout replacement, or repeated nominal geometry.',
            'null_rule': 'A null training leader remains null. Fresh quality failures remain failures; never replace them using confirmation results.'}


def derive():
    read = lambda p: json.loads(p.read_text())
    return build_plan(read(PARENT/'planned-grid.json'), read(PARENT/'screen/summary.json'),
                      read(PARENT/'screen/capacity-frontier.json'), read(HERE/'seeds.json')['seeds'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    plan = derive()
    destination = HERE/'selection.json'
    if args.check:
        require(json.loads(destination.read_text()) == plan, 'Committed selection differs from deterministic training-only derivation')
    else:
        require(not destination.exists(), 'Selection already exists; never overwrite an approved/frozen plan')
        destination.write_text(json.dumps(plan, indent=2)+'\n')
    print(json.dumps(plan['counts'], sort_keys=True))


if __name__ == '__main__':
    main()
