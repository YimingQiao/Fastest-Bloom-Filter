#!/usr/bin/env python3
"""Retain every internal timing ratio and cross-batch semantic check."""
import csv,hashlib,json,math,statistics
from pathlib import Path
H=Path(__file__).resolve().parent
P=H/'timing-full'
rows=list(csv.DictReader((P/'results.csv').open()))
summary=json.loads((P/'summary.json').read_text())
assert len(rows)==144 and summary['all_split64_checksums_bytes_fp_equal']
by_filter={}
for r in rows:by_filter.setdefault(tuple(r[k] for k in ('filter','keys','requested_bpk')),[]).append(r)
fields=('filter_bytes','actual_bpk','present_queries','absent_queries','false_positives','result_checksum')
assert len(by_filter)==24
for key,group in by_filter.items():
    assert len(group)==6 and {int(r['batch']) for r in group}=={1,3,4,8,31,4096},key
    for field in fields:assert len({r[field] for r in group})==1,(key,field)
comparisons=[r for r in summary['comparisons'] if r['filter']!='Split64Original']
assert len(comparisons)==192
policies=sorted({r['filter'] for r in comparisons})
aggregates=[]
for policy in policies:
    for metric in ('lookup_ns','hash_lookup_ns'):
        group=[r for r in comparisons if r['filter']==policy and r['metric']==metric]
        values=[r['candidate_over_original_latency'] for r in group]
        assert len(values)==24
        worst=max(group,key=lambda r:r['candidate_over_original_latency'])
        best=min(group,key=lambda r:r['candidate_over_original_latency'])
        aggregates.append(dict(filter=policy,metric=metric,cases=24,geomean_latency_ratio=math.exp(statistics.mean(math.log(x) for x in values)),
                               faster_cases=sum(x<1 for x in values),slower_cases=sum(x>1 for x in values),min_latency_ratio=min(values),max_latency_ratio=max(values),best_case=best,worst_case=worst))
losses=[r for r in comparisons if r['candidate_over_original_latency']>1]
with (P/'losses.csv').open('w',newline='') as stream:
    writer=csv.DictWriter(stream,fieldnames=list(comparisons[0]),lineterminator='\n');writer.writeheader();writer.writerows(losses)
result=dict(scope='One seed42 exploratory internal screen, CPU3, Clang, same binary and exact Split64 bitmap. No held-out or strongest-filter claim.',
            ratio='candidate/original latency; lower is faster. Geometric means describe equally weighted test cases, not a deployment workload.',
            source_and_binary_unchanged=summary['all_frozen_inputs_and_binaries_unchanged'],
            cross_batch_semantic_groups=24,cross_batch_fields_equal=list(fields),aggregates=aggregates,
            all_positive_regressions_retained=len(losses),comparisons=comparisons,
            results_sha256=hashlib.sha256((P/'results.csv').read_bytes()).hexdigest(),analysis_script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
(P/'report.json').write_text(json.dumps(result,indent=2)+'\n')
lines=['# Split64 BITALG/KTEST internal training screen','','All 24 workloads/144 rows completed. Every Split64 policy matches original bitmap bytes, output checksum and false-positive count in every workload. Each of 24 filter/size/allocation groups also matches those fields across all six batches. Frozen inputs/binaries were verified before and after.','','This is seed42, hit50, q2^22, five repetitions, CPU3/Clang, with all construction inputs and no independent calibration. Query-only equivalence is established by the independent oracle and exact unchanged bitmap. FastPattern remains a separate context row; it is not an accuracy-equivalent Split64 control. No cross-compiler/socket/API ranking is made.','','All ratios below are candidate/original latency; lower is faster. Every case and both metrics are retained. Aggregate means weight test cases equally and are descriptive, not confidence bounds.','','| Policy | Metric | Geomean ratio | Faster /24 | Slower /24 | Minimum | Maximum |','|---|---|---:|---:|---:|---:|---:|']
for r in aggregates:lines.append(f"| {r['filter']} | {r['metric']} | {r['geomean_latency_ratio']:.4f} | {r['faster_cases']} | {r['slower_cases']} | {r['min_latency_ratio']:.4f} | {r['max_latency_ratio']:.4f} |")
for metric in ('lookup_ns','hash_lookup_ns'):
    lines+=['',f'## {metric}','','| Keys | Actual bpk | Batch | Original ns | V1 hybrid | V1 narrow | V1 wide | Hybrid KTEST |','|---:|---:|---:|---:|---:|---:|---:|---:|']
    keys=sorted({(r['keys'],r['actual_bpk'],r['batch']) for r in comparisons})
    for n,bpk,batch in keys:
        group={r['filter']:r for r in comparisons if (r['keys'],r['actual_bpk'],r['batch'],r['metric'])==(n,bpk,batch,metric)}
        order=('Split64BitShuffleHybrid','Split64BitShuffleNarrow','Split64BitShuffleWide','Split64BitShuffleHybridKtest')
        first=group[order[0]]
        lines.append('| '+ ' | '.join([f'{n:,}',f'{bpk:g}',str(batch),f"{first['original_ns']:.4f}",*[f"{group[name]['candidate_over_original_latency']:.4f}" for name in order]])+' |')
lines+=['','`results.csv` contains all original timings, ranges, allocations and query counts. `comparisons.csv` includes original self-controls; `losses.csv` includes every ratio greater than one without suppressing small differences. `report.json` retains extrema and their workloads. No production promotion or fresh-seed conclusion follows from this initial screen.','']
(P/'README.md').write_text('\n'.join(lines))
print(json.dumps({'aggregates':aggregates,'losses':len(losses),'all_cross_batch_semantics_match':True},indent=2))
