"""Fixed26 bulk cases/296 rows; old142 semantic controls and six new quality streams."""
import csv
import io
import json
import math
from pathlib import Path
import sys
HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
sys.path.insert(0,str(STAGE/'preflight'))
from source_guard import ROOT,PARENT,OLD,need,sha,save,blob
from checks import schema,SEMANTIC,RNG
from lease import require_lease
from validate_rows import validate
CANDIDATE='FourSectorRange12Experiment'

def protocol():return json.loads((STAGE/'protocol.json').read_text())
def names():return json.loads((STAGE/'registry.json').read_text())
def parent_rows():return list(csv.DictReader(io.StringIO((PARENT/'screen/results.csv').read_text())))
def cases():return protocol()['cases']
def command(binary,case):
    p=protocol();n=1<<case['key_power']
    return[str(binary),str(case['key_power']),str(case['budget_bpk']),str(p['hit_percent']),str(p['query_power']),str(case['batch']),str(p['repeats']),str(p['seed']),','.join(case['filters']),str(n),str(p['calibration_power']),p['mode'],str(p['build_repeats'])]
def order(case):
    p=protocol();n=1<<case['key_power'];q=1<<p['query_power'];hit=q//100*p['hit_percent']+min(q%100,p['hit_percent'])
    r=RNG((p['seed']+(n+q+hit-1)*0x9e3779b97f4a7c15)&((1<<64)-1))
    out=[name for name in names()if name in case['filters']]
    for i in range(len(out),1,-1):j=r.next()%i;out[i-1],out[j]=out[j],out[i-1]
    return out

def geometry(case):
    n=1<<case['key_power'];cap=case['budget_bpk'];parent={r['filter']:r for r in parent_rows()if int(r['keys'])==n and int(r['requested_bpk'])==cap}
    expected={name:parent[name]for name in case['filters']if name!=CANDIDATE}
    if CANDIDATE in case['filters']:
        amount=n*cap//8
        expected[CANDIDATE]=dict(filter=CANDIDATE,budget_bytes=str(amount),filter_bytes=str(amount),logical_bytes=str(amount),geometry_kind='project_four_range24_mapping',unit_bytes='64',unit_count=str(amount//64),effective_probes='12',probe_policy='fixed',constructor_argument=str(amount),page_level='0',native_constructor_bpk='0',implementation_origin='project_experiment',calibration_identity=f'four-sector-range12/n{n}/bytes{amount}/seed42')
    return expected

def rows_from(text):
    rows=list(csv.DictReader(io.StringIO(text)));need(rows and all(None not in row and None not in row.values()for row in rows),'Malformed CSV');return rows

def validate_case(rows,case):
    p=protocol();need(list(rows[0])==schema(),'Changed CSVschema');need([r['filter']for r in rows]==order(case),'Changed source-derived job order')
    expected=geometry(case)
    validate(rows,expected,power=case['key_power'],budget=case['budget_bpk'],query_power=p['query_power'],batch=case['batch'],repeats=p['repeats'],seed=p['seed'],calibration_power=p['calibration_power'])
    for row in rows:
        if row['filter']==CANDIDATE:continue
        old=expected[row['filter']]
        need({k:row[k]for k in SEMANTIC}=={k:old[k]for k in SEMANTIC},'Retained142 semantic control changed '+row['filter'])
    return expected

def wilson(fp,n):
    need(0<=fp<=n and n>0,'Invalid sample');z=1.959963984540054;v=z*z;p=fp/n;c=(p+v/(2*n))/(1+v/n);h=z*math.sqrt(p*(1-p)/n+v/(4*n*n))/(1+v/n)
    return(0.0 if fp==0 else max(0,c-h),1.0 if fp==n else min(1,c+h))

def quality(rows):
    groups={};api_geometries={}
    for case in cases():
        selected=[r for r in rows if int(r['keys'])==1<<case['key_power']and int(r['requested_bpk'])==case['budget_bpk']and int(r['batch'])==case['batch']]
        expected=validate_case(selected,case)
        for row in selected:
            identity=expected[row['filter']]['calibration_identity'];sample=tuple(int(row[k])for k in('keys','filter_bytes','seed','calibration_absent_queries','calibration_false_positives','false_positives','result_checksum'))
            group=groups.setdefault(identity,dict(sample=sample,apis=set(),candidate=row['filter']==CANDIDATE))
            need(group['sample']==sample and group['candidate']==(row['filter']==CANDIDATE),'Known mapping/batch semantic drift');group['apis'].add(row['filter'])
            api_geometries[(row['filter'],int(row['keys']),int(row['requested_bpk']))]=identity
    need(len(rows)==296 and len(groups)==98 and len(api_geometries)==148,'Wrong full296/98mapping/148geometry set')
    result=[]
    for identity,group in sorted(groups.items()):
        n,allocated,seed,total,fp,mixed,checksum=group['sample'];low,high=wilson(fp,total)
        result.append(dict(calibration_identity=identity,apis=sorted(group['apis']),candidate=group['candidate'],keys=n,filter_bytes=allocated,actual_bpk=8*allocated/n,seed=seed,negatives=total,false_positives=fp,mixed_false_positives=mixed,result_checksum=checksum,point_fpr=fp/total,wilson95_low=low,wilson95_high=high,passes_1pct=high<=.01,passes_0_1pct=high<=.001,passes_0_01pct=high<=.0001,pooled=False))
    need(sum(r['candidate']for r in result)==6,'Missing fixed candidate geometries')
    return dict(mapping_records=result,retained_mapping_count=92,candidate_mapping_count=6,api_geometry_count=148,repeated_batches_add_samples=False,prior_K12_pilot_counts_reproduced=False)

def audit(output,meta,binary,commit,final=True):
    import re
    from freeze import PROOF,BINARY_SHA
    proof=json.loads((STAGE/'CALLER_FREEZE.json').read_text());published=json.loads((HERE/'protocol.json').read_text())
    need(re.fullmatch(r'[0-9a-f]{40}',commit)is not None and meta['proof_commit']==PROOF and meta['executable_sha256']==BINARY_SHA,'Wrong source/proof/binary identity')
    need(meta['host']==proof['host']and meta['environment']==proof['environment'],'Changed validated host/environment')
    need(meta['driver_protocol_sha256']==sha(HERE/'protocol.json')and meta['numa_policy']==published['numa_policy'],'Changed driver protocol/placement claim')
    fds=meta['lease'].get('inherited_lock_descriptors')
    need(isinstance(fds,list)and bool(fds)and all(type(fd)is int and fd>=0 for fd in fds)and len(set(fds))==len(fds),'Malformed inherited lease evidence')
    need(meta['source_commit']==commit and meta['executable']==str(binary)and meta['executable_sha256']==sha(binary),'Changed exact source/binary metadata')
    need(meta['protocol_sha256']==sha(STAGE/'protocol.json')and meta['affinity']==[3]and meta['lease']['cpu']==3 and meta['lease']['socket']==1 and meta['lease']['lock_path']=='/tmp/fastest-bf-socket1.lock'and bool(meta['lease']['inherited_lock_descriptors']),'Changed protocol/lease metadata')
    if final:need(meta['complete']is True and meta['final_frozen_inputs_equal']is True,'Incomplete final screen')
    need(isinstance(meta['cases'],list)and len(meta['cases'])==26,'Missing fullcase ledger')
    rows=[];inventory={'metadata.json','results.csv','quality.json'}
    for i,(case,record)in enumerate(zip(cases(),meta['cases'],strict=True)):
        need(record['case']==case and record['command']==command(binary,case)and record['expected_order']==order(case),'Changed fixed command/order')
        need(record['complete']is True and record['returncode']==0,'Incomplete/failed case')
        for stream in('stdout','stderr'):
            name=f'case-{i:02d}.'+stream;need(record[stream]==name and sha(output/name)==record[stream+'_sha256'],'Raw stream drift');inventory.add(name)
        need(not(output/record['stderr']).read_bytes(),'Unexpected diagnostics')
        current=rows_from((output/record['stdout']).read_text());validate_case(current,case);need(record['rows']==len(current),'Changed rowcount');rows.extend(current)
    need(rows==rows_from((output/'results.csv').read_text()),'Raw/aggregate disagreement');q=quality(rows)
    need(q==json.loads((output/'quality.json').read_text()),'Quality identity/interval drift')
    counts=dict(cases=26,rows=296,retained_control_rows=284,candidate_rows=12,retained_quality_records=92,candidate_quality_records=6,pooled=False)
    if final:need(meta['counts']==counts and meta['results_sha256']==sha(output/'results.csv')and meta['quality_sha256']==sha(output/'quality.json'),'Changed finalcounts/hash')
    need({p.name for p in output.iterdir()if p.is_file()}==inventory,'Unexpected raw inventory');return rows,counts
