#!/usr/bin/env python3
"""Report complete-build effects and the instrumented P=W control separately."""
import csv
import json
from pathlib import Path
import statistics
import sys

path=Path(sys.argv[1])
rows=list(csv.DictReader(path.open()))
groups={}
for row in rows:
    key=tuple(row[k] for k in ('keys','filter_bytes','threads','seed'))
    groups.setdefault(key,{})[row['filter']]=row
cases=[]
for key,group in groups.items():
    for family in ('FastPattern','FourSector','Split64'):
        if family+'OriginalW' not in group:continue
        original,control=group[family+'OriginalW'],group[family+'InstrumentedW']
        for suffix in ('InstrumentedW','Cache256KiB','Cache512KiB','Cache1024KiB'):
            row=group[family+suffix]
            case={'family':family,'variant':suffix,'keys':int(key[0]),'filter_bytes':int(key[1]),'workers':int(key[2]),'seed':int(key[3]),
                  'partitions':int(row['partitions']),'target_bytes':int(row['target_bytes']),'scratch_bytes':int(row['build_scratch_bytes']),
                  'original_build_ns':float(original['insert_ns']),'control_build_ns':float(control['insert_ns']),'build_ns':float(row['insert_ns']),
                  'speedup_vs_original':float(original['insert_ns'])/float(row['insert_ns']),
                  'speedup_vs_control':float(control['insert_ns'])/float(row['insert_ns']),
                  'phases':{name:float(row[f'phase_{name}_ns']) for name in ('allocate','count','prefix','scatter','insert','release','total')}}
            cases.append(case)
summary=[]
for key in sorted({tuple(r[k] for k in ('family','variant','keys','filter_bytes','workers')) for r in cases}):
    selected=[r for r in cases if tuple(r[k] for k in ('family','variant','keys','filter_bytes','workers'))==key]
    r=dict(zip(('family','variant','keys','filter_bytes','workers'),key))
    r.update({'count':len(selected),'median_speedup_vs_original':statistics.median(x['speedup_vs_original'] for x in selected),
              'min_speedup_vs_original':min(x['speedup_vs_original'] for x in selected),'max_speedup_vs_original':max(x['speedup_vs_original'] for x in selected),
              'median_speedup_vs_control':statistics.median(x['speedup_vs_control'] for x in selected)})
    summary.append(r)
result={'metric':'Outer whole-build nanoseconds per key, including all scratch passes and release; phase medians are explanatory only.',
        'cases':cases,'summary':summary}
path.with_name('summary.json').write_text(json.dumps(result,indent=2)+'\n')
for family,n,bytes_,workers in sorted({(r['family'],r['keys'],r['filter_bytes'],r['workers']) for r in summary}):
    options=[r for r in summary if (r['family'],r['keys'],r['filter_bytes'],r['workers'])==(family,n,bytes_,workers) and r['variant']!='InstrumentedW']
    best=max(options,key=lambda r:r['median_speedup_vs_original'])
    control=next(r for r in summary if (r['family'],r['keys'],r['filter_bytes'],r['workers'])==(family,n,bytes_,workers) and r['variant']=='InstrumentedW')
    print(f"{family} n={n} bytes={bytes_} W={workers}: screen-best={best['variant']} {best['median_speedup_vs_original']:.3f}x vs actual original, {best['median_speedup_vs_control']:.3f}x vs instrumented; control={control['median_speedup_vs_original']:.3f}x")
