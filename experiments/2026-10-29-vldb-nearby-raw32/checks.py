"""Finite caller proof and metadata checks. Importing executes no filter/planner."""
import csv
import io
import json
import math
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
PROPOSAL=ROOT/'experiments/2026-10-29-vldb-nearby-performance-proposal'
NATIVE=['FastPatternBF','FourSectorBloomFilter','Split64BloomFilter','ByteSplitBloomFilter',
        'Split64RangeBloomFilter','FourSectorRange12Experiment']
SEMANTIC=['queries','seed','hit_percent','present_queries','absent_queries','calibration_absent_queries',
          'calibration_false_positives','false_positives','result_checksum','inserted_checksum','query_checksum','calibration_checksum']
GEOMETRY=['surface','implementation_origin','key_domain','keys','requested_bpk','budget_bytes','filter_bytes',
          'logical_bytes','unit_bytes','unit_count','constructor_argument','effective_probes','probe_policy',
          'geometry_kind','address','public_metadata']
def need(value,message):
    if not value:raise ValueError(message)
def names():return json.loads((PROPOSAL/'proposal.json').read_text())['ordered_apis']
def cases():return [dict(filter=name,power=16,cap=cap)for cap in (12,24)for name in names()]
def command(binary,case,action='--check'):
    return [str(binary),action,case['filter'],str(case['power']),str(case['cap']),'12','50','42','10','0']
def parse(text):
    rows=list(csv.DictReader(io.StringIO(text)))
    need(len(rows)==1 and None not in rows[0] and None not in rows[0].values(),'Exactly one complete CSV row required')
    return rows[0]
def geometry_key(name):
    if name in NATIVE:return name
    config,surface,policy=name.split('/')
    if config.startswith('sector'):config=config.split('-u')[0]+'-u1'
    return config+'/'+surface+'/'+policy
def semantic(row):return {k:row[k]for k in SEMANTIC}
def normalized(row):
    out=dict(row);out.pop('worker',None);out.pop('filter',None)
    out['public_metadata']=json.loads(out['public_metadata']);return out
def validate(row,case):
    need(row['worker']=='nearby_legacy' and row['filter']==case['filter'],'Wrong worker/API identity')
    need(int(row['keys'])==1<<case['power'] and int(row['requested_bpk'])==case['cap'],'Wrong fixed geometry')
    n=1<<case['power'];q=1<<12;present=q//100*50+min(q%100,50)
    need(row['key_domain']=='raw_u32' and int(row['queries'])==q and row['seed']=='42' and row['hit_percent']=='50','Wrong workload')
    need(int(row['present_queries'])==present and int(row['absent_queries'])==q-present and row['calibration_absent_queries']=='1024','Wrong exact raw counts')
    need(0<=int(row['false_positives'])<=q-present and 0<=int(row['calibration_false_positives'])<=1024,'Invalid FP count')
    need(row['repeats']=='0' and row['build_repeats']=='0' and row['query_phase_order']=='untimed','Preflight must not time')
    need(0<int(row['logical_bytes'])<=int(row['filter_bytes'])<=n*case['cap']//8,'Charged allocation outside cap')
    public=case['filter']not in NATIVE;unit=4 if public else 8
    for mode,count in [('raw_single',0),('raw_batch1',1),('raw_batch4096',4096)]:
        for suffix in ['_ns','_min_ns','_max_ns','_trials_ns']:need(row[mode+suffix]=='nan','Unexpected timed field')
        need(int(row[mode+'_scratch_bytes'])==unit*count,'Wrong exact physical scratch')
    for key in ['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:need(row[key]=='nan','Unexpected construction timing')
    need(int(row['build_hash_scratch_bytes'])==(0 if public else 8*n) and row['filter_build_scratch_bytes']=='0','Wrong build scratch')
    for key in ['result_checksum','inserted_checksum','query_checksum','calibration_checksum']:need(0<=int(row[key])<1<<64,'Missing full digest')
    if public:
        config,_,policy=case['filter'].split('/');metadata=json.loads(row['public_metadata']);u=int(config.split('-u')[1])
        need(row['implementation_origin']=='external' and row['surface']=='artifact_pimpl' and metadata['u']==u,'Wrong public U/origin')
        need(metadata['k']==8 and metadata['size']==int(row['logical_bytes']) and row['effective_probes']=='8','Wrong captured metadata')
        need(row['address']==metadata['addr']=='magic','Both fixed nonpower2 policies require actual MAGIC')
        need(row['geometry_kind']==('original_blocked_bloom_nearby_odd'if policy=='nearby_odd'else'original_blocked_bloom'),'Wrong constructor policy')
    elif case['filter']in NATIVE[:4]:
        expected=n*(8 if case['cap']==12 else 16)//8
        need(int(row['filter_bytes'])==expected and row['implementation_origin']=='production_native','Native real-n sizing changed')
    else:
        need(int(row['filter_bytes'])==n*case['cap']//8 and int(row['unit_bytes'])==64,'Range backing changed')
        expected='optional_native_range'if case['filter']==NATIVE[4]else'project_experiment'
        need(row['implementation_origin']==expected and row['surface']=='public_contains_hash_and_lookup','New native surface/origin changed')
    return row
def check_aliases(rows):
    groups={}
    for row in rows:
        key=(geometry_key(row['filter']),row['keys'],row['requested_bpk'])
        value={k:row[k]for k in SEMANTIC+['filter_bytes','logical_bytes','unit_bytes','unit_count','constructor_argument']}
        if key in groups:need(groups[key]==value,'U alias bitmap/output/calibration semantics differ')
        groups[key]=value
    need(len(groups)==24,'Expected24 tiny mapping identities per backend, no pooling')
    return groups
