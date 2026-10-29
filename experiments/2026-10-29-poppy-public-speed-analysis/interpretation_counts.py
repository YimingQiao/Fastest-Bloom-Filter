#!/usr/bin/env python3
"""Post-completion descriptive bookkeeping; does not change frozen rankings."""
import csv
import json
from collections import Counter
from pathlib import Path

HERE=Path(__file__).resolve().parent
report=HERE/'report-v1'
contrasts=list(csv.DictReader((report/'contrasts.csv').open()))
quality=list(csv.DictReader((report/'quality.csv').open()))
groups=[]
for category in ['query','build']:
    pairs=[('poppy_external',g)for g in ['retained_external','production_native','optional_native_range','optional_native_k12','all_native_composite']]
    pairs += [(g,'all_external_composite')for g in ['production_native','optional_native_range','optional_native_k12','all_native_composite']]
    for numerator,denominator in pairs:
        rows=[r for r in contrasts if r['category']==category and r['numerator_group']==numerator and r['denominator_group']==denominator]
        counts=Counter(r['outcome']for r in rows)
        ratios=[float(r['latency_ratio'])for r in rows if r['latency_ratio']]
        groups.append(dict(category=category,numerator=numerator,denominator=denominator,
            counts={k:counts[k]for k in ['win','loss','tie','no_comparable']},
            ratio_min=min(ratios),ratio_max=max(ratios)))
native_losses=[]
for category in ['query','build']:
    rows=[r for r in contrasts if r['category']==category and r['numerator_group']=='production_native' and r['denominator_group']=='all_external_composite' and r['outcome']=='loss']
    native_losses.append(dict(category=category,count=len(rows),rival_filters=dict(Counter(json.loads(r['denominator_winners'])[0]['filter']for r in rows))))
qualification=[]
for n in [65536,33554432]:
    for cap in [16,24,32]:
        for target in [.01,.001,.0001]:
            points=[r['configuration_id']for r in quality if r['owner']=='poppy_external' and int(r['keys'])==n and int(r['actual_bytes'])*8<=n*cap and float(r['wilson95_upper'])<=target]
            qualification.append(dict(keys=n,cap_bpk=cap,target=target,qualified_points=points))
strict24=[r for r in contrasts if r['category']=='query' and r['numerator_group']=='all_native_composite' and r['denominator_group']=='all_external_composite' and r['cap_bpk']=='24' and r['target_fpr']=='0.0001']
result=dict(scope='Descriptive counts of complete frozen nested views; repeated inputs and controls are not independent samples.',
            groups=groups,production_losses=native_losses,poppy_qualification=qualification,
            strict24_composite_query=dict(Counter(r['outcome']for r in strict24)))
(report/'outcome-bookkeeping.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(dict(production_losses=native_losses,strict24=result['strict24_composite_query'])))
