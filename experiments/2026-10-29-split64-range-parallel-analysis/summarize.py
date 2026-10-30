#!/usr/bin/env python3
"""Offline T8 shared-query analysis; strict pointwise quality, no pooled negatives."""
import sys
if not __debug__:raise SystemExit('Python -O is forbidden')
import argparse
import csv
import hashlib
import json
import math
import subprocess
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
PRODUCER=ROOT/'experiments/2026-10-29-split64-range-parallel-screen'
SOURCE_COMMIT='35c97d584b600fdd71e6c086459433a53d4e567a'
RAW_COMMIT='3cbe13263153135a1fe2e86cacf688016cd782ca'
RAW_ARCHIVE_SHA='99addd9db1ebaa332e8307b4c014d08d243320f857186162a8b81778424bf2c4'
sys.path.insert(0,str(PRODUCER/'screening'))
from audit import load_complete
from source_guard import sha, require

OWNERS=('external','production_native','project_experiment')
QUERY=('parallel_lookup_gated_ns','parallel_lookup_end_to_end_ns','parallel_hash_lookup_gated_ns','parallel_hash_lookup_end_to_end_ns')
BUILD=('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns')
CAPS=(16,24,32)
TARGETS=(0.01,0.001,0.0001)
RANGE='Split64RangeNative'


def wilson(fp,count):
    require(type(fp) is int and type(count) is int and count>0 and 0<=fp<=count,'Invalid calibration count')
    z=1.959963984540054;p=fp/count;d=1+z*z/count
    center=(p+z*z/(2*count))/d
    width=z*math.sqrt(p*(1-p)/count+z*z/(4*count*count))/d
    return (0.0 if fp==0 else max(0.0,center-width)),(1.0 if fp==count else min(1.0,center+width))


def finite(value):
    result=float(value)
    return result if math.isfinite(result) else None


def load():
    manifest=PRODUCER/'SCREEN_RESULTS_ARCHIVE.json'
    require(sha(manifest)==RAW_ARCHIVE_SHA,'Changed sealed raw manifest')
    committed=subprocess.check_output(['git','show',RAW_COMMIT+':'+str(manifest.relative_to(ROOT))],cwd=ROOT)
    require(hashlib.sha256(committed).hexdigest()==RAW_ARCHIVE_SHA,'Raw manifest is not the exact committed blob')
    archive=json.loads(manifest.read_text())
    require(archive['source_commit']==SOURCE_COMMIT and len(archive['files'])==30,'Wrong sealed raw ownership')
    for rel,info in archive['files'].items():
        file=PRODUCER/rel
        require(file.stat().st_size==info['bytes'] and sha(file)==info['sha256'],'Changed raw evidence '+rel)
        committed=subprocess.check_output(['git','show',RAW_COMMIT+':'+str(file.relative_to(ROOT))],cwd=ROOT)
        require(hashlib.sha256(committed).hexdigest()==info['sha256'],'Raw file is not the exact committed blob: '+rel)
    rows,validation=load_complete(SOURCE_COMMIT)
    require(validation==dict(rows=142,cases=13,calibration_records=92,pooled=False),'Wrong audited cardinalities')
    return rows


def quality_records(rows):
    records={}
    for row in rows:
        sample=row['calibration_identity']; fp=int(row['calibration_false_positives']);count=int(row['calibration_absent_queries'])
        identity=(int(row['keys']),int(row['filter_bytes']),fp,count,int(row['result_checksum']),int(row['false_positives']))
        if sample in records:
            require(records[sample]['identity']==identity,'Conflicting duplicate calibration mapping')
        else:
            lower,upper=wilson(fp,count)
            records[sample]=dict(calibration_identity=sample,identity=identity,keys=int(row['keys']),filter_bytes=int(row['filter_bytes']),
              calibration_false_positives=fp,calibration_absent_queries=count,calibration_fpr=fp/count,wilson95_lower=lower,wilson95_upper=upper,
              configuration_ids=[],filters=[],pooled=False)
        records[sample]['configuration_ids'].append(row['configuration_id']);records[sample]['filters'].append(row['filter'])
    return records


def usable(row,cap,target,metric,quality):
    return (int(row['filter_bytes'])<=int(row['keys'])*cap//8 and quality[row['calibration_identity']]['wilson95_upper']<=target
            and finite(row[metric]) is not None)


def best(rows,owner,cap,target,metric,quality):
    candidates=[r for r in rows if r['implementation_origin']==owner and usable(r,cap,target,metric,quality)]
    return min(candidates,key=lambda r:(float(r[metric]),r['configuration_id'])) if candidates else None


def ratio(a,b):
    return a/b if a is not None and b is not None else None


def named(prefix,row,metric,quality):
    return {prefix+'_'+field:value for field,value in dict(filter=None if row is None else row['filter'],
      configuration_id=None if row is None else row['configuration_id'],filter_bytes=None if row is None else int(row['filter_bytes']),
      actual_bpk=None if row is None else float(row['actual_bpk']),ns=None if row is None else float(row[metric]),
      wilson95_upper=None if row is None else quality[row['calibration_identity']]['wilson95_upper']).items()}


def views(rows,quality,metrics):
    ranking=[];alternatives=[]
    for n in sorted({int(r['keys']) for r in rows}):
        sized=[r for r in rows if int(r['keys'])==n]
        for cap in CAPS:
            for target in TARGETS:
                for metric in metrics:
                    base=dict(keys=n,cap_bpk=cap,target_fpr=target,metric=metric,threads=8)
                    leaders={owner:best(sized,owner,cap,target,metric,quality) for owner in OWNERS}
                    record=dict(base)
                    for owner,row in leaders.items():record.update(named(owner,row,metric,quality))
                    external=record['external_ns'];production=record['production_native_ns'];candidate=record['project_experiment_ns']
                    record.update(external_over_production=ratio(external,production),external_over_range=ratio(external,candidate),
                                  production_over_range=ratio(production,candidate))
                    ranking.append(record)
                    for row in sized:
                        q=quality[row['calibration_identity']];value=finite(row[metric]);eligible=usable(row,cap,target,metric,quality)
                        alternatives.append(dict(base,filter=row['filter'],configuration_id=row['configuration_id'],calibration_identity=row['calibration_identity'],
                          owner=row['implementation_origin'],requested_bpk=int(row['requested_bpk']),filter_bytes=int(row['filter_bytes']),actual_bpk=float(row['actual_bpk']),
                          fits_cap=int(row['filter_bytes'])<=n*cap//8,quality_pass=q['wilson95_upper']<=target,metric_available=value is not None,eligible=eligible,
                          ns=value,wilson95_upper=q['wilson95_upper'],external_id=record['external_configuration_id'],external_ns=external,
                          external_over_candidate=ratio(external,value) if eligible else None,
                          production_id=record['production_native_configuration_id'],production_ns=production,
                          production_over_candidate=ratio(production,value) if eligible else None))
    return ranking,alternatives


def scaling(rows,quality):
    result=[]
    for row in rows:
        for metric in QUERY:
            serial_metric='hash_lookup_ns' if metric.startswith('parallel_hash') else 'lookup_ns'
            serial=finite(row[serial_metric]);parallel=finite(row[metric])
            result.append(dict(filter=row['filter'],owner=row['implementation_origin'],configuration_id=row['configuration_id'],calibration_identity=row['calibration_identity'],
               keys=int(row['keys']),filter_bytes=int(row['filter_bytes']),actual_bpk=float(row['actual_bpk']),threads=8,metric=metric,
               serial_metric=serial_metric,serial_ns=serial,parallel_ns=parallel,serial_over_parallel=ratio(serial,parallel),
               wilson95_upper=quality[row['calibration_identity']]['wilson95_upper']))
    return result


def equal_capacity(rows,quality):
    pairs=[]
    for candidate in rows:
        if candidate['filter']!=RANGE:continue
        for peer in rows:
            if peer['filter']==RANGE or peer['keys']!=candidate['keys'] or peer['filter_bytes']!=candidate['filter_bytes']:continue
            for metric in QUERY+BUILD:
                a=finite(peer[metric]);b=finite(candidate[metric])
                pairs.append(dict(keys=int(candidate['keys']),filter_bytes=int(candidate['filter_bytes']),metric=metric,
                  range_id=candidate['configuration_id'],peer=peer['filter'],peer_owner=peer['implementation_origin'],peer_id=peer['configuration_id'],
                  mapping_alias=peer['calibration_identity']==candidate['calibration_identity'],range_ns=b,peer_ns=a,peer_over_range=ratio(a,b),
                  range_wilson95_upper=quality[candidate['calibration_identity']]['wilson95_upper'],peer_wilson95_upper=quality[peer['calibration_identity']]['wilson95_upper']))
    return pairs


def outcomes(records,key):
    values=[r[key] for r in records if r[key] is not None]
    return dict(available=len(values),wins=sum(v>1 for v in values),ties=sum(v==1 for v in values),losses=sum(v<1 for v in values),
                minimum=min(values) if values else None,maximum=max(values) if values else None)


def analyze(rows):
    require(len(rows)==142 and len({r['configuration_id'] for r in rows})==142,'Expected unique142 APIs/geometries')
    require(set(r['implementation_origin'] for r in rows)==set(OWNERS),'Changed ownership classes')
    quality=quality_records(rows);require(len(quality)==92,'Wrong92 unpooled calibration records')
    query,qa=views(rows,quality,QUERY);build,ba=views(rows,quality,BUILD);scales=scaling(rows,quality);pairs=equal_capacity(rows,quality)
    require(len(query)==len(build)==72 and len(qa)==len(ba)==5112 and len(scales)==568,'Wrong nested view cardinalities')
    range_alts=[r for r in qa if r['filter']==RANGE]
    require(len(range_alts)==216,'Wrong all216 Range alternatives')
    loss=[r for r in qa if r['owner']!='external' and r['external_over_candidate'] is not None and r['external_over_candidate']<1]
    summary=dict(scope='Initial fixed142 T8 training screen; one seed42, fixed within-trial phase order, no held-out inference',
      source_commit=SOURCE_COMMIT,raw_commit=RAW_COMMIT,raw_manifest_sha256=RAW_ARCHIVE_SHA,rows=142,query_views=len(query),query_alternatives=len(qa),range_query_alternatives=len(range_alts),
      build_views=len(build),build_alternatives=len(ba),serial_scaling_rows=len(scales),equal_capacity_pairs=len(pairs),quality_records=len(quality),pooled=False,
      query_range_vs_external=outcomes(query,'external_over_range'),query_production_vs_external=outcomes(query,'external_over_production'),
      query_range_vs_production=outcomes(query,'production_over_range'),build_range_vs_external=outcomes(build,'external_over_range'),
      native_query_losses=len(loss),range_query_losses=sum(r['filter']==RANGE for r in loss))
    for record in quality.values():record.pop('identity')
    return dict(summary=summary,quality=list(quality.values()),query_views=query,query_alternatives=qa,range_query_alternatives=range_alts,
                build_views=build,build_alternatives=ba,serial_scaling=scales,equal_capacity_pairs=pairs,native_query_losses=loss)


def write_csv(path,records):
    if not records:path.write_text('');return
    with path.open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=list(records[0]),lineterminator='\n');writer.writeheader()
        for row in records:
            writer.writerow({k:json.dumps(v,separators=(',',':')) if isinstance(v,(list,dict)) else v for k,v in row.items()})


def fmt(value):return '—' if value is None else f'{value:.3f}'


def report(data):
    summary=data['summary']
    niche=[r for r in data['query_views'] if r['cap_bpk']==24 and r['target_fpr']==0.0001]
    ratios=[r['external_over_range'] for r in niche]
    require(len(ratios)==8 and all(v is not None for v in ratios),'Missing strict24 niche views')
    niche_text=f"Range24 wins all eight current cap24/0.01% query comparisons, with external/Range ratios{min(ratios):.3f}–{max(ratios):.3f}. At small n the external leader is Fixed64; at large n it is Boost Multi64K8 at approximately24 actual bits/key. This identifies a narrow capacity/quality niche, not a general replacement."
    outcomes_text=f"Across64 quality-eligible nested views, the selected Range allocation wins{summary['query_range_vs_external']['wins']} and loses{summary['query_range_vs_external']['losses']} against the fastest eligible external. Against eligible production natives it wins{summary['query_range_vs_production']['wins']} and loses{summary['query_range_vs_production']['losses']} across56 views. The best production native wins54/56 external comparisons; its two losses are large-n, cap32/0.01% hash gated/end-to-end, where Range24 is faster. These counts reuse configurations across caps and must not be treated as independent trials."
    lines=['# Initial eight-core exact-capacity screen','',
      'All142 configurations completed and the frozen raw/aggregate, command, placement and source/binary audit passed. This is a single-seed training comparison on eight physical cores of socket1/node1, using one serially built shared bitmap. It is not a held-out or order-independent superiority claim.','',
      niche_text,'',outcomes_text,'',
      'Ratios below are strongest eligible external time / project time: values above1 favor the project. Every cap admits selected smaller actual allocations, including the fixed extra external geometries. Each of the four metrics chooses its own eligible external and native leader.','',
      '| Keys | Cap bpk | FPR limit | Metric | External leader (actual bpk) | Best production (ratio) | Range actual bpk (ratio) |',
      '|---:|---:|---:|---|---|---|---|']
    for r in data['query_views']:
        ext='—' if r['external_filter'] is None else f"{r['external_filter']} ({r['external_actual_bpk']:.6g})"
        prod='—' if r['production_native_filter'] is None else f"{r['production_native_filter']} ({fmt(r['external_over_production'])})"
        candidate='—' if r['project_experiment_filter'] is None else f"{r['project_experiment_actual_bpk']:.6g} ({fmt(r['external_over_range'])})"
        lines.append(f"| {r['keys']} | {r['cap_bpk']} | {100*r['target_fpr']:.3g}% | {r['metric'].replace('parallel_','').replace('_ns','')} | {ext} | {prod} | {candidate} |")
    lines+=['','These72 nested views reuse measurements and are not72 independent statistical tests. `query-alternatives.csv` retains all5112 allocation alternatives, including over-cap, unavailable and quality-failing records; all216 Range alternatives and every eligible native loss are retained separately. Exact ties are reported as ties.','',
      'Quality consists of92 mapping/geometry/size/seed records. Alias APIs reuse their original2^24 calibration denominator, never pool it. Each gate uses the pointwise two-sided Wilson95 upper; timed mixed-query negatives are separate. A failed upper-bound gate is not proof that the true FPR exceeds its limit. Historical FourSector intervals do not override current qualification.','',
      '| Range keys | Actual bpk | Calibration FP / probes | Wilson95 upper |',
      '|---:|---:|---:|---:|']
    for r in data['quality']:
        if RANGE in r['filters']:
            lines.append(f"| {r['keys']} | {8*r['filter_bytes']/r['keys']:.6g} | {r['calibration_false_positives']} / {r['calibration_absent_queries']} | {100*r['wilson95_upper']:.6f}% |")
    lines+=['','The current FourSector16 calibration at n=2^25 has16563 false positives/16777216 and Wilson95 upper0.10023738%, so it is ineligible for0.1% in this screen. The smaller n FourSector16 upper is0.09710818%. This is a pointwise resolution gate, not proof of a true-FPR violation or a reversal of separate higher-resolution historical evidence.','',
      'Range24 same-row serial/gated ratios are7.71–8.31x at small n and7.84–8.08x at large n; including launch/join reduces them to6.21–7.05x and7.26–7.44x respectively. These are descriptive observed ratios under the fixed phase order, not an architectural scaling law.','',
      'The stronger-external serial-build comparison is unfavorable overall: Range wins6/64 eligible nested build views and loses58. Against the exactly matching Fixed64 bitmap/API control at equal bytes, Range wins all24 query and24 serial-build pairs. These distinct comparisons are both retained rather than crediting a mapping-equivalent control win as overall leadership.']
    lines+=['','`serial-scaling.csv` contains568 same-row serial/parallel comparisons, including unavailable raw-only pure entries. Gated time includes wake-up and completion synchronization. End-to-end additionally includes thread creation, affinity, joins and executor temporary destruction. Caller0 counts toward T8; only seven threads are spawned. A scaling ratio does not establish leadership over another filter.','',
      '`build-views.csv` and `build-alternatives.csv` keep all four serial medians separate: pure insert, allocation+insert, hash+insert and allocation+hash+insert. These measurements support no parallel-build claim. `equal-capacity-pairs.csv` additionally preserves every Range/other-API equal-byte pair across all eight query/build metrics, with quality and mapping-alias status.','',
      'The query phase order is fixed serial pure → serial common-hash → parallel pure → parallel common-hash. Six repetitions do not balance that order. Each process filters the source registry then shuffles it once using seed42; case groups run in ascending n/ceiling order. All variants share the same compiler/ISA, byte ceiling, raw input, common hash and full-output checks. Backing-byte budgets exclude object/allocator metadata and separately reported scratch.','',
      'No production promotion follows this training screen. Fresh seeds and order controls are required before a broader superiority claim.','']
    return '\n'.join(lines)


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,default=HERE/'report');args=parser.parse_args()
    require(not args.output.exists(),'Do not overwrite an existing analysis attempt')
    rows=load();data=analyze(rows);args.output.mkdir()
    (args.output/'summary.json').write_text(json.dumps(data['summary'],indent=2)+'\n')
    for key,value in data.items():
        if key!='summary':write_csv(args.output/(key.replace('_','-')+'.csv'),value)
    (args.output/'REPORT.md').write_text(report(data))
    print(json.dumps(data['summary'],indent=2))

if __name__=='__main__':main()
