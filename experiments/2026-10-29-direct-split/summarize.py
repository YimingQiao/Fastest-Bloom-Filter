#!/usr/bin/env python3
"""Conservatively compare preselected shortcuts with the best qualifying baseline row."""
import csv
import json
from pathlib import Path
import statistics
import sys
from run import wilson_upper

path = Path(sys.argv[1])
rows = list(csv.DictReader(path.open()))
groups = {}
for row in rows:
    key = tuple(row[k] for k in ['keys', 'actual_bpk', 'batch', 'hit_percent', 'seed'])
    groups.setdefault(key, {})[row['filter']] = row
baseline_names = ['FastFilterFixed16', 'FastFilterFixed16SingleControl',
                  'FastFilterSimdBlock', 'FastFilterSimdBlockSingleControl',
                  'FastFilterFixed32', 'Split64FrozenBF']
cases = []
for key, group in groups.items():
    for candidate, target in [('ByteSplit128SingleExperiment', 0.01 if key[1] == '16' else 0.001),
                              ('IndependentSplit32SingleExperiment', 0.01 if key[1] == '16' else 0.0001)]:
        if candidate not in group:
            continue
        current = group[candidate]
        def qualifies(row):
            q = int(row['calibration_absent_queries'])
            fp = int(row['calibration_false_positives'])
            if q == 0:
                q, fp = int(row['absent_queries']), int(row['false_positives'])
            return int(row['filter_bytes']) <= int(current['filter_bytes']) and q > 0 and wilson_upper(fp, q) <= target
        if not qualifies(current):
            raise ValueError(f'candidate fails FPR gate: {key}, {candidate}, {target}')
        baselines = [group[name] for name in baseline_names if name in group and qualifies(group[name])]
        if not baselines:
            raise ValueError(f'no qualifying baseline for {key}')
        for metric in ['lookup_ns', 'hash_lookup_ns']:
            best = min(baselines, key=lambda row: float(row[metric]))
            cases.append({'candidate': candidate, 'keys': int(key[0]), 'actual_bpk': int(key[1]),
                          'batch': int(key[2]), 'hit_percent': int(key[3]), 'seed': int(key[4]),
                          'fpr_target': target, 'metric': metric, 'baseline': best['filter'],
                          'candidate_ns': float(current[metric]), 'baseline_ns': float(best[metric]),
                          'speedup': float(best[metric]) / float(current[metric])})
summary = []
for candidate, keys, bpk, batch, metric in sorted({(r['candidate'], r['keys'], r['actual_bpk'], r['batch'], r['metric']) for r in cases}):
    selected = [r for r in cases if (r['candidate'], r['keys'], r['actual_bpk'], r['batch'], r['metric']) == (candidate, keys, bpk, batch, metric)]
    summary.append({'candidate': candidate, 'keys': keys, 'actual_bpk': bpk, 'batch': batch, 'metric': metric,
                    'count': len(selected), 'median_speedup': statistics.median(r['speedup'] for r in selected),
                    'min_speedup': min(r['speedup'] for r in selected), 'max_speedup': max(r['speedup'] for r in selected)})
result = {'selection': 'preselected prototype shortcut versus fastest qualifying baseline/control per scenario and metric; two-sided Wilson 95% upper gate',
          'cases': cases, 'summary': summary}
output = path.with_name('summary.json')
output.write_text(json.dumps(result, indent=2) + '\n')
for r in summary:
    print(r['candidate'], 'n=',r['keys'], 'bpk=',r['actual_bpk'],r['metric'],
          f"{r['median_speedup']:.3f}x [{r['min_speedup']:.3f}, {r['max_speedup']:.3f}]")
