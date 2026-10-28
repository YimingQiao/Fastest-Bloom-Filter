#!/usr/bin/env python3
"""Screen external configurations under explicit memory/FPR constraints, never a global-fastest claim."""
import argparse
import csv
import math
from collections import defaultdict
from pathlib import Path
from statistics import median


def upper95(successes, trials):
    # One-sided 95% Wilson score bound. Zero observed FP still has nonzero bound.
    if not trials:
        return math.inf
    z = 1.6448536269514722
    p = successes / trials
    return (p + z*z/(2*trials) + z*math.sqrt(p*(1-p)/trials + z*z/(4*trials*trials))) / (1+z*z/trials)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('csv', nargs='+', type=Path)
    ap.add_argument('--max-bpk', type=float, default=32)
    ap.add_argument('--allocation-slack', type=int, default=64, help='Bytes above bit-budget cap, explicitly reported')
    ap.add_argument('--fpr-targets', default='0.01,0.001,0.0001')
    ap.add_argument('--metric', choices=['lookup_ns', 'hash_lookup_ns', 'insert_ns', 'hash_insert_ns'], default='hash_lookup_ns')
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    records = []
    for path in args.csv:
        for r in csv.DictReader(path.open()):
            r['series'] = path.parent.name
            records.append(r)
    # Never collapse different binaries into one algorithm and silently pick its best timings.
    def config(r):
        return tuple(r.get(k, '') for k in ('series', 'language', 'filter', 'keys', 'requested_bpk', 'filter_bytes', 'input_mode', 'queries', 'repeats'))
    seen = set()
    for r in records:
        identity = (config(r), r['hit_percent'], r['batch'], r.get('insert_batch', r['batch']), r['seed'])
        if identity in seen:
            raise ValueError(f'Duplicate timing case: {identity}')
        seen.add(identity)
    negatives = defaultdict(dict)
    for r in records:
        if r['hit_percent'] == '0':
            # Batch/insert-batch repeats use identical query keys; count a seed only once.
            seed = r['seed']
            counts = (int(r['false_positives']), int(r['absent_queries']))
            previous = negatives[config(r)].get(seed)
            if previous is not None and previous[1] == counts[1] and previous != counts:
                raise ValueError('FPR changed across batch sizes for same input')
            if previous is None or counts[1] > previous[1]:
                negatives[config(r)][seed] = counts
    timings = defaultdict(list)
    for r in records:
        if args.metric not in r or not math.isfinite(float(r[args.metric])):
            continue
        bucket = (config(r), r['hit_percent'], r['batch'], r.get('insert_batch', r['batch']))
        timings[bucket].append(r)
    contenders = defaultdict(list)
    seed_sets = {}
    for (cfg, hit, batch, ins_batch), rr in timings.items():
        seeds = {r['seed'] for r in rr}
        signature = (rr[0]['keys'], rr[0]['queries'], rr[0]['repeats'], hit, batch, ins_batch)
        if seed_sets.setdefault(signature, seeds) != seeds:
            raise ValueError(f'Incomparable timing seed sets: {signature}')
        if set(negatives[cfg]) != seeds:
            raise ValueError(f'Calibration and timing seed sets differ: {cfg}')
        counts = negatives[cfg].values()
        fp = sum(x[0] for x in counts)
        nq = sum(x[1] for x in counts)
        bound = upper95(fp, nq)
        r = rr[0]
        cap = math.floor(int(r['keys']) * args.max_bpk / 8) + args.allocation_slack
        if int(r['filter_bytes']) > cap:
            continue
        for target in map(float, args.fpr_targets.split(',')):
            if bound <= target:
                scenario = (r['keys'], hit, batch, ins_batch, target, r['queries'], r['repeats'])
                contenders[scenario].append({
                    'series': cfg[0], 'language':r['language'], 'filter':r['filter'],
                    'requested_bpk':r['requested_bpk'], 'filter_bytes':r['filter_bytes'],
                    'memory_ceiling_bytes':cap, 'fpr_observed':fp/nq,
                    'fpr_upper95':bound, 'negative_samples':nq,
                    'timing_cases':len(rr), 'metric':args.metric,
                    'ns_per_key':median(float(x[args.metric]) for x in rr),
                })
    fields = ['keys','hit_percent','batch','insert_batch','fpr_target','queries','repeats','rank','series','language','filter',
              'requested_bpk','filter_bytes','memory_ceiling_bytes','fpr_observed','fpr_upper95',
              'negative_samples','timing_cases','metric','ns_per_key','relative_to_fastest']
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('w', newline='') as f:
        writer = csv.DictWriter(f, fields, lineterminator='\n')
        writer.writeheader()
        for scenario, candidates in sorted(contenders.items()):
            candidates.sort(key=lambda c: c['ns_per_key'])
            best = candidates[0]['ns_per_key']
            for rank, candidate in enumerate(candidates, 1):
                row = dict(zip(fields[:7], scenario))
                row.update(candidate, rank=rank, relative_to_fastest=candidate['ns_per_key']/best)
                writer.writerow(row)
    print(f'Wrote {len(contenders)} screened scenarios to {args.output}. Selection and timing use the supplied seeds; confirm winners with new seeds.')


if __name__ == '__main__':
    main()
