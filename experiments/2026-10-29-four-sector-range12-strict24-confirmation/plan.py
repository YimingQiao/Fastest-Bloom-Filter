#!/usr/bin/env python3
"""Source-only finite78 plan: fixed training union, order-only seeds, no BF."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
TRAIN=ROOT/'experiments/2026-10-29-four-sector-range12-analysis'
STAGE=ROOT/'experiments/2026-10-29-four-sector-range12-screen'
TRAIN_COMMIT='cf8642c5e0d0f5800a1cd316f89c312b333c772a'
SOURCE_COMMIT='a433e307c73b46e0c1e6f011cf6b6e0d8b2c2ef3'
PROOF_COMMIT='e150be33b95a22dca9b75175e6174b9555c82393'
RAW_COMMIT='fd50847f2a4f414be8962f6e6a19039d9966ee6c'
CANDIDATE='FourSectorRange12Experiment'
BINARY='/tmp/fastest-bf-k12-actual-caller-v2/native/actual/benchmark'
BINARY_SHA='9aceea39f8f57564409806f911ddcf2ec6c17ff623a5132acbb609b11ad05149'
MASK=(1<<64)-1
GAMMA=0x9e3779b97f4a7c15
SEED_ORIGIN=0x4b31322d686f6c64

def need(ok,why):
    if not ok:raise ValueError(why)
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def read(path,commit):
    data=subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT);need(data==path.read_bytes(),'Changed committed input '+str(path));return json.loads(data)
def mix(x):
    z=x&MASK;z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK;z=((z^(z>>27))*0x94d049bb133111eb)&MASK;return z^(z>>31)
def order(n,seed,selected,registry,q=1<<22):
    hits=q//100*50+min(q%100,50);state=(seed+(n+q+hits-1)*GAMMA)&MASK;names=[x for x in registry if x in selected]
    for i in range(len(names),1,-1):state=(state+GAMMA)&MASK;j=mix(state)%i;names[i-1],names[j]=names[j],names[i-1]
    return names

def domain(power,seed,cal=26):
    n=1<<power;q=1<<22;base=mix(seed+GAMMA)%((1<<32)-n-q)
    return dict(key_power=power,key_base=base,inserted=[base,base+n],timed_negative_envelope=[base+n,base+n+q],independent_calibration=[base+n+q,base+n+q+(1<<cal)],full_counter_envelope=[base,base+n+q+(1<<cal)],convention='half-open; positive timed queries deliberately revisit inserted keys')
def overlaps(a,b):return max(a[0],b[0])<min(a[1],b[1])

def derive():
    views=read(TRAIN/'report/leaders.json',TRAIN_COMMIT);registry=read(STAGE/'registry.json',SOURCE_COMMIT)
    proof=read(STAGE/'CALLER_FREEZE.json',PROOF_COMMIT);need(proof['performance_binary']==BINARY and proof['performance_binary_sha256']==BINARY_SHA and sha(Path(BINARY))==BINARY_SHA,'Changed frozen actual caller')
    current=read(TRAIN/'report/quality.json',TRAIN_COMMIT)
    primary=[x for x in views if x['cap_bpk']==24 and x['fpr_ceiling']==.0001]
    secondary=[x for x in views if x['keys']==1<<25 and x['cap_bpk']==32 and x['fpr_ceiling']==.0001]
    need(len(primary)==8 and len(secondary)==4,'Changed fixed training views')
    def geometries(rows):
        result={}
        for row in rows:
            for item in row['winners']['external']+row['best_retained_projects']+row['winners']['K12_experiment']:
                key=(item['filter'],item['requested_bpk']);result[key]=dict(filter=item['filter'],requested_bpk=item['requested_bpk'])
        return sorted(result.values(),key=lambda x:(x['requested_bpk'],registry.index(x['filter'])))
    primary_union=geometries(primary);need(len(primary_union)==5 and all(x['requested_bpk']==24 for x in primary_union),'Unexpected primary training union')
    selected=[x['filter']for x in primary_union]
    expected={'FourSectorRange12Experiment','Split64RangeNative','FastFilterFixed64','RocksDBFastLocalBloom64K8Batch32','Boost192Multi64K8'}
    need(set(selected)==expected,'Primary union differs from all8 frozen views')
    secondary_union=geometries(secondary);extra=[x for x in secondary_union if x not in primary_union]
    need(extra==[dict(filter='Boost192Multi32K8',requested_bpk=28),dict(filter='FastPatternBF',requested_bpk=32),dict(filter='FourSectorBloomFilter',requested_bpk=32)],'Unexpected secondary geometry union')
    occupied=[domain(power,42,24)['full_counter_envelope']for power in(16,25)]
    training_envelopes=list(occupied);ledger=[];seeds=[];candidate_id=0
    for target,label in[(0,'first'),(2,'middle'),(4,'last')]:
        while True:
            seed=mix(SEED_ORIGIN+candidate_id*GAMMA);orders={str(p):order(1<<p,seed,selected,registry)for p in(16,25)};positions={p:names.index(CANDIDATE)for p,names in orders.items()}
            domains=[domain(p,seed)for p in(16,25)];envelopes=[x['full_counter_envelope']for x in domains]
            order_ok=all(pos==target for pos in positions.values());disjoint=not overlaps(*envelopes)and all(not overlaps(new,old)for new in envelopes for old in occupied)
            accept=order_ok and disjoint
            ledger.append(dict(candidate_id=candidate_id,seed=seed,target_position=target,target_label=label,observed_positions=positions,order_qualifies=order_ok,raw_domain_disjoint=disjoint,accepted=accept,raw_domains=domains))
            candidate_id+=1;need(candidate_id<=10000,'Bounded source-only order search exhausted')
            if accept:seeds.append(seed);occupied.extend(envelopes);break
    cases=[]
    for seed_index,seed in enumerate(seeds):
        base=[]
        for power in(16,25):
            for batch in(31,4096):base.append(dict(track='primary24',key_power=power,budget_bpk=24,batch=batch,filters=selected))
        for budget in(28,32):
            filters=[x['filter']for x in extra if x['requested_bpk']==budget]
            for batch in(31,4096):base.append(dict(track='secondary32_additional_geometry',key_power=25,budget_bpk=budget,batch=batch,filters=filters))
        shift=seed_index*3%len(base);base=base[shift:]+base[:shift]
        for item in base:
            row=dict(item,seed=seed);row['expected_order']=order(1<<item['key_power'],seed,item['filters'],registry);row['raw_domains']=domain(item['key_power'],seed)
            row['command']=[BINARY,str(item['key_power']),str(item['budget_bpk']),'50','22',str(item['batch']),'6',str(seed),','.join(item['filters']),str(1<<item['key_power']),'26','query-only','0'];cases.append(row)
    need(len(cases)==24 and sum(len(x['filters'])for x in cases)==78,'Wrong finite78 coverage')
    # API records are preserved independently; only pre-proven Range/Fixed64 aliases collapse.
    records={}
    for case in cases:
        for name in case['filters']:records[(name,case['key_power'],case['budget_bpk'],case['seed'])]=True
    mapping={('Split64Range/Fixed64'if name in('Split64RangeNative','FastFilterFixed64')else name,power,budget,seed)for name,power,budget,seed in records}
    need(len(records)==39 and len(mapping)==33,'Wrong API/mapping sample cardinalities')
    alias_proof=[r for r in current['mapping_records']if set(['Split64RangeNative','FastFilterFixed64']).issubset(r['apis'])and r['actual_bpk']==24]
    need(len(alias_proof)==2,'Missing previously proven equal-mapping identity for24bpk')
    return dict(training_commit=TRAIN_COMMIT,producer_source_commit=SOURCE_COMMIT,compiled_proof_commit=PROOF_COMMIT,raw_training_commit=RAW_COMMIT,performance_binary=BINARY,performance_binary_sha256=BINARY_SHA,primary_decisions=primary,secondary_decisions=secondary,primary_union=primary_union,secondary_extra=extra,seed_origin=SEED_ORIGIN,seed_generator='mix64(SEED_ORIGIN+candidate_id*golden64) modulo2^64; no filter outputs involved',seeds=seeds,seed_ledger=ledger,training_counter_envelopes_excluded=training_envelopes,all_six_fresh_counter_envelopes_pairwise_disjoint=True,calibration_power=26,query_power=22,repeats=6,cases=cases,expected_cases=24,expected_rows=78,primary_rows=60,secondary_additional_rows=18,api_geometry_seed_quality_records=39,known_mapping_seed_quality_records=33,known_alias_proof=alias_proof,quality_pooling=False,outcome_based_extension=False)

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--write',action='store_true');args=parser.parse_args();proposal=derive();path=HERE/'selection.json';text=json.dumps(proposal,indent=2)+'\n'
    if args.write:need(not path.exists(),'Preserve existing proposal');path.write_text(text)
    else:need(path.read_text()==text,'Source-derived proposal drift')
    print(json.dumps(dict(seed_candidates=len(proposal['seed_ledger']),seeds=proposal['seeds'],cases=24,rows=78,API_samples=39,mapping_samples=33,filter_runs=0)))
if __name__=='__main__':main()
