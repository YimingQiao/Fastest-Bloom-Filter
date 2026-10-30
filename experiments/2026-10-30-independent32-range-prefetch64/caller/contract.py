"""Fixed small actual-caller proof; no timing ranking or formal-data loader."""
import json
import math
from pathlib import Path

HERE = Path(__file__).resolve().parent
SELECTION = json.loads((HERE/'selection.json').read_text())
POINTS = SELECTION['points']
MODES = ('generic_pure','generic_staged_common_hash','visible_public_pure','visible_public_fused_common_hash')
FOUR = ((0,1,3,2),(1,2,0,3),(2,3,1,0),(3,0,2,1))
TWO = ((0,1),(1,0),(1,0),(0,1))
MASK = (1 << 64) - 1
GEOMETRY = ('point_id','filter','owner','keys','requested_bpk','actual_bytes','budget_bytes',
            'logical_bytes','unit_bytes','unit_count','effective_probes','constructor_argument',
            'native_constructor_bpk','geometry_kind','probe_policy','bitmap_available')
FIELDS = set(GEOMETRY) | set(('queries hit batch repeats seed reverse_jobs measure key_base inserted_digest '
    'query_digest inserted_hash_digest query_hash_digest result_digest present absent false_positives '
    'calibration_negatives calibration_fp calibration_digest bitmap_digest query_scratch_bytes phase_order samples').split())
CASES = [dict(power=16,hit=50,query_power=12,batch=b,repeats=4,seed=74381,order=o,
              calibration_power=10 if b==1 else 0) for b,o in ((1,0),(31,1),(4096,0))]
ALLOCATION_CASES = [dict(power=p,hit=50,query_power=12,batch=1,repeats=4,seed=74381,order=0,
                         calibration_power=0) for p in (16,25)]


def need(value, message):
    if not value: raise ValueError(message)


def unique(pairs):
    out={}
    for k,v in pairs:
        need(k not in out,'duplicate JSON field');out[k]=v
    return out


class Random:
    def __init__(self, seed): self.state=seed
    def advance(self, n): self.state=(self.state+n*0x9e3779b97f4a7c15)&MASK
    def next(self):
        self.advance(1);z=self.state
        z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK
        z=((z^(z>>27))*0x94d049bb133111eb)&MASK
        return z^(z>>31)


def arguments(case, mode='--check'):
    return [mode,*map(str,(case['power'],case['hit'],case['query_power'],case['batch'],case['repeats'],case['seed'],case['order'],case['calibration_power']))]


def selected(case, allocation=False):
    n,q=1<<case['power'],1<<case['query_power']
    points=[p for p in POINTS if int(p['geometry']['keys'])==n]
    if allocation:return points,None
    points.append(SELECTION['proof_only_point'])
    rng=Random(case['seed']);base=rng.next()%((1<<32)-n-q)
    present=q//100*case['hit']+min(q%100,case['hit'])
    rng.advance(n-1+present+q-1)
    for i in range(len(points)-1,0,-1):
        j=rng.next()%(i+1);points[i],points[j]=points[j],points[i]
    if case['order']:points.reverse()
    return points,base


def geometry(point):
    g=point['geometry']
    return dict(point_id=point['id'],filter=g['filter'],owner=point['owner'],keys=int(g['keys']),
        requested_bpk=int(g['requested_bpk']),actual_bytes=int(g['filter_bytes']),budget_bytes=int(g['budget_bytes']),
        logical_bytes=int(g['logical_bytes']),unit_bytes=int(g['unit_bytes']),unit_count=int(g['unit_count']),
        effective_probes=int(g['effective_probes']),constructor_argument=int(g['constructor_argument']),
        native_constructor_bpk=int(g.get('native_constructor_bpk',0)),geometry_kind=g['geometry_kind'],
        probe_policy=g['probe_policy'],bitmap_available=point['public_data_available'])


def parse(text, case, allocation=False):
    def bad(value): raise ValueError('nonfinite JSON constant '+value)
    rows=[json.loads(line,object_pairs_hook=unique,parse_constant=bad) for line in text.splitlines()]
    points,base=selected(case,allocation)
    need([r.get('point_id') for r in rows]==[p['id'] for p in points],'exact point order/set')
    for row,point in zip(rows,points,strict=True):
        need(set(row)==(set(GEOMETRY)|{'allocation_only'} if allocation else FIELDS),'exact schema')
        for k,v in geometry(point).items():need(type(row[k])is type(v) and row[k]==v,'geometry '+k)
        if allocation:
            need(row['allocation_only'] is True,'allocation mode');continue
        q=1<<case['query_power'];present=q//100*case['hit']+min(q%100,case['hit'])
        expected=dict(queries=q,hit=case['hit'],batch=case['batch'],repeats=4,seed=74381,
            reverse_jobs=bool(case['order']),measure=False,key_base=base,present=present,absent=q-present,
            query_scratch_bytes=8*case['batch'],calibration_negatives=(1<<case['calibration_power']) if case['calibration_power'] else 0)
        for k,v in expected.items():need(type(row[k])is type(v) and row[k]==v,'caller '+k)
        for k in ('inserted_digest','query_digest','inserted_hash_digest','query_hash_digest','result_digest'):
            need(type(row[k])is int and 0<=row[k]<=MASK,'digest '+k)
        need(type(row['false_positives'])is int and 0<=row['false_positives']<=row['absent'],'mixed FP')
        need(type(row['calibration_fp'])is int and 0<=row['calibration_fp']<=row['calibration_negatives'],'calibration FP')
        need((row['calibration_digest'] is not None)==bool(case['calibration_power']),'calibration availability')
        # Actual public Data trait, never an ownership-label approximation.
        need((row['bitmap_digest'] is not None)==row['bitmap_available'],'Data trait/digest availability')
        for k in ('bitmap_digest','calibration_digest'):
            need(row[k] is None or (type(row[k])is int and 0<=row[k]<=MASK),'optional digest '+k)
        schedule=FOUR if case['batch']==1 else TWO
        need(row['phase_order']==[m for trial in schedule for m in trial],'balanced phase order')
        need(type(row['samples'])is dict and set(row['samples'])==set(MODES),'metric set')
        for i,name in enumerate(MODES):
            v=row['samples'][name]
            need(type(v)is list and len(v)==(4 if i<2 or case['batch']==1 else 0),'trial length')
            need(all(type(x)in (int,float) and math.isfinite(x) and x>0 for x in v),'positive finite trial')
    if not allocation:
        for key in ('inserted_digest','query_digest','inserted_hash_digest','query_hash_digest'):
            need(len({r[key]for r in rows})==1,'shared input '+key)
        aliases={}
        for row,point in zip(rows,points,strict=True):
            evidence=tuple(row[k]for k in ('actual_bytes','false_positives','result_digest','calibration_negatives','calibration_fp','calibration_digest','bitmap_digest'))
            key=point['mapping_id'];need(key not in aliases or aliases[key]==evidence,'proven mapping alias');aliases[key]=evidence
    return rows


def semantic(row):
    return {k:v for k,v in row.items() if k not in ('samples','reverse_jobs')}


def cross_batch(records):
    by_point={}
    omit={'samples','phase_order','reverse_jobs','batch','query_scratch_bytes','calibration_negatives','calibration_fp','calibration_digest'}
    for record in records:
        for row in record['rows']:
            value={k:v for k,v in row.items()if k not in omit}
            need(by_point.setdefault(row['point_id'],value)==value,'same-input cross-batch output/mapping drift')


def old_reference(records, profile):
    expected=json.loads((HERE/'old-reference.json').read_text())[profile]['rows']
    actual=records[0]['rows']
    for old in expected:
        matches=[r for r in actual if r['filter']==old['filter'] and r['actual_bytes']==old['actual_bytes']]
        need(len(matches)==1,'retained old control missing')
        for k,v in old.items():need(matches[0][k]==v,'retained old semantic field '+k)


def invalid_cases():
    base=arguments(CASES[0]);items=[]
    for index,value,diagnostic in [(0,'--bad','unknown mode'),(1,'25','proof grid mismatch'),
        (3,'22','proof grid mismatch'),(4,'2','unsupported grid'),(6,'-1','unsigned integer required'),
        (8,'26','proof grid mismatch')]:
        args=list(base);args[index]=value;items.append((args,diagnostic+'\n'))
    return items
