#!/usr/bin/env python3
"""Post-completion presentation of the frozen analysis; no new ranking rule."""
import json
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE / 'report-v1'
METRICS = ['raw_batched_public', 'raw_visible_public', 'raw_insert',
           'allocate_filter_and_scratch_raw_insert']
LABELS = dict(zip(METRICS, ['Raw batched public', 'Raw visible public',
                          'Raw insert', 'Allocate filter + scratch + raw insert']))
OWNERS = ['production_native', 'optional_native_range', 'optional_native_k12',
          'retained_external', 'new_raw8_external', 'all_native', 'all_external']


def read(name):
    return json.loads((OUT / (name + '.json')).read_text())


def outcome(rival, candidate):
    if rival is None or candidate is None:
        return 'NC'
    return 'W' if rival > candidate else 'L' if rival < candidate else 'T'


def ids(leader):
    return ', '.join(leader['configuration_ids']) or '—'


def number(value):
    return '—' if value is None else f'{value:.6f}'


def compact(values):
    values = sorted(values)
    if not values:
        return 'none'
    runs = []
    start = last = values[0]
    for value in values[1:]:
        if value == last + 1:
            last = value
        else:
            runs.append(str(start) if start == last else f'{start}–{last}')
            start = last = value
    runs.append(str(start) if start == last else f'{start}–{last}')
    return ', '.join(runs)


def main():
    views, quality, counts, provenance = map(read, ['views', 'quality', 'counts', 'provenance'])
    assert provenance['raw_commit'] == 'ff572807b0444a76044cba4c5170fb6a57189ea2'
    assert provenance['loader_commit'] == 'c30592d5eaf6b0294e869137edfcced043ab7002'
    assert len(views) == 216 and len(quality) == 262 and counts['rows'] == 786
    lines = ['# Complete raw8 public-API training screen', '',
        'The new fastbloom-rs 0.5.10 raw-byte API has **0 wins, 96 losses and 12 no-comparable views** against the retained external envelope in each of the query and build classes. The same counts hold against all native and all retained implementations. This is a seed 42 training result within this fixed panel, not a claim about every workload or library.', '',
        'All 18 original processes completed successfully in session 98863, without a retry or resumed measurement. The original 786 rows, 262 calibration sources and 524 strict reuse rows were committed before the frozen analysis ran. Analysis session 39150 also exited 0. Raw execution used CPU 2 and explicit NUMA node 0 binding; the correctness proof used CPU 3. No older latency was normalized or imported.', '',
        '| Coverage | Count |', '|---|---:|',
        '| Catalog geometries / new fastbloom-rs K1–K24 geometries | 262 / 144 |',
        '| Rows / measured processes | 786 / 18 |',
        '| Query views / build views | 108 / 108 |',
        '| All alternatives / new raw8 alternatives | 28,296 / 15,552 |',
        '| Actual metric trial vectors / original samples | 3,144 / 25,152 |',
        '| API comparisons / Fastbloom 0.17 fixed-default comparisons | 786 / 864 |',
        '| Quality API records / groups after known-alias checks | 262 / 260 |', '',
        '## Four separate contracts', '',
        'Every filter receives the same original raw-u64 key streams. Direct fastbloom-rs uses the public byte-slice API on little-endian eight-byte keys; its upstream hashing and short-circuit membership work remain inside the raw operation. Common-prehash APIs pay the common hash inside each measured raw operation. There is no artificial identity-copy phase. The two query contracts remain separate: the visible loop exposes public singleton calls to the optimizer, while the batched path uses the public bulk opportunity or the direct public per-key loop.', '',
        'Insertion uses a fixed 4096-key chunk, chosen independently of query batches 1/31/4096. `raw_insert` starts after filter and scratch readiness. `allocate_filter_and_scratch_raw_insert` starts before both required scratch allocation/initialization and filter construction, then includes raw insertion. Common-hash build scratch is 32 KiB; direct raw8 scratch is 0. Build scratch is dropped before query. Common-hash query scratch is 8/248/32768 bytes for batches 1/31/4096; direct raw8 scratch is 0. Caps apply to actual filter payload bytes, with caller scratch reported separately. Thus equal payload caps do not imply equal total process memory.', '',
        'All four metrics retain eight samples, their medians, minima and maxima. Output poisoning is outside every timed query and is followed by full output/guard validation. Query phase order uses the frozen AB/BA/BA/AB schedule twice. Row order is one seeded training permutation; build measurements are not an independently balanced order experiment. Batch labels on the visible whole-array loop do not change that loop contract.', '',
        '## New raw8 baseline versus retained external leaders', '',
        'Each row below covers 54 nested views. The ratio is retained-external latency divided by new-raw8 latency; greater than 1 favors the new baseline. Every smaller actual allocation competes under the cap. No-comparable cases are the six size/batch combinations at 16 bpk and 0.01% FPR for each metric; they are not counted as speed losses.', '',
        '| Metric | W / L / T / NC | Rival/new ratio range |', '|---|---:|---:|']
    for metric in METRICS:
        group = [v for v in views if v['metric'] == metric]
        c = Counter(v['new_vs_retained_external']['outcome'] for v in group)
        ratios = [v['new_vs_retained_external']['ratio'] for v in group if v['new_vs_retained_external']['ratio'] is not None]
        lines.append(f'| {LABELS[metric]} | {c["win"]} / {c["loss"]} / {c["tie"]} / {c["no_comparable"]} | {min(ratios):.6f}–{max(ratios):.6f} |')
    lines += ['', '## Native counterexamples remain', '',
        'These descriptive counts read the already-selected per-metric minima; they do not select a new candidate. Each owner class is compared with all registered external APIs. Optional Range and K12 are not silently merged into production. All 16 query and 9 build losses of the combined native envelope are to Bloomsday; the exact cases and latencies are in [NATIVE_LOSSES.md](NATIVE_LOSSES.md).', '',
        '| Native owner | Class | W / L / T / NC |', '|---|---|---:|']
    for owner in ['production_native', 'optional_native_range', 'optional_native_k12', 'all_native']:
        for kind in ['query', 'build']:
            c = Counter(outcome(v['leaders']['all_external']['latency_ns'], v['leaders'][owner]['latency_ns']) for v in views if v['metric_class'] == kind)
            lines.append(f'| {owner} | {kind} | {c["W"]} / {c["L"]} / {c["T"]} / {c["NC"]} |')
    lines += ['', 'At the strict 24 bpk/0.01% slice, the retained external leader is Fastbloom 0.17 public K7 in all 24 size/batch/metric views. Native Range wins 21 of those views and optional K12 wins the three batched-query views at small batch 31, small batch 4096 and large batch 31. This is an allocation niche in the current raw contract. It does not erase their losses at other caps or against other native APIs.', '',
        '## Quality is unpooled and finite', '',
        'Each construction has exactly 2^24 absent queries, collected only at query batch 1. These negatives are disjoint from the inserted and mixed-query domains, not mutually disjoint across API records; implementations intentionally share input streams. Batches 31/4096 reuse the result only after the frozen geometry/raw-input/full-mixed-output identity checks. The only collapsed aliases are Fastbloom 0.17 default at 16 bpk and K11 at the two sizes. The 260 groups are not a proof that all other mappings are pairwise distinct or independent. Pointwise two-sided 95% Wilson upper bounds determine this screen\'s gates; there is no multiple-comparison guarantee and no cross-configuration or cross-batch pooling.', '',
        '| New raw8 size | Actual bpk | K passing 1% | K passing 0.1% | K passing 0.01% |', '|---:|---:|---|---|---|']
    for n in [65536, 33554432]:
        for bpk in [16, 24, 32]:
            group = [q for q in quality if q['owner'] == 'new_raw8_external' and q['keys'] == n and q['budget_bpk'] == bpk]
            assert len(group) == 24 and all(q['actual_bytes'] * 8 == n * bpk for q in group)
            cells = [compact(int(q['filter'].rsplit('K', 1)[1]) for q in group if q['wilson_high'] <= t) for t in [.01, .001, .0001]]
            lines.append(f'| {n} | {bpk} | ' + ' | '.join(cells) + ' |')
    lines += ['', 'All 144 new configurations remain in the raw data and alternatives, including every quality failure. At actual 24 bpk, both native Range and K12 pass 0.01% at both sizes in this seed; their Wilson upper percentages are approximately 0.009509%/0.009209% and 0.009124%/0.009344%, respectively. K12 at 16 bpk fails 0.1% at both sizes. A finite upper-bound miss is not permanent algorithmic disqualification, and near-target configurations require a later prespecified uniform confirmation rather than an adaptive extension here.', '',
        '## Complete evidence and limits', '',
        'The [216-view table](VIEWS.md) preserves every metric, size, batch, cap, target and all exact leader ties. [views.json](views.json) retains all five owner classes and four composite minima, nulls and all three new-baseline comparisons. [alternatives.json](alternatives.json) retains all 28,296 alternatives, actual bytes, scratch, quality gates, eight samples and losses. [quality.json](quality.json), [api_ratios.json](api_ratios.json) and [fixed_default_ratios.json](fixed_default_ratios.json) retain the complete corresponding records. Fixed/default speed wins do not imply quality qualification.', '',
        'This is one seen seed, one training round and 18 separately allocated processes on one machine. Ratios are descriptive median comparisons, not significance tests. The cap/threshold views reuse measurements and are not independent observations. Selection across requested allocations can cross process boundaries. Public compiler decisions, including outlined singleton helpers, remain part of the measured APIs; the report does not infer their causal contribution.', '',
        'Poppy is absent from this binary. Both natural public byte8 and typed-u64 forms for the separately frozen 14-constructor shortlist remain required future controls, with 28 new, separate quality records. The historical Poppy shortlist is not an exhaustive natural-API search. No old Poppy timing or FPR is transferred, and no all-library leadership or fresh-seed claim follows from this screen.', '',
        f'Raw commit: `{provenance["raw_commit"]}`. Producer: `{provenance["producer_commit"]}`. Frozen calculation: `{provenance["analysis_commit"]}`. Loader: `{provenance["loader_commit"]}`. See [provenance.json](provenance.json) and [actual analysis outcome](../analysis-v1-outcome.json).', '']
    (OUT / 'REPORT.md').write_text('\n'.join(lines))

    table = ['# All 216 frozen nested views', '',
        'Latencies are median ns/key. Owner abbreviations: P=production, R=optional Range, K=optional K12, E=retained external, N=new raw8 external. Every exact tie is retained. Full bytes, trials and alternatives remain in the JSON artifacts. Ratio is retained/new; greater than 1 favors new.', '',
        '| n | batch | cap bpk | FPR % | metric | P | R | K | E | N | New vs retained |', '|---:|---:|---:|---:|---|---|---|---|---|---|---|']
    losses = ['# All combined-native losses to the external envelope', '',
        'These 25 rows preserve all 16 query and 9 build losses. Ratio is external/native, so less than 1 means native is slower. No cap 16/0.01% no-comparable view is relabeled as a loss.', '',
        '| n | batch | cap bpk | FPR % | metric | Native IDs | Native ns | External IDs | External ns | External/native |', '|---:|---:|---:|---:|---|---|---:|---|---:|---:|']
    loss_count = 0
    for v in views:
        prefix = [str(v['keys']), str(v['batch']), str(v['cap_bpk']), f'{v["fpr_fraction_cap"]*100:g}', v['metric']]
        cells = [f'{ids(v["leaders"][o])}<br>{number(v["leaders"][o]["latency_ns"])}' for o in OWNERS[:5]]
        compare = v['new_vs_retained']
        table.append('| ' + ' | '.join(prefix + cells + [compare['outcome'] + ' ' + number(compare['ratio'])]) + ' |')
        n, e = v['leaders']['all_native'], v['leaders']['all_external']
        if outcome(e['latency_ns'], n['latency_ns']) == 'L':
            loss_count += 1
            losses.append('| ' + ' | '.join(prefix + [ids(n), number(n['latency_ns']), ids(e), number(e['latency_ns']), number(e['latency_ns']/n['latency_ns'])]) + ' |')
    assert loss_count == 25
    (OUT / 'VIEWS.md').write_text('\n'.join(table) + '\n')
    (OUT / 'NATIVE_LOSSES.md').write_text('\n'.join(losses) + '\n')
    print('Rendered 216 existing views and 25 native counterexamples; no new ranking or measurement')


if __name__ == '__main__':
    main()
