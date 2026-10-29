"""Source-only checks. Prepared but not executed during active timing leases."""
import json,unittest
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]

class Source(unittest.TestCase):
    def test_only_one_page_member_added(self):
        old=(ROOT/'benchmarks/vldb-raw32-stage3/retry-v2/modern.cpp').read_text()
        start=old.index('template<unsigned K,bool Compact> class RawPage {');end=old.index('static const char* Names[]',start);old=old[start:end]
        new=(HERE/'page_facades.hpp').read_text();start=new.index('template<unsigned K,bool Compact> class RawPage {');end=new.index('// Same owned filter/geometry.',start);new=new[start:end]
        added='  bool SinglePointer(const uint32_t* key)const{return filter_.test(reinterpret_cast<const uint8_t*>(key),sizeof(uint32_t));}\n'
        self.assertEqual(new.count(added),1);self.assertEqual(new.replace(added,''),old)
    def test_registry_and_counts(self):
        p=json.loads((HERE/'protocol.json').read_text());self.assertEqual(len(p['registry']),len(set(p['registry'])));self.assertEqual(len(p['registry']),16)
        self.assertEqual(len(p['canonical_alias']),6)
        self.assertEqual(p['rows_per_round'],4*2*3+12*2*4)
        self.assertEqual(p['unpooled_quality_identities'],4*2*3+6*2*4)
        for name in p['registry']:self.assertIn('"'+name+'"',(HERE/'main.cpp').read_text())
    def test_pointer_and_original_dense_contract(self):
        source=(HERE/'query_pointer.hpp').read_text()
        self.assertIn('filter.SinglePointer(keys+i)',source)
        self.assertIn('DenseCall(base,count,keys+i,out+i)',source)
        self.assertNotIn('filter.Single(keys[i])',source)
        self.assertIn('const uint32_t batch=mode==QueryMode::DenseBatch1?1:4096',source)

if __name__=='__main__':unittest.main()
