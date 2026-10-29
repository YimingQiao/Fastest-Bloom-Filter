"""Exact seen-input matrix, mapping checks and metadata identity; no calibration."""
import csv,io,json,math
from pathlib import Path
from pins import *
from guard import source_registry,validate_rows,expected_order
OLD='FourSectorRange12BloomFilter';NEW='FourSectorRange12InlineV1';RANGE='Split64RangeBloomFilter'
SEEDS=[48714180869863897,13312860449584497766,9336338316380403537]
SEMANTIC=('language','keys','queries','requested_bpk','filter_bytes','actual_bpk','hash_bits','hit_percent','present_queries','absent_queries','false_positives','fpr','result_checksum','input_mode','insert_batch','scalar_track','budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes','probe_policy','constructor_argument','size_contract')
def rows(text):return list(csv.DictReader(io.StringIO(text)))
def configuration():
    p=json.loads((STAGE/'protocol.json').read_text());source=(STAGE/'benchmark/src/main.rs').read_text();registry=source_registry(source)
    need(p['key_powers']==[16,25]and p['budget_bpk']==24 and p['batches']==[1,3,31,4096]and p['seeds']==SEEDS,'Changed finite matrix')
    need(p['query_power']==22 and p['hit_percent']==50 and p['repeats']==8 and p['calibration_power']==0 and p['expected_cases']==24 and p['expected_rows']==72,'Changed fixed work')
    names=[n for n in registry if n in [OLD,NEW,RANGE]];need(len(names)==3,'Wrong internal controls')
    cases=[dict(key_power=n,budget_bpk=24,batch=b,seed=s,filters=names)for n in [16,25]for b in [1,3,31,4096]for s in SEEDS]
    order=json.loads((STAGE/'ORDER.json').read_text());recorded={(r['key_power'],r['seed']):r['order']for r in order['permutations']}
    for case in cases:need(expected_order(case,p,source)==recorded[(case['key_power'],case['seed'])],'Predata row order changed')
    return p,cases,source

def command(binary,case):return [str(binary),str(case['key_power']),'24','50','22',str(case['batch']),'8',str(case['seed']),','.join(case['filters']),str(1<<case['key_power']),'0']
def expected_stderr():
    paths=[STAGE/f'validation-v1/normal-case-{i}.stderr'for i in range(5)];data=paths[0].read_bytes();need(data and all(p.read_bytes()==data for p in paths),'Preflight backend information differs');return data
def validate_stderr(data):need(data==expected_stderr(),'Unexpected/missing diagnostic bytes')
def sample_key(row):return (OLD if row['filter']==NEW else row['filter'],int(row['keys']),int(row['seed']))
def prior():
    meta=json.loads((PRIOR/'metadata.json').read_text());need(meta['complete']and meta['case_count']==36 and meta['row_count']==108,'Prior108 incomplete')
    data=rows((PRIOR/'results.csv').read_text());need(len(data)==108 and sha(PRIOR/'results.csv')==meta['results_sha256'],'Prior CSV changed')
    selected={}
    for row in data:
        if row['filter']not in[OLD,RANGE]or int(row['requested_bpk'])!=24:continue
        key=sample_key(row);sample={k:row[k]for k in SEMANTIC};sample.update(calibration_absent_queries=row['calibration_absent_queries'],calibration_false_positives=row['calibration_false_positives'])
        need(key not in selected or selected[key]==sample,'Prior repeated mapping/input changed');selected[key]=sample
    need(len(selected)==12 and all(int(x['calibration_absent_queries'])==1<<26 for x in selected.values()),'Missing12 unpooled old constructions')
    return selected

def validate_case(group,case,protocol,source):
    validate_rows(group,case,protocol,source);known=prior();by_name={r['filter']:r for r in group}
    a={k:v for k,v in by_name[OLD].items()if not(k.endswith('_ns')or k.endswith('_trials')or k in['filter','implementation_origin'])}
    b={k:v for k,v in by_name[NEW].items()if not(k.endswith('_ns')or k.endswith('_trials')or k in['filter','implementation_origin'])}
    need(a==b,'Old/new complete semantic identity failed')
    for row in group:
        sample=known[sample_key(row)];need({k:row[k]for k in SEMANTIC}=={k:sample[k]for k in SEMANTIC},'Seen108 mapping/output changed')
        need(row['calibration_absent_queries']==row['calibration_false_positives']=='0','Unexpected new calibration')

def quality_context(all_rows):
    known=prior();seen={}
    for row in all_rows:
        key=sample_key(row);sample={k:row[k]for k in SEMANTIC}
        need(key not in seen or seen[key]==sample,'Cross-batch/clone identity failed');seen[key]=sample
    need(set(seen)==set(known),'Missing12 proven mapping/input records')
    records=[]
    for key,sample in sorted(known.items()):
        n=int(sample['calibration_absent_queries']);k=int(sample['calibration_false_positives']);z=1.959963984540054;p=k/n;d=1+z*z/n;c=(p+z*z/(2*n))/d;r=z*math.sqrt(p*(1-p)/n+z*z/(4*n*n))/d
        records.append(dict(family=key[0],keys=key[1],seed=key[2],actual_bytes=int(sample['filter_bytes']),old_negatives=n,old_false_positives=k,old_wilson95_low=max(0,c-r),old_wilson95_high=min(1,c+r),candidate_alias=NEW if key[0]==OLD else None))
    return dict(prior_raw_commit=PRIOR_RAW,records=records,record_count=12,new_calibration_samples=0,pooled=False,scope='Historical same-construction quality context only, after full source/bitmap/public-output identity; no newly estimated interval')

def metadata_identity(meta,source_commit,freeze):
    full_commit(source_commit);need(meta['source_commit']==source_commit and meta['proof_commit']==PROOF and meta['proposal_commit']==PROPOSAL and meta['prior_raw_commit']==PRIOR_RAW,'Metadata ancestry drift')
    need(meta['binary']==freeze['binary']and meta['binary_sha256']==freeze['binary_sha256'],'Wrong actual executable')
    need(meta['protocol_sha256']==sha(STAGE/'protocol.json')and meta['order_sha256']==sha(STAGE/'ORDER.json')and meta['execution_freeze_sha256']==sha(HERE/'freeze.json'),'Metadata descriptor drift')
    need(meta['host']==freeze['host']and meta['environment']==freeze['environment']and meta['affinity']==[3],'Metadata environment drift')
    lease=meta['lease'];need(lease['cpu']==3 and lease['lease']=='socket1'and lease['lock_path']=='/tmp/fastest-bf-socket1.lock'and lease['inherited_lock_descriptors']and len(set(lease['inherited_lock_descriptors']))==len(lease['inherited_lock_descriptors']),'Recorded lease invalid')
    need(meta['performance_run']and meta['measurement_sessions']==1 and meta['new_calibration_samples']==0,'Wrong measured scope')

def audit(output,source_commit,freeze):
    meta=json.loads((output/'metadata.json').read_text());metadata_identity(meta,source_commit,freeze);protocol,cases,source=configuration();need(meta['complete']and isinstance(meta['cases'],list)and len(meta['cases'])==24,'Incomplete ledger')
    aggregate=[]
    for index,(record,case)in enumerate(zip(meta['cases'],cases,strict=True)):
        need(record['complete']and record['returncode']==0 and record['index']==index and record['case']==case and record['command']==command(freeze['binary'],case)and record['rows']==3,'Wrong measured command')
        for stream in ['stdout','stderr']:need(sha(output/record[stream])==record[stream+'_sha256'],'Raw log drift')
        validate_stderr((output/record['stderr']).read_bytes());group=rows((output/record['stdout']).read_text());validate_case(group,case,protocol,source);aggregate+=group
    need(aggregate==rows((output/'results.csv').read_text())and len(aggregate)==72,'Raw/aggregate row drift')
    need(quality_context(aggregate)==json.loads((output/'quality-context.json').read_text()),'Prior quality context drift')
    need(meta['case_count']==24 and meta['row_count']==72 and meta['mapping_records']==12 and meta['results_sha256']==sha(output/'results.csv')and meta['quality_context_sha256']==sha(output/'quality-context.json'),'Final counts/hashes drift')
    return dict(complete=True,case_count=24,row_count=72,mapping_records=12,new_calibration_samples=0,raw_aggregate_order_equal=True,source_commit=source_commit,all_losses_retained=True)
