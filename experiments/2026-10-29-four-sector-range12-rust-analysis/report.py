#!/usr/bin/env python3
"""Render the complete measured sidecar, preserving every selected loss."""
import collections,csv,json
from pathlib import Path
HERE=Path(__file__).resolve().parent;DATA=HERE/'report'
def csvrows(name):return list(csv.DictReader((DATA/(name+'.csv')).open()))
def metric_title(metric):return {'lookup_ns':'Staged prehashed','hash_lookup_ns':'Staged hash+query','inline_lookup_ns':'Visible public-single','inline_hash_lookup_ns':'Visible fused hash+single','insert_ns':'Insert','allocate_insert_ns':'Allocate+insert','hash_insert_ns':'Hash+insert','allocate_hash_insert_ns':'Allocate+hash+insert'}[metric]
def main():
    meta=json.loads((DATA/'metadata.json').read_text());q=json.loads((DATA/'quality.json').read_text());views=json.loads((DATA/'views.json').read_text());pairs=csvrows('pairs');conditions=csvrows('conditions')
    counts=collections.Counter(x['unconditional_outcome']for x in pairs)
    out=['# Fixed fresh Rust K12 public-API confirmation','',
      'The frozen Rust K12 implementation passed the fixed 0.01% quality gate at 24 bits/key on all three fresh seeds and has a useful staged bulk-query niche. It does **not** replace the existing Range filter generally: singleton/visible queries and all four construction measures lose to equal-byte Range, and the large 4096 batch also loses. The C++ wins do not transfer to every Rust API.', '',
      f'The complete 36-command/108-row measurement is committed at `{meta["raw_commit"]}`; the executed source is `{meta["source_commit"]}`. All command/raw/aggregate/source/binary/order/phase/trial and quality guards passed before analysis. There was one measurement session, 36 separate process invocations, and no rerun, additional seed, calibration extension or post-data selection.', '',
      '## Equal 24 bits/key primary comparison','',
      'The following ratios are **Range latency / K12 latency**, shown as the minimum–maximum of the three paired fresh-seed ratios. Values above 1 favor K12. These two staged contracts use their specified batch; the visible contracts below are whole-array public-single loops regardless of batch tag. All APIs in each primary comparison share a process and the same actual payload bytes.','',
      '| Keys | Batch | Prehashed ratio | Hash+query ratio | Three-seed outcome |','|---:|---:|---:|---:|---|']
    for n in [65536,33554432]:
        for batch in [1,31,4096]:
            selected=[]
            for metric in ['lookup_ns','hash_lookup_ns']:
                selected.append(next(x for x in conditions if int(x['keys'])==n and int(x['batch'])==batch and x['metric']==metric and x['rival']=='Split64RangeBloomFilter'and int(x['rival_bytes'])*8==24*n))
            ranges=[f'{float(x["ratio_min"]):.4f}–{float(x["ratio_max"]):.4f}×'for x in selected]
            outcome='K12 wins both on all 3'if all(int(x['wins'])==3 for x in selected)else'K12 loses both on all 3'if all(int(x['losses'])==3 for x in selected)else'mixed; retain individual seeds'
            out.append(f'| {n:,} | {batch} | {ranges[0]} | {ranges[1]} | {outcome} |')
    out += ['',
      'The staged bulk advantage is narrow in some cells: large batch 31 hash+query is 1.0159–1.0248×, and small batch 31 hash+query is 1.0350–1.0467×. Small batch 4096 is stronger (prehashed 1.3820–1.4049×, hash+query 1.2700–1.2829×). Large4096 instead loses by roughly 0.7–2.6% depending on contract/seed. Three seeds and eight within-process query repetitions do not establish statistical significance for the narrow margins.', '',
      'The visible prehashed API loses all 18 comparisons to Range (ratio 0.3994–0.4419×), and visible fused hash+single loses all 18 (0.3548–0.4376×). All 72 construction comparisons lose; insert ratio is 0.5033–0.8544× and the other boundaries are retained below. Across all 144 primary metric/seed views, K12 wins 18 and loses 126 to the best retained project filter, here equal-byte Range.', '',
      'K12 beats the selected Fastbloom public K7@24 control in every 144 primary metric/seed view. K7 was derived from the complete prior 336-row bounded-K training union across all 96 strict24/32 views; it is **not** a fresh measurement of every K or proof against all Rust libraries. The complete SBBF/Bloomsday/default/fixed-K training eligibility evidence and old losses remain in that immutable training archive.', '',
      '## All main-policy leader comparisons','',
      'Each cell reports K12 wins/losses/ties against the independently selected fastest eligible leader in that owner set, then the three-seed/batch ratio range. There are 18 comparisons per row/column (two sizes×three batches×three seeds). All 12 allocation gates pass, so no row is silently removed. Cap 32 admits the measured 24-bit allocations as well as 32-bit extras.','',
      '| Contract | Cap24 external | Cap24 retained project | Cap32 external | Cap32 retained project |','|---|---|---|---|---|']
    for metric in ['lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns','insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:
        cells=[]
        for cap,owner in [(24,'external'),(24,'retained_project'),(32,'external'),(32,'retained_project')]:
            found=[v['leaders']['main_all_three'][owner]for v in views if v['cap_bpk']==cap and v['metric']==metric];valid=[v for v in found if v and v['comparable']];c=collections.Counter(x['outcome']for x in valid);ratios=[x['ratio_to_candidate']for x in valid]
            cells.append(f'{c["win"]}/{c["loss"]}/{c["tie"]}; {min(ratios):.3f}–{max(ratios):.3f}×'if ratios else'no comparable rival')
        out.append('| '+metric_title(metric)+' | '+' | '.join(cells)+' |')
    out += ['',
      'The secondary cap 32 comparisons include extra 32-bit allocations measured in a different process from K12@24; they are not same-process or equal-byte comparisons. K12 wins only 6/144 views against the best retained project leader there, with 138 losses. Against the best external leader it wins 59 and loses 85. All four owner classes, current-seed and unconditional leaders, ties and allocation alternatives remain in the machine-readable tables; this report does not promote secondary winners into a general claim.', '',
      '## Independent quality','',
      'Each API/allocation/size has three separate 67,108,864-negative calibration streams. Repeated batch/mode observations reuse the same construction and denominator only after exact semantic equality; they are not pooled. Main eligibility requires **each** seed’s two-sided 95% Wilson upper endpoint to be at most 0.01%. These pointwise intervals are finite-sample evidence, not a simultaneous guarantee for all future workloads.', '',
      '| API | Keys | Actual bits/key | Worst separate upper bound | All3 pass |','|---|---:|---:|---:|---|']
    for g in q['all_three_seed_gates']:
        out.append(f'| {g["filter"]} | {g["keys"]:,} | {g["filter_bytes"]*8/g["keys"]:g} | {g["worst_wilson95_high"]*100:.7f}% | {g["all_three_seeds_pass"]} |')
    out += ['',
      'K12’s worst endpoint is 0.0092754% at 65,536 keys and 0.0095440% at 33,554,432 keys. Both pass; no quality gate was relaxed and no sample was extended. The historical K12@16 failures and prior broader training losses remain applicable scope limitations.', '',
      '## Public API and ordering limits','',
      'The normal linked binary SHA256 is `dc6864c5cfb5324e4689e677705189fa5758be037530189a39e2bffafed2251e`. Its visible K12 loops call the unchanged scalar helper per key; the caller has six saved registers and a 72-byte frame, and the helper has five saved registers plus bounds checks. Batch paths retain runtime SIMD and scalar/remainder routing. These costs were disclosed before measurement. The poor singleton/visible results are consistent with that codegen hypothesis but do not isolate causality: a separate unchanged-mapping hint experiment must keep this exact implementation as its baseline.', '',
      'The three primary seed positions are first/middle/last at both sizes, and all 48 order-stratum summaries are retained. There is no complete pairwise or secondary-position balance claim. Query four-mode schedules balance eight repetitions; construction keeps the old four fixed-order boundaries and medians only. No build dispersion or cross-language speed ranking is inferred. CPU3 was pinned under an actual inherited socket1 flock, with no NUMA policy set.', '',
      '## Complete outputs','',
      f'- [720 named paired outcomes](report/pairs.csv): {counts["win"]} wins, {counts["loss"]} losses, {counts["tie"]} ties, all comparable under the fixed quality policy.',
      '- [240 three-seed conditions](report/conditions.csv), retaining each ratio and order position.',
      '- [288 nested views](report/views.json) and [1728 allocation alternatives](report/alternatives.csv), with all-three/current/unconditional policies.',
      '- [36 unpooled quality records and 12 all-seed gates](report/quality.json).',
      '- [48 primary-position strata](report/order_strata.csv) and [216 same-row API ratios](report/api_ratios.csv).',
      '- [Replay/provenance metadata](report/metadata.json) and [pre-data rules](../2026-10-29-four-sector-range12-rust-screen/screening/ANALYSIS_RULES.md).','']
    (HERE/'REPORT.md').write_text('\n'.join(out))
if __name__=='__main__':main()
