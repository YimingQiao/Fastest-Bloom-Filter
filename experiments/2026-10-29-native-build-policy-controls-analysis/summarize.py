#!/usr/bin/env python3
"""The prespecified six-contrast, eight-cycle descriptive analysis."""
import argparse,csv,hashlib,importlib.util,io,json,math,random,statistics,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
PRODUCER=ROOT/'experiments/2026-10-29-native-build-policy-controls/screening'
sys.path.insert(0,str(PRODUCER))
import audit as producer
from screen_contract import PLAN,need,parse
RAW_COMMIT='9986f9312d914c72790d527bbc9e3faca8558cf7'
RAW_MANIFEST_SHA='15f0057ba6d70ea3c7268e94f67e2eb15d594076b13740a8490234aee12620ad'
SOURCE='c59e2cb3c559c3bd56d8ef59ad79994f93033bf9'
CONTRASTS=(('A1','A0'),('Policy','A0'),('Policy','A1'),('Clone','A0'),('Clone','A1'),('Policy','Clone'))
NEGATIVE=('A1/A0','Clone/A0','Clone/A1')
POLICY=('Policy/A0','Policy/A1')
BAND=(.97,1.03)
SEED=20261029
DRAWS=10000
AXES=('language','family','scenario','requested','contract')


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def dump(path,value):path.write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def csv_text(rows,fields=None):
    stream=io.StringIO(newline='');writer=csv.DictWriter(stream,fieldnames=fields or list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows);return stream.getvalue()


def load():
    manifest=PRODUCER/'SCREEN_ARCHIVE.json'
    need(sha(manifest)==RAW_MANIFEST_SHA,'Wrong committed raw archive')
    files=parse(manifest.read_text())['files']
    need(len(files)==83,'Wrong full raw extent')
    for path in [manifest]+[PRODUCER/name for name in files]:
        need(path.read_bytes()==subprocess.check_output(['git','show',RAW_COMMIT+':'+str(path.relative_to(ROOT))],cwd=ROOT),'Raw committed byte drift')
        if path!=manifest:
            entry=files[str(path.relative_to(PRODUCER))];need(sha(path)==entry['sha256']and path.stat().st_size==entry['bytes'],'Raw inventory drift')
    rows,counts=producer.load(SOURCE,live=False)
    need(counts['process_cases']==40 and counts['contracts']==72,'Wrong audited scope')
    return rows


def resampling():
    # The same fixed index matrix is reused for every contrast. Across-cell
    # reuse is harmless to these separate descriptive intervals; no joint
    # or independent-cell significance calculation is made.
    rng=random.Random(SEED)
    return [tuple(rng.randrange(8)for _ in range(8))for _ in range(DRAWS)]


def quantile_sorted(values,p):
    rank=(len(values)-1)*p;lo=math.floor(rank);hi=math.ceil(rank)
    return values[lo]+(values[hi]-values[lo])*(rank-lo)


def estimate(numerator,denominator,draws):
    need(len(numerator)==len(denominator)==32,'Exactly32 original samples required')
    need(all(math.isfinite(x)and x>0 for x in numerator+denominator),'Positive finite times required')
    logs=[math.log(a/b)for a,b in zip(numerator,denominator,strict=True)]
    blocks=[math.fsum(logs[start:start+4])/4 for start in range(0,32,4)]
    point=math.exp(math.fsum(blocks)/8)
    distribution=sorted(math.exp(math.fsum(blocks[i]for i in indices)/8)for indices in draws)
    return dict(latency_ratio=point,interval_low=quantile_sorted(distribution,.025),interval_high=quantile_sorted(distribution,.975)),blocks,logs


def interval_label(row):
    if row['interval_high']<BAND[0]:return 'wholly_faster_than_band'
    if row['interval_low']>BAND[1]:return 'wholly_slower_than_band'
    if row['interval_low']>=BAND[0]and row['interval_high']<=BAND[1]:return 'wholly_inside_band'
    return 'crosses_band_boundary'


def classify(by_seed):
    need(set(by_seed)==set(PLAN.SEEDS),'Both prespecified input seeds required')
    controls=[by_seed[seed][name]for seed in PLAN.SEEDS for name in NEGATIVE]
    policies=[by_seed[seed][name]for seed in PLAN.SEEDS for name in POLICY]
    negative_inside=all(interval_label(row)=='wholly_inside_band'for row in controls)
    if all(interval_label(row)=='wholly_faster_than_band'for row in policies):pattern='all_policy_intervals_faster'
    elif all(interval_label(row)=='wholly_slower_than_band'for row in policies):pattern='all_policy_intervals_slower'
    elif all(interval_label(row)=='wholly_inside_band'for row in policies):pattern='all_policy_intervals_inside'
    else:pattern='mixed_policy_intervals'
    if not negative_inside:decision='unresolved_negative_controls'
    elif pattern=='all_policy_intervals_faster':decision='consistently_faster'
    elif pattern=='all_policy_intervals_slower':decision='consistently_slower'
    elif pattern=='all_policy_intervals_inside':decision='practically_within_band'
    else:decision='unresolved_policy_intervals'
    return dict(negative_controls_inside=negative_inside,policy_interval_pattern=pattern,classification=decision)


def calculate(rows,draws):
    paired=[];cycles=[];samples=[];arms=[];grouped={}
    for case,row in zip(PLAN.ledger(),rows,strict=True):
        base={key:case[key]for key in ('case_index','language','family','scenario','requested','seed','bytes','batch_n','history_n','hotspot')}
        base['scenario_name']=case['name'];base['active_gate']=case['batch_n']<=65536 and case['bytes']<=262144
        for contract in case['contracts']:
            context=dict(base,contract=contract);group=tuple(context[k]for k in AXES)
            seed_group=grouped.setdefault(group,{}).setdefault(case['seed'],{})
            for arm in PLAN.ARMS:
                values=row['arms'][arm][contract+'_ns']
                entry=dict(context,arm=arm,median_ns=statistics.median(values),min_ns=min(values),max_ns=max(values),median_ns_per_new_hash=statistics.median(values)/case['batch_n'],trials_ns=json.dumps(values,separators=(',',':')))
                entry.update({k:row['arms'][arm][k]for k in ('effective','workers','scratch_bytes','spawned_per_pass')})
                setup=row['arms'][arm]['insert_prefill_setup_ns']
                entry.update(prefill_setup_median_ns=statistics.median(setup)if contract=='insert'else None,prefill_setup_trials_ns=json.dumps(setup,separators=(',',':'))if contract=='insert'else None)
                arms.append(entry)
                for repeat,value in enumerate(values):
                    order=PLAN.arm_order(repeat);position=order.index(arm)
                    samples.append(dict(context,arm=arm,repeat=repeat,cycle=repeat//4,position=position,predecessor=order[position-1]if position else None,absolute_ns=value))
            for numerator,denominator in CONTRASTS:
                a=row['arms'][numerator][contract+'_ns'];b=row['arms'][denominator][contract+'_ns'];stats,block_logs,trial_logs=estimate(a,b,draws)
                name=numerator+'/'+denominator;entry=dict(context,contrast=name,numerator=numerator,denominator=denominator,**stats)
                entry.update(interval_class=interval_label(entry),point_outcome='numerator_slower'if stats['latency_ratio']>1 else'numerator_faster'if stats['latency_ratio']<1 else'tie')
                paired.append(entry);seed_group[name]=entry
                for cycle,value in enumerate(block_logs):
                    cycles.append(dict(context,contrast=name,cycle=cycle,mean_log_ratio=value,latency_ratio=math.exp(value),
                                       trial_latency_ratios=json.dumps([math.exp(x)for x in trial_logs[cycle*4:cycle*4+4]],separators=(',',':'))))
    matched=[];decisions=[]
    for group,by_seed in grouped.items():
        context=dict(zip(AXES,group,strict=True));reference=by_seed[PLAN.SEEDS[0]]['A1/A0']
        context.update(scenario_name=reference['scenario_name'],bytes=reference['bytes'],batch_n=reference['batch_n'],history_n=reference['history_n'],active_gate=reference['active_gate'])
        verdict=dict(context,**classify(by_seed));decisions.append(verdict)
        for numerator,denominator in CONTRASTS:
            name=numerator+'/'+denominator;item=dict(context,contrast=name)
            for seed in PLAN.SEEDS:
                row=by_seed[seed][name]
                for key in ('latency_ratio','interval_low','interval_high','interval_class','point_outcome'):item[f'seed{seed}_{key}']=row[key]
            matched.append(item)
    need((len(paired),len(cycles),len(samples),len(arms),len(matched),len(decisions))==(432,3456,9216,288,216,36),'Wrong prespecified products')
    return dict(contrasts=paired,cycles=cycles,samples=samples,arm_metrics=arms,matched_seeds=matched,decisions=decisions,
                individual_slower=[x for x in paired if x['point_outcome']=='numerator_slower'])


def report(products):
    decisions=products['decisions'];labels={label:sum(x['classification']==label for x in decisions)for label in ('consistently_faster','consistently_slower','practically_within_band','unresolved_negative_controls','unresolved_policy_intervals')}
    text=['# Fixed four-arm native build-policy confirmation','',
      'All40 processes/72 contracts completed under the frozen same-process native C++/Rust caller. The prescribed analysis retains432 individual contrasts,3,456 cycle records,9,216 original trial values and36 matched two-seed contracts. There is no pooling across language, family, scenario, contract or seed. Query performance, external leadership and cross-language speed are outside scope.','',
      'Every ratio is numerator latency / denominator latency; values above1 mean slower. The engineering band is[0.97,1.03]. Pointwise intervals resample only eight complete Williams cycles under the fixed10,000-draw bootstrap. These intervals depend on representativeness/independence assumptions, are not familywise guarantees, and cannot prove absence of a small effect. All contrasts reuse the same observed A samples and index draws; they are not independent experiments.','',
      'Prespecified classifications: '+', '.join(f'{key}={value}'for key,value in labels.items())+'.','',
      'A policy classification is permitted only when all three negative-control full intervals are inside the engineering band at both seeds. A large observed active-gate gain can therefore coexist with an unresolved classification if the negative controls are unstable. The policy interval pattern remains visible below. No default integration follows from unexplained offsets.','',
      '|Language / family|Scenario / contract|Gate|Negative controls inside both seeds|Policy interval pattern|Classification|','|---|---|---|---|---|---|']
    for row in decisions:text.append(f"|{row['language']} / {row['family']}|{row['scenario']} {row['scenario_name']} / {row['contract']}|{'active'if row['active_gate']else'outside'}|{row['negative_controls_inside']}|{row['policy_interval_pattern']}|{row['classification']}|")
    text+=['','The two targets were fixed before these data: C++ Split64 scenario1/T4 insert and Rust Split64 scenario1/T8 allocation+insert. Their individual controls and intervals are retained without replacing the other34 contracts:','',
           '|Target|Contrast|Seed2694173 ratio [interval]|Seed3819257 ratio [interval]|','|---|---|---:|---:|']
    for row in products['matched_seeds']:
        if row['family']=='Split64'and row['scenario']==1 and ((row['language']=='cpp'and row['contract']=='insert')or(row['language']=='rust'and row['contract']=='allocate_insert')):
            values=[]
            for seed in PLAN.SEEDS:values.append(f"{row[f'seed{seed}_latency_ratio']:.6f} [{row[f'seed{seed}_interval_low']:.6f}, {row[f'seed{seed}_interval_high']:.6f}]")
            text.append(f"|{row['language']} {row['contract']}|{row['contrast']}|{values[0]}|{values[1]}|")
    text+=['','All individual point-slower outcomes remain in `individual_slower.csv`; all gains/ties/intervals remain in `contrasts.csv` and `matched_seeds.csv`. An interval crossing the band is unresolved, not an asserted deterministic regression. `arm_metrics.csv` retains every absolute timing vector, while `samples.csv` retains chronological cycle/position/predecessor context. Samples are references to the same raw arm observations, not additional independent data.','',
           'The two fresh input seeds reverse the20-cell process order, but this is still one session and machine. Every Williams block balances absolute arm positions and within-row predecessor pairs; cross-row/process carryover is not claimed balanced. Clone and Before have distinct measured function addresses in this binary; that fact alone does not identify the cause of an observed difference. The same unchanged native policy is evaluated throughout, with no threshold/sample extension.']
    return '\n'.join(text)+'\n',labels


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--output',type=Path,required=True);args=parser.parse_args()
    need(not args.output.exists()and not args.output.is_symlink(),'Preserve prior analysis products')
    rows=load();draws=resampling();products=calculate(rows,draws);args.output.mkdir(parents=True)
    for name,records in products.items():(args.output/(name+'.csv')).write_text(csv_text(records,list(products['contrasts'][0])if name=='individual_slower'else None))
    narrative,labels=report(products);(args.output/'REPORT.md').write_text(narrative)
    dump(args.output/'summary.json',dict(raw_commit=RAW_COMMIT,source_commit=SOURCE,raw_manifest_sha256=RAW_MANIFEST_SHA,
        counts={k:len(v)for k,v in products.items()},classification_counts=labels,engineering_latency_band=list(BAND),
        bootstrap=dict(seed=SEED,draws=DRAWS,cycles=8,index_matrix_sha256=hashlib.sha256(json.dumps(draws,separators=(',',':')).encode()).hexdigest(),shared_across_contrasts_and_cases=True),
        all_cells_retained=True,prior_latency_import=False,compiler_or_filter_executed=False))
    print('PASS audited40/72;432 contrasts,36 two-seed decisions; all originals and outcomes retained')
if __name__=='__main__':main()
