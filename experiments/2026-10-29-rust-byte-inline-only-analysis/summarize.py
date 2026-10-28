#!/usr/bin/env python3
"""Describe all three Byte annotation controls, retaining every seed/mode/loss."""
import csv,hashlib,itertools,json,math,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
EXPERIMENT=HERE.parent/'2026-10-29-rust-byte-inline-only'
sys.path.insert(0,str(EXPERIMENT))
from freeze import verify
from guard import require,validate_all,workloads
from run import verify_commit
ORIGINAL='ByteSplitBloomFilter';TRIPLE='ByteTripleHintControl';CANDIDATE='ByteOnlyInlineV1'
METRICS=('lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns')
PAIRS=((ORIGINAL,CANDIDATE),(ORIGINAL,TRIPLE),(TRIPLE,CANDIDATE))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def gm(v):return math.exp(sum(math.log(x) for x in v)/len(v))
def wilson(fp,n):
    require(n>0 and 0<=fp<=n,'Invalid quality count')
    z=1.959963984540054;zz=z*z;p=fp/n;c=p+zz/(2*n);w=z*math.sqrt((p*(1-p)+zz/(4*n))/n);d=1+zz/n
    return (0 if fp==0 else max(0,(c-w)/d),1 if fp==n else min(1,(c+w)/d))
def csvout(path,rows):
    require(bool(rows),'Empty table')
    with path.open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
def load():
    screen=EXPERIMENT/'screen';m=json.loads((screen/'metadata.json').read_text());p=json.loads((EXPERIMENT/'protocol.json').read_text());reg=json.loads((EXPERIMENT/'registry.json').read_text());f=json.loads((EXPERIMENT/'validation/freeze.json').read_text())
    verify(f);verify_commit(m['source_commit'],f)
    require(m['complete'] and m['rows']==96 and m['workloads']==32,'Incomplete matrix')
    require(m['cpu']==3 and m['affinity']==[3] and m['lease']['lease']=='socket1','Wrong CPU/lease')
    require(m['freeze_sha256']==sha(EXPERIMENT/'validation/freeze.json') and m['protocol_sha256']==sha(EXPERIMENT/'protocol.json'),'Changed protocol')
    require(m['binary_sha256']==p['binary_sha256'] and m['results_sha256']==sha(screen/'results.csv'),'Changed binary/results')
    require({tuple(x['workload']) for x in m['commands']}==set(workloads(p)) and len(m['commands'])==32,'Wrong command grid')
    ordered=[];orders={}
    for e in m['commands']:
        power,bpk,batch,seed=e['workload'];path=screen/f'k{power}-p{bpk}-b{batch}-s{seed}.csv'
        require(e['complete'] and e['returncode']==0 and e['csv_sha256']==sha(path),'Failed/changed command')
        with path.open() as stream:rr=list(csv.DictReader(stream))
        require([r['filter'] for r in rr]==e['filter_order'],'Wrong recorded row order')
        ordered+=rr;orders[(1<<power,bpk,batch,seed)]=e['filter_order']
    with (screen/'results.csv').open() as stream:rows=list(csv.DictReader(stream))
    require(rows==ordered,'Aggregate differs from raw case order');validate_all(rows,reg,p)
    return rows,orders,p,m

def quality(rows):
    values=[];groups={}
    for r in rows:
        if r['filter']!=ORIGINAL or int(r['batch'])!=1:continue
        fp,n=int(r['calibration_false_positives']),int(r['calibration_absent_queries']);lo,hi=wilson(fp,n)
        item=dict(family='ByteSplit',keys=int(r['keys']),requested_bpk=int(r['requested_bpk']),actual_bpk=float(r['actual_bpk']),filter_bytes=int(r['filter_bytes']),seed=int(r['seed']),negatives=n,false_positives=fp,fpr=fp/n,wilson_lower=lo,wilson_upper=hi)
        values.append(item);groups.setdefault((item['keys'],item['requested_bpk']),[]).append(item)
    worst=[]
    for (n,bpk),rr in sorted(groups.items()):
        require(len(rr)==2 and len({r['seed'] for r in rr})==2,'Expected two unpooled seed records')
        worst.append(dict(keys=n,requested_bpk=bpk,actual_bpk=rr[0]['actual_bpk'],filter_bytes=rr[0]['filter_bytes'],distinct_seeds=2,worst_wilson_upper=max(r['wilson_upper'] for r in rr),minimum_fpr=min(r['fpr'] for r in rr),maximum_fpr=max(r['fpr'] for r in rr)))
    return values,worst

def paired(rows,orders):
    index={(r['filter'],int(r['keys']),int(r['requested_bpk']),int(r['batch']),int(r['seed'])):r for r in rows}
    pairs=[];api=[]
    for key,order in sorted(orders.items()):
        n,bpk,batch,seed=key
        for before,after in PAIRS:
            a,b=index[(before,*key)],index[(after,*key)]
            for metric in METRICS:
                ratio=float(a[metric])/float(b[metric]);prefix=metric[:-3]
                pairs.append(dict(before=before,after=after,keys=n,requested_bpk=bpk,actual_bpk=float(a['actual_bpk']),filter_bytes=int(a['filter_bytes']),batch=batch,seed=seed,metric=metric,after_first=order.index(after)<order.index(before),filter_order='|'.join(order),before_ns=float(a[metric]),after_ns=float(b[metric]),before_min_ns=float(a[prefix+'_min_ns']),before_max_ns=float(a[prefix+'_max_ns']),after_min_ns=float(b[prefix+'_min_ns']),after_max_ns=float(b[prefix+'_max_ns']),before_over_after=ratio,outcome='after_faster' if ratio>1 else 'before_faster' if ratio<1 else 'exact_tie'))
        for name in (ORIGINAL,TRIPLE,CANDIDATE):
            r=index[(name,*key)]
            for mode,a,b in [('prehashed','lookup_ns','inline_lookup_ns'),('raw','hash_lookup_ns','inline_hash_lookup_ns')]:
                api.append(dict(filter=name,keys=n,requested_bpk=bpk,batch=batch,seed=seed,mode=mode,generic_ns=float(r[a]),visible_ns=float(r[b]),generic_over_visible=float(r[a])/float(r[b])))
    return pairs,api

def aggregate(pairs):
    groups={}
    for r in pairs:groups.setdefault(tuple(r[k] for k in ('before','after','keys','requested_bpk','batch','metric')),[]).append(r)
    result=[];strata=[]
    for (before,after,n,bpk,batch,metric),rr in sorted(groups.items()):
        require(len(rr)==2 and len({r['seed'] for r in rr})==2 and sum(r['after_first'] for r in rr)==1,'Wrong pairwise order balance')
        for first in (None,False,True):
            selected=[r for r in rr if first is None or r['after_first']==first];v=[r['before_over_after'] for r in selected]
            row=dict(before=before,after=after,keys=n,requested_bpk=bpk,batch=batch,metric=metric,after_first='both' if first is None else first,seeds=len(v),geomean_before_over_after=gm(v),minimum_ratio=min(v),maximum_ratio=max(v),after_faster=sum(x>1 for x in v),before_faster=sum(x<1 for x in v),exact_ties=sum(x==1 for x in v))
            (result if first is None else strata).append(row)
    return result,strata

def main():
    if not __debug__:raise ValueError('Run analysis without Python -O')
    rows,orders,protocol,metadata=load();pairs,api=paired(rows,orders);conditions,strata=aggregate(pairs);q,worst=quality(rows)
    require((len(pairs),len(api),len(conditions),len(strata),len(q),len(worst))==(384,192,192,384,8,4),'Wrong analysis cardinalities')
    out=HERE/'report';out.mkdir(exist_ok=False)
    for name,values in [('paired-ratios',pairs),('api-ratios',api),('conditions',conditions),('order-strata',strata),('quality',q),('quality-worst',worst)]:csvout(out/(name+'.csv'),values)
    scope='Same-process native annotation/placement comparison only; no external leadership, no global fastest claim, no cross-CPU/binary timing comparison. Two seeds and repeated four-mode/batch views are not independent replicated algorithms or pooled quality samples.'
    summary=dict(scope=scope,cpu=3,workloads=32,rows=96,pairwise_records=len(pairs),conditions=len(conditions),unpooled_quality_records=8,seeds=protocol['seeds'],source_commit=metadata['source_commit'],binary_sha256=protocol['binary_sha256'],input_results_sha256=sha(EXPERIMENT/'screen/results.csv'),all_pairwise_losses=[r for r in pairs if r['before_over_after']<1],exact_ties=[r for r in pairs if r['before_over_after']==1])
    (out/'summary.json').write_text(json.dumps(summary,indent=2,allow_nan=False)+'\n')
    lines=['# Byte-only annotation comparison','',scope,'','All96 rows and source/binary pins pass. Pair orders reverse between seeds; absolute middle position is not balanced. The one-hint and triple-hint active visible code is identical, as are all three active batch3 AVX2 regions; addresses differ. These are descriptive measurements, not a causal alignment result or statistical superiority test.','','## Batch1 pair ratios','', 'Values above1 favor the row named after. Every individual loss and min/max remains in CSV/JSON.','','| Keys | Actual bpk | Metric | Original / one hint | Original / triple | Triple / one hint |','|---:|---:|---|---:|---:|---:|']
    idx={(r['before'],r['after'],r['keys'],r['requested_bpk'],r['batch'],r['metric']):r for r in conditions}
    for power,bpk,metric in itertools.product(protocol['key_powers'],protocol['requested_bpk'],METRICS):
        n=1<<power;v=[idx[(a,b,n,bpk,1,metric)]['geomean_before_over_after'] for a,b in PAIRS]
        lines.append(f'| {n} | {bpk*2} | {metric} | {v[0]:.4f} | {v[1]:.4f} | {v[2]:.4f} |')
    lines+=['','## All retained losses','']
    for before,after in PAIRS:
        rr=[r for r in pairs if r['before']==before and r['after']==after];v=[r['before_over_after'] for r in rr]
        lines.append(f'- {before} / {after}: after wins{sum(x>1 for x in v)}/{len(v)}, loses{sum(x<1 for x in v)}, ties{sum(x==1 for x in v)}; minimum ratio{min(v):.6f}. These views reuse data and are not independent significance trials.')
    lines+=['','Quality consists of8 size/budget/seed records, each with its own two-sided95% Wilson interval; clone, batch and mode repeats are discarded. Worst endpoints across the two seeds are reported without pooling. No allocation or candidate is selected by this report.','']
    (out/'RESULTS.md').write_text('\n'.join(lines))
    print('PASS:96 rows,384 pairs,192 API ratios,192 conditions,384 order strata,8 unpooled quality records')
if __name__=='__main__':main()
