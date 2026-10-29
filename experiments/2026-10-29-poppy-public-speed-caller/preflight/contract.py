"""Four tiny actual-caller cases; no formal486 work or calibration."""
from guard import source_registry,validate_rows
P='PoppyPublic044';K12='FourSectorRange12BloomFilter';RANGE='Split64RangeBloomFilter'
TINY=dict(query_power=12,calibration_power=0,hit_percent=50,repeats=4)
TESTS=['eight_public_adapter_fixtures_keep_real_capacity_and_full_outputs',
       'all_literal_poppy_geometries_charge_cache_and_reject_wrong_inputs',
       'four_mode_order_balances_positions_and_predecessors',
       'actual_harness_detects_corrupt_last_output_in_every_timed_mode']
def cases(source):
    filters=[x for x in source_registry(source)if x in [P,K12,RANGE]]
    return [dict(key_power=16,budget_bpk=24,batch=b,seed=42,filters=filters,order=order)for b in [1,31]for order in ['original','reverse']]
def argv(binary,case,reference=False):
    filters=[n for n in case['filters']if not reference or n!=P]
    out=[str(binary),'16','24','50','12',str(case['batch']),'4','42',','.join(filters),'65536','0']
    return out if reference else out+[case['order']]
def semantic(row):return {k:v for k,v in row.items()if not(k.endswith('_ns')or k.endswith('_trials'))}
def keyed(rows):
    result={r['filter']:semantic(r)for r in rows}
    if len(result)!=len(rows):raise ValueError('Duplicate output filter')
    return result
def compare(actual,reference):
    current={k:v for k,v in keyed(actual).items()if k!=P}
    if current!=keyed(reference):raise ValueError('Unchanged actual caller semantic mismatch')
    return len(current)
def invalid(binary,source):
    base=argv(binary,cases(source)[0]);result=[]
    for at,value in [(11,'unknown_order'),(1,'15'),(2,'16'),(8,P+',missing'),(8,P+','+P)]:
        x=base.copy();x[at]=value;result.append(x)
    return result+[base+['extra']]
