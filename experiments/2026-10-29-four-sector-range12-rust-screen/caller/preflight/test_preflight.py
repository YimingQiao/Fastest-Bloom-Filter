import importlib.util,json,tempfile,unittest
from pathlib import Path
from bindings import HERE,CALLER,ROOT
from contract import cases,argv,invalid,compare,semantic,K12
from dependencies import cargo_roots,collect
from derive_guard import generate
from guard import expected_geometry,source_registry,expected_order

def load(path,name):
    spec=importlib.util.spec_from_file_location(name,path);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module
class Guards(unittest.TestCase):
    def test_exact_timed_and_public_derivation(self):
        result=load(CALLER/'derive.py','caller_derive').derive()
        self.assertTrue(result['unchanged_timed_body']);self.assertEqual(result['registry_size'],21)
        self.assertEqual((HERE/'guard.py').read_text(),generate())
    def test_bounded_counts_and_old_seed(self):
        source=(CALLER/'benchmark/src/main.rs').read_text();selected=cases(source)
        self.assertEqual(sum(len(c['filters'])for c in selected),42)
        self.assertEqual(sum(len([x for x in c['filters']if x!=K12])for c in selected),38)
        self.assertEqual({c['seed']for c in selected},{42})
        self.assertEqual(len(source_registry(source)),21)
        self.assertEqual(len(invalid('/fake')),6)
        for c in selected:self.assertEqual(argv('/fake',c)[7],'42')
    def test_geometry(self):
        g=expected_geometry(K12,1024,24)
        self.assertEqual((g['filter_bytes'],g['effective_probes'],g['geometry_kind'],g['implementation_origin']),(3072,12,'top24_range_lines','K12_experiment'))
    def test_semantic_comparison_keeps_all_nontiming_fields(self):
        a=dict(filter='A',filter_bytes='3072',lookup_ns='1',lookup_trials='1|1',result_checksum='4')
        b=dict(a,lookup_ns='2',lookup_trials='2|2')
        self.assertEqual(compare([a],[b]),1)
        with self.assertRaises(ValueError):compare([dict(a,result_checksum='5')],[b])
    def test_metadata_relative_package_owner(self):
        with tempfile.TemporaryDirectory()as directory:
            root=Path(directory);target=root/'target';target.mkdir();crate=root/'crate';(crate/'src').mkdir(parents=True);source=crate/'src/lib.rs';source.write_text('source');manifest=crate/'Cargo.toml';manifest.write_text('manifest')
            package='path+file://'+str(crate)+'#test@0.0.0';artifact=target/'libtest-0123456789abcdef.rlib';artifact.write_text('library')
            dep=target/'test-0123456789abcdef.d';dep.write_text(str(dep)+': src/lib.rs\n')
            item=dict(reason='compiler-artifact',manifest_path=str(manifest),package_id=package,target=dict(src_path=str(source),name='test',kind=['lib']),filenames=[str(artifact)])
            packages={package:dict(manifest_path=str(manifest),targets=[item['target']])}
            import hashlib
            pins={'crate/src/lib.rs':hashlib.sha256(source.read_bytes()).hexdigest()}
            consumed,rules=collect(target,target,[json.dumps(item)],pins,root,packages)
            self.assertEqual(list(consumed),[str(source)]);self.assertEqual(rules[0]['owner']['manifest'],str(manifest))
            wrong={package:dict(packages[package],manifest_path=str(root/'other/Cargo.toml'))}
            with self.assertRaises(ValueError):cargo_roots([json.dumps(item)],target,wrong)
    def test_unmapped_relative_dep_is_rejected(self):
        with tempfile.TemporaryDirectory()as directory:
            root=Path(directory);dep=root/'wrong.d';dep.write_text(str(dep)+': src/lib.rs\n')
            with self.assertRaises(ValueError):collect(root,root,[],{},root,{})
    def test_source_based_subset_order(self):
        source=(CALLER/'benchmark/src/main.rs').read_text();c=cases(source)[0]
        first=expected_order(c,dict(query_power=12,hit_percent=50),source)
        c=dict(c,filters=list(reversed(c['filters'])))
        self.assertEqual(first,expected_order(c,dict(query_power=12,hit_percent=50),source))
    def test_collector_parent_is_exact_and_change_is_metadata_only(self):
        import subprocess
        old=subprocess.check_output(['git','show','ec44c93cde22ea5c30ffd4d2bca5bc6e5eaaf63b:experiments/2026-10-29-native-build-policy-controls/caller/preflight/dependencies.py'],cwd=ROOT).decode()
        self.assertEqual((HERE/'dependencies-parent.py').read_text(),old)
        expected=old.replace('def cargo_roots(texts,target):','def cargo_roots(texts,target,packages):').replace("            need(package.startswith('path+file://'+str(manifest.parent)+'#'),'Cargo package/manifest disagreement')", "            known=packages.get(package)\n            need(known is not None and Path(known['manifest_path']).resolve()==manifest,'Cargo package/manifest disagreement')\n            need(any(Path(t['src_path']).resolve()==source and t['name']==value['target']['name'] and t['kind']==value['target']['kind'] for t in known['targets']),'Cargo artifact target absent from structured metadata')").replace('def collect(build,target,cargo_texts,repo_sources,root):','def collect(build,target,cargo_texts,repo_sources,root,packages):').replace('owners=cargo_roots(cargo_texts,target);','owners=cargo_roots(cargo_texts,target,packages);')
        self.assertEqual((HERE/'dependencies.py').read_text(),expected)
if __name__=='__main__':unittest.main()
