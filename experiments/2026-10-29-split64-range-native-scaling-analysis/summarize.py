#!/usr/bin/env python3
"""Separate complete native60 analysis; no partial-result or cross-language ranking."""
import sys
if not __debug__:raise SystemExit('Python -O is forbidden before loading data')
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import re
import statistics
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
PRODUCER=ROOT/'experiments/2026-10-29-split64-range-native-scaling'
SOURCE_COMMIT='0129cbdb116bdf56be1c6ab0ba5a973c495d07c2'
sys.path.insert(0,str(PRODUCER/'screening'))
from audit import load_complete
from contract import METRICS,need
from source_guard import sha

PAIRS=(('insert','serial_insert','parallel_insert'),('allocate_insert','serial_allocate_insert','parallel_allocate_insert'),('lookup','serial_lookup','parallel_lookup'))
IDENTITY=('language','filter','keys','requested_bpk')

def key(row):return tuple(row[k]for k in IDENTITY)+(row['core_budget'],)
def wilson(fp,count):
    need(count>0 and 0<=fp<=count,'Invalid quality counts');z=1.959963984540054;p=fp/count;denom=1+z*z/count
    center=(p+z*z/(2*count))/denom;half=z*math.sqrt(p*(1-p)/count+z*z/(4*count*count))/denom
    return 0.0 if fp==0 else max(0.0,center-half),1.0 if fp==count else min(1.0,center+half)

def quality_records(rows):
    grouped={}
    for row in rows:grouped.setdefault(tuple(row[k]for k in IDENTITY)+(row['seed'],),[]).append(row)
    records=[]
    for identity,group in sorted(grouped.items()):
        need(len(group)==3 and sorted(int(r['core_budget'])for r in group)==[1,4,8],'Wrong repeated quality coverage')
        row=group[0]
        for other in group[1:]:
            for field in ('filter_bytes','calibration_absent_queries','calibration_false_positives','false_positives','result_checksum','key_base'):
                need(other[field]==row[field],'Calibration or bitmap changed across T')
        count,fp=int(row['calibration_absent_queries']),int(row['calibration_false_positives']);low,high=wilson(fp,count)
        records.append(dict(zip(IDENTITY+('seed',),identity))|dict(filter_bytes=int(row['filter_bytes']),calibration_count=count,calibration_fp=fp,
          observed_fpr=fp/count,wilson95_lower=low,wilson95_upper=high,passes_1pct=high<=.01,passes_0_1pct=high<=.001,passes_0_01pct=high<=.0001,
          reused_T_rows=3,pooled=False))
    need(len(records)==20,'Wrong20 language-specific quality records')
    return records

def ratio_record(row,kind,baseline_metric,target_metric,baseline=None):
    reference=row if baseline is None else baseline
    base=float(reference[baseline_metric+'_ns']);target=float(row[target_metric+'_ns']);ratio=base/target
    return {k:row[k]for k in IDENTITY}|dict(core_budget=int(row['core_budget']),filter_bytes=int(row['filter_bytes']),seed=int(row['seed']),
      build_workers=int(row['build_workers']),query_workers=int(row['query_workers']),estimated_build_scratch_bytes=int(row['estimated_build_scratch_bytes']),
      comparison=kind,baseline_metric=baseline_metric,target_metric=target_metric,baseline_ns=base,target_ns=target,speedup=ratio,
      result='win'if ratio>1 else'loss'if ratio<1 else'tie',baseline_trials=reference[baseline_metric+'_trials_ns'],target_trials=row[target_metric+'_trials_ns'])

def analyze(rows):
    need(len(rows)==60,'Only completed60 data may be analyzed');indexed={key(r):r for r in rows};need(len(indexed)==60,'Duplicate native geometry/T')
    quality=quality_records(rows);same=[];t1=[];equal=[];timings=[]
    for row in rows:
        base=indexed[tuple(row[k]for k in IDENTITY)+('1',)]
        for kind,serial,parallel in PAIRS:
            same.append(ratio_record(row,'same_row_'+kind,serial,parallel))
            if row['core_budget']!='1':t1.append(ratio_record(row,'same_public_T1_to_T_'+kind,parallel,parallel,base))
        for metric in METRICS:
            timings.append({k:row[k]for k in IDENTITY}|dict(core_budget=int(row['core_budget']),metric=metric,
              filter_bytes=int(row['filter_bytes']),ns=float(row[metric+'_ns']),min_ns=float(row[metric+'_min_ns']),max_ns=float(row[metric+'_max_ns']),trials_ns=row[metric+'_trials_ns']))
        if row['filter']=='Split64Range'and row['requested_bpk']in ('16','32'):
            control=indexed[(row['language'],'Split64',row['keys'],row['requested_bpk'],row['core_budget'])]
            need(control['filter_bytes']==row['filter_bytes'],'Unequal allocations in same-byte comparison')
            for metric in METRICS:
                equal.append(ratio_record(row,'equal_bytes_Range_vs_Split',metric,metric,control)|dict(baseline_filter='Split64',target_filter='Split64Range'))
    need((len(same),len(t1),len(equal),len(timings))==(180,120,144,360),'Wrong complete comparison cardinalities')
    groups={}
    for source,records in (('same_row',same),('T1',t1),('equal_bytes',equal)):
        for record in records:
            # Descriptive only; keep languages, metric boundaries and T separate.
            group=(source,record['language'],record['filter'],record['comparison'],record['target_metric'],record['core_budget'])
            groups.setdefault(group,[]).append(record)
    grouped=[]
    for group,records in sorted(groups.items()):
        ratios=[r['speedup']for r in records]
        grouped.append(dict(zip(('source','language','filter','comparison','metric','core_budget'),group))|dict(pairs=len(records),
          wins=sum(r>1 for r in ratios),losses=sum(r<1 for r in ratios),ties=sum(r==1 for r in ratios),minimum=min(ratios),
          median=statistics.median(ratios),maximum=max(ratios),geomean=math.exp(sum(map(math.log,ratios))/len(ratios))))
    losses=[]
    for source,records in (('same_row',same),('T1',t1),('equal_bytes',equal)):
        for row in records:
            if row['speedup']<1:
                losses.append(dict(source=source,**row)|dict(baseline_filter=row.get('baseline_filter',row['filter']),target_filter=row.get('target_filter',row['filter'])))
    return dict(quality=quality,same_row=same,T1=t1,equal_bytes=equal,timings=timings,groups=grouped,losses=losses)

def load_verified(raw_commit):
    need(re.fullmatch('[0-9a-f]{40}',raw_commit),'Exact committed raw archive revision required')
    rows,metadata,coverage=load_complete(live=False)
    need(metadata['source_commit']==SOURCE_COMMIT,'Wrong measured producer revision')
    expected={'metadata.json','results.csv','root-verification.txt'}|{r[s]for r in metadata['commands']for s in ('stdout','stderr')}
    observed={p.name for p in (PRODUCER/'screen').iterdir()if p.is_file()}
    need(expected==observed and len(expected)==75,'Unexpected raw archive inventory')
    archive_path=PRODUCER/'SCREEN_ARCHIVE.json';archive=json.loads(archive_path.read_text())['files']
    need(set(archive)=={'screen/'+name for name in expected},'Wrong committed raw manifest inventory')
    archive_blob=subprocess.check_output(['git','show',raw_commit+':'+str(archive_path.relative_to(ROOT))],cwd=ROOT)
    need(hashlib.sha256(archive_blob).hexdigest()==sha(archive_path),'Changed committed raw archive manifest')
    for name in sorted(expected):
        path=PRODUCER/'screen'/name;rel=str(path.relative_to(ROOT));blob=subprocess.check_output(['git','show',raw_commit+':'+rel],cwd=ROOT)
        need(sha(path)==archive['screen/'+name]['sha256']and path.stat().st_size==archive['screen/'+name]['bytes'],'Changed raw manifest artifact '+name)
        need(hashlib.sha256(blob).hexdigest()==sha(path),'Raw file differs from committed blob '+name)
    return rows,metadata,coverage

def write_csv(path,rows):
    if not rows:
        path.write_text('source,language,filter,comparison,speedup,result\n');return
    with path.open('w',newline='')as f:
        writer=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)

def report(data,raw_commit):
    lines=['# Native public-API scaling screen','',
      f'Complete60-row source `{SOURCE_COMMIT}`; raw archive `{raw_commit}`. This is one seed42 training screen on one host.',
      'The complete grid inserts2^16 or2^25 keys, queries2^22 prehashed64 keys at50% hits, uses actual16/24/32 bits per key and T1/4/8 allowed physical cores. Split64 has16/32-bpk controls; Range has16/24/32. Each row has four repetitions per interval and an independent2^24-negative calibration stream.',
      'C++ and Rust are reported separately. All comparisons retain fresh native thread startup, partition passes and scratch costs. No cross-language leadership claim is made.','',
      'At33,554,432 keys and T8, allocate+build gains2.18–2.61× and whole-array query gains6.83–7.81× across the ten language/geometry configurations. At65,536 keys, all ten T8 build configurations lose. Extra partitioning and thread startup are plausible contributors, but their costs are not separately measured here. Queries still gain6.09–7.00× because each query call contains4,194,304 keys, independently of the filter’s construction size.','',
      '| Language | Inserted keys | T8 insert ratio | T8 allocate+build ratio | T8 query ratio |',
      '|---|---:|---:|---:|---:|']
    for language in ('cpp','rust'):
        for n in (1<<16,1<<25):
            ranges=[]
            for metric in ('parallel_insert','parallel_allocate_insert','parallel_lookup'):
                ratios=[r['speedup']for r in data['same_row']if r['language']==language and int(r['keys'])==n and r['core_budget']==8 and r['target_metric']==metric]
                need(len(ratios)==5,'Wrong fixed five-geometry report group');ranges.append(f'{min(ratios):.3f}–{max(ratios):.3f}')
            lines.append(f"| {language} | {n:,} | {' | '.join(ranges)} |")
    lines+=['',
      'The primary ratios divide each row’s own serial median by its parallel median. Separate T1 ratios compare the same public parallel API at T1 and T4/T8; they are supplemental because workload groups execute at different times. Insert-only, allocate+insert and query are separate intervals. Four build repetitions use one balanced Williams cycle; queries alternate AB/BA. Cases and languages have fixed order, and all build trials precede queries.','',
      '## Same-row serial/parallel ratios','',
      'Each summary row below combines both input sizes and every measured capacity for that family. Its median is a median of workload ratios, not the latency or speedup of any specific n; use the size-separated table above or full CSV for a concrete workload.','',
      '| Language | Family | Interval | T | Wins | Losses | Ties | Minimum | Median | Maximum |',
      '|---|---|---|---:|---:|---:|---:|---:|---:|---:|']
    for row in data['groups']:
        if row['source']=='same_row':lines.append(f"| {row['language']} | {row['filter']} | {row['metric']} | {row['core_budget']} | {row['wins']} | {row['losses']} | {row['ties']} | {row['minimum']:.3f} | {row['median']:.3f} | {row['maximum']:.3f} |")
    lines+=['','Every ratio and every loss remains in the CSV tables. A ratio above1 means the target is faster. These nested descriptive counts are not independent statistical trials. T1 direct fallbacks are retained, including any measured overhead/noise.','',
      '## Large input scaling','',
      '![Large input native scaling](scaling-large.svg)','',
      'The four panels use each point’s own same-row serial control. They do not compare C++ speed with Rust speed. Each curve retains one fixed family/allocation, including all T1/T4/T8 points and any slowdown. The complete smaller input and loss records remain in the CSV tables.','',
      '## Memory, quality and scheduler contract','',
      'Twenty language/family/geometry records each retain the original2^24 calibration denominator. Repeated T rows are deduplicated, never pooled. Identical C++/Rust semantic outputs do not provide independent negative samples. Wilson95 bounds describe only each tested construction/input stream; quality thresholds are descriptive and do not filter any timing loss from this report.','',
      'Range16/32 and Split16/32 have144 equal-byte, same-language metric pairs. Range24 has no exact-byte production Split control in this grid; it is not silently compared as if16 or32 bytes were equal. Existing external benchmark latencies are not imported.','',
      'The caller is CPU3 for serial work. Native workers inherit firstT physical cores on node1 and may migrate or colocate inside that set. C++ uses caller+W−1 spawned workers; Rust uses W scoped workers plus a coordinator sharing the sameT core budget, except W1 direct fallback. Individual worker pinning is not claimed.','',
      'Insert-only bitmaps are constructed on CPU3 before affinity expansion. Inclusive allocate+build begins after expansion. Both include the full public insertion algorithm but differ in first touch as prespecified. Estimated explicit build scratch excludes allocator metadata, runtime handles/stacks and RSS. All inserted and mixed dense outputs are checked outside timing on every build, and every query trial checks complete output and guards.','',
      'The small-build loss motivates a bounded build-worker policy experiment, not a partition/kernel rewrite. Here65,536 inserted keys also meant a128–256KiB bitmap. The public API additionally permits a64K incremental batch into a much larger or already populated filter; these measurements do not justify blindly treating input batch length as constructor size. Future controls must vary both batch length and actual footprint, preserving query dispatch and the original public call.','',
      'Files: timings.csv360 metric records; same_row.csv180 ratios; T1.csv120 same-public-API ratios; equal_bytes.csv144 Range/Split pairs; quality.csv20 unpooled records; groups.csv descriptive summaries; losses.csv all individual regressions. No candidate is promoted by this sidecar.','']
    return '\n'.join(lines)

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--raw-commit',required=True);parser.add_argument('--output',type=Path,required=True);args=parser.parse_args()
    rows,metadata,coverage=load_verified(args.raw_commit);data=analyze(rows)
    need(not args.output.exists()and not args.output.is_symlink(),'Preserve previous reports');args.output.mkdir(parents=True)
    for name,records in data.items():write_csv(args.output/(name+'.csv'),records)
    from plot import plot_large
    plot_large(data['same_row'],args.output/'scaling-large.svg')
    summary=dict(source_commit=SOURCE_COMMIT,raw_commit=args.raw_commit,coverage=coverage,counts={k:len(v)for k,v in data.items()},
      no_cross_language_timing_ranking=True,no_calibration_pooling=True,screen_metadata_sha256=sha(PRODUCER/'screen/metadata.json'))
    (args.output/'summary.json').write_text(json.dumps(summary,indent=2,allow_nan=False)+'\n')
    (args.output/'REPORT.md').write_text(report(data,args.raw_commit));print(json.dumps(summary,sort_keys=True))

if __name__=='__main__':main()
