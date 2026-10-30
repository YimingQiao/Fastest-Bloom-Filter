"""Fixed accuracy-only row contract; no throughput field or stream pooling."""
import csv
import math
from pathlib import Path
HERE=Path(__file__).resolve().parent
NAMES=('Split64Range','CyclicSplit64Range','MultiplyCodeSplit64Range')
FIELDS=('filter','keys','actual_bpk','filter_bytes','seed','calibration_negatives','false_positives','checksum')
def require(value,message):
    if not value:raise ValueError(message)
def wilson(fp,n):
    require(n>0 and 0<=fp<=n,'Invalid quality count')
    z=1.959963984540054;zz=z*z;p=fp/n;d=1+zz/n;c=p+zz/(2*n);w=z*math.sqrt((p*(1-p)+zz/(4*n))/n)
    return (0 if fp==0 else max(0,(c-w)/d),1 if fp==n else min(1,(c+w)/d))
def validate(rows):
    expected=[(name,1<<power,bpk) for power in (16,25) for bpk in (16,24,28,32) for name in NAMES]
    require(len(rows)==24,'Incomplete fixed accuracy matrix')
    with (HERE/'parent-quality-reference.csv').open() as stream:
        parent={tuple(r[k] for k in ('filter','keys','actual_bpk')):r for r in csv.DictReader(stream)}
    require(len(parent)==16,'Wrong pinned parent reference')
    for row,(name,n,bpk) in zip(rows,expected):
        require(set(row)==set(FIELDS),'Unexpected/missing columns; no timing fields permitted')
        require(row['filter']==name and int(row['keys'])==n and int(row['actual_bpk'])==bpk,'Wrong filter/geometry/order')
        require(int(row['filter_bytes'])==n*bpk//8,'Wrong actual backing allocation')
        require(int(row['seed'])==42 and int(row['calibration_negatives'])==1<<24,'Wrong unique/disjoint accuracy stream')
        require(0<=int(row['false_positives'])<=1<<24,'Invalid false positives')
        require(0<=int(row['checksum'])<1<<64,'Invalid dense checksum')
        if name!=NAMES[-1]:
            previous=parent[(name,str(n),str(bpk))]
            require(all(row[k]==previous[k] for k in FIELDS),'Unchanged control fails pinned semantic reproduction')
    return rows
