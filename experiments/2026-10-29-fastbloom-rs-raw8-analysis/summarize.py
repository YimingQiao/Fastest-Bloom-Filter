"""Pre-data pure calculation rules. A separate committed-raw loader is required."""
import math
from collections import Counter
METRICS=['raw_batched_public','raw_visible_public','raw_insert','allocate_filter_and_scratch_raw_insert']
OWNERS=['production_native','optional_native_range','optional_native_k12','retained_external','new_raw8_external']
CAPS=[16,24,32];TARGETS=[0.01,0.001,0.0001]
def need(ok,message):
 if not ok:raise ValueError(message)
def identity(row):return f'{row["filter"]}-n{row["keys"]}-b{row["requested_bpk"]}'
def owner(row):
 value=row['implementation_origin']
 if value=='external':return 'new_raw8_external'if row['filter'].startswith('FastbloomRsRawK')else'retained_external'
 need(value in OWNERS,'Unknown ownership');return value
def wilson(fp,n):
 need(type(fp)is int and type(n)is int and 0<=fp<=n and n>0,'Invalid quality denominator')
 z=1.959963984540054;p=fp/n;den=1+z*z/n;center=(p+z*z/(2*n))/den;radius=z*math.sqrt(p*(1-p)/n+z*z/(4*n*n))/den
 return (0.0 if fp==0 else max(0.0,center-radius),1.0 if fp==n else min(1.0,center+radius))
def comparison(rival,candidate):
 if rival is None or candidate is None or candidate<=0:return dict(ratio=None,outcome='no_comparable')
 ratio=rival/candidate
 return dict(ratio=ratio,outcome='win'if ratio>1 else'loss'if ratio<1 else'tie')
def leaders(alternatives,allowed):
 eligible=[x for x in alternatives if x['eligible']and x['owner']in allowed]
 if not eligible:return dict(latency_ns=None,configuration_ids=[])
 best=min(x['latency_ns']for x in eligible)
 return dict(latency_ns=best,configuration_ids=sorted(x['configuration_id']for x in eligible if x['latency_ns']==best))
def analyze(rows,quality):
 need(len(rows)==786 and len(quality['api_records'])==262,'Incomplete fixed panel')
 need(quality['source_rows']==262 and quality['reuse_rows']==524 and quality['pooling']is False,'Unexpected quality reuse policy')
 records={r['configuration_id']:dict(r)for r in quality['api_records']};need(len(records)==262,'Duplicate quality source')
 coverage=Counter(identity(r)for r in rows);need(set(coverage)==set(records)and set(coverage.values())=={3},'Missing or duplicated geometry')
 for key,record in records.items():
  matched=[r for r in rows if identity(r)==key];need({int(r['batch'])for r in matched}=={1,31,4096},'Wrong geometry batch coverage')
  source=[r for r in matched if int(r['batch'])==1][0]
  need(record['calibration_absent_queries']==1<<24 and int(source['calibration_absent_queries'])==1<<24,'Wrong calibration denominator')
  need(int(source['calibration_false_positives'])==record['calibration_false_positives']and int(source['filter_bytes'])==record['actual_bytes'],'Quality source mismatch')
  record['wilson_low'],record['wilson_high']=wilson(record['calibration_false_positives'],record['calibration_absent_queries'])
  record['point_rate']=record['calibration_false_positives']/record['calibration_absent_queries'];record['owner']=owner(source)
  record['qualifies']={str(t):record['wilson_high']<=t for t in TARGETS}
 need(len({r['mapping_identity']for r in records.values()})==260,'Unproven mapping deduplication')
 alternatives=[];views=[]
 classes={x:{x}for x in OWNERS}
 classes.update(all_native=set(OWNERS[:3]),all_external=set(OWNERS[3:]),all_retained=set(OWNERS[:-1]),all_registered=set(OWNERS))
 for n in [1<<16,1<<25]:
  for batch in [1,31,4096]:
   subset=[r for r in rows if int(r['keys'])==n and int(r['batch'])==batch];need(len(subset)==131,'Wrong size/batch panel')
   for cap in CAPS:
    for target in TARGETS:
     for metric in METRICS:
      view=dict(keys=n,batch=batch,cap_bpk=cap,fpr_fraction_cap=target,metric=metric,metric_class='query'if metric in METRICS[:2]else'build');current=[]
      for row in subset:
       key=identity(row);q=records[key];size=int(row['filter_bytes']);budget=size<=n*cap//8;qualifies=q['wilson_high']<=target;latency=float(row[metric+'_ns']);need(math.isfinite(latency)and latency>=0,'Invalid latency')
       current.append(dict(**view,configuration_id=key,filter=row['filter'],requested_bpk=int(row['requested_bpk']),owner=owner(row),actual_bytes=size,actual_bpk=size*8/n,build_scratch_bytes=int(row['build_scratch_bytes']),query_scratch_bytes=int(row['query_scratch_bytes']),fits_cap=budget,quality_pass=qualifies,eligible=budget and qualifies,wilson_high=q['wilson_high'],calibration_false_positives=q['calibration_false_positives'],calibration_absent_queries=q['calibration_absent_queries'],latency_ns=latency,min_ns=float(row[metric+'_min_ns']),max_ns=float(row[metric+'_max_ns']),trials=[float(x)for x in row[metric+'_trials'].split('|')],source_process=f'n{n}-b{row["requested_bpk"]}-qbatch{batch}'))
      selected={name:leaders(current,allowed)for name,allowed in classes.items()}
      result=dict(**view,leaders=selected,new_vs_retained=comparison(selected['all_retained']['latency_ns'],selected['new_raw8_external']['latency_ns']),new_vs_native=comparison(selected['all_native']['latency_ns'],selected['new_raw8_external']['latency_ns']),new_vs_retained_external=comparison(selected['retained_external']['latency_ns'],selected['new_raw8_external']['latency_ns']),selection_scope='This current-seed finite panel; allocations may come from distinct processes')
      for item in current:item['vs_best_retained']=comparison(selected['all_retained']['latency_ns'],item['latency_ns'])if item['eligible']else dict(ratio=None,outcome='ineligible')
      alternatives.extend(current);views.append(result)
 api=[];fixed=[]
 by={(r['filter'],int(r['keys']),int(r['requested_bpk']),int(r['batch'])):r for r in rows};need(len(by)==786,'Duplicate raw row')
 for row in rows:
  api.append(dict(configuration_id=identity(row),keys=int(row['keys']),batch=int(row['batch']),owner=owner(row),actual_bytes=int(row['filter_bytes']),batched_ns=float(row['raw_batched_public_ns']),visible_ns=float(row['raw_visible_public_ns']),batched_trials=row['raw_batched_public_trials'],visible_trials=row['raw_visible_public_trials'],**comparison(float(row['raw_batched_public_ns']),float(row['raw_visible_public_ns']))))
  name=row['filter']
  if name.startswith('Fastbloom017K'):
   default=by[('Fastbloom017',int(row['keys']),int(row['requested_bpk']),int(row['batch']))];need(row['filter_bytes']==default['filter_bytes'],'Fixed/default payload mismatch')
   for metric in METRICS:
    fixed.append(dict(keys=int(row['keys']),requested_bpk=int(row['requested_bpk']),batch=int(row['batch']),metric=metric,fixed_configuration=identity(row),default_configuration=identity(default),actual_bytes=int(row['filter_bytes']),fixed_ns=float(row[metric+'_ns']),default_ns=float(default[metric+'_ns']),fixed_trials=row[metric+'_trials'],default_trials=default[metric+'_trials'],fixed_wilson_high=records[identity(row)]['wilson_high'],default_wilson_high=records[identity(default)]['wilson_high'],**comparison(float(default[metric+'_ns']),float(row[metric+'_ns']))))
 need(len(views)==216 and len(alternatives)==28296 and sum(r['owner']=='new_raw8_external'for r in alternatives)==15552,'Wrong nested analysis coverage')
 need(len(api)==786 and len(fixed)==864,'Wrong API/fixed-default coverage')
 summaries=[]
 for kind in ['query','build']:
  for rival in ['new_vs_retained','new_vs_native','new_vs_retained_external']:
   counts=Counter(v[rival]['outcome']for v in views if v['metric_class']==kind);summaries.append(dict(metric_class=kind,comparison=rival,**{k:counts[k]for k in ['win','loss','tie','no_comparable']}))
 return dict(quality=list(records.values()),views=views,alternatives=alternatives,api_ratios=api,fixed_default_ratios=fixed,summary=summaries,counts=dict(rows=786,quality_api_records=262,quality_mapping_records=260,views=216,query_views=108,build_views=108,alternatives=28296,new_raw8_alternatives=15552,api_ratios=786,fixed_default_ratios=864),scope='Seed42 exploratory raw-only screen; no Poppy raw API in this binary; no global leadership or fresh-seed claim')
