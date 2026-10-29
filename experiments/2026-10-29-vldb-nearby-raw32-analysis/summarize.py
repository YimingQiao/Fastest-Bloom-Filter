#!/usr/bin/env python3
"""Analyze only committed complete fixed160 raw evidence under prespecified rules."""
import argparse,csv,hashlib,io,json,math,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
SCREEN=ROOT/'experiments/2026-10-29-vldb-nearby-raw32/screening'
sys.path.insert(0,str(SCREEN))
from screen_guard import verify,audit,sha
from screen_contract import need,MODES,NATIVE,geometry_key,parity
PRODUCER='46e300098ba043f0a402522dd161a99190eb4a68'
GROUPS=('external_original_pimpl','external_nearby_pimpl','production_native','optional_native_range','project_experiment','all_external_pimpl','all_project_controls','overall')
CAPS=(12,24);TARGETS=(.01,.001,.0001)

def exact(commit,path):
    need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Immutable full raw commit required')
    need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),'Committed artifact changed '+str(path))

def load(raw_commit):
    path=SCREEN/'RAW_ARCHIVE.json';exact(raw_commit,path);archive=json.loads(path.read_text())
    need(archive['producer_commit']==PRODUCER and archive['rows']==160 and archive['observed_exit_code']==0,'Wrong/incomplete raw archive')
    expected={'screen-run.log'}|{str(p.relative_to(SCREEN))for p in (SCREEN/'results-v1').iterdir()if p.is_file()}
    need(set(archive['files'])==expected and len(expected)==322,'Wrong raw artifact inventory')
    for name,digest in archive['files'].items():
        p=SCREEN/name;need(p.resolve().is_relative_to(SCREEN)and sha(p)==digest,'Raw SHA drift');exact(raw_commit,p)
    binary,_=verify(PRODUCER);output=SCREEN/'results-v1';meta=json.loads((output/'metadata.json').read_text())
    rows=audit(output,meta,binary,PRODUCER)
    return rows,dict(raw_commit=raw_commit,raw_archive_sha256=sha(path),producer_commit=PRODUCER,
                     binary_sha256=meta['binary_sha256'],analysis_rules_sha256=sha(SCREEN/'ANALYSIS_RULES.json'),
                     phase_order=rows[0]['query_phase_order'],old_latency_import=False)

def owner(row):
    if row['implementation_origin']=='external':
        return 'external_nearby_pimpl'if row['filter'].endswith('/nearby_odd')else'external_original_pimpl'
    need(row['implementation_origin']in GROUPS,'Unknown ownership');return row['implementation_origin']

def wilson(fp,n):
    need(type(fp)is int and type(n)is int and 0<=fp<=n and n>0,'Invalid binomial record')
    z=1.959963984540054;z2=z*z;p=fp/n;d=1+z2/n;c=(p+z2/(2*n))/d
    half=z*math.sqrt(p*(1-p)/n+z2/(4*n*n))/d
    return max(0.,c-half),min(1.,c+half)

def identity(row):return row['filter'],row['keys'],row['requested_bpk']
def mapping(row):return geometry_key(row['filter']),row['keys'],row['requested_bpk']

def qualities(rows):
    parity(rows,True);apis={};mappings={}
    for row in rows:
        key=identity(row)
        if key in apis:continue
        n=int(row['calibration_absent_queries']);fp=int(row['calibration_false_positives']);lo,hi=wilson(fp,n)
        record=dict(filter=row['filter'],keys=int(row['keys']),requested_bpk=int(row['requested_bpk']),
                    filter_bytes=int(row['filter_bytes']),actual_bpk=int(row['filter_bytes'])*8/int(row['keys']),
                    logical_bytes=int(row['logical_bytes']),owner=owner(row),negatives=n,false_positives=fp,
                    point_fpr=fp/n,wilson95_low=lo,wilson95_high=hi,pooled=False,
                    mixed_false_positives=int(row['false_positives']),complete_output_checksum=row['result_checksum'],
                    mapping=geometry_key(row['filter']))
        apis[key]=record;mkey=mapping(row)
        if mkey not in mappings:
            mappings[mkey]={**record,'filter':geometry_key(row['filter']),'api_aliases':[]}
        mappings[mkey]['api_aliases'].append(row['filter'])
    need(len(apis)==80 and len(mappings)==48,'Quality count drift')
    return apis,list(mappings.values())

def belongs(row,group):
    own=owner(row)
    if group=='overall':return True
    if group=='all_external_pimpl':return own.startswith('external_')
    if group=='all_project_controls':return not own.startswith('external_')
    return own==group

def selected(rows,mode):
    if not rows:return None
    fastest=min(float(r[mode+'_ns'])for r in rows)
    tied=[r for r in rows if float(r[mode+'_ns'])==fastest]
    return dict(latency_ns=fastest,leaders=[dict(filter=r['filter'],requested_bpk=int(r['requested_bpk']),
         actual_bpk=int(r['filter_bytes'])*8/int(r['keys']),filter_bytes=int(r['filter_bytes']),owner=owner(r))for r in tied])

def rankings(rows,apis):
    views=[];alternatives=[]
    for round_index in (0,1):
        for n in (1<<16,1<<25):
            for cap in CAPS:
                candidates=[r for r in rows if r['round']==round_index and int(r['keys'])==n and int(r['filter_bytes'])<=n*cap//8]
                for target in TARGETS:
                    eligible=[r for r in candidates if apis[identity(r)]['wilson95_high']<=target]
                    for mode in MODES:
                        context=dict(round=round_index,keys=n,cap_bpk=cap,fpr_cap=target,mode=mode)
                        leaders={group:selected([r for r in eligible if belongs(r,group)],mode)for group in GROUPS}
                        ext=leaders['all_external_pimpl'];project=leaders['all_project_controls']
                        ratio=project['latency_ns']/ext['latency_ns']if ext and project else None
                        views.append({**context,'leaders':leaders,'project_over_external_latency':ratio,
                                      'outcome':'no_comparable'if ratio is None else'win'if ratio<1 else'loss'if ratio>1 else'tie'})
                        for row in candidates:
                            q=apis[identity(row)];time=float(row[mode+'_ns']);ok=q['wilson95_high']<=target
                            alternatives.append({**context,'filter':row['filter'],'requested_bpk':int(row['requested_bpk']),
                                'actual_bytes':int(row['filter_bytes']),'owner':owner(row),'eligible':ok,
                                'wilson95_high':q['wilson95_high'],'latency_ns':time,
                                'candidate_over_best_external_latency':time/ext['latency_ns']if ext else None,
                                'candidate_over_best_project_latency':time/project['latency_ns']if project else None,
                                'candidate_over_overall_latency':time/leaders['overall']['latency_ns']if leaders['overall']else None})
    need(len(views)==72 and len(alternatives)==2160,'Nested view/alternative count drift')
    return views,alternatives

def pairs(rows,apis):
    lookup={(r['round'],r['filter'],r['keys'],r['requested_bpk']):r for r in rows};out=[];conditions={}
    for row in rows:
        if not row['filter'].endswith('/nearby_odd'):continue
        original=row['filter'].rsplit('/',1)[0]+'/original'
        old=lookup[(row['round'],original,row['keys'],row['requested_bpk'])]
        for mode in MODES:
            oldq,newq=apis[identity(old)],apis[identity(row)];ratio=float(row[mode+'_ns'])/float(old[mode+'_ns'])
            record=dict(round=row['round'],config=row['filter'].rsplit('/',1)[0],keys=int(row['keys']),cap_bpk=int(row['requested_bpk']),mode=mode,
                        original_bytes=int(old['filter_bytes']),nearby_bytes=int(row['filter_bytes']),
                        original_latency_ns=float(old[mode+'_ns']),nearby_latency_ns=float(row[mode+'_ns']),
                        nearby_over_original_latency=ratio,outcome='win'if ratio<1 else'loss'if ratio>1 else'tie',
                        original_wilson95_high=oldq['wilson95_high'],nearby_wilson95_high=newq['wilson95_high'],
                        original_fp=oldq['false_positives'],nearby_fp=newq['false_positives'],negatives=newq['negatives'],
                        original_logical_bytes=int(old['logical_bytes']),nearby_logical_bytes=int(row['logical_bytes']),
                        quality_eligible_pairs={str(t):oldq['wilson95_high']<=t and newq['wilson95_high']<=t for t in TARGETS})
            out.append(record);key=(record['config'],record['keys'],record['cap_bpk'],mode);conditions.setdefault(key,[]).append(record)
    combined=[]
    for key,records in conditions.items():
        records.sort(key=lambda r:r['round']);need([r['round']for r in records]==[0,1],'Missing paired round')
        ratios=[r['nearby_over_original_latency']for r in records]
        combined.append(dict(config=key[0],keys=key[1],cap_bpk=key[2],mode=key[3],round0_latency_ratio=ratios[0],round1_latency_ratio=ratios[1],
                             worst_latency_ratio=max(ratios),best_latency_ratio=min(ratios),
                             outcome='both_win'if all(x<1 for x in ratios)else'both_loss'if all(x>1 for x in ratios)else'both_tie'if all(x==1 for x in ratios)else'mixed'))
    need(len(out)==168 and len(combined)==84,'Named pair coverage drift');return out,combined

def count(records,key):
    return {str(x):sum(r[key]==x for r in records)for x in sorted({r[key]for r in records})}

def calculate(rows):
    apis,mappings=qualities(rows);views,alts=rankings(rows,apis);paired,combined=pairs(rows,apis)
    return dict(quality_api=list(apis.values()),quality_mapping=mappings,views=views,alternatives=alts,
                paired=paired,paired_rounds=combined,view_outcomes=count(views,'outcome'),pair_outcomes=count(paired,'outcome'),
                two_round_pair_outcomes=count(combined,'outcome'),query_rows=rows)

def csv_write(path,rows):
    need(bool(rows),'Empty output table');out=io.StringIO(newline='');writer=csv.DictWriter(out,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader()
    for row in rows:writer.writerow({k:json.dumps(v,sort_keys=True)if isinstance(v,(dict,list))else v for k,v in row.items()})
    path.write_text(out.getvalue())

def report(result,provenance):
    lines=['# Fixed160 nearby public-capacity raw32 results','',
      f'Complete committed raw `{provenance["raw_commit"]}` supplies160 process rows/480 query-mode records. Both launch rounds and all six trials remain in the tables. This is seen-seed42 training/bridge evidence from one GCC12.2/Boost1.83 executable with a fresh process per row. No old latency is imported or context correction applied.','',
      'Quality retains80 API-geometry records and48 proven mapping records. Duplicate U aliases and launch rounds share a denominator only after exact allocation/output/calibration agreement; negatives are never pooled. Formal records retain complete-output checksums. The earlier bounded caller proof separately compares complete bitmap/output bytes.','',
      f'All168 unconditional nearby/original latency pairs: `{result["pair_outcomes"]}`. Across84 identical conditions spanning both rounds: `{result["two_round_pair_outcomes"]}`. Ratios below1 favor nearby. These comparisons remain visible when either geometry fails a quality threshold.','',
      f'All72 nested-cap views: project-control versus eligible PImpl outcomes `{result["view_outcomes"]}`. No-comparable views are excluded from win denominators. Every one of2160 alternatives, including every quality failure and smaller allocation under a cap, is retained.','',
      '| Round | n | Cap bpk | FPR cap | Mode | Best project | Best PImpl | Project/PImpl latency |',
      '|---:|---:|---:|---:|---|---|---|---:|']
    for view in result['views']:
        def label(group):
            x=view['leaders'][group]
            return 'no eligible config'if x is None else ', '.join(f'{r["filter"]}@{r["actual_bpk"]:.6g}bpk'for r in x['leaders'])+f' ({x["latency_ns"]:.6f} ns)'
        ratio=view['project_over_external_latency']
        lines.append(f'| {view["round"]} | {view["keys"]} | {view["cap_bpk"]} | {view["fpr_cap"]:.4%} | {view["mode"]} | {label("all_project_controls")} | {label("all_external_pimpl")} | {"n/a"if ratio is None else f"{ratio:.6f}"} |')
    lines += ['', 'The five ownership classes and every tied leader appear separately in summary.json. Composite project leaders can be production, optional Range or experimental K12; a project win is not automatically a production-native win. See quality-api.csv for exact FP counts/Wilson endpoints and paired.csv for both allocations, both timings and all eligibility flags.', '',
      'This bounded panel covers original PImpl U shapes and the fixed project controls. It does not establish leadership over modern external libraries or private/static template surfaces. A changed divisor also changes occupancy, so no oddness-only causal decomposition follows. One seen seed, separate process launches and two rounds do not establish independent-run statistical significance or generalize to other keys, construction speed or multithreading. No adaptive geometry replacement or extra calibration was performed.']
    return '\n'.join(lines)+'\n'

def main():
    p=argparse.ArgumentParser();p.add_argument('--raw-commit',required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    need(not a.output.exists(),'Preserve existing analysis');rows,provenance=load(a.raw_commit);result=calculate(rows)
    a.output.mkdir(parents=True);(a.output/'summary.json').write_text(json.dumps(dict(provenance=provenance,**result),indent=2)+'\n')
    for name,key in [('quality-api','quality_api'),('quality-mapping','quality_mapping'),('alternatives','alternatives'),('paired','paired'),('paired-rounds','paired_rounds'),('all-query-rows','query_rows')]:csv_write(a.output/(name+'.csv'),result[key])
    (a.output/'RESULTS.md').write_text(report(result,provenance));print(json.dumps(dict(views=len(result['views']),alternatives=len(result['alternatives']),pairs=len(result['paired']))))
if __name__=='__main__':main()
