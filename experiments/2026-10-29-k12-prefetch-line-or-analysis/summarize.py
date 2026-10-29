#!/usr/bin/env python3
"""Complete fixed72 construction analysis; never invokes a compiler or filter."""
import argparse,csv,hashlib,io,json,math,statistics,subprocess,sys
from collections import Counter,defaultdict
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PRODUCER=ROOT/'experiments/2026-10-29-k12-prefetch-line-or/screening'
SOURCE='957b17ad279c23b2292b59808cad9ebe09e839a8'
sys.path.insert(0,str(PRODUCER))
import audit as producer_audit
import screen_contract as contract
TYPES=contract.TYPES;SEEDS=contract.SEEDS
METRICS=('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns')
VECTORS=('insert_trials_ns','allocate_insert_trials_ns','hash_insert_trials_ns','allocate_hash_insert_trials_ns')
CONTRASTS=((TYPES[1],TYPES[0]),(TYPES[1],TYPES[2]),(TYPES[0],TYPES[2]))
TARGET=.0001
def need(ok,message):
    if not ok:raise ValueError(message)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def exact(commit,path):
    need(len(commit)==40 and set(commit)<=set('0123456789abcdef'),'Full immutable commit required')
    need(subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)==path.read_bytes(),'Committed artifact changed')
def load():
    anchor=json.loads((HERE/'raw-anchor.json').read_text());need(anchor['complete']is True,'Complete committed raw required')
    directory=PRODUCER/'results-v1';manifest=directory/'RAW_ARCHIVE.json';exact(anchor['commit'],manifest)
    need(sha(manifest)==anchor['manifest_sha256'],'Changed raw manifest')
    for name,item in json.loads(manifest.read_text())['files'].items():
        path=directory/name;need(path.resolve().is_relative_to(directory),'Raw path escaped')
        need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Raw artifact changed');exact(anchor['commit'],path)
    metadata,rows,counts=producer_audit.load_complete(SOURCE)
    need(counts==contract.COUNTS,'Incomplete fixed coverage');exact(SOURCE,PRODUCER/'ANALYSIS_RULES.json')
    return metadata,rows
def wilson(fp,n):
    need(n>0 and 0<=fp<=n,'Invalid calibration');z=1.959963984540054;p=fp/n;den=1+z*z/n
    return min(1.,(p+z*z/(2*n)+z*math.sqrt(p*(1-p)/n+z*z/(4*n*n)))/den)
def outcome(ratio):return 'faster'if ratio<1 else'slower'if ratio>1 else'tie'
def compute(rows):
    contract.complete(rows);ledger=contract.plan();groups={}
    for i,item in enumerate(ledger):
        values=rows[3*i:3*i+3];contract.parse(contract.csv_text(values),item)
        key=(item['keys'],item['insert_batch'],item['seed']);need(key not in groups,'Duplicate fixed cell')
        groups[key]=(item,{r['filter']:r for r in values})
    api={};mapping={}
    for row in rows:
        key=(int(row['keys']),row['filter'],int(row['seed']));fp=int(row['calibration_false_positives']);n=int(row['calibration_absent_queries'])
        need(n==1<<26,'Changed independent denominator')
        value=dict(keys=key[0],filter=key[1],seed=key[2],actual_bytes=int(row['filter_bytes']),absent=n,false_positives=fp,
            observed_fpr=fp/n,wilson95_upper=wilson(fp,n),target=TARGET,passes=wilson(fp,n)<=TARGET)
        need(api.get(key,value)==value,'Repeated construction quality differs');api[key]=value
        family='Range'if key[1]==TYPES[2]else'K12';mkey=(key[0],family,key[2])
        canonical={k:v for k,v in value.items()if k!='filter'}|{'mapping':family}
        need(mapping.get(mkey,canonical)==canonical,'Known alias quality differs');mapping[mkey]=canonical
    gates={}
    for n in (1<<16,1<<20,1<<22,1<<25):
        for name in TYPES:
            values=[api[(n,name,seed)]for seed in SEEDS]
            gates[(n,name)]=dict(keys=n,filter=name,seeds=list(SEEDS),all_three_pass=all(v['passes']for v in values),
                worst_wilson95_upper=max(v['wilson95_upper']for v in values),individual=values)
    pairs=[];vectors=[]
    for key,(item,group)in groups.items():
        shared=dict(keys=key[0],insert_batch=key[1],seed=key[2],filter_bytes=item['expected_bytes'],
            existing_prefetch_branch=item['existing_prefetch_branch'],filter_order=item['filter_order'])
        for name in TYPES:
            row=group[name]
            for metric,vector in zip(METRICS,VECTORS):
                samples=json.loads(row[vector]);need(len(samples)==7,'Changed build trial count')
                vectors.append(dict(**shared,filter=name,metric=metric,trials=samples,median_ns=float(row[metric]),
                    minimum_ns=min(samples),maximum_ns=max(samples)))
        for first,second in CONTRASTS:
            left,right=group[first],group[second]
            lq,rq=api[(key[0],first,key[2])],api[(key[0],second,key[2])]
            lg,rg=gates[(key[0],first)],gates[(key[0],second)]
            for metric,vector in zip(METRICS,VECTORS):
                a,b=float(left[metric]),float(right[metric]);ratio=a/b
                pairs.append(dict(**shared,numerator=first,denominator=second,metric=metric,numerator_ns=a,denominator_ns=b,
                    latency_ratio=ratio,outcome=outcome(ratio),numerator_trials=json.loads(left[vector]),denominator_trials=json.loads(right[vector]),
                    numerator_upper=lq['wilson95_upper'],denominator_upper=rq['wilson95_upper'],current_both_qualified=lq['passes']and rq['passes'],
                    all_three_both_qualified=lg['all_three_pass']and rg['all_three_pass'],same_mapping=second==TYPES[0]))
    bins=defaultdict(list)
    for row in pairs:bins[(row['keys'],row['insert_batch'],row['numerator'],row['denominator'],row['metric'])].append(row)
    ranges=[]
    for key,values in sorted(bins.items()):
        need(len(values)==3 and {r['seed']for r in values}==set(SEEDS),'Missing fixed seed')
        ordered=sorted(values,key=lambda r:SEEDS.index(r['seed']));ratios=[r['latency_ratio']for r in ordered]
        ranges.append(dict(zip(('keys','insert_batch','numerator','denominator','metric'),key))|
            dict(seeds=list(SEEDS),latency_ratios=ratios,min_latency_ratio=min(ratios),max_latency_ratio=max(ratios),
                outcomes=[r['outcome']for r in ordered],current_both_qualified=[r['current_both_qualified']for r in ordered],
                all_three_both_qualified=all(r['all_three_both_qualified']for r in values)))
    counts=dict(rows=len(rows),contracts=len(groups),pairs=len(pairs),build_vectors=len(vectors),build_metric_samples=sum(len(v['trials'])for v in vectors),
                seed_ranges=len(ranges),api_quality_records=len(api),mapping_quality_records=len(mapping),all_three_gates=len(gates))
    need(counts==dict(rows=72,contracts=24,pairs=288,build_vectors=288,build_metric_samples=2016,seed_ranges=96,
                     api_quality_records=36,mapping_quality_records=24,all_three_gates=12),'Fixed analysis cardinalities changed')
    return dict(counts=counts,paired=pairs,vectors=vectors,ranges=ranges,quality_api=list(api.values()),quality_mapping=list(mapping.values()),gates=list(gates.values()))
def report(data):
    lines=['# Conditional K12 construction: complete fixed72','',
      'The fixed C++ screen uses n16/20/22/25 (192 KiB/3 MiB/12 MiB/96 MiB at actual24 bpk), insertion chunks4/whole input, and seeds15485863/32452843/49979687. Each of24 processes runs old K12, conditional K12 and native Range with seven fresh construction repetitions. CPU2/NUMA0 and the exact checked binary remain fixed. Query q18/hit50/b4096 is semantic control only.','',
      '**Ratios are numerator latency / denominator latency; below1 is faster.** Allocation-plus-build is the primary contract and contains its insertion subinterval. Three-seed ranges are descriptive, not confidence intervals. All288 comparisons and288 seven-value vectors remain in the CSVs. No previous latency is imported.','',
      '## Conditional / original K12, every fixed cell','',
      '| Keys | Chunk | Metric | Minimum ratio | Maximum ratio | Three seed outcomes |','|---:|---:|---|---:|---:|---|']
    for r in data['ranges']:
        if (r['numerator'],r['denominator'])!=(TYPES[1],TYPES[0]):continue
        lines.append(f"| {r['keys']} | {r['insert_batch']} | {r['metric']} | {r['min_latency_ratio']:.6f} | {r['max_latency_ratio']:.6f} | {' / '.join(r['outcomes'])} |")
    lines+=['','## Allocation-inclusive internal Range comparisons','',
      '| Keys | Chunk | Numerator / Range | Metric | Minimum ratio | Maximum ratio | Three outcomes | Both mappings pass all seeds |','|---:|---:|---|---|---:|---:|---|---|']
    for r in data['ranges']:
        if r['denominator']!=TYPES[2]or not r['metric'].startswith('allocate_'):continue
        lines.append(f"| {r['keys']} | {r['insert_batch']} | {r['numerator']} | {r['metric']} | {r['min_latency_ratio']:.6f} | {r['max_latency_ratio']:.6f} | {' / '.join(r['outcomes'])} | {r['all_three_both_qualified']} |")
    lines+=['','Range is an internal native control. Unqualified mappings remain unconditional timing observations, not qualified competitive wins. Same-mapping K12 comparisons remain informative with their quality attached. No external construction ranking is claimed.','',
      '## Every per-construction quality bound','',
      '| Keys | API | Seed | FP / negatives | Wilson upper % | Pass0.01% |','|---:|---|---:|---:|---:|---|']
    for q in data['quality_api']:lines.append(f"| {q['keys']} | {q['filter']} | {q['seed']} | {q['false_positives']} / {q['absent']} | {100*q['wilson95_upper']:.9f} | {q['passes']} |")
    losses=[r for r in data['paired']if r['outcome']=='slower']
    lines+=['','## Every slower comparison','',
      '| Keys | Chunk | Seed | Numerator / denominator | Metric | Latency ratio |','|---:|---:|---:|---|---|---:|']
    for r in losses:lines.append(f"| {r['keys']} | {r['insert_batch']} | {r['seed']} | {r['numerator']} / {r['denominator']} | {r['metric']} | {r['latency_ratio']:.6f} |")
    if not losses:lines.append('| — | — | — | none | — | — |')
    lines+=['','Quality has36 API records and24 proven mapping records; duplicate chunks and K12 aliases reuse one denominator. Pointwise Wilson endpoints are not simultaneous guarantees. Negative intervals are disjoint from inserted/query intervals within each construction; different filters/seeds do not create independent random functions or guaranteed disjoint streams.','',
      'Latin positions balance the three seeds per cell, not all six predecessor directions. Pure-before-common build phases remain fixed; seed/order/code-layout effects are not separately isolated. The small false branch has unchanged instructions but a distinct actual caller/code layout. These are the measured construction scopes only: no query, Rust, multithread, universal speed or significance claim, and no automatic promotion or further threshold search.','']
    return '\n'.join(lines)
def write_csv(path,rows):
    with path.open('w',newline='')as f:
        writer=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader()
        writer.writerows({k:json.dumps(v,separators=(',',':'))if isinstance(v,(list,dict))else v for k,v in row.items()}for row in rows)
def main():
    need(__debug__,'Python -O unsupported');p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    need(not a.output.exists()and not a.output.is_symlink(),'Preserve earlier reports')
    meta,rows=load();data=compute(rows);a.output.mkdir()
    for key in ('paired','vectors','ranges','quality_api','quality_mapping','gates'):write_csv(a.output/(key+'.csv'),data[key])
    (a.output/'all-records.json').write_text(json.dumps(data,indent=2,allow_nan=False)+'\n')
    summary=dict(counts=data['counts'],source_commit=SOURCE,raw_anchor=json.loads((HERE/'raw-anchor.json').read_text()),started=meta['started'],finished=meta['finished'],
      outcomes={first+'/'+second:dict(Counter(r['outcome']for r in data['paired']if r['numerator']==first and r['denominator']==second))for first,second in CONTRASTS})
    (a.output/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');(a.output/'REPORT.md').write_text(report(data));print(json.dumps(summary))
if __name__=='__main__':main()
