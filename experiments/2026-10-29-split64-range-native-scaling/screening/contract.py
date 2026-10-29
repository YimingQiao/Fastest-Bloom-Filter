"""Exact native scaling ledger and row guards; no ranking or sample pooling."""
import importlib.util
import math
from pathlib import Path

_spec=importlib.util.spec_from_file_location('native_preflight_contract',Path(__file__).resolve().parents[1]/'preflight/contract.py')
_tiny=importlib.util.module_from_spec(_spec);_spec.loader.exec_module(_tiny)
FIELDS,METRICS,need,parse,order,scratch,semantic=(_tiny.FIELDS,_tiny.METRICS,_tiny.need,_tiny.parse,_tiny.order,_tiny.scratch,_tiny.semantic)
CPUS=[3,5,7,9,11,13,15,17]

def cases(protocol):
    need(protocol['source_anchor']=='5fd487fe3381ce05be2ba823a6137107f4108854','Wrong native source anchor')
    for key,value in dict(key_powers=[16,25],actual_budgets_bpk=[16,24,32],threads=[1,4,8],query_power=22,repeats=4,seed=42,hit_percent=50,calibration_power=24,socket_cpus=CPUS,driver_cpu=3,socket=1,numa_node=1,expected_commands=36,expected_rows=60).items():
        need(protocol[key]==value,'Changed fixed protocol '+key)
    return [dict(language=language,key_power=n,budget_bpk=cap,threads=t,cpus=CPUS[:t],filters=['Split64Range']if cap==24 else['Split64','Split64Range'])
            for n in (16,25)for cap in (16,24,32)for t in (1,4,8)for language in ('cpp','rust')]

def command(binary,case,protocol):
    cpus=','.join(map(str,case['cpus']))
    return ['taskset','-c',cpus,'numactl','--physcpubind='+cpus,'--membind=1',str(binary),str(case['key_power']),str(case['budget_bpk']),str(protocol['query_power']),str(case['threads']),str(protocol['repeats']),str(protocol['seed']),str(protocol['hit_percent']),str(protocol['calibration_power']),','.join(case['filters']),cpus]

def validate(rows,case,protocol):
    n,q,cal=1<<case['key_power'],1<<protocol['query_power'],1<<protocol['calibration_power']
    language,cap,t=case['language'],case['budget_bpk'],case['threads']
    seed,hit,reps=protocol['seed'],protocol['hit_percent'],protocol['repeats']
    need([r['filter']for r in rows]==order(case['filters'],n,q,seed,hit),'Wrong source-derived filtered row order/count')
    present=q//100*hit+min(q%100,hit);base=_tiny.next_value(seed)[1]%((1<<32)-n-q)
    expected=dict(keys=n,queries=q,requested_bpk=cap,filter_bytes=n*cap//8,core_budget=t,build_workers=t,query_workers=t,
      estimated_build_scratch_bytes=scratch(language,n,t),repeats=reps,seed=seed,hit_percent=hit,present_queries=present,
      absent_queries=q-present,calibration_absent_queries=cal,key_base=base,
      build_spawned_workers_per_pass=t-1 if language=='cpp'else 0 if t==1 else t,
      query_spawned_workers=t-1 if language=='cpp'else 0 if t==1 else t)
    for row in rows:
        need(list(row)==FIELDS,'Wrong complete CSV schema')
        for key,value in expected.items():need(row[key]==str(value),'Wrong exact worker/geometry/workload '+key)
        need(float(row['actual_bpk'])==cap,'Wrong actual allocation')
        need(row['language']==language and row['scheduler_model']==('caller_worker0'if language=='cpp'else'scoped_workers_plus_caller'),'Wrong public scheduler')
        need(row['input_mode']=='prehashed64'and row['query_contract']=='whole_array_native_api'and row['phase_order']=='build_williams4_query_alternating'and row['parallel_first_touch']=='insert_cpu3_allocate_allowed_set','Changed native timing contract')
        need(0<=int(row['false_positives'])<=q-present and 0<=int(row['calibration_false_positives'])<=cal and 0<=int(row['result_checksum'])<1<<64,'Bad full-output/calibration counts')
        for metric in METRICS:
            trial=list(map(float,row[metric+'_trials_ns'].split('|')))
            need(len(trial)==reps and all(math.isfinite(x)and x>0 for x in trial),'Invalid full trial vector')
            sorted_trial=sorted(trial);median=(sorted_trial[1]+sorted_trial[2])/2
            for suffix,value in (('_ns',median),('_min_ns',min(trial)),('_max_ns',max(trial))):
                need(math.isclose(float(row[metric+suffix]),value,rel_tol=1e-12,abs_tol=1e-12),'Wrong trial summary')
    return rows

def complete(all_rows,protocol):
    ledger=cases(protocol);offset=0;reference={};quality={}
    for case in ledger:
        count=len(case['filters']);rows=validate(all_rows[offset:offset+count],case,protocol);offset+=count
        for row in rows:
            identity=(row['filter'],row['keys'],row['requested_bpk'],row['seed'])
            answer=semantic(row)
            need(identity not in reference or reference[identity]==answer,'Cross-T/language complete semantics differ')
            reference[identity]=answer
            # Retain each language separately; repeated T is one original denominator.
            quality[(row['language'],)+identity]=(row['calibration_absent_queries'],row['calibration_false_positives'])
    need(offset==len(all_rows)==60 and len(reference)==10 and len(quality)==20,'Wrong complete60 coverage')
    return dict(rows=60,commands=36,semantic_geometries=10,language_quality_records=20,pooled_samples=False)
