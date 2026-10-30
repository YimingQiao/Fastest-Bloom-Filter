#!/usr/bin/env python3
"""Summarize same-workload candidate latency relative to the old native header."""
import csv,json,math,sys
from collections import defaultdict
from pathlib import Path
path=Path(sys.argv[1])
rows=list(csv.DictReader(path.open()))
keys=('keys','requested_bpk','batch','seed','hit_percent','queries')
groups=defaultdict(dict)
for row in rows:
    groups[tuple(row[k] for k in keys)][row['filter']]=row
out={'rows':len(rows),'workloads':len(groups),'ratio_definition':'candidate latency / old native latency; below1 is faster','workload_results':[],'aggregate_results':[]}
aggregates=defaultdict(list)
for key,byname in sorted(groups.items(),key=lambda x:tuple(int(v) for v in x[0])):
    old=byname['FastPatternBeforeTailBF']
    for name in ('FastPatternEntryTailBF','FastPatternGroupedTailBF'):
        new=byname[name]
        record={**dict(zip(keys,key)),'candidate':name,'actual_bpk':old['actual_bpk']}
        for metric in ('lookup_ns','hash_lookup_ns','hash_insert_ns'):
            before,after=float(old[metric]),float(new[metric])
            ratio=after/before
            record[metric]={'old':before,'new':after,'ratio':ratio}
            aggregates[(name,key[0],key[1],key[2],metric)].append(ratio)
        out['workload_results'].append(record)
for (name,n,bpk,batch,metric),ratios in sorted(aggregates.items(),key=lambda x:(x[0][0],*(int(v) for v in x[0][1:4]),x[0][4])):
    out['aggregate_results'].append({'candidate':name,'keys':int(n),'requested_bpk':int(bpk),'batch':int(batch),'metric':metric,'count':len(ratios),'geomean_ratio':math.exp(sum(map(math.log,ratios))/len(ratios)),'min_ratio':min(ratios),'max_ratio':max(ratios)})
(path.parent/'summary.json').write_text(json.dumps(out,indent=2)+'\n')
for n in sorted({r['keys'] for r in rows},key=int):
    for bpk in sorted({r['requested_bpk'] for r in rows},key=int):
        print('keys='+n,'requested_bpk='+bpk)
        for batch in sorted({r['batch'] for r in rows},key=int):
            values=[]
            for name in ('FastPatternEntryTailBF','FastPatternGroupedTailBF'):
                for metric in ('lookup_ns','hash_lookup_ns'):
                    ratios=aggregates[(name,n,bpk,batch,metric)]
                    if ratios:
                        values.append(math.exp(sum(map(math.log,ratios))/len(ratios)))
            print('  batch='+batch,' '.join(f'{v:.3f}' for v in values))
