"""Offline-only retry guards; no compiler or filter is executed."""
import json,sys,unittest
from pathlib import Path
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent))
from source_guard import sha

class Retry(unittest.TestCase):
    def test_only_constructor_cpp_delta(self):
        original=(HERE.parent/'modern.cpp').read_text()
        self.assertEqual((HERE/'modern.cpp').read_text(),original.replace('bool(filter_) &&','filter_.data()!=nullptr &&'))
    def test_reused_binary_and_commands(self):
        p=json.loads((HERE/'reuse.json').read_text());root=HERE.parents[2]
        for name,want in p['files'].items():self.assertEqual(sha(root/name),want,name)
    def test_no_native_legacy_rebuild(self):
        cm=(HERE/'CMakeLists.txt').read_text()
        self.assertIn('set(WORKERS modern)\nif(VLDB_BACKEND STREQUAL "native-asan")\n  list(APPEND WORKERS legacy)',cm)
        source=(HERE/'preflight.py').read_text()
        self.assertIn("expected=3 if backend=='native' else 2",source)
        self.assertIn("capture(binary.parent if backend=='native' and target=='legacy' else build",source)

if __name__=='__main__':unittest.main()
