import copy
import unittest
from contract import cases,command,comparable,parse,quality,validate,wilson
from derive_selection import derive

def original():
    case=next(c for c in cases()if c['policy']=='original')
    row=dict(case['geometry'],**case['old_semantics'],worker='legacy',repeats='0',build_repeats='0',
             query_phase_order='untimed',build_hash_scratch_bytes='0',filter_build_scratch_bytes='0',adapter_object_bytes='256')
    for mode,scratch in [('raw_single',0),('raw_batch1',4),('raw_batch4096',16384)]:
        for suffix in ['_ns','_trials_ns','_min_ns','_max_ns']:row[mode+suffix]='nan'
        row[mode+'_scratch_bytes']=str(scratch)
    for key in ['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:row[key]='nan'
    return case,row

class Contract(unittest.TestCase):
    def test_fixed_grid_and_committed_derivation(self):
        self.assertEqual(cases(),derive()['cases']);self.assertEqual(len(cases()),36)
        self.assertEqual(sum(c['policy']=='original'for c in cases()),24)
        self.assertEqual(len({(c['filter'],c['power'],c['cap'],c['policy'])for c in cases()}),36)
        for case in cases():
            self.assertEqual(case['status'],'supported')
            self.assertLessEqual(int(case['geometry']['filter_bytes']),(1<<case['power'])*case['cap']//8)
    def test_original_exact_semantics_and_metadata(self):
        case,row=original();validate(row,case)
        for key in ['calibration_false_positives','result_checksum','query_checksum','unit_count']:
            bad=dict(row);bad[key]=str(int(bad[key])+1)
            with self.assertRaises(ValueError):validate(bad,case)
        bad=dict(row);bad['public_metadata']='{}'
        with self.assertRaises(ValueError):validate(bad,case)
    def test_no_timing_and_exact_physical_scratch(self):
        case,row=original()
        for key,value in [('repeats','1'),('build_repeats','1'),('raw_single_ns','1.0'),
                          ('raw_batch1_trials_ns','0.0'),('raw_batch4096_scratch_bytes','4')]:
            bad=dict(row);bad[key]=value
            with self.assertRaises(ValueError):validate(bad,case)
    def test_exact_present_and_negative_counts(self):
        case,row=original()
        for key in ['present_queries','absent_queries','calibration_absent_queries']:
            bad=dict(row);bad[key]=str(int(bad[key])+1)
            with self.assertRaises(ValueError):validate(bad,case)
    def test_fixed_command_and_single_row(self):
        case,_=original();argv=command('/binary',case)
        self.assertEqual(argv[1],'--check');self.assertEqual(argv[9],'0');self.assertEqual(argv[10],'original')
        tiny=command('/binary',case,tiny=True)
        self.assertEqual((tiny[3],tiny[5],tiny[8]),('16','12','10'))
        for text in ['', 'a,b\n1\n', 'a,b\n1,2\n3,4\n']:
            with self.assertRaises(ValueError):parse(text)
    def test_wilson_unpooled_and_full_ledger(self):
        self.assertEqual(wilson(0,1024)[0],0);self.assertEqual(wilson(1024,1024)[1],1)
        for bad in [(-1,10),(11,10),(0,0)]:
            with self.assertRaises(ValueError):wilson(*bad)
        with self.assertRaises(ValueError):quality([])

if __name__=='__main__':unittest.main()
