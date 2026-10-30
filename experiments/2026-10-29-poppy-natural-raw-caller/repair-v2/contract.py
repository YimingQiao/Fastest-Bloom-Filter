"""Fixed tiny raw-only CLI schema/order/geometry/trials; no performance ranking."""
import json,math,re,statistics
from bindings import CALLER,need
METRICS=['raw_batched_public','raw_visible_public','raw_insert','allocate_filter_and_scratch_raw_insert']
BASE_FIELDS=['language','filter','keys','queries','requested_bpk','filter_bytes','actual_bpk','hit_percent','present_queries','batch','insert_batch','repeats','seed','key_base','raw_hash_contract','build_scratch_bytes','query_scratch_bytes','absent_queries','false_positives','result_checksum','calibration_absent_queries','calibration_false_positives']
POPPY_FIELDS=['poppy_policy','poppy_fpp_bits','poppy_bucket_bytes','poppy_cache_bytes','poppy_source_configuration']
GEOMETRY_FIELDS=['budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes','probe_policy','constructor_argument','implementation_origin','size_contract']
FIELDS=set(BASE_FIELDS+['query_phase_order']+GEOMETRY_FIELDS+POPPY_FIELDS+[m+'_'+s for m in METRICS for s in ['ns','min_ns','max_ns','trials']])
TESTS=['poppy_tests::natural_forms_real_geometry_small_load_full_bytes_and_outputs','poppy_tests::natural_geometry_registry_and_reject_before_bitmap','reporter::tests::actual_scratch_allocations_clock_boundaries_and_lifetimes','reporter::tests::skip_last_and_wrong_value_faults_fail_after_valid_warmups_in_both_modes']
MASK=(1<<64)-1
class Random:
    def __init__(self,seed):self.state=seed
    def next(self):
        self.state=(self.state+0x9e3779b97f4a7c15)&MASK;z=self.state;z=((z^(z>>30))*0xbf58476d1ce4e5b9)&MASK;z=((z^(z>>27))*0x94d049bb133111eb)&MASK;return z^(z>>31)
    def shuffle(self,items):
        for i in range(len(items)-1,0,-1):j=self.next()%(i+1);items[i],items[j]=items[j],items[i]
def registry():
    text=(CALLER/'benchmark/src/main.rs').read_text();text=text[text.index('const FILTER_NAMES:'):text.index('fn main() {')]
    names=re.findall(r'    "([A-Za-z0-9]+)",',text);need(len(names)==len(set(names))==73,'Wrong registry');return names
def points():
    values=json.loads((CALLER/'geometry-union.json').read_text());need(len(values)==14,'Wrong selected geometry count')
    return {f'PoppyRaw{form}{int(p["filter"].removeprefix("PoppyPublic")):03d}':p for p in values for form in ['Byte','Typed']}
def cases():
    plan=json.loads((CALLER/'PREFLIGHT_PLAN.json').read_text());need(plan['total_caller_rows']==146,'Wrong finite plan')
    values=[plan['retained_control_cli']['arguments']]
    for budget in [16,24]:
        names=[name for name in registry()if name in points()and points()[name]['keys']==65536 and points()[name]['run_budget_bpk']==budget]
        for batch in [1,31]:values.append(['16',str(budget),'50','12',str(batch),'4','42',','.join(names),'4096','0'])
    need([len(row_order(c)[0])for c in values]==[45,8,8,6,6],'Wrong five-case scope')
    return values
def argv(binary,case):return [str(binary),*case]
def row_order(case):
    n=1<<int(case[0]);q=1<<int(case[3]);hit=int(case[2]);r=Random(int(case[6]));base=r.next()%((1<<32)-n-q)
    hits=q//100*hit+min(q%100,hit)
    r.state=(r.state+(n-1+hits+q-1)*0x9e3779b97f4a7c15)&MASK # exact draw skip; no filter outputs
    requested=case[7].split(',')if case[7]else None
    names=registry()[:45]if requested is None else [name for name in registry()if name in requested]
    if requested is not None:need(len(names)==len(requested),'Invalid fixed subset')
    r.shuffle(names);return names,base,hits
def phase_order(seed,repeats):
    labels=[0,1];Random(seed^0x6a09e667f3bcc909).shuffle(labels)
    return ';'.join('|'.join(str(labels[i])for i in ([0,1]if j%4 in [0,3]else[1,0]))for j in range(repeats))
def geometry(name,n,cap):
    if name in points():
        p=points()[name];c=p['canonical_constructor'];need((n,cap)==(p['keys'],p['run_budget_bpk']),'Wrong natural constructor')
        return dict(filter_bytes=p['actual_bytes'],budget_bytes=n*cap//8,logical_bytes=p['bucket_bytes'],geometry_kind='poppy_public_buckets_with_cache',unit_bytes=4096,unit_count=p['bucket_bytes']//4096,effective_probes=c['probes'],probe_policy='frozen_public_params',constructor_argument=n,implementation_origin='external_poppy_natural',size_contract='exact_byte_ceiling_v1')
    budget=n*cap//8;native={'FastPatternBF','ByteSplitBloomFilter','FourSectorBloomFilter','Split64BloomFilter'}
    logical=budget;unit=64;kind='range_lines';probes=8;policy='fixed';argument=budget;owner='external'
    if name in native:
        logical=1<<(budget.bit_length()-1);kind='native_pow2_lines';argument=(logical*4+n-1)//n;owner='production_native'
        if name=='ByteSplitBloomFilter':probes=-1;policy='variable_byte_mask_0_16'
        elif name=='FastPatternBF'and n>logical*8//12:probes=6
    elif name=='Split64RangeBloomFilter':owner='optional_native_range'
    elif name=='FourSectorRange12BloomFilter':kind='top24_range_lines';probes=12;owner='optional_native_k12'
    elif name=='BloomsdayPinned':unit=32;kind='public_split32_range';argument=cap
    elif name=='SbbfSafePinned':unit=32;kind='public_sbbf_range_padded64'
    elif name.startswith('FastbloomRsRawK'):
        unit=8;kind='raw8_classical_words';probes=int(name.removeprefix('FastbloomRsRawK'));policy='public_from_size_and_hashes';argument=budget*8
    elif name=='Fastbloom017'or name.startswith('Fastbloom017K'):
        unit=8;kind='classical_words';argument=budget*8
        if name=='Fastbloom017':probes=round(cap*math.log(2));policy='upstream_expected_items_real_n'
        else:probes=int(name.removeprefix('Fastbloom017K'));policy='public_fixed_hash_count'
    else:raise ValueError('Unknown API')
    return dict(filter_bytes=logical,budget_bytes=budget,logical_bytes=logical,geometry_kind=kind,unit_bytes=unit,unit_count=logical//unit,effective_probes=probes,probe_policy=policy,constructor_argument=argument,implementation_origin=owner,size_contract='exact_byte_ceiling_v1')
def poppy_metadata(name):
    if name not in points():return dict.fromkeys(POPPY_FIELDS,'')
    p=points()[name];c=p['canonical_constructor']
    return dict(poppy_policy=c['policy'],poppy_fpp_bits=c['fpp_bits'],poppy_bucket_bytes=str(p['bucket_bytes']),poppy_cache_bytes=str(p['cache_bytes']),poppy_source_configuration=p['configuration_id'])
def hash_contract(name):
    if name.startswith('PoppyRawByte'):return 'public_poppy_natural_byte8'
    if name.startswith('PoppyRawTyped'):return 'public_poppy_natural_typed_u64'
    return 'public_raw8_two_seed_xxh3_64'if name.startswith('FastbloomRsRawK')else'public_common_hash64'
def is_direct(name):return name.startswith(('FastbloomRsRawK','PoppyRaw'))
def integer(value):
    need(isinstance(value,str)and re.fullmatch(r'-?\d+',value),'Integer field required');return int(value)
def validate_rows(rows,case):
    names,base,present=row_order(case);need([r['filter']for r in rows]==names,'Wrong exact job order/row count')
    n=1<<int(case[0]);q=1<<int(case[3]);cap=int(case[1]);batch=int(case[4]);repeats=int(case[5]);seed=int(case[6]);insertion=int(case[8]);cal=0 if int(case[9])==0 else 1<<int(case[9])
    for row in rows:
        need(set(row)==FIELDS,'Wrong raw-only schema')
        name=row['filter'];direct=is_direct(name);g=geometry(name,n,cap)
        expected=dict(keys=n,queries=q,requested_bpk=cap,hit_percent=int(case[2]),present_queries=present,batch=batch,insert_batch=insertion,repeats=repeats,seed=seed,key_base=base,build_scratch_bytes=0 if direct else min(insertion,n)*8,query_scratch_bytes=0 if direct else batch*8,absent_queries=q-present,calibration_absent_queries=cal,**g)
        for key,value in expected.items():need(integer(row[key])==value if type(value)is int else row[key]==value,'Wrong field '+key)
        need(row['language']=='rust'and row['raw_hash_contract']==hash_contract(name),'Wrong raw API identity')
        need({k:row[k]for k in POPPY_FIELDS}==poppy_metadata(name),'Wrong public constructor identity')
        need(math.isclose(float(row['actual_bpk']),g['filter_bytes']*8/n,rel_tol=0,abs_tol=1e-12),'Actual cap mismatch')
        need(0<=integer(row['false_positives'])<=q-present and 0<=integer(row['calibration_false_positives'])<=cal,'Invalid FP counts')
        need(0<=integer(row['result_checksum'])<1<<64,'Invalid full checksum')
        need(row['query_phase_order']==phase_order(seed,repeats),'Exact seeded phase schedule differs')
        samples={}
        for metric in METRICS:
            values=[float(x)for x in row[metric+'_trials'].split('|')];need(len(values)==repeats and all(math.isfinite(x)and x>=0 for x in values),'Invalid raw trial vector')
            for suffix,value in [('ns',statistics.median(values)),('min_ns',min(values)),('max_ns',max(values))]:need(math.isclose(float(row[metric+'_'+suffix]),value,rel_tol=1e-12,abs_tol=1e-12),'Trial summary mismatch')
            samples[metric]=values
        need(all(a>=b for a,b in zip(samples[METRICS[3]],samples['raw_insert'])),'Full build shorter than contained insertion')
def semantic(row):
    ignored={'batch','query_scratch_bytes','query_phase_order'}|{m+'_'+s for m in METRICS for s in ['ns','min_ns','max_ns','trials']}
    return {k:v for k,v in row.items()if k not in ignored}
def parent_semantic(row):return semantic({k:v for k,v in row.items()if k not in POPPY_FIELDS})
def validate_reference(rows,reference):
    need(len(rows)==len(reference)==45,'Wrong retained control coverage')
    need([r['filter']for r in rows]==[r['filter']for r in reference],'Retained control order changed')
    need([parent_semantic(r)for r in rows]==[parent_semantic(r)for r in reference],'Retained control semantics changed')
def validate_process(returncode,stdout,stderr,rejection=None):
    forbidden=[b'AddressSanitizer',b'LeakSanitizer',b'MemorySanitizer',b'ThreadSanitizer',b'UndefinedBehaviorSanitizer',b'runtime error:']
    need(not any(token in stdout or token in stderr for token in forbidden),'Sanitizer/runtime diagnostic')
    if rejection is None:need(returncode==0,'Expected successful command')
    else:
        need(returncode==rejection['expected_exit'],'Wrong CLI rejection exit code')
        need(not stdout and rejection['diagnostic'].encode()in stderr,'Wrong CLI rejection diagnostic or stdout')
def invalid(binary):
    base=['7','24','50','12','31','4','42','FastPatternBF','31','12'];result=[]
    changes=[(7,'MissingFilter',2,"unknown filter 'MissingFilter'"),(7,'FastPatternBF,FastPatternBF',2,"duplicate filter 'FastPatternBF'"),(7,'PoppyRawByte039',101,'Poppy requires its frozen real n and declared budget'),(6,'-1',101,'unsigned integers required'),(6,str(1<<64),101,'integer overflow'),(7,'PoppyRawByte020',101,'Poppy requires its frozen real n and declared budget')]
    for index,value,exitcode,diagnostic in changes:
        values=list(base);values[index]=value
        if value=='PoppyRawByte020':values[0]='16';values[1]='16'
        result.append(dict(command=[str(binary),*values],expected_exit=exitcode,diagnostic=diagnostic))
    return result
