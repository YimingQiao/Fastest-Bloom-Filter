"""Source-only geometry, registry and strict row contract. No BF is run here."""
import csv,io,itertools,json,math,statistics
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
NATIVES=['FastPatternBF','FourSectorBloomFilter','Split64BloomFilter','ByteSplitBloomFilter']
CONFIGS=['sector32-u1','sector32-u2','sector32-u4','sector64-u1','sector64-u2','sector64-u4','register64-u0']
SURFACES=['artifact_pimpl','public_dynamic','public_static']
MODES=['raw_single','raw_batch1','raw_batch4096']
PERMUTATIONS=list(itertools.permutations(range(3)))
SEMANTICS=['filter_bytes','logical_bytes','unit_bytes','unit_count','effective_probes','probe_policy',
           'geometry_kind','address','constructor_argument','implementation_origin']
GEOMETRY_FIELDS=['worker','filter','surface','implementation_origin','key_domain','keys','requested_bpk',
 'budget_bytes','filter_bytes','logical_bytes','unit_bytes','unit_count','constructor_argument',
 'effective_probes','probe_policy','geometry_kind','address','public_metadata']
WORK_FIELDS=['queries','seed','hit_percent','present_queries','absent_queries','calibration_absent_queries',
 'calibration_false_positives','false_positives','result_checksum','inserted_checksum','query_checksum',
 'calibration_checksum','repeats','query_phase_order']
EXTRA_FIELDS=['build_repeats','insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns',
 'build_hash_scratch_bytes','filter_build_scratch_bytes','adapter_object_bytes']
FIELDS=GEOMETRY_FIELDS+WORK_FIELDS+[m+s for m in MODES for s in
 ['_ns','_trials_ns','_min_ns','_max_ns','_scratch_bytes']]+EXTRA_FIELDS

def need(ok,message):
    if not ok:raise ValueError(message)

def protocol():return json.loads((HERE/'protocol.json').read_text())
def names(worker):
    if worker=='legacy':return NATIVES+[c+'/'+s for c in CONFIGS for s in SURFACES]
    need(worker=='modern','Unknown worker')
    return NATIVES+protocol()['modern_external']
def schedule(seed,repeats):
    need(repeats>=0 and repeats%6==0,'Incomplete six-trial phase block')
    return '|'.join(''.join(map(str,PERMUTATIONS[(i+seed%6)%6])) for i in range(repeats)) or 'untimed'
def present(q,hit):return q//100*hit+min(q%100,hit)
def integer(s):
    need(isinstance(s,str) and s.isdecimal(),'Expected unsigned integer: '+repr(s));return int(s)
def model(name):return json.loads((HERE/'modern-models.json').read_text())[name]

def geometry(worker,name,power,cap):
    need(name in names(worker) and 6<=power<=25 and cap in (12,16,24,32),'Unregistered geometry')
    n=1<<power;budget=n*cap//8
    g=dict(worker=worker,filter=name,keys=n,requested_bpk=cap,budget_bytes=budget,
           key_domain='raw_u32',implementation_origin='external',probe_policy='fixed',address='range')
    if name in NATIVES:
        b=1<<(budget.bit_length()-1);need(b>=128,'Native minimum allocation')
        arg=(b*4+n-1)//n
        g.update(filter_bytes=b,logical_bytes=b,unit_bytes=64,unit_count=b//64,constructor_argument=arg,
          effective_probes=6 if name=='FastPatternBF' and n>b*8//12 else 8,
          geometry_kind='native_pow2_lines',address='pow2',implementation_origin='production_native',surface='public_native_lookup')
        if name=='ByteSplitBloomFilter':g.update(effective_probes=-1,probe_policy='variable_byte_mask_0_16')
    elif worker=='legacy':
        c,s=name.split('/');word=4 if c.startswith('sector32') else 8;w=1 if c.startswith('register') else 8
        # The fixed powers-of-two n and caps 12/16/24/32 are the exact divisors
        # checked by Stage2. The native worker still calls next_cheap_magic;
        # this is a row expectation, never a replacement addressing algorithm.
        need(budget>=128,'Original minimum allocation')
        g.update(filter_bytes=budget,logical_bytes=budget,unit_bytes=word*w,unit_count=budget//(word*w),
          constructor_argument=budget*8,effective_probes=8,geometry_kind='original_blocked_bloom',
          address='pow2' if cap in (16,32) else 'magic',surface=s)
    else:
        m=model(name);kind=m['geometry_kind'];unit=int(m['unit_bytes'])
        g.update(effective_probes=int(m['effective_probes']),probe_policy=m['probe_policy'],
                 geometry_kind=kind,surface='upstream_public_hash_api')
        if kind=='simd_pow2_buckets':
            b=1<<(budget.bit_length()-1);g.update(filter_bytes=b,logical_bytes=b,unit_bytes=32,
                unit_count=b//32,constructor_argument=b.bit_length()-1,address='pow2')
        elif kind=='fixed_range_buckets':
            b=budget//unit*unit;scale={16:10,32:24,64:50}[unit]
            g.update(filter_bytes=b,logical_bytes=b,unit_bytes=unit,unit_count=b//unit,constructor_argument=b//unit*scale)
        elif kind=='boost_range':
            overhead=int(m['filter_bytes'])-int(m['unit_count'])*unit
            used=int(m['logical_bytes'])-(int(m['unit_count'])-1)*unit
            count=(budget-overhead)//unit;logical=count*unit+used-unit
            g.update(filter_bytes=count*unit+overhead,logical_bytes=logical,unit_bytes=unit,unit_count=count,constructor_argument=logical*8)
        elif kind=='rocks_core_lines':
            b=budget//64*64;g.update(filter_bytes=b,logical_bytes=b,unit_bytes=64,unit_count=b//64,constructor_argument=b)
        elif kind=='page_raw_bytes':
            k=g['effective_probes'];level=8-8//k
            if name.endswith('Default'):
                level=12
                for i in range(6,12):
                    if budget<(1<<(i+4)):level=max(i,8-8//k);break
            while budget>>level>=1<<18:level+=1
            need(level<=13 and budget>>level,'Unsupported Page geometry');unit=1<<level;b=budget//unit*unit
            g.update(filter_bytes=b,logical_bytes=b,unit_bytes=unit,unit_count=b//unit,constructor_argument=b//unit,
                     geometry_kind='page_raw4_bytes',surface='upstream_raw4_byte_api')
        else:raise ValueError('Unmodeled registered geometry: '+kind)
    return g

def calibration_key(row):
    name=row['filter']
    if row['worker']=='legacy' and name not in NATIVES:name=name.split('-u')[0]
    name={'FastFilterFixed16SingleV1':'FastFilterFixed16','FastFilterFixed32Bulk':'FastFilterFixed32',
          'FastFilterSimdBlockSingleV1':'FastFilterSimdBlock','RocksDBFastLocalBloom64K8Batch32':'RocksDBFastLocalBloom64K8'}.get(name,name)
    # Public surfaces/U are aliases, not independent negative samples. Native
    # controls also share their construction and stream across executables.
    return (name,)+tuple(str(row[k]) for k in ['keys','filter_bytes','logical_bytes','unit_bytes','unit_count','effective_probes','probe_policy','geometry_kind','address'])

def panel(worker):
    out=[];seen=set()
    for p in (16,25):
        for cap in (12,16,24,32):
            for name in names(worker):
                g=geometry(worker,name,p,cap);key=(name,p)+tuple(str(g[k]) for k in SEMANTICS)
                if key in seen:continue
                seen.add(key);out.append(g)
    return out

def check_cases(backend):
    # Every API: MAGIC mixed-hit + all-miss/all-hit at a power-of-two cap in
    # ordinary builds. ASan repeats MAGIC mixed-hit for every API. All paths
    # themselves check every tail0..131 and all three dense/single modes.
    hits=(50,0,100) if backend=='native' else (50,)
    for worker in ('legacy','modern'):
        for hit in hits:
            for name in names(worker):
                yield dict(worker=worker,filter=name,power=10,cap=24 if hit==50 else 16,qpower=13,hit=hit,seed=42,calpower=12,repeats=0)
    if backend=='native':
        for worker in ('legacy','modern'):
            for name in NATIVES:
                yield dict(worker=worker,filter=name,power=10,cap=12,qpower=13,hit=50,seed=42,calpower=12,repeats=0)
        for name in names('modern'):
            if name.startswith('Page'):
                yield dict(worker='modern',filter=name,power=16,cap=24,qpower=13,hit=50,seed=42,calpower=12,repeats=0)

def arguments(case,action='--check'):
    return [action,case['filter'],*[str(case[x]) for x in ['power','cap','qpower','hit','seed','calpower','repeats']]]

def parse_one(raw):
    reader=csv.DictReader(io.StringIO(raw));rows=list(reader)
    need(reader.fieldnames==FIELDS and len(rows)==1,'Expected exactly one complete worker row')
    need(None not in rows[0] and all(v is not None for v in rows[0].values()),'Malformed row width')
    return rows[0]

def validate(row,c):
    g=geometry(c['worker'],c['filter'],c['power'],c['cap'])
    for k,v in g.items():need(row[k]==str(v),'Wrong geometry field '+k)
    metadata=json.loads(row['public_metadata']);name=c['filter']
    if c['worker']=='legacy' and name not in NATIVES:
        config,surface=name.split('/');word=4 if config.startswith('sector32') else 8;w=1 if config.startswith('register') else 8
        for k,v in dict(size=g['logical_bytes'],word_size=word,k=8,w=w,s=w,u=int(config.rsplit('u',1)[1]),addr=g['address']).items():
            need(metadata[k]==v,'Wrong original public metadata '+k)
        if surface=='public_static':need(metadata['metadata_source']=='public_static_template','Static metadata mislabeled')
    elif name.startswith('Page'):
        need(metadata=={'key_bytes':4,'page_level':g['unit_bytes'].bit_length()-1},'Page must hash four raw bytes')
    else:need(metadata=={},'Unexpected public metadata')
    q=1<<c['qpower'];cal=(1<<c['calpower']) if c['calpower'] else 0;p=present(q,c['hit'])
    for k,v in dict(queries=q,seed=c['seed'],hit_percent=c['hit'],present_queries=p,absent_queries=q-p,
                   calibration_absent_queries=cal,repeats=c['repeats'],build_repeats=0).items():need(integer(row[k])==v,'Wrong workload '+k)
    need(integer(row['false_positives'])<=q-p and integer(row['calibration_false_positives'])<=cal,'Impossible FP count')
    for k in ('result_checksum','inserted_checksum','query_checksum','calibration_checksum'):need(integer(row[k])<1<<64,'Invalid full-stream checksum')
    need(row['query_phase_order']==schedule(c['seed'],c['repeats']),'Phase schedule drift')
    scratch_unit=0 if name.startswith('Page') else 4 if c['worker']=='legacy' and name not in NATIVES else 8
    for i,m in enumerate(MODES):
        need(integer(row[m+'_scratch_bytes'])==scratch_unit*(0,1,4096)[i],'Wrong exact requested scratch')
        metrics=[float(row[m+s]) for s in ('_ns','_min_ns','_max_ns')]
        if not c['repeats']:
            need(row[m+'_trials_ns']=='nan' and all(math.isnan(x) for x in metrics),'Correctness row contains timing')
        else:
            trial=list(map(float,row[m+'_trials_ns'].split('|')))
            need(len(trial)==c['repeats'] and all(math.isfinite(x) and x>0 for x in trial),'Missing timing trials')
            need(metrics==[statistics.median(trial),min(trial),max(trial)],'Trial summaries differ')
    for k in ('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns'):need(math.isnan(float(row[k])),'Build timing must stay disabled')
    need(integer(row['build_hash_scratch_bytes'])==(g['keys']*8 if scratch_unit==8 else 0),'Wrong build hash scratch')
    build_scratch=(1+g['filter_bytes']//32//16384)*(16384*8+4) if name=='FastFilterFixed32Bulk' else 0
    need(integer(row['filter_build_scratch_bytes'])==build_scratch,'Wrong filter heap build scratch')
    need(integer(row['adapter_object_bytes'])>0,'Missing control object size')
    return row

def parity(rows):
    streams={};aliases={}
    for r in rows:
        stream=tuple(r[k] for k in ('keys','queries','seed','hit_percent','calibration_absent_queries'))
        digests=tuple(r[k] for k in ('inserted_checksum','query_checksum','calibration_checksum'))
        need(stream not in streams or streams[stream]==digests,'Raw-u32 input streams differ')
        streams[stream]=digests
        key=(stream,calibration_key(r));answers=tuple(r[k] for k in ('false_positives','calibration_false_positives','result_checksum'))
        need(key not in aliases or aliases[key]==answers,'Alias/API/backend/round parity failed')
        aliases[key]=answers
    return len(aliases)
