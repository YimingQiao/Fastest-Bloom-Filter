"""Offline negative tests: no compiler, filter, calibration or timer is run."""
import collections,copy,csv,io,json,math,tempfile,unittest
from pathlib import Path
from contract import *

def fixture(worker='legacy',name='sector32-u2/artifact_pimpl',repeats=0):
    c=dict(worker=worker,filter=name,power=10,cap=24,qpower=13,hit=50,seed=42,calpower=12,repeats=repeats)
    g=geometry(worker,name,10,24);r={k:str(v) for k,v in g.items()}
    if worker=='legacy' and name not in NATIVES:
        config,surface=name.split('/');word=4 if config.startswith('sector32') else 8;w=1 if config.startswith('register') else 8
        metadata=dict(size=g['logical_bytes'],word_size=word,k=8,w=w,s=w,u=int(config.rsplit('u',1)[1]),addr='magic')
        if surface=='public_static':metadata['metadata_source']='public_static_template'
    elif name.startswith('Page'):metadata=dict(key_bytes=4,page_level=g['unit_bytes'].bit_length()-1)
    else:metadata={}
    r['public_metadata']=json.dumps(metadata,separators=(',',':'));q=1<<13;p=present(q,50)
    r.update({k:str(v) for k,v in dict(queries=q,seed=42,hit_percent=50,present_queries=p,absent_queries=q-p,
      calibration_absent_queries=1<<12,calibration_false_positives=1,false_positives=2,result_checksum=3,
      inserted_checksum=4,query_checksum=5,calibration_checksum=6,repeats=repeats,build_repeats=0,adapter_object_bytes=256).items()})
    r['query_phase_order']=schedule(42,repeats);unit=0 if name.startswith('Page') else 4 if worker=='legacy' and name not in NATIVES else 8
    for i,m in enumerate(MODES):
        r.update({m+s:'nan' for s in ('_ns','_min_ns','_max_ns','_trials_ns')});r[m+'_scratch_bytes']=str(unit*(0,1,4096)[i])
        if repeats:r.update({m+'_ns':'3.5',m+'_min_ns':'1',m+'_max_ns':'6',m+'_trials_ns':'1|2|3|4|5|6'})
    for k in ('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns'):r[k]='nan'
    r['build_hash_scratch_bytes']=str((1<<10)*8 if unit==8 else 0)
    r['filter_build_scratch_bytes']=str((1+g['filter_bytes']//32//16384)*(16384*8+4) if name=='FastFilterFixed32Bulk' else 0)
    return c,{k:r[k] for k in FIELDS}

class Contract(unittest.TestCase):
    def test_balance(self):
        for seed in (0,1,5,42,65537):
            order=schedule(seed,6).split('|');self.assertEqual(len(set(order)),6)
            self.assertEqual(set(collections.Counter((position,int(mode)) for trial in order for position,mode in enumerate(trial)).values()),{2})
            self.assertEqual(set(collections.Counter((trial[i],trial[i+1]) for trial in order for i in (0,1)).values()),{2})
        with self.assertRaises(ValueError):schedule(42,5)
    def test_counts_and_dedup(self):
        self.assertEqual([len(names(w)) for w in ('legacy','modern')],[25,23])
        panels=[panel(w) for w in ('legacy','modern')];self.assertEqual(list(map(len,panels)),[192,172])
        self.assertEqual(len({calibration_key(g) for p in panels for g in p}),166)
        self.assertEqual([len(list(check_cases(x))) for x in ('native','native-asan')],[158,48])
        for w in ('legacy','modern'):
            rows=[r for r in panel(w) if r['filter']=='FastPatternBF' and r['keys']==65536]
            self.assertEqual([r['requested_bpk'] for r in rows],[12,16,32])
            self.assertEqual([r['filter_bytes']*8//65536 for r in rows],[8,16,32])
    def test_frozen_modern_geometry(self):
        old=json.loads((ROOT/'experiments/2026-10-29-exact-budget-range/planned-grid.json').read_text())['configurations']
        for w in ('legacy','modern'):
            for r in panel(w):
                if w=='legacy' and r['filter'] not in NATIVES:continue
                found=[x for x in old if x['filter']==r['filter'] and int(x['keys'])==r['keys'] and r['requested_bpk'] in x['represented_budget_bpk']]
                self.assertEqual(len(found),1);x=found[0]
                for k in SEMANTICS:
                    if k=='address':continue
                    value=x[k]
                    if k=='geometry_kind' and str(value)=='page_raw_bytes':value='page_raw4_bytes'
                    self.assertEqual(str(r[k]),str(value),(r['filter'],k))
    def test_frozen_original_geometry(self):
        p=ROOT/'benchmarks/vldb-raw32-stage2/validation-v1/metadata.json';old=json.loads(p.read_text())['backend_rows']['native']
        self.assertEqual(len(old),56)
        cases=[(c,p,b) for c in CONFIGS for p in (16,25) for b in (12,16,24,32)]
        for (config,power,cap),x in zip(cases,old):
            r=geometry('legacy',config+'/artifact_pimpl',power,cap)
            self.assertEqual(r['filter_bytes'],x['backing_bytes']);self.assertEqual(r['constructor_argument'],x['constructor_bits']);self.assertEqual(r['address'],x['address'])
    def test_valid_all_families(self):
        for w in ('legacy','modern'):
            for n in names(w):
                c,r=fixture(w,n);validate(r,c)
                f=io.StringIO();writer=csv.DictWriter(f,fieldnames=FIELDS);writer.writeheader();writer.writerow(r);self.assertEqual(parse_one(f.getvalue()),r)
    def test_missing_rows(self):
        with self.assertRaises(ValueError):parse_one(','.join(FIELDS)+'\n')
    def test_present_count(self):
        c,r=fixture();r['present_queries']=str(int(r['present_queries'])-1);r['absent_queries']=str(int(r['absent_queries'])+1)
        with self.assertRaises(ValueError):validate(r,c)
    def test_metadata_and_scratch(self):
        for key,value in [('public_metadata','{}'),('raw_batch1_scratch_bytes','8'),('filter_bytes','1'),('calibration_false_positives','4097')]:
            c,r=fixture();r[key]=value
            with self.assertRaises((ValueError,KeyError)):validate(r,c)
        c,r=fixture('modern','PageBloom4Default');meta=json.loads(r['public_metadata']);meta['key_bytes']=8;r['public_metadata']=json.dumps(meta)
        with self.assertRaises(ValueError):validate(r,c)
    def test_trial_guards(self):
        c,r=fixture(repeats=6);validate(r,c)
        for key,value in [('raw_single_ns','1'),('raw_batch1_trials_ns','1|2'),('query_phase_order','012|012|012|012|012|012'),('insert_ns','0')]:
            t=copy.deepcopy(r);t[key]=value
            with self.assertRaises(ValueError):validate(t,c)
        c,r=fixture();r['raw_single_ns']='1'
        with self.assertRaises(ValueError):validate(r,c)
    def test_alias_no_pool(self):
        c,a=fixture('legacy','sector32-u1/artifact_pimpl');_,b=fixture('legacy','sector32-u4/public_static')
        self.assertEqual(parity([a,b]),1);b['calibration_false_positives']='2'
        with self.assertRaises(ValueError):parity([a,b])
    def test_native_context_controls(self):
        _,a=fixture('legacy','FastPatternBF');_,b=fixture('modern','FastPatternBF')
        self.assertEqual(parity([a,b]),1);b['query_checksum']='7'
        with self.assertRaises(ValueError):parity([a,b])
    def test_new_output_guard(self):
        from source_guard import module,STAGE2
        guard=module('startup_guard_test',STAGE2/'startup_guards.py')
        with tempfile.TemporaryDirectory() as d:
            with self.assertRaises(ValueError):guard.require_new_build_root(Path(d))
            guard.require_new_build_root(Path(d)/'new')
    def test_existing_unlocked_descriptor_rejected(self):
        from unittest.mock import patch
        from source_guard import module,STAGE2
        guard=module('startup_lock_test',STAGE2/'startup_guards.py')
        with patch.object(guard.os,'sched_getaffinity',return_value={2}),patch.object(guard.os,'listdir',return_value=['9']),patch.object(guard.os,'readlink',return_value='/tmp/fastest-bf-socket0.lock'),patch.object(guard.Path,'read_text',return_value='pos:\t0\n'):
            with self.assertRaises(ValueError):guard.require_inherited_write_lock(2,'socket0')

if __name__=='__main__':unittest.main()
