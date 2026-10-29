"""Fixed78 contract: exact order/geometry, all losses,39 API and33 mapping samples."""
import csv
import io
import json
from pathlib import Path
import re
import sys
HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
sys.path.insert(0,str(STAGE/'preflight'))
from bindings import ROOT,PUBLIC,plan,need,sha,save,blob,require_lease
from checks import schema,SEMANTIC
from validate_rows import validate
from contract import wilson
PROOF='cb2de7eec244e7299b5545a9258004cf41223ff5'
BINARY=Path(plan.BINARY)
CANDIDATE=plan.CANDIDATE

def protocol():return json.loads((STAGE/'protocol.json').read_text())
def cases():return protocol()['cases']
def training():return list(csv.DictReader(io.StringIO((PUBLIC/'screening/results-v1/results.csv').read_text())))
def geometry(case):
    rows={r['filter']:r for r in training()if int(r['keys'])==1<<case['key_power']and int(r['requested_bpk'])==case['budget_bpk']}
    return{name:dict(rows[name],calibration_identity=name)for name in case['filters']}
def rows_from(text):
    rows=list(csv.DictReader(io.StringIO(text)));need(rows and all(None not in r and None not in r.values()for r in rows),'Malformed CSV');return rows

def validate_case(rows,case):
    p=protocol();need(list(rows[0])==schema(),'Changed schema')
    need([r['filter']for r in rows]==case['expected_order']==plan.order(1<<case['key_power'],case['seed'],case['filters'],json.loads((PUBLIC/'registry.json').read_text())),'Changed exact seeded API order')
    validate(rows,geometry(case),power=case['key_power'],budget=case['budget_bpk'],query_power=p['query_power'],batch=case['batch'],repeats=p['repeats'],seed=case['seed'],calibration_power=p['calibration_power'])

def quality(rows):
    p=protocol();apis={};mapping={}
    for case in cases():
        current=[r for r in rows if int(r['keys'])==1<<case['key_power']and int(r['requested_bpk'])==case['budget_bpk']and int(r['batch'])==case['batch']and int(r['seed'])==case['seed']]
        validate_case(current,case)
        for row in current:
            key=(row['filter'],int(row['keys']),int(row['requested_bpk']),int(row['seed']));semantic={k:row[k]for k in SEMANTIC}
            need(key not in apis or apis[key]==semantic,'Batch reuse changed semantic sample');apis[key]=semantic
            family='Split64Range/Fixed64'if row['filter']in('Split64RangeNative','FastFilterFixed64')else row['filter']
            identity=(family,*key[1:]);sample=tuple(int(row[k])for k in('keys','filter_bytes','seed','calibration_absent_queries','calibration_false_positives','false_positives','result_checksum'))
            group=mapping.setdefault(identity,dict(sample=sample,apis=set()));need(group['sample']==sample,'Proven alias sample changed');group['apis'].add(row['filter'])
    need(len(rows)==78 and len(apis)==39 and len(mapping)==33,'Wrong full78/39API/33mapping quality coverage')
    api_records=[];gates={}
    for key,row in sorted(apis.items()):
        name,n,budget,seed=key;total=int(row['calibration_absent_queries']);fp=int(row['calibration_false_positives']);low,high=wilson(fp,total)
        record=dict(filter=name,keys=n,requested_bpk=budget,filter_bytes=int(row['filter_bytes']),actual_bpk=float(row['actual_bpk']),seed=seed,negatives=total,false_positives=fp,mixed_false_positives=int(row['false_positives']),result_checksum=int(row['result_checksum']),point_fpr=fp/total,wilson95_low=low,wilson95_high=high,passes_strict_0_01pct=high<=p['fpr_ceiling'],pooled=False)
        api_records.append(record);gates.setdefault(key[:3],[]).append(record)
    allseed=[]
    for (name,n,budget),items in sorted(gates.items()):
        need(sorted(x['seed']for x in items)==sorted(p['seeds']),'Missing independent seed gate')
        allseed.append(dict(filter=name,keys=n,requested_bpk=budget,filter_bytes=items[0]['filter_bytes'],all_three_seeds_pass=all(x['passes_strict_0_01pct']for x in items),worst_wilson95_high=max(x['wilson95_high']for x in items),seeds=[x['seed']for x in items],pooled=False))
    need(len(allseed)==13,'Wrong13 API geometry allseed gates')
    records=[]
    for identity,group in sorted(mapping.items()):
        n,allocated,seed,total,fp,mixed,checksum=group['sample'];low,high=wilson(fp,total)
        records.append(dict(mapping=identity[0],keys=n,requested_bpk=identity[2],filter_bytes=allocated,seed=seed,apis=sorted(group['apis']),negatives=total,false_positives=fp,mixed_false_positives=mixed,result_checksum=checksum,wilson95_low=low,wilson95_high=high,pooled=False))
    return dict(api_seed_records=api_records,mapping_seed_records=records,all_seed_gates=allseed,repeated_batches_add_samples=False,known_alias_only='Split64RangeNative/FastFilterFixed64 at24bpk',all_timings_retained_even_if_ineligible=True,calibration_extension_allowed=False)

def audit(output,meta,commit,final=True):
    need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Exact source commit required');proof=json.loads((STAGE/'validation-v1/metadata.json').read_text())
    need(meta['source_commit']==commit and meta['proof_commit']==PROOF and meta['executable']==str(BINARY)and meta['executable_sha256']==plan.BINARY_SHA==sha(BINARY),'Changed source/proof/binary identity')
    need(meta['host']==proof['host']and meta['environment']==proof['environment'],'Changed exact host/environment')
    need(meta['protocol_sha256']==sha(STAGE/'protocol.json')and meta['selection_sha256']==sha(STAGE/'selection.json')and meta['numa_policy']=='CPU affinity only; no explicit NUMA memory binding','Changed protocol/placement claim')
    fds=meta['lease'].get('inherited_lock_descriptors');need(isinstance(fds,list)and bool(fds)and all(type(x)is int and x>=0 for x in fds)and len(fds)==len(set(fds)),'Invalid inherited descriptor evidence')
    need(meta['affinity']==[3]and meta['lease']['cpu']==3 and meta['lease']['socket']==1 and meta['lease']['lock_path']=='/tmp/fastest-bf-socket1.lock','Changed CPU/socket lease')
    if final:need(meta['complete']is True and meta['final_frozen_inputs_equal']is True,'Incomplete final confirmation')
    need(isinstance(meta['cases'],list)and len(meta['cases'])==24,'Missing fixed24 command ledger')
    rows=[];inventory={'metadata.json','results.csv','quality.json'}
    for i,(case,record)in enumerate(zip(cases(),meta['cases'],strict=True)):
        need(record['case']==case and record['command']==case['command']and record['expected_order']==case['expected_order'],'Changed fixed case/command/order')
        need(record['complete']is True and record['returncode']==0,'Incomplete/failed workload')
        for stream in('stdout','stderr'):
            name=f'case-{i:02d}.'+stream;need(record[stream]==name and sha(output/name)==record[stream+'_sha256'],'Raw output drift');inventory.add(name)
        need(not(output/record['stderr']).read_bytes(),'Unexpected diagnostics')
        current=rows_from((output/record['stdout']).read_text());validate_case(current,case);need(record['rows']==len(current),'Rowcount drift');rows.extend(current)
    need(rows==rows_from((output/'results.csv').read_text()),'Raw/aggregate disagreement');need(quality(rows)==json.loads((output/'quality.json').read_text()),'Quality/gate drift')
    counts=dict(case_count=24,rows=78,primary_rows=60,secondary_rows=18,api_seed_records=39,mapping_seed_records=33,all_seed_gates=13,pooled=False)
    if final:need(meta['counts']==counts and meta['results_sha256']==sha(output/'results.csv')and meta['quality_sha256']==sha(output/'quality.json'),'Changed finalcounts/hash')
    need({x.name for x in output.iterdir()if x.is_file()}==inventory,'Unexpected raw inventory');return rows,counts
