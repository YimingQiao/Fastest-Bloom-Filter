#!/usr/bin/env python3
"""Complete internal three-way source-defined ratios; no external ranking."""
import argparse,csv,hashlib,io,json,math,re,subprocess,sys
from collections import defaultdict
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1];STAGE=ROOT/'experiments/2026-10-29-rust-k12-singleton-inline';SCREEN=STAGE/'screening'
sys.path.append(str(SCREEN))
import pins,contract
SOURCE='d86e8d3ada25df6078f2fba6af5230e3d1e2695c'
OLD=contract.OLD;NEW=contract.NEW;RANGE=contract.RANGE
QUERY=('lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns')
BUILD=('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns')
DIRECTIONS=((OLD,NEW),(RANGE,NEW),(RANGE,OLD))
def need(ok,msg):
    if not ok:raise ValueError(msg)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write_json(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def csv_text(rows):
    f=io.StringIO(newline='');w=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');w.writeheader();w.writerows(rows);return f.getvalue()
def load(raw_commit):
    need(re.fullmatch('[0-9a-f]{40}',raw_commit)is not None,'Full immutable raw commit required');raw=STAGE/'results-v1';archive=raw/'ARCHIVE.json';a=json.loads(archive.read_text())
    for name,r in {**a['files'],'ARCHIVE.json':None}.items():
        p=raw/name;data=p.read_bytes()
        if r:need(sha(p)==r['sha256']and len(data)==r['bytes'],'Raw artifact drift')
        need(data==subprocess.check_output(['git','show',raw_commit+':'+str(p.relative_to(ROOT))],cwd=ROOT),'Uncommitted raw artifact')
    need(set(a['files'])=={p.name for p in raw.iterdir()if p.is_file()and p.name!='ARCHIVE.json'}and len(a['files'])==52,'Unexpected raw closure')
    freeze=pins.verify(SOURCE);contract.audit(raw,SOURCE,freeze)
    rows=contract.rows((raw/'results.csv').read_text());meta=json.loads((raw/'metadata.json').read_text());return rows,meta,json.loads((raw/'quality-context.json').read_text())
def outcome(ratio):return 'win'if ratio>1 else'loss'if ratio<1 else'tie'
def summarize(items):
    ratios=[x['rival_over_candidate']for x in items]
    return dict(samples=len(items),wins=sum(x>1 for x in ratios),losses=sum(x<1 for x in ratios),ties=sum(x==1 for x in ratios),ratio_min=min(ratios),ratio_max=max(ratios),ratios_by_seed={str(x['seed']):x['rival_over_candidate']for x in items})
def analyze(rows,meta,quality):
    need(len(rows)==72 and len(meta['cases'])==24,'Complete data required');pairs=[];api=[];offset=0
    for index,record in enumerate(meta['cases']):
        group=rows[offset:offset+3];offset+=3;order=[r['filter']for r in group];by_name={r['filter']:r for r in group}
        need(set(order)=={OLD,NEW,RANGE},'Wrong configurations')
        for rival,candidate in DIRECTIONS:
            a,b=by_name[rival],by_name[candidate];need(a['filter_bytes']==b['filter_bytes']and a['actual_bpk']==b['actual_bpk']=='24','Unequal payload')
            for metric in QUERY+BUILD:
                av,bv=float(a[metric]),float(b[metric]);ratio=av/bv
                item=dict(case_index=index,keys=int(b['keys']),batch=int(b['batch']),seed=int(b['seed']),metric=metric,rival=rival,candidate=candidate,actual_bytes=int(b['filter_bytes']),rival_ns=av,candidate_ns=bv,rival_over_candidate=ratio,outcome=outcome(ratio),rival_position=order.index(rival),candidate_position=order.index(candidate),rival_before_candidate=order.index(rival)<order.index(candidate),rival_trials='',candidate_trials='',rival_min_ns='',rival_max_ns='',candidate_min_ns='',candidate_max_ns='')
                if metric in QUERY:
                    prefix=metric.removesuffix('_ns')
                    for role,row in [('rival',a),('candidate',b)]:
                        item[role+'_trials']=row[prefix+'_trials'];item[role+'_min_ns']=float(row[prefix+'_min_ns']);item[role+'_max_ns']=float(row[prefix+'_max_ns'])
                pairs.append(item)
        for row in group:
            for staged,visible in [('lookup_ns','inline_lookup_ns'),('hash_lookup_ns','inline_hash_lookup_ns')]:
                api.append(dict(case_index=index,filter=row['filter'],keys=int(row['keys']),batch=int(row['batch']),seed=int(row['seed']),staged_contract=staged,visible_contract=visible,staged_ns=float(row[staged]),visible_ns=float(row[visible]),staged_over_visible=float(row[staged])/float(row[visible])))
    groups=defaultdict(list);strata=defaultdict(list)
    for item in pairs:
        key=tuple(item[k]for k in ['keys','batch','metric','rival','candidate']);groups[key].append(item);strata[key+(item['rival_before_candidate'],)].append(item)
    conditions=[];orders=[]
    for key,items in sorted(groups.items()):
        need(len(items)==3 and {x['seed']for x in items}==set(contract.SEEDS),'Missing fixed seed')
        conditions.append(dict(zip(['keys','batch','metric','rival','candidate'],key))|summarize(items))
    for key,items in sorted(strata.items()):orders.append(dict(zip(['keys','batch','metric','rival','candidate','rival_before_candidate'],key))|summarize(items))
    need(len(pairs)==576 and len(conditions)==192 and len(orders)==384 and len(api)==144,'Incomplete retained comparisons')
    need(quality['record_count']==12 and quality['new_calibration_samples']==0 and not quality['pooled'],'Wrong contextual quality')
    return dict(pairs=pairs,conditions=conditions,order_strata=orders,api_ratios=api,quality_context=quality,summary=dict(rows=72,cases=24,pairs=576,conditions=192,order_strata=384,api_ratios=144,quality_records=12,new_calibration_samples=0,seed_scope='Seen Rust108 inputs; internal codegen/regression comparison, not fresh external leadership',all_losses_retained=True,build_trials_available=False))
def main():
    p=argparse.ArgumentParser();p.add_argument('--raw-commit',required=True);a=p.parse_args();need(__debug__,'Python -O forbidden');rows,meta,q=load(a.raw_commit);result=analyze(rows,meta,q)
    output=HERE/'report';need(not output.exists()and not output.is_symlink(),'Preserve prior analysis');output.mkdir()
    for name in ['pairs','api_ratios']:(output/(name+'.csv')).write_text(csv_text(result[name]))
    for name in ['conditions','order_strata','quality_context']:write_json(output/(name+'.json'),result[name])
    write_json(output/'metadata.json',result['summary']|dict(source_commit=SOURCE,raw_commit=a.raw_commit,binary_sha256=meta['binary_sha256']))
    print(json.dumps(result['summary']))
if __name__=='__main__':main()
