import copy,unittest
import run
class LoaderGuards(unittest.TestCase):
 def good(self):return dict(complete=True,producer_commit=run.PRODUCER,launcher_exit_code=0,session_id=98863,files={name:dict(bytes=0,sha256='0'*64)for name in run.raw_paths()})
 def test_exact45_members(self):
  self.assertEqual(len(run.raw_paths()),45);run.raw_manifest(self.good())
 def test_incomplete_extra_or_missing(self):
  good=self.good()
  for mutate in [lambda x:x.update(complete=False),lambda x:x['files'].pop('results-v1/case-17.stdout'),lambda x:x['files'].update({'unexpected':dict(bytes=0,sha256='0'*64)}),lambda x:x.update(launcher_exit_code=143),lambda x:x.update(session_id=1)]:
   bad=copy.deepcopy(good);mutate(bad)
   with self.assertRaises(ValueError):run.raw_manifest(bad)
 def test_immutable_refs(self):
  for value in ['HEAD','075b4fd','A'*40,'0'*39]:
   with self.assertRaises(ValueError):run.full_commit(value)
  self.assertEqual(run.full_commit('0'*40),'0'*40)
 def test_hash_byte_and_producer_identity(self):
  for key,value in [('sha256','0'*63),('bytes',-1)]:
   bad=self.good();bad['files']['launch-v1.stdout'][key]=value
   with self.assertRaises(ValueError):run.raw_manifest(bad)
  bad=self.good();bad['producer_commit']='0'*40
  with self.assertRaises(ValueError):run.raw_manifest(bad)
if __name__=='__main__':unittest.main()
