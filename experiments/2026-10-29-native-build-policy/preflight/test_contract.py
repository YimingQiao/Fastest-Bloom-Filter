import copy
import json
from pathlib import Path
import subprocess
import sys
import unittest
from contract import cases,scratch,semantic,validate_protocol,validate_real,validate_spy
from validate import command

def rows(language):
    result=[]
    for case in cases():
        auto=16 if language=='cpp'else 3
        effective=1 if case['case']in (0,2)else case['requested']
        candidate=auto if effective==0 else effective;control=auto if case['requested']==0 else case['requested']
        result.append(dict(language=language,**case,query_n=32771,control_effective=case['requested'],candidate_effective=effective,
          native_auto_workers=auto,candidate_auto_workers=1 if case['case']in (0,2)else auto,
          control_workers=control,candidate_workers=candidate,control_scratch=scratch(language,case['batch_n'],control),
          candidate_scratch=scratch(language,case['batch_n'],candidate),checksum=42,positives=21848,
          checked_history_per_variant=case['history_n'],checked_new_per_variant=case['batch_n'],variants=3,full_mixed_checks_per_variant=2,performance_run=False))
    return result

class Guards(unittest.TestCase):
    def test_explicit_protocol_ledger(self):
        value=json.loads((Path(__file__).parent/'protocol.json').read_text());validate_protocol(value)
        value['real_case_ledger'][3]['requested']=1
        with self.assertRaises(ValueError):validate_protocol(value)
    def test_exact_minimal_coverage(self):
        for language in ('cpp','rust'):self.assertEqual(validate_real('\n'.join(map(json.dumps,rows(language))),language),rows(language))
        self.assertEqual(list(map(semantic,rows('cpp'))),list(map(semantic,rows('rust'))))
    def test_missing_duplicate_order_and_schema(self):
        original=rows('cpp')
        for bad in ([],original[:-1],original+original[:1],original[:1]+original[:11],list(reversed(original))):
            with self.assertRaises(ValueError):validate_real('\n'.join(map(json.dumps,bad)),'cpp')
        bad=copy.deepcopy(original);bad[0]['ns']=1
        with self.assertRaises(ValueError):validate_real('\n'.join(map(json.dumps,bad)),'cpp')
    def test_effective_scratch_and_full_history_mandatory(self):
        for index,key,value in ((0,'candidate_effective',8),(0,'candidate_scratch',42),(1,'candidate_workers',1),(5,'candidate_workers',1),
          (5,'checked_history_per_variant',4096),(2,'checked_new_per_variant',4096),(0,'full_mixed_checks_per_variant',1)):
            bad=rows('cpp');bad[index][key]=value
            with self.assertRaises(ValueError):validate_real('\n'.join(map(json.dumps,bad)),'cpp')
    def test_geometry_uses_actual_footprint(self):
        data=rows('cpp');self.assertEqual(data[3]['bytes'],524288);self.assertEqual(data[9]['bytes'],262208)
        self.assertEqual(data[5]['bytes'],67108864);self.assertEqual(data[11]['bytes'],100663296)
        self.assertEqual(data[5]['history_n'],33554432);self.assertEqual(data[11]['history_n'],50331648)
    def test_automatic_workers_are_language_relative(self):
        cpp=rows('cpp');rust=rows('rust');self.assertEqual(cpp[4]['requested'],0)
        self.assertEqual(cpp[4]['control_workers'],16);self.assertEqual(rust[4]['control_workers'],3)
        self.assertEqual(semantic(cpp[4]),semantic(rust[4]))
        bad=rows('rust');bad[4]['candidate_workers']=16
        with self.assertRaises(ValueError):validate_real('\n'.join(map(json.dumps,bad)),'rust')
        self.assertEqual(cpp[3]['requested'],8);self.assertEqual(cpp[0]['requested'],1)
    def test_spy_all_requests_and_boundaries(self):
        good=dict(language='cpp',spy_cases=336,forwarded_calls=2016,performance_run=False)
        validate_spy(json.dumps(good),'cpp')
        for key,value in (('spy_cases',168),('forwarded_calls',336),('language','rust'),('performance_run',True)):
            with self.assertRaises(ValueError):validate_spy(json.dumps(good|{key:value}),'cpp')
    def test_child_expansion_before_numactl_both_sockets(self):
        for cpu in (2,3):
            cpus=[cpu,cpu+2,cpu+4];text=','.join(map(str,cpus));argv=command('/binary','--real',dict(child_cpus=cpus,node=cpu-2))
            self.assertEqual(argv,['taskset','-c',text,'numactl','--physcpubind='+text,'--membind='+str(cpu-2),'/binary','--real'])
    def test_optimized_python_fails_before_work(self):
        process=subprocess.run([sys.executable,'-O',str(Path(__file__).parent/'validate.py'),'--help'],capture_output=True,text=True)
        self.assertNotEqual(process.returncode,0);self.assertIn('Python -O is forbidden',process.stderr)

if __name__=='__main__':unittest.main()
