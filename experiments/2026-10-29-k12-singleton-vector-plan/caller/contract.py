"""Focused actual-public caller row contract; no timed-data selection."""
import json
import math

MODES=("generic_pure","generic_staged_common_hash","visible_public_pure","visible_public_fused_common_hash")
BASE_CASES=((8,0,1),(8,50,3),(16,100,31),(8,50,4096))
CASES=[dict(power=p,hit=h,batch=b,order=order,query_power=12,repeats=4,seed=74381)
       for p,h,b in BASE_CASES for order in (0,1)]
FOUR=((0,1,3,2),(1,2,0,3),(2,3,1,0),(3,0,2,1))
TWO=((0,1),(1,0),(1,0),(0,1))

def need(value,message):
    if not value: raise ValueError(message)

def unique(pairs):
    out={}
    for key,value in pairs:
        need(key not in out,"duplicate JSON field")
        out[key]=value
    return out

def arguments(case, mode="--check"):
    return [mode,*map(str,(case['power'],case['hit'],case['query_power'],case['batch'],case['repeats'],case['seed'],case['order']))]

def semantics(row):
    return {k:v for k,v in row.items() if k not in ('filter','order','samples')}

def rows(text,case):
    result=[json.loads(line,object_pairs_hook=unique)for line in text.splitlines() if line]
    names=['Control','Candidate'] if case['order']==0 else ['Candidate','Control']
    need([r.get('filter') for r in result]==names,'exact two public rows/order required')
    for r in result:
        n,q=1<<case['power'],1<<case['query_power']
        for field,expected in dict(keys=n,queries=q,actual_bytes=n*3,hit=case['hit'],batch=case['batch'],repeats=4,seed=74381,order=case['order'],measure=False).items():
            need(r.get(field)==expected,f'wrong {field}')
        present=sum(i%100<case['hit']for i in range(q))
        need(r['present']==present and r['absent']==q-present,'query interval counts')
        need(type(r['false_positives'])is int and 0<=r['false_positives']<=r['absent'],'FP counts')
        need(type(r['key_base'])is int and 0<=r['key_base']<(1<<32)-n-q,'raw interval')
        for field in ('inserted_digest','query_digest','inserted_hash_digest','query_hash_digest','bitmap_digest','result_digest'):
            need(type(r[field])is int and 0<=r[field]<(1<<64),'missing full semantic digest')
        schedule=FOUR if case['batch']==1 else TWO
        need(r['phase_order']==[v for step in schedule for v in step],'wrong actual phase order')
        need(set(r['samples'])==set(MODES),'wrong metric set')
        for index,mode in enumerate(MODES):
            values=r['samples'][mode]
            need(len(values)==(4 if index<2 or case['batch']==1 else 0),'wrong repeat count')
            need(all(isinstance(v,(int,float)) and math.isfinite(v) and v>0 for v in values),'invalid time')
    need(semantics(result[0])==semantics(result[1]),'control/candidate full semantic mismatch')
    return result
