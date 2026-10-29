"""Independent complete-data arithmetic audit; no imports from the analysis."""
import json,math,statistics,sys
from pathlib import Path
root=Path('/home/yiming/projects/fastest-bf-lab')
raw=root/'experiments/2026-10-30-independent32-range/screening/results-v1'
report=Path(sys.argv[1])
def read(path):return json.loads(path.read_text())
def same(a,b):
    if a is None or b is None: assert a is b,(a,b)
    else: assert math.isclose(a,b,rel_tol=2e-13,abs_tol=1e-15),(a,b)
def indexed(items,fields,expected=None):
    result={tuple(x[k] for k in fields):x for x in items}
    assert len(result)==len(items),(fields,'duplicate output key')
    if expected is not None: assert set(result)==set(expected),(fields,'missing/extra key')
    return result
def upper(k,n):
    z=1.959963984540054
    return (k+z*z/2+z*math.sqrt(k*(1-k/n)+z*z/4))/(n+z*z)
records=read(raw/'records.json')
meta=read(raw/'metadata.json')
assert meta['complete'] and len(records)==24 and all(c['exit_code']==0 for c in meta['cases'])
points=read(root/'experiments/2026-10-30-independent32-range/caller/selection.json')['points']
point={p['id']:p for p in points}
seed=(982451653,961748941)
flat=[(rec['case'],r) for rec in records for r in rec['rows']]
assert len(flat)==216
fresh={(r['point_id'],r['seed']):r for c,r in flat if r['calibration_negatives']}
assert len(fresh)==36
assert all(r['calibration_negatives']==2**26 for r in fresh.values())
assert len({(point[pid]['mapping_id'],s) for pid,s in fresh})==34
gate={pid: all(upper(fresh[pid,s]['calibration_fp'],2**26)<=.01 for s in seed) and
    int(p['geometry']['filter_bytes'])*8<=int(p['geometry']['keys'])*16 for pid,p in point.items()}
rows={(c['index'],r['point_id']):r for c,r in flat}
cases={c['index']:c for c,r in flat}
med={(c['index'],r['point_id'],m):statistics.median(v) for c,r in flat for m,v in r['samples'].items() if v}
assert len(med)==576
candidates={(int(p['geometry']['keys']),int(p['geometry']['requested_bpk'])):p['id']
    for p in points if p['owner']=='candidate'}
condition={(2**cases[i]['power'],cases[i]['batch'],m) for i,pid,m in med}
pairkeys={(i,m,o) for i,pid,m in med for o in ('external','production_native')}
viewkeys={(*c,o) for c in condition for o in ('external','production_native')}
vectors=read(report/'vectors.json');trials=read(report/'trials.json')
assert len(vectors)==576 and len(trials)==4608
indexed(vectors,('case_index','point_id','mode'),med)
indexed(trials,('case_index','point_id','mode','repeat'),{(*k,j) for k in med for j in range(8)})
for v in vectors:
 r=rows[v['case_index'],v['point_id']]; values=r['samples'][v['mode']]
 assert v['values_ns_per_key']==values
 for name,expected in [('median_ns_per_key',statistics.median(values)),('min_ns_per_key',min(values)),('max_ns_per_key',max(values))]:same(v[name],expected)
for t in trials: same(t['ns_per_key'],rows[t['case_index'],t['point_id']]['samples'][t['mode']][t['repeat']])
gates=indexed(read(report/'gates.json'),('point_id',),{(pid,) for pid in point})
for (pid,),g in gates.items():assert g['eligible']==gate[pid]
qualities=indexed(read(report/'quality.json'),('point_id','seed'),fresh)
for q in qualities.values():
 r=fresh[q['point_id'],q['seed']]
 assert q['calibration_fp']==r['calibration_fp'] and q['calibration_negatives']==2**26
 same(q['wilson_upper'],upper(r['calibration_fp'],2**26))
 assert q['reuse_case_indices']==[c['index'] for c,row in flat if row['point_id']==q['point_id'] and row['seed']==q['seed'] and not row['calibration_negatives']]
 assert len(q['reuse_case_indices'])==5
 for key,value in q['insertion_identity'].items():assert value==r[key]
 for key,value in q['query_identity'].items():assert value==r[key]
 source=next((c['index'],j) for rec in records for c in [rec['case']] for j,row in enumerate(rec['rows']) if row is r)
 assert (q['source_case_index'],q['source_row_index'])==source
aliases={}
for pid,ss in fresh:aliases.setdefault((point[pid]['mapping_id'],ss),[]).append(pid)
maps=indexed(read(report/'mapping_quality.json'),('mapping_id','seed'),aliases)
for key,m in maps.items():
 assert m['point_ids']==aliases[key]
 assert m['representative_quality']==qualities[aliases[key][0],key[1]]
alts=read(report/'alternatives.json');assert len(alts)==576
indexed(alts,('case_index','point_id','mode'),med)
for a in alts:
 same(a['median_ns_per_key'],med[a['case_index'],a['point_id'],a['mode']]);assert a['eligible']==gate[a['point_id']]
def outcome(r):return 'not_comparable' if r is None else 'faster' if r<1 else 'slower' if r>1 else 'tie'
def check_pair(p):
 i,m,n,d=p['case_index'],p['mode'],p['numerator_point_id'],p['rival_point_id']
 a=med[i,n,m];b=med[i,d,m] if d else None
 expected=a/b if b is not None and (not p['qualification_required'] or gate[n] and gate[d]) else None
 same(p['numerator_ns_per_key'],a);same(p['rival_ns_per_key'],b);same(p['latency_ratio'],expected)
 assert p['outcome']==outcome(expected)
 assert p['numerator_eligible']==gate[n] and p['rival_eligible']==(gate[d] if d else None)
envelopes=read(report/'envelopes.json');fixed=read(report/'fixed_pairs.json');controls=read(report/'controls.json')
assert (len(envelopes),len(fixed),len(controls))==(128,128,704)
for pairs in (envelopes,fixed):
 indexed(pairs,('case_index','mode','rival_owner'),pairkeys)
 for p in pairs:
  c=cases[p['case_index']];n=2**c['power']
  assert (p['keys'],p['batch'],p['seed'],p['round'])==(n,c['batch'],c['seed'],c['round'])
  assert p['qualification_required'] is True and p['numerator_point_id']==candidates[n,12]
expected_controls=set()
for i,m,o in pairkeys:
 if o!='external':continue
 n=2**cases[i]['power'];c12,c16=candidates[n,12],candidates[n,16]
 retained=[p['id'] for p in points if int(p['geometry']['keys'])==n and p['owner'] in ('production_native','retained_independent')]
 for pid in retained:expected_controls.add((i,m,c16,pid,'candidate16_equal_byte'))
 for pid in [c16]+retained:expected_controls.add((i,m,c12,pid,'candidate12_smaller_footprint'))
indexed(controls,('case_index','mode','numerator_point_id','rival_point_id','comparison'),expected_controls)
assert all(p['qualification_required'] is False for p in controls)
for p in envelopes:
 i,m=p['case_index'],p['mode']
 eligible=[x['id'] for x in points if int(x['geometry']['keys'])==p['keys'] and x['owner']==p['rival_owner'] and gate[x['id']]]
 best=min(eligible,key=lambda pid:(med[i,pid,m],pid)) if eligible else None
 assert p['rival_point_id']==best
 check_pair(p)
views=read(report/'fixed_views.json');assert len(views)==32
indexed(views,('keys','batch','mode','rival_owner'),viewkeys)
for v in views:
 n,b,m,o=v['keys'],v['batch'],v['mode'],v['rival_owner']
 ids=[i for i,c in cases.items() if 2**c['power']==n and c['batch']==b]
 assert len(ids)==4
 eligible=[x['id'] for x in points if int(x['geometry']['keys'])==n and x['owner']==o and gate[x['id']]]
 gm={pid:math.exp(math.fsum(math.log(med[i,pid,m]) for i in ids)/4) for pid in eligible}
 best=min(eligible,key=lambda pid:(gm[pid],pid)) if eligible else None
 assert v['fixed_leader_point_id']==best
 same(v['geometric_mean_ns_per_key'],gm.get(best))
 for p in fixed:
  if (p['keys'],p['batch'],p['mode'],p['rival_owner'])==(n,b,m,o):assert p['rival_point_id']==best
for p in fixed+controls:check_pair(p)
assert sum(p['comparison']=='candidate16_equal_byte' for p in controls)==320
assert sum(p['comparison']=='candidate12_smaller_footprint' for p in controls)==384
rounds=read(report/'round_pairs.json');assert len(rounds)==288
expected_rounds={(pid,cases[i]['seed'],cases[i]['batch'],m) for i,pid,m in med if cases[i]['round']==1}
indexed(rounds,('point_id','seed','batch','mode'),expected_rounds)
for p in rounds:
 a,b,m,pid=p['round1_case_index'],p['round2_case_index'],p['mode'],p['point_id']
 same(p['round2_over_round1_latency_ratio'],med[b,pid,m]/med[a,pid,m])
assert len({(p['point_id'],p['seed'],p['batch'],p['mode']) for p in rounds})==288
required=[p for p in envelopes if p['keys']==2**25 and
    (p['batch']==4096 or p['batch']==1 and p['mode'].startswith('visible_'))]
assert len(required)==32
decision=read(report/'decision.json');assert decision['comparisons']==required
for key,label in [('faster','faster'),('slower','slower'),('ties','tie'),('not_comparable','not_comparable')]:
 assert decision[key]==sum(p['outcome']==label for p in required)
assert decision['closed']==all(p['outcome']=='faster' for p in required)
print('PASS independent216: 36 quality/34 known mappings; 576 vectors/4608 trials; 576 alternatives; 128 envelopes/128 fixed pairs; 704 controls; 288 round comparisons; 32 target decisions')
