#!/usr/bin/env python3
"""MT-aware, allocation/FPR-qualified screen summary; no timing-mode pooling."""
import csv
import json
import math
from pathlib import Path
import statistics

NATIVE=frozenset(('FastPatternBF','FourSectorBloomFilter','Split64BloomFilter','ByteSplitBloomFilter'))
METRICS=('parallel_lookup_gated_ns','parallel_hash_lookup_gated_ns',
         'parallel_lookup_end_to_end_ns','parallel_hash_lookup_end_to_end_ns')
QUALITY_FIELDS=('language','filter','keys','requested_bpk','filter_bytes','hash_bits','input_mode','seed','queries','insert_batch')
CASE_FIELDS=('keys','queries','threads','batch','hit_percent','repeats','seed','insert_batch')

def wilson_upper(positive,total):
    if total<=0 or not 0<=positive<=total:raise ValueError('invalid independent calibration counts')
    z=1.959963984540054;p=positive/total;zz=z*z
    return (p+zz/(2*total)+z*math.sqrt((p*(1-p)+zz/(4*total))/total))/(1+zz/total)

def key(row,fields):return tuple(row[field] for field in fields)

def validate_trial_metadata(row):
    for phase in ('parallel_lookup','parallel_hash_lookup'):
        raw=phase=='parallel_lookup' and row['input_mode']=='raw_bytes'
        samples={field:[float(v) for v in row[f'{phase}_{field}_trials'].split('|')]
                 for field in ('end_to_end','launch','gated','join')}
        if raw:
            if any(len(values)!=1 or not math.isnan(values[0]) for values in samples.values()):
                raise ValueError('raw-only adapter has pure timing samples')
            fields=[field+'_ns' for field in ('end_to_end','launch','gated','join')]
            fields += [field+'_'+bound+'_ns' for field in ('end_to_end','gated') for bound in ('min','max')]
            if any(not math.isnan(float(row[phase+'_'+field])) for field in fields):
                raise ValueError('raw-only adapter has a scalar pure timing field')
            continue
        repeats=int(row['repeats'])
        if any(len(values)!=repeats or any(not math.isfinite(v) or v<0 for v in values) for values in samples.values()):
            raise ValueError('invalid raw timing samples')
        for i in range(repeats):
            if not math.isclose(samples['end_to_end'][i],sum(samples[f][i] for f in ('launch','gated','join')),rel_tol=1e-9,abs_tol=1e-8):
                raise ValueError('incomplete query timing decomposition')
        for field,values in samples.items():
            if not math.isclose(float(row[f'{phase}_{field}_ns']),statistics.median(values),rel_tol=1e-9,abs_tol=1e-8):
                raise ValueError('median does not match timing samples')
        for field in ('end_to_end','gated'):
            for label,fn in (('min',min),('max',max)):
                if not math.isclose(float(row[f'{phase}_{field}_{label}_ns']),fn(samples[field]),rel_tol=1e-9,abs_tol=1e-8):
                    raise ValueError('timing range does not match samples')

def calibrations(rows):
    streams={};seen=set();answers={};allocations={}
    for row in rows:
        quality=key(row,QUALITY_FIELDS)
        unique=quality+key(row,('threads','batch','hit_percent','repeats'))
        if unique in seen:raise ValueError('duplicate timing row')
        seen.add(unique)
        allocation_key=key(row,tuple(f for f in QUALITY_FIELDS if f!='filter_bytes'))
        if allocation_key in allocations and allocations[allocation_key]!=row['filter_bytes']:
            raise ValueError('same filter configuration changed allocation across T or batch')
        allocations[allocation_key]=row['filter_bytes']
        if int(row['threads'])!=int(row['spawned_threads'])+1:raise ValueError('worker count mismatch')
        if row['executor']!='caller_worker0':raise ValueError('mixed executor contract')
        count=int(row['calibration_absent_queries']);fp=int(row['calibration_false_positives'])
        upper=wilson_upper(fp,count)
        if quality in streams:
            old=streams[quality]
            if (old['queries'],old['false_positives'])!=(count,fp):
                raise ValueError('inconsistent repeated calibration stream')
            old['repeated_rows']+=1
        else:
            streams[quality]={'queries':count,'false_positives':fp,'wilson95_upper':upper,'repeated_rows':1,
                              'configuration':dict(zip(QUALITY_FIELDS,quality))}
        answer_key=quality+(row['hit_percent'],)
        value=key(row,('result_checksum','absent_queries','false_positives','present_queries'))
        if answer_key in answers and answers[answer_key]!=value:
            raise ValueError('same workload answers changed across T or batch')
        answers[answer_key]=value
    return streams

def record(row,metric,quality):
    return {'filter':row['filter'],'requested_bpk':int(row['requested_bpk']),
            'filter_bytes':int(row['filter_bytes']),'actual_bpk':8*int(row['filter_bytes'])/int(row['keys']),
            'ns_per_query':float(row[metric]),'wilson95_upper':quality['wilson95_upper'],
            'calibration_queries':quality['queries'],'calibration_fp':quality['false_positives']}

def rank(rows,caps=(16,32),targets=(0.01,0.001,0.0001),metrics=METRICS):
    streams=calibrations(rows);groups={}
    for row in rows:groups.setdefault(key(row,CASE_FIELDS),[]).append(row)
    comparisons=[]
    for case,group in sorted(groups.items()):
        for cap in caps:
            for target in targets:
                qualified=[r for r in group if 8*int(r['filter_bytes'])<=cap*int(r['keys'])
                           and streams[key(r,QUALITY_FIELDS)]['wilson95_upper']<=target]
                for metric in metrics:
                    native=[];external=[]
                    for row in qualified:
                        value=float(row[metric])
                        raw_pure=row['input_mode']=='raw_bytes' and metric.startswith('parallel_lookup_')
                        if raw_pure and not math.isnan(value):
                            raise ValueError('raw-only adapter has a pure query metric')
                        if math.isnan(value):
                            if not raw_pure:
                                raise ValueError('unexpected missing timing')
                            continue
                        if not math.isfinite(value) or value<=0:raise ValueError('invalid measured time')
                        (native if row['filter'] in NATIVE else external).append(row)
                    order=lambda r:(float(r[metric]),int(r['filter_bytes']),r['filter'])
                    best_native=min(native,key=order) if native else None
                    best_external=min(external,key=order) if external else None
                    result={'case':dict(zip(CASE_FIELDS,case)),'memory_cap_bpk':cap,'fpr_target':target,'metric':metric,
                            'native_eligible_allocations':len(native),'external_eligible_allocations':len(external),
                            'native':record(best_native,metric,streams[key(best_native,QUALITY_FIELDS)]) if best_native else None,
                            'external':record(best_external,metric,streams[key(best_external,QUALITY_FIELDS)]) if best_external else None}
                    if best_native and best_external:
                        result['native_speedup_vs_best_external']=float(best_external[metric])/float(best_native[metric])
                        result['median_winner']='native' if result['native_speedup_vs_best_external']>1 else 'external' if result['native_speedup_vs_best_external']<1 else 'tie'
                        prefix=metric[:-3]
                        n_min=float(best_native[prefix+'_min_ns']);n_max=float(best_native[prefix+'_max_ns'])
                        e_min=float(best_external[prefix+'_min_ns']);e_max=float(best_external[prefix+'_max_ns'])
                        result['trial_ranges_overlap']=max(n_min,e_min)<=min(n_max,e_max)
                    else:result['median_winner']='unqualified_both' if not native and not external else 'unqualified_native' if not native else 'unqualified_external'
                    comparisons.append(result)
    scaling=[]
    index={key(r,QUALITY_FIELDS)+key(r,('batch','hit_percent','repeats','threads')):r for r in rows}
    for row in rows:
        if row['filter'] not in NATIVE:continue
        base=index.get(key(row,QUALITY_FIELDS)+key(row,('batch','hit_percent','repeats'))+('1',))
        if base is None:raise ValueError('missing fixed-allocation T1 scaling control')
        for metric in metrics:
            scale=float(base[metric])/float(row[metric])
            scaling.append({'filter':row['filter'],**dict(zip(CASE_FIELDS,key(row,CASE_FIELDS))),
                            'requested_bpk':int(row['requested_bpk']),'filter_bytes':int(row['filter_bytes']),
                            'metric':metric,'t1_ns':float(base[metric]),'threads_ns':float(row[metric]),
                            'speedup_vs_same_filter_t1':scale,'parallel_efficiency':scale/int(row['threads'])})
    return {'calibration_streams':list(streams.values()),'comparisons':comparisons,'native_scaling':scaling}

def main():
    here=Path(__file__).resolve().parent
    protocol=json.loads((here/'protocol.json').read_text())
    metadata=json.loads((here/'results/metadata.json').read_text())
    if metadata['source_changes'] or metadata['binary_changed']:raise ValueError('source/executable drift')
    rows=list(csv.DictReader((here/'results/results.csv').open()))
    if len(rows)!=protocol['expected_rows']:raise ValueError('incomplete matrix')
    for case in protocol['cases']:
        group=[r for r in rows if int(r['keys'])==1<<case['key_power'] and int(r['requested_bpk'])==case['requested_bpk'] and int(r['threads'])==case['threads']]
        if len(group)!=23 or {r['filter'] for r in group}!=set(protocol['filters']):raise ValueError('shortlist mismatch')
        for row in group:
            validate_trial_metadata(row)
            for field,want in (('queries',1<<protocol['query_power']),('batch',protocol['batch']),('hit_percent',protocol['hit_percent']),('seed',protocol['seed']),('repeats',protocol['repeats']),('insert_batch',int(row['keys'])),('calibration_absent_queries',1<<protocol['calibration_power'])):
                if int(row[field])!=want:raise ValueError('workload mismatch: '+field)
    result=rank(rows,protocol['eligibility']['actual_memory_caps_bpk'],protocol['eligibility']['fpr_targets'],protocol['ranking_metrics'])
    result['family_comparisons']=[]
    for family in sorted(NATIVE):
        subset=[r for r in rows if r['filter'] not in NATIVE or r['filter']==family]
        detail=rank(subset,protocol['eligibility']['actual_memory_caps_bpk'],protocol['eligibility']['fpr_targets'],protocol['ranking_metrics'])
        for comparison in detail['comparisons']:
            comparison['native_family']=family
            result['family_comparisons'].append(comparison)
    result['limitations']=protocol['eligibility']['limits']
    result['calibration_deduplication']={'timing_rows':len(rows),'distinct_streams':len(result['calibration_streams']),
        'rule':'Repeated T/batch entries are checked for identical count and positives and counted once; no pooling across different timing-query counts.'}
    (here/'results/summary.json').write_text(json.dumps(result,indent=2)+'\n')
    def flatten(comparisons):
        flat=[]
        for r in comparisons:
            row={**r['case'],'memory_cap_bpk':r['memory_cap_bpk'],'fpr_target':r['fpr_target'],'metric':r['metric'],'median_winner':r['median_winner'],
                 'native_speedup_vs_best_external':r.get('native_speedup_vs_best_external',''),'trial_ranges_overlap':r.get('trial_ranges_overlap','')}
            if 'native_family' in r:row['native_family']=r['native_family']
            for side in ('native','external'):
                for field in ('filter','requested_bpk','filter_bytes','actual_bpk','ns_per_query','wilson95_upper'):
                    row[side+'_'+field]=r[side][field] if r[side] else ''
            flat.append(row)
        return flat
    flat=flatten(result['comparisons'])
    for name,values in (('qualified-comparison.csv',flat),('qualified-family-comparison.csv',flatten(result['family_comparisons'])),('native-scaling.csv',result['native_scaling'])):
        with (here/'results'/name).open('w',newline='') as file:
            writer=csv.DictWriter(file,fieldnames=list(values[0]),lineterminator='\n');writer.writeheader();writer.writerows(values)
    print(f'{len(rows)} rows, {len(result["calibration_streams"])} distinct calibration streams, {len(flat)} qualified comparisons, {len(result["native_scaling"])} separate native scaling entries')

if __name__=='__main__':main()
