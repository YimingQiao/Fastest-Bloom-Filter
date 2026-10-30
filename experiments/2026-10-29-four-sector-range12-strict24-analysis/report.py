#!/usr/bin/env python3
"""Render the sealed78 outcome without changing any measurement or selection."""
import json
from pathlib import Path
HERE=Path(__file__).resolve().parent
v=json.loads((HERE/'report/views.json').read_text());q=json.loads((HERE/'report/quality.json').read_text());m=json.loads((HERE/'report/metadata.json').read_text())
def ratio(values):return f'{min(values):.4f}–{max(values):.4f}×'
lines=['# Three-seed K12 strict24 confirmation','',
'K12@24 wins every measured primary comparison against the fastest selected external and retained project:24/24 per-seed size/batch/query-contract views. It also wins12/12 prespecified large-table cap32 secondary views while still using24 bits/key. All13 API geometries pass all three independent quality gates, so these wins do not rely on excluding a rival. All180 named rival pairs are wins; no tie, loss, quality exclusion or missing comparator occurred in this finite confirmation.','',
'The primary niche is two sizes (65,536 and33,554,432 inserted keys), batches31/4096, actual at-most24 bits/key and false-positive ceiling0.01%. Each fixed API/seed uses2^26 independent negatives and six balanced query trials. Three seeds were selected solely for disjoint raw input domains and K12 first/middle/last position among the primary five. Ratios below are rival latency / K12 latency, hence throughput ratios; ranges show all three seeds, not confidence intervals.','',
'## Primary actual24 results','',
'|Keys|Batch|Query contract|K12 ns/query range|Best external / K12|Range / K12|External winners across seeds|','|---:|---:|---|---:|---:|---:|---|']
for n in(1<<16,1<<25):
 for b in(31,4096):
  for metric in('lookup_ns','hash_lookup_ns'):
   group=[x for x in v if x['track']=='primary24'and x['quality_policy']=='all_three_seeds'and x['keys']==n and x['batch']==b and x['metric']==metric]
   times=[x['winners']['K12_experiment'][0]['latency_ns']for x in group];names=sorted({r['filter']for x in group for r in x['winners']['external']})
   lines.append(f"|{n:,}|{b}|{'Prehashed'if metric=='lookup_ns'else'Common hash + query'}|{min(times):.4f}–{max(times):.4f}|{ratio([x['K12_vs_external']['ratio']for x in group])}|{ratio([x['K12_vs_retained']['ratio']for x in group])}|{', '.join(names)}|")
lines+=['','The narrowest primary margin is the small-table batch31 common-hash path:1.01964–1.03253× over the optional native Range control. Large-table batch4096 common-hash gains are1.03628–1.04991×. These small margins remain explicit; the experiment does not provide a timing significance test.','',
'## Prespecified large-table cap32 secondary','',
'These views include all primary24 allocations plus BoostMulti32K8@28, FastPattern@32 and FourSector@32. The extra geometries ran in separate processes. Primary K12 measurements are reused; this is not an additional independent experiment or a claim that every allocation shared a process.','',
'|Batch|Query contract|Best external / K12|Best retained project / K12|Retained winners across seeds|','|---:|---|---:|---:|---|']
for b in(31,4096):
 for metric in('lookup_ns','hash_lookup_ns'):
  group=[x for x in v if x['track']=='secondary_large_cap32'and x['quality_policy']=='all_three_seeds'and x['batch']==b and x['metric']==metric];names=sorted({r['filter']for x in group for r in x['best_retained']})
  lines.append(f"|{b}|{'Prehashed'if metric=='lookup_ns'else'Common hash + query'}|{ratio([x['K12_vs_external']['ratio']for x in group])}|{ratio([x['K12_vs_retained']['ratio']for x in group])}|{', '.join(names)}|")
lines+=['','The smallest secondary margin is1.01628–1.02557× versus FourSector@32 on the large batch31 common-hash path.','',
'## Independent quality gates','',
'Every API/allocation passes all three separately calculated two-sided95% Wilson upper endpoints at0.01%. No calibration extension occurred. The39 API/geometry/seed records reduce only to33 proven mapping records: Range/Fixed64 aliases and repeated batches are not pooled or counted as new negatives. The table retains each API and its actual backing allocation.','',
'|API|Keys|Requested bpk|Actual backing bytes|Worst three-seed Wilson upper, %|All3 pass|','|---|---:|---:|---:|---:|---|']
for row in q['all_seed_gates']:lines.append(f"|{row['filter']}|{row['keys']:,}|{row['requested_bpk']}|{row['filter_bytes']:,}|{row['worst_wilson95_high']*100:.8f}|{row['all_three_seeds_pass']}|")
lines+=['','K12 worst upper bounds are0.00929051% (small) and0.00952436% (large). These are finite-sample, pointwise intervals, not simultaneous guarantees across all filters and constructions. All-seed, current-seed and unconditional-speed leader views coincide in this run because every gate passes.','',
'## Limits and next step','',
'The result supports an isolated Rust port and a possible optional strict24 bulk configuration. It does not change the default layout and does not establish singleton, construction, multithreaded, every-capacity or global leadership. Rivals are the prespecified union of leaders from the complete earlier296-row training screen, not every unmeasured external configuration.','',
'The earlier training failures remain: K12@16 failed the0.1% and0.01% quality gates, and across the wider training views K12 had30 external losses and44 retained-project losses. Those results are not overwritten by this narrower successful confirmation. See [the original interpretation](../2026-10-29-four-sector-range12-analysis/INTERPRETATION.md).','',
'First/middle/last strata and every named pair are retained in `report/named-pairs.csv` and `report/paired-conditions.json`. Each stratum contains one seed; order and seed effects cannot be separated causally. Primary views share one same-process five-API workload, but no absolute five-position or all-rival pairwise balance is claimed.','',
'## Reproduction and evidence','',
f"- Fixed source: `{m['source_commit']}`; native binary `9aceea39f8f57564409806f911ddcf2ec6c17ff623a5132acbb609b11ad05149`.",
f"- Complete raw51-file archive committed before analysis: `{m['raw_commit']}`; descriptor SHA `{m['raw_archive_sha256']}`.",
'- All24 commands/78 rows were replay-audited for exact order, geometry, source/binary identity, balanced phases, six-trial medians/extrema and raw/aggregate equality. CPU3/socket1 whole flock held; no explicit NUMA memory binding claim.',
'- Separate analysis emits108 views (36 conditions × three eligibility policies),648 alternatives,180 named pairs and60 three-seed pair conditions; six synthetic guards pass. Initial analysis-only syntax failure is retained in `offline-v1.txt` and corrected before reading fresh measurements.',
'- No compiler or filter was executed by the analysis. The full numerical records and all quality identities are in `report/`.','']
(HERE/'REPORT.md').write_text('\n'.join(lines))
