#!/usr/bin/env python3
"""Summarize paired-seed ratios, retaining every batch and regression."""
import argparse,csv,statistics
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('input',type=Path);p.add_argument('output',type=Path);a=p.parse_args()
rows=list(csv.DictReader(a.input.open()))
keys=lambda r:tuple(int(r[k]) for k in ['keys','requested_bpk','batch'])
summary=[]
for scenario in sorted({keys(r) for r in rows}):
 rr=[r for r in rows if keys(r)==scenario]
 old={int(r['seed']):r for r in rr if r['filter']=='FastPatternBefore'}
 for variant in sorted({r['filter'] for r in rr}-{'FastPatternBefore'}):
  after={int(r['seed']):r for r in rr if r['filter']==variant}
  assert old.keys()==after.keys()
  row=dict(zip(['keys','requested_bpk','batch'],scenario));row['variant']=variant;row['seeds']=len(old)
  for metric in ['lookup_ns','hash_lookup_ns']:
   ratios=[float(old[s][metric])/float(after[s][metric]) for s in old]
   row['before_'+metric]=statistics.median(float(r[metric]) for r in old.values())
   row['after_'+metric]=statistics.median(float(r[metric]) for r in after.values())
   row[metric+'_speedup']=statistics.median(ratios)
   row[metric+'_speedup_min']=min(ratios);row[metric+'_speedup_max']=max(ratios)
  summary.append(row)
with a.output.open('w',newline='') as f:
 w=csv.DictWriter(f,fieldnames=list(summary[0]),lineterminator='\n');w.writeheader();w.writerows(summary)
print(f'{len(summary)} scenario/variant summaries written; no regressions excluded')
