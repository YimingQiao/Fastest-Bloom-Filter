"""Small native-API fixture checks, no latency ranking."""
import csv
import io
import math

METRICS=('serial_insert','parallel_insert','serial_allocate_insert','parallel_allocate_insert','serial_lookup','parallel_lookup')
PREFIX='language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,core_budget,build_workers,query_workers,estimated_build_scratch_bytes,repeats,seed,hit_percent,present_queries,absent_queries,false_positives,result_checksum,calibration_absent_queries,calibration_false_positives,key_base,input_mode,scheduler_model,build_spawned_workers_per_pass,query_spawned_workers,query_contract,phase_order,parallel_first_touch'.split(',')
FIELDS=PREFIX+[m+s for m in METRICS for s in ('_ns','_min_ns','_max_ns','_trials_ns')]
MASK=(1<<64)-1
STEP=0x9e3779b97f4a7c15

def need(ok,message):
    if not ok:raise ValueError(message)

def next_value(state):
    state=(state+STEP)&MASK;z=((state^(state>>30))*0xbf58476d1ce4e5b9)&MASK;z=((z^(z>>27))*0x94d049bb133111eb)&MASK
    return state,z^(z>>31)

def order(names,n,q,seed,hit):
    present=q//100*hit+min(q%100,hit);state=(seed+STEP*(n+present+q-1))&MASK;names=list(names)
    for count in range(len(names),1,-1):
        state,value=next_value(state);i=value%count;names[count-1],names[i]=names[i],names[count-1]
    return names

def parse(text):
    reader=csv.DictReader(io.StringIO(text));need(reader.fieldnames==FIELDS,'Wrong complete native CSV schema');rows=list(reader)
    need(rows and all(None not in r and all(v is not None for v in r.values()) for r in rows),'Empty/malformed native CSV')
    return rows

def scratch(language,n,w):
    if w==1:return 0
    counts=w*((w+7)//8)*64;starts=(w+1)*8
    return n*8+counts+starts+(w*w*24+w*48 if language=='rust' else 0)

def validate(rows,language,cap,t):
    n,q,seed,hit,reps,cal=1<<16,1<<14,42,50,4,1<<12
    names=['Split64Range'] if cap==24 else ['Split64','Split64Range']
    need([r['filter']for r in rows]==order(names,n,q,seed,hit),'Wrong filtered source-derived order')
    present=q//100*hit+min(q%100,hit);base=next_value(seed)[1]%((1<<32)-n-q)
    expected=dict(keys=n,queries=q,requested_bpk=cap,filter_bytes=n*cap//8,actual_bpk=cap,core_budget=t,build_workers=t,
      query_workers=t,estimated_build_scratch_bytes=scratch(language,n,t),repeats=reps,seed=seed,hit_percent=hit,
      present_queries=present,absent_queries=q-present,calibration_absent_queries=cal,key_base=base,
      build_spawned_workers_per_pass=(t-1 if language=='cpp' else 0 if t==1 else t),
      query_spawned_workers=(t-1 if language=='cpp' else 0 if t==1 else t))
    for row in rows:
        need(list(row)==FIELDS,'Wrong field order')
        for field,value in expected.items():need(float(row[field])==value,'Wrong worker/capacity/count '+field)
        need(row['language']==language and row['scheduler_model']==('caller_worker0'if language=='cpp'else'scoped_workers_plus_caller'),'Wrong scheduler model')
        need(row['input_mode']=='prehashed64' and row['query_contract']=='whole_array_native_api' and row['phase_order']=='build_williams4_query_alternating'
          and row['parallel_first_touch']=='insert_cpu3_allocate_allowed_set','Changed native timer contract')
        need(0<=int(row['false_positives'])<=q-present and 0<=int(row['calibration_false_positives'])<=cal and 0<=int(row['result_checksum'])<=MASK,'Bad output counts')
        for metric in METRICS:
            values=list(map(float,row[metric+'_trials_ns'].split('|')))
            need(len(values)==reps and all(math.isfinite(v)and v>0 for v in values),'Missing/invalid trial vector')
            sorted_values=sorted(values);median=(sorted_values[1]+sorted_values[2])/2
            for suffix,value in (('_ns',median),('_min_ns',min(values)),('_max_ns',max(values))):
                need(math.isclose(float(row[metric+suffix]),value,rel_tol=1e-12,abs_tol=1e-12),'Wrong timing summary')
    return rows

def semantic(row):
    fields=('filter','keys','queries','requested_bpk','filter_bytes','actual_bpk','hit_percent','present_queries','absent_queries','false_positives','result_checksum','calibration_absent_queries','calibration_false_positives','key_base','input_mode')
    return tuple(row[f] for f in fields)
