#!/usr/bin/env python3
"""Separate completed78 analysis; never opens an unfinished/uncommitted raw archive."""
import argparse
import csv
import json
import math
from pathlib import Path
import re
import subprocess
import sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
STAGE=ROOT/'experiments/2026-10-29-four-sector-range12-strict24-confirmation'
SCREEN=STAGE/'screening'
sys.path.insert(0,str(SCREEN))
from runtime import need,sha,save,blob,audit,protocol,plan,CANDIDATE
from pins import verify
SOURCE='e278444c70ac3f9e513dea0395490ad34a39c214'
OWNERS=['production_native','optional_native_range','K12_experiment','external']
POLICIES=['all_three_seeds','current_seed','unconditional_speed']

def load(raw_commit):
    need(re.fullmatch('[0-9a-f]{40}',raw_commit)is not None,'Full40 immutable raw commit required')
    archive=SCREEN/'RAW_ARCHIVE.json';need(archive.read_bytes()==blob(archive,raw_commit),'Changed committed raw descriptor');a=json.loads(archive.read_text())
    need(a['complete']is True and a['source_commit']==SOURCE and len(a['files'])==51,'Wrong completed51-file fixed78 archive')
    for name,item in a['files'].items():
        p=SCREEN/name;need(sha(p)==item['sha256']and p.stat().st_size==item['bytes']and p.read_bytes()==blob(p,raw_commit),'Changed raw archive '+name)
    verify(SOURCE);output=SCREEN/'results-v1';meta=json.loads((output/'metadata.json').read_text());rows,counts=audit(output,meta,SOURCE);need(counts==a['counts'],'Raw count drift')
    rules=SCREEN/'ANALYSIS_RULES.md';need(rules.read_bytes()==blob(rules,SOURCE),'Changed predata interpretation')
    return rows,json.loads((output/'quality.json').read_text()),meta

def owner(name):
    if name==CANDIDATE:return'K12_experiment'
    if name=='Split64RangeNative':return'optional_native_range'
    if name in('FastPatternBF','FourSectorBloomFilter'):return'production_native'
    return'external'
def state(a,b):return'win'if a<b else'loss'if a>b else'tie'
def finite(value):
    v=float(value);return v if math.isfinite(v)and v>0 else None

def calculate(rows,q):
    p=protocol();need(len(rows)==78 and len(q['api_seed_records'])==39 and len(q['mapping_seed_records'])==33 and len(q['all_seed_gates'])==13,'Incomplete78 quality evidence')
    perseed={(r['filter'],r['keys'],r['requested_bpk'],r['seed']):r for r in q['api_seed_records']}
    allseed={(r['filter'],r['keys'],r['requested_bpk']):r for r in q['all_seed_gates']}
    alternatives=[];views=[];pairs=[]
    for track,cap,sizes in [('primary24',24,[1<<16,1<<25]),('secondary_large_cap32',32,[1<<25])]:
        for n in sizes:
            for batch in p['batches']:
                for seed in p['seeds']:
                    group=[r for r in rows if int(r['keys'])==n and int(r['batch'])==batch and int(r['seed'])==seed and int(r['requested_bpk'])<=cap]
                    need(len(group)==(5 if cap==24 else 8),'Wrong finite rival union')
                    for metric in p['query_contracts']:
                        base=[]
                        for row in group:
                            name=row['filter'];budget=int(row['requested_bpk']);quality=perseed[(name,n,budget,seed)];gate=allseed[(name,n,budget)];latency=finite(row[metric]);prefix=metric.removesuffix('_ns')
                            item=dict(track=track,keys=n,batch=batch,seed=seed,K12_primary_position=['first','middle','last'][p['seeds'].index(seed)],cap_bpk=cap,metric=metric,filter=name,owner=owner(name),requested_bpk=budget,filter_bytes=int(row['filter_bytes']),actual_bpk=float(row['actual_bpk']),latency_ns=latency,trials_ns=json.loads(row[prefix+'_trials_ns']),minimum_ns=float(row[prefix+'_min_ns']),maximum_ns=float(row[prefix+'_max_ns']),byte_eligible=int(row['filter_bytes'])*8<=cap*n,contract_valid=latency is not None and not(metric=='lookup_ns'and row['input_mode']=='raw_bytes'),current_seed_pass=quality['passes_strict_0_01pct'],all_three_seeds_pass=gate['all_three_seeds_pass'],wilson95_high=quality['wilson95_high'],worst_three_seed_high=gate['worst_wilson95_high'],negative_count=quality['negatives'],false_positives=quality['false_positives'])
                            base.append(item)
                        candidate=next(x for x in base if x['filter']==CANDIDATE)
                        for rival in base:
                            if rival['filter']==CANDIDATE:continue
                            pairs.append(dict(track=track,keys=n,batch=batch,seed=seed,cap_bpk=cap,metric=metric,K12_primary_position=candidate['K12_primary_position'],rival=rival['filter'],rival_owner=rival['owner'],candidate_bytes=candidate['filter_bytes'],rival_bytes=rival['filter_bytes'],candidate_ns=candidate['latency_ns'],rival_ns=rival['latency_ns'],rival_over_K12=rival['latency_ns']/candidate['latency_ns'],outcome=state(candidate['latency_ns'],rival['latency_ns']),both_allseed_eligible=candidate['all_three_seeds_pass']and rival['all_three_seeds_pass']and candidate['byte_eligible']and rival['byte_eligible'],both_currentseed_eligible=candidate['current_seed_pass']and rival['current_seed_pass']and candidate['byte_eligible']and rival['byte_eligible'],candidate_trials=candidate['trials_ns'],rival_trials=rival['trials_ns']))
                        for policy in POLICIES:
                            current=[]
                            for original in base:
                                quality_pass=True if policy=='unconditional_speed'else original['all_three_seeds_pass']if policy=='all_three_seeds'else original['current_seed_pass']
                                item=dict(original,quality_policy=policy,eligible=quality_pass and original['byte_eligible']and original['contract_valid']);current.append(item);alternatives.append(item)
                            winners={}
                            for label in OWNERS:
                                good=[x for x in current if x['owner']==label and x['eligible']];best=min((x['latency_ns']for x in good),default=None);winners[label]=[x for x in good if x['latency_ns']==best]
                            retained=[x for x in current if x['owner']in('production_native','optional_native_range')and x['eligible']];best=min((x['latency_ns']for x in retained),default=None);retained=[x for x in retained if x['latency_ns']==best]
                            candidate=winners['K12_experiment']
                            def compare(rivals):
                                if not candidate:return dict(outcome='candidate_ineligible',ratio=None)
                                if not rivals:return dict(outcome='no_comparable',ratio=None)
                                return dict(outcome=state(candidate[0]['latency_ns'],rivals[0]['latency_ns']),ratio=rivals[0]['latency_ns']/candidate[0]['latency_ns'])
                            views.append(dict(track=track,keys=n,batch=batch,seed=seed,K12_primary_position=['first','middle','last'][p['seeds'].index(seed)],cap_bpk=cap,metric=metric,quality_policy=policy,winners=winners,best_retained=retained,K12_vs_external=compare(winners['external']),K12_vs_retained=compare(retained)))
    need((len(views),len(alternatives),len(pairs))==(108,648,180),'Unexpected fixed108views/648alternatives/180namedpairs')
    summaries=[]
    keys=sorted({(x['track'],x['keys'],x['batch'],x['metric'],x['rival'])for x in pairs})
    for key in keys:
        group=[x for x in pairs if(x['track'],x['keys'],x['batch'],x['metric'],x['rival'])==key];need(sorted(x['seed']for x in group)==sorted(p['seeds']),'Missing paired seed')
        summaries.append(dict(track=key[0],keys=key[1],batch=key[2],metric=key[3],rival=key[4],wins=sum(x['outcome']=='win'for x in group),losses=sum(x['outcome']=='loss'for x in group),ties=sum(x['outcome']=='tie'for x in group),ratio_min=min(x['rival_over_K12']for x in group),ratio_max=max(x['rival_over_K12']for x in group),allseed_pair_eligible=all(x['both_allseed_eligible']for x in group),per_seed=group))
    need(len(summaries)==60,'Unexpected60 fixed named pair conditions')
    return views,alternatives,pairs,summaries

def csvwrite(path,rows):
    with path.open('w',newline='')as file:
        writer=csv.DictWriter(file,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows({k:json.dumps(v,separators=(',',':'))if isinstance(v,(dict,list))else v for k,v in row.items()}for row in rows)

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--raw-commit',required=True);args=parser.parse_args();rows,q,meta=load(args.raw_commit);views,alternatives,pairs,summary=calculate(rows,q)
    out=HERE/'report';out.mkdir(exist_ok=True);save(out/'views.json',views);csvwrite(out/'all-alternatives.csv',alternatives);csvwrite(out/'named-pairs.csv',pairs);save(out/'paired-conditions.json',summary);save(out/'quality.json',q)
    totals={}
    for track in('primary24','secondary_large_cap32'):
        totals[track]={}
        for policy in POLICIES:
            group=[x for x in views if x['track']==track and x['quality_policy']==policy];totals[track][policy]={k:{state:sum(x[k]['outcome']==state for x in group)for state in('win','loss','tie','candidate_ineligible','no_comparable')}for k in('K12_vs_external','K12_vs_retained')}
    save(out/'metadata.json',dict(source_commit=SOURCE,raw_commit=args.raw_commit,raw_archive_sha256=sha(SCREEN/'RAW_ARCHIVE.json'),rules_sha256=sha(SCREEN/'ANALYSIS_RULES.md'),views=108,alternatives=648,named_pairs=180,paired_conditions=60,api_seed_records=39,mapping_seed_records=33,all_seed_gates=13,summary=totals,new_filter_runs=0,scope='Fixed fresh-three-seed confirmation of training-selected finite union; secondary geometry timing processes differ'))
    print(json.dumps(totals))
if __name__=='__main__':main()
