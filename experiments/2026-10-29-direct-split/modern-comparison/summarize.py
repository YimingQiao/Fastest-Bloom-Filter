#!/usr/bin/env python3
"""Compare against every quality-eligible rival at equal bytes and under the cap."""
import csv
import json
from pathlib import Path
import statistics
import sys
from run import wilson_upper

path = Path(sys.argv[1])
rows = list(csv.DictReader(path.open()))
candidates = {'ByteSplit128SingleExperiment', 'IndependentSplit32SingleExperiment'}
groups = {}
for row in rows:
    key = tuple(row[k] for k in ['keys', 'queries', 'batch', 'hit_percent', 'repeats', 'seed'])
    groups.setdefault(key, []).append(row)
cases = []
for key, group in groups.items():
    for current in group:
        candidate = current['filter']
        if candidate not in candidates:
            continue
        cap = int(current['filter_bytes'])
        bpk = int(current['actual_bpk'])
        target = 0.01 if bpk == 16 else (0.001 if candidate.startswith('Byte') else 0.0001)
        def qualifies(row):
            q = int(row['calibration_absent_queries'])
            fp = int(row['calibration_false_positives'])
            return q > 0 and wilson_upper(fp, q) <= target
        if not qualifies(current):
            raise ValueError(f'candidate fails independent FPR gate: {key}, {candidate}, {bpk}, {target}')
        for mode in ['equal_bytes', 'under_cap']:
            eligible = [row for row in group if row['filter'] not in candidates and qualifies(row)
                        and (int(row['filter_bytes']) == cap if mode == 'equal_bytes' else int(row['filter_bytes']) <= cap)]
            if not eligible:
                raise ValueError(f'no eligible baseline: {key}, {candidate}, {bpk}, {mode}')
            for metric in ['lookup_ns', 'hash_lookup_ns']:
                best = min(eligible, key=lambda row: float(row[metric]))
                cases.append({'candidate':candidate, 'keys':int(key[0]), 'actual_bpk':bpk,
                              'batch':int(key[2]), 'hit_percent':int(key[3]), 'seed':int(key[5]),
                              'fpr_target':target, 'comparison':mode, 'metric':metric,
                              'candidate_bytes':cap, 'candidate_ns':float(current[metric]),
                              'baseline':best['filter'], 'baseline_actual_bpk':float(best['actual_bpk']),
                              'baseline_bytes':int(best['filter_bytes']), 'baseline_ns':float(best[metric]),
                              'candidate_wilson95_upper':wilson_upper(int(current['calibration_false_positives']),int(current['calibration_absent_queries'])),
                              'baseline_wilson95_upper':wilson_upper(int(best['calibration_false_positives']),int(best['calibration_absent_queries'])),
                              'speedup':float(best[metric])/float(current[metric])})
summary = []
for key in sorted({tuple(r[k] for k in ['candidate','keys','actual_bpk','comparison','metric']) for r in cases}):
    selected = [r for r in cases if tuple(r[k] for k in ['candidate','keys','actual_bpk','comparison','metric']) == key]
    item = dict(zip(['candidate','keys','actual_bpk','comparison','metric'],key))
    item.update({'count':len(selected), 'median_speedup':statistics.median(r['speedup'] for r in selected),
                 'min_speedup':min(r['speedup'] for r in selected), 'max_speedup':max(r['speedup'] for r in selected),
                 'winning_rivals':sorted({f"{r['baseline']}@{r['baseline_actual_bpk']:g}bpk" for r in selected})})
    summary.append(item)
result = {'selection':'Two preselected prototypes; every native/FastFilter/RocksDB rival and versioned control tested; independent two-sided Wilson 95% upper FPR gate; per-case minimum at equal bytes and across both allocations under cap.',
          'cases':cases,'summary':summary}
path.with_name('summary.json').write_text(json.dumps(result,indent=2)+'\n')
for r in summary:
    if r['comparison'] == 'under_cap':
        print(r['candidate'], 'n=',r['keys'],'cap_bpk=',r['actual_bpk'],r['metric'],
              f"{r['median_speedup']:.3f}x [{r['min_speedup']:.3f}, {r['max_speedup']:.3f}]",','.join(r['winning_rivals']))
