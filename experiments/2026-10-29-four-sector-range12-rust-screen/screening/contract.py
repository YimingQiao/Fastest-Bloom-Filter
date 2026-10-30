"""Exact commands, full rows/trials, unpooled quality and original policy scope."""
import csv,io,json,math,re
from pathlib import Path
from pins import STAGE,HERE,PROPOSAL,PROOF,CALLER,sha,need,full_commit
from guard import source_registry,expected_order,validate_rows,raw_intervals
CANDIDATE='FourSectorRange12BloomFilter'

def configuration():
    protocol=json.loads((STAGE/'protocol.json').read_text());selection=json.loads((STAGE/'selection.json').read_text());source=(STAGE/'caller/benchmark/src/main.rs').read_text()
    need(sha(STAGE/'selection.json')==protocol['selection_sha256'],'Selection/protocol mismatch')
    need(source_registry(source)==selection['planned_registry'],'Actual caller registry differs from fixed proposal')
    need(protocol['counts']['commands']==36 and protocol['counts']['rows']==108,'Wrong immutable protocol counts')
    measured=dict(protocol,repeats=protocol['query_repeats'])
    need(protocol['query_repeats']==protocol['build_repeats']==8 and protocol['calibration_power']==26 and protocol['query_power']==22 and protocol['hit_percent']==50,'Changed execution dimensions')
    for c in selection['cases']:
        need(expected_order(c,measured,source)==c['expected_filter_order'],'Proposal exact row-order mismatch')
        d=raw_intervals(c,measured)
        for key in ['inserted','timed_negative_envelope','independent_calibration']:need(d[key]==c['domains'][key],'Proposal raw interval mismatch')
        need(c['arguments']==[str(c['key_power']),str(c['budget_bpk']),'50','22',str(c['batch']),'8',str(c['seed']),','.join(c['filters']),str(1<<c['key_power']),'26'],'Proposal exact command changed')
    need(len(selection['cases'])==36 and sum(len(c['filters'])for c in selection['cases'])==108,'Incomplete proposal case union')
    return protocol,selection,measured,source

def expected_stderr():
    raw=STAGE/'caller/validation-v1'
    values=[(raw/f'normal-case-{i}.stderr').read_bytes()for i in range(7)]
    need(values[0] and all(x==values[0]for x in values),'Changed normal preflight informational stderr')
    return values[0]
def validate_stderr(data):need(data==expected_stderr(),'Unexpected/additional measurement diagnostic')
def command(binary,case):return [str(binary),*case['arguments']]
def rows(text):return list(csv.DictReader(io.StringIO(text)))
def wilson(fp,n):
    need(0<=fp<=n and n>0,'Invalid independent quality count');z=1.959963984540054;p=fp/n;den=1+z*z/n;center=(p+z*z/(2*n))/den;delta=z*math.sqrt(p*(1-p)/n+z*z/(4*n*n))/den
    return (0.0 if fp==0 else max(0,center-delta),1.0 if fp==n else min(1,center+delta))
def semantics(row):
    fields=('filter_bytes','actual_bpk','budget_bytes','logical_bytes','geometry_kind','effective_probes','probe_policy','constructor_argument','implementation_origin','result_checksum','false_positives','present_queries','absent_queries','calibration_absent_queries','calibration_false_positives')
    return {f:row[f]for f in fields}
def quality(all_rows):
    samples={}
    for row in all_rows:
        key=(row['filter'],int(row['keys']),int(row['filter_bytes']),int(row['seed']))
        if key in samples:need(samples[key]['semantics']==semantics(row),'Repeated batch semantic/quality mismatch')
        else:
            fp,n=int(row['calibration_false_positives']),int(row['calibration_absent_queries']);need(n==1<<26,'Wrong fixed cal26 denominator');lo,hi=wilson(fp,n)
            samples[key]=dict(filter=key[0],keys=key[1],filter_bytes=key[2],seed=key[3],false_positives=fp,queries=n,wilson95_low=lo,wilson95_high=hi,current_eligible=hi<=0.0001,semantics=semantics(row))
    need(len(samples)==36,'Expected36 separate API/allocation/size/seed samples')
    groups={}
    for key,value in samples.items():groups.setdefault(key[:3],[]).append(value)
    seeds=set(configuration()[0]['seeds']);gates=[]
    for key,values in sorted(groups.items()):
        need(len(values)==3 and {x['seed']for x in values}==seeds,'Missing/reused quality seed')
        gates.append(dict(filter=key[0],keys=key[1],filter_bytes=key[2],seeds=sorted(seeds),all_three_seeds_pass=all(x['current_eligible']for x in values),worst_wilson95_high=max(x['wilson95_high']for x in values)))
    need(len(gates)==12,'Expected12 separate all-three-seed gates')
    return dict(scope='API identities kept separate; only batch/mode reuse deduplicated, no sample pooling',api_geometry_seed_records=[samples[k]for k in sorted(samples)],all_three_seed_gates=gates)

def metadata_identity(meta,source_commit,freeze):
    full_commit(source_commit);need(meta['source_commit']==source_commit and meta['proposal_commit']==PROPOSAL and meta['proof_commit']==PROOF and meta['caller_source_commit']==CALLER,'Wrong immutable source identity')
    need(meta['binary']==freeze['binary']and meta['binary_sha256']==freeze['binary_sha256'],'Wrong actual executable')
    need(meta['protocol_sha256']==sha(STAGE/'protocol.json')and meta['selection_sha256']==sha(STAGE/'selection.json')and meta['execution_freeze_sha256']==sha(HERE/'freeze.json'),'Protocol/freeze identity drift')
    need(meta['host']==freeze['host']and meta['environment']==freeze['environment']and meta['affinity']==[3],'Host/environment/affinity drift')
    lease=meta['lease'];fds=lease['inherited_lock_descriptors'];need(lease['cpu']==3 and lease['lease']=='socket1'and lease['lock_path']=='/tmp/fastest-bf-socket1.lock'and fds and len(fds)==len(set(fds)) and all(isinstance(x,int)and x>=0 for x in fds),'Wrong actual inherited lease evidence')

def audit(directory,source_commit,freeze,complete=True):
    directory=Path(directory);meta=json.loads((directory/'metadata.json').read_text());metadata_identity(meta,source_commit,freeze)
    p,s,measured,source=configuration();ledger=meta['cases'];need(isinstance(ledger,list),'Case ledger overwritten by a count')
    if complete:need(meta['complete']is True and len(ledger)==36,'Incomplete formal matrix')
    need(len(ledger)<=36,'Extra workload');all_rows=[]
    for index,entry in enumerate(ledger):
        case=s['cases'][index];need(entry['index']==index and entry['case']==case and entry['command']==command(freeze['binary'],case),'Command/case order drift')
        need(entry['complete']is True and entry['returncode']==0,'Unfinished or failed measurement')
        for stream in ['stdout','stderr']:need(sha(directory/entry[stream])==entry[stream+'_sha256'],'Raw command output drift')
        validate_stderr((directory/entry['stderr']).read_bytes())
        parsed=rows((directory/entry['stdout']).read_text());validate_rows(parsed,case,measured,source);need(entry['rows']==len(parsed),'Wrong case row count');all_rows.extend(parsed)
    aggregate=rows((directory/'results.csv').read_text());need(aggregate==all_rows,'Raw/aggregate exact rows differ')
    if complete:
        need(len(all_rows)==108 and meta['case_count']==36 and meta['row_count']==108,'Wrong complete cardinality')
        need(meta['results_sha256']==sha(directory/'results.csv'),'Aggregate hash changed')
        q=quality(all_rows);need(json.loads((directory/'quality.json').read_text())==q and meta['quality_sha256']==sha(directory/'quality.json'),'Quality ledger mismatch')
        need(meta['quality_record_count']==36 and meta['all_seed_gate_count']==12,'Wrong quality metadata counts')
    return dict(complete=complete,case_count=len(ledger),row_count=len(all_rows),query_metric_rows=len(all_rows)*4,build_metric_rows=len(all_rows)*4,quality_record_count=36 if complete else None,all_seed_gate_count=12 if complete else None)
