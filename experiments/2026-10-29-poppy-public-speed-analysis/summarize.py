#!/usr/bin/env python3
"""Offline complete Poppy486 analysis; never invokes a compiler or filter."""
import argparse,csv,hashlib,io,json,math,re,subprocess,sys
from collections import Counter,defaultdict
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PRODUCER=ROOT/'experiments/2026-10-29-poppy-public-speed-screen'
SOURCE='3c2be48860b52fc55e50aff1170f30724db772da'
sys.path.insert(0,str(PRODUCER))
import audit as producer_audit
import screen_contract as contract
from plan import selection
QUERY=('lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns')
BUILD=('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns')
CAPS=(16,24,32);TARGETS=(.01,.001,.0001)
OWNERS=('poppy_external','retained_external','all_external_composite','production_native','optional_native_range','optional_native_k12','all_native_composite')
CONTRASTS=(('poppy_external','retained_external'),('poppy_external','production_native'),('poppy_external','optional_native_range'),('poppy_external','optional_native_k12'),('poppy_external','all_native_composite'),('production_native','all_external_composite'),('optional_native_range','all_external_composite'),('optional_native_k12','all_external_composite'),('all_native_composite','all_external_composite'))
def need(ok,message):
    if not ok:raise ValueError(message)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def exact(commit,path):
    need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full immutable commit required')
    need(Path(path).read_bytes()==subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT),'Changed committed artifact '+str(path))
def load():
    anchor=json.loads((HERE/'completed-raw-anchor.json').read_text());need(anchor['complete']is True,'Complete committed raw required')
    source=anchor['producer_commit'];need(source==SOURCE,'Wrong fixed producer');raw=anchor['raw_commit'];directory=PRODUCER/'results-v1';manifest=directory/'RAW_ARCHIVE.json'
    exact(raw,manifest);need(sha(manifest)==anchor['raw_manifest_sha256'],'Raw seal changed')
    document=json.loads(manifest.read_text());need(document['source_commit']==source and len(document['files'])==77,'Wrong producer/raw inventory')
    for name,item in document['files'].items():
        path=directory/name;need(path.resolve().is_relative_to(directory),'Raw path escape');exact(raw,path)
        need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Raw artifact changed')
    log=PRODUCER/'screen-run.log';exact(raw,log);need(sha(log)==anchor['screen_log_sha256'],'Whole-operation log changed')
    exact(source,PRODUCER/'ANALYSIS_RULES.json');need(sha(PRODUCER/'ANALYSIS_RULES.json')==anchor['analysis_rules_sha256'],'Rules changed')
    metadata,records,counts=producer_audit.load_complete(source)
    need(counts['rows']==486 and counts['unpooled_api_geometry_quality_records']==81,'Incomplete audited producer')
    return metadata,records,anchor
def wilson(fp,n):
    need(n>0 and 0<=fp<=n,'Invalid quality counts');z=1.959963984540054;p=fp/n;d=1+z*z/n
    return min(1.,(p+z*z/(2*n)+z*math.sqrt(p*(1-p)/n+z*z/(4*n*n)))/d)
def owner(point):return {'external':'retained_external','native_experimental':'optional_native_range'}.get(point['owner'],point['owner'])
def includes(group,value):
    if group=='all_external_composite':return value in ('poppy_external','retained_external')
    if group=='all_native_composite':return value in ('production_native','optional_native_range','optional_native_k12')
    return group==value
def best(values,group):
    eligible=[r for r in values if r['eligible']and includes(group,r['owner'])]
    if not eligible:return []
    value=min(r['latency_ns']for r in eligible)
    return sorted([r for r in eligible if r['latency_ns']==value],key=lambda x:(x['actual_bytes'],x['configuration_id']))
def outcome(ratio):return 'win'if ratio<1 else'loss'if ratio>1 else'tie'
def comparison(left,right):
    if not left or not right:return dict(outcome='no_comparable',latency_ratio=None,numerator_winners=left,denominator_winners=right)
    ratio=left[0]['latency_ns']/right[0]['latency_ns'];return dict(outcome=outcome(ratio),latency_ratio=ratio,numerator_winners=left,denominator_winners=right)
def calculate(records):
    producer_counts,observations,links=contract.validate_records(records)
    points={p['configuration_id']:p for p in selection()['configurations']};quality=[];qmap={}
    for row in observations:
        ident=row['configuration_id'];p=points[ident];n=row['absent'];fp=row['false_positives'];need(n==1<<26,'Wrong single quality denominator')
        q=dict(row,owner=owner(p),observed_fpr=fp/n,wilson95_upper=wilson(fp,n));quality.append(q);qmap[ident]=q
    flat=[];lookup={};vectors=[]
    for record in records:
        case=record['case'];ids={points[i]['filter']:i for i in case['configuration_ids']}
        for position,row in enumerate(record['rows']):
            ident=ids[row['filter']];p=points[ident];q=qmap[ident]
            meta=dict(configuration_id=ident,filter=row['filter'],owner=owner(p),keys=case['keys'],actual_bytes=int(row['filter_bytes']),round=case['round'],batch=case['batch'],case_index=case['index'],filter_position=position,calibration_case_index=q['case_index'],false_positives=q['false_positives'],quality_absent=q['absent'],quality_upper=q['wilson95_upper'])
            flat.append(dict(meta,row=row));key=(ident,case['round'],case['batch']);need(key not in lookup,'Duplicate geometry/round/batch');lookup[key]=dict(meta,row=row)
            for metric in QUERY:
                values=[float(x)for x in row[metric.removesuffix('_ns')+'_trials'].split('|')]
                vectors.append(dict(meta,metric=metric,values=values,median_ns=float(row[metric])))
    views=[];alternatives=[];contrasts=[]
    for category,metrics in [('query',QUERY),('build',BUILD)]:
        for round_index in (1,2):
            for n in (65536,33554432):
                for batch in (1,31,4096):
                    for cap in CAPS:
                        for target in TARGETS:
                            for metric in metrics:
                                key=dict(category=category,round=round_index,keys=n,batch=batch,cap_bpk=cap,target_fpr=target,metric=metric);local=[]
                                for entry in flat:
                                    if entry['round']!=round_index or entry['keys']!=n or entry['batch']!=batch or entry['actual_bytes']*8>n*cap:continue
                                    value=float(entry['row'][metric]);need(math.isfinite(value)and value>0,'Invalid actual median')
                                    candidate={k:v for k,v in entry.items()if k!='row'}|key|dict(latency_ns=value,eligible=entry['quality_upper']<=target)
                                    local.append(candidate)
                                alternatives.extend(local);leaders={group:best(local,group)for group in OWNERS};views.append(dict(key,leaders=leaders))
                                for left,right in CONTRASTS:contrasts.append(dict(key,numerator_group=left,denominator_group=right,**comparison(leaders[left],leaders[right])))
    pairs=[]
    for ident,p in points.items():
        for batch in (1,31,4096):
            left=lookup[(ident,2,batch)];right=lookup[(ident,1,batch)]
            for metric in QUERY+BUILD:
                a,b=float(left['row'][metric]),float(right['row'][metric]);ratio=a/b
                pairs.append(dict(configuration_id=ident,filter=p['filter'],owner=owner(p),keys=p['keys'],actual_bytes=p['actual_bytes'],batch=batch,metric=metric,round2_ns=a,round1_ns=b,round2_over_round1=ratio,outcome=outcome(ratio),round1_case=right['case_index'],round2_case=left['case_index'],round1_position=right['filter_position'],round2_position=left['filter_position'],quality_upper=qmap[ident]['wilson95_upper']))
    counts=dict(rows=len(flat),quality_records=len(quality),quality_links=len(links),query_vectors=len(vectors),query_values=sum(len(v['values'])for v in vectors),build_medians=len(flat)*4,query_views=sum(v['category']=='query'for v in views),build_views=sum(v['category']=='build'for v in views),query_alternatives=sum(v['category']=='query'for v in alternatives),build_alternatives=sum(v['category']=='build'for v in alternatives),query_named_contrasts=sum(v['category']=='query'for v in contrasts),build_named_contrasts=sum(v['category']=='build'for v in contrasts),round_pairs=len(pairs))
    need(counts==dict(rows=486,quality_records=81,quality_links=486,query_vectors=1944,query_values=15552,build_medians=1944,query_views=432,build_views=432,query_alternatives=13320,build_alternatives=13320,query_named_contrasts=3888,build_named_contrasts=3888,round_pairs=1944),'Fixed analysis coverage changed')
    return dict(counts=counts,quality=quality,quality_links=links,rows=flat,query_vectors=vectors,views=views,alternatives=alternatives,contrasts=contrasts,round_pairs=pairs)
def report(data):
    lines=['# Poppy public APIs: complete fixed486','',
      'This report uses the complete two-round fixed36-process matrix only. All47 fitting Poppy mappings,32 prior strong leader geometries and2 original K12 controls remain. Each API/geometry has one held-out2^26-negative calibration; aliases, rounds, batches and historical observations add no denominator. The81 quality records share a common seen seed/input stream and are not81 independent experiments.','',
      '**All ratios are numerator latency / denominator latency; below1 is faster.** Query and construction remain separate; actual allocated bytes include Poppy cache. Smaller selected allocations are eligible under larger caps. Cross-budget leaders may come from separate processes in the same round. Exact median ties retain every winner.','',
      '## All named qualified contrasts','',
      '| Category | Round | Metric | Numerator / denominator | Wins | Losses | Ties | No comparable |','|---|---:|---|---|---:|---:|---:|---:|']
    groups=defaultdict(list)
    for row in data['contrasts']:groups[(row['category'],row['round'],row['metric'],row['numerator_group'],row['denominator_group'])].append(row)
    for key,rows in sorted(groups.items()):
        category,rnd,metric,left,right=key;c=Counter(r['outcome']for r in rows);lines.append(f'| {category} | {rnd} | {metric} | {left} / {right} | {c["win"]} | {c["loss"]} | {c["tie"]} | {c["no_comparable"]} |')
    lines+=['','No-comparable views are not wins and are excluded from win denominators. The two composite groups are labelled unions, not production-only outcomes or new samples. All26,640 alternatives and7,776 contrasts remain in machine-readable outputs, including every failed-quality and slower point.','',
      '## Every calibration record','',
      '| Configuration | Owner | Actual bytes | FP / negatives | Wilson95 upper % | Failed ceilings |','|---|---|---:|---|---:|---|']
    for row in data['quality']:
        failed=[f'{100*t:g}%'for t in TARGETS if row['wilson95_upper']>t]
        lines.append(f'| {row["configuration_id"]} | {row["owner"]} | {row["actual_bytes"]} | {row["false_positives"]} / {row["absent"]} | {100*row["wilson95_upper"]:.9f} | {", ".join(failed) if failed else "none"} |')
    lines+=['','All1,944 same-geometry round2/round1 metric comparisons retain both positions and all losses. Reversal does not isolate an order effect: only round1/batch4096 calibrates, so thermal/cache/calibration histories differ. These are seen seed42 and repeated nested views, not fresh-seed confirmation, confidence intervals or a significance claim.','',
      'Public eight-byte preparation, cache/bucket/secondary hashing, Result handling and dense answer production remain charged. Actual Poppy contains_bytes remains out of line per key in the measured native executable; other types receive the same caller/compiler visibility. These are public API comparisons, not core-bitmap-only times. Staged and visible, prehashed and common-hash modes are never combined.','',
      'The unchanged caller emits1,944 eight-sample query vectors but only1,944 construction medians. No missing construction vectors or uncertainty estimates are invented. Allocation-plus-insertion includes its insertion interval; several contrasts share controls. Cross-process agreement is source/geometry/output-checksum/count evidence, not an archived full-array or raw-input-digest comparison. No previous latency is imported. All quality failures, slower results and unavailable rivals remain; no global-fastest, multithread, parameter-retuning or automatic-promotion claim follows.','']
    return '\n'.join(lines)
def write_csv(path,rows):
    with path.open('w',newline='')as f:
        writer=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader()
        writer.writerows({k:json.dumps(v,separators=(',',':'))if isinstance(v,(list,dict))else v for k,v in row.items()}for row in rows)
def main():
    need(__debug__,'Python -O forbidden');p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);args=p.parse_args();need(not args.output.exists()and not args.output.is_symlink(),'Preserve earlier analysis')
    metadata,records,anchor=load();data=calculate(records);args.output.mkdir()
    for name in ['quality','quality_links','query_vectors','views','alternatives','contrasts','round_pairs']:write_csv(args.output/(name+'.csv'),data[name])
    (args.output/'all-records.json').write_text(json.dumps(data,indent=2,allow_nan=False)+'\n')
    (args.output/'metadata.json').write_text(json.dumps(dict(counts=data['counts'],raw_anchor=anchor,started=metadata['started'],finished=metadata['finished']),indent=2)+'\n')
    (args.output/'REPORT.md').write_text(report(data));print(json.dumps(data['counts']))
if __name__=='__main__':main()
