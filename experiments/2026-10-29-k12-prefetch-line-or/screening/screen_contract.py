"""Fixed24 processes/72 rows, every construction sample and quality identity."""
import csv,io,json,math,statistics,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;BASE=HERE.parent
sys.path.insert(0,str(BASE/'caller'))
from contract import TYPES,need,METRICS,SEMANTICS
from placement import PREFIX,validate as validate_placement
MASK=(1<<64)-1
SEEDS=(15485863,32452843,49979687)
COUNTS=dict(cases=24,rows=72,build_trial_vectors=288,build_metric_samples=2016,
            query_trial_vectors=144,query_metric_samples=288,api_quality_records=36,mapping_quality_records=24,
            construction_contrasts=288)
GEOMETRY=('budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes',
          'probe_policy','constructor_argument','page_level','native_constructor_bpk','implementation_origin')

def plan():
    result=json.loads((BASE/'plan.json').read_text())['cases']
    need(len(result)==24 and [r['index']for r in result]==list(range(24)),'Wrong frozen ledger')
    need({(r['keys_power'],r['insert_chunk'],r['seed'])for r in result}=={(n,c,s)for n in (16,20,22,25)for c in (4,'whole_input')for s in SEEDS},'Changed finite workload set')
    for item in result:
        need(item['filter_order']==list(TYPES[SEEDS.index(item['seed']):]+TYPES[:SEEDS.index(item['seed'])]),'Changed Latin order')
        need(item['expected_bytes']==3*item['keys']and item['existing_prefetch_branch']==(item['expected_bytes']>2097152),'Changed existing dispatch')
    return result

def splitmix_first(seed):
    z=(seed+0x9e3779b97f4a7c15)&MASK;z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK
    z=((z^(z>>27))*0x94d049bb133111eb)&MASK;return z^(z>>31)

def intervals(item):
    n,q=1<<item['keys_power'],1<<item['query_power'];cal=(1<<item['calibration_power'])if item['calibration_power']else 0
    base=splitmix_first(item['seed'])%((1<<32)-n-q)
    need(0<=base<base+n<=base+n+q<=base+n+q+cal<=1<<64,'Overlapping or wrapped source intervals')
    return dict(evidence='Reconstructed from pinned caller SplitMix64/seed; not emitted input digests',key_base=base,
                inserted_half_open=[base,base+n],mixed_absent_superset_half_open=[base+n,base+n+q],
                calibration_half_open=[base+n+q,base+n+q+cal])

def command(binary,item):
    rotation=SEEDS.index(item['seed'])
    return PREFIX+[str(binary),*map(str,[item['keys_power'],24,item['hit_percent'],item['query_power'],
           item['query_batch'],item['query_repeats'],item['seed']]),','.join(TYPES),
           str(item['insert_batch']),str(item['calibration_power']),'full',str(item['build_repeats']),f'latin{rotation}']

def parse(text,item):
    reader=csv.DictReader(io.StringIO(text));need(reader.fieldnames and len(set(reader.fieldnames))==len(reader.fieldnames),'Duplicate/missing CSV header')
    rows=list(reader);need(len(rows)==3 and [r.get('filter')for r in rows]==item['filter_order'],'Incomplete/wrong three-filter order')
    n,q=1<<item['keys_power'],1<<item['query_power'];present=q//100*item['hit_percent']+min(q%100,item['hit_percent'])
    cal=(1<<item['calibration_power'])if item['calibration_power']else 0
    for row in rows:
        need(None not in row and all(v is not None for v in row.values()),'Malformed CSV width')
        range_type=row['filter']==TYPES[2]
        expected=dict(keys=n,queries=q,requested_bpk=24,filter_bytes=n*3,hash_bits=64,hit_percent=item['hit_percent'],
            present_queries=present,absent_queries=q-present,batch=item['query_batch'],repeats=item['query_repeats'],seed=item['seed'],
            insert_batch=item['insert_batch'],filter_build_scratch_bytes=0,harness_hash_scratch_bytes=8*max(item['insert_batch'],item['query_batch']),
            calibration_absent_queries=cal,query_repeats=item['query_repeats'],build_repeats=item['build_repeats'],
            budget_bytes=n*3,logical_bytes=n*3,unit_bytes=64,unit_count=n*3//64,effective_probes=8 if range_type else 12,
            constructor_argument=n*3,page_level=0,native_constructor_bpk=0)
        for key,value in expected.items():need(int(row[key])==value,'Changed row field '+key)
        for key,value in dict(language='cpp',input_mode='prehashed',measurement_mode='full',budget_mode='exact_backing_bytes',
             geometry_kind='native_split64_range'if range_type else'project_four_range24_mapping',probe_policy='fixed',implementation_origin='project_experiment').items():
            need(row[key]==value,'Changed contract field '+key)
        need(float(row['actual_bpk'])==24 and 0<=int(row['result_checksum'])<=MASK,'Invalid size/checksum')
        fp=int(row['false_positives']);need(0<=fp<=q-present and float(row['fpr'])==fp/(q-present),'Invalid mixed FPR')
        need(0<=int(row['calibration_false_positives'])<=cal,'Invalid calibration count')
        phase=';'.join('H>P'if(item['seed']+i)&1 else'P>H'for i in range(item['query_repeats']))
        need(row['query_phase_order']==phase,'Changed query phase schedule')
        for vector,metric in METRICS.items():
            values=json.loads(row[vector]);count=item['query_repeats']if'lookup'in vector else item['build_repeats']
            need(len(values)==count and all(type(v)in(int,float)and math.isfinite(v)and v>0 for v in values),'Invalid trial vector')
            need(math.isclose(statistics.median(values),float(row[metric]),rel_tol=1e-12,abs_tol=1e-12),'Trial/median differs')
            if'lookup'in vector:
                need(float(row[metric.replace('_ns','_min_ns')])==min(values)and float(row[metric.replace('_ns','_max_ns')])==max(values),'Query endpoints differ')
        for prefix in ('','hash_'):
            insert=json.loads(row[prefix+'insert_trials_ns']);total=json.loads(row['allocate_'+prefix+'insert_trials_ns'])
            need(all(a>=b for a,b in zip(total,insert)),'Nested allocation interval too short')
    aliases=[r for r in rows if r['filter']!=TYPES[2]]
    need(tuple(aliases[0][k]for k in SEMANTICS+GEOMETRY)==tuple(aliases[1][k]for k in SEMANTICS+GEOMETRY),'K12 alias semantics differ')
    return rows

def csv_text(rows):
    stream=io.StringIO(newline='');writer=csv.DictWriter(stream,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows);return stream.getvalue()

def complete(rows):
    need(len(rows)==72,'Incomplete formal rows');api={};mapping={}
    for row in rows:
        key=(row['keys'],row['seed'],row['filter']);value=tuple(row[k]for k in SEMANTICS+GEOMETRY)
        need(api.get(key,value)==value,'Cross-chunk API output/geometry/calibration differs');api[key]=value
        family='Range'if row['filter']==TYPES[2]else'K12';key=(row['keys'],row['seed'],family)
        need(mapping.get(key,value)==value,'Alias mapping observation differs');mapping[key]=value
    need(len(api)==36 and len(mapping)==24,'Wrong unpooled quality identities')
    return dict(COUNTS)

def audit(directory,metadata,binary,source_commit,sha):
    need(metadata['complete']is True and metadata['source_commit']==source_commit,'Wrong/incomplete source')
    need(metadata['binary']['path']==str(binary)and metadata['plan']==plan(),'Changed binary/plan')
    validate_placement(metadata['lease']);need(metadata['child_prefix']==PREFIX,'Wrong child placement')
    need(metadata['compiler_runs']==0 and metadata['query_ranking']is False,'Changed execution scope')
    need(len(metadata['cases'])==24,'Incomplete command ledger');rebuilt=[]
    for item,record in zip(plan(),metadata['cases']):
        label=f"case-{item['index']:02d}"
        need(record['case']==item and record['command']==command(binary,item)and record['complete']is True and record['returncode']==0,'Changed/failed invocation')
        need(record['raw_intervals']==intervals(item),'Changed source-derived intervals')
        for stream in ('stdout','stderr'):
            need(record[stream]==label+'.'+stream and sha(directory/record[stream])==record[stream+'_sha256'],'Changed raw log')
        need(not(directory/record['stderr']).read_bytes(),'Unexpected stderr')
        rebuilt.extend(parse((directory/record['stdout']).read_text(),item))
    need(rebuilt==json.loads((directory/'rows.json').read_text()),'Raw/JSON mismatch')
    need(rebuilt==list(csv.DictReader(io.StringIO((directory/'results.csv').read_text()))),'Raw/CSV mismatch')
    counts=complete(rebuilt);need(metadata['counts']==counts,'Wrong complete counts');return counts
