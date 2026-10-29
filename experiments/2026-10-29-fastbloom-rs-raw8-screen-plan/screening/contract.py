"""Fixed786 rows, strict raw replay and262 calibration sources; no ranking."""
import csv,io,json,re
from pathlib import Path
from pins import PLAN,HERE,PROOF,PROPOSAL,need,sha
import row_guard as guard
def protocol():return json.loads((PLAN/'protocol.json').read_text())
def cases():return json.loads((PLAN/'commands.json').read_text())['cases']
def ledger():return json.loads((PLAN/'quality-ledger.json').read_text())
def csv_bytes(rows):
 out=io.StringIO(newline='');writer=csv.DictWriter(out,fieldnames=list(rows[0]));writer.writeheader();writer.writerows(rows);return out.getvalue().encode()
def placement(stdout,stderr,returncode):
 need(returncode==0 and not stderr,'numactl placement failed')
 text=stdout.decode()
 for pattern in [r'^policy:\s*bind\s*$',r'^physcpubind:\s*2\s*$',r'^membind:\s*0\s*$']:need(re.search(pattern,text,re.M),'Unexpected NUMA/CPU policy')
def validate_case(rows,case):guard.validate_rows(rows,case['binary_arguments'])
def quality(rows):
 need(len(rows)==786,'Wrong complete quality row count')
 plan=ledger();records={};by_case={}
 for case in cases():
  group=rows[sum(c['expected_rows']for c in cases()[:case['case_index']]):sum(c['expected_rows']for c in cases()[:case['case_index']+1])]
  validate_case(group,case);by_case[case['case_index']]={r['filter']:r for r in group}
 for record in plan['api_records_detail']:
  source=by_case[record['source_case_index']][record['filter']]
  need(int(source['calibration_absent_queries'])==record['calibration_absent_queries'],'Missing calibration source')
  for index in record['reuse_case_indices']:
   reused=by_case[index][record['filter']]
   need(all(reused[k]==source[k]for k in plan['reuse_identity_fields']),'Calibration reuse identity differs')
   need(all(int(reused[k])==0 for k in plan['reuse_required_zero_fields']),'Reuse row calibrated unexpectedly')
  records[record['configuration_id']]=dict(configuration_id=record['configuration_id'],filter=record['filter'],keys=record['keys'],budget_bpk=record['budget_bpk'],actual_bytes=record['actual_bytes'],seed=int(source['seed']),key_base=int(source['key_base']),raw_hash_contract=source['raw_hash_contract'],calibration_absent_queries=int(source['calibration_absent_queries']),calibration_false_positives=int(source['calibration_false_positives']),source_case_index=record['source_case_index'],reuse_case_indices=record['reuse_case_indices'],mapping_identity=record['configuration_id'])
 alias_fields=['keys','queries','filter_bytes','actual_bpk','seed','key_base','raw_hash_contract','present_queries','absent_queries','false_positives','result_checksum','calibration_absent_queries','calibration_false_positives','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes','constructor_argument']
 for alias in plan['known_aliases']:
  first,second=[records[name]for name in alias['members']];a=by_case[first['source_case_index']][first['filter']];b=by_case[second['source_case_index']][second['filter']]
  need(all(a[k]==b[k]for k in alias_fields),'Known default/K11 alias differs')
  second['mapping_identity']=first['mapping_identity']
 need(len(records)==262 and len({r['mapping_identity']for r in records.values()})==260,'Wrong quality identities')
 return dict(api_records=list(records.values()),api_record_count=262,mapping_record_count=260,source_rows=262,reuse_rows=524,pooling=False)
def identity(meta,source_commit,frozen):
 p=protocol();need(re.fullmatch('[0-9a-f]{40}',source_commit),'Immutable producer commit required')
 need(meta['source_commit']==source_commit and meta['proposal_commit']==PROPOSAL and meta['proof_commit']==PROOF,'Wrong source provenance')
 need(meta['freeze_sha256']==sha(HERE/'freeze.json')and meta['protocol_sha256']==sha(PLAN/'protocol.json'),'Wrong freeze/protocol identity')
 need(meta['binary']==frozen['binary']and meta['binary_sha256']==frozen['binary_sha256'],'Wrong measured executable')
 need(meta['host']==frozen['host']and meta['environment']==frozen['expected_environment'],'Host/environment differs')
 need(meta['affinity']==[2]and meta['lease_environment']=='socket0-cpu2','Wrong placement')
 lease=meta['lease'];fds=lease['inherited_lock_descriptors'];need(lease['cpu']==2 and lease['socket']==0 and lease['lease']=='socket0-cpu2'and lease['lock_path']==p['lease_file'],'Wrong lease identity')
 need(fds and len(fds)==len(set(fds))and all(type(fd)is int and fd>=0 for fd in fds),'Missing inherited descriptor evidence')
 need([r['fd']for r in lease['fdinfo_records']]==fds and all(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',r['fdinfo'],re.M)for r in lease['fdinfo_records']),'Missing exclusive flock evidence')
 need(meta['numactl_sha256']==p['numactl_sha256'],'Wrong numactl tool')
def audit(output,source_commit,frozen):
 output=Path(output);meta=json.loads((output/'metadata.json').read_text());identity(meta,source_commit,frozen)
 need(isinstance(meta['cases'],list),'Ledger was replaced by counts')
 need(meta['complete']and len(meta['cases'])==18,'Incomplete formal matrix')
 probe=meta['placement_probe'];p=protocol();need(probe['complete']and probe['command']==[*p['child_placement_prefix'],p['child_placement_prefix'][0],'--show'],'Changed/incomplete placement probe')
 for stream in ['stdout','stderr']:need(sha(output/probe[stream])==probe[stream+'_sha256'],'Placement evidence changed')
 placement((output/probe['stdout']).read_bytes(),(output/probe['stderr']).read_bytes(),probe['returncode'])
 rows=[]
 for expected,observed in zip(cases(),meta['cases']):
  need(observed['case_index']==expected['case_index']and observed['command']==expected['command']and observed['complete']and observed['returncode']==0,'Changed/incomplete case ledger')
  for stream in ['stdout','stderr']:need(sha(output/observed[stream])==observed[stream+'_sha256'],'Raw stream changed')
  out=(output/observed['stdout']).read_bytes();err=(output/observed['stderr']).read_bytes();guard.validate_process(0,out,err);need(err==frozen['expected_stderr'].encode(),'Unexpected caller stderr')
  current=list(csv.DictReader(io.StringIO(out.decode())));validate_case(current,expected);need(observed['row_count']==len(current),'Case count mismatch');rows.extend(current)
 need((output/'results.csv').read_bytes()==csv_bytes(rows),'Raw/aggregate byte mismatch')
 need(len(rows)==786 and meta['counts']==dict(case_count=18,row_count=786,calibration_rows=262,reuse_rows=524),'Wrong final counts')
 q=quality(rows);need(json.loads((output/'quality.json').read_text())==q,'Quality links differ')
 return meta,rows
