#!/usr/bin/env python3
"""Retain every native and external control, with paired-seed speedups."""
import argparse,csv,statistics
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('input',type=Path);p.add_argument('output',type=Path);a=p.parse_args()
rows=list(csv.DictReader(a.input.open()));groups={}
for row in rows:
 key=tuple(row[x] for x in ['keys','requested_bpk','batch']);groups.setdefault(key,{}).setdefault(row['filter'],{})[row['seed']]=row
controls={'ByteSplitBloomFilter':['ByteShortEntryV2','ByteShortEntryV3'],'Split64BloomFilter':['SplitShortEntryV2','SplitShortEntryV3'],'BloomsdayPinned':['BloomsdaySingleApiV1'],'Fastbloom017':['FastbloomSingleApiV1']}
result=[]
for key,by_name in sorted(groups.items(),key=lambda kv:tuple(map(int,kv[0]))):
 for original,variants in controls.items():
  if original not in by_name:continue
  base=by_name[original]
  for name in variants:
   if name not in by_name:continue
   current=by_name[name];assert base.keys()==current.keys()
   row=dict(zip(['keys','requested_bpk','batch'],key));row.update({'original':original,'candidate':name,'seeds':len(base)})
   for metric in ['lookup_ns','hash_lookup_ns','hash_insert_ns']:
    ratios=[float(base[s][metric])/float(current[s][metric]) for s in base]
    row['original_'+metric]=statistics.median(float(r[metric]) for r in base.values())
    row['candidate_'+metric]=statistics.median(float(r[metric]) for r in current.values())
    row[metric+'_speedup']=statistics.median(ratios)
    row[metric+'_speedup_min']=min(ratios);row[metric+'_speedup_max']=max(ratios)
   result.append(row)
with a.output.open('w',newline='') as f:
 w=csv.DictWriter(f,fieldnames=list(result[0]),lineterminator='\n');w.writeheader();w.writerows(result)
print(f'{len(result)} scenario/control rows; all paired-seed ranges retained')
