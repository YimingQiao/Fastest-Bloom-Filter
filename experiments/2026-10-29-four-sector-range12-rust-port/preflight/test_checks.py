import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from checks import artifact,fixture,dependencies,execution_stderr,check_environment,CPUS,PACKAGE
HERE=Path(__file__).resolve().parent
class Guards(unittest.TestCase):
    def record(self,root):
        crate=root/'native';(crate/'src').mkdir(parents=True);manifest=crate/'Cargo.toml';manifest.write_text('[package]');src=crate/'src/lib.rs';src.write_text('lib');target=root/'target';target.mkdir();exe=target/'fixture';exe.write_bytes(b'x')
        row=dict(reason='compiler-artifact',package_id='path+'+crate.as_uri()+'#'+PACKAGE,manifest_path=str(manifest),target=dict(name='fixture',src_path=str(src)),profile=dict(test=False),executable=str(exe))
        return row,manifest,target,exe
    def test_structured_artifact_and_wrong_target(self):
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);record,manifest,target,exe=self.record(root);text=json.dumps(record)
            self.assertEqual(artifact(text,target,'fixture',False,manifest),(exe,manifest.parent))
            with self.assertRaises(ValueError):artifact(text+'\n'+text,target,'fixture',False,manifest)
            with self.assertRaises(ValueError):artifact(text,root/'different','fixture',False,manifest)
    def test_wrong_package_manifest_or_dependency_rejected(self):
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);record,manifest,target,exe=self.record(root)
            for key,value in [('package_id','path+file:///other#x@0.0.0'),('manifest_path',str(root/'Cargo.toml'))]:
                bad=dict(record);bad[key]=value
                with self.assertRaises(ValueError):artifact(json.dumps(bad),target,'fixture',False,manifest)
            bad=dict(record);bad['package_id']='registry+https://example.org#unwanted@1.0';bad['executable']=None
            with self.assertRaises(ValueError):artifact(json.dumps(record)+'\n'+json.dumps(bad),target,'fixture',False,manifest)
    def test_full_fixture_size_and_actual_backend(self):
        data=bytes(192+8193*4);meta=json.dumps(dict(backend='avx2',bytes=192,workers=3));self.assertEqual(fixture(data,meta,3,7,'avx2')['raw_bytes'],len(data))
        with self.assertRaises(ValueError):fixture(data[:-1],meta,3,7,'avx2')
        with self.assertRaises(ValueError):fixture(data,meta,3,7,'avx512')
    def test_phony_targets_and_continuation_deps(self):
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);a=root/'a.rs';b=root/'b.rs';a.write_text('a');b.write_text('b');dep=root/'fixture.d';dep.write_text(f'/bin/fixture: {a} \\\n {b}\n\n{a}:\n{b}:\n');self.assertEqual(set(dependencies(dep,root)),{str(a),str(b)})
    def test_relative_rust_depfiles_use_unique_manifest_root(self):
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);record,manifest,target,exe=self.record(root);(root/'src').mkdir();(root/'src/lib.rs').write_text('decoy')
            dep=target/'fixture.d';dep.write_text('/bin/fixture: src/lib.rs\n\nsrc/lib.rs:\n');_,crate=artifact(json.dumps(record),target,'fixture',False,manifest)
            self.assertEqual(set(dependencies(dep,crate)),{str(crate/'src/lib.rs')});self.assertNotEqual(dependencies(dep,crate),dependencies(dep,root))
    def test_dangling_artifact_rejected(self):
        with tempfile.TemporaryDirectory()as d:
            root=Path(d);record,manifest,target,exe=self.record(root);exe.unlink();exe.symlink_to(root/'absent')
            with self.assertRaises(ValueError):artifact(json.dumps(record),target,'fixture',False,manifest)
    def test_real_child_affinity_proof_shape(self):
        payload=b'{"backend":"avx512"}\n';record=dict(pre_exec_affinity=CPUS,executable='/bin/test');raw=json.dumps(record).encode()+b'\n'+payload
        self.assertEqual(execution_stderr(raw,'/bin/test'),(record,payload))
        for mask in([3],[3,5,7],CPUS+[17]):
            bad=json.dumps(dict(record,pre_exec_affinity=mask)).encode()+b'\n'+payload
            with self.assertRaises(ValueError):execution_stderr(bad,'/bin/test')
    def test_encoded_or_target_flags_cannot_override_frozen_flags(self):
        self.assertTrue(all(x is None for x in check_environment({}).values()))
        for key in('CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS','CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS','RUSTC_WRAPPER'):
            with self.assertRaises(ValueError):check_environment({key:'surprise'})
    def test_optimized_python_rejected_before_help(self):
        r=subprocess.run([sys.executable,'-O',str(HERE/'validate.py'),'--help'],capture_output=True,text=True);self.assertNotEqual(r.returncode,0);self.assertFalse(r.stdout);self.assertIn('Use Python without -O',r.stderr)
if __name__=='__main__':unittest.main()
