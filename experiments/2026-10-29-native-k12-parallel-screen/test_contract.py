import copy,unittest
from contract import *
def vector(row,median,minimum,maximum,trials,values):
 row.update({median:str(statistics.median(values)),minimum:str(min(values)),maximum:str(max(values)),trials:'|'.join(map(str,values))})
def fixture(case):
 p=case['point'];n=p['keys'];g=p['geometry'];r={'language':'cpp','filter':p['filter'],'keys':str(n),'queries':str(Q),'seed':str(case['seed']),'requested_bpk':g['requested_bpk'],'filter_bytes':g['filter_bytes'],'actual_bpk':str(int(g['filter_bytes'])*8/n),'present_queries':str(Q//100*50+min(Q%100,50)),'absent_queries':str(Q-(Q//100*50+min(Q%100,50))),'false_positives':'10','result_checksum':'123'}
 for field in INPUTS:r[field]=str(n+case['seed'])
 if case['track']=='shared_query':
  r.update({k:g[k]for k in GEOMETRY});r.update(implementation_origin=p['owner'],size_contract='exact_byte_ceiling_v1',measurement_mode='query_only',input_mode='prehashed',hash_bits='64',hit_percent='50',batch='4096',repeats='8',insert_batch=str(n),threads='8',spawned_threads='7',build_repeats='0',harness_hash_scratch_bytes='32768',parallel_hash_scratch_bytes='262144',calibration_absent_queries=str(CAL),calibration_false_positives='100',executor='caller_worker0',query_phase_order=expected_schedule(case['seed'],8),fpr=str(10/int(r['absent_queries'])))
  for key in ['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:r[key]='nan'
  r['filter_build_scratch_bytes']=str((1+int(g['filter_bytes'])//32//16384)*(16384*8+4)if p['filter']=='FastFilterFixed32Bulk'else 0)
  for prefix in ['','hash_']:vector(r,prefix+'lookup_ns',prefix+'lookup_min_ns',prefix+'lookup_max_ns',prefix+'lookup_trials_ns',list(range(1,9)))
  for phase in ['parallel_lookup','parallel_hash_lookup']:
   for kind,values in [('gated',list(range(1,9))),('end_to_end',list(range(3,11)))]:vector(r,phase+'_'+kind+'_ns',phase+'_'+kind+'_min_ns',phase+'_'+kind+'_max_ns',phase+'_'+kind+'_trials',values)
   for kind in ['launch','join']:r[phase+'_'+kind+'_ns']='1';r[phase+'_'+kind+'_trials']='|'.join(['1']*8)
 else:
  copied=p['filter']!='Split64BloomFilter';bitmap=int(g['filter_bytes'])if copied else 0
  r.update(measurement_mode='prehashed_native_public_api',new_calibration_samples='0',repeats='6',paired_phase_order=';'.join(['1|8','8|1']*3),native_constructor_argument=g['native_constructor_bpk']if not copied else g['requested_bpk'],build_workers_t1='1',build_workers_t8='8',query_workers_t1='1',query_workers_t8='8',build_scratch_bytes_t1='0',build_scratch_bytes_t8=str(n*8+584),public_bitmap_compared=str(int(copied)),validation_bitmap_bytes=str(bitmap),validation_expected_output_bytes=str(Q*4),caller_buffer_bytes=str(16*n+24*Q+128+bitmap))
  for metric in ['insert_t1','allocate_insert_t1','insert_t8','allocate_insert_t8','lookup_t1','lookup_t8']:vector(r,metric+'_ns',metric+'_min_ns',metric+'_max_ns',metric+'_trials_ns',list(range(1,7)))
 return {'case':case,'row':r}
class Contract(unittest.TestCase):
 def setUp(self):self.records=[fixture(c)for c in plan()]
 def test_complete_fixed195(self):
  result=validate_complete(self.records);self.assertEqual(result['shared_query_rows'],147);self.assertEqual(result['native_public_rows'],48)
 def test_empty_success_and_missing_rows(self):
  with self.assertRaises(ValueError):parse('filter,keys\n')
  with self.assertRaises(ValueError):validate_complete(self.records[:-1])
 def test_changed_order_geometry_and_hits(self):
  for change in ['order','geometry','hits']:
   records=copy.deepcopy(self.records)
   if change=='order':records[0],records[1]=records[1],records[0]
   else:records[0]['row']['filter_bytes'if change=='geometry'else'present_queries']='1'
   with self.assertRaises(ValueError):validate_complete(records)
 def test_trial_and_seeded_phase(self):
  for field,value in [('lookup_ns','99'),('query_phase_order',expected_schedule(42,8)),('parallel_lookup_end_to_end_ns','0'),('insert_ns','3')]:
   records=copy.deepcopy(self.records);records[0]['row'][field]=value
   with self.assertRaises(ValueError):validate_complete(records)
 def test_public_identity_and_auxiliary_memory(self):
  for field,value in [('result_checksum','99'),('query_workers_t8','1'),('validation_bitmap_bytes','1'),('new_calibration_samples','1')]:
   records=copy.deepcopy(self.records);records[-1]['row'][field]=value
   with self.assertRaises(ValueError):validate_complete(records)
 def test_alias_no_extra_quality_or_repaired_failure(self):
  seen={};records=copy.deepcopy(self.records);found=False
  for entry in records[:147]:
   c=entry['case'];p=c['point'];key=(p['keys'],p['geometry']['calibration_identity'],c['seed'])
   if key in seen:entry['row']['calibration_false_positives']='101';found=True;break
   seen[key]=True
  self.assertTrue(found)
  with self.assertRaises(ValueError):validate_complete(records)
 def test_input_and_native_nested_interval(self):
  records=copy.deepcopy(self.records);records[-1]['row']['query_hash_checksum']='7'
  with self.assertRaises(ValueError):validate_complete(records)
  records=copy.deepcopy(self.records);r=records[-1]['row'];vector(r,'allocate_insert_t8_ns','allocate_insert_t8_min_ns','allocate_insert_t8_max_ns','allocate_insert_t8_trials_ns',[.5]*6)
  with self.assertRaises(ValueError):validate_complete(records)
if __name__=='__main__':unittest.main()
