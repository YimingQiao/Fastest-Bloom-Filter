"""Fixed tiny old-seed fixtures only. No new quality sample or speed selection."""
from guard import source_registry,validate_rows
K12='FourSectorRange12BloomFilter';NEW='FourSectorRange12SingleLineV1';RANGE='Split64RangeBloomFilter'
TINY=dict(query_power=12,calibration_power=0,hit_percent=50,repeats=4)
def cases(source):
    names=source_registry(source)
    result=[dict(key_power=10,budget_bpk=24,batch=b,seed=42,filters=[n for n in names if n in [K12,NEW,RANGE]])for b in [1,3,31,4096]]
    result.append(dict(key_power=10,budget_bpk=16,batch=3,seed=42,filters=names))
    assert len(result)==5 and sum(len(c['filters'])for c in result)==34
    return result
def argv(binary,case):
    return [str(binary),str(case['key_power']),str(case['budget_bpk']),'50','12',str(case['batch']),'4','42',','.join(case['filters']),'1024','0']
def semantic(row):return {k:v for k,v in row.items()if not(k.endswith('_ns')or k.endswith('_trials'))}
def compare(actual,reference):
    current={r['filter']:semantic(r)for r in actual if r['filter']!=NEW};old={r['filter']:semantic(r)for r in reference}
    if current!=old:raise ValueError('Retained complete row semantics changed')
    aliases={r['filter']:semantic(r)for r in actual if r['filter']in [K12,NEW]}
    if len(aliases)==2:
        for row in aliases.values():row.pop('filter');row.pop('implementation_origin')
        if aliases[K12]!=aliases[NEW]:raise ValueError('Old/new complete row mapping identity changed')
    return len(old)
def invalid(binary):
    base=[str(binary),'10','24','50','12','3','4','42',NEW,'1024','0'];out=[]
    for at,value in [(8,NEW+',missing'),(8,NEW+','+NEW),(6,'5')]:
        row=base.copy();row[at]=value;out.append(row)
    return out
