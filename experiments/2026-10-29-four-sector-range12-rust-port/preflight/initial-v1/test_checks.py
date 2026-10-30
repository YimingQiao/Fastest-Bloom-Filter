import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from checks import artifact,fixture,dependencies
HERE=Path(__file__).resolve().parent
class Guards(unittest.TestCase):
    def test_structured_artifact_and_wrong_target(self):
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);exe=root/'fixture';exe.write_bytes(b'x');record=dict(reason='compiler-artifact',target=dict(name='fixture'),profile=dict(test=False),executable=str(exe));text=json.dumps(record)
            self.assertEqual(artifact(text,root,'fixture',False),exe)
            with self.assertRaises(ValueError):artifact(text+'\n'+text,root,'fixture',False)
            with self.assertRaises(ValueError):artifact(text,root/'different','fixture',False)
    def test_full_fixture_size_and_actual_backend(self):
        data=bytes(192+8193*4);meta=json.dumps(dict(backend='avx2',bytes=192,workers=3));self.assertEqual(fixture(data,meta,3,7,'avx2')['raw_bytes'],len(data))
        with self.assertRaises(ValueError):fixture(data[:-1],meta,3,7,'avx2')
        with self.assertRaises(ValueError):fixture(data,meta,3,7,'avx512')
    def test_phony_targets_and_continuation_deps(self):
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);a=root/'a.rs';b=root/'b.rs';a.write_text('a');b.write_text('b');dep=root/'fixture.d';dep.write_text(f'/bin/fixture: {a} \\\n {b}\n\n{a}:\n{b}:\n');self.assertEqual(set(dependencies(dep,root)),{str(a),str(b)})
    def test_dangling_artifact_rejected(self):
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);exe=root/'fixture';exe.symlink_to(root/'absent');record=dict(reason='compiler-artifact',target=dict(name='fixture'),profile=dict(test=False),executable=str(exe))
            with self.assertRaises(ValueError):artifact(json.dumps(record),root,'fixture',False)
    def test_optimized_python_rejected_before_help(self):
        r=subprocess.run([sys.executable,'-O',str(HERE/'validate.py'),'--help'],capture_output=True,text=True);self.assertNotEqual(r.returncode,0);self.assertFalse(r.stdout);self.assertIn('Use Python without -O',r.stderr)
if __name__=='__main__':unittest.main()
