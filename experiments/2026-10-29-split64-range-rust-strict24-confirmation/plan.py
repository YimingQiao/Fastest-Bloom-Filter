#!/usr/bin/env python3
"""Source-only finite held-out proposal, derived from all eligible training APIs."""
import csv
import hashlib
import json
from pathlib import Path
import subprocess
import sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
STAGE=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes-screen'
sys.path.insert(0,str(STAGE))
import guard

RAW_COMMIT='2624516177e02d9019c582b2e76a6b6ac8fad7ae'
PRODUCER_COMMIT='571186b420bf7e5fc08269ed4a65feab42ac8400'
BINARY='/tmp/fastest-bf-fastbloom-fixed-k-performance/validation-v1/native/release/compare_benchmark'
BINARY_SHA='f499f5daa354f3db31c5cfa1e84640c890f96c81e2724456aa64bf7b6bc7ef05'
SEEDS=(32452843,49979687)
METRICS=tuple(m+'_ns'for m in guard.METRICS)+guard.BUILD

def read_committed(path,commit=RAW_COMMIT):
    raw=path.read_bytes()
    assert raw==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
    return raw

def inputs():
    import io
    read_committed(STAGE/'guard.py',PRODUCER_COMMIT)
    raw=STAGE/'resume-results-v1/combined/results.csv'
    quality=STAGE/'resume-results-v1/combined/quality.json'
    rows=list(csv.DictReader(io.StringIO(read_committed(raw).decode())))
    document=json.loads(read_committed(quality))
    assert len(rows)==336 and len(document['api_records'])==112 and len(document['mapping_records'])==110
    source_path=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes/benchmark/src/main.rs'
    source=read_committed(source_path,PRODUCER_COMMIT).decode()
    return rows,document,source,{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest()for p in [raw,quality,source_path,STAGE/'guard.py']}

def derive():
    rows,document,source,pins=inputs()
    # The completed quality document is not pooled across its repeated batch tags.
    # Use the same independent Wilson endpoint formula and denominator as training.
    import math
    def high(row):
        fp=int(row['calibration_false_positives']);n=int(row['calibration_absent_queries'])
        z=1.959963984540054;z2=z*z;p=fp/n
        return 1.0 if fp==n else min(1.0,(p+z2/(2*n)+z*math.sqrt(p*(1-p)/n+z2/(4*n*n)))/(1+z2/n))
    support={}
    for r in rows:
        if r['filter']not in guard.EXTERNAL or int(r['filter_bytes'])*8>24*int(r['keys']):continue
        key=(r['filter'],int(r['keys']),int(r['filter_bytes']))
        current=dict(filter=r['filter'],keys=int(r['keys']),actual_bpk=float(r['actual_bpk']),filter_bytes=int(r['filter_bytes']),
            calibration_false_positives=int(r['calibration_false_positives']),calibration_negatives=int(r['calibration_absent_queries']),
            wilson95_high=high(r),qualifies_strict24=high(r)<=.0001,effective_probes=int(r['effective_probes']))
        assert key not in support or support[key]==current
        support[key]=current
    assert len(support)==60 # all15 external APIs at16/24 bpk, both sizes
    decisions=[];union=set()
    for n in [1<<16,1<<25]:
        for batch in [1,31,4096]:
            for metric in METRICS:
                eligible=[r for r in rows if int(r['keys'])==n and int(r['batch'])==batch and
                    r['filter']in guard.EXTERNAL and int(r['filter_bytes'])*8<=24*n and high(r)<=.0001]
                assert eligible
                best=min(float(r[metric])for r in eligible)
                leaders=[dict(filter=r['filter'],actual_bpk=float(r['actual_bpk']),filter_bytes=int(r['filter_bytes']),ns=float(r[metric]))
                    for r in eligible if float(r[metric])==best]
                union.update((r['filter'],r['actual_bpk'])for r in leaders)
                decisions.append(dict(keys=n,batch=batch,metric=metric,cap_bpk=24,fpr_ceiling=.0001,leaders=leaders,
                    eligible=[dict(filter=r['filter'],actual_bpk=float(r['actual_bpk']),ns=float(r[metric]),wilson95_high=high(r))for r in eligible]))
    assert len(decisions)==48
    # Do not hand-pick K7: the complete query+build union must be derived first.
    assert union=={('Fastbloom017K7',24.0)},'Training winner union changed; preserve this proposal and review a new scope'
    names=[name for name in guard.source_registry(source)if name in {guard.RANGE}|{name for name,_ in union}]
    cases=[];proof=[]
    base=[(n,batch)for n in [16,25]for batch in [1,31,4096]]
    for seed_index,seed in enumerate(SEEDS):
        for n,batch in (base if seed_index==0 else list(reversed(base))):
            case=dict(key_power=n,budget_bpk=24,batch=batch,seed=seed,filters=names)
            # Main consumes one key_base draw, n-1 insertion shuffles, q/2
            # positive draws and q-1 query shuffles before selected-job shuffle.
            state=(seed+guard.STEP*((1<<n)+(1<<22)//2+(1<<22)-1))&guard.MASK
            order=guard.shuffled(names,state)
            cases.append(dict(case=case,expected_filter_order=order,
                expected_phase_order=guard.expected_phases(seed,8),
                raw_intervals=guard.raw_intervals(case,dict(query_power=22,calibration_power=24)),
                command=[BINARY,str(n),'24','50','22',str(batch),'8',str(seed),','.join(names),str(1<<n),'24']))
    for n in [16,25]:
        for batch in [1,31,4096]:
            orders=[r['expected_filter_order']for r in cases if r['case']['key_power']==n and r['case']['batch']==batch]
            assert orders[0]==list(reversed(orders[1]))
            proof.append(dict(key_power=n,batch=batch,seed_orders=orders,pair_order_balanced=True))
    return dict(training_raw_commit=RAW_COMMIT,producer_source_commit=PRODUCER_COMMIT,inputs_sha256=pins,
        target=dict(actual_bpk_ceiling=24,fpr_ceiling=.0001),
        selection_rule='Union of exact fastest eligible external allocations over all2 sizes×3 batches×8 query/build metrics; retain ties; no guessed K or minimum-K timing assumption.',
        external_union=[dict(filter=name,actual_bpk=bpk)for name,bpk in sorted(union)],decisions=decisions,
        all_external_capacity_quality_support=list(support.values()),
        complete112_quality_document= str((STAGE/'resume-results-v1/combined/quality.json').relative_to(ROOT)),
        cases=cases,pair_order_proof=proof)

if __name__=='__main__':
    target=HERE/'selection.json';assert not target.exists(),'Preserve prior selection artifact'
    target.write_text(json.dumps(derive(),indent=2,allow_nan=False)+'\n')
    print('Source-only:48 exact metric selections,60 external eligibility records;12 cases/24 rows, two preselected fresh seeds; no Bloom execution.')
