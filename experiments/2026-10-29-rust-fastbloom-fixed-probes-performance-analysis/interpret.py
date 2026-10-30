#!/usr/bin/env python3
"""Describe complete336 tables; preserve every alternative and failure."""
from collections import Counter
import csv
import json
from pathlib import Path

HERE=Path(__file__).resolve().parent
REPORT=HERE/'report'
def read(name):
    with(REPORT/name).open()as stream:return list(csv.DictReader(stream))

def main():
    query=read('query-views.csv');build=read('build-views.csv')
    expansion=read('baseline-expansion.csv');controls=read('same-allocation-controls.csv')
    quality=json.loads((REPORT/'api-quality.json').read_text())
    assert len(query)==len(build)==len(expansion)==216 and len(controls)==96 and len(quality)==112
    metrics=['lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns']
    improved=[r for r in expansion if r['external_baseline_speedup'] and float(r['external_baseline_speedup'])>1]
    maximum=max(improved,key=lambda r:float(r['external_baseline_speedup']))
    niche=[r for r in query if r['cap_bpk']=='24' and r['fpr_ceiling']=='0.0001']
    assert len(niche)==24 and all(r['range_vs_external_outcome']=='win'for r in niche)
    assert all({x['filter']for x in json.loads(r['external_leaders'])}=={'Fastbloom017K7'}for r in niche)
    query_controls=Counter(r['outcome']for r in controls if r['metric']in metrics)
    build_controls=Counter(r['outcome']for r in controls if r['metric']not in metrics)
    four=[r for r in quality if r['filter']=='FourSectorBloomFilter'and r['actual_bpk']==16]
    summary=dict(scope='Descriptive completed seed42 training screen across two measurement sessions; no held-out/global claim.',
        query_views_improved_by_public_K=len(improved),largest_external_expansion=maximum,
        strict24_range_views=niche,range_same_allocation_query=dict(query_controls),range_same_allocation_build=dict(build_controls),
        four16_current_quality=four,
        query_class_counts={metric:{field:dict(Counter(r[field]for r in query if r['metric']==metric))
            for field in ['production_vs_external_outcome','range_vs_external_outcome']}for metric in metrics},
        build_class_counts={metric:{field:dict(Counter(r[field]for r in build if r['metric']==metric))
            for field in ['production_vs_external_outcome','range_vs_external_outcome']}for metric in sorted({r['metric']for r in build})})
    (REPORT/'interpretation.json').write_text(json.dumps(summary,indent=2)+'\n')
    lines=['# Interpretation of the complete bounded public-K screen','',
        f"The public K1…12 controls improve the best eligible external latency in {len(improved)}/216 nested query views relative to the original three external configurations measured in this same screen. The largest improvement is {float(maximum['external_baseline_speedup']):.3f}×: Fastbloom K7 versus automatic K17, large-size cap24/0.01%, visible prehashed query. This replaces default-only baseline claims; all automatic configurations remain in the tables.",'',
        'Range retains a specific opportunity at an actual24-bpk ceiling and0.01% FPR upper-bound target. Fastbloom K7 is the strongest eligible measured external allocation in all24 such query views. The following ratios compare those measured medians; they are not confidence intervals or independent replications.','',
        '| Keys | Query contract | Batch1 | Batch31 | Batch4096 |','|---:|---|---:|---:|---:|']
    for n in [65536,33554432]:
        for metric in metrics:
            rows=[next(r for r in niche if int(r['keys'])==n and r['metric']==metric and int(r['batch'])==batch)for batch in [1,31,4096]]
            lines.append(f"| {n} | {metric} | "+' | '.join(f"{float(r['range_vs_external']):.3f}×"for r in rows)+' |')
    lines+=['',
        'This is a capacity/quality niche among the three measured Rust external families and their bounded public configurations. It is not a claim against every published Bloom filter. At cap24 the power-of-two production layouts cannot use an intermediate24-bpk allocation, and their measured smaller layouts do not qualify for0.01%; the absence of a production winner in that view is not a latency loss. Fresh seeds are still needed before a production decision.','',
        f"Equal16/32-byte controls are unfavorable to Range: it loses {query_controls['loss']}/48 query and {build_controls['loss']}/48 build comparisons against production Split64; all {query_controls['win']} query and {build_controls['win']} build wins remain too. These controls do not assume identical address mapping or equal false-positive rates.",'',
        'For batch1 at the larger32-bpk ceiling and0.01% target, Bloomsday remains faster for staged prehashed, visible prehashed and fused visible queries at both tested sizes. The large batch1 staged hash+query contract differs: Range takes23.743ns versus27.452ns for Bloomsday. Bulk results also differ: at large batch4096, Range24 takes5.896ns for staged prehashed queries versus8.428ns for Bloomsday32. Its extra capacity can change the eligible winner, so the24-bpk result must not be generalized to32 bpk. The full tables also retain every low-K failure, native loss and empty eligibility view.','',
        'FourSector actual16-bpk passes the current small-size0.1% Wilson gate but misses it at the large size. The large sample has16,563 false positives in16,777,216 negatives and an upper bound0.10023738%; this is a finite-sample gate miss, not proof that true FPR exceeds0.1%. Earlier higher-resolution studies concerned separately identified constructions; their timings and counts are not imported or pooled here.','',
        'All four construction boundaries are reported independently. Each has36 production wins/6 losses/12 missing views against the expanded external set, and30 Range wins/18 losses/6 missing views. These repeated nested counts share measurements and are descriptive; build ordering is fixed and only build medians are available.','',
        'The complete evidence spans two measurement sessions. The first17 cases/316 rows are untouched after an unknown exit143; only the unfinished20-row case was restarted with the same frozen executable and parameters. Within-case public API comparisons share a process. Nested-cap alternatives can span case processes, and the final large/cap32/batch4096 case is from the resumed session. No earlier completed case was rerun or discarded.']
    (REPORT/'INTERPRETATION.md').write_text('\n'.join(lines)+'\n')
    print('PASS complete216-view interpretation, all24 strict24 views and96 equal-allocation controls; no data rerun')

if __name__=='__main__':main()
