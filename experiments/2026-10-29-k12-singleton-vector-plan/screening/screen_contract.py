"""Fixed two-round public-query contract. No outcome-based filtering."""
import json
import math
from pathlib import Path
HERE=Path(__file__).resolve().parent
MODES=('generic_pure','generic_staged_common_hash','visible_public_pure','visible_public_fused_common_hash')
FIELDS={'filter','keys','queries','actual_bytes','hit','batch','repeats','seed','order','measure','key_base',
    'inserted_digest','query_digest','bitmap_digest','inserted_hash_digest','query_hash_digest','result_digest',
    'present','absent','false_positives','phase_order','samples'}
COUNTS=dict(processes=96,rows=192,metric_contrasts=240,vectors=480,samples=3840)
def need(value,message):
    if not value:raise ValueError(message)
def unique(pairs):
    out={}
    for key,value in pairs:need(key not in out,'duplicate JSON field');out[key]=value
    return out
def read(path):return json.loads(Path(path).read_text(),object_pairs_hook=unique)
def ledger():return read(HERE/'ledger.json')
def key_base(seed,n,q):
    mask=(1<<64)-1;z=(seed+0x9e3779b97f4a7c15)&mask
    z=((z^(z>>30))*0xbf58476d1ce4e5b9)&mask;z=((z^(z>>27))*0x94d049bb133111eb)&mask
    return (z^(z>>31))%((1<<32)-n-q)
def arguments(case):
    order=0 if case['api_order']==['Control','Candidate']else 1
    return ['--measure',*map(str,(case['n_exponent'],case['hit_percent'],22,case['batch'],8,case['seed'],order))]
def semantics(row):return {k:v for k,v in row.items()if k not in ('filter','samples')}
def parse(text,case):
    result=[json.loads(line,object_pairs_hook=unique)for line in text.splitlines()if line]
    need([r.get('filter')for r in result]==case['api_order'],'exact public API order/set required')
    n,q=1<<case['n_exponent'],1<<22;hit=case['hit_percent'];present=(q//100)*hit+min(q%100,hit)
    order=0 if case['api_order'][0]=='Control'else 1
    schedule=((0,1,3,2),(1,2,0,3),(2,3,1,0),(3,0,2,1))if case['batch']==1 else((0,1),(1,0),(1,0),(0,1))
    phase=[v for _ in range(2)for step in schedule for v in step]
    for row in result:
        need(set(row)==FIELDS,'unexpected row schema')
        for field,expected in dict(keys=n,queries=q,actual_bytes=3*n,hit=hit,batch=case['batch'],repeats=8,
            seed=case['seed'],order=order,measure=True,key_base=key_base(case['seed'],n,q),present=present,absent=q-present).items():
            need(type(row[field])is type(expected)and row[field]==expected,'wrong '+field)
        for field in ('inserted_digest','query_digest','inserted_hash_digest','query_hash_digest','bitmap_digest','result_digest'):
            need(type(row[field])is int and 0<=row[field]<(1<<64),'invalid semantic digest')
        need(type(row['false_positives'])is int and 0<=row['false_positives']<=row['absent'],'invalid mixed FP count')
        need(row['phase_order']==phase,'wrong measured phase schedule')
        need(set(row['samples'])==set(MODES),'metric keys changed')
        for index,mode in enumerate(MODES):
            values=row['samples'][mode];expected=8 if index<2 or case['batch']==1 else 0
            need(type(values)is list and len(values)==expected,'wrong sample count')
            need(all(type(v)in(int,float)and math.isfinite(v)and v>0 for v in values),'nonfinite/nonpositive sample')
    need(semantics(result[0])==semantics(result[1]),'same-mapping implementation mismatch')
    return result
def validate_records(records):
    expected=ledger();need(len(records)==len(expected)==96,'incomplete case ledger')
    same_query={};same_bitmap={};vectors=samples=0
    for record,case in zip(records,expected,strict=True):
        need(set(record)=={'case','rows'}and record['case']==case,'case order changed')
        parse('\n'.join(json.dumps(r,allow_nan=False)for r in record['rows']),case)
        for row in record['rows']:
            key=(row['keys'],row['seed'],row['hit'])
            shared={k:v for k,v in semantics(row).items()if k not in('batch','phase_order','order')}
            need(key not in same_query or same_query[key]==shared,'chunk/round query semantics changed');same_query[key]=shared
            bitmap_key=(row['keys'],row['seed'])
            bitmap=tuple(row[k]for k in('actual_bytes','key_base','inserted_digest','inserted_hash_digest','bitmap_digest'))
            need(bitmap_key not in same_bitmap or same_bitmap[bitmap_key]==bitmap,'hit/round construction identity changed');same_bitmap[bitmap_key]=bitmap
            for values in row['samples'].values():vectors+=bool(values);samples+=len(values)
    need(len(same_query)==12 and len(same_bitmap)==4,'input identity cardinality')
    need(vectors==480 and samples==3840,'metric cardinality')
    return dict(COUNTS)
