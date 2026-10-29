import copy,fcntl,json,os,subprocess,sys,tempfile,unittest
from pathlib import Path
from unittest.mock import patch
import contract,fixtures,lease,pins,row_guard
class Guards(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.rows=fixtures.rows()
 def mutate(self,index,key,value):
  rows=copy.deepcopy(self.rows);rows[index][key]=value
  with self.assertRaises(ValueError):contract.quality(rows)
 def test_complete_coverage(self):
  q=contract.quality(self.rows);self.assertEqual((len(self.rows),q['api_record_count'],q['mapping_record_count'],q['source_rows'],q['reuse_rows']),(786,262,260,262,524))
 def test_exact_commands_and_order(self):
  rows=copy.deepcopy(self.rows);rows[0],rows[1]=rows[1],rows[0]
  with self.assertRaises(ValueError):contract.quality(rows)
  args=list(contract.cases()[0]['binary_arguments']);args[6]='43'
  with self.assertRaises(ValueError):row_guard.row_order(args)
  with self.assertRaises(ValueError):contract.quality(self.rows[:-1])
 def test_geometry_and_scratch(self):
  for key,value in [('filter_bytes','1'),('build_scratch_bytes','999'),('query_scratch_bytes','999')]:self.mutate(0,key,value)
 def test_trial_faults(self):
  for key,value in [('raw_visible_public_trials','nan|'*7+'nan'),('raw_batched_public_ns','999'),('query_phase_order','0|1;'*8)]:self.mutate(0,key,value)
 def test_reuse_output_and_zero_calibration(self):
  first_reuse=contract.cases()[0]['expected_rows']
  self.mutate(first_reuse,'result_checksum',str(int(self.rows[first_reuse]['result_checksum'])^1))
  self.mutate(first_reuse,'calibration_absent_queries',str(1<<24))
  self.mutate(first_reuse,'calibration_false_positives','1')
 def test_known_alias_complete_identity(self):
  rows=copy.deepcopy(self.rows)
  for row in rows:
   if row['keys']=='65536'and row['requested_bpk']=='16'and row['filter']=='Fastbloom017K11':row['result_checksum']=str(int(row['result_checksum'])^1)
  with self.assertRaisesRegex(ValueError,'alias'):contract.quality(rows)
 def test_sanitizers_and_unexpected_exit(self):
  for code,err in [(0,b'AddressSanitizer failure'),(139,b'segfault'),(0,b'runtime error: overflow')]:
   with self.assertRaises(ValueError):row_guard.validate_process(code,b'',err)
 def test_placement(self):
  contract.placement(b'policy: bind\nphyscpubind: 2\nmembind: 0\n',b'',0)
  for out,err,code in [(b'policy: default\nphyscpubind: 2\nmembind: 0\n',b'',0),(b'policy: bind\nphyscpubind: 2 4\nmembind: 0\n',b'',0),(b'policy: bind\nphyscpubind: 2\nmembind: 1\n',b'',0),(b'',b'get_mempolicy: Operation not permitted',0)]:
   with self.assertRaises(ValueError):contract.placement(out,err,code)
 def test_full_raw_replay_and_corruptions(self):
  actual_sha=contract.sha
  def fake_sha(path):return 'synthetic-freeze'if Path(path)==pins.HERE/'freeze.json'else actual_sha(path)
  with tempfile.TemporaryDirectory()as name,patch.object(contract,'sha',fake_sha):
   directory=Path(name);frozen,meta=fixtures.archive(directory,self.rows)
   self.assertEqual(len(contract.audit(directory,fixtures.SOURCE,frozen)[1]),786)
   for key,value in [('cases',18),('source_commit','2'*40),('proof_commit','2'*40),('binary_sha256','0'*64),('affinity',[3]),('environment',{}),('numactl_sha256','0'*64),('complete',False)]:
    bad=copy.deepcopy(meta);bad[key]=value;pins.save(directory/'metadata.json',bad)
    with self.assertRaises(ValueError):contract.audit(directory,fixtures.SOURCE,frozen)
   bad=copy.deepcopy(meta);bad['cases'][1]['command']=bad['cases'][0]['command'];pins.save(directory/'metadata.json',bad)
   with self.assertRaises(ValueError):contract.audit(directory,fixtures.SOURCE,frozen)
   pins.save(directory/'metadata.json',meta);(directory/'results.csv').write_bytes((directory/'results.csv').read_bytes()+b'\n')
   with self.assertRaises(ValueError):contract.audit(directory,fixtures.SOURCE,frozen)
 def test_full_commit_required(self):
  with self.assertRaises(ValueError):pins.verify('HEAD')
 def test_actual_descriptor_requirement(self):
  with tempfile.TemporaryDirectory()as name,patch.dict(os.environ,{'BF_SOCKET_LEASE':'socket0-cpu2'}),patch.object(os,'sched_getaffinity',return_value={2}):
   path=Path(name)/'lock'
   with path.open('w')as handle:
    with self.assertRaises(ValueError):lease.require_lease(str(path))
    fcntl.flock(handle,fcntl.LOCK_SH)
    with self.assertRaises(ValueError):lease.require_lease(str(path))
    fcntl.flock(handle,fcntl.LOCK_EX);evidence=lease.require_lease(str(path));self.assertEqual(evidence['inherited_lock_descriptors'],[handle.fileno()])
    with patch.object(os,'sched_getaffinity',return_value={3}):
     with self.assertRaises(ValueError):lease.require_lease(str(path))
 def test_optimized_python_rejected_at_entry(self):
  result=subprocess.run([sys.executable,'-O',str(pins.HERE/'run.py'),'--help'],capture_output=True)
  self.assertNotEqual(result.returncode,0);self.assertIn(b'Python -O forbidden',result.stderr)
if __name__=='__main__':unittest.main()
