"""Fixed24 held-out rows, corrected exact job order, unpooled quality gates."""
import csv
import io
import json
import math
from pathlib import Path
import sys

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
sys.path.insert(0,str(STAGE/'preflight'))
from bindings import ROOT,PUBLIC,sha,save,need,blob,verify as preflight_verify
from subset_guard import validate_protocol,validate_rows,validate_all,expected_order,raw_intervals
from lease import require_lease

def protocol():return json.loads((STAGE/'preflight/runtime-protocol.json').read_text())
def commands():return json.loads((STAGE/'preflight/corrected-selection.json').read_text())['cases']
def registry():return json.loads((PUBLIC/'registry.json').read_text())
def source():return(PUBLIC/'benchmark/src/main.rs').read_text()

def wilson(fp,n):
    need(type(fp)is int and type(n)is int and n>0 and 0<=fp<=n,'Invalid independent sample')
    z=1.959963984540054;z2=z*z;p=fp/n
    center=(p+z2/(2*n))/(1+z2/n);half=z*math.sqrt(p*(1-p)/n+z2/(4*n*n))/(1+z2/n)
    return(0.0 if fp==0 else max(0.0,center-half),1.0 if fp==n else min(1.0,center+half))

def quality(rows):
    groups={}
    for row in rows:
        key=(row['filter'],int(row['keys']),int(row['seed']))
        value=(int(row['filter_bytes']),int(row['calibration_false_positives']),int(row['calibration_absent_queries']))
        need(key not in groups or groups[key]==value,'Repeated batch changes quality sample')
        groups[key]=value
    need(len(groups)==8,'Require all8 API/size/seed quality records')
    records=[];families={}
    for(name,n,seed),(allocated,fp,total)in sorted(groups.items()):
        low,high=wilson(fp,total)
        record=dict(filter=name,keys=n,seed=seed,filter_bytes=allocated,actual_bpk=8*allocated/n,
            negatives=total,false_positives=fp,point_fpr=fp/total,wilson95_low=low,wilson95_high=high,
            target=.0001,current_seed_pass=high<=.0001,pooled=False)
        records.append(record);families.setdefault((name,n),[]).append(record)
    summary=[]
    for(name,n),samples in sorted(families.items()):
        need({r['seed']for r in samples}=={32452843,49979687}and len(samples)==2,'Wrong fixed fresh-seed set')
        summary.append(dict(filter=name,keys=n,seeds=[r['seed']for r in samples],
            all_fresh_seeds_pass=all(r['current_seed_pass']for r in samples),
            worst_wilson95_high=max(r['wilson95_high']for r in samples),pooled=False))
    need(len(summary)==4,'Wrong family/size count')
    return dict(api_size_seed_records=records,family_size_all_seed_gates=summary,
        batch_or_mode_repeats_add_samples=False,selection_or_seed_extension_on_failure=False)

def metadata_identity(metadata,binary,source_commit):
    import re
    published=json.loads((HERE/'protocol.json').read_text())
    need(re.fullmatch(r'[0-9a-f]{40}',source_commit)is not None and metadata['source_commit']==source_commit,'Changed expected source commit')
    need(metadata['proof_commit']==published['proof_commit'],'Changed completed preflight commit')
    need(metadata['executable']==str(binary)==commands()[0]['command'][0] and metadata['executable_sha256']==published['performance_executable_sha256'],'Changed frozen binary identity')
    need(metadata['protocol_sha256']==sha(HERE/'protocol.json') and metadata['corrected_selection_sha256']==sha(STAGE/'preflight/corrected-selection.json'),'Changed protocol/selection identity')
    need(metadata['host']==json.loads((STAGE/'validation-v1/metadata.json').read_text())['host'],'Changed measured host')
    need(metadata['affinity']==[3] and metadata['numa_policy']==published['numa_policy'],'Changed placement claim')
    lease=metadata['lease'];fds=lease.get('inherited_lock_descriptors')
    need(set(lease)=={'cpu','socket','lock_path','inherited_lock_descriptors'} and lease['cpu']==3 and lease['socket']==1 and lease['lock_path']==published['socket_lock'],'Changed socket lease')
    need(isinstance(fds,list)and bool(fds)and all(type(fd)is int and fd>=0 for fd in fds)and len(set(fds))==len(fds),'Missing inherited lock evidence')
    environment={k:None for k in ['LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','RUSTFLAGS','RUSTDOCFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']}
    environment['BF_SOCKET_LEASE']='socket1-cpu3'
    need(metadata['environment']==environment,'Changed measured environment')

def audit(output,metadata,binary,source_commit,final=True):
    metadata_identity(metadata,binary,source_commit)
    if final:need(metadata['complete']is True and metadata['final_frozen_inputs_equal']is True,'Incomplete final evidence')
    p=protocol();s=source();r=registry();validate_protocol(p,r,s)
    ledger=commands();need(isinstance(metadata['cases'],list)and len(metadata['cases'])==12,'Missing full list ledger')
    rows=[];inventory={'metadata.json','results.csv','quality.json'}
    for i,(item,record)in enumerate(zip(ledger,metadata['cases'],strict=True)):
        need(record['case']==item['case'] and record['command']==item['command'] and record['command'][0]==str(binary),'Changed exact command')
        need(record['complete']is True and record['returncode']==0,'Incomplete/failed workload')
        need(record['expected_filter_order']==item['expected_filter_order']and record['raw_input_intervals']==item['raw_intervals'],'Changed corrected order/domain ledger')
        for stream in ['stdout','stderr']:
            name=f'case-{i:02d}.'+stream
            need(record[stream]==name and sha(output/name)==record[stream+'_sha256'],'Raw workload drift');inventory.add(name)
        need((output/record['stderr']).read_text().strip()=='sbbf-rs 0.2.8 backend: Avx2Filter','Unexpected backend/diagnostic')
        current=list(csv.DictReader(io.StringIO((output/record['stdout']).read_text())))
        validate_rows(current,item['case'],p,s)
        need(record['rows']==len(current)==2 and [row['filter']for row in current]==item['expected_filter_order'],'Wrong actual subset order')
        rows.extend(current)
    need(rows==list(csv.DictReader(io.StringIO((output/'results.csv').read_text()))),'Raw/aggregate drift')
    counts=validate_all(rows,p,r,s)
    need(quality(rows)==json.loads((output/'quality.json').read_text()),'Changed unpooled quality gates')
    if final:
        need(metadata['counts']==counts and metadata['results_sha256']==sha(output/'results.csv')and metadata['quality_sha256']==sha(output/'quality.json'),'Final summary/hash drift')
    need({p.name for p in output.iterdir()if p.is_file()}==inventory,'Unexpected raw inventory')
    return rows,counts
