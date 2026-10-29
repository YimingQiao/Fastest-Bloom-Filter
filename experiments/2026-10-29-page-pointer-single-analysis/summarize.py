#!/usr/bin/env python3
"""Analyze only a committed complete240 Page caller comparison."""
import argparse,csv,hashlib,json,math,re,subprocess,sys
from collections import defaultdict
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
STAGE=ROOT/'experiments/2026-10-29-page-pointer-single'
SOURCE_COMMIT='82fe0322fb2a761ece241fc89635e126bc80a590'
sys.path.insert(0,str(STAGE/'screening'))
import screen_contract as producer
from source_guard import module
from checks import canonical_row
need=producer.need
MODES=producer.original.MODES
CAPS=(12,16,24,32)
GATES=(.01,.001,.0001)
NATIVE=producer.original.NATIVES
POINTERS=producer.ALIASES
VALUES=set(POINTERS.values())

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def exact(commit,path,want=None):
    data=Path(path).read_bytes()
    blob=subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT)
    need(blob==data,'Artifact is not the exact committed blob')
    if want is not None:need(hashlib.sha256(data).hexdigest()==want,'Archive hash differs')

def load(raw_commit):
    need(__debug__,'Python -O unsupported')
    need(re.fullmatch('[0-9a-f]{40}',raw_commit)is not None,'Exact completed raw commit required')
    manifest=STAGE/'SCREEN_ARCHIVE.json';exact(raw_commit,manifest);desc=json.loads(manifest.read_text())
    need(desc['producer_commit']==SOURCE_COMMIT,'Wrong timed source')
    expected={'screen/metadata.json','screen-run.log'}|{f'screen/row{i:03d}.{stream}'for i in range(240)for stream in ('stdout','stderr')}
    need(set(desc['files'])==expected,'Complete482 raw artifacts required')
    for name,want in desc['files'].items():exact(raw_commit,STAGE/name,want)
    audit=module('page240_completed_raw_audit',STAGE/'screening/audit.py')
    rows=audit.check(STAGE/'screen',SOURCE_COMMIT,live=False)
    need(len(rows)==240,'Wrong complete row count')
    return rows,dict(source_commit=SOURCE_COMMIT,raw_commit=raw_commit,
      raw_archive_sha256=sha(manifest),worker_freeze_sha256=sha(STAGE/'WORKER_FREEZE.json'),
      scope='Same executable, separate fresh row processes; no old-context latency imported')

def wilson(fp,n):
    need(type(fp)is int and type(n)is int and n>0 and 0<=fp<=n,'Invalid quality sample')
    z=1.959963984540054;p=fp/n;d=1+z*z/n;c=(p+z*z/(2*n))/d
    h=z*math.sqrt(p*(1-p)/n+z*z/(4*n*n))/d
    return (0.0 if fp==0 else max(0,c-h),1.0 if fp==n else min(1,c+h))

def identity(row):return producer.original.calibration_key(canonical_row(row))

def quality(rows):
    groups={}
    for r in rows:
        key=identity(r);value=tuple(r[k]for k in ('seed','queries','hit_percent','calibration_absent_queries',
          'false_positives','calibration_false_positives','result_checksum','inserted_checksum','query_checksum','calibration_checksum'))
        entry=groups.setdefault(key,dict(row=r,value=value,aliases=set()))
        need(entry['value']==value,'Caller/round quality or stream mismatch')
        alias=(int(r['round']),r['filter']);need(alias not in entry['aliases'],'Duplicate caller row')
        entry['aliases'].add(alias)
    need(len(groups)==72,'Wrong unpooled mapping count');result=[];lookup={}
    for index,(key,item)in enumerate(sorted(groups.items())):
        r=item['row'];fp,n=int(r['calibration_false_positives']),int(r['calibration_absent_queries']);lo,hi=wilson(fp,n)
        record=dict(quality_id=index,identity=list(key),keys=int(r['keys']),filter_bytes=int(r['filter_bytes']),
          actual_bpk=8*int(r['filter_bytes'])/int(r['keys']),seed=int(r['seed']),false_positives=fp,
          negatives=n,point_fpr=fp/n,wilson95_low=lo,wilson95_high=hi,pooled=False,
          aliases=[dict(round=round_index,filter=name)for round_index,name in sorted(item['aliases'])])
        result.append(record);lookup[key]=record
    return result,lookup

def owner(row):
    name=row['filter'];need(name in NATIVE or name in VALUES or name in POINTERS,'Unknown owner')
    kind='production_native'if name in NATIVE else 'page_value'if name in VALUES else 'page_pointer'
    need(row['implementation_origin']==('production_native'if kind=='production_native'else'external'),'Ownership drift')
    return kind

def outcome(ratio):return 'lower_latency'if ratio<1 else'higher_latency'if ratio>1 else'tie'
def label(r):return dict(filter=r['filter'],filter_bytes=int(r['filter_bytes']),actual_bpk=8*int(r['filter_bytes'])/int(r['keys']))
def best(rows,mode):
    if not rows:return [],None
    ns=min(float(r[mode+'_ns'])for r in rows)
    return [label(r)for r in rows if float(r[mode+'_ns'])==ns],ns

def paired(rows,qmap):
    index={}
    for r in rows:
        key=(int(r['round']),r['filter'],int(r['keys']),int(r['filter_bytes']))
        need(key not in index,'Duplicate geometry alias');index[key]=r
    reverse={value:pointer for pointer,value in POINTERS.items()};result=[]
    for r in rows:
        if r['filter']not in VALUES:continue
        p=index[(int(r['round']),reverse[r['filter']],int(r['keys']),int(r['filter_bytes']))]
        need(identity(p)==identity(r),'Pair is not the same mapping')
        q=qmap[identity(r)]
        for mode in MODES:
            old,new=float(r[mode+'_ns']),float(p[mode+'_ns']);ratio=new/old
            item=dict(round=int(r['round']),keys=int(r['keys']),filter_bytes=int(r['filter_bytes']),
              actual_bpk=8*int(r['filter_bytes'])/int(r['keys']),mode=mode,value_filter=r['filter'],pointer_filter=p['filter'],
              value_ns=old,pointer_ns=new,pointer_over_value_latency=ratio,pointer_outcome=outcome(ratio),
              quality_id=q['quality_id'],wilson95_high=q['wilson95_high'],same_mapping=True,calibration_pooled=False)
            for prefix,row in [('value',r),('pointer',p)]:
                item[prefix+'_trials_ns']=list(map(float,row[mode+'_trials_ns'].split('|')))
                item[prefix+'_minimum_ns']=float(row[mode+'_min_ns']);item[prefix+'_maximum_ns']=float(row[mode+'_max_ns'])
                item[prefix+'_phase_order']=row['query_phase_order']
            result.append(item)
    need(len(result)==288,'Incomplete same-geometry pair grid');return result

def rankings(rows,qmap):
    groups=defaultdict(list)
    for r in rows:
        need(int(r['round'])in (0,1),'Unknown round');owner(r)
        for mode in MODES:need(math.isfinite(float(r[mode+'_ns']))and float(r[mode+'_ns'])>0,'Invalid latency')
        groups[int(r['round']),int(r['keys'])].append(r)
    need(len(groups)==4 and all(len(v)==60 for v in groups.values()),'Wrong complete allocation panel')
    views=[];alternatives=[]
    for (round_index,n),options in sorted(groups.items()):
        for cap in CAPS:
            for gate in GATES:
                for mode in MODES:
                    base=dict(round=round_index,keys=n,cap_bpk=cap,fpr_ceiling=gate,mode=mode)
                    admitted=lambda r:int(r['filter_bytes'])*8<=cap*n and qmap[identity(r)]['wilson95_high']<=gate
                    feasible=[r for r in options if admitted(r)]
                    selected={kind:best([r for r in feasible if owner(r)==kind],mode)for kind in ('production_native','page_value','page_pointer')}
                    selected['any_page']=best([r for r in feasible if owner(r)!='production_native'],mode)
                    selected['overall']=best(feasible,mode)
                    view=dict(base,eligible_configurations=len(feasible))
                    for kind,(names,ns)in selected.items():view[kind+'_leaders']=names;view[kind+'_ns']=ns
                    native,page=selected['production_native'][1],selected['any_page'][1]
                    ratio=native/page if native is not None and page is not None else None
                    view['native_over_best_page_latency']=ratio
                    view['native_outcome']=outcome(ratio)if ratio is not None else'ineligible_or_missing'
                    views.append(view)
                    for r in options:
                        q=qmap[identity(r)];ns=float(r[mode+'_ns']);budget=int(r['filter_bytes'])*8<=cap*n;passes=q['wilson95_high']<=gate
                        item=dict(base,**label(r),owner=owner(r),requested_bpk=int(r['requested_bpk']),quality_id=q['quality_id'],
                          budget_pass=budget,quality_pass=passes,eligible=budget and passes,wilson95_high=q['wilson95_high'],latency_ns=ns,
                          trials_ns=list(map(float,r[mode+'_trials_ns'].split('|'))),minimum_ns=float(r[mode+'_min_ns']),maximum_ns=float(r[mode+'_max_ns']),phase_order=r['query_phase_order'])
                        for kind in ('production_native','page_value','page_pointer','any_page','overall'):
                            target=selected[kind][1];ratio=ns/target if target is not None else None
                            item['candidate_over_'+kind+'_latency']=ratio
                            item['candidate_vs_'+kind]=outcome(ratio)if item['eligible']and ratio is not None else'ineligible_or_missing'
                        alternatives.append(item)
    need(len(views)==144 and len(alternatives)==8640,'Wrong complete nested comparison count')
    return views,alternatives

def native_controls(rows,qmap):
    result=[]
    for r in rows:
        if owner(r)!='production_native':continue
        for mode in MODES:
            result.append(dict(round=int(r['round']),keys=int(r['keys']),**label(r),mode=mode,
              latency_ns=float(r[mode+'_ns']),trials_ns=list(map(float,r[mode+'_trials_ns'].split('|'))),
              minimum_ns=float(r[mode+'_min_ns']),maximum_ns=float(r[mode+'_max_ns']),
              phase_order=r['query_phase_order'],quality_id=qmap[identity(r)]['quality_id'],old_context_comparison=False))
    need(len(result)==144,'Wrong native control scope');return result

def write_csv(path,rows):
    with path.open('w',newline='')as stream:
        fields=list(dict.fromkeys(k for r in rows for k in r));writer=csv.DictWriter(stream,fieldnames=fields,lineterminator='\n');writer.writeheader()
        writer.writerows({k:json.dumps(v,separators=(',',':'))if isinstance(v,(dict,list))else v for k,v in r.items()}for r in rows)

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--raw-commit',required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    need(not a.output.exists()and not a.output.is_symlink(),'Preserve previous report')
    rows,provenance=load(a.raw_commit);q,qmap=quality(rows);pairs=paired(rows,qmap);views,alternatives=rankings(rows,qmap);controls=native_controls(rows,qmap)
    a.output.mkdir(parents=True,exist_ok=False)
    for name,data in [('paired-callers.csv',pairs),('rankings.csv',views),('all-alternatives.csv',alternatives),('native-controls.csv',controls)]:write_csv(a.output/name,data)
    summary=dict(scope='Seed42 training; two rounds kept separate; same executable but fresh row processes; no old-context correction',provenance=provenance,quality=q,paired_callers=pairs,views=views,native_controls=controls,
      counts=dict(raw_rows=len(rows),quality=len(q),pairs=len(pairs),views=len(views),alternatives=len(alternatives),native_controls=len(controls)))
    (a.output/'summary.json').write_text(json.dumps(summary,indent=2,allow_nan=False)+'\n')
    (a.output/'archive.json').write_text(json.dumps(dict(files={f.name:sha(f)for f in sorted(a.output.iterdir())if f.is_file()}),indent=2)+'\n')
    print('Complete240 analysis:288 caller pairs,144 views,8640 alternatives,144 native controls,72 unpooled quality identities')

if __name__=='__main__':main()
