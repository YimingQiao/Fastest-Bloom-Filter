import ast
import json
import unittest
from pathlib import Path
import derive

class Source(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.generated=derive.sources()
    def test_exact_native_and_caller_derivation(self):
        for rel,data in self.generated.items():
            self.assertEqual((derive.HERE/rel).read_bytes(),data,rel)
    def test_no_timed_policy_adapter(self):
        cpp=self.generated['cpp/bindings.hpp'].decode()
        rust=self.generated['rust/src/bindings.rs'].decode()
        for token in ['65536','262144','effective_request','EffectiveBuildRequest']:
            self.assertNotIn(token,cpp);self.assertNotIn(token,rust)
        main=self.generated['rust/src/main.rs'].decode()
        self.assertNotIn('Filter<',main)
        self.assertIn('filter.insert_hashes_parallel(black_box(&d.batch), c.requested)',main)
        self.assertIn('filter.InsertParallel(static_cast<uint32_t>(c.n),d.batch.data(),c.requested)',self.generated['cpp/main.cpp'].decode())
    def test_source_delta_and_licenses(self):
        for label in ['before','after']:
            for name in ['LICENSE-MIT','LICENSE-APACHE','NOTICE']:
                self.assertIn('native/'+label+'/rust/'+name,self.generated)
            for path in ['cpp/'+label+'/parallel_layout_bloom.h','cpp/'+label+'/parallel_split64_range_bloom.h']:
                self.assertNotIn('namespace bloom_filters',self.generated[path].decode())
        for path in ['include/parallel_bloom.h','include/split64_bloom.h','include/four_sector_bloom.h','include/byte_split_bloom.h','rust/src/layout_parallel.rs','rust/src/range_parallel.rs']:
            self.assertEqual(self.generated['native/before/'+path],self.generated['native/after/'+path])
    def test_preflight_keeps_cli_namespace(self):
        tree=ast.parse((derive.HERE/'preflight.py').read_text())
        assignments=[node for node in ast.walk(tree) if isinstance(node,ast.Assign)
            and any(isinstance(target,ast.Name) and target.id=='args' for target in node.targets)]
        self.assertEqual(len(assignments),1)
        self.assertIsInstance(assignments[0].value,ast.Call)
        self.assertEqual(assignments[0].value.func.attr,'parse_args')
    def test_implicit_build_and_allocator_flags_rejected(self):
        tree=ast.parse((derive.HERE/'lease.py').read_text())
        forbidden=next(ast.literal_eval(node.value) for node in ast.walk(tree)
            if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='forbidden' for t in node.targets))
        for key in ['CFLAGS','CXXFLAGS','CPPFLAGS','LDFLAGS','MALLOC_ARENA_MAX','CARGO_ENCODED_RUSTFLAGS','RUSTC_WRAPPER']:
            self.assertIn(key,forbidden)
    def test_fixed96_ledger(self):
        self.assertEqual((derive.HERE/'fixed-plan/ledger.json').read_bytes(),(derive.HERE.parent/'ledger.json').read_bytes())
        rows=json.loads((derive.HERE/'fixed-plan/ledger.json').read_text())['cases']
        self.assertEqual(len(rows),96)
        self.assertTrue(any(x['batch_n']==65537 and x['bytes']==262144 and x['requested']==8 for x in rows))

if __name__=='__main__':unittest.main()
