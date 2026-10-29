import json,tempfile,unittest
from pathlib import Path
from checks import artifact,fixture,CPUS
class Checks(unittest.TestCase):
 def text(self):
  rows=[]
  for b in[192,1088,2097216]:
   for w in[3,7]:
    for hot in['false','true']:rows.append(f'case={len(rows)+1},bytes={b},workers_requested={w},workers_actual={min(w,b//64)},hotspot={hot},backend=avx512,words={b//4}')
  return '\n'.join(rows+['complete=true,cases=12,checksum=42,timing=false,calibration=0'])+'\n'
 def test_fixture_coverage(self):
  d=fixture(self.text(),'avx512');self.assertEqual(len(d['cases']),12);self.assertEqual(d['checksum'],42);self.assertEqual(CPUS,[3,5,7,9,11,13,15])
 def test_silent_serial_fallback_rejected(self):
  with self.assertRaises(ValueError):fixture(self.text().replace('workers_actual=7','workers_actual=1'))
 def test_wrong_backend_and_incomplete_rejected(self):
  with self.assertRaises(ValueError):fixture(self.text(),'avx2')
  with self.assertRaises(ValueError):fixture(self.text().split('\n',1)[1])
 def test_structured_artifact_identity(self):
  with tempfile.TemporaryDirectory()as tmp:
   target=Path(tmp);binary=target/'test';binary.write_text('bound bytes');manifest=target/'Cargo.toml';source=target/'lib.rs'
   package=dict(name='native',manifest_path=str(manifest),targets=[dict(name='native',kind=['lib'],src_path=str(source))])
   e=dict(reason='compiler-artifact',package_id='path+file:///native#0.1.0',manifest_path=str(manifest),target=package['targets'][0],profile=dict(test=True),executable=str(binary))
   packages={e['package_id']:package};self.assertEqual(artifact(json.dumps(e),'native',True,target,packages),binary)
   e['manifest_path']=str(target/'other.toml')
   with self.assertRaises(ValueError):artifact(json.dumps(e),'native',True,target,packages)

class CargoStem(unittest.TestCase):
 def event(self, root, name, package='caller'):
  manifest=root/package/'Cargo.toml';source=manifest.parent/'src/main.rs'
  target=dict(name=name,kind=['bin'],src_path=str(source));pkg='path+file://'+str(manifest.parent)+'#'+package+'@0.0.0'
  return dict(reason='compiler-artifact',manifest_path=str(manifest),package_id=pkg,target=target,filenames=[str(root/'target'/name)]),{pkg:dict(manifest_path=str(manifest),targets=[target])}
 def test_exact_normalized_stem(self):
  from dependencies import cargo_roots,owner_for
  with tempfile.TemporaryDirectory()as tmp:
   root=Path(tmp);event,packages=self.event(root,'native-rust-k12-port-proof');owners=cargo_roots([json.dumps(event)],root/'target',packages)
   owner=owner_for(root/'target/deps/native_rust_k12_port_proof-0123456789abcdef.d',owners)
   self.assertEqual(owner['package_id'],event['package_id'])
   self.assertIsNone(owner_for(root/'target/deps/native_rust_k12_port_other-0123456789abcdef.d',owners))
 def test_normalized_collision_rejected(self):
  from dependencies import cargo_roots
  with tempfile.TemporaryDirectory()as tmp:
   root=Path(tmp);first,a=self.event(root,'a-b','first');second,b=self.event(root,'a_b','second')
   with self.assertRaises(ValueError):cargo_roots([json.dumps(first),json.dumps(second)],root/'target',a|b)

if __name__=='__main__':unittest.main()
