"""Exact-derived formal row guard; unused proof helpers retain their parent bytes."""
import json
import math
from pathlib import Path

HERE=Path(__file__).resolve().parent
PLAN=json.loads((HERE/'selection.json').read_text())
POINTS={p['id']:p for p in PLAN['points']}
MODES=('generic_pure','generic_staged_common_hash','visible_public_pure','visible_public_fused_common_hash')
FOUR=((0,1,3,2),(1,2,0,3),(2,3,1,0),(3,0,2,1))
TWO=((0,1),(1,0),(1,0),(0,1))
BASE=[(50,1,0),(50,1,1),(0,1,0),(100,1,0),(50,3,0),(50,31,0),(50,4096,0),(100,31,0)]
CASES=[dict(power=16,hit=h,batch=b,order=o,query_power=12,repeats=4,seed=74381,
            calibration_power=10 if h==50 and b==1 else 0) for h,b,o in BASE]
ALLOCATION_CASES=[dict(power=p,hit=50,batch=1,order=0,query_power=12,repeats=4,seed=74381,calibration_power=0) for p in (16,25)]


def need(value,message):
    if not value:raise ValueError(message)


def unique(pairs):
    result={}
    for key,value in pairs:
        need(key not in result,'duplicate JSON field')
        result[key]=value
    return result


class Random:
    def __init__(self,seed):self.state=seed
    def advance(self,count):self.state=(self.state+count*0x9e3779b97f4a7c15)&((1<<64)-1)
    def next(self):
        self.advance(1);z=self.state
        z=((z^(z>>30))*0xbf58476d1ce4e5b9)&((1<<64)-1)
        z=((z^(z>>27))*0x94d049bb133111eb)&((1<<64)-1)
        return z^(z>>31)


def arguments(case,mode='--check'):
    return [mode,*map(str,(case['power'],case['hit'],case['query_power'],case['batch'],case['repeats'],case['seed'],case['order'],case['calibration_power']))]


def selected(case,allocation=False):
    n=1<<case['power'];primary=allocation or (case['hit']==50 and case['batch']==1)
    points=[p for p in PLAN['points'] if int(p['geometry']['keys'])==n and
            (primary or p['owner'] in ('candidate','old_k12','native_range'))]
    if allocation:return points,None
    q=1<<case['query_power'];rng=Random(case['seed']);base=rng.next()%((1<<32)-n-q)
    present=q//100*case['hit']+min(q%100,case['hit'])
    rng.advance(n-1+present+q-1)
    for i in range(len(points)-1,0,-1):
        j=rng.next()%(i+1);points[i],points[j]=points[j],points[i]
    if case['order']:points.reverse()
    return points,base


def semantics(row):
    return {k:v for k,v in row.items() if k not in ('samples','reverse_jobs')}


def geometry(row,point):
    g=point['geometry']
    values=dict(point_id=point['id'],filter=g['filter'],owner=point['owner'],keys=int(g['keys']),
        requested_bpk=int(g['requested_bpk']),actual_bytes=int(g['filter_bytes']),budget_bytes=int(g['budget_bytes']),
        logical_bytes=int(g['logical_bytes']),unit_bytes=int(g['unit_bytes']),unit_count=int(g['unit_count']),
        effective_probes=int(g['effective_probes']),constructor_argument=int(g['constructor_argument']),
        geometry_kind=g['geometry_kind'],probe_policy=g['probe_policy'],native_constructor_bpk=int(g.get('native_constructor_bpk',0)))
    for key,value in values.items():need(row.get(key)==value,'wrong geometry '+key)


def parse(text,case,allocation=False):
    result=[json.loads(line,object_pairs_hook=unique) for line in text.splitlines() if line]
    points,base=selected(case,allocation)
    need([r.get('point_id') for r in result]==[p['id'] for p in points],'wrong full public point order/set')
    for row,p in zip(result,points,strict=True):
        geometry(row,p)
        if allocation:
            need(row.get('allocation_only') is True,'not allocation observation');continue
        q=1<<case['query_power'];present=q//100*case['hit']+min(q%100,case['hit'])
        for key,value in dict(queries=q,hit=case['hit'],batch=case['batch'],repeats=case['repeats'],seed=case['seed'],
            reverse_jobs=bool(case['order']),measure=True,key_base=base,present=present,absent=q-present,
            query_scratch_bytes=case['batch']*8,calibration_negatives=(1<<case['calibration_power']) if case['calibration_power'] else 0).items():
            need(row.get(key)==value,'wrong caller '+key)
        need(type(row['false_positives']) is int and 0<=row['false_positives']<=row['absent'],'invalid mixed FP')
        need(type(row['calibration_fp']) is int and 0<=row['calibration_fp']<=row['calibration_negatives'],'invalid cal FP')
        for key in ('inserted_digest','query_digest','inserted_hash_digest','query_hash_digest','result_digest'):
            need(type(row[key]) is int and 0<=row[key]<(1<<64),'missing full digest '+key)
        for key in ('bitmap_digest','calibration_digest'):
            need(row[key] is None or (type(row[key]) is int and 0<=row[key]<(1<<64)),'invalid optional digest')
        if p['owner'] in ('candidate','old_k12','native_range'):need(row['bitmap_digest'] is not None,'missing public native bitmap')
        need((row['calibration_digest'] is None)==(case['calibration_power']==0),'wrong calibration availability')
        schedule=FOUR if case['batch']==1 else TWO
        need(row['phase_order']==[m for r in range(case['repeats']) for m in schedule[r%4]],'wrong phase order')
        need(set(row['samples'])==set(MODES),'wrong query mode set')
        for index,mode in enumerate(MODES):
            values=row['samples'][mode];need(len(values)==(case['repeats'] if index<2 or case['batch']==1 else 0),'wrong vector length')
            need(all(type(v) in (int,float) and math.isfinite(v) and v>0 for v in values),'invalid vector')
    if not allocation:
        for key in ('inserted_digest','query_digest','inserted_hash_digest','query_hash_digest'):
            need(len({r[key] for r in result})==1,'canonical input differs across public points')
        aliases={}
        for row,p in zip(result,points,strict=True):
            evidence=tuple(row[k] for k in ('actual_bytes','false_positives','result_digest','calibration_negatives','calibration_fp','calibration_digest','bitmap_digest'))
            key=p['mapping_id'];need(key not in aliases or aliases[key]==evidence,'known alias full output mismatch');aliases[key]=evidence
    return result


def old_reference(records,profile):
    expected=json.loads((HERE/'old-reference.json').read_text())['profiles'][profile]['expected']
    record=next(r for r in records if r['case']['hit']==100 and r['case']['batch']==31)
    for item in expected:
        owner='old_k12' if item['old_filter']=='Control' else 'candidate'
        actual=next(r for r in record['rows'] if r['owner']==owner and r['requested_bpk']==24)
        for key,value in item.items():
            if key!='old_filter':need(actual.get(key)==value,'old seen public semantic mismatch '+key)
