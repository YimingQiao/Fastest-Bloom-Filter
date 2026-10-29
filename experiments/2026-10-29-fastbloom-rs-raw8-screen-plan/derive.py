"""Fixed catalog/commands/order/domain derivation. No filter, compiler or result read."""
import argparse,hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
MASK=(1<<64)-1;GAMMA=0x9e3779b97f4a7c15
CATALOG='1a4b37b8830e99f6091ab050096d62a4d431bb00'
CALLER='d23791243dabdda85a8ff2eb11ce2d9b3e5a6b47'
PROOF='73ff8ed51da5b54a3d19b76ab5da403291c4d51f'
SOURCE_PATHS=[(CATALOG,'experiments/2026-10-29-fastbloom-rs-raw8-plan/selection.json'),
 (CALLER,'experiments/2026-10-29-fastbloom-rs-raw8-caller/benchmark/src/main.rs'),
 (CALLER,'experiments/2026-10-29-fastbloom-rs-raw8-caller/benchmark/src/reporter.rs'),
 (CALLER,'experiments/2026-10-29-fastbloom-rs-raw8-caller/benchmark/src/raw_contract.rs'),
 (PROOF,'experiments/2026-10-29-fastbloom-rs-raw8-caller/proof-final/freeze.json'),
 (PROOF,'experiments/2026-10-29-fastbloom-rs-raw8-caller/proof-final/MANIFEST.json')]
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
def digest(data):return hashlib.sha256(data).hexdigest()
class Random:
 def __init__(self,seed):self.state=seed
 def advance(self,n):self.state=(self.state+GAMMA*n)&MASK
 def next(self):
  self.advance(1);z=self.state;z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK;z=((z^(z>>27))*0x94d049bb133111eb)&MASK;return z^(z>>31)
 def shuffle(self,names):
  for i in range(len(names)-1,0,-1):j=self.next()%(i+1);names[i],names[j]=names[j],names[i]
def workload(seed,n,q,hit):
 rng=Random(seed);base=rng.next()%((1<<32)-n-q);present=q//100*hit+min(q%100,hit)
 draws=(n-1)+present+(q-1);rng.advance(draws)
 return rng,base,present,draws
def registry(source):
 part=source[source.index('const FILTER_NAMES:'):source.index('fn main() {')]
 names=re.findall(r'    "([A-Za-z0-9]+)",',part);assert len(names)==len(set(names))==45;return names
def phase(seed,repeats):
 labels=[0,1];Random(seed^0x6a09e667f3bcc909).shuffle(labels)
 return [[labels[i]for i in ([0,1]if j%4 in [0,3]else[1,0])]for j in range(repeats)]
def derive():
 p=json.loads((HERE/'protocol.json').read_text());inputs={path:blob(c,path)for c,path in SOURCE_PATHS}
 placement=json.loads((HERE/'PLACEMENT.json').read_text());assert placement['child_prefix']==p['child_placement_prefix'] and placement['sha256']==p['numactl_sha256']
 assert placement['cpu']==2 and placement['cpu_topology_node']==0
 for stream in ['stdout','stderr']:assert digest((HERE/('numactl-hardware.'+stream)).read_bytes())==placement['hardware_'+stream+'_sha256']
 selection=json.loads(inputs[SOURCE_PATHS[0][1]]);points=selection['points'];assert len(points)==262
 names=registry(inputs[SOURCE_PATHS[1][1]].decode());freeze=json.loads(inputs[SOURCE_PATHS[4][1]])
 assert freeze['binaries_sha256'][p['normal_binary']]==p['normal_binary_sha256']
 assert p['catalog_commit']==CATALOG and p['caller_source_commit']==CALLER and p['proof_commit']==PROOF
 q=1<<p['query_exponent'];cal=1<<p['calibration_exponent'];cases=[];identities=[]
 for exponent in p['keys_exponents']:
  n=1<<exponent
  for cap in p['requested_budgets_bpk']:
   group=[r for r in points if r['keys']==n and r['budget_bpk']==cap];keep={r['filter']for r in group}
   assert len(keep)==len(group)==(41 if cap==24 else 45)
   requested=[name for name in names if name in keep];assert len(requested)==len(group)
   selection_arg=''if len(requested)==45 else','.join(requested)
   rng,base,present,draws=workload(p['seed'],n,q,p['hit_percent']);order=list(requested);rng.shuffle(order)
   source_case=len(cases)
   assert p['query_batches'][0]==p['calibration_query_batch']==1
   for batch in p['query_batches']:
    cal_power=p['calibration_exponent'] if batch==p['calibration_query_batch'] else 0
    args=[str(exponent),str(cap),str(p['hit_percent']),str(p['query_exponent']),str(batch),str(p['repeats']),str(p['seed']),selection_arg,str(p['insert_batch']),str(cal_power)]
    rows=[next(r for r in group if r['filter']==name)for name in order]
    cases.append(dict(case_index=len(cases),command=[*p['child_placement_prefix'],p['normal_binary'],*args],binary_arguments=args,keys=n,budget_bpk=cap,batch=batch,expected_rows=len(rows),row_order=order,
                      key_base=base,positive_query_count=present,workload_rng_draws_after_key_base=draws,
                      inserted_interval=[base,base+n],mixed_absent_envelope=[base+n,base+n+q],
                      calibration_exponent=cal_power,calibration_interval=[base+n+q,base+n+q+cal] if cal_power else None,
                      quality_source_case_index=source_case,quality_calibration_interval=[base+n+q,base+n+q+cal],
                      interval_note='Half-open. Mixed negatives are a deterministic subset of the envelope; calibration is disjoint from both inserted and all timed-negative raw keys.',
                      phase_order=phase(p['seed'],p['repeats']),configuration_ids=[r['configuration_id']for r in rows]))
   identities.extend(dict(configuration_id=r['configuration_id'],filter=r['filter'],keys=n,budget_bpk=cap,actual_bytes=r['actual_bytes'],raw_path=r['raw_path'],seed=p['seed'],calibration_absent_queries=cal,
                          source_case_index=source_case,source_batch=1,reuse_case_indices=[source_case+1,source_case+2],reuse_batches=[31,4096])for r in group)
 assert len(cases)==18 and sum(c['expected_rows']for c in cases)==786 and len(identities)==262
 assert sum(r['raw_path']=='DirectRaw8'for r in identities)==144
 assert all(c['inserted_interval'][1]<=c['mixed_absent_envelope'][0]and c['mixed_absent_envelope'][1]==c['quality_calibration_interval'][0]and c['quality_calibration_interval'][1]<1<<64 for c in cases)
 assert sum(c['expected_rows']for c in cases if c['calibration_exponent'])==262
 assert sum(c['expected_rows']for c in cases if not c['calibration_exponent'])==524
 # Known aliases are a deduplication identity, never extra negatives or evidence.
 aliases=[dict(keys=n,members=[f'Fastbloom017-n{n}-b16',f'Fastbloom017K11-n{n}-b16'],require='Exact raw-hash contract, geometry, counts, full-output checksum and calibration equality in this run')for n in [1<<x for x in p['keys_exponents']]]
 sources=[dict(commit=c,path=path,sha256=digest(inputs[path]))for c,path in SOURCE_PATHS]
 return {'commands.json':dict(status='Pre-data proposal; no process executed',processes=18,rows=786,cases=cases),
         'quality-ledger.json':dict(api_records=262,calibrated_rows=262,reuse_rows=524,known_mapping_records=260,repeated_batch_records_are_not_independent=True,
            reuse_identity_fields=['filter','keys','queries','requested_bpk','filter_bytes','actual_bpk','hit_percent','present_queries','insert_batch','repeats','seed','key_base','raw_hash_contract','build_scratch_bytes','absent_queries','false_positives','result_checksum','budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes','probe_policy','constructor_argument','implementation_origin','size_contract'],
            reuse_required_zero_fields=['calibration_absent_queries','calibration_false_positives'],
            reuse_proof_scope='Complete arrays are validated inside each process; cross-process equality uses exact frozen deterministic input identities plus full mixed-output checksum/count fingerprints. No archived cross-process array identity claim.',
            api_records_detail=identities,known_aliases=aliases),
         'INPUTS.json':dict(source_anchors=sources,protocol_sha256=digest((HERE/'protocol.json').read_bytes()),placement_sha256=digest((HERE/'PLACEMENT.json').read_bytes()),numactl_sha256=placement['sha256'],proof_binary_sha256=p['normal_binary_sha256'],no_poppy_results_read=True)}
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--check',action='store_true');args=parser.parse_args()
 for name,data in derive().items():
  text=json.dumps(data,indent=2)+'\n';path=HERE/name
  if args.check:assert path.read_text()==text,name
  else:path.write_text(text)
 print('Fixed18 commands/786 rows,262 API identities/260 conditional mappings; source derivation only')
if __name__=='__main__':main()
