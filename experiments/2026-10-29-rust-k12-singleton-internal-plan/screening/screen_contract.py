"""Exact 96-process/two-profile contract; no filtering or outcome analysis."""
import json
import math
from pathlib import Path

HERE=Path(__file__).resolve().parent
FIELDS={'filter','keys','queries','batch','hit','seed','repeats','filter_bytes','backend',
        'input_digest','insert_digest','bitmap_digest','output_digest','scratch_bytes',
        'phase_order','trials_ns','round','stage','calibration_queries'}
COUNTS=dict(processes=96,rows=192,metric_contrasts=288,vectors=576,samples=4608)
FOUR=[[0,1,3,2],[1,2,0,3],[2,3,1,0],[3,0,2,1]]
TWO=[[0,1],[1,0],[1,0],[0,1]]

def need(ok,message):
    if not ok:raise ValueError(message)

def unique(pairs):
    result={}
    for key,value in pairs:
        need(key not in result,'duplicate JSON key');result[key]=value
    return result

def read(path):return json.loads(Path(path).read_text(),object_pairs_hook=unique)
def ledger():return read(HERE/'ledger.json')['cases']
def arguments(case):return ['--measure',*map(str,[case['key_power'],case['hit'],case['batch'],case['seed'],case['round']])]
def semantics(row):return {key:value for key,value in row.items() if key not in ['filter','trials_ns']}

def parse(text,case):
    rows=[json.loads(line,object_pairs_hook=unique) for line in text.splitlines() if line]
    need(len(rows)==2 and [r.get('filter') for r in rows]==case['api_order'],'wrong exact API set/order')
    fixed=dict(keys=case['keys'],queries=case['queries'],batch=case['batch'],hit=case['hit'],seed=case['seed'],
               repeats=8,filter_bytes=case['filter_bytes'],backend='avx512',scratch_bytes=min(case['batch'],case['queries'])*8,
               round=case['round'],stage='measure',calibration_queries=0)
    for row in rows:
        need(set(row)==FIELDS,'unexpected row schema')
        for key,value in fixed.items():
            need(type(row[key]) is type(value) and row[key]==value,'wrong '+key)
        for key in ['input_digest','insert_digest','bitmap_digest','output_digest']:
            need(type(row[key]) is int and 0<=row[key]<2**64,'invalid semantic digest')
        schedule=(FOUR if case['batch']==1 else TWO)*2
        need(json.dumps(row['phase_order'])==json.dumps(schedule),'wrong balanced phase schedule')
        need(type(row['trials_ns']) is list and len(row['trials_ns'])==len(case['metrics']),'wrong mode count')
        for values in row['trials_ns']:
            need(type(values) is list and len(values)==8,'wrong query repeat count')
            need(all(type(v) in (int,float) and math.isfinite(v) and v>0 for v in values),'invalid timing sample')
    need(semantics(rows[0])==semantics(rows[1]),'same-mapping arm identity differs')
    return rows

def validate_records(records):
    expected=ledger();need(len(records)==len(expected)==96,'incomplete fixed ledger')
    queries={};bitmaps={};vectors=samples=0
    for record,case in zip(records,expected,strict=True):
        need(set(record)=={'case','rows'} and json.dumps(record['case'],sort_keys=True)==json.dumps(case,sort_keys=True),'case order/identity differs')
        parse('\n'.join(json.dumps(r,allow_nan=False) for r in record['rows']),case)
        for row in record['rows']:
            key=(row['keys'],row['seed'],row['hit'])
            value=tuple(row[k] for k in ['queries','input_digest','output_digest','filter_bytes','backend'])
            need(queries.setdefault(key,value)==value,'query/input differs across profiles/batches/rounds')
            construction=(row['keys'],row['seed'])
            value=tuple(row[k] for k in ['filter_bytes','insert_digest','bitmap_digest'])
            need(bitmaps.setdefault(construction,value)==value,'construction differs across hits/profiles/rounds')
            vectors+=len(row['trials_ns']);samples+=sum(map(len,row['trials_ns']))
    need(len(queries)==12 and len(bitmaps)==4,'wrong input identity cardinality')
    need(vectors==576 and samples==4608,'wrong vector/sample cardinality')
    return dict(COUNTS)
