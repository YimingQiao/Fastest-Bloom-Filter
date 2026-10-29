#!/usr/bin/env python3
"""Post-completion descriptive tallies of the frozen primary CSV artifacts.

No measured input selection, new rank, additional samples or inference. The
primary per-hit/per-seed/per-round records are preserved by the frozen analyzer.
"""
import collections
import csv
import json
from pathlib import Path


def brief(rows):
    ratios = [float(row['latency_ratio']) for row in rows]
    return dict(count=len(rows), outcomes=dict(collections.Counter(row['outcome'] for row in rows)),
                min_ratio=min(ratios), max_ratio=max(ratios))


def main():
    path = Path(__file__).resolve().parent / 'report-v1'
    with (path / 'pairs.csv').open() as source:
        rows = list(csv.DictReader(source))
    with (path / 'round-sensitivity.csv').open() as source:
        rounds = list(csv.DictReader(source))
    if len(rows) != 240 or len(rounds) != 120:
        raise ValueError('complete frozen primary output required')
    summary = dict(totals_are_descriptive_bookkeeping_not_independent_repetitions=True,
                   all=brief(rows),
                   by_batch={b: brief([r for r in rows if r['batch'] == b])
                             for b in ('1', '3', '31', '4096')},
                   per_size_batch_mode=[],
                   round_direction_changes=[r for r in rounds if r['direction_changed'] == 'True'],
                   round_ratio_ranges=[])
    for key in sorted({(r['n_exponent'], r['batch'], r['mode']) for r in rows}):
        group = [r for r in rows if (r['n_exponent'], r['batch'], r['mode']) == key]
        summary['per_size_batch_mode'].append(dict(zip(('n_exponent', 'batch', 'mode'), key), **brief(group)))
    for batch in ('1', '3', '31', '4096'):
        group = [r for r in rounds if r['batch'] == batch]
        ratios = [float(r['ratio_of_ratios_round2_over_round1']) for r in group]
        summary['round_ratio_ranges'].append(dict(batch=batch, comparisons=len(group),
            direction_changes=sum(r['direction_changed'] == 'True' for r in group),
            min_ratio_of_ratios=min(ratios), max_ratio_of_ratios=max(ratios)))
    print(json.dumps(summary, indent=2))


if __name__ == '__main__':
    main()
