"""Offline protocol/row guards only; importing this module never runs a BF."""
import itertools

NATIVES=['FastPatternBF','FourSectorBloomFilter','Split64BloomFilter','ByteSplitBloomFilter']
CONFIGS=['sector32-u1','sector32-u2','sector32-u4','sector64-u1','sector64-u2','sector64-u4','register64-u0']
MODES=['public_single','dense_batch1','dense_batch4096']
PERMUTATIONS=list(itertools.permutations(range(3)))

def need(ok,message):
    if not ok: raise ValueError(message)

def schedule(seed,repeats):
    need(repeats>0 and repeats%6==0,'Use complete six-trial phase blocks')
    return [PERMUTATIONS[(i+seed%6)%6] for i in range(repeats)]

def domains(n,q,cal,hit):
    need(0<n<=0xffffffff and 0<=q<=0xffffffff and 0<=cal<=0xffffffff and 0<=hit<=100,'Invalid raw32 domain')
    present=q//100*hit+min(q%100,hit)
    absent=q-present
    need(n+absent+cal<=1<<32,'Overlapping raw32 counter domains')
    return present,absent

def validate(protocol):
    p=protocol; s=p['screen']; legacy=p['workers']['legacy'];modern=p['workers']['modern']
    need(legacy['boost']=='1.83' and modern['boost']=='1.92','Boost context mixing')
    need(legacy['native_controls']==modern['native_controls']==NATIVES,'Missing paired native controls')
    need(legacy['original_configs']==CONFIGS,'Changed original configurations')
    need(legacy['public_surfaces']==['artifact_pimpl','public_dynamic','public_static'],'Public surface substitution')
    expected=sorted(set(p['selection']['exact_external_union'])|set(p['selection']['visible_external_union']))+p['selection']['extra_controls']
    need(modern['external']==expected and len(expected)==len(set(expected))==19,'Modern shortlist drift')
    need(s['key_powers']==[16,25] and s['bitmap_cap_bpk']==[12,16,24,32],'Unregistered geometry grid')
    need(s['query_modes']==MODES and s['seeds']==[42],'Unregistered modes or seeds')
    need(s['query_power']==22 and s['calibration_power']==24 and s['hit_percent']==50,'Workload drift')
    need(s['launch_rounds']==2 and s['worker_orders']==[['legacy','modern'],['modern','legacy']],'Both launch orders required')
    need(s['build_repeats']==0 and not s['pool_alias_calibration'] and not s['context_shift_correction'],'Unsupported accounting or normalization')
    need(s['deduplicate_actual_geometry'],'Repeated capacity must be deduplicated')
    for power in s['key_powers']: domains(1<<power,1<<s['query_power'],1<<s['calibration_power'],s['hit_percent'])
    schedule(42,s['query_repeats'])
    need(p['preflight']['backends']==['native','avx2','native-asan'] and p['preflight']['cases_per_backend']==56,'Preflight coverage drift')
    need(p['preflight']['timing_permitted'] is False,'Preflight cannot time filters')
    return p

def geometry_cases(protocol):
    validate(protocol)
    return [(c,n,b) for c in CONFIGS for n in protocol['screen']['key_powers'] for b in protocol['screen']['bitmap_cap_bpk']]

def validate_geometry(row,case):
    name,power,bpk=case; cap=(1<<power)*bpk//8
    word=4 if name.startswith('sector32') else 8
    w=1 if name=='register64-u0' else 8
    u=int(name.rsplit('u',1)[1]); block=word*w
    expected_mode='pow2' if bpk in (16,32) else 'magic'
    need(set(row)=={'budget_bytes','constructor_bits','logical_bytes','backing_bytes','block_count','address','digest','bitmap_digest','upstream_metadata'},'Malformed geometry row')
    need(row['budget_bytes']==cap and row['address']==expected_mode,'Wrong cap or mode')
    need(isinstance(row['block_count'],int) and row['block_count']>0,'Invalid block count')
    logical=row['block_count']*block
    need(row['logical_bytes']==logical and row['constructor_bits']==logical*8,'Wrong logical geometry')
    need(row['backing_bytes']==(logical+63)//64*64<=cap,'Uncharged padding or cap overflow')
    actual=row['upstream_metadata']
    need(actual['size']==logical and actual['word_size']==word and actual['w']==w and actual['s']==w and actual['k']==8 and actual['u']==u and actual['addr']==expected_mode,'Actual original metadata disagrees')
    need(isinstance(row['digest'],int) and 0<=row['digest']<1<<64,'Missing full-output digest')
    need(isinstance(row['bitmap_digest'],int) and 0<=row['bitmap_digest']<1<<64,'Missing full-bitmap digest')
    return row
