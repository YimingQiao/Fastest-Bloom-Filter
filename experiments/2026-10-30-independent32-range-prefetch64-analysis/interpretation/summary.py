"""Descriptive complete-report summaries only; no producer or ranker invocation."""
import collections
import json
from pathlib import Path
HERE=Path(__file__).resolve().parent
REPORT=HERE.parent/'report-v1'
def read(name):return json.loads((REPORT/(name+'.json')).read_text())
def stats(rows):
    values=[p['latency_ratio'] for p in rows if p['latency_ratio'] is not None]
    return dict(comparisons=len(rows),outcomes=dict(collections.Counter(p['outcome'] for p in rows)),
        latency_ratio_min=min(values) if values else None,latency_ratio_max=max(values) if values else None)
def round_flips(rows,group_field):
    cells={}
    for p in rows:
        key=(p['keys'],p['seed'],p['batch'],p['mode'],p[group_field])
        assert p['round'] not in cells.setdefault(key,{})
        cells[key][p['round']]=p
    output=[]
    for key,rounds in sorted(cells.items()):
        assert set(rounds)=={1,2}
        a,b=rounds[1],rounds[2]
        output.append(dict(keys=key[0],seed=key[1],batch=key[2],mode=key[3],comparison_group=key[4],
            round1_case_index=a['case_index'],round2_case_index=b['case_index'],
            round1_rival=a['rival_point_id'],round2_rival=b['rival_point_id'],
            round1_latency_ratio=a['latency_ratio'],round2_latency_ratio=b['latency_ratio'],
            round1_outcome=a['outcome'],round2_outcome=b['outcome'],
            outcome_changed=a['outcome']!=b['outcome'],rival_changed=a['rival_point_id']!=b['rival_point_id']))
    return output
controls=read('control_pairs');envelopes=read('envelopes');fixed=read('fixed_pairs')
groups=[]
for n in (65536,33554432):
    for batch in (1,31,4096):
        for mode in ('generic_pure','generic_staged_common_hash','visible_public_pure','visible_public_fused_common_hash'):
            for owner in ('range_control','external','production_native'):
                pool=controls if owner=='range_control' else envelopes
                rows=[r for r in pool if (r['keys'],r['batch'],r['mode'])==(n,batch,mode) and
                      (owner=='range_control' or r['rival_owner']==owner)]
                if rows:groups.append(dict(keys=n,batch=batch,mode=mode,comparison_group=owner,
                    rivals=sorted({r['rival_point_id'] for r in rows if r['rival_point_id'] is not None}),**stats(rows)))
flips={'direct_control':round_flips(controls,'comparison_group'),
       'per_cell_rivals':round_flips(envelopes,'rival_owner'),
       'fixed_rivals':round_flips(fixed,'rival_owner')}
assert tuple(len(flips[k]) for k in ('direct_control','per_cell_rivals','fixed_rivals'))==(32,64,64)
gates=read('gates');quality=read('quality')
summary=dict(scope='Completed fixed report only; counts/ranges are descriptive, not pooled significance.',
    envelopes_total=stats(envelopes),
    envelopes_by_owner={o:stats([r for r in envelopes if r['rival_owner']==o]) for o in ('external','production_native')},
    envelopes_by_size={str(n):stats([r for r in envelopes if r['keys']==n]) for n in (65536,33554432)},
    control_total=stats(controls),control_by_size={str(n):stats([r for r in controls if r['keys']==n]) for n in (65536,33554432)},
    fixed_total=stats(fixed),contracts=groups,
    qualification=dict(points=len(gates),qualified=sum(g['eligible'] for g in gates),
        failed_point_ids=[g['point_id'] for g in gates if not g['eligible']],
        api_records=len(quality),known_mapping_records=len(read('mapping_quality')),
        candidate_wilson_upper=[dict(point_id=q['point_id'],seed=q['seed'],upper=q['wilson_upper'])
          for q in quality if next(g['owner'] for g in gates if g['point_id']==q['point_id'])=='candidate']),
    round_flip_definition='Same seed/size/batch/mode/group changes exact ratio outcome across rounds; per-cell rivals may also change. No isolated order or statistical-independence inference.',
    round_flip_counts={name:dict(groups=len(items),outcome_changed=sum(x['outcome_changed'] for x in items),
        rival_changed=sum(x['rival_changed'] for x in items)) for name,items in flips.items()},
    round_flip_records=flips,decision=read('decision'))
print(json.dumps(summary,indent=2,allow_nan=False))

