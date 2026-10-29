import unittest
import derive
class Guards(unittest.TestCase):
 def test_jump_matches_loop_and_nonhalf_hit_count(self):
  for seed in [0,42,(1<<64)-1]:
   for n,q,hit in [(128,4096,50),(64,32,0),(64,32,100)]:
    got,base,present,draws=derive.workload(seed,n,q,hit);r=derive.Random(seed);self.assertEqual(r.next()%((1<<32)-n-q),base)
    for _ in range(draws):r.next()
    self.assertEqual(got.state,r.state)
  self.assertEqual(derive.workload(42,65536,1<<22,50)[2],2097154)
 def test_complete_fixed_catalog_and_nested_counts(self):
  d=derive.derive();cases=d['commands.json']['cases'];self.assertEqual(len(cases),18);self.assertEqual(sum(c['expected_rows']for c in cases),786)
  self.assertEqual(sorted(set(c['expected_rows']for c in cases)),[41,45])
  for c in cases:self.assertEqual(len(c['row_order']),len(set(c['row_order'])))
  for c in cases:self.assertEqual(c['command'][:3],['/usr/bin/numactl','--physcpubind=2','--membind=0']);self.assertEqual(c['command'][4:],c['binary_arguments'])
  self.assertEqual(sum(c['expected_rows']for c in cases if c['calibration_exponent']),262)
  self.assertEqual(sum(c['expected_rows']for c in cases if not c['calibration_exponent']),524)
  for c in cases:self.assertEqual(c['binary_arguments'][-1],'24'if c['batch']==1 else'0')
  self.assertEqual(262*3*3*3*4,28296);self.assertEqual(144*3*3*3*4,15552)
 def test_domains_and_batch_reuse(self):
  cases=derive.derive()['commands.json']['cases']
  for c in cases:
   self.assertEqual(c['inserted_interval'][1],c['mixed_absent_envelope'][0]);self.assertEqual(c['mixed_absent_envelope'][1],c['quality_calibration_interval'][0]);self.assertEqual(c['quality_calibration_interval'][1]-c['quality_calibration_interval'][0],1<<24)
   self.assertEqual(c['calibration_interval'],c['quality_calibration_interval']if c['batch']==1 else None)
  for i in range(0,18,3):
   a,b,c=cases[i:i+3];self.assertEqual(a['row_order'],b['row_order']);self.assertEqual(b['row_order'],c['row_order']);self.assertEqual(a['key_base'],c['key_base'])
   self.assertEqual([x['quality_source_case_index']for x in [a,b,c]],[i,i,i])
 def test_two_phase_balance(self):
  orders=derive.phase(42,8);self.assertEqual(len(orders),8)
  for position in [0,1]:self.assertEqual(sum(row[position]==0 for row in orders),4)
if __name__=='__main__':unittest.main()
