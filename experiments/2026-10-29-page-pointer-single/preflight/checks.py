"""Additive validation only; canonicalization never changes measured code."""
import json,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
SOURCE=HERE.parent
ROOT=SOURCE.parents[1]
BASE=ROOT/'benchmarks/vldb-raw32-stage3'
sys.path.insert(0,str(BASE))
import contract as original
need=original.need
PROTOCOL=json.loads((SOURCE/'protocol.json').read_text())
NAMES=PROTOCOL['registry']
WORKER=PROTOCOL['worker']
ALIASES=PROTOCOL['canonical_alias']

def cases():
    return [dict(worker=WORKER,filter=name,power=f['key_power'],cap=f['cap_bpk'],
       qpower=13,hit=f['hit_percent'],seed=42,calpower=12,repeats=0)
       for f in PROTOCOL['preflight_plan']['fixtures'] for name in NAMES]

def canonical_case(case):
    need(case['worker']==WORKER and case['filter'] in NAMES,'Unregistered caller case')
    return dict(case,worker='modern',filter=ALIASES.get(case['filter'],case['filter']))

def canonical_row(row):
    name=row['filter'];need(row['worker']==WORKER and name in NAMES,'Wrong caller worker/name')
    r=dict(row,worker='modern',filter=ALIASES.get(name,name))
    if name in ALIASES:
        need(row['surface']=='upstream_raw4_input_pointer_single_v1','Pointer surface not explicit')
        r['surface']='upstream_raw4_byte_api'
    return r

def validate(row,case):
    need(row['filter']==case['filter'],'Different requested alias')
    original.validate(canonical_row(row),canonical_case(case))
    return row

def parity(rows):return original.parity([canonical_row(r) for r in rows])

def baseline_key(row):
    return tuple(row[k]for k in ('filter','keys','requested_bpk','queries','hit_percent','seed','calibration_absent_queries'))

def compare_baseline(rows,baseline):
    old={baseline_key(r):r for r in baseline if r['worker']=='modern'}
    fields=original.SEMANTICS+original.WORK_FIELDS+original.EXTRA_FIELDS+[
       m+'_scratch_bytes'for m in original.MODES]+['public_metadata','adapter_object_bytes']
    for actual in rows:
        r=canonical_row(actual);key=baseline_key(r)
        need(key in old,'Missing original small-fixture baseline')
        for k in fields:need(r[k]==old[key][k],'Caller changed baseline semantics: '+k)
    return len(set(baseline_key(canonical_row(r))for r in rows))
