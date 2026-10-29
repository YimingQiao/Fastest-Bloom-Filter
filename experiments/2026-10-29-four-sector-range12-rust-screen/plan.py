#!/usr/bin/env python3
"""Source-only K12 Rust108 proposal derived from every strict24/32 training view."""
import csv,hashlib,io,json,math,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
RAW='2624516177e02d9019c582b2e76a6b6ac8fad7ae'
ANALYSIS='434747e8d83b1ad1f43a1ce01149afc1d41fceb7'
SOURCE='571186b420bf7e5fc08269ed4a65feab42ac8400'
FRESH='3f830f99c84e03ff3b2ef2b0903c500e19062ee9'
PROOF='645f397cd406fd7e89cc75020b0b6fe2f142b3ab'
CPP_FRESH='9c9cd9a32a3fbd6dd025f62e1055084312a0ae4b'
CANDIDATE='FourSectorRange12BloomFilter'
MASK=(1<<64)-1;STEP=0x9e3779b97f4a7c15;ORIGIN=0x4b31325255535431
QUERY=('lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns')
BUILD=('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns')
NATIVE={'FastPatternBF','ByteSplitBloomFilter','FourSectorBloomFilter','Split64BloomFilter'}
EXTERNAL={'SbbfSafePinned','Fastbloom017','BloomsdayPinned'}|{f'Fastbloom017K{k}'for k in range(1,13)}

def need(ok,why):
    if not ok:raise ValueError(why)
def read(relative,commit,pins):
    p=ROOT/relative;data=p.read_bytes();need(data==subprocess.check_output(['git','show',commit+':'+relative],cwd=ROOT),'Changed committed input '+relative);pins[relative]=dict(commit=commit,sha256=hashlib.sha256(data).hexdigest(),bytes=len(data));return data

def high(fp,n):
    z=1.959963984540054;z2=z*z;p=fp/n
    if fp==n:return 1.0
    return min(1.0,(p+z2/(2*n)+z*math.sqrt(p*(1-p)/n+z2/(4*n*n)))/(1+z2/n))
def mix(x):
    x&=MASK;x=((x^(x>>30))*0xbf58476d1ce4e5b9)&MASK;x=((x^(x>>27))*0x94d049bb133111eb)&MASK;return x^(x>>31)
def order(power,seed,names,registry,q=1<<22):
    n=1<<power;hits=q//100*50+min(q%100,50);state=(seed+(n+q+hits-1)*STEP)&MASK;result=[x for x in registry if x in names]
    for count in range(len(result),1,-1):state=(state+STEP)&MASK;j=mix(state)%count;result[count-1],result[j]=result[j],result[count-1]
    return result

def domain(power,seed,cal):
    n=1<<power;q=1<<22;base=mix(seed+STEP)%((1<<32)-n-q)
    return dict(key_power=power,seed=seed,key_base=base,inserted=[base,base+n],timed_negative_envelope=[base+n,base+n+q],independent_calibration=[base+n+q,base+n+q+(1<<cal)],full_counter_envelope=[base,base+n+q+(1<<cal)],interval_convention='half-open raw counters; common hash then applied; positive queries intentionally revisit insertion keys')
def overlaps(a,b):return max(a[0],b[0])<min(a[1],b[1])
def owner(name):return 'external'if name in EXTERNAL else 'production_snapshot'if name in NATIVE else 'optional_range_snapshot'
def identity(row):return dict(filter=row['filter'],requested_bpk=int(row['requested_bpk']),filter_bytes=int(row['filter_bytes']),actual_bpk=float(row['actual_bpk']))

def derive():
    pins={};raw_path='experiments/2026-10-29-rust-fastbloom-fixed-probes-screen/resume-results-v1/combined/results.csv'
    rows=list(csv.DictReader(io.StringIO(read(raw_path,RAW,pins).decode())));need(len(rows)==336,'Incomplete training raw')
    source=read('experiments/2026-10-29-rust-fastbloom-fixed-probes/benchmark/src/main.rs',SOURCE,pins).decode()
    match=re.search(r'const FILTER_NAMES: &\[&str\] = &\[(.*?)\];',source,re.S);need(match is not None,'Registry absent');registry=re.findall(r'"([A-Za-z0-9_]+)"',match[1]);need(len(registry)==20 and set(registry)==NATIVE|EXTERNAL|{'Split64RangeBloomFilter'},'Wrong original registry');registry.append(CANDIDATE)
    quality={}
    for row in rows:
        n=int(row['keys']);key=(row['filter'],n,int(row['filter_bytes']));item=dict(**identity(row),keys=n,owner=owner(row['filter']),effective_probes=int(row['effective_probes']),calibration_false_positives=int(row['calibration_false_positives']),calibration_negatives=int(row['calibration_absent_queries']),wilson95_high=high(int(row['calibration_false_positives']),int(row['calibration_absent_queries'])))
        need(key not in quality or quality[key]==item,'Repeated quality drift');quality[key]=item
    need(len(quality)==112,'All112 API quality records retained')
    union={1<<16:set(),1<<25:set()};decisions=[]
    for n in(1<<16,1<<25):
        for batch in(1,31,4096):
            for cap in(24,32):
                for metric in QUERY+BUILD:
                    candidates=[r for r in rows if int(r['keys'])==n and int(r['batch'])==batch and int(r['filter_bytes'])*8<=cap*n and quality[(r['filter'],n,int(r['filter_bytes']))]['wilson95_high']<=.0001]
                    leaders={};eligible={}
                    for category in('external','retained_project'):
                        items=[r for r in candidates if (r['filter']in EXTERNAL)==(category=='external')]
                        eligible[category]=[dict(**identity(r),owner=owner(r['filter']),ns=float(r[metric]),wilson95_high=quality[(r['filter'],n,int(r['filter_bytes']))]['wilson95_high'])for r in items]
                        best=min((float(r[metric])for r in items),default=None)
                        selected=[r for r in items if float(r[metric])==best]
                        leaders[category]=[dict(**identity(r),ns=float(r[metric]),owner=owner(r['filter']))for r in selected]
                        union[n].update((r['filter'],int(r['requested_bpk']))for r in selected)
                    decisions.append(dict(keys=n,batch=batch,cap_bpk=cap,fpr_ceiling=.0001,metric=metric,leaders=leaders,eligible=eligible))
    need(len(decisions)==96,'Wrong full training view count')
    # Independently bind the published analysis; raw-derived external and combined
    # retained minima above are not selected by reading a hand-written report.
    for kind,metrics in [('query',QUERY),('build',BUILD)]:
        views=list(csv.DictReader(io.StringIO(read('experiments/2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/report/'+kind+'-views.csv',ANALYSIS,pins).decode())))
        for d in [x for x in decisions if x['metric']in metrics]:
            match=[x for x in views if int(x['keys'])==d['keys']and int(x['batch'])==d['batch']and int(x['cap_bpk'])==d['cap_bpk']and float(x['fpr_ceiling'])==.0001 and x['metric']==d['metric']];need(len(match)==1,'Missing published view');v=match[0]
            need({(x['filter'],x['filter_bytes'])for x in d['leaders']['external']}=={(x['filter'],x['filter_bytes'])for x in json.loads(v['external_leaders'])},'Published external leader mismatch')
            a=float(v['production_native_ns'])if v['production_native_ns']else math.inf;b=float(v['native_experimental_ns'])if v['native_experimental_ns']else math.inf
            expected=(json.loads(v['production_native_leaders'])if a<=b else[])+(json.loads(v['native_experimental_leaders'])if b<=a else[])
            need({(x['filter'],x['filter_bytes'])for x in d['leaders']['retained_project']}=={(x['filter'],x['filter_bytes'])for x in expected},'Published retained leader mismatch')
    expected={1<<16:{('BloomsdayPinned',32),('Fastbloom017K7',24),('FourSectorBloomFilter',32),('Split64BloomFilter',32),('Split64RangeBloomFilter',24),('Split64RangeBloomFilter',32)},1<<25:{('BloomsdayPinned',32),('Fastbloom017K7',24),('FourSectorBloomFilter',32),('Split64RangeBloomFilter',24)}}
    need(union==expected,'Training union changed; review new scope rather than silently substitute')
    fresh=json.loads(read('experiments/2026-10-29-split64-range-rust-strict24-analysis/report/metadata.json',FRESH,pins));read('experiments/2026-10-29-split64-range-rust-strict24-analysis/REPORT.md',FRESH,pins)
    fresh_quality=json.loads(read('experiments/2026-10-29-split64-range-rust-strict24-analysis/report/quality.json',FRESH,pins));need(fresh['raw_rows']==24 and fresh['paired_outcomes']==96,'Wrong prior fresh evidence')
    proof=json.loads(read('experiments/2026-10-29-four-sector-range12-rust-port/PREFLIGHT_FREEZE.json',PROOF,pins));read('experiments/2026-10-29-four-sector-range12-rust-port/native/src/four_sector_range12.rs',PROOF,pins);need(proof['checks']['rust_full_byte_comparisons']==36,'Missing public candidate proof')
    cpp=json.loads(read('experiments/2026-10-29-four-sector-range12-strict24-confirmation/protocol.json',CPP_FRESH,pins))
    old_seeds=[(42,24),(32452843,24),(49979687,24)]+[(x,26)for x in cpp['seeds']]
    prior=[dict(kind='prior Rust training/fresh or C++ K12 fresh',**domain(p,s,c))for s,c in old_seeds for p in(16,25)]
    occupied=[d['full_counter_envelope']for d in prior];ledger=[];seeds=[];candidate_id=0;primary=['Split64RangeBloomFilter','Fastbloom017K7',CANDIDATE]
    for position,label in enumerate(('first','middle','last')):
        while True:
            need(candidate_id<100000,'Finite seed search exhausted')
            seed=mix(ORIGIN+candidate_id*STEP);orders={str(p):order(p,seed,primary,registry)for p in(16,25)};positions={p:names.index(CANDIDATE)for p,names in orders.items()};domains=[domain(p,seed,26)for p in(16,25)];envelopes=[x['full_counter_envelope']for x in domains]
            order_ok=all(x==position for x in positions.values());disjoint=not overlaps(*envelopes)and all(not overlaps(a,b)for a in envelopes for b in occupied)
            accept=order_ok and disjoint and seed not in[s for s,_ in old_seeds]
            ledger.append(dict(candidate_id=candidate_id,seed=seed,target_position=label,orders=orders,positions=positions,domains=domains,order_ok=order_ok,disjoint_from_prior_and_selected=disjoint,accepted=accept));candidate_id+=1
            if accept:seeds.append(seed);occupied.extend(envelopes);break
    panels={str(n):[dict(filter=name,requested_bpk=bpk,actual_bytes=n*bpk//8,owner='K12_experiment'if name==CANDIDATE else owner(name))for name,bpk in sorted(items|{(CANDIDATE,24)},key=lambda x:(x[1],registry.index(x[0])))]for n,items in union.items()}
    cases=[];batches=(1,31,4096)
    for seed_index,seed in enumerate(seeds):
        for power in((16,25)if seed_index%2==0 else(25,16)):
            for batch in batches[seed_index:]+batches[:seed_index]:
                for budget in((24,32)if seed_index%2==0 else(32,24)):
                    selected=[x['filter']for x in panels[str(1<<power)]if x['requested_bpk']==budget]
                    cases.append(dict(key_power=power,budget_bpk=budget,batch=batch,seed=seed,filters=selected,expected_filter_order=order(power,seed,selected,registry),domains=domain(power,seed,26),arguments=[str(power),str(budget),'50','22',str(batch),'8',str(seed),','.join(selected),str(1<<power),'26'],track='primary24'if budget==24 else'secondary32_extra'))
    need(len(cases)==36 and sum(len(x['filters'])for x in cases)==108,'Wrong finite108 scope')
    return dict(inputs=pins,original_registry=registry[:-1],planned_registry=registry,candidate=CANDIDATE,training_decisions=decisions,complete_training_api_quality=list(quality.values()),selected_size_panels=panels,previous_fresh_metadata=fresh,previous_fresh_quality=fresh_quality,seed_selection=dict(origin=ORIGIN,step=STEP,method='SplitMix-mixed deterministic candidate IDs; only source-derived primary candidate position and raw-domain separation; no new filter outputs',prior_domains=prior,candidate_ledger=ledger,fresh_seeds=seeds),cases=cases,counts=dict(training_views=96,commands=36,rows=108,api_geometry_seed_quality=36,all_three_seed_api_geometry_gates=12,query_metric_rows=432,build_metric_rows=432,primary_metric_seed_views=144,secondary_metric_seed_views=144))
if __name__=='__main__':
    output=HERE/'selection.json';need(not output.exists(),'Preserve existing selection');result=derive();output.write_text(json.dumps(result,indent=2,allow_nan=False)+'\n');print(json.dumps({'counts':result['counts'],'fresh_seeds':result['seed_selection']['fresh_seeds'],'seed_candidates':len(result['seed_selection']['candidate_ledger'])},indent=2))
