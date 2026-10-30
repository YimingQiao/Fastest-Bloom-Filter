#!/usr/bin/env python3
"""Fresh-seed, eight-core confirmation with pooled quality and paired timings."""
import csv
import json
import math
from pathlib import Path
import statistics
from summary_common import NATIVE,METRICS,QUALITY_FIELDS,calibrations,key,validate_trial_metadata,wilson_upper

POOL_FIELDS=tuple(f for f in QUALITY_FIELDS if f!='seed')
CASE_FIELDS=('keys','queries','threads','batch','hit_percent','repeats','insert_batch')

def calibration_interval(seed,n,q,count):
    mask=(1<<64)-1
    z=(seed+0x9e3779b97f4a7c15)&mask
    z=((z^(z>>30))*0xbf58476d1ce4e5b9)&mask
    z=((z^(z>>27))*0x94d049bb133111eb)&mask
    z^=z>>31
    base=z%((1<<32)-n-q)
    return base+n+q,base+n+q+count

def pooled_quality(rows,seeds):
    streams=calibrations(rows);groups={}
    for stream in streams.values():
        config=stream['configuration'];groups.setdefault(key(config,POOL_FIELDS),{})[config['seed']]=stream
    result={}
    for config,by_seed in groups.items():
        if set(by_seed)!=set(map(str,seeds)):raise ValueError('incomplete or unexpected calibration seed set')
        parameters=dict(zip(POOL_FIELDS,config))
        intervals={seed:calibration_interval(int(seed),int(parameters['keys']),int(parameters['queries']),stream['queries']) for seed,stream in by_seed.items()}
        ordered=sorted(intervals.values())
        if any(a[1]>b[0] for a,b in zip(ordered,ordered[1:])):
            raise ValueError('overlapping new-seed calibration intervals cannot be pooled')
        total=sum(s['queries'] for s in by_seed.values());positive=sum(s['false_positives'] for s in by_seed.values())
        result[config]={'configuration':dict(zip(POOL_FIELDS,config)),'queries':total,'false_positives':positive,
                        'wilson95_upper':wilson_upper(positive,total),'max_seed_wilson95_upper':max(s['wilson95_upper'] for s in by_seed.values()),
                        'seed_streams':[{'seed':int(seed),'raw_key_interval':intervals[seed],**{k:v for k,v in stream.items() if k!='configuration'}} for seed,stream in sorted(by_seed.items(),key=lambda x:int(x[0]))]}
    return result

def candidates(rows,seeds):
    groups={}
    for row in rows:
        case=key(row,CASE_FIELDS);config=key(row,POOL_FIELDS)
        group=groups.setdefault(case,{}).setdefault(config,{})
        if row['seed'] in group:raise ValueError('duplicate timing seed/configuration')
        group[row['seed']]=row
    for group in groups.values():
        for by_seed in group.values():
            if set(by_seed)!=set(map(str,seeds)):raise ValueError('incomplete paired timing seeds')
    return groups

def metric_time(by_seed,metric):
    values=[]
    for row in by_seed.values():
        value=float(row[metric]);raw=row['input_mode']=='raw_bytes' and metric.startswith('parallel_lookup_')
        if raw:
            if not math.isnan(value):raise ValueError('raw-only adapter has pure timing')
            continue
        if not math.isfinite(value) or value<=0:raise ValueError('invalid query timing')
        values.append(value)
    return statistics.median(values) if values else None

def describe(config,by_seed,metric,quality):
    row=next(iter(by_seed.values()))
    return {'filter':row['filter'],'requested_bpk':int(row['requested_bpk']),'filter_bytes':int(row['filter_bytes']),
            'actual_bpk':8*int(row['filter_bytes'])/int(row['keys']),
            'median_of_seed_medians_ns':metric_time(by_seed,metric),
            'seed_ns':{seed:float(r[metric]) for seed,r in sorted(by_seed.items(),key=lambda x:int(x[0]))},
            'calibration_queries':quality[config]['queries'],'calibration_fp':quality[config]['false_positives'],
            'wilson95_upper':quality[config]['wilson95_upper'],'max_seed_wilson95_upper':quality[config]['max_seed_wilson95_upper']}

def comparisons(rows,seeds,caps,targets,metrics=METRICS,native_family=None):
    quality=pooled_quality(rows,seeds);groups=candidates(rows,seeds);result=[]
    for case,group in sorted(groups.items()):
        for cap in caps:
            for target in targets:
                eligible={c:s for c,s in group.items() if 8*int(c[POOL_FIELDS.index('filter_bytes')])<=cap*int(c[POOL_FIELDS.index('keys')]) and quality[c]['wilson95_upper']<=target}
                for metric in metrics:
                    native={};external={}
                    for config,by_seed in eligible.items():
                        value=metric_time(by_seed,metric)
                        if value is None:continue
                        name=config[POOL_FIELDS.index('filter')]
                        if name in NATIVE:
                            if native_family is None or name==native_family:native[config]=by_seed
                        else:external[config]=by_seed
                    order=lambda c:(metric_time(eligible[c],metric),int(c[POOL_FIELDS.index('filter_bytes')]),c)
                    own=min(native,key=order) if native else None
                    rival=min(external,key=order) if external else None
                    row={'case':dict(zip(CASE_FIELDS,case)),'memory_cap_bpk':cap,'fpr_target':target,'metric':metric,
                         'native_family':native_family or 'portfolio','native_eligible_allocations':len(native),'external_eligible_allocations':len(external),
                         'native':describe(own,native[own],metric,quality) if own else None,
                         'external':describe(rival,external[rival],metric,quality) if rival else None}
                    if own is None or rival is None:
                        row['aggregate_median_winner']='unqualified_both' if own is None and rival is None else 'unqualified_native' if own is None else 'unqualified_external'
                        result.append(row);continue
                    row['aggregate_speedup']=row['external']['median_of_seed_medians_ns']/row['native']['median_of_seed_medians_ns']
                    row['aggregate_median_winner']='native' if row['aggregate_speedup']>1 else 'external' if row['aggregate_speedup']<1 else 'tie'
                    paired=[];conservative=[]
                    for seed in map(str,seeds):
                        nrow=native[own][seed];erow=external[rival][seed];nv=float(nrow[metric]);ev=float(erow[metric]);prefix=metric[:-3]
                        overlap=max(float(nrow[prefix+'_min_ns']),float(erow[prefix+'_min_ns']))<=min(float(nrow[prefix+'_max_ns']),float(erow[prefix+'_max_ns']))
                        paired.append({'seed':int(seed),'native_ns':nv,'external_ns':ev,'speedup':ev/nv,'trial_ranges_overlap':overlap})
                        best=min(external,key=lambda c:(float(external[c][seed][metric]),int(c[POOL_FIELDS.index('filter_bytes')]),c))
                        brow=external[best][seed]
                        conservative.append({'seed':int(seed),'native_ns':nv,'external_ns':float(brow[metric]),'speedup':float(brow[metric])/nv,
                                             'external_filter':brow['filter'],'external_requested_bpk':int(brow['requested_bpk']),'external_filter_bytes':int(brow['filter_bytes']),
                                             'external_pooled_wilson95_upper':quality[best]['wilson95_upper'],
                                             'external_seed_wilson95_upper':wilson_upper(int(brow['calibration_false_positives']),int(brow['calibration_absent_queries']))})
                    row['paired_seeds']=paired;row['conservative_seeds']=conservative
                    for label,values in (('paired',paired),('conservative',conservative)):
                        row[label+'_median_speedup']=statistics.median(v['speedup'] for v in values)
                        row[label+'_speedup_min']=min(v['speedup'] for v in values);row[label+'_speedup_max']=max(v['speedup'] for v in values)
                    row['native_all_seed_quality_uppers_pass']=row['native']['max_seed_wilson95_upper']<=target
                    row['external_all_seed_quality_uppers_pass']=row['external']['max_seed_wilson95_upper']<=target
                    result.append(row)
    return result

def serial_ratios(rows,seeds,metrics=METRICS):
    output=[]
    for case,group in candidates([r for r in rows if r['filter'] in NATIVE],seeds).items():
        for config,by_seed in group.items():
            first=next(iter(by_seed.values()))
            for metric in metrics:
                serial='hash_lookup_ns' if metric.startswith('parallel_hash_lookup') else 'lookup_ns'
                paired=[{'seed':int(seed),'serial_ns':float(by_seed[str(seed)][serial]),'parallel_ns':float(by_seed[str(seed)][metric]),
                         'serial_to_parallel_ratio':float(by_seed[str(seed)][serial])/float(by_seed[str(seed)][metric])} for seed in seeds]
                output.append({'case':dict(zip(CASE_FIELDS,case)),'filter':first['filter'],'requested_bpk':int(first['requested_bpk']),
                               'filter_bytes':int(first['filter_bytes']),'metric':metric,'serial_control':serial,'paired_seeds':paired,
                               'median_serial_ratio':statistics.median(r['serial_to_parallel_ratio'] for r in paired),
                               'min_serial_ratio':min(r['serial_to_parallel_ratio'] for r in paired),'max_serial_ratio':max(r['serial_to_parallel_ratio'] for r in paired)})
    return output

def main():
    here=Path(__file__).resolve().parent;protocol=json.loads((here/'protocol.json').read_text());metadata=json.loads((here/'results/metadata.json').read_text())
    if metadata['source_changes'] or metadata['binary_changed']:raise ValueError('source/executable drift')
    rows=list(csv.DictReader((here/'results/results.csv').open()));seeds=protocol['seeds']
    if len(rows)!=protocol['expected_rows']:raise ValueError('incomplete matrix')
    for case in protocol['cases']:
        group=[r for r in rows if int(r['keys'])==1<<case['key_power'] and int(r['requested_bpk'])==case['requested_bpk'] and int(r['threads'])==case['threads'] and int(r['seed'])==case['seed']]
        if len(group)!=23 or {r['filter'] for r in group}!=set(protocol['filters']):raise ValueError('shortlist mismatch')
        for row in group:
            validate_trial_metadata(row)
            for field,want in (('queries',1<<protocol['query_power']),('batch',protocol['batch']),('hit_percent',protocol['hit_percent']),('repeats',protocol['repeats']),('insert_batch',int(row['keys'])),('calibration_absent_queries',1<<protocol['calibration_power'])):
                if int(row[field])!=want:raise ValueError('workload mismatch: '+field)
    caps=protocol['eligibility']['actual_memory_caps_bpk'];targets=protocol['eligibility']['fpr_targets'];metrics=protocol['ranking_metrics']
    quality=pooled_quality(rows,seeds)
    result={'scope':'T8/batch4096 fresh-seed confirmation only; T1/T4 remain screening-only.','pooled_calibration':list(quality.values()),
            'comparisons':comparisons(rows,seeds,caps,targets,metrics),
            'family_comparisons':sum((comparisons(rows,seeds,caps,targets,metrics,family) for family in sorted(NATIVE)),[]),
            'serial_ratios':serial_ratios(rows,seeds,metrics)}
    (here/'results/summary.json').write_text(json.dumps(result,indent=2)+'\n')
    def flat(comp):
        output=[]
        for r in comp:
            row={**r['case'],'memory_cap_bpk':r['memory_cap_bpk'],'fpr_target':r['fpr_target'],'metric':r['metric'],'native_family':r['native_family'],
                 'aggregate_median_winner':r['aggregate_median_winner'],**{k:r.get(k,'') for k in ('aggregate_speedup','paired_median_speedup','paired_speedup_min','paired_speedup_max','conservative_speedup_min','conservative_speedup_max','native_all_seed_quality_uppers_pass','external_all_seed_quality_uppers_pass')}}
            for side in ('native','external'):
                for f in ('filter','requested_bpk','filter_bytes','actual_bpk','median_of_seed_medians_ns','wilson95_upper','max_seed_wilson95_upper'):
                    row[side+'_'+f]=r[side][f] if r[side] else ''
            output.append(row)
        return output
    ratios=[{**r['case'],**{f:r[f] for f in ('filter','requested_bpk','filter_bytes','metric','serial_control','median_serial_ratio','min_serial_ratio','max_serial_ratio')}} for r in result['serial_ratios']]
    paired=[]
    for r in result['comparisons']:
        for pair,conservative in zip(r.get('paired_seeds',[]),r.get('conservative_seeds',[])):
            paired.append({**r['case'],'memory_cap_bpk':r['memory_cap_bpk'],'fpr_target':r['fpr_target'],'metric':r['metric'],
                           'native_filter':r['native']['filter'],'native_requested_bpk':r['native']['requested_bpk'],
                           'external_filter':r['external']['filter'],'external_requested_bpk':r['external']['requested_bpk'],**pair,
                           'conservative_external_filter':conservative['external_filter'],
                           'conservative_external_requested_bpk':conservative['external_requested_bpk'],
                           'conservative_external_ns':conservative['external_ns'],'conservative_speedup':conservative['speedup'],
                           'conservative_external_pooled_wilson95_upper':conservative['external_pooled_wilson95_upper'],
                           'conservative_external_seed_wilson95_upper':conservative['external_seed_wilson95_upper']})
    for name,values in (('qualified-comparison.csv',flat(result['comparisons'])),('qualified-family-comparison.csv',flat(result['family_comparisons'])),('paired-seed-comparison.csv',paired),('serial-ratios.csv',ratios)):
        with (here/'results'/name).open('w',newline='') as file:
            writer=csv.DictWriter(file,fieldnames=list(values[0]),lineterminator='\n');writer.writeheader();writer.writerows(values)
    print(f'{len(rows)} rows, {len(quality)} pooled configurations, {len(result["comparisons"])} eight-core quality/metric comparisons; each configuration has three fresh seed streams')

if __name__=='__main__':main()
