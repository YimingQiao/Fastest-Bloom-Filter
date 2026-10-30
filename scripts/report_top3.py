#!/usr/bin/env python3
"""Descriptive rankings from seven complete suites; never combine panel timings."""
import csv, hashlib, json, math, statistics
from collections import defaultdict
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'docs/benchmark-top3-2026-10-30'
inputs={}; groups=defaultdict(list); unavailable=[]
def read(name):
 p=ROOT/name;b=p.read_bytes();inputs[name]=hashlib.sha256(b).hexdigest()
 return list(csv.DictReader(b.decode().splitlines())) if p.suffix=='.csv' else json.loads(b)
def add(panel,n,b,cap,fpr,metric,threads,cell,method,size,latency,eligible):
 key=(panel,int(n),int(b),float(cap),float(fpr),metric,int(threads))
 v=float(latency)
 if math.isnan(v):
  unavailable.append(dict(panel=panel,keys=int(n),batch=int(b),cap=cap,fpr=fpr,metric=metric,method=method,bytes=int(size),cell=str(cell)));return
 assert math.isfinite(v) and v>0
 groups[key].append(dict(cell=str(cell),method=method,bytes=int(size),ns=v,eligible=bool(eligible)))
def yes(v):return v is True or v=='True'
def gm(v):return math.exp(math.fsum(math.log(x)for x in v)/len(v))
base='experiments/2026-10-29-exact-budget-range/screen/'
summary=read(base+'summary.json');raw=read(base+'results.csv');assert len(raw)==988
q={(r['keys'],r['seed'],r['calibration_identity']):r['quality_upper']for r in summary['quality']}
for r in raw:
 n=int(r['keys']);size=int(r['filter_bytes']);upper=q[n,int(r['seed']),r['calibration_identity']]
 for cap in (12,14,16,20,24,28,32):
  for fpr in (.01,.001,.0001):
   for metric in ('lookup_ns','hash_lookup_ns'):
    if not math.isfinite(float(r[metric])):
     unavailable.append(dict(panel='CPP988',filter=r['filter'],keys=n,bytes=size,metric=metric,cap=cap,fpr=fpr));continue
    add('CPP988',n,r['batch'],cap,fpr,metric,1,r['seed'],r['filter'],size,r[metric],size*8<=n*cap and upper<=fpr)
base='experiments/2026-10-29-fastbloom-rs-raw8-analysis/report-v1/'
rows=read(base+'alternatives.json');assert len(rows)==28296
for r in rows:add('Rust786',r['keys'],r['batch'],r['cap_bpk'],r['fpr_fraction_cap'],r['metric'],1,42,r['filter'],r['actual_bytes'],r['latency_ns'],r['eligible'])
base='experiments/2026-10-29-four-sector-range12-strict24-analysis/report/'
for r in read(base+'all-alternatives.csv'):
 if r['quality_policy']!='all_three_seeds':continue
 add('CPP_K12_'+r['track'],r['keys'],r['batch'],r['cap_bpk'],.0001,r['metric'],1,r['seed'],r['filter'],r['filter_bytes'],r['latency_ns'],yes(r['eligible']))
base='experiments/2026-10-29-native-k12-parallel-analysis/report/'
for r in read(base+'query_alternatives.csv'):
 add('CPP_MT195',r['keys'],4096,r['cap_bpk'],r['target_fpr'],r['metric'],8,r['seed'],r['filter'],r['actual_bytes'],r['latency_ns'],yes(r['all_seed_eligible']))
prefetch_names={p['id']:p['geometry']['filter']for p in read('experiments/2026-10-30-independent32-range-prefetch64/caller/selection.json')['points']}
base='experiments/2026-10-30-independent32-range-prefetch64-analysis/report-v1/'
rows=read(base+'alternatives.json');assert len(rows)==512
for r in rows:add('CPP_prefetch192',r['keys'],r['batch'],r['cap_bpk'],r['fpr_ceiling'],r['mode'],1,(r['seed'],r['round']),prefetch_names[r['point_id']],r['actual_bytes'],r['median_ns_per_key'],r['eligible'])
points={p['id']:p['geometry']['filter']for p in read('experiments/2026-10-29-k12-singleton-external-plan/selection.json')['points']}
rows=read('experiments/2026-10-29-k12-singleton-external-analysis/report-v2/alternatives.csv');assert len(rows)==2304
for r in rows:
 for c in json.loads(r['cells']):
  add('CPP_singleton616',r['keys'],1,r['cap_bpk'],r['fpr_ceiling'],r['mode'],1,(c['seed'],c['round']),points[r['point_id']],r['actual_bytes'],c['median_ns_per_key'],yes(r['eligible']))
# Historical C++ build confirmation: retain its original pooled three-seed, one-sided95 quality rule.
rows=read('results/2026-10-28-modern-confirmation-cpp/results.csv');assert len(rows)==234
quality=defaultdict(list)
for r in rows:quality[(r['keys'],r['filter'],r['filter_bytes'])].append(r)
upper={}
for key,rs in quality.items():
 assert len(rs)==3 and len({r['seed']for r in rs})==3
 n=sum(int(r['calibration_absent_queries'])for r in rs);k=sum(int(r['calibration_false_positives'])for r in rs);z=1.6448536269514722
 upper[key]=(k+z*z/2+z*math.sqrt(k*(1-k/n)+z*z/4))/(n+z*z)
for r in rows:
 for cap in (16,32):
  for fpr in (.01,.001,.0001):
   ok=int(r['filter_bytes'])*8<=int(r['keys'])*cap and upper[r['keys'],r['filter'],r['filter_bytes']]<=fpr
   for metric in ('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns'):
    add('CPP_build234',r['keys'],r['insert_batch'],cap,fpr,metric,1,r['seed'],r['filter'],r['filter_bytes'],r[metric],ok)
results=[];full=[]
for key,rows in sorted(groups.items()):
 panel,n,b,cap,fpr,metric,threads=key
 cells={r['cell']for r in rows};byconfig=defaultdict(dict)
 for r in rows:
  config=(r['method'],r['bytes']);assert r['cell'] not in byconfig[config],(key,config,r['cell'])
  byconfig[config][r['cell']]=r
 ranked=[]
 for (method,size),cs in byconfig.items():
  assert set(cs)==cells,(key,method,'missing cell')
  if not all(r['eligible']for r in cs.values()):continue
  lat=gm([r['ns']for r in cs.values()]);ranked.append(dict(method=method,actual_bytes=size,actual_bpk=size*8/n,ns_per_key=lat,cell_ns={c:r['ns']for c,r in cs.items()}))
 ranked.sort(key=lambda r:(r['ns_per_key'],r['method'],r['actual_bytes']))
 # Public API methods remain distinct; select one geometry per API for the readable top3.
 seen=set();methods=[]
 for r in ranked:
  if r['method']in seen:continue
  seen.add(r['method']);methods.append(r)
 fastest=ranked[0]['ns_per_key']if ranked else None
 for rank,r in enumerate(ranked,1):
  r.update(configuration_rank=rank,relative_throughput=fastest/r['ns_per_key'])
 scenario=dict(panel=panel,keys=n,batch=b,cap_bpk=cap,fpr_ceiling=fpr,metric=metric,threads=threads,cells=len(cells),eligible_configurations=len(ranked),eligible_methods=len(methods))
 results.append(dict(**scenario,top3=methods[:3]))
 full.extend(dict(**scenario,**r)for r in ranked)
OUT.mkdir(exist_ok=True)
(OUT/'rankings.json').write_text(json.dumps(dict(scenarios=results,all_eligible_configurations=full,unavailable_metrics=unavailable),indent=2)+'\n')
fields=['panel','keys','batch','cap_bpk','fpr_ceiling','metric','threads','cells','eligible_configurations','eligible_methods','configuration_rank','method','actual_bytes','actual_bpk','ns_per_key','relative_throughput']
with (OUT/'rankings.csv').open('w')as f:
 w=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore',lineterminator='\n');w.writeheader();w.writerows(full)
lines=['# Benchmark Top 3 — descriptive snapshot','',
'Each panel is ranked separately. Hardware: Xeon Platinum 8474C. These panels use 50% mixed-query hits. No cross-language, cross-binary or cross-panel timing normalization is applied. This report covers seven complete external-comparison suites, not every historical internal A/B experiment.','',
'Throughput ratio = fastest latency / method latency, so first place is 1.00 and lower is slower. ns/key is also retained. Multi-cell summaries use the geometric mean of the original per-cell medians; a configuration must be eligible in every cell. These are descriptive same-data rankings, not independent confirmation or significance tests. Exact ties use method/bytes only for display order.','',
'Top3 means three public API methods: each may use its fastest eligible measured allocation under the byte ceiling. API variants remain distinct even if they share a bitmap mapping. Every eligible allocation, including alternatives within a method, remains in rankings.json and rankings.csv. Fewer than three qualifiers are shown without padding.','',
'CPP988: one seen seed, broad capacity screen, prehashed/staged query only. Rust786: one seen seed, raw query and build; build uses insertion chunk4096 regardless of the query-batch context label. CPP_singleton616: two seen seeds and opposite rounds, single-key contracts and restricted union of external leaders. CPP_prefetch192: two seen seeds and opposite rounds, fixed16-bpk/1% panel; prototypes remain experimental. CPP_K12: three fresh seeds, fixed strict0.01% shortlist. CPP_MT195: three seen seeds, eight physical cores; gated excludes launch/join while end_to_end includes them. Historical compiled versions remain the ones actually measured.','',
'CPP_build234 retains the original three-seed pooled, one-sided95 quality gate and historical allocation boundaries. Caller-prepared hash workspace is not asserted to be charged; it is not the newer raw8 full-construction contract. NaN metrics (such as a raw-only API lacking a prehashed path) remain listed as unavailable in rankings.json, never as zero latency.', '',
'Metrics: lookup/generic_pure = prehashed query; hash_lookup/generic_staged_common_hash = staged hash+query; visible_public_* = public single-key loop; raw_batched_public/raw_visible_public include required public hashing. raw_insert excludes bitmap/scratch allocation; allocate_filter_and_scratch_raw_insert includes both. RPT selection-vector production, SQL joins/materialization and whole SQL latency are not measured by these microbenchmarks.','']
for panel in sorted({r['panel']for r in results}):
 lines += ['## '+panel,'','| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |','|---:|---:|---:|---:|---|---:|---|---|---|']
 for s in results:
  if s['panel']!=panel:continue
  vals=[f"{r['method']} @{r['actual_bpk']:.4g} bpk: {r['ns_per_key']:.4f} ns, **{r['relative_throughput']:.3f}×**"for r in s['top3']]
  vals+=['—']*(3-len(vals))
  lines.append(f"| {s['keys']} | {s['batch']} | {s['cap_bpk']:g} | {s['fpr_ceiling']*100:g}% | {s['metric']} | {s['cells']} | "+' | '.join(vals)+' |')
(OUT/'REPORT.md').write_text('\n'.join(lines)+'\n')
(OUT/'INPUTS.json').write_text(json.dumps(dict(source_sha256=inputs,script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),scenarios=len(results),eligible_configuration_rows=len(full)),indent=2)+'\n')
print(json.dumps(dict(scenarios=len(results),panels={p:sum(s['panel']==p for s in results)for p in sorted({s['panel']for s in results})},configurations=len(full))))
