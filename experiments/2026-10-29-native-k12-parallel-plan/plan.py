#!/usr/bin/env python3
"""Deterministic source-only union from complete committed T8 evidence."""
import argparse,csv,hashlib,io,json,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
EXACT='9d5426a40369aac364736d27bb60a36a4d0fca41'
RAW='3cbe13263153135a1fe2e86cacf688016cd782ca'
CONFIRM='1072629b24ab07ffa602b39955f71233ed652ac0'
NATIVE='6e7df603a02e2e7d1c226afaff6d37c14f841f3b'
SEEDS=[5357122369631638320,10870879273875959492,2465277812845611592]
PREFIX='experiments/2026-10-29-'
PATHS={
 'views':(EXACT,PREFIX+'split64-range-parallel-analysis/report-final/query-views.csv'),
 'exact_rows':(RAW,PREFIX+'split64-range-parallel-screen/screen/results.csv'),
 'paired':(CONFIRM,PREFIX+'external-parallel-query/confirmation8/results/paired-seed-comparison.csv'),
 'old_rows':(CONFIRM,PREFIX+'external-parallel-query/confirmation8/results/results.csv'),
}
GEO=['requested_bpk','filter_bytes','budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes','probe_policy','constructor_argument','page_level','native_constructor_bpk','configuration_id','calibration_identity']
def need(ok,msg):
 if not ok:raise ValueError(msg)
def build():
 inputs={};data={}
 for name,(commit,path) in PATHS.items():
  b=subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
  need((ROOT/path).read_bytes()==b,'source changed '+path)
  inputs[name]={'commit':commit,'path':path,'sha256':hashlib.sha256(b).hexdigest()}
  data[name]=list(csv.DictReader(io.StringIO(b.decode())))
 seed_path=PREFIX+'four-sector-range12-strict24-confirmation/protocol.json'
 seed_commit='9c9cd9a32a3fbd6dd025f62e1055084312a0ae4b'
 seed_bytes=subprocess.check_output(['git','show',seed_commit+':'+seed_path],cwd=ROOT)
 need((ROOT/seed_path).read_bytes()==seed_bytes and json.loads(seed_bytes)['seeds']==SEEDS,'seen construction seed source changed')
 inputs['seen_seed_protocol']={'commit':seed_commit,'path':seed_path,'sha256':hashlib.sha256(seed_bytes).hexdigest()}
 need(len(data['views'])==72 and len(data['exact_rows'])==142 and len(data['old_rows'])==276,'changed complete evidence size')
 by_id={r['configuration_id']:r for r in data['exact_rows']};by_geometry={}
 for r in data['exact_rows']:
  key=(int(r['keys']),r['filter'],int(r['filter_bytes']))
  need(key not in by_geometry,'duplicate actual API geometry');by_geometry[key]=r
 old={(r['keys'],r['filter'],r['requested_bpk'],r['seed']):r for r in data['old_rows']}
 selected={}
 def retain(row,reason,kind='external',new_name=None):
  key=(int(row['keys']),new_name or row['filter'],int(row['filter_bytes']))
  if key not in selected:
   selected[key]={'keys':key[0],'filter':key[1],'owner':kind,'source_filter':row['filter'],'geometry':{k:row[k]for k in GEO},'reasons':[]}
  selected[key]['reasons'].append(reason)
 for i,r in enumerate(data['views']):
  if r['external_filter']:
   row=by_id[r['external_configuration_id']]
   need(row['filter']==r['external_filter'] and row['filter_bytes']==r['external_filter_bytes'],'leader geometry mismatch')
   retain(row,{'source':'exact142_query_view','row':i,'cap_bpk':r['cap_bpk'],'target_fpr':r['target_fpr'],'metric':r['metric']})
 for i,r in enumerate(data['paired']):
  for prefix in ('external','conservative_external'):
   prior=old[(r['keys'],r[prefix+'_filter'],r[prefix+'_requested_bpk'],r['seed'])]
   key=(int(prior['keys']),prior['filter'],int(prior['filter_bytes']))
   need(key in by_geometry,'historical leader lacks exact matching geometry')
   retain(by_geometry[key],{'source':'confirmed_T8_'+prefix,'row':i,'seed':r['seed'],'cap_bpk':r['memory_cap_bpk'],'target_fpr':r['fpr_target'],'metric':r['metric'],'legacy_requested_bpk':prior['requested_bpk']})
 need(len(selected)==21,'external union changed')
 for n in (65536,33554432):
  for name in ('FastPatternBF','FourSectorBloomFilter','Split64BloomFilter','ByteSplitBloomFilter'):
   for bpk in (16,32):retain(by_geometry[(n,name,n*bpk//8)],{'source':'fixed_production_control','actual_bpk':bpk},'production_native')
  for bpk in (16,24,32):
   retain(by_geometry[(n,'Split64RangeNative',n*bpk//8)],{'source':'fixed_optional_range_control','actual_bpk':bpk},'optional_native_range','Split64RangeBloomFilter')
   row={'keys':n,'filter':'FourSectorRange12BloomFilter','requested_bpk':str(bpk),'filter_bytes':str(n*bpk//8),'budget_bytes':str(n*bpk//8),'logical_bytes':str(n*bpk//8),'geometry_kind':'native_k12_top24_lines','unit_bytes':'64','unit_count':str(n*bpk//512),'effective_probes':'12','probe_policy':'fixed','constructor_argument':str(n*bpk//8),'page_level':'0','native_constructor_bpk':'0','configuration_id':f'k12-{n}-{bpk}','calibration_identity':f'k12-{n}-{bpk}'}
   retain(row,{'source':'fixed_optional_k12_candidate','native_commit':NATIVE,'actual_bpk':bpk},'optional_native_k12')
 rows=sorted(selected.values(),key=lambda r:(r['keys'],int(r['geometry']['filter_bytes']),r['filter']))
 need(len(rows)==49,'query panel changed')
 api=[r for r in rows if r['filter'] in ('Split64BloomFilter','Split64RangeBloomFilter','FourSectorRange12BloomFilter')]
 need(len(api)==16,'public API panel changed')
 return dict(scope='source-only proposal; no BF/compile/timing',inputs=inputs,native_source_commit=NATIVE,construction_seeds=SEEDS,seed_status='Previously tested C++ K12 single-thread construction seeds; new MT timing, not fresh-seed quality confirmation',query_configurations=rows,public_api_configuration_ids=[r['geometry']['configuration_id']for r in api],counts={'external_size_geometries':21,'production_native_size_geometries':16,'range_size_geometries':6,'K12_size_geometries':6,'query_size_geometries':49,'query_rows_three_seeds':147,'native_public_api_size_geometries':16,'native_public_api_rows_three_seeds':48,'total_process_rows':195,'query_API_geometry_seed_quality_records':147},deduplication='Identical API and actual geometry once per n/seed. Known mapping identities may be validated/reused but never pooled; no API alias removed from timing.')
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args();result=build();text=json.dumps(result,indent=2)+'\n'
 if a.write:(HERE/'selection.json').write_text(text)
 else:need((HERE/'selection.json').read_text()==text,'changed selection')
 print(json.dumps(result['counts']))
