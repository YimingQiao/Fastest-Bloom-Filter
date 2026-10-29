"""Finite accuracy-only row contract; no workload/planner execution on import."""
import csv
import io
import json
import math
from pathlib import Path
from derive_selection import GEOMETRY,SEMANTIC,CONFIGS,need

HERE=Path(__file__).resolve().parent
def selection():return json.loads((HERE/'selection.json').read_text())
def cases():return selection()['cases']
def names():return [c+'/artifact_pimpl'for c in CONFIGS]
def command(binary,case,*,tiny=False,action='--check'):
    return [str(binary),action,case['filter'],str(16 if tiny else case['power']),str(case['cap']),
            str(12 if tiny else 22),'50','42',str(10 if tiny else 24),'0',case['policy']]
def parse(text):
    rows=list(csv.DictReader(io.StringIO(text)))
    need(len(rows)==1 and None not in rows[0] and None not in rows[0].values(),'Expected exactly one complete CSV row')
    return rows[0]
def comparable(row):
    value=dict(row)
    if 'public_metadata'in value:value['public_metadata']=json.loads(value['public_metadata'])
    return value
def untimed(row,*,power,qpower,calpower):
    n=1<<power;q=1<<qpower;present=q//100*50+min(q%100,50)
    need(row['worker']=='legacy'and row['surface']=='artifact_pimpl'and row['implementation_origin']=='external',
         'Wrong API surface/origin')
    need(row['key_domain']=='raw_u32'and int(row['keys'])==n and int(row['queries'])==q,'Wrong workload')
    need(int(row['seed'])==42 and int(row['hit_percent'])==50 and int(row['present_queries'])==present and
         int(row['absent_queries'])==q-present,'Wrong fixed query stream')
    need(int(row['calibration_absent_queries'])==1<<calpower,'Wrong independent negative count')
    for k,total in [('false_positives',q-present),('calibration_false_positives',1<<calpower)]:
        need(0<=int(row[k])<=total,'Invalid false-positive count')
    need(row['repeats']=='0'and row['build_repeats']=='0'and row['query_phase_order']=='untimed','Timing forbidden')
    for mode,scratch in [('raw_single',0),('raw_batch1',4),('raw_batch4096',16384)]:
        for suffix in ['_ns','_trials_ns','_min_ns','_max_ns']:
            need(row[mode+suffix]=='nan','Unexpected timing trial')
        need(int(row[mode+'_scratch_bytes'])==scratch,'Wrong exact compact scratch')
    for key in ['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:
        need(row[key]=='nan','Unexpected build timing')
    need(row['build_hash_scratch_bytes']=='0'and row['filter_build_scratch_bytes']=='0','Unexpected scratch')
    for key in ['result_checksum','inserted_checksum','query_checksum','calibration_checksum']:
        need(0<=int(row[key])<1<<64,'Missing complete digest')
    return row
def validate(row,case):
    if case['status']=='unsupported':
        expected=dict(status='unsupported',filter=case['filter'],policy=case['policy'],keys=str(1<<case['power']),
                      requested_bpk=str(case['cap']),budget_bytes=str((1<<case['power'])*case['cap']//8))
        need(row==expected,'Unsupported point changed or replaced');return row
    untimed(row,power=case['power'],qpower=22,calpower=24)
    need(comparable({k:row[k]for k in GEOMETRY})==comparable(case['geometry']),'Changed fixed public geometry')
    if case['policy']=='original':
        need({k:row[k]for k in SEMANTIC}==case['old_semantics'],'Old seed42 reproduction changed')
    return row
def wilson(fp,n):
    need(type(fp)is int and type(n)is int and 0<=fp<=n and n>0,'Invalid binomial sample')
    z=1.959963984540054;v=z*z;p=fp/n;d=1+v/n;c=(p+v/(2*n))/d
    h=z*math.sqrt(p*(1-p)/n+v/(4*n*n))/d
    return (0.0 if fp==0 else max(0.0,c-h),1.0 if fp==n else min(1.0,c+h))
def quality(rows):
    need(len(rows)==36,'Missing fixed accuracy point')
    result=[]
    for case,row in zip(cases(),rows,strict=True):
        validate(row,case)
        item={k:case[k]for k in ['filter','power','cap','policy','status']}
        item.update(pooled=False,old_reproduction=case['policy']=='original')
        if case['status']=='supported':
            n=int(row['calibration_absent_queries']);fp=int(row['calibration_false_positives']);lo,hi=wilson(fp,n)
            item.update(filter_bytes=int(row['filter_bytes']),logical_bytes=int(row['logical_bytes']),
                        negatives=n,false_positives=fp,point_fpr=fp/n,wilson95_low=lo,wilson95_high=hi,
                        passes_1pct=hi<=.01,passes_0_1pct=hi<=.001,passes_0_01pct=hi<=.0001)
        result.append(item)
    return result
