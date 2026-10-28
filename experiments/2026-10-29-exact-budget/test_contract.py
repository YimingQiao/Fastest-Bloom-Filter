#!/usr/bin/env python3
"""Full72 selection, construction modes, output/calibration and dedup regression checks."""
import csv,io,json,math,subprocess,sys
from pathlib import Path
from make_plan import generate,identities
binary,planner=map(Path,sys.argv[1:3])

def invoke(selection='',mode='query-only',builds='0',bpk=14,batch=31,repeats=2,ib=1024):
    return subprocess.run([str(binary),'10',str(bpk),'50','12',str(batch),str(repeats),'731',selection,str(ib),'12',mode,str(builds)],text=True,capture_output=True)
def valid(**kwargs):
    result=invoke(**kwargs);assert result.returncode==0,result.stderr
    rows=list(csv.DictReader(io.StringIO(result.stdout)));assert rows and all(None not in row for row in rows)
    names=[r['filter'] for r in rows];assert len(names)==len(set(names))
    for row in rows:
        assert row['budget_mode']=='exact_backing_bytes'
        assert int(row['filter_bytes'])<=int(row['budget_bytes'])
        assert float(row['actual_bpk'])==8*int(row['filter_bytes'])/int(row['keys'])
        assert row['query_repeats']==row['repeats']==str(kwargs.get('repeats',2))
        count=kwargs.get('repeats',2)
        assert row['query_phase_order']==';'.join('H>P' if (731+r)%2 else 'P>H' for r in range(count))
        pure=json.loads(row['lookup_trials_ns']);raw=json.loads(row['hash_lookup_trials_ns'])
        assert len(pure)==len(raw)==count and all(math.isfinite(x) and x>0 for x in raw)
        assert all(x is None for x in pure) if row['input_mode']=='raw_bytes' else all(math.isfinite(x) and x>0 for x in pure)
        if count%2==0:
            assert row['query_phase_order'].split(';').count('P>H')==count//2
            assert row['query_phase_order'].split(';').count('H>P')==count//2
        assert int(row['present_queries'])+int(row['absent_queries'])==4096
        assert 0<=int(row['calibration_false_positives'])<=4096
        assert int(row['calibration_absent_queries'])==4096
        assert math.isfinite(float(row['hash_lookup_ns'])) and float(row['hash_lookup_ns'])>0
        if row['input_mode']=='raw_bytes':
            for field in ('insert_ns','allocate_insert_ns','lookup_ns','lookup_min_ns','lookup_max_ns'):
                assert math.isnan(float(row[field])),(row['filter'],field)
        else: assert math.isfinite(float(row['lookup_ns'])) and float(row['lookup_ns'])>0
        if row['measurement_mode']=='query_only':
            assert row['build_repeats']=='0'
            assert int(row['harness_hash_scratch_bytes'])==8*kwargs.get('batch',31)
            for field in ('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns'):
                assert math.isnan(float(row[field])),(row['filter'],field)
        else:
            assert int(row['harness_hash_scratch_bytes'])==8*max(kwargs.get('batch',31),kwargs.get('ib',1024))
            for field in ('hash_insert_ns','allocate_hash_insert_ns'):
                assert math.isfinite(float(row[field])) and float(row[field])>0
    return {r['filter']:r for r in rows}

query=valid();assert len(query)==72
full=valid(mode='full',builds='1');assert set(full)==set(query)
partial=valid(ib=37,batch=4096,repeats=2);assert set(partial)==set(query)
fields=('filter_bytes','actual_bpk','result_checksum','false_positives','calibration_false_positives','effective_probes','unit_count','logical_bytes')
for name in query:
    for field in fields:assert query[name][field]==full[name][field]==partial[name][field],(name,field)
for selection in ('FastPatternBF,FastFilterClassic10Bulk,RocksDBFastLocalBloom64K12,PageBloom8Compact', 'Boost192Block512K10'):
    assert set(valid(selection=selection))==set(selection.split(','))
for selection in ('FastPatternBF,missing','missing,FastPatternBF','FastPatternBF,FastPatternBF',',FastPatternBF','FastPatternBF,','FastPatternBF,,FastFilterFixed16'):
    p=invoke(selection=selection);assert p.returncode and not p.stdout,(selection,p.stdout,p.stderr)
p=invoke(repeats=3);assert p.returncode and not p.stdout
for mode,builds in [('query-only','1'),('full','0'),('bad','0')]:
    p=invoke(mode=mode,builds=builds);assert p.returncode and not p.stdout
p=invoke(selection='FastPatternBF',bpk=1);assert p.returncode and not p.stdout,'native cannot fit1024keys inside128B with positive constructor bpk'
plan=generate(planner,[16,25],[12,14,16,20,24,28,32]);assert not plan['unsupported']
assert len(plan['registry'])==72 and len(plan['configurations'])==960 and len(plan['cases'])==14
for power in (16,25):
    native=[r for r in plan['configurations'] if r['filter']=='FastPatternBF' and r['key_power']==power]
    assert len(native)==3
    assert [8*int(r['filter_bytes'])/(1<<power) for r in native]==[8,16,32]
    assert [r['represented_budget_bpk'] for r in native]==[[12,14],[16,20,24,28],[32]]
# Separate API timings, identical calibration sample identities.
for k in (10,14,17,19):
    group=[r for r in plan['configurations'] if r['key_power']==16 and r['requested_bpk']=='14' and r['filter'] in {f'FastFilterClassic{k}',f'FastFilterClassic{k}Bulk',f'FastFilterClassic{k}Branchless'}]
    assert len(group)==3 and len({r['configuration_id'] for r in group})==3 and len({r['calibration_identity'] for r in group})==1
print('PASS:72 complete builds/query-only/full/partial parity; dense outputs/calibration, NaN construction contract, exact selection,960 unique planned configurations, shared-calibration identities.')

fixtures=sys.argv[3]
for name in ('QueryOnceFixture','LatePureFault','LateHashFault','LateGuardFault'):
    command=[fixtures,'10','14','50','12','4096','2','731',name,'1024','0','query-only','0']
    result=subprocess.run(command,text=True,capture_output=True)
    if name=='QueryOnceFixture':
        assert result.returncode==0,result.stderr
        assert len(list(csv.DictReader(io.StringIO(result.stdout))))==1
        command[-2:]=['full','1']
        result=subprocess.run(command,text=True,capture_output=True)
        assert result.returncode and 'constructed more than one' in result.stderr
    else:
        assert result.returncode and ('output' in result.stderr or 'guard' in result.stderr),result.stderr
        assert not list(csv.DictReader(io.StringIO(result.stdout)))
print('PASS: one complete query-only construction; second-trial pure/hash corruption and output guard faults rejected.')

from validate_rows import validate
import copy
small_plan=generate(planner,[10],[14])
expected={r['filter']:r for r in small_plan['configurations']}
kwargs=dict(power=10,budget=14,query_power=12,batch=31,repeats=2,seed=731,calibration_power=12)
validate(list(query.values()),expected,**kwargs)
for name,field,value in [
    ('FastPatternBF','filter_bytes','-1'),('FastPatternBF','lookup_ns','nan'),
    ('FastPatternBF','lookup_trials_ns','[1,2]'),('PageBloom8Compact','lookup_ns','1'),
    ('PageBloom8Compact','lookup_trials_ns','[1,2]'),('FastFilterClassic10','effective_probes','11'),
    ('FastPatternBF','build_repeats','1'),('FastPatternBF','query_phase_order','P>H;P>H')]:
    altered=copy.deepcopy(list(query.values()))
    next(r for r in altered if r['filter']==name)[field]=value
    try:validate(altered,expected,**kwargs)
    except (AssertionError,ValueError):pass
    else:raise AssertionError(('malformed row accepted',name,field))
print('PASS: shared screen row validator rejects wrong allocation/probes, raw pure times, trial/summary drift and phase/build metadata.')
