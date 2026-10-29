"""Strict fixed142 metadata/order/trial-vector validation, with no BF execution."""
import csv
import io
import math
import sys
from pathlib import Path

STAGE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(STAGE / 'preflight-v3'))
from checks import require, shuffled_order, vector, median, close, identity, MASK, RAW

GEOMETRY_FIELDS = ('filter_bytes','budget_bytes','logical_bytes','geometry_kind','unit_bytes',
 'unit_count','effective_probes','probe_policy','constructor_argument','page_level',
 'native_constructor_bpk','implementation_origin')
with (STAGE/'validation-v3/native-cli-p16-h50-b31-t3.stdout').open(newline='') as _file:
    EXPECTED_HEADER=next(csv.reader(_file))

SEMANTIC_FIELDS = ('keys','queries','filter_bytes','result_checksum','false_positives',
 'present_queries','absent_queries','calibration_absent_queries','calibration_false_positives')


def parse_rows(data):
    reader = csv.DictReader(io.StringIO(data))
    require(reader.fieldnames==EXPECTED_HEADER, 'Changed frozen CSV header')
    rows=list(reader)
    require(rows and all(None not in r and all(v is not None for v in r.values()) for r in rows), 'Empty or malformed CSV')
    return rows


def command(binary, case, protocol):
    cpus=','.join(map(str,protocol['cpus']))
    return ['taskset','-c',cpus,'numactl','--physcpubind='+cpus,'--membind='+str(protocol['numa_node']),
      str(binary),str(case['key_power']),str(case['budget_bpk']),str(protocol['hit_percent']),
      str(protocol['query_power']),str(protocol['batch']),str(protocol['repeats']),str(protocol['seed']),
      ','.join(case['filters']),str(1 << case['key_power']),str(protocol['calibration_power']),
      str(protocol['threads']),cpus]


def validate_case(rows, case, planned, protocol):
    names=case["filters"]; cap=case["budget_bpk"]; n=1 << case["key_power"]
    q=1 << protocol["query_power"]; repeats=protocol["repeats"]; seed=protocol["seed"]
    cal=1 << protocol["calibration_power"]; hit=protocol["hit_percent"]
    batch=protocol["batch"]; workers=protocol["threads"]
    require([row['filter'] for row in rows] == shuffled_order(names,seed,n,q,hit), 'Wrong exact measured registry/order')
    present = q//100*hit+min(q%100,hit)
    for row in rows:
        require(None not in row and all(value is not None for value in row.values()), 'Malformed query CSV')
        name = row['filter']; raw = name == RAW
        values = dict(keys=n,queries=q,requested_bpk=cap,hash_bits=64,hit_percent=hit,present_queries=present,
                      absent_queries=q-present,batch=batch,repeats=repeats,seed=seed,insert_batch=n,
                      calibration_absent_queries=cal,threads=workers,spawned_threads=workers-1,
                      parallel_hash_scratch_bytes=workers*batch*8,harness_hash_scratch_bytes=max(n,batch)*8)
        for field,expected in values.items():
            require(int(row[field]) == expected,'Wrong '+field)
        geometry = planned[name]
        for field in ('filter_bytes','budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes',
                      'probe_policy','constructor_argument','page_level','native_constructor_bpk','implementation_origin'):
            require(row[field] == geometry[field], 'Changed actual geometry: '+name+'/'+field)
        require(close(row['actual_bpk'],8*int(row['filter_bytes'])/n), 'Wrong actual bpk')
        require(row['size_contract'] == 'exact_byte_ceiling_v1' and row['executor'] == 'caller_worker0'
                and row['query_phase_order'] == 'fixed_serial_pure_serial_hash_parallel_pure_parallel_hash'
                and row['input_mode'] == ('raw_bytes' if raw else 'prehashed'), 'Wrong timing/input contract')
        require(0 <= int(row['result_checksum']) <= MASK and 0 <= int(row['false_positives']) <= q-present
                and 0 <= int(row['calibration_false_positives']) <= cal, 'Invalid output counts')
        require(math.isnan(float(row['fpr'])) if present == q else close(row['fpr'],int(row['false_positives'])/(q-present)), 'Wrong mixed FPR')
        for prefix in ('lookup','hash_lookup'):
            missing = raw and prefix == 'lookup'
            trial = vector(row,prefix+'_trials_ns',repeats,missing,True)
            for field,expected in (('_ns',median(trial)),('_min_ns',min(trial)),('_max_ns',max(trial))):
                require(math.isnan(float(row[prefix+field])) if missing else close(row[prefix+field],expected),'Wrong direct serial trial summary')
        for prefix in ('parallel_lookup','parallel_hash_lookup'):
            missing = raw and prefix == 'parallel_lookup'
            trials = {part:vector(row,prefix+'_'+part+'_trials',repeats,missing,part in ('end_to_end','gated'),1)
                      for part in ('end_to_end','launch','gated','join')}
            if missing:
                require(all(math.isnan(float(row[prefix+'_'+field])) for field in ('end_to_end_ns','launch_ns','gated_ns','join_ns','end_to_end_min_ns','end_to_end_max_ns','gated_min_ns','gated_max_ns')), 'Raw-only adapter has pure summary')
                continue
            for part,values in trials.items():
                require(close(row[prefix+'_'+part+'_ns'],median(values)), 'Wrong parallel median')
            for part in ('end_to_end','gated'):
                require(close(row[prefix+'_'+part+'_min_ns'],min(trials[part])) and close(row[prefix+'_'+part+'_max_ns'],max(trials[part])),'Wrong parallel range')
            for i in range(repeats):
                require(close(trials['end_to_end'][i],sum(trials[p][i] for p in ('launch','gated','join'))), 'Incorrect thread lifetime decomposition')
        for field in ('insert_ns','allocate_insert_ns'):
            require(math.isnan(float(row[field])) if raw else math.isfinite(float(row[field])) and float(row[field])>0, 'Wrong pure-build label')
        require(all(math.isfinite(float(row[field])) and float(row[field])>0 for field in ('hash_insert_ns','allocate_hash_insert_ns')), 'Invalid raw serial build')


        require(row['language']=='cpp', 'Wrong language')
        scratch=(1+int(row['filter_bytes'])//32//16384)*(16384*8+4) if name=='FastFilterFixed32Bulk' else 0
        require(int(row['filter_build_scratch_bytes'])==scratch, 'Wrong temporary filter heap scratch')
        for a,b in [('insert_ns','allocate_insert_ns'),('hash_insert_ns','allocate_hash_insert_ns')]:
            if not (raw and a=='insert_ns'):
                require(float(row[b])>=float(row[a]), 'Allocation-inclusive serial build smaller than insert')
        require(int(row['budget_bytes'])==n*cap//8 and 0<int(row['filter_bytes'])<=n*cap//8, 'Actual backing exceeds requested ceiling')


def validate_matrix(rows, selection, protocol):
    require(len(rows)==protocol['expected_rows']==142,'Wrong full142 row count')
    seen=set(); samples={}; offset=0
    for case in protocol['cases']:
        planned={r['filter']:r for r in selection['configurations'] if r['key_power']==case['key_power'] and int(r['requested_bpk'])==case['budget_bpk']}
        part=rows[offset:offset+len(case['filters'])]; offset+=len(part)
        validate_case(part,case,planned,protocol)
        for row in part:
            config,sample=identity(row)
            require(config==planned[row['filter']]['configuration_id'] and sample==planned[row['filter']]['calibration_identity'], 'Changed configuration/calibration identity')
            require(config not in seen,'Duplicate selected API geometry'); seen.add(config)
            values=tuple(row[f] for f in SEMANTIC_FIELDS)
            require(sample not in samples or samples[sample]==values,'Equivalent API calibration/output disagreement')
            samples[sample]=values
    require(offset==len(rows) and len(samples)==protocol['expected_calibration_identities']==92, 'Wrong unique calibration records')
    return dict(rows=len(rows),cases=len(protocol['cases']),calibration_records=len(samples),pooled=False)


def validate_placement(meta, protocol):
    """Check archived placement evidence against this protocol, not today's host."""
    lease=meta['lease']
    require(lease['cpu']==protocol['driver_cpu']==3 and lease['lease']=='socket1'
      and lease['lock_path']=='/tmp/fastest-bf-socket1.lock', 'Wrong recorded parent lease')
    descriptors=lease['inherited_lock_descriptors']
    require(isinstance(descriptors,list) and descriptors and len(descriptors)==len(set(descriptors))
      and all(type(fd) is int and fd>=0 for fd in descriptors), 'Missing recorded inherited lock descriptor')
    require(meta['process_affinity']==[protocol['driver_cpu']], 'Wrong recorded parent affinity')
    topology=meta['topology']
    require([r['cpu'] for r in topology]==protocol['cpus'] and len(topology)==protocol['threads']==8, 'Wrong recorded CPU set')
    require(all(type(r['core']) is int and r['core']>=0 and r['socket']==protocol['socket']
      and r['nodes']==[protocol['numa_node']] for r in topology), 'Wrong recorded socket/NUMA node')
    require(len({(r['socket'],r['core']) for r in topology})==8, 'Recorded CPUs share a physical core')
    environment=meta['environment']
    require(environment.get('BF_SOCKET_LEASE')=='socket1-cpu3', 'Wrong recorded lease environment')
    require(not any(environment.get(k) for k in ('LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','GLIBC_TUNABLES')),
      'Recorded loader/allocator override')
