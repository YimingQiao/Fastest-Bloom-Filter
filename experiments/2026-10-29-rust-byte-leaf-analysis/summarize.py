#!/usr/bin/env python3
"""Postprocess fixed Byte216 confirmation, retaining each seed and filter-order stratum."""
import csv,hashlib,json,math,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
EXPERIMENT=HERE.parent/'2026-10-29-rust-byte-leaf-confirmation'
sys.path.insert(0,str(EXPERIMENT))
from freeze import verify
from guard import require,validate_all,workloads
from run import verify_commit
ORIGINAL='ByteSplitBloomFilter'; CANDIDATE='ByteLeafInlineV1'; EXTERNAL='BloomsdayPinned'
METRICS=('lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def gm(v):return math.exp(sum(math.log(x) for x in v)/len(v))
def wilson(fp,n):
    require(n>0 and 0<=fp<=n,'Invalid quality count')
    z=1.959963984540054;zz=z*z;p=fp/n;c=p+zz/(2*n);w=z*math.sqrt((p*(1-p)+zz/(4*n))/n);d=1+zz/n
    return (0 if fp==0 else max(0,(c-w)/d),1 if fp==n else min(1,(c+w)/d))
def outcome(r):return 'candidate_faster' if r>1 else 'original_or_external_faster' if r<1 else 'exact_tie'
def csvout(path,rows):
    require(bool(rows),'Empty table')
    with path.open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
def load():
    screen=EXPERIMENT/'screen';m=json.loads((screen/'metadata.json').read_text());p=json.loads((EXPERIMENT/'protocol.json').read_text());reg=json.loads((EXPERIMENT/'registry.json').read_text());f=json.loads((EXPERIMENT/'validation/freeze.json').read_text())
    verify(f);verify_commit(m['source_commit'],f)
    require(m['complete'] and m['rows']==216 and m['workloads']==96,'Incomplete matrix')
    require(m['cpu']==2 and m['affinity']==[2] and m['lease']['lease']=='socket0','Wrong CPU/lease')
    require(m['freeze_sha256']==sha(EXPERIMENT/'validation/freeze.json') and m['protocol_sha256']==sha(EXPERIMENT/'protocol.json'),'Changed protocol')
    require(m['binary_sha256']==p['binary_sha256'] and m['results_sha256']==sha(screen/'results.csv'),'Changed binary/results')
    require({tuple(x['workload']) for x in m['commands']}==set(workloads(p)) and len(m['commands'])==96,'Wrong command grid')
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
    records=[];groups={}
    for r in rows:
        if r['batch']!='1' or r['filter']==CANDIDATE:continue
        fp,n=int(r['calibration_false_positives']),int(r['calibration_absent_queries']);lo,hi=wilson(fp,n)
        item=dict(family=r['filter'],keys=int(r['keys']),requested_bpk=int(r['requested_bpk']),actual_bpk=float(r['actual_bpk']),filter_bytes=int(r['filter_bytes']),seed=int(r['seed']),negatives=n,false_positives=fp,fpr=fp/n,wilson_lower=lo,wilson_upper=hi)
        records.append(item);groups.setdefault((item['family'],item['keys'],item['requested_bpk']),[]).append(item)
    worst=[]
    for (family,n,bpk),rr in sorted(groups.items()):
        require(len(rr)==6 and len({r['seed'] for r in rr})==6,'Wrong distinct seed quality records')
        worst.append(dict(family=family,keys=n,requested_bpk=bpk,actual_bpk=rr[0]['actual_bpk'],filter_bytes=rr[0]['filter_bytes'],seeds=6,worst_wilson_upper=max(r['wilson_upper'] for r in rr),minimum_point_fpr=min(r['fpr'] for r in rr),maximum_point_fpr=max(r['fpr'] for r in rr)))
    return records,worst

def paired(rows,orders):
    idx={(r['filter'],int(r['keys']),int(r['requested_bpk']),int(r['batch']),int(r['seed'])):r for r in rows};pairs=[];api=[]
    for r in rows:
        common=dict(keys=int(r['keys']),requested_bpk=int(r['requested_bpk']),actual_bpk=float(r['actual_bpk']),batch=int(r['batch']),seed=int(r['seed']))
        if r['filter']==CANDIDATE:
            key=(common['keys'],common['requested_bpk'],common['batch'],common['seed']);o=idx[(ORIGINAL,*key)];order=orders[key];first=order.index(CANDIDATE)<order.index(ORIGINAL)
            for metric in METRICS:
                ratio=float(o[metric])/float(r[metric]);prefix=metric[:-3]
                pairs.append(dict(**common,metric=metric,candidate_first=first,filter_order='|'.join(order),original_ns=float(o[metric]),candidate_ns=float(r[metric]),original_min_ns=float(o[prefix+'_min_ns']),original_max_ns=float(o[prefix+'_max_ns']),candidate_min_ns=float(r[prefix+'_min_ns']),candidate_max_ns=float(r[prefix+'_max_ns']),original_over_candidate=ratio,outcome=outcome(ratio)))
        for name,a,b in [('prehashed','lookup_ns','inline_lookup_ns'),('raw','hash_lookup_ns','inline_hash_lookup_ns')]:
            ratio=float(r[a])/float(r[b]);api.append(dict(**common,filter=r['filter'],mode=name,generic_ns=float(r[a]),visible_ns=float(r[b]),generic_over_visible=ratio))
    return pairs,api

def pair_aggregates(pairs):
    groups={}
    for r in pairs:groups.setdefault((r['keys'],r['requested_bpk'],r['batch'],r['metric']),[]).append(r)
    allgroups=[];strata=[]
    for (n,bpk,batch,metric),rr in sorted(groups.items()):
        require(len(rr)==6 and sum(r['candidate_first'] for r in rr)==3,'Unbalanced seed/order group')
        for first in (None,False,True):
            values=[r['original_over_candidate'] for r in rr if first is None or r['candidate_first']==first]
            row=dict(keys=n,requested_bpk=bpk,batch=batch,metric=metric,candidate_first='both' if first is None else first,seeds=len(values),geomean_original_over_candidate=gm(values),minimum_ratio=min(values),maximum_ratio=max(values),candidate_faster=sum(v>1 for v in values),original_faster=sum(v<1 for v in values),exact_ties=sum(v==1 for v in values))
            (allgroups if first is None else strata).append(row)
    return allgroups,strata

def comparisons(rows,worst,p):
    b1=[r for r in rows if r['batch']=='1']; idx={(r['filter'],int(r['keys']),int(r['requested_bpk']),int(r['seed'])):r for r in b1}
    quality_index={(r['family'],r['keys'],r['requested_bpk']):r for r in worst}
    detailed=[];rankings=[]
    for power in p['key_powers']:
      n=1<<power
      for metric in METRICS:
       for cap in p['ranking']['memory_caps_bpk']:
        for ceiling in p['ranking']['fpr_ceilings']:
         def qualifies(family,bpk):
            q=quality_index[(family,n,bpk)];return q['filter_bytes']*8<=n*cap and q['worst_wilson_upper']<=ceiling
         for cb in p['requested_bpk']:
          for eb in p['requested_bpk']:
           cq,eq=qualifies(ORIGINAL,cb),qualifies(EXTERNAL,eb)
           for seed in p['seeds']:
            c,e=idx[(CANDIDATE,n,cb,seed)],idx[(EXTERNAL,n,eb,seed)];ratio=float(e[metric])/float(c[metric]) if cq and eq else None
            detailed.append(dict(keys=n,metric=metric,cap_bpk=cap,fpr_ceiling=ceiling,candidate_requested_bpk=cb,external_requested_bpk=eb,seed=seed,candidate_qualifies_all_seeds=cq,external_qualifies_all_seeds=eq,candidate_ns=float(c[metric]),external_ns=float(e[metric]),external_over_candidate=ratio,outcome=outcome(ratio) if ratio is not None else 'no_eligible_pair'))
         selected={}
         for name in (ORIGINAL,CANDIDATE,EXTERNAL):
            family=ORIGINAL if name==CANDIDATE else name
            available=[]
            for bpk in p['requested_bpk']:
                if qualifies(family,bpk):
                    values=[float(idx[(name,n,bpk,s)][metric]) for s in p['seeds']]
                    available.append(dict(filter=name,requested_bpk=bpk,actual_bpk=bpk*2,geomean_seed_median_ns=gm(values),per_seed_ns=values,worst_wilson_upper=quality_index[(family,n,bpk)]['worst_wilson_upper']))
            selected[name]=min(available,key=lambda v:(v['geomean_seed_median_ns'],v['actual_bpk'])) if available else None
         c,e=selected[CANDIDATE],selected[EXTERNAL]
         ratios=[a/b for a,b in zip(e['per_seed_ns'],c['per_seed_ns'])] if c and e else []
         rankings.append(dict(keys=n,metric=metric,cap_bpk=cap,fpr_ceiling=ceiling,original=selected[ORIGINAL],candidate=c,external=e,seeds=p['seeds'],external_over_candidate_per_seed=ratios,geomean_ratio=gm(ratios) if ratios else None,candidate_faster=sum(v>1 for v in ratios),external_faster=sum(v<1 for v in ratios),exact_ties=sum(v==1 for v in ratios)))
    return detailed,rankings

def main():
    require(__debug__,'Run analysis without Python -O');rows,orders,p,m=load();q,w=quality(rows);pairs,api=paired(rows,orders);conditions,strata=pair_aggregates(pairs);external,rankings=comparisons(rows,w,p)
    require(tuple(map(len,(q,w,pairs,api,conditions,strata,external,rankings)))==(48,8,384,432,64,128,1152,48),'Wrong analysis counts')
    out=HERE/'report';out.mkdir(exist_ok=False)
    for name,table in [('quality.csv',q),('quality-worst.csv',w),('paired-ratios.csv',pairs),('api-ratios.csv',api),('conditions.csv',conditions),('order-strata.csv',strata),('external-comparisons.csv',external)]:csvout(out/name,table)
    (out/'rankings.json').write_text(json.dumps(rankings,indent=2,allow_nan=False)+'\n')
    summary=dict(scope='Six-seed CPU2 unchanged-binary Byte leaf confirmation; initial CPU3 screen kept separate',rows=216,workloads=96,quality_records=48,quality_worst_records=8,paired_ratios=384,order_strata=128,api_ratios=432,external_allocation_comparisons=1152,rankings=48,source_commit=m['source_commit'],binary_sha256=m['binary_sha256'],results_sha256=m['results_sha256'],analysis_sha256=sha(Path(__file__)),ranking_selection='Descriptive postprocessing: one eligible allocation per family chosen by geometric mean of six seed medians, held fixed across those seeds; all allocation alternatives retained. No speed CI or global leadership claim.',quality_rule='All six pointwise Wilson upper endpoints must pass; worst endpoint reported. No clone/batch/mode/seed pooling.',cpu_scope='CPU2 only; do not pool initial CPU3 measurements')
    (out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    lines=['# Byte leaf hint: six-seed confirmation','', 'The unchanged executable completed 96 workloads / 216 rows on CPU2. Original/candidate order is exactly 3:3 within each size/budget/batch group. Every output, workload, filter order, phase order and source/dependency/binary hash passed. The original CPU3 seed42 screen and its regression remain separate. This report makes no production decision.','', 'All 384 per-seed original/candidate ratios and their trial ranges remain in paired-ratios.csv. Ratios above1 favor the candidate. The128 order-stratified views report the three candidate-first and three original-first seeds separately; they are descriptive subsets, not additional samples.','', '| Keys | Requested bpk | Batch | Metric | Geometric original/candidate | Lowest | Highest | Candidate/original/ties |','| ---: | ---: | ---: | --- | ---: | ---: | ---: | --- |']
    for r in conditions:lines.append(f"| {r['keys']} | {r['requested_bpk']} | {r['batch']} | {r['metric']} | {r['geomean_original_over_candidate']:.3f} | {r['minimum_ratio']:.3f} | {r['maximum_ratio']:.3f} | {r['candidate_faster']}/{r['original_faster']}/{r['exact_ties']} |")
    lines+=['','External comparisons use only batch1 and the prespecified Bloomsday public API. All four modes stay separate; original generic-mode losses are not replaced by visible-mode gains. All1152 allocation/seed/cap/ceiling alternatives, including ineligible pairs and losses, are retained. Cap32 includes eligible actual16 allocations.','', 'rankings.json gives48 descriptive views. To retain a single configuration across seeds, each family chooses its eligible tested allocation by the geometric mean of six seed medians. This is postprocessing, not a preregistered statistical superiority test. Selection does not erase alternatives. Eligibility requires all six pointwise95% Wilson upper endpoints under the ceiling, with the worst endpoint reported. This is not a simultaneous-selection guarantee.','', 'quality.csv retains48 family/size/seed calibration records; quality-worst.csv gives8 across-seed extrema without pooling negatives. Byte original/candidate and repeated modes/batches reuse streams. Trial ranges and six-seed ratios are descriptive, not speed confidence intervals. No explicit NUMA memory binding or global-fastest claim is made.','']
    (out/'RESULTS.md').write_text('\n'.join(lines));print('PASS:384 seed pairs,128 order strata,48 quality records,1152 external alternatives')
if __name__=='__main__':main()
