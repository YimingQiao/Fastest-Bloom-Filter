#!/usr/bin/env python3
"""Offline all-loss analysis; refuses incomplete or uncommitted formal raw data."""
import argparse,csv,hashlib,importlib.util,io,json,math,statistics,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PRODUCER=ROOT/'experiments/2026-10-29-k12-line-or/screening'
SOURCE='c922861c75d193b9dbfc2c2399eea6b454d1f9eb'
METRICS=('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns')
VECTORS=('insert_trials_ns','allocate_insert_trials_ns','hash_insert_trials_ns','allocate_hash_insert_trials_ns')

def need(x,message):
    if not x:raise RuntimeError(message)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def exact(commit,path):
    need(len(commit)==40 and set(commit)<=set('0123456789abcdef'),'Full immutable commit required')
    need(subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)==path.read_bytes(),'Committed artifact changed')
def load():
    anchor=json.loads((HERE/'raw-anchor.json').read_text());need(anchor['complete'] is True,'No complete committed data anchor yet')
    raw=PRODUCER/'results-v1';manifest=raw/'RAW_ARCHIVE.json';exact(anchor['commit'],manifest);need(sha(manifest)==anchor['manifest_sha256'],'Raw manifest changed')
    for name,item in json.loads(manifest.read_text())['files'].items():
        path=raw/name;need(path.resolve().is_relative_to(raw),'Raw path escaped')
        need(sha(path)==item['sha256'] and path.stat().st_size==item['bytes'],'Raw artifact changed');exact(anchor['commit'],path)
    sys.path.insert(0,str(PRODUCER));from freeze import verify
    from screen_contract import audit
    frozen=verify(SOURCE);meta=json.loads((raw/'metadata.json').read_text())
    need(meta['freeze']==frozen,'Recorded source/binary freeze differs');audit(raw,meta,Path(frozen['binary']['path']),SOURCE,sha)
    return meta,json.loads((raw/'rows.json').read_text())
def compute(rows):
    need(len(rows)==16,'Expected all16 filter rows')
    groups={}
    for row in rows:
        key=(int(row['keys']),int(row['insert_batch']),int(row['seed']))
        bucket=groups.setdefault(key,{})
        need(row['filter'] not in bucket,'Duplicate actual type')
        bucket[row['filter']]=row
    need(len(groups)==8,'Wrong workload count')
    pairs=[];vectors=[]
    for key,group in groups.items():
        need(set(group)=={'K12ScalarOrControl','K12LineOrCandidate'},'Missing paired type')
        control=group['K12ScalarOrControl'];candidate=group['K12LineOrCandidate']
        common=dict(keys=key[0],insert_batch=key[1],seed=key[2],filter_order='control_then_candidate' if key[2]==5011 else 'candidate_then_control',filter_bytes=int(control['filter_bytes']))
        need(control['filter_bytes']==candidate['filter_bytes'],'Changed allocation')
        for metric,vector in zip(METRICS,VECTORS):
            raw={arm:json.loads(row[vector]) for arm,row in [('control',control),('candidate',candidate)]}
            for arm,row in [('control',control),('candidate',candidate)]:
                samples=raw[arm];need(len(samples)==5 and all(math.isfinite(x) and x>0 for x in samples),'Wrong trial vector')
                need(math.isclose(statistics.median(samples),float(row[metric]),rel_tol=1e-12,abs_tol=1e-12),'Trial median differs')
                vectors.append(dict(**common,metric=metric,arm=arm,trials=samples,median_ns=float(row[metric]),minimum_ns=min(samples),maximum_ns=max(samples)))
            c=float(control[metric]);p=float(candidate[metric]);ratio=p/c
            pairs.append(dict(**common,metric=metric,control_ns=c,candidate_ns=p,latency_ratio=ratio,outcome='slower' if ratio>1 else 'faster' if ratio<1 else 'tie',control_trials=raw['control'],candidate_trials=raw['candidate']))
    ranges=[];buckets={}
    for row in pairs:buckets.setdefault((row['keys'],row['insert_batch'],row['metric']),[]).append(row)
    for key,items in buckets.items():
        need({r['seed'] for r in items}=={5011,6011} and len(items)==2,'Missing fixed seed pair')
        ratios=[r['latency_ratio'] for r in items]
        ranges.append(dict(keys=key[0],insert_batch=key[1],metric=key[2],min_latency_ratio=min(ratios),max_latency_ratio=max(ratios),outcomes=[r['outcome'] for r in sorted(items,key=lambda r:r['seed'])]))
    need(len(pairs)==32 and len(vectors)==64 and len(ranges)==16,'Wrong analysis cardinalities')
    return pairs,vectors,ranges

def write_csv(path,rows):
    with path.open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader()
        writer.writerows({k:json.dumps(v,separators=(',',':')) if isinstance(v,list) else v for k,v in r.items()}for r in rows)
def report(pairs,ranges):
    lines=['# K12 whole-line insertion screen','',
      'Fixed n=65,536 and33,554,432; actual24bpk; insertion chunks4 and whole input; seeds5011/6011. Each of8 processes runs both actual public types, with relative filter order reversed for6011. Five fresh construction trials per pure/common-hash contract; q18/hit50/batch4096 queries validate semantics only. CPU3, NUMA1, Clang23 native binary.', '',
      'All ratios are **candidate latency / control latency**: below1 is faster. The two seed values are descriptive ranges, not confidence intervals. Allocation-plus-build contains the corresponding insertion interval; those measurements are dependent. Build phase order remains pure then common hash. No query, accuracy or external leadership ranking is made.', '',
      '| Keys | Insertion chunk | Metric | Minimum ratio | Maximum ratio | Seed5011 /6011 |','|---:|---:|---|---:|---:|---|']
    for r in ranges:lines.append(f"| {r['keys']} | {r['insert_batch']} | {r['metric']} | {r['min_latency_ratio']:.6f} | {r['max_latency_ratio']:.6f} | {' / '.join(r['outcomes'])} |")
    lines+=['','## Every slower outcome','','| Keys | Chunk | Seed | Metric | Control ns/key | Candidate ns/key | Latency ratio |','|---:|---:|---:|---|---:|---:|---:|']
    losses=[r for r in pairs if r['outcome']=='slower']
    for r in losses:lines.append(f"| {r['keys']} | {r['insert_batch']} | {r['seed']} | {r['metric']} | {r['control_ns']:.6f} | {r['candidate_ns']:.6f} | {r['latency_ratio']:.6f} |")
    if not losses:lines.append('| — | — | — | none | — | — | — |')
    lines+=['','All32 comparisons and64 original vectors are retained in paired.csv and trials.csv. Whole allocation-plus-build outcomes must be considered before any recommendation. The screen alone does not authorize production promotion or further parameter search.','']
    return '\n'.join(lines)
def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);a=p.parse_args();need(not a.output.exists(),'Preserve prior report')
    meta,rows=load();pairs,vectors,ranges=compute(rows);a.output.mkdir()
    for name,records in [('paired.csv',pairs),('trials.csv',vectors),('seed-ranges.csv',ranges)]:write_csv(a.output/name,records)
    summary=dict(cases=8,rows=16,paired_comparisons=32,build_vectors=64,metric_samples=320,seed_ranges=16,outcomes={k:sum(r['outcome']==k for r in pairs) for k in ('faster','slower','tie')},allocation_outcomes={k:sum(r['outcome']==k and r['metric'].startswith('allocate_') for r in pairs) for k in ('faster','slower','tie')},source_commit=SOURCE,raw_anchor=json.loads((HERE/'raw-anchor.json').read_text()),started=meta['started'],finished=meta['finished'])
    (a.output/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');(a.output/'REPORT.md').write_text(report(pairs,ranges));print(json.dumps(summary))
if __name__=='__main__':main()
