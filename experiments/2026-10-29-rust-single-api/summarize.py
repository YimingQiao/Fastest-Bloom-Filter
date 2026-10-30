#!/usr/bin/env python3
"""Report every control relative to its unchanged same-process native baseline."""
import argparse,csv
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('input',type=Path);p.add_argument('output',type=Path);a=p.parse_args()
rows=list(csv.DictReader(a.input.open()));groups={}
for row in rows:
 key=tuple(row[x] for x in ['keys','requested_bpk','batch','seed']);groups.setdefault(key,{})[row['filter']]=row
result=[]
for key,by_name in sorted(groups.items(),key=lambda kv:tuple(map(int,kv[0]))):
 for family in ['Byte','Split']:
  base=by_name['ByteSplitBloomFilter' if family=='Byte' else 'Split64BloomFilter']
  for name in [family+'NativeSingleApiV1',family+'InlineLookupV1']:
   row=dict(zip(['keys','requested_bpk','batch','seed'],key));row['candidate']=name
   for metric in ['lookup_ns','hash_lookup_ns','hash_insert_ns']:
    row['native_'+metric]=base[metric];row['candidate_'+metric]=by_name[name][metric]
    row[metric+'_speedup']=float(base[metric])/float(by_name[name][metric])
   result.append(row)
with a.output.open('w',newline='') as f:
 w=csv.DictWriter(f,fieldnames=list(result[0]),lineterminator='\n');w.writeheader();w.writerows(result)
print(f'{len(result)} control/workload rows; no regressions excluded')
