"""Bounded old-seed caller checks; no held-out data or timing selection."""
from guard import source_registry, validate_rows
K12='FourSectorRange12BloomFilter'
TINY=dict(query_power=12,calibration_power=12,hit_percent=50,repeats=4)
SMALL24=['Fastbloom017K7','Split64RangeBloomFilter',K12]
SMALL32=['BloomsdayPinned','FourSectorBloomFilter','Split64BloomFilter','Split64RangeBloomFilter']

def cases(source):
    names=source_registry(source)
    result=[]
    for cap,selected in [(24,SMALL24),(32,SMALL32)]:
        for batch in [1,31,4096]:
            result.append(dict(key_power=10,budget_bpk=cap,batch=batch,seed=42,filters=[n for n in names if n in selected]))
    result.append(dict(key_power=10,budget_bpk=16,batch=31,seed=42,filters=names))
    assert len(result)==7 and sum(len(x['filters'])for x in result)==42
    return result

def argv(binary,case):
    return [str(binary),str(case['key_power']),str(case['budget_bpk']),'50','12',str(case['batch']),'4','42',','.join(case['filters']),'1024','12']

def semantic(row):
    return {k:v for k,v in row.items()if not (k.endswith('_ns')or k.endswith('_trials'))}

def compare(actual,reference):
    current={r['filter']:semantic(r)for r in actual if r['filter']!=K12}
    old={r['filter']:semantic(r)for r in reference}
    if len(current)!=len(old)or current!=old:raise ValueError('Retained full row semantics changed')
    return len(old)

def invalid(binary):
    base=[str(binary),'10','24','50','12','31','4','42',K12,'1024','12']
    changes=[(8,K12+',missing'),(8,K12+','),(8,K12+','+K12),(7,'-1'),(7,'18446744073709551616'),(6,'5')]
    out=[]
    for at,value in changes:
        row=base.copy();row[at]=value;out.append(row)
    return out
