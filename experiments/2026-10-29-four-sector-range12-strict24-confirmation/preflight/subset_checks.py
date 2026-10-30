"""Exact three union fixtures, unsigned64 boundary and existing query contract."""
import csv
import io
import json
from bindings import HERE,STAGE,PUBLIC,plan,need
from checks import schema,SEMANTIC
from validate_rows import validate
SEED=(1<<64)-1
CASES=[dict(cap=24,batch=31,names=['Boost192Multi64K8','FastFilterFixed64','RocksDBFastLocalBloom64K8Batch32','Split64RangeNative','FourSectorRange12Experiment']),dict(cap=28,batch=4096,names=['Boost192Multi32K8']),dict(cap=32,batch=31,names=['FastPatternBF','FourSectorBloomFilter'])]

def expected(cap):
    def saved(value):return{r['filter']:r for r in csv.DictReader(io.StringIO((PUBLIC/f'caller-validation-v2/native-plan-{value}.stdout').read_text()))}
    if cap in(24,32):result=saved(cap)
    else:
        need(cap==28,'Only fixed28 extra geometry');low=saved(24)['Boost192Multi32K8'];high=saved(32)['Boost192Multi32K8']
        # Pinned Boost multi32K8 has stride32, block32, alignment64: overhead63.
        def geometry(budget):
            count=(budget-63)//32;logical=count*32
            return dict(low,filter_bytes=str(logical+63),budget_bytes=str(budget),logical_bytes=str(logical),unit_count=str(count),constructor_argument=str(logical*8))
        need(geometry(3072)==low and geometry(4096)==high,'Frozen Boost capacity endpoints changed')
        result={'Boost192Multi32K8':geometry(3584)}
    return{name:dict(row,calibration_identity=name)for name,row in result.items()}

def order(case):return plan.order(1024,SEED,case['names'],json.loads((PUBLIC/'registry.json').read_text()),q=4096)
def command(binary,case,seed=SEED):return[str(binary),'10',str(case['cap']),'50','12',str(case['batch']),'2',str(seed),','.join(case['names']),'1024','12','query-only','0']
def validate_case(text,case):
    rows=list(csv.DictReader(io.StringIO(text)));need(rows and list(rows[0])==schema(),'Wrong subset CSVschema');need([r['filter']for r in rows]==order(case),'Wrong exact unsigned64 seed order')
    geometry=expected(case['cap']);validate(rows,{name:geometry[name]for name in case['names']},power=10,budget=case['cap'],query_power=12,batch=case['batch'],repeats=2,seed=SEED,calibration_power=12)
    return rows

def check_fixture_domain():
    proposal=json.loads((STAGE/'selection.json').read_text());need(SEED not in proposal['seeds'],'Do not run fresh seed in preflight')
    base=plan.mix(SEED+plan.GAMMA)%((1<<32)-1024-4096);envelope=[base,base+1024+4096+4096]
    for row in proposal['seed_ledger']:
        if row['accepted']:
            for domain in row['raw_domains']:need(not plan.overlaps(envelope,domain['full_counter_envelope']),'Tiny fixture overlaps heldout counter envelope')
    return dict(seed=SEED,key_power=10,query_power=12,calibration_power=12,full_counter_envelope=envelope,disjoint_from_all_six_fresh_domains=True)
