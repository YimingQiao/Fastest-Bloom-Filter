import copy
import json
from pathlib import Path
import subprocess
import sys
import unittest
from contract import FIELDS,METRICS,CPUS,cases,command,complete,order,scratch,validate,_tiny
import placement

PROTOCOL=json.loads((Path(__file__).parent/'protocol.json').read_text())

def fixture(case):
    n,q=1<<case['key_power'],1<<PROTOCOL['query_power'];t,cap=case['threads'],case['budget_bpk'];language=case['language']
    present=q//100*50+min(q%100,50);result=[]
    for name in order(case['filters'],n,q,42,50):
        row={key:''for key in FIELDS}
        row.update({key:str(value)for key,value in dict(language=language,filter=name,keys=n,queries=q,requested_bpk=cap,filter_bytes=n*cap//8,
          actual_bpk=cap,core_budget=t,build_workers=t,query_workers=t,estimated_build_scratch_bytes=scratch(language,n,t),repeats=4,seed=42,
          hit_percent=50,present_queries=present,absent_queries=q-present,false_positives=1,result_checksum=42,calibration_absent_queries=1<<24,
          calibration_false_positives=1,key_base=_tiny.next_value(42)[1]%((1<<32)-n-q),input_mode='prehashed64',
          scheduler_model='caller_worker0'if language=='cpp'else'scoped_workers_plus_caller',
          build_spawned_workers_per_pass=t-1 if language=='cpp'else 0 if t==1 else t,query_spawned_workers=t-1 if language=='cpp'else 0 if t==1 else t,
          query_contract='whole_array_native_api',phase_order='build_williams4_query_alternating',parallel_first_touch='insert_cpu3_allocate_allowed_set').items()})
        for metric in METRICS:row.update({metric+'_ns':'2.5',metric+'_min_ns':'1',metric+'_max_ns':'4',metric+'_trials_ns':'1|2|3|4'})
        result.append(row)
    return result

def placed():
    return dict(parent_affinity=[3],lease=dict(cpu=3,lease='socket1',lock_path='/tmp/fastest-bf-socket1.lock',inherited_lock_descriptors=[3]),
      lease_mode='FLOCK ADVISORY WRITE',environment={'BF_SOCKET_LEASE':'socket1-cpu3'},topology=[dict(cpu=c,socket=1,core=i,nodes=[1])for i,c in enumerate(CPUS)])

class Guards(unittest.TestCase):
    def test_complete_grid_without_pooling(self):
        rows=[row for case in cases(PROTOCOL)for row in fixture(case)]
        self.assertEqual(complete(rows,PROTOCOL),dict(rows=60,commands=36,semantic_geometries=10,language_quality_records=20,pooled_samples=False))
    def test_partial_duplicate_reordered_rows(self):
        case=cases(PROTOCOL)[0];rows=fixture(case)
        for value in ([],rows[:-1],rows+rows[:1],list(reversed(rows))):
            with self.assertRaises(ValueError):validate(value,case,PROTOCOL)
    def test_workers_and_scratch_are_exact(self):
        case=cases(PROTOCOL)[4]
        self.assertEqual(case['threads'],8)
        for key in ('build_workers','query_workers','core_budget','estimated_build_scratch_bytes','build_spawned_workers_per_pass','query_spawned_workers'):
            rows=fixture(case);rows[0][key]='1'
            with self.assertRaises(ValueError):validate(rows,case,PROTOCOL)
        self.assertEqual(scratch('cpp',65536,8),8*65536+584)
        self.assertEqual(scratch('rust',65536,8),8*65536+2504)
    def test_all_metrics_and_vectors_required(self):
        case=cases(PROTOCOL)[0]
        for metric in METRICS:
            for suffix,value in (('_trials_ns','1|2|3'),('_trials_ns','1|nan|3|4'),('_min_ns','2'),('_max_ns','3'),('_ns','3')):
                rows=fixture(case);rows[0][metric+suffix]=value
                with self.assertRaises(ValueError):validate(rows,case,PROTOCOL)
    def test_same_mapping_cross_t_and_language(self):
        for index,key in ((2,'result_checksum'),(4,'calibration_false_positives'),(2,'false_positives')):
            rows=[row for case in cases(PROTOCOL)for row in fixture(case)];rows[index][key]='2'
            with self.assertRaises(ValueError):complete(rows,PROTOCOL)
    def test_capacity_and_quality_denominator(self):
        case=cases(PROTOCOL)[0]
        for key,value in (('filter_bytes','1'),('actual_bpk','24'),('calibration_absent_queries','33554432'),('false_positives','999999999'),('result_checksum',str(1<<64))):
            rows=fixture(case);rows[0][key]=value
            with self.assertRaises(ValueError):validate(rows,case,PROTOCOL)
    def test_frozen_workload_and_language_order(self):
        self.assertEqual([c['language']for c in cases(PROTOCOL)[:4]],['cpp','rust','cpp','rust'])
        p=copy.deepcopy(PROTOCOL);p['seed']=43
        with self.assertRaises(ValueError):cases(p)
    def test_affinity_expands_before_numactl(self):
        case=cases(PROTOCOL)[4];cmd=command('/binary',case,PROTOCOL);cpus=','.join(map(str,CPUS))
        self.assertEqual(cmd[:7],['taskset','-c',cpus,'numactl','--physcpubind='+cpus,'--membind=1','/binary'])
        self.assertEqual(cmd[-1],cpus);self.assertEqual(cmd[-6],'4');self.assertEqual(cmd[-4],'50')
    def test_recorded_placement_corruptions(self):
        placement.validate(placed())
        for mutate in (lambda x:x.update(parent_affinity=[3,5]),lambda x:x.update(lease_mode='FLOCK ADVISORY READ'),
          lambda x:x['lease'].update(inherited_lock_descriptors=[]),lambda x:x['lease'].update(cpu=2),lambda x:x['lease'].update(lock_path='/tmp/other'),
          lambda x:x['environment'].update(LD_PRELOAD='/bad'),lambda x:x['environment'].update(BF_SOCKET_LEASE='wrong'),
          lambda x:x['topology'][0].update(socket=0),lambda x:x['topology'][0].update(nodes=[0]),lambda x:x['topology'][0].update(core=1),
          lambda x:x['topology'].reverse()):
            value=placed();mutate(value)
            with self.assertRaises(ValueError):placement.validate(value)
    def test_optimized_python_rejected(self):
        for name in ('run.py','audit.py','freeze.py'):
            result=subprocess.run([sys.executable,'-O',str(Path(__file__).parent/name),'--help'],capture_output=True,text=True)
            self.assertNotEqual(result.returncode,0);self.assertIn('Python -O is forbidden',result.stderr)

if __name__=='__main__':unittest.main()
