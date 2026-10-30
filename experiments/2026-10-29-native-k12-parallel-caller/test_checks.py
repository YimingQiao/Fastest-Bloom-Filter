import copy,unittest
from checks import NAMES,SEMANTICS,expected_schedule,query_rows,public_row

def query_fixture():
 out=[]
 for name in NAMES:
  r={k:'1'for k in SEMANTICS};r.update(filter=name,keys='32768',queries='32768',requested_bpk='24',batch='4096',repeats='4',seed='101',threads='8',spawned_threads='7',build_repeats='0',calibration_absent_queries='4096',insert_batch='32768',harness_hash_scratch_bytes='32768',parallel_hash_scratch_bytes='262144',measurement_mode='query_only',filter_bytes='98304',present_queries='16400',absent_queries='16368',calibration_false_positives='1',query_phase_order=expected_schedule(101,4))
  for field in ['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:r[field]='nan'
  for prefix in ['','hash_']:
   r.update({prefix+'lookup_ns':'2.5',prefix+'lookup_min_ns':'1',prefix+'lookup_max_ns':'4',prefix+'lookup_trials_ns':'1|2|3|4'})
  for phase in ['parallel_lookup','parallel_hash_lookup']:
   for kind in ['end_to_end','gated']:r.update({phase+'_'+kind+'_ns':'2.5',phase+'_'+kind+'_min_ns':'1',phase+'_'+kind+'_max_ns':'4',phase+'_'+kind+'_trials':'1|2|3|4'})
  out.append(r)
 return out
class Checks(unittest.TestCase):
 def test_valid_complete_registry(self):self.assertEqual(len(query_rows(query_fixture())),15)
 def test_missing_and_duplicate_alias(self):
  for bad in [query_fixture()[:-1],query_fixture()[:-1]+[query_fixture()[0]]]:
   with self.assertRaises(ValueError):query_rows(bad)
 def test_disabled_builds_and_exact_hits(self):
  for key,value in [('insert_ns','2'),('present_queries','16384'),('build_repeats','1')]:
   rows=query_fixture();rows[0][key]=value
   with self.assertRaises(ValueError):query_rows(rows)
 def test_balanced_but_wrong_seed(self):
  rows=query_fixture();rows[0]['query_phase_order']='0|1|3|2;1|2|0|3;2|3|1|0;3|0|2|1'
  self.assertNotEqual(rows[0]['query_phase_order'],expected_schedule(101,4))
  with self.assertRaises(ValueError):query_rows(rows)
 def test_trial_summary_corruption(self):
  rows=query_fixture();rows[0]['parallel_lookup_gated_ns']='3'
  with self.assertRaises(ValueError):query_rows(rows)
 def test_public_full_identity_and_reference_memory(self):
  reference=query_fixture()[4];r=copy.deepcopy(reference);r.update(repeats='2',paired_phase_order='1|8;8|1',measurement_mode='prehashed_native_public_api',new_calibration_samples='0',build_workers_t1='1',build_workers_t8='8',query_workers_t1='1',query_workers_t8='8',build_scratch_bytes_t1='0',build_scratch_bytes_t8='300000',public_bitmap_compared='1',validation_bitmap_bytes='98304',validation_expected_output_bytes='131072',caller_buffer_bytes='2000000')
  for metric in ['insert_t1','allocate_insert_t1','insert_t8','allocate_insert_t8','lookup_t1','lookup_t8']:r.update({metric+'_ns':'1.5',metric+'_min_ns':'1',metric+'_max_ns':'2',metric+'_trials_ns':'1|2'})
  public_row(r,reference)
  for key,value in [('result_checksum','99'),('false_positives','99'),('query_workers_t8','1'),('validation_bitmap_bytes','0')]:
   bad=copy.deepcopy(r);bad[key]=value
   with self.assertRaises(ValueError):public_row(bad,reference)
if __name__=='__main__':unittest.main()
