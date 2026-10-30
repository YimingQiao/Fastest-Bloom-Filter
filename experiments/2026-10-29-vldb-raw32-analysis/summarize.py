#!/usr/bin/env python3
"""Analyze only a complete, committed raw32 screen; never partial timings."""
import argparse,csv,hashlib,io,itertools,json,math,re,sys,subprocess
from collections import defaultdict
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
STAGE=ROOT/'benchmarks/vldb-raw32-stage3'
COMMIT='6baeaeb88c89b9a4eed71f0a0aa1263c613289bd'
sys.path.insert(0,str(STAGE))
import contract as producer
need=producer.need
MODES=producer.MODES
CAPS=(12,16,24,32)
CEILINGS=(.01,.001,.0001)

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT)
def exact(commit,path,want=None):
    data=Path(path).read_bytes();need(blob(commit,path)==data,'Archive differs from exact committed blob: '+str(path))
    if want is not None:need(hashlib.sha256(data).hexdigest()==want,'Archive digest mismatch: '+str(path))

def load(raw_commit,archive):
    need(__debug__,'Python -O is unsupported')
    need(re.fullmatch('[0-9a-f]{40}',raw_commit) is not None,'Full raw archive commit required')
    archive=Path(archive).resolve();need(archive.is_relative_to(STAGE),'Raw archive must be under measured stage')
    exact(raw_commit,archive);manifest=json.loads(archive.read_text())
    need(manifest['producer_commit']==COMMIT,'Wrong raw producer')
    # Manifest paths are relative to the Stage3 root. It must include metadata,
    # all728 stdout/stderr pairs and the top-level execution log, with no silent
    # interpretation of a partial run or unanchored metadata reconstruction.
    required={'screen/metadata.json','screen-run.log'}|{f'screen/row{i:03d}.{suffix}' for i in range(728) for suffix in ('stdout','stderr')}
    need(required<=manifest['files'].keys(),'Incomplete raw evidence archive')
    for name,want in manifest['files'].items():
        p=(STAGE/name).resolve();need(p.is_relative_to(STAGE),'Raw archive path escape');exact(raw_commit,p,want)
    meta=json.loads((STAGE/'screen/metadata.json').read_text())
    need(meta['complete'] is True and meta['all_sources_and_binaries_unchanged'] is True and meta['source_commit']==COMMIT,'Require completed frozen728 screen')
    need(meta['tuner_file_before']==meta['tuner_file_after'],'Tuner state drift')
    lease=meta['lease'];need(lease['cpu']==2 and lease['lease']=='socket0' and lease['lock_path']=='/tmp/fastest-bf-socket0.lock' and lease['inherited_write_verified'] is True and lease['inherited_lock_descriptors'],'Wrong recorded placement')
    for directory in (STAGE,STAGE/'retry-v2',STAGE/'screen-v2'):
        p=directory/'PREPARATION.json';exact(COMMIT,p)
        for name,want in json.loads(p.read_text())['files'].items():exact(COMMIT,ROOT/name,want)
    freeze_path=STAGE/'WORKER_FREEZE.json';exact(COMMIT,freeze_path);freeze=json.loads(freeze_path.read_text())
    need(meta['worker_freeze_sha256']==sha(freeze_path),'Wrong measured worker freeze')
    for name,want in freeze['proof_artifacts'].items():exact(COMMIT,ROOT/name,want)
    protocol=producer.protocol();plans={w:producer.panel(w) for w in ('legacy','modern')}
    need(plans==json.loads((STAGE/'planned-grid.json').read_text())['panels'],'Changed selected geometry')
    expected=[]
    for round_index,workers in enumerate(protocol['screen']['worker_orders']):
        for worker in workers:
            for geometry in plans[worker]:
                s=protocol['screen'];case=dict(worker=worker,filter=geometry['filter'],power=geometry['keys'].bit_length()-1,cap=geometry['requested_bpk'],qpower=s['query_power'],hit=s['hit_percent'],seed=s['seeds'][0],calpower=s['calibration_power'],repeats=s['query_repeats'])
                expected.append((round_index,case))
    need(len(meta['commands'])==len(meta['rows'])==len(expected)==728,'Incomplete or extra cases')
    rows=[]
    for i,((round_index,case),record,saved) in enumerate(zip(expected,meta['commands'],meta['rows'],strict=True)):
        label=f'row{i:03d}';worker=case['worker'];binary=freeze['binaries']['native/'+worker]['path']
        need(record['label']==label and record['round']==round_index and record['worker']==worker and record['case']==case and record['returncode']==0,'Wrong recorded case/order/status')
        need(record['command']==[binary,*producer.arguments(case,'--measure')],'Actual recorded command differs')
        need(not (STAGE/'screen'/f'{label}.stderr').read_text(),'Unexpected measured worker diagnostic')
        row=producer.validate(producer.parse_one((STAGE/'screen'/f'{label}.stdout').read_text()),case)
        row=dict(round=round_index,**row);need(row==saved,'Metadata and raw CSV disagree');rows.append(row)
    need(producer.parity(rows)==166 and meta['quality_identities']==166,'Wrong unpooled quality identities')
    return rows,dict(producer_commit=COMMIT,raw_commit=raw_commit,raw_archive_sha256=sha(archive),worker_freeze_sha256=sha(freeze_path),lease=lease)

def wilson(fp,n):
    need(type(fp)is int and type(n)is int and n>0 and 0<=fp<=n,'Invalid sample')
    z=1.959963984540054;d=1+z*z/n;p=fp/n;c=(p+z*z/(2*n))/d;h=z*math.sqrt(p*(1-p)/n+z*z/(4*n*n))/d
    return (0.0 if fp==0 else max(0,c-h),1.0 if fp==n else min(1,c+h))

def identity(row):return producer.calibration_key(row)
def quality(rows):
    groups={}
    for r in rows:
        key=identity(r);value=tuple(r[k] for k in ('seed','calibration_absent_queries','calibration_false_positives','result_checksum','false_positives','query_checksum','inserted_checksum','calibration_checksum'))
        entry=groups.setdefault(key,dict(value=value,row=r,aliases=set()))
        need(entry['value']==value,'Alias/round quality or construction drift')
        alias=(r['worker'],int(r['round']),r['filter']);need(alias not in entry['aliases'],'Repeated row inside quality identity');entry['aliases'].add(alias)
    need(len(groups)==166,'Wrong complete quality count')
    records=[];lookup={}
    for index,(key,e) in enumerate(sorted(groups.items())):
        r=e['row'];fp,n=int(r['calibration_false_positives']),int(r['calibration_absent_queries']);low,high=wilson(fp,n)
        item=dict(quality_id=index,identity=list(key),keys=int(r['keys']),filter_bytes=int(r['filter_bytes']),actual_bpk=8*int(r['filter_bytes'])/int(r['keys']),seed=int(r['seed']),false_positives=fp,negatives=n,point_fpr=fp/n,wilson95_low=low,wilson95_high=high,aliases=[dict(worker=w,round=t,filter=f)for w,t,f in sorted(e['aliases'])],pooled=False)
        records.append(item);lookup[key]=item
    return records,lookup

def owner(row):
    native=row['filter'] in producer.NATIVES
    need(row['implementation_origin']==('production_native' if native else 'external'),'Wrong ownership')
    return 'production_native' if native else ('original_public' if row['worker']=='legacy' else 'modern_external')
def name_record(row):
    return dict(filter=row['filter'],surface=row['surface'],filter_bytes=int(row['filter_bytes']),actual_bpk=8*int(row['filter_bytes'])/int(row['keys']))
def leaders(rows,mode):
    if not rows:return [],None
    best=min(float(r[mode+'_ns'])for r in rows)
    return [name_record(r)for r in rows if float(r[mode+'_ns'])==best],best
def outcome(value):return 'win' if value>1 else 'loss' if value<1 else 'tie'

def rankings(rows,qmap):
    groups=defaultdict(list)
    for r in rows:
        need(r['worker'] in ('legacy','modern') and int(r['round']) in (0,1),'Unknown context/round')
        for mode in MODES:need(math.isfinite(float(r[mode+'_ns'])) and float(r[mode+'_ns'])>0,'Invalid latency')
        owner(r);groups[r['worker'],int(r['round']),int(r['keys'])].append(r)
    need(len(groups)==8 and all(len(v)==(96 if k[0]=='legacy' else 86)for k,v in groups.items()),'Wrong context geometry coverage')
    views=[];alternatives=[]
    for (worker,round_index,n),options in sorted(groups.items()):
        for cap,ceiling,mode in itertools.product(CAPS,CEILINGS,MODES):
            base=dict(worker=worker,round=round_index,keys=n,cap_bpk=cap,fpr_ceiling=ceiling,mode=mode)
            admitted=lambda r:int(r['filter_bytes'])*8<=n*cap and qmap[identity(r)]['wilson95_high']<=ceiling
            feasible=[r for r in options if admitted(r)]
            selected={'native':leaders([r for r in feasible if owner(r)=='production_native'],mode),
                      'external':leaders([r for r in feasible if owner(r)!='production_native'],mode),
                      'overall':leaders(feasible,mode)}
            if worker=='legacy':
                for surface in producer.SURFACES:selected[surface]=leaders([r for r in feasible if r['surface']==surface],mode)
            v=dict(base,eligible_configurations=len(feasible))
            for key,(names,ns)in selected.items():v[key+'_leaders']=names;v[key+'_ns']=ns
            prod,ext=v['native_ns'],v['external_ns'];ratio=ext/prod if prod is not None and ext is not None else None
            v['native_external_over_native_latency']=ratio;v['native_outcome']=outcome(ratio)if ratio is not None else'ineligible_or_missing';views.append(v)
            for r in options:
                q=qmap[identity(r)];ns=float(r[mode+'_ns']);budget=int(r['filter_bytes'])*8<=n*cap;valid=q['wilson95_high']<=ceiling
                a=dict(base,**name_record(r),owner=owner(r),requested_bpk=int(r['requested_bpk']),quality_id=q['quality_id'],budget_pass=budget,quality_pass=valid,eligible=budget and valid,wilson95_high=q['wilson95_high'],latency_ns=ns,
                       trials_ns=list(map(float,r[mode+'_trials_ns'].split('|'))),minimum_ns=float(r[mode+'_min_ns']),maximum_ns=float(r[mode+'_max_ns']),phase_order=r['query_phase_order'])
                for label in ('native','external','overall'):
                    rival=selected[label][1];ratio=rival/ns if rival is not None else None
                    a[label+'_over_candidate_latency']=ratio
                    a['candidate_vs_'+label]=outcome(ratio)if a['eligible'] and ratio is not None else'ineligible_or_missing'
                alternatives.append(a)
    need(len(views)==288 and len(alternatives)==26208,'Incomplete same-context/all-loss views')
    return views,alternatives

def cross_context(views):
    index={(v['worker'],v['round'],v['keys'],v['cap_bpk'],v['fpr_ceiling'],v['mode']):v for v in views};records=[]
    for v in views:
        if v['worker']!='legacy':continue
        k=(v['round'],v['keys'],v['cap_bpk'],v['fpr_ceiling'],v['mode']);m=index[('modern',)+k]
        item={key:v[key]for key in ('round','keys','cap_bpk','fpr_ceiling','mode')}
        item.update(scope='Separate executable API/context observations; no context correction',context_shift_correction=False)
        for prefix,row,group in [('original_public',v,'external'),('modern_external',m,'external'),('native_legacy_context',v,'native'),('native_modern_context',m,'native')]:
            item[prefix+'_leaders']=row[group+'_leaders'];item[prefix+'_ns']=row[group+'_ns']
        a,b=v['external_ns'],m['external_ns'];ratio=b/a if a is not None and b is not None else None
        item['modern_external_over_original_latency']=ratio;item['original_observed_outcome']=outcome(ratio)if ratio is not None else'ineligible_or_missing';records.append(item)
    need(len(records)==144,'Wrong paired context grid');return records

def native_context_controls(rows,qmap):
    groups=defaultdict(dict)
    for r in rows:
        if owner(r)!='production_native':continue
        key=(int(r['round']),r['filter'],int(r['keys']),int(r['filter_bytes']))
        need(r['worker']not in groups[key],'Repeated native context');groups[key][r['worker']]=r
    need(len(groups)==48 and all(set(v)=={'legacy','modern'}for v in groups.values()),'Missing exact paired native geometry')
    records=[]
    for (round_index,name,n,size),pair in sorted(groups.items()):
        l,m=pair['legacy'],pair['modern'];need(identity(l)==identity(m),'Native context geometry mapping differs')
        for mode in MODES:
            a,b=float(l[mode+'_ns']),float(m[mode+'_ns'])
            records.append(dict(round=round_index,filter=name,keys=n,filter_bytes=size,actual_bpk=8*size/n,mode=mode,
              legacy_ns=a,modern_ns=b,modern_over_legacy_latency=b/a,quality_id=qmap[identity(l)]['quality_id'],context_shift_correction=False))
    need(len(records)==144,'Wrong native context control count');return records

def write_csv(path,rows):
    with Path(path).open('w',newline='')as f:
        fields=list(dict.fromkeys(k for r in rows for k in r));w=csv.DictWriter(f,fieldnames=fields);w.writeheader()
        w.writerows({k:json.dumps(v,separators=(',',':'))if isinstance(v,(list,dict))else v for k,v in r.items()}for r in rows)
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--raw-commit',required=True);p.add_argument('--archive',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    need(not a.output.exists(),'Preserve previous report');rows,provenance=load(a.raw_commit,a.archive)
    q,qmap=quality(rows);views,alternatives=rankings(rows,qmap);cross=cross_context(views);controls=native_context_controls(rows,qmap)
    a.output.mkdir(parents=True,exist_ok=False)
    for filename,records in [('same-context-rankings.csv',views),('all-alternatives.csv',alternatives),('cross-context-observations.csv',cross),('native-context-controls.csv',controls)]:write_csv(a.output/filename,records)
    summary=dict(scope='Single-seed training; separate two rounds/contexts/modes; no normalization or pooled quality',provenance=provenance,quality=q,views=views,cross_context=cross,native_context_controls=controls,counts=dict(rows=len(rows),quality=len(q),views=len(views),alternatives=len(alternatives),cross_context=len(cross),native_context_controls=len(controls)))
    (a.output/'summary.json').write_text(json.dumps(summary,indent=2,allow_nan=False)+'\n')
    (a.output/'archive.json').write_text(json.dumps({'files':{f.name:sha(f)for f in sorted(a.output.iterdir())if f.is_file()}},indent=2)+'\n')
    print('Complete728 rows analyzed; both rounds, all26,208 alternatives and166 unpooled quality identities retained')

if __name__=='__main__':main()
