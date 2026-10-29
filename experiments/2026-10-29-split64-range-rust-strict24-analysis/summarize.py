#!/usr/bin/env python3
"""Complete finite held-out24 analysis; no new BF, allocation or K selection."""
import csv
import hashlib
import json
import math
from pathlib import Path
import subprocess
import sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
STAGE=ROOT/'experiments/2026-10-29-split64-range-rust-strict24-confirmation'
SCREEN=STAGE/'screening'
sys.path.insert(0,str(SCREEN))
from contract import audit,need,commands,sha,save
from freeze import verify
SOURCE='87f662b00f853780003731c3dd35ec746d0a7e2c'
RAW='e1b06581872c18fde71a02dd0bb7eacbba0a2259'
CANDIDATE='Split64RangeBloomFilter'
EXTERNAL='Fastbloom017K7'
QUERY=['lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns']
BUILD=['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']
METRICS=QUERY+BUILD

def blob(path,commit):return subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
def load():
    descriptor=SCREEN/'RAW_ARCHIVE.json';need(descriptor.read_bytes()==blob(descriptor,RAW),'Changed committed raw descriptor')
    archive=json.loads(descriptor.read_text());need(len(archive['files'])==27 and archive['source_commit']==SOURCE and archive['complete'],'Wrong completed raw archive')
    for name,item in archive['files'].items():
        path=SCREEN/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,RAW),'Changed raw evidence '+name)
    binary,_=verify(SOURCE);out=SCREEN/'results-v1';meta=json.loads((out/'metadata.json').read_text())
    rows,counts=audit(out,meta,binary,SOURCE);need(counts==archive['counts'],'Changed archived coverage')
    return rows,json.loads((out/'quality.json').read_text()),meta

def calculate(rows,quality):
    need(len(rows)==24,'Require complete24')
    grouped={}
    for row in rows:
        key=tuple(int(row[k])for k in('keys','batch','seed'));need(row['filter']not in grouped.setdefault(key,{}),'Duplicate API/workload');grouped[key][row['filter']]=row
    need(len(grouped)==12 and all(set(g)=={CANDIDATE,EXTERNAL}for g in grouped.values()),'Incomplete fixed pair grid')
    qmap={(r['filter'],r['keys'],r['seed']):r for r in quality['api_size_seed_records']};gate={(r['filter'],r['keys']):r for r in quality['family_size_all_seed_gates']}
    need(len(qmap)==8 and len(gate)==4,'Quality identity drift')
    orders={(1<<c['case']['key_power'],c['case']['batch'],c['case']['seed']):c['expected_filter_order']for c in commands()}
    pairs=[]
    for(n,batch,seed),group in sorted(grouped.items()):
        candidate,external=group[CANDIDATE],group[EXTERNAL]
        need(candidate['filter_bytes']==external['filter_bytes']and int(candidate['filter_bytes'])*8==24*n,'Not equal exact24 payload')
        for metric in METRICS:
            c,e=float(candidate[metric]),float(external[metric]);need(math.isfinite(c)and math.isfinite(e)and c>0 and e>0,'Invalid timing')
            trial=metric[:-3]+'_trials'
            record=dict(keys=n,batch=batch,seed=seed,metric=metric,kind='query'if metric in QUERY else'build',filter_bytes=int(candidate['filter_bytes']),actual_bpk=24,candidate_ns=c,external_ns=e,external_over_candidate=e/c,outcome='win'if c<e else'loss'if c>e else'tie',candidate_row_position=orders[(n,batch,seed)].index(CANDIDATE),candidate_current_seed_pass=qmap[(CANDIDATE,n,seed)]['current_seed_pass'],external_current_seed_pass=qmap[(EXTERNAL,n,seed)]['current_seed_pass'],candidate_all_fresh_seeds_pass=gate[(CANDIDATE,n)]['all_fresh_seeds_pass'],external_all_fresh_seeds_pass=gate[(EXTERNAL,n)]['all_fresh_seeds_pass'],candidate_trials=candidate.get(trial),external_trials=external.get(trial),quality_pooling=False)
            if metric in QUERY:
                prefix=metric[:-3];record.update(candidate_min_ns=float(candidate[prefix+'_min_ns']),candidate_max_ns=float(candidate[prefix+'_max_ns']),external_min_ns=float(external[prefix+'_min_ns']),external_max_ns=float(external[prefix+'_max_ns']))
            pairs.append(record)
    conditions=[]
    for n in(65536,33554432):
        for batch in(1,31,4096):
            for metric in METRICS:
                current=[r for r in pairs if(r['keys'],r['batch'],r['metric'])==(n,batch,metric)]
                need(len(current)==2 and {r['seed']for r in current}=={32452843,49979687}and {r['candidate_row_position']for r in current}=={0,1},'Missing two-seed/order reversal')
                conditions.append(dict(keys=n,batch=batch,metric=metric,min_ratio=min(r['external_over_candidate']for r in current),max_ratio=max(r['external_over_candidate']for r in current),wins=sum(r['outcome']=='win'for r in current),losses=sum(r['outcome']=='loss'for r in current),ties=sum(r['outcome']=='tie'for r in current),candidate_all_fresh_seeds_pass=gate[(CANDIDATE,n)]['all_fresh_seeds_pass'],external_all_fresh_seeds_pass=gate[(EXTERNAL,n)]['all_fresh_seeds_pass']))
    need(len(pairs)==96 and len(conditions)==48,'Wrong finite outcome counts')
    return pairs,conditions

def write_csv(path,rows):
    with path.open('w',newline='')as stream:
        writer=csv.DictWriter(stream,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
def report(pairs,conditions,q,meta):
    query=[r for r in pairs if r['kind']=='query'];build=[r for r in pairs if r['kind']=='build']
    def counts(rows):return '/'.join(str(sum(r['outcome']==x for r in rows))for x in['win','loss','tie'])
    lines=['# Rust Range24 fixed fresh confirmation','',f'The complete 12-workload/24-row confirmation gives Range query wins/losses/ties **{counts(query)}** and build wins/losses/ties **{counts(build)}** against the prespecified public Fastbloom 0.17 K7 control at equal actual 24 bits/key. All 96 paired outcomes and 48 two-seed conditions are retained; ratio below1 means a Range loss.','',f"All four API/size gates pass both fixed fresh seeds: {all(x['all_fresh_seeds_pass']for x in q['family_size_all_seed_gates'])}. Each gate uses separate 2^24-negative Wilson 95% upper endpoints at 0.01%; no seeds, aliases, batches or modes are pooled.",'','| Keys | API | Seed | False positives / negatives | Wilson95% upper, percent | Pass |','|---:|---|---:|---:|---:|---|']
    for r in q['api_size_seed_records']:lines.append(f"| {r['keys']} | {r['filter']} | {r['seed']} | {r['false_positives']} / {r['negatives']} | {100*r['wilson95_high']:.8f}% | {r['current_seed_pass']} |")
    lines+=['','Query contracts and build boundaries remain separate. The table shows the smaller and larger external/Range ratios across the two seeds for each fixed workload; this is a descriptive range of paired medians, not a confidence interval.','', '| Keys | Batch | Metric | Min–max ratio | W/L/T |','|---:|---:|---|---:|---:|']
    for r in conditions:lines.append(f"| {r['keys']} | {r['batch']} | `{r['metric']}` | {r['min_ratio']:.4f}–{r['max_ratio']:.4f}× | {r['wins']}/{r['losses']}/{r['ties']} |")
    lines+=['','[Raw data and completed identity ledger](../2026-10-29-split64-range-rust-strict24-confirmation/screening/results-v1/metadata.json), [prespecified training leader union](../2026-10-29-split64-range-rust-strict24-confirmation/selection.json), and [complete preceding public-K training report](../2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/REPORT.md) retain the underlying scope and failures.','','The original row-order reversal is exact at both sizes and every batch: seed 32452843 puts K7 first, seed 49979687 puts Range first. `paired.csv` retains each seed/order separately. Four query phases are balanced over 8 repetitions and retain their complete trial vectors and min/max; the four build metrics retain producer medians only. Build order is not a balanced causal experiment, and allocator/address variation is not isolated.','', 'The visible scalar whole-array loops still call each public singleton API and, for fused raw queries, the common hash inside that loop. Their batch tag identifies a repeated surrounding workload, not a change in their per-key API contract. Staged prehashed and staged hash+query retain their separate bulk API boundaries.','', 'Scope: the two APIs were fixed before new filter outputs. K7 at 24 bpk is the exact union of all 48 strongest qualifying external query/build leaders selected from the preceding complete K1..12, default, SBBF and Bloomsday training table. This confirms that finite capacity niche against the training-derived shortlist; it does not show that K7 is the fastest external configuration on every fresh seed, nor global leadership. The broader training eligibility/failure table and all fixed-K support remain in the immutable proposal. No new allocation, K, seed or baseline was selected here.','', 'The payloads are 196,608 bytes for 65,536 keys and 100,663,296 bytes for 33,554,432 keys. Range has less quality margin than K7; these finite uniform-hash samples do not impose a universal true-FPR guarantee. Existing equal 16/32-bpk Range-vs-Split losses in the training archive remain relevant: an optional 24-bpk API is a distinct capacity choice, not evidence to replace the existing default everywhere.','',f"Source `{SOURCE}`, completed raw `{RAW}`, frozen native binary `{meta['executable_sha256']}`. Single completed measurement session 92333, CPU3/socket1 affinity only; no explicit NUMA memory binding. There was no rebuild or algorithm change, no partial-results selection, and no discarded failed formal run. Raw evidence was committed before this analysis.",'']
    return '\n'.join(lines)
def main():
    rows,q,meta=load();pairs,conditions=calculate(rows,q);out=HERE/'report';out.mkdir(exist_ok=True)
    write_csv(out/'paired.csv',pairs);write_csv(out/'conditions.csv',conditions);save(out/'quality.json',q)
    save(out/'order-strata.json',{str(position):[r for r in pairs if r['candidate_row_position']==position]for position in[0,1]})
    save(out/'metadata.json',dict(source_commit=SOURCE,raw_commit=RAW,raw_manifest_sha256=sha(SCREEN/'RAW_ARCHIVE.json'),raw_rows=24,workloads=12,paired_outcomes=96,condition_summaries=48,quality_records=8,all_seed_gates=4,query_metrics=QUERY,build_metrics=BUILD,algorithm_runs=0))
    (HERE/'REPORT.md').write_text(report(pairs,conditions,q,meta));print(json.dumps({'query':{x:sum(r['kind']=='query'and r['outcome']==x for r in pairs)for x in['win','loss','tie']},'build':{x:sum(r['kind']=='build'and r['outcome']==x for r in pairs)for x in['win','loss','tie']},'all_quality_pass':all(r['all_fresh_seeds_pass']for r in q['family_size_all_seed_gates'])}))
if __name__=='__main__':main()
