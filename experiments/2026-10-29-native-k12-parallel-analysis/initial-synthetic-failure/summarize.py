#!/usr/bin/env python3
"""Complete195 analysis under the pre-data frozen rules; no BF execution."""
import argparse,csv,hashlib,io,json,math,subprocess,sys
from collections import Counter,defaultdict
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1];SCREEN=ROOT/'experiments/2026-10-29-native-k12-parallel-screen'
SOURCE='a46a7afd49094fb1c6748191d1fc448a8cd1f2fb'
RAW='7c526683db0ad367ac99bbeeeba252a11a27b64e'
RAW_SHA='6ffa698a2ba2e2f8bcd1db31892aa8229b0873ae99bfe61287e5dc598b9c4a15'
sys.path.insert(0,str(SCREEN))
import contract,audit
SEEDS=[5357122369631638320,10870879273875959492,2465277812845611592]
CAPS=[16,24,32];TARGETS=[0.01,0.001,0.0001]
METRICS=['parallel_lookup_gated_ns','parallel_lookup_end_to_end_ns','parallel_hash_lookup_gated_ns','parallel_hash_lookup_end_to_end_ns']
OWNERS=['external','production_native','optional_native_range','optional_native_k12','all_native_composite']
PUBLIC_METRICS=['insert_t1_ns','allocate_insert_t1_ns','insert_t8_ns','allocate_insert_t8_ns','lookup_t1_ns','lookup_t8_ns']
FAMILIES={'k12':'FourSectorRange12BloomFilter','range':'Split64RangeBloomFilter','split':'Split64BloomFilter'}
def need(ok,msg):
 if not ok:raise ValueError(msg)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def exact(commit,p):need(p.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(p.relative_to(ROOT))],cwd=ROOT),'uncommitted artifact '+str(p))
def load():
 manifest=SCREEN/'RAW_COMPLETE.json';exact(RAW,manifest);need(sha(manifest)==RAW_SHA,'raw seal changed');m=json.loads(manifest.read_text());need(m['complete']and m['source_commit']==SOURCE,'wrong raw producer')
 for name,h in m['files'].items():
  p=SCREEN/name;need(p.resolve().is_relative_to(SCREEN),'raw path escaped');need(sha(p)==h,'raw artifact changed');exact(RAW,p)
 need(len(m['files'])==396,'incomplete raw closure');audit.audit(SCREEN/'results-v1',SOURCE,live=True)
 exact(SOURCE,SCREEN/'ANALYSIS_RULES.json');return json.loads((SCREEN/'results-v1/rows.json').read_text())
def wilson(k,n):
 need(n>0 and 0<=k<=n,'invalid independent counts');z=1.959963984540054;p=k/n;d=1+z*z/n
 return min(1.,(p+z*z/(2*n)+z*math.sqrt(p*(1-p)/n+z*z/(4*n*n)))/d)
def identity(record):
 p=record['case']['point'];return(p['keys'],p['filter'],int(p['geometry']['filter_bytes']),record['case']['seed'])
def result(ratio):return 'win'if ratio<1 else'loss'if ratio>1 else'tie'
def compare(candidate,rival):
 if candidate is None or rival is None:return {'outcome':'no_comparable','latency_ratio':None,'candidate':candidate,'rival':rival}
 ratio=candidate['latency_ns']/rival['latency_ns'];return {'outcome':result(ratio),'latency_ratio':ratio,'candidate':candidate,'rival':rival}
def best(alternatives,owner,all_seed=False):
 values=[r for r in alternatives if r['all_seed_eligible'if all_seed else'current_eligible']and(r['owner']==owner or(owner=='all_native_composite'and r['owner']!='external'))]
 if not values:return None
 r=min(values,key=lambda x:(x['latency_ns'],x['actual_bytes'],x['filter']));return {k:r[k]for k in ['filter','owner','actual_bytes','geometry_id','latency_ns','quality_upper','all_seed_worst_upper']}
def comparisons(leaders):
 pairs={name:compare(leaders[name],leaders['external'])for name in OWNERS if name!='external'}
 pairs['k12_vs_range']=compare(leaders['optional_native_k12'],leaders['optional_native_range'])
 pairs['k12_vs_production']=compare(leaders['optional_native_k12'],leaders['production_native'])
 pairs['range_vs_production']=compare(leaders['optional_native_range'],leaders['production_native']);return pairs
def calculate(records):
 contract.validate_complete(records);query=[r for r in records if r['case']['track']=='shared_query'];public=[r for r in records if r['case']['track']=='native_public']
 quality=[];quality_by_id={};canonical={};by_configuration=defaultdict(list)
 for record in query:
  c=record['case'];p=c['point'];r=record['row'];g=p['geometry'];ident=identity(record);fp=int(r['calibration_false_positives']);n=int(r['calibration_absent_queries']);upper=wilson(fp,n)
  q={'keys':p['keys'],'filter':p['filter'],'owner':p['owner'],'actual_bytes':int(r['filter_bytes']),'seed':c['seed'],'geometry_id':g['configuration_id'],'mapping_id':g['calibration_identity'],'absent':n,'false_positives':fp,'observed_fpr':fp/n,'wilson95_upper':upper}
  quality.append(q);quality_by_id[ident]=q;by_configuration[ident[:3]].append(q)
  key=(p['keys'],g['calibration_identity'],c['seed']);v=canonical.setdefault(key,dict(q,aliases=[]));need(v['false_positives']==fp and v['absent']==n,'alias calibration differs');v['aliases'].append(p['filter'])
 for key,values in by_configuration.items():need(len(values)==3 and {v['seed']for v in values}==set(SEEDS),'missing construction seed')
 worst={k:max(v['wilson95_upper']for v in values)for k,values in by_configuration.items()}
 alternatives=[];views=[];all_seed_groups=defaultdict(list);query_scaling=[]
 for n in [65536,33554432]:
  for cap in CAPS:
   for target in TARGETS:
    for metric in METRICS:
     for seed in SEEDS:
      local=[]
      for record in query:
       p=record['case']['point'];r=record['row'];ident=identity(record)
       if p['keys']!=n or ident[-1]!=seed or int(r['filter_bytes'])*8>n*cap:continue
       q=quality_by_id[ident];v={'keys':n,'cap_bpk':cap,'target_fpr':target,'metric':metric,'seed':seed,'filter':p['filter'],'owner':p['owner'],'actual_bytes':int(r['filter_bytes']),'geometry_id':p['geometry']['configuration_id'],'latency_ns':float(r[metric]),'quality_upper':q['wilson95_upper'],'all_seed_worst_upper':worst[ident[:3]],'current_eligible':q['wilson95_upper']<=target,'all_seed_eligible':worst[ident[:3]]<=target};need(math.isfinite(v['latency_ns'])and v['latency_ns']>0,'invalid median');local.append(v)
      alternatives.extend(local);leaders={owner:best(local,owner)for owner in OWNERS};gated={owner:best(local,owner,True)for owner in OWNERS}
      view={'keys':n,'cap_bpk':cap,'target_fpr':target,'metric':metric,'seed':seed,'leaders':leaders,'comparisons':comparisons(leaders)};views.append(view)
      all_seed_groups[(n,cap,target,metric)].append({'seed':seed,'leaders':gated,'comparisons':comparisons(gated)})
 for record in query:
  r=record['row'];p=record['case']['point']
  for metric in METRICS:
   serial='hash_lookup_ns'if'parallel_hash_'in metric else'lookup_ns';ratio=float(r[metric])/float(r[serial]);query_scaling.append({'keys':p['keys'],'filter':p['filter'],'owner':p['owner'],'actual_bytes':int(r['filter_bytes']),'seed':record['case']['seed'],'parallel_metric':metric,'serial_metric':serial,'parallel_ns':float(r[metric]),'serial_ns':float(r[serial]),'parallel_over_serial':ratio,'outcome':result(ratio)})
 conditions=[]
 for key,seeds in sorted(all_seed_groups.items()):
  need(len(seeds)==3 and {s['seed']for s in seeds}==set(SEEDS),'incomplete all-seed condition');conditions.append(dict(zip(['keys','cap_bpk','target_fpr','metric'],key))|{'seed_results':seeds})
 public_rows=[];public_scaling=[];public_pairs=[];public_by_id={identity(r):r for r in public}
 for record in public:
  r=record['row'];ident=identity(record);q=quality_by_id[ident];public_rows.append({'case':record['case'],'row':r,'quality':q,'all_seed_worst_upper':worst[ident[:3]],'new_quality_samples':0})
  for contract_name in ['insert','allocate_insert','lookup']:
   t1=float(r[contract_name+'_t1_ns']);t8=float(r[contract_name+'_t8_ns']);ratio=t8/t1;public_scaling.append({'keys':ident[0],'filter':ident[1],'actual_bytes':ident[2],'seed':ident[3],'contract':contract_name,'t1_ns':t1,'t8_ns':t8,'t8_over_t1':ratio,'outcome':result(ratio),'quality_upper':q['wilson95_upper'],'all_seed_worst_upper':worst[ident[:3]]})
 for left,right,budgets in [('k12','range',[16,24,32]),('k12','split',[16,32]),('range','split',[16,32])]:
  for n in [65536,33554432]:
   for bpk in budgets:
    for seed in SEEDS:
     li=(n,FAMILIES[left],n*bpk//8,seed);ri=(n,FAMILIES[right],n*bpk//8,seed);l=public_by_id[li]['row'];r=public_by_id[ri]['row']
     for metric in PUBLIC_METRICS:
      a,b=float(l[metric]),float(r[metric]);ratio=a/b;public_pairs.append({'keys':n,'actual_bpk':bpk,'actual_bytes':n*bpk//8,'seed':seed,'metric':metric,'candidate':li[1],'rival':ri[1],'candidate_ns':a,'rival_ns':b,'candidate_over_rival':ratio,'outcome':result(ratio),'candidate_upper':quality_by_id[li]['wilson95_upper'],'rival_upper':quality_by_id[ri]['wilson95_upper'],'candidate_all_seed_upper':worst[li[:3]],'rival_all_seed_upper':worst[ri[:3]]})
 counts={'query_rows':len(query),'public_rows':len(public),'quality_API_records':len(quality),'quality_mapping_records':len(canonical),'per_seed_views':len(views),'alternatives':len(alternatives),'all_seed_conditions':len(conditions),'same_row_query_scaling':len(query_scaling),'public_scaling':len(public_scaling),'public_named_pairs':len(public_pairs)}
 need(counts=={'query_rows':147,'public_rows':48,'quality_API_records':147,'quality_mapping_records':126,'per_seed_views':216,'alternatives':3636,'all_seed_conditions':72,'same_row_query_scaling':588,'public_scaling':144,'public_named_pairs':252},'fixed analysis coverage changed')
 return {'counts':counts,'quality_API':quality,'quality_mappings':list(canonical.values()),'query_views':views,'query_alternatives':alternatives,'all_seed_conditions':conditions,'query_scaling':query_scaling,'public_rows':public_rows,'public_scaling':public_scaling,'public_pairs':public_pairs}
def outcome_counts(items,key='outcome'):return dict(Counter(r[key]for r in items))
def summary_text(result_data):
 d=result_data;lines=['# Native K12 multithread comparison: complete fixed195','',f'Producer `{SOURCE}`; complete raw `{RAW}`. All195 rows are retained:147 common-executor query rows and48 actual public native API rows. Two sizes,49 exact API/geometry points, three already-seen construction seeds, eight physical cores on socket0/NUMA0. No new kernel or post-result selection was used.','',
 'All latency ratios below use candidate/rival (or T8/T1); **below1 is faster**. Actual allocations are admitted under nested16/24/32-bpk ceilings. Quality uses each construction’s independent2^26-negative two-sided95% Wilson upper endpoint;1%,0.1%,0.01% are fractions0.01,0.001,0.0001.147 API records correspond to126 checked mapping identities, with no pooled or additional denominator from aliases or the public track.','',
 'The shared executor creates fresh threads for every invocation. Launch/gated/join/end-to-end boundaries remain separate and all four query phases are balanced. Public native APIs use their actual whole-array partitioning and an eight-core allowed mask. These two contexts are reported separately; their medians are not normalized or substituted for one another.','',
 '## Shared T8 query leadership','', '| Quality policy | Candidate group / strongest external | Wins | Losses | Ties | No comparable |','|---|---|---:|---:|---:|---:|']
 for policy,items in [('current seed',d['query_views']),('all three seeds pass',[s for c in d['all_seed_conditions']for s in c['seed_results']])]:
  for owner in OWNERS[1:]:
   counts=Counter(v['comparisons'][owner]['outcome']for v in items);lines.append(f"| {policy} | {owner} | {counts['win']} | {counts['loss']} | {counts['tie']} | {counts['no_comparable']} |")
 lines+=['','Counts span nested caps, metrics and seen constructions; they are descriptive repeated views, not independent experiments. No-comparable cases are excluded from any win denominator. The all-native composite is not a production-only result. All3636 cap-admitted alternatives, quality failures and every leader remain in the machine-readable output.','',
 '## Every all-seed K12 condition against the strongest external','', '| Keys | Cap bpk | FPR ceiling | Metric | Minimum ratio | Maximum ratio | W / L / T / unavailable |','|---:|---:|---:|---|---:|---:|---|']
 for condition in d['all_seed_conditions']:
  comps=[s['comparisons']['optional_native_k12']for s in condition['seed_results']];valid=[c['latency_ratio']for c in comps if c['latency_ratio']is not None];count=Counter(c['outcome']for c in comps)
  lo=f'{min(valid):.6f}'if valid else'—';hi=f'{max(valid):.6f}'if valid else'—';lines.append(f"| {condition['keys']} | {condition['cap_bpk']} | {100*condition['target_fpr']:.4g}% | {condition['metric']} | {lo} | {hi} | {count['win']} / {count['loss']} / {count['tie']} / {count['no_comparable']} |")
 lines+=['','## Actual public native APIs','', '| Matched pair | Metric | Wins | Losses | Ties | Minimum ratio | Maximum ratio |','|---|---|---:|---:|---:|---:|---:|']
 groups=defaultdict(list)
 for r in d['public_pairs']:groups[(r['candidate'],r['rival'],r['metric'])].append(r)
 for (candidate,rival,metric),rows in sorted(groups.items()):
  count=Counter(r['outcome']for r in rows);ratios=[r['candidate_over_rival']for r in rows];lines.append(f"| {candidate} / {rival} | {metric} | {count['win']} | {count['loss']} | {count['tie']} | {min(ratios):.6f} | {max(ratios):.6f} |")
 lines+=['','These252 same-byte comparisons are unconditional performance observations. Their per-seed and worst-of-three quality endpoints are retained alongside each row; a fast but quality-ineligible construction does not become a qualified win.144 separate T8/T1 ratios preserve every actual-native scaling loss. Allocation-plus-insertion contains the insertion interval from the same build; those measurements are dependent. External serial construction is not included in a parallel-build victory panel.','',
 'Range/K12 retain a copied serial bitmap during validation/timing; Split64 has no public bitmap copy. Requested auxiliary buffers and actual partition scratch remain in every public row. This is a cross-family working-set difference, not a bitmap-cap charge; within a family T1/T8 uses the same auxiliary storage.','',
 '## Quality failures and limits','', '| Keys | API | Actual bytes | Seed | False positives / independent negatives | Wilson upper % | Failed ceiling(s) |','|---:|---|---:|---:|---|---:|---|']
 failures=0
 for q in d['quality_API']:
  failed=[t for t in TARGETS if q['wilson95_upper']>t]
  if not failed:continue
  failures+=1;lines.append(f"| {q['keys']} | {q['filter']} | {q['actual_bytes']} | {q['seed']} | {q['false_positives']} / {q['absent']} | {100*q['wilson95_upper']:.9f} | {', '.join(str(100*t)+'%'for t in failed)} |")
 if not failures:lines.append('| — | none | — | — | — | — | — |')
 lines+=['','Every query/build trial vector remains in the committed raw data; all optional, production and external outcomes remain separate. Three already-seen constructions, repeated metric/cap views and within-process repetitions do not support an independent significance or fresh-quality claim. Wilson endpoints are pointwise, not simultaneous guarantees. The external union is the fixed strongest union from the two committed prior panels, not every library/configuration. These observations do not establish universal fastest performance or automatically promote a new kernel.','']
 return '\n'.join(lines)
def write_csv(p,rows):
 with p.open('w',newline='')as f:
  writer=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
def main():
 need(__debug__,'Python -O forbidden');p=argparse.ArgumentParser();p.add_argument('--output',type=Path,default=HERE/'report');a=p.parse_args();need(not a.output.exists(),'preserve earlier analysis')
 records=load();result_data=calculate(records);a.output.mkdir()
 for name in ['quality_API','query_alternatives','query_scaling','public_scaling','public_pairs']:write_csv(a.output/(name+'.csv'),result_data[name])
 for name in ['quality_mappings','query_views','all_seed_conditions','public_rows']:(a.output/(name+'.json')).write_text(json.dumps(result_data[name],indent=2,allow_nan=False)+'\n')
 (a.output/'metadata.json').write_text(json.dumps({'producer_commit':SOURCE,'raw_commit':RAW,'raw_manifest_sha256':RAW_SHA,'analysis_rules_sha256':sha(SCREEN/'ANALYSIS_RULES.json'),'counts':result_data['counts']},indent=2)+'\n')
 (a.output/'REPORT.md').write_text(summary_text(result_data));print(json.dumps(result_data['counts']))
if __name__=='__main__':main()
