"""Fixed160 raw-u32 contract. No filter/planner execution and no old timing import."""
import importlib.util
import json
import math
from pathlib import Path
import statistics
import sys
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1]
sys.path.insert(0,str(STAGE))
from checks import NATIVE,SEMANTIC,GEOMETRY,geometry_key,need
spec=importlib.util.spec_from_file_location('nearby_frozen_stage3_contract',ROOT/'benchmarks/vldb-raw32-stage3/contract.py')
original=importlib.util.module_from_spec(spec);spec.loader.exec_module(original)
MODES=original.MODES

def protocol():return json.loads((HERE/'protocol.json').read_text())
def models():return json.loads((HERE/'geometry-models.json').read_text())
def geometry(name,power,cap):
    key=f'{name}/{power}/{cap}';g=models()[key]
    return dict(g)
def plan():
    p=protocol();base=[]
    for power in p['key_powers']:
        for cap in p['bitmap_cap_bpk']:
            for name in p['ordered_apis']:
                base.append(dict(filter=name,power=power,cap=cap,qpower=p['query_power'],hit=p['hit_percent'],
                                 seed=p['seed'],calpower=p['calibration_power'],repeats=p['query_repeats']))
    need(len(base)==80 and len({(c['filter'],c['power'],c['cap'])for c in base})==80,'Wrong finite panel')
    return [dict(round=r,case=c,geometry=geometry(c['filter'],c['power'],c['cap']))
            for r,order in [(0,base),(1,list(reversed(base)))]for c in order]
def command(binary,c):return [str(binary),'--measure',c['filter'],*[str(c[k])for k in ('power','cap','qpower','hit','seed','calpower','repeats')]]
def validate(row,c):
    need(list(row)==original.FIELDS,'Exact tested CSV schema required')
    g=geometry(c['filter'],c['power'],c['cap'])
    for k,v in g.items():
        need(json.loads(row[k])==json.loads(v)if k=='public_metadata'else row[k]==str(v),'Wrong geometry '+k)
    n=1<<c['power'];q=1<<c['qpower'];cal=1<<c['calpower'];present=original.present(q,c['hit'])
    expected=dict(queries=q,seed=c['seed'],hit_percent=c['hit'],present_queries=present,absent_queries=q-present,
                  calibration_absent_queries=cal,repeats=c['repeats'],build_repeats=0)
    for k,v in expected.items():need(original.integer(row[k])==v,'Wrong workload '+k)
    need(original.integer(row['false_positives'])<=q-present and original.integer(row['calibration_false_positives'])<=cal,'Impossible FP count')
    for k in ('result_checksum','inserted_checksum','query_checksum','calibration_checksum'):need(original.integer(row[k])<1<<64,'Invalid full checksum')
    need(row['query_phase_order']==original.schedule(c['seed'],c['repeats']),'Changed six-permutation phase order')
    public=c['filter']not in NATIVE;unit=4 if public else 8
    for mode,count in zip(MODES,(0,1,4096)):
        need(original.integer(row[mode+'_scratch_bytes'])==unit*count,'Wrong exact scratch')
        trials=[float(s)for s in row[mode+'_trials_ns'].split('|')]
        need(len(trials)==6 and all(math.isfinite(x)and x>0 for x in trials),'Invalid/missing six trials')
        need([float(row[mode+s])for s in ('_ns','_min_ns','_max_ns')]==[statistics.median(trials),min(trials),max(trials)],'Wrong timing summaries')
    need(all(row[k]=='nan'for k in ('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns')),'Construction remains disabled')
    need(original.integer(row['build_hash_scratch_bytes'])==(0 if public else 8*n)and row['filter_build_scratch_bytes']=='0','Wrong build scratch')
    object_bytes=json.loads((HERE/'object-bytes.json').read_text())[c['filter']]
    need(row['adapter_object_bytes']==object_bytes,'Actual compiled adapter size changed')
    return row

def parity(rows,complete=False):
    inputs={};apis={};mappings={}
    geometry_fields=[k for k in GEOMETRY if k not in ('surface','implementation_origin','public_metadata','requested_bpk')]
    for row in rows:
        stream=tuple(row[k]for k in ('keys','queries','seed','hit_percent','calibration_absent_queries'))
        digests=tuple(row[k]for k in ('inserted_checksum','query_checksum','calibration_checksum'))
        need(inputs.get(stream,digests)==digests,'Input streams differ');inputs[stream]=digests
        fields=tuple(row[k]for k in SEMANTIC+geometry_fields)
        api=(row['filter'],row['keys'],row['requested_bpk'])
        mapping=(geometry_key(row['filter']),row['keys'],row['requested_bpk'])
        for groups,key in ((apis,api),(mappings,mapping)):
            need(groups.get(key,fields)==fields,'Alias/round semantic or allocation mismatch');groups[key]=fields
    if complete:need(len(rows)==160 and len(apis)==80 and len(mappings)==48,'Incomplete unpooled geometry coverage')
    return len(apis),len(mappings)

def compare_old(row):
    key=f'{geometry_key(row["filter"])}/{int(row["keys"]).bit_length()-1}/{row["requested_bpk"]}'
    old=json.loads((HERE/'semantic-references.json').read_text()).get(key)
    if old is None:
        need(row['filter']in NATIVE[4:],'Missing prespecified old public/native reference');return False
    need({k:row[k]for k in SEMANTIC}==old,'Old full semantic reproduction changed')
    return True

def audit_rows(metadata,raws,binary):
    expected=plan();records=metadata['commands'];saved=metadata['rows']
    need(len(records)==len(saved)==len(raws)==len(expected)==160,'Incomplete/extra finite ledger')
    rows=[];reproductions=0
    for i,(item,record,stored,raw)in enumerate(zip(expected,records,saved,raws,strict=True)):
        label=f'row{i:03d}';c=item['case']
        need(record['label']==label and record['round']==item['round']and record['case']==c,'Changed row order')
        need(record['command']==command(binary,c)and record['complete']is True and record['returncode']==0,'Failed/wrong invocation')
        need(record['stdout']==label+'.stdout'and record['stderr']==label+'.stderr'and not raw['stderr'],'Raw artifact mismatch')
        row=dict(round=item['round'],**validate(original.parse_one(raw['stdout']),c))
        need(row==stored,'Raw/ledger row mismatch');reproductions+=compare_old(row);rows.append(row)
    need(reproductions==144,'Missing old semantic controls')
    parity(rows,True);return rows
