import copy
import subprocess
import sys
import unittest
from pathlib import Path
from contract import FIELDS,METRICS,next_value,order,scratch,validate,semantic
from validate import command

def rows(language='cpp',cap=16,t=3):
    n,q=1<<16,1<<14;present=q//100*50+min(q%100,50);names=['Split64Range']if cap==24 else['Split64','Split64Range']
    result=[]
    for name in order(names,n,q,42,50):
        row={key:''for key in FIELDS}
        values=dict(language=language,filter=name,keys=n,queries=q,requested_bpk=cap,filter_bytes=n*cap//8,actual_bpk=cap,core_budget=t,build_workers=t,query_workers=t,
          estimated_build_scratch_bytes=scratch(language,n,t),repeats=4,seed=42,hit_percent=50,present_queries=present,absent_queries=q-present,false_positives=1,result_checksum=42,
          calibration_absent_queries=4096,calibration_false_positives=0,key_base=next_value(42)[1]%((1<<32)-n-q),input_mode='prehashed64',
          scheduler_model='caller_worker0'if language=='cpp'else'scoped_workers_plus_caller',build_spawned_workers_per_pass=t-1 if language=='cpp'else 0 if t==1 else t,
          query_spawned_workers=t-1 if language=='cpp'else 0 if t==1 else t,query_contract='whole_array_native_api',phase_order='build_williams4_query_alternating',parallel_first_touch='insert_cpu3_allocate_allowed_set')
        row.update({k:str(v)for k,v in values.items()})
        for metric in METRICS:
            row.update({metric+'_ns':'2.5',metric+'_min_ns':'1',metric+'_max_ns':'4',metric+'_trials_ns':'1|2|3|4'})
        result.append(row)
    return result

class Guards(unittest.TestCase):
    def test_every_small_geometry_and_real_workers(self):
        for language in ('cpp','rust'):
            for cap in (16,24,32):
                for t in (1,3):validate(rows(language,cap,t),language,cap,t)
    def test_nonfallback_and_scratch_mandatory(self):
        for key in ('build_workers','query_workers','core_budget','estimated_build_scratch_bytes','build_spawned_workers_per_pass'):
            r=rows();r[0][key]='1'
            with self.assertRaises(ValueError):validate(r,'cpp',16,3)
        self.assertEqual(scratch('cpp',65536,3),8*65536+224)
        self.assertEqual(scratch('rust',65536,3),8*65536+584)
    def test_partial_order_and_bad_vector(self):
        for r in (rows()[:-1],list(reversed(rows()))):
            with self.assertRaises(ValueError):validate(r,'cpp',16,3)
        r=rows();r[0]['parallel_insert_trials_ns']='1|nan|3|4'
        with self.assertRaises(ValueError):validate(r,'cpp',16,3)
    def test_semantics_cross_language_exclude_runtime_cost(self):
        a=rows('cpp');b=rows('rust');self.assertEqual(list(map(semantic,a)),list(map(semantic,b)))
    def test_child_affinity_and_negative_argument_indices(self):
        c=command('/binary',16,3)
        self.assertEqual(c[:7],['taskset','-c','3,5,7','numactl','--physcpubind=3,5,7','--membind=1','/binary'])
        self.assertEqual((c[-2],c[-6],c[-4]),('Split64,Split64Range','4','50'))
    def test_optimized_python_rejected(self):
        r=subprocess.run([sys.executable,'-O',str(Path(__file__).parent/'validate.py'),'--help'],capture_output=True,text=True)
        self.assertNotEqual(r.returncode,0);self.assertIn('Python -O is forbidden',r.stderr)

if __name__=='__main__':unittest.main()
