"""Exact48 real configurations and cheap spy forwarding coverage, no timing."""
import json

def need(ok,message):
    if not ok:raise ValueError(message)

def cases():
    result=[]
    for family,above,large in (('Split64',524288,67108864),('Split64Range',262208,100663296)):
        descriptions=[(262144,65536,1,0,False),(262144,65537,4,0,False),(262144,65536,4,131072,True),
                      (above,65536,8,0,False),(large,65536,0,0,False),(large,65536,8,large//2,True)]
        for i,(size,n,t,history,hotspot)in enumerate(descriptions):
            result.append(dict(family=family,case=i,bytes=size,batch_n=n,requested=t,history_n=history,hotspot=hotspot))
    return result

def validate_protocol(value):
    need(value['real_case_ledger']==cases(),'Changed fixed minimal case ledger')
    for key,expected in dict(languages=['cpp','rust'],modes=['normal','asan'],expected_real_rows=48,expected_native_filter_lifetimes=144,
      expected_semantic_geometries=12,performance_run=False,quality_calibration_run=False).items():need(value[key]==expected,'Changed correctness protocol '+key)
    need(value['spy']['cases_per_executable']==336 and value['spy']['forwarded_calls_per_case']==6 and value['spy']['total_spy_cases']==1344,'Changed spy scope')
    need(value['scheduler']['requested_T_cases']==[1,4,4,8,0,8],'Changed representative requests')
    return value

def scratch(language,n,w):
    if w==1:return 0
    return n*8+w*((w+7)//8)*64+(w+1)*8+(w*w*24+w*48 if language=='rust'else 0)

def validate_real(text,language):
    rows=[json.loads(line)for line in text.splitlines()];need(len(rows)==12,'Exactly12 real cases required')
    for row,case in zip(rows,cases()):
        effective=1 if case['case']in (0,2)else case['requested']
        auto=row.get('native_auto_workers');limit=min(case['batch_n']//4096,case['bytes']//64,1024)
        need(type(auto)is int and 1<=auto<=limit,'Invalid original native automatic worker observation')
        cw=auto if case['requested']==0 else max(1,min(case['requested'],limit))
        w=auto if effective==0 else max(1,min(effective,limit))
        fixed=dict(language=language,**case,query_n=32771,control_effective=case['requested'],candidate_effective=effective,
          native_auto_workers=auto,candidate_auto_workers=1 if case['case']in (0,2)else auto,
          control_workers=cw,candidate_workers=w,control_scratch=scratch(language,case['batch_n'],cw),candidate_scratch=scratch(language,case['batch_n'],w),
          checked_history_per_variant=case['history_n'],checked_new_per_variant=case['batch_n'],variants=3,full_mixed_checks_per_variant=2,performance_run=False)
        need(set(row)==set(fixed)|{'checksum','positives'},'Wrong full real-row schema')
        for k,value in fixed.items():need(type(row[k])is type(value)and row[k]==value,'Wrong real-case accounting '+k)
        need(type(row['checksum'])is int and 0<=row['checksum']<1<<64,'Bad complete dense checksum')
        need(type(row['positives'])is int and 0<=row['positives']<=32771,'Bad dense output count')
    return rows

def validate_spy(text,language):
    lines=text.splitlines();need(len(lines)==1,'Expected one spy report')
    value=json.loads(lines[0]);expected=dict(language=language,spy_cases=336,forwarded_calls=2016,performance_run=False)
    need(value==expected and all(type(value[k])is type(v)for k,v in expected.items()),'Wrong forwarding spy coverage')
    return value

def semantic(row):
    excluded={'language','control_scratch','candidate_scratch','native_auto_workers','candidate_auto_workers'}
    if row['requested']==0:excluded.update(('control_workers','candidate_workers'))
    return {k:v for k,v in row.items()if k not in excluded}

def accounting(row):
    return {k:row[k]for k in ('native_auto_workers','candidate_auto_workers','control_workers','candidate_workers','control_scratch','candidate_scratch')}
