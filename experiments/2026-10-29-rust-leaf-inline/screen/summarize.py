#!/usr/bin/env python3
"""Post-run analysis; no selection, binary or source changes."""
import csv, hashlib, json, math, sys
from pathlib import Path
HERE=Path(__file__).resolve().parent.parent
sys.path.insert(0,str(HERE))
from guard import validate_all, CONTROLS
from freeze import verify
from run import verify_commit

def require(x,msg):
 if not x:raise ValueError(msg)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def wilson(fp,n):
 require(n>0 and 0<=fp<=n,'Bad quality count')
 z=1.959963984540054; p=fp/n; zz=z*z; den=1+zz/n
 c=p+zz/(2*n); d=z*math.sqrt((p*(1-p)+zz/(4*n))/n)
 return (0 if fp==0 else max(0,(c-d)/den),1 if fp==n else min(1,(c+d)/den))
def csvout(p,rows):
 require(bool(rows),'Empty table')
 with p.open('w',newline='') as f:
  w=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');w.writeheader();w.writerows(rows)
def geomean(xs):return math.exp(sum(map(math.log,xs))/len(xs))
def nsentry(r,metric):
 if r is None:return None
 prefix=metric[:-3]
 return dict(filter=r['filter'],owner=registry[r['filter']]['owner'],requested_bpk=int(r['requested_bpk']),actual_bpk=float(r['actual_bpk']),filter_bytes=int(r['filter_bytes']),median_ns=float(r[metric]),min_ns=float(r[prefix+'_min_ns']),max_ns=float(r[prefix+'_max_ns']),wilson_upper=wilson(int(r['calibration_false_positives']),int(r['calibration_absent_queries']))[1])
require(__debug__, 'Run analysis without Python -O')
screen=HERE/'screen'
meta=json.loads((screen/'metadata.json').read_text()); protocol=json.loads((HERE/'protocol.json').read_text()); registry=json.loads((HERE/'registry.json').read_text()); frozen=json.loads((HERE/'validation/freeze.json').read_text())
verify(frozen);verify_commit(meta['source_commit'],frozen)
require(meta['complete'] and meta['rows']==112 and meta['workloads']==16,'Incomplete matrix')
require(meta['cpu']==protocol['cpu']==3 and meta['affinity']==[3],'Wrong CPU')
require(meta['freeze_sha256']==sha(HERE/'validation/freeze.json') and meta['protocol_sha256']==sha(HERE/'protocol.json'),'Wrong source')
require(meta['results_sha256']==sha(screen/'results.csv'),'Changed results')
for e in meta['commands']:
 p,bpk,b,seed=e['workload']; require(e['complete'] and e['returncode']==0,'Failed command')
 require(e['csv_sha256']==sha(screen/f'k{p}-p{bpk}-b{b}-s{seed}.csv'),'Changed case')
rows=list(csv.DictReader((screen/'results.csv').open()));validate_all(rows,registry,protocol)
metrics=protocol['ranking']['metrics'];b1=[r for r in rows if int(r['batch'])==1]
quality=[]
for r in b1:
 if registry[r['filter']]['owner']=='native_experimental':continue
 fp,n=int(r['calibration_false_positives']),int(r['calibration_absent_queries']);lo,hi=wilson(fp,n)
 quality.append(dict(filter=r['filter'],owner=registry[r['filter']]['owner'],keys=int(r['keys']),requested_bpk=int(r['requested_bpk']),actual_bpk=float(r['actual_bpk']),filter_bytes=int(r['filter_bytes']),seed=int(r['seed']),calibration_negatives=n,calibration_fp=fp,fpr=fp/n,wilson_lower=lo,wilson_upper=hi))
require(len(quality)==28,'Wrong unique quality count');csvout(screen/'quality.csv',quality)
index={(r['filter'],r['keys'],r['requested_bpk'],r['batch'],r['seed']):r for r in rows}
pairs=[]
for r in rows:
 if r['filter'] not in CONTROLS:continue
 o=index[(CONTROLS[r['filter']],r['keys'],r['requested_bpk'],r['batch'],r['seed'])]
 for metric in metrics:
  ratio=float(o[metric])/float(r[metric]);prefix=metric[:-3]
  pairs.append(dict(candidate=r['filter'],original=o['filter'],keys=int(r['keys']),requested_bpk=int(r['requested_bpk']),actual_bpk=float(r['actual_bpk']),batch=int(r['batch']),seed=int(r['seed']),metric=metric,original_ns=float(o[metric]),candidate_ns=float(r[metric]),original_min_ns=float(o[prefix+'_min_ns']),original_max_ns=float(o[prefix+'_max_ns']),candidate_min_ns=float(r[prefix+'_min_ns']),candidate_max_ns=float(r[prefix+'_max_ns']),original_over_candidate=ratio,outcome='candidate_faster' if ratio>1 else 'original_faster' if ratio<1 else 'exact_tie'))
require(len(pairs)==192,'Wrong pair count');csvout(screen/'candidate-ratios.csv',pairs)
aggregates=[]
for name in CONTROLS:
 for batch in protocol['batches']:
  for metric in metrics:
   group=[p for p in pairs if p['candidate']==name and p['batch']==batch and p['metric']==metric];rs=[p['original_over_candidate'] for p in group]
   require(len(group)==4,'Wrong aggregate count')
   aggregates.append(dict(candidate=name,batch=batch,metric=metric,conditions=len(group),geomean_original_over_candidate=geomean(rs),minimum_ratio=min(rs),maximum_ratio=max(rs),candidate_faster=sum(x>1 for x in rs),original_faster=sum(x<1 for x in rs),exact_ties=sum(x==1 for x in rs)))
csvout(screen/'candidate-aggregates.csv',aggregates)
api=[]
for r in rows:
 for mode,a,b in [('prehashed','lookup_ns','inline_lookup_ns'),('raw','hash_lookup_ns','inline_hash_lookup_ns')]:
  api.append(dict(filter=r['filter'],owner=registry[r['filter']]['owner'],keys=int(r['keys']),requested_bpk=int(r['requested_bpk']),batch=int(r['batch']),seed=int(r['seed']),mode=mode,original_ns=float(r[a]),visible_ns=float(r[b]),original_over_visible=float(r[a])/float(r[b])))
require(len(api)==224,'Wrong API count');csvout(screen/'api-ratios.csv',api)
rankings=[];flat=[];individual=[]
for metric in metrics:
 for power in protocol['key_powers']:
  n=1<<power
  for cap in protocol['ranking']['memory_caps_bpk']:
   for ceiling in protocol['ranking']['fpr_ceilings']:
    eligible=[r for r in b1 if int(r['keys'])==n and int(r['filter_bytes'])*8<=n*cap and wilson(int(r['calibration_false_positives']),int(r['calibration_absent_queries']))[1]<=ceiling]
    winners={}
    for owner in ['native','native_experimental','external']:
     rr=[r for r in eligible if registry[r['filter']]['owner']==owner]
     winners[owner]=nsentry(min(rr,key=lambda r:(float(r[metric]),int(r['filter_bytes']),r['filter'])) if rr else None,metric)
    item=dict(metric=metric,keys=n,memory_cap_bpk=cap,fpr_ceiling=ceiling,**winners)
    for owner in ['native','native_experimental']:
     item['external_over_'+owner]=(winners['external']['median_ns']/winners[owner]['median_ns'] if winners['external'] and winners[owner] else None)
    rankings.append(item);f={k:item[k] for k in ['metric','keys','memory_cap_bpk','fpr_ceiling']}
    for owner,e in winners.items():
     for k in ['filter','actual_bpk','filter_bytes','median_ns','min_ns','max_ns','wilson_upper']:f[owner+'_'+k]=e[k] if e else None
    for owner in ['native','native_experimental']:f['external_over_'+owner]=item['external_over_'+owner]
    flat.append(f)
    for r in b1:
     if int(r['keys'])!=n or registry[r['filter']]['owner']=='external':continue
     qualifies=r in eligible; ext=winners['external']
     individual.append(dict(metric=metric,keys=n,cap_bpk=cap,fpr_ceiling=ceiling,candidate=r['filter'],owner=registry[r['filter']]['owner'],requested_bpk=int(r['requested_bpk']),qualifies=qualifies,candidate_ns=float(r[metric]),external=ext,external_over_candidate=ext['median_ns']/float(r[metric]) if qualifies and ext else None))
require(len(rankings)==48,'Wrong ranking count');csvout(screen/'rankings.csv',flat)
summary=dict(scope='Seed42 CPU3 initial three-hint leaf-inline screen; no promotion or held-out/global-fastest claim',source_commit=meta['source_commit'],rows=112,workloads=16,configurations=10,query_contracts=4,rankings=rankings,individual=individual,candidate_comparisons=192,candidate_aggregates=aggregates,api_ratios=224,quality_records=28,analysis_sha256=sha(Path(__file__)),notes=['Batch1 rankings keep native original, native experimental and external separately. Other batches are native-only regressions.','Four modes share each bitmap and calibration, all families share inputs, and reused batch/clone calibration is not pooled.','Caps and ceilings are nested views; speed ratios and min/max ranges are descriptive, not speed confidence intervals.','No CPU memory binding; CPU3 pinned. Original native implementation is unchanged.','Code shape may affect paths without source edits; report bulk controls rather than attributing every change to call overhead.'])
(screen/'summary.json').write_text(json.dumps(summary,indent=2,allow_nan=False)+'\n')
lines=['# Rust leaf-inline initial screen','', 'Exactly three inline(always) hints were changed in a separate native crate. Production sources, allocation, probes, backend dispatch and bulk routing stayed unchanged. This seed42 CPU3 screen has 16 workloads / 112 rows: batch1 compares seven original public APIs plus three experimental clones; batches3/31/4096 compare only the three native original/clone pairs.','', 'Key powers16/25, actual16/32 bpk, 50% hits, 2^22 queries, eight balanced four-mode trials, whole-input insertion, and 2^24 independent calibration negatives. CPU3 was pinned under the inherited exclusive socket1 flock; memory placement was not explicitly bound. All dense outputs, exact phase order, trial vectors, source/dependency/binary hashes and cross-batch semantic identity passed. No held-out confirmation or production promotion follows from this training screen.','', 'The four modes remain separate: original batch prehashed (lookup_ns), original batch staged common hash (hash_lookup_ns), whole-array public singleton prehashed (inline_lookup_ns), and whole-array public singleton fused hash (inline_hash_lookup_ns). Each is independent-key throughput, not dependent-key latency. Visible Four/Split can use different kernels from bulk. Byte retains a scalar fallback call on non-AVX2 execution; the AVX2 hot path inlines. Split still emits qword products.','', '## Original/candidate regressions and gains','', 'Each ratio is original/candidate; above1 favors the candidate. Aggregates describe four size/budget conditions and do not pool their timings. Every individual condition and its trial range is in candidate-ratios.csv.','', '| Candidate | Batch | Mode | Geometric ratio | Lowest | Highest | Candidate faster / original faster / ties |','| --- | ---: | --- | ---: | ---: | ---: | --- |']
for a in aggregates:lines.append(f"| {a['candidate']} | {a['batch']} | {a['metric']} | {a['geomean_original_over_candidate']:.3f} | {a['minimum_ratio']:.3f} | {a['maximum_ratio']:.3f} | {a['candidate_faster']}/{a['original_faster']}/{a['exact_ties']} |")
for metric in metrics:
 lines += ['','## Batch1 '+metric,'','Actual-byte caps include any smaller tested allocation. Eligibility uses the pointwise two-sided95% Wilson upper endpoint; this is no simultaneous-selection guarantee.','', '| Keys | Cap bpk | FPR ceiling | Original native (ns) | Experimental native (ns) | External (ns) | External / experimental |','| ---: | ---: | ---: | --- | --- | --- | ---: |']
 for item in rankings:
  if item['metric']!=metric:continue
  def fmt(e):return f"{e['filter']} ({e['median_ns']:.3f})" if e else 'No qualifier'
  ratio=item['external_over_native_experimental'];lines.append(f"| {item['keys']} | {item['memory_cap_bpk']} | {item['fpr_ceiling']:.2%} | {fmt(item['native'])} | {fmt(item['native_experimental'])} | {fmt(item['external'])} | {ratio:.3f} |" if ratio is not None else f"| {item['keys']} | {item['memory_cap_bpk']} | {item['fpr_ceiling']:.2%} | {fmt(item['native'])} | {fmt(item['native_experimental'])} | {fmt(item['external'])} | — |")
lines += ['', 'rankings.csv and summary.json retain all48 four-mode cap/quality views and every individual native comparison. candidate-ratios.csv retains192 original/candidate comparisons, api-ratios.csv all224 within-row API ratios, and quality.csv28 distinct original-family/size calibrations. Clone and batch reuse is not additional quality evidence. The16/32-bpk grid does not cover finer upstream capacities. No external leadership is inferred for the native-only batch guards.','']
(screen/'RESULTS.md').write_text('\n'.join(lines));print('Wrote48 rankings,192 candidate ratios,224 API ratios,28 distinct quality records')
