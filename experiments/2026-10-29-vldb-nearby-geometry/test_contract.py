"""Synthetic row checks only; no upstream planner, compiler or Bloom call."""
import copy,difflib,json,unittest
from pathlib import Path
from nearby_contract import cases,validate,reference_row

def row():
    # A shape fixture only; cheap-divisor acceptance is proved by C++, not
    # inferred by this Python test. n16/cap12/sector32 permits this odd count.
    count=3071;logical=count*32
    return dict(status='supported',policy='nearby_odd',budget_bytes=98304,
        constructor_bits=logical*8,logical_bytes=logical,backing_bytes=98304,
        block_count=count,address='magic',digest=1,bitmap_digest=2,
        upstream_metadata=dict(size=logical,word_size=4,w=8,s=8,k=8,u=1,addr='magic'))

class Contract(unittest.TestCase):
    def test_finite_scope(self):
        values=cases();self.assertEqual(len(values),31);self.assertEqual(len(set(values)),31)
        self.assertEqual(sum(c[-1]=='nearby_odd'for c in values),28)
        self.assertEqual(sum(c[-1]=='original'for c in values),3)
    def test_padding_is_charged(self):
        r=row();validate(r,('sector32-u1',16,12,'nearby_odd'))
        r['backing_bytes']=r['logical_bytes']
        with self.assertRaises(ValueError):validate(r,('sector32-u1',16,12,'nearby_odd'))
    def test_fixed_window_and_metadata(self):
        for key,value in [('block_count',3072),('block_count',3001),('policy','original'),('address','pow2')]:
            r=row();r[key]=value
            with self.assertRaises(ValueError):validate(r,('sector32-u1',16,12,'nearby_odd'))
        r=row();r['upstream_metadata']['u']=2
        with self.assertRaises(ValueError):validate(r,('sector32-u1',16,12,'nearby_odd'))
    def test_unsupported_retained(self):
        r=dict(status='unsupported',policy='nearby_odd',budget_bytes=98304,block_bytes=32,maximum_blocks=3072,lower_blocks=3042)
        self.assertEqual(validate(r,('sector32-u1',16,12,'nearby_odd')),r)
        with self.assertRaises(ValueError):validate(r,('sector32-u1',16,12,'original'))
    def test_reference_removes_only_labels(self):
        r=row();self.assertEqual(set(r)-set(reference_row(r)),{'status','policy'})
    def test_checker_delta_is_exact(self):
        here=Path(__file__).resolve().parent;root=here.parents[1]
        old=(root/'benchmarks/vldb-raw32-stage2/geometry_check.cpp').read_text();new=(here/'check.cpp').read_text()
        patch=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='frozen-stage2/geometry_check.cpp',tofile='nearby/check.cpp'))
        self.assertEqual(patch,(here/'checker.patch').read_text())
        # Public query and conversion code is unchanged from the passed checker.
        a=old[old.index('template<class Filter> uint64_t Query'):old.index('template<class T> void Check')]
        b=new[new.index('template<class Filter> uint64_t Query'):new.index('template<class T> void Check')]
        self.assertEqual(a,b)

if __name__=='__main__':unittest.main()
