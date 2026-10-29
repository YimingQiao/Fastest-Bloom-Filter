#!/usr/bin/env python3
"""Offline fixed Rust K12 confirmation; require complete committed raw first."""
import argparse,csv,hashlib,importlib.util,json,math,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1];STAGE=ROOT/'experiments/2026-10-29-four-sector-range12-rust-screen';RAW=STAGE/'results-v1'
sys.path.insert(0,str(STAGE/'screening'))
from pins import verify,sha,need,full_commit
from contract import audit,configuration,rows,quality
SOURCE='b71707b5f7b562e3544befc6877492854673ff08'
CANDIDATE='FourSectorRange12BloomFilter'
OWNERS=('production_snapshot','optional_range_snapshot','K12_experiment','external')

def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
def load(raw_commit):
    full_commit(raw_commit);descriptor=RAW/'ARCHIVE.json';need(descriptor.read_bytes()==blob(raw_commit,descriptor),'Raw archive is not at exact committed revision')
    manifest=json.loads(descriptor.read_text());files=manifest['files'];need(set(files)=={p.name for p in RAW.iterdir()if p.is_file()and p.name!='ARCHIVE.json'},'Unexpected/missing raw evidence files')
    for name,record in files.items():
        path=RAW/name;need(sha(path)==record['sha256']and path.stat().st_size==record['bytes']and path.read_bytes()==blob(raw_commit,path),'Committed raw byte mismatch '+name)
    freeze=verify(SOURCE);proof=audit(RAW,SOURCE,freeze);need(proof['case_count']==36 and proof['row_count']==108,'Incomplete raw workload')
    meta=json.loads((RAW/'metadata.json').read_text());need(meta['measurement_sessions']==1,'Different session provenance requires separate explicit analysis version')
    return rows((RAW/'results.csv').read_text()),quality(rows((RAW/'results.csv').read_text())),proof

def number(row,key):return float(row[key])
def key(row):return (row['filter'],int(row['keys']),int(row['filter_bytes']))
def owner_map(selection):return {(x['filter'],int(n),x['actual_bytes']):x['owner']for n,panel in selection['selected_size_panels'].items()for x in panel}
def status(ratio):return 'win'if ratio>1 else 'loss'if ratio<1 else 'tie'
def admitted(row,cap):return int(row['filter_bytes'])*8<=int(row['keys'])*cap

def analyze(all_rows,quality_records):
    protocol,selection,measured,source=configuration();owners=owner_map(selection);metrics=protocol['metrics']['query']+protocol['metrics']['build']
    quality_by={(x['filter'],x['keys'],x['filter_bytes'],x['seed']):x for x in quality_records['api_geometry_seed_records']}
    all_gates={(x['filter'],x['keys'],x['filter_bytes']):x for x in quality_records['all_three_seed_gates']}
    grouped={}
    for row in all_rows:
        group=(int(row['keys']),int(row['batch']),int(row['seed']));grouped.setdefault(group,[]).append(row)
        need(key(row)in owners and key(row)in all_gates,'Unknown selected allocation')
    pairs=[];views=[];alternatives=[];api=[]
    for (n,batch,seed),group in sorted(grouped.items()):
        candidates=[r for r in group if r['filter']==CANDIDATE];need(len(candidates)==1,'Missing/duplicate candidate');candidate=candidates[0];need(int(candidate['filter_bytes'])*8==24*n,'Candidate actual24 changed')
        cg=all_gates[key(candidate)]['all_three_seeds_pass'];cq=quality_by[(*key(candidate),seed)]['current_eligible']
        primary=next(c for c in selection['cases']if c['key_power']==n.bit_length()-1 and c['batch']==batch and c['seed']==seed and c['budget_bpk']==24)
        candidate_order=primary['expected_filter_order'].index(CANDIDATE)
        for row in group:
            if row['filter']==CANDIDATE:continue
            for metric in metrics:
                rival_ns=number(row,metric);candidate_ns=number(candidate,metric);ratio=rival_ns/candidate_ns
                rg=all_gates[key(row)]['all_three_seeds_pass'];rq=quality_by[(*key(row),seed)]['current_eligible']
                metric_prefix=metric.removesuffix('_ns');trials=metric_prefix+'_trials'
                pairs.append(dict(keys=n,batch=batch,seed=seed,metric=metric,metric_kind='query'if metric in protocol['metrics']['query']else'build',candidate=CANDIDATE,candidate_bytes=int(candidate['filter_bytes']),rival=row['filter'],rival_bytes=int(row['filter_bytes']),rival_owner=owners[key(row)],same_process=int(row['requested_bpk'])==24,equal_bytes=int(row['filter_bytes'])==int(candidate['filter_bytes']),track='primary24'if int(row['requested_bpk'])==24 else'secondary32_extra',candidate_order=candidate_order,
                    candidate_ns=candidate_ns,rival_ns=rival_ns,ratio=ratio,unconditional_outcome=status(ratio),candidate_all_seeds_eligible=cg,rival_all_seeds_eligible=rg,main_comparable=cg and rg,candidate_current_eligible=cq,rival_current_eligible=rq,current_comparable=cq and rq,
                    candidate_trials=candidate.get(trials,''),rival_trials=row.get(trials,''),candidate_min=candidate.get(metric_prefix+'_min_ns',''),candidate_max=candidate.get(metric_prefix+'_max_ns',''),rival_min=row.get(metric_prefix+'_min_ns',''),rival_max=row.get(metric_prefix+'_max_ns','')))
        for cap in [24,32]:
            within=[r for r in group if admitted(r,cap)]
            for metric in metrics:
                base=dict(keys=n,batch=batch,seed=seed,cap_bpk=cap,fpr_ceiling=.0001,metric=metric,metric_kind='query'if metric in protocol['metrics']['query']else'build',candidate_order=candidate_order,candidate_bytes=int(candidate['filter_bytes']),candidate_ns=number(candidate,metric),candidate_all_seeds_eligible=cg,candidate_current_eligible=cq,
                    scope='within primary process'if cap==24 else'candidate24 and extra32 allocations cross processes; smaller24 also admitted')
                v=dict(base,leaders={})
                for policy in ['main_all_three','current_seed','unconditional']:
                    eligible=[r for r in within if policy=='unconditional'or(all_gates[key(r)]['all_three_seeds_pass']if policy=='main_all_three'else quality_by[(*key(r),seed)]['current_eligible'])]
                    leader={}
                    for kind in [*OWNERS,'retained_project','all']:
                        subset=[r for r in eligible if kind=='all'or (owners[key(r)]in ('production_snapshot','optional_range_snapshot')if kind=='retained_project'else owners[key(r)]==kind)]
                        if subset:
                            best=min(number(r,metric)for r in subset);ties=[dict(filter=r['filter'],filter_bytes=int(r['filter_bytes']),owner=owners[key(r)],ns=best)for r in subset if number(r,metric)==best]
                            candidate_ok=policy=='unconditional'or(cg if policy=='main_all_three'else cq)
                            leader[kind]=dict(ns=best,ties=ties,ratio_to_candidate=best/number(candidate,metric),comparable=candidate_ok,outcome=status(best/number(candidate,metric))if candidate_ok else'candidate_ineligible')
                        else:leader[kind]=None
                    v['leaders'][policy]=leader
                views.append(v)
                for row in group:
                    g=all_gates[key(row)]['all_three_seeds_pass'];q=quality_by[(*key(row),seed)]['current_eligible'];inside=admitted(row,cap)
                    alternatives.append(dict(**base,filter=row['filter'],filter_bytes=int(row['filter_bytes']),owner=owners[key(row)],ns=number(row,metric),within_cap=inside,all_three_seeds_pass=g,current_seed_pass=q,main_eligible=inside and g,current_eligible=inside and q))
        for row in group:
            for numerator,denominator in [('lookup_ns','inline_lookup_ns'),('hash_lookup_ns','inline_hash_lookup_ns')]:
                api.append(dict(filter=row['filter'],keys=n,filter_bytes=int(row['filter_bytes']),batch=batch,seed=seed,numerator=numerator,denominator=denominator,ratio=number(row,numerator)/number(row,denominator),scope='same row two distinct query API contracts'))
    need(len(pairs)==720 and len(views)==288 and len(api)==216,'Fixed output cardinality drift')
    conditions=[];groups={}
    for row in pairs:groups.setdefault((row['keys'],row['batch'],row['metric'],row['rival'],row['rival_bytes']),[]).append(row)
    for identity,items in sorted(groups.items()):
        need(len(items)==3 and {x['seed']for x in items}==set(protocol['seeds']),'Missing condition seed');ratios=[x['ratio']for x in items]
        conditions.append(dict(keys=identity[0],batch=identity[1],metric=identity[2],rival=identity[3],rival_bytes=identity[4],ratio_min=min(ratios),ratio_max=max(ratios),wins=sum(x>1 for x in ratios),losses=sum(x<1 for x in ratios),ties=sum(x==1 for x in ratios),main_comparable=all(x['main_comparable']for x in items),seeds=[x['seed']for x in items],ratios=ratios,order_positions=[x['candidate_order']for x in items]))
    need(len(conditions)==240,'Wrong three-seed conditions')
    strata=[]
    for order in range(3):
        for track in ['primary24','secondary32_extra']:
            for metric in metrics:
                subset=[x for x in pairs if x['candidate_order']==order and x['track']==track and x['metric']==metric]
                strata.append(dict(candidate_primary_position=order,track=track,metric=metric,pairs=len(subset),wins=sum(x['ratio']>1 for x in subset),losses=sum(x['ratio']<1 for x in subset),ties=sum(x['ratio']==1 for x in subset),main_comparable=sum(x['main_comparable']for x in subset),ratio_min=min(x['ratio']for x in subset),ratio_max=max(x['ratio']for x in subset),scope='primary job position; secondary extra allocation is separate process'))
    return dict(pairs=pairs,conditions=conditions,views=views,alternatives=alternatives,api_ratios=api,order_strata=strata,quality=quality_records)

def write_csv(path,data):
    with path.open('w',newline='')as f:
        w=csv.DictWriter(f,fieldnames=list(data[0]),lineterminator='\n');w.writeheader()
        for row in data:w.writerow({k:json.dumps(v,separators=(',',':'))if isinstance(v,(list,dict))else v for k,v in row.items()})
def main():
    p=argparse.ArgumentParser();p.add_argument('--raw-commit',required=True);args=p.parse_args();all_rows,q,a=load(args.raw_commit);result=analyze(all_rows,q);out=HERE/'report';need(not out.exists(),'Preserve old analysis output');out.mkdir()
    for name in ['pairs','conditions','alternatives','api_ratios','order_strata']:write_csv(out/(name+'.csv'),result[name])
    for name in ['views','quality']:(out/(name+'.json')).write_text(json.dumps(result[name],indent=2,allow_nan=False)+'\n')
    counts={k:len(v)for k,v in result.items()if isinstance(v,list)}
    (out/'metadata.json').write_text(json.dumps(dict(source_commit=SOURCE,raw_commit=args.raw_commit,raw_audit=a,counts=counts,scope='Fixed three fresh seeds; all contracts/losses; no global/all-K fresh claim'),indent=2)+'\n')
    print(json.dumps(counts))
if __name__=='__main__':main()
