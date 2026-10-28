#!/usr/bin/env python3
"""Render only the frozen fixed-comparison results; never select new leaders."""
import csv,json
from pathlib import Path
HERE=Path(__file__).resolve().parent
s=json.loads((HERE/'summary.json').read_text())
m=json.loads((HERE/'metadata.json').read_text())
config={c['geometry']['configuration_id']:c for c in s['configurations']}

def name(cid):
    if cid is None:return '—'
    g=config[cid]['geometry']
    return g['filter']+' @ '+format(8*int(g['filter_bytes'])/int(g['keys']),'.9g')+' bpk'

def ratios(pair):
    return ', '.join(format(x['candidate_over_external_latency'],'.4f') for x in pair['per_seed']) or '—'

flat=[]
for source in ('main_comparisons','frontier_comparisons'):
    for index,cell in enumerate(s[source]):
        for slot,pair in cell['pairs'].items():
            for seed in s['seeds']:
                entry=next((r for r in pair['per_seed'] if r['seed']==seed),{})
                flat.append(dict(source=source,comparison_index=index,keys=cell['keys'],metric=cell['metric'],memory_cap_bpk=cell['memory_cap_bpk'],
                                 fpr_ceiling=cell['fpr_ceiling'],candidate_slot=slot,seed=seed,status=pair['status'],
                                 candidate_configuration_id=pair['candidate_configuration_id'],external_configuration_id=pair['external_configuration_id'],
                                 candidate=name(pair['candidate_configuration_id']),external=name(pair['external_configuration_id']),
                                 candidate_ns=entry.get('candidate_ns'),external_ns=entry.get('external_ns'),
                                 candidate_over_external_latency=entry.get('candidate_over_external_latency'),
                                 candidate_quality_upper=entry.get('candidate_quality_upper'),external_quality_upper=entry.get('external_quality_upper'),
                                 both_quality_pass=entry.get('both_quality_pass'),timing_outcome=entry.get('timing_outcome')))
with(HERE/'fixed-comparisons.csv').open('w',newline='')as f:
    w=csv.DictWriter(f,fieldnames=list(flat[0]),lineterminator='\n');w.writeheader();w.writerows(flat)

flat=[]
for c in s['configurations']:
    g=c['geometry']
    for r in c['seeds']:
        flat.append({k:g[k] for k in ('configuration_id','calibration_identity','filter','implementation_origin','keys','filter_bytes','logical_bytes','geometry_kind','unit_count','effective_probes','probe_policy')}|
                    {k:r[k] for k in ('seed','probes','false_positives','observed_fpr','quality_upper','lookup_ns','hash_lookup_ns','result_checksum','mixed_false_positives')})
with(HERE/'configuration-seeds.csv').open('w',newline='')as f:
    w=csv.DictWriter(f,fieldnames=list(flat[0]),lineterminator='\n');w.writeheader();w.writerows(flat)

failures={}
for source in ('main_comparisons','frontier_comparisons'):
    for i,c in enumerate(s[source]):
        for slot,q in c['fixed_leader_quality'].items():
            if q is not None and not q['qualified_all_seeds']:
                key=(q['configuration_id'],c['fpr_ceiling'])
                if key not in failures:
                    cfg=config[q['configuration_id']]
                    failures[key]={'configuration_id':key[0],'filter':cfg['geometry']['filter'],'keys':int(cfg['geometry']['keys']),
                                   'filter_bytes':int(cfg['geometry']['filter_bytes']),'fpr_ceiling':key[1],
                                   'worst_pointwise_quality_upper':q['worst_pointwise_quality_upper'],
                                   'seeds':[{k:r[k] for k in ('seed','probes','false_positives','observed_fpr','quality_upper')} for r in cfg['seeds']],
                                   'affected_fixed_comparisons':[]}
                failures[key]['affected_fixed_comparisons'].append({'source':source,'index':i,'slot':slot,'memory_cap_bpk':c['memory_cap_bpk'],'metric':c['metric']})
(HERE/'quality-failures.json').write_text(json.dumps(list(failures.values()),indent=2)+'\n')

def main_cell(n,metric,cap,fpr):
    return next(c for c in s['main_comparisons'] if (c['keys'],c['metric'],c['memory_cap_bpk'],c['fpr_ceiling'])==(n,metric,cap,fpr))
strict=main_cell(2**25,'hash_lookup_ns',32,.0001)
loose=main_cell(2**25,'hash_lookup_ns',16,.01)
pure_loose=main_cell(2**25,'lookup_ns',16,.01)
lines=['# Fixed-capacity confirmation: mixed results retained','',
'All 39 workloads / 162 rows completed, with unchanged committed sources, dependency hashes, and all 15 parent binaries. The fixed 54-configuration subset ran on CPU3/socket1; training ran on CPU2. No cross-run latency ratio is used. This is confirmation of training-selected comparisons, not a new exhaustive ranking.','',
'- At 33,554,432 keys and a 32-bpk ceiling with 0.01% maximum FPR, the fixed production FastPattern32 hash+query comparison loses on two of three seeds. Candidate/external latency ratios are **'+ratios(strict['pairs']['production_native'])+'**.','- RangeSplit64 at exactly 24 bpk wins that same fixed strict comparison on all three seeds: **'+ratios(strict['pairs']['project_experiment'])+'** (4.33–6.65% lower latency). Its worst Wilson upper bound is **0.000099362116612808834**, only 0.000000637883387191166 below the 0.0001 ceiling. This narrow margin is not a universal quality guarantee.','- At the large loose 1% target, RangeSplit64 at 12 bpk wins hash+query on all seeds (**'+ratios(loose['pairs']['project_experiment'])+'**), but loses pure prehashed lookup on all seeds (**'+ratios(pure_loose['pairs']['project_experiment'])+'**). The production FastPattern16 hash+query ratios are **'+ratios(loose['pairs']['production_native'])+'**, including two losses.','- FourSector16 at 65,536 keys fails the fixed 0.1% quality gate on the first seed. Its fast timings remain descriptive; no alternate native filter replaces it. No other fixed training leader/target fails its all-seed quality gate.','',
'Ratios throughout are **candidate latency / external latency**, so values below one favor the candidate. Each ratio uses the medians of six balanced query trials from the same confirmation seed. Range candidates remain project experiments.','',
'## Strict large comparison: exact payload and calibration','',
'Each calibration uses 16,777,216 absent keys. BoostMulti64K8 uses 100,663,295 charged bytes; RangeSplit64 uses 100,663,296 bytes; production FastPattern uses 134,217,728 bytes. All fit the 32-bpk cap.','',
'| Seed | Configuration | False positives | Wilson upper | Hash+query ns/key |','|---|---|---:|---:|---:|']
for slot in ('external','production_native','project_experiment'):
    cid=strict['leaders'][slot]
    for r in config[cid]['seeds']:
        lines.append(f"| {r['seed']} | {name(cid)} | {r['false_positives']} | {r['quality_upper']:.17g} | {r['hash_lookup_ns']:.9f} |")
lines+=['','## Retained quality failure','','| Seed | FourSector16 false positives / probes | Wilson upper | Meets 0.001? |','|---|---:|---:|---|']
for failure in failures.values():
    for r in failure['seeds']:
        lines.append(f"| {r['seed']} | {r['false_positives']} / {r['probes']} | {r['quality_upper']:.17g} | {'yes' if r['quality_upper']<=failure['fpr_ceiling'] else '**no**'} |")
lines+=['','The single failing configuration/target appears in multiple main/frontier slots. Those repeated comparisons are not additional independent failures. API duplicates and seeds are never pooled: there are 144 distinct mapping/seed calibration records, each with its own 2^24 probes.','',
'## Every main fixed comparison','','Values in each cell follow the three fixed seed order listed above. `quality failure` means a timing advantage cannot establish a qualifying win. Null training slots remain null.','',
'| Keys | Mode | Cap bpk | FPR ceiling | Fixed external | Fixed production: ratios; status | Fixed experiment: ratios; status |','|---:|---|---:|---:|---|---|---|']
for c in s['main_comparisons']:
    entries=[]
    for slot in ('production_native','project_experiment'):
        pair=c['pairs'][slot]
        label={'qualified_fixed_pair':'qualified','quality_failure_no_replacement':'**quality failure**','no_fixed_training_pair':'no fixed pair'}[pair['status']]
        entries.append(name(c['leaders'][slot])+': '+ratios(pair)+'; '+label)
    lines.append(f"| {c['keys']} | {'prehashed' if c['metric']=='lookup_ns' else 'hash+query'} | {c['memory_cap_bpk']} | {100*c['fpr_ceiling']:g}% | {name(c['leaders']['external'])} | {entries[0]} | {entries[1]} |")
lines+=['','## Reproduction and scope','',
'- Source/plan commit: `'+m['source_commit']+'`; unchanged parent binary source: `'+m['parent_source_commit']+'`.','- Recorded UTC interval: `'+m['start_utc']+'` to `'+m['end_utc']+'`.','- 2^22 mixed queries, 50% intended hits, batch4096, six balanced phase repetitions; one validated complete build, zero ranked build repetitions.','- Worst pointwise two-sided95 Wilson upper bound across all three seeds determines quality. Bounds are not simultaneous guarantees over the selected grid.','- [summary.json](summary.json) retains all fixed main/frontier slots, trial vectors, nulls, seed losses, and calibration identities. [fixed-comparisons.csv](fixed-comparisons.csv) expands every fixed comparison per seed; overlapping main/frontier/project slots are labeled and must not be counted as independent trials.','- [configuration-seeds.csv](configuration-seeds.csv) retains all 162 configuration/seed records, including native controls; [quality-failures.json](quality-failures.json) deduplicates failed fixed leader/target gates.','- Frozen `../summarize.py` validated exact commands, merged/raw output equality, complete geometry/seed sets, committed source blobs and live dependencies/binaries. No seed, configuration, or failed leader was replaced.','- No global fastest-filter, untested workload, cross-language, or construction-performance claim follows from this subset.','']
(HERE/'RESULTS.md').write_text('\n'.join(lines))
print('Rendered all 24 main and 42 fixed frontier comparisons, 162 configuration/seed records, and',len(failures),'unique failed leader/target gate')
