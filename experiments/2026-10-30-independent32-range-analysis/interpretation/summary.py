"""Descriptive summaries of the complete, frozen report only; no producer execution."""
import collections
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPORT = HERE.parent / 'report-v2'

def read(name):
    return json.loads((REPORT / (name + '.json')).read_text())

def summary(rows, field='latency_ratio'):
    values = [r[field] for r in rows if r[field] is not None]
    return dict(count=len(rows), outcomes=dict(collections.Counter(r['outcome'] for r in rows)),
                latency_ratio_min=min(values) if values else None,
                latency_ratio_max=max(values) if values else None)

envelopes = read('envelopes')
controls = read('controls')
gates = read('gates')
quality = read('quality')
groups = []
for n in (65536,33554432):
    for batch in (1,31,4096):
        for mode in ('generic_pure','generic_staged_common_hash','visible_public_pure','visible_public_fused_common_hash'):
            for owner in ('external','production_native'):
                rows = [r for r in envelopes if (r['keys'],r['batch'],r['mode'],r['rival_owner'])==(n,batch,mode,owner)]
                if rows:
                    groups.append(dict(keys=n,batch=batch,mode=mode,rival_owner=owner,
                        rivals=sorted({r['rival_point_id'] for r in rows}),**summary(rows)))
result = dict(
    envelopes_total=summary(envelopes),
    envelopes_by_owner={o:summary([r for r in envelopes if r['rival_owner']==o]) for o in ('external','production_native')},
    envelopes_by_size={str(n):summary([r for r in envelopes if r['keys']==n]) for n in (65536,33554432)},
    fixed_total=summary(read('fixed_pairs')),
    fixed_by_owner={o:summary([r for r in read('fixed_pairs') if r['rival_owner']==o]) for o in ('external','production_native')},
    contracts=groups,
    control_totals={tag:summary([r for r in controls if r['comparison']==tag]) for tag in ('candidate16_equal_byte','candidate12_smaller_footprint')},
    controls_by_size={str(n):{tag:summary([r for r in controls if r['comparison']==tag and r['keys']==n])
        for tag in ('candidate16_equal_byte','candidate12_smaller_footprint')} for n in (65536,33554432)},
    gates=dict(points=len(gates),eligible=sum(g['eligible'] for g in gates),
        failures=[g for g in gates if not g['eligible']]),
    candidate_quality=[q for q in quality if next(g for g in gates if g['point_id']==q['point_id'])['owner']=='candidate'],
    decision=read('decision'))
print(json.dumps(result,indent=2,allow_nan=False))

