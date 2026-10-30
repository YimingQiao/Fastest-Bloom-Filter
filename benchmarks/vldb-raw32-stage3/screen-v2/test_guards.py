"""Offline negative tests; no compiler, worker or timer is run."""
import copy,unittest
from guards import check_proof,RETRY

class Provenance(unittest.TestCase):
    def test_exact_v2_proof(self):
        f=dict(preparation_commit='a'*40,binaries={'native/legacy':{'sha256':'old'}},consumed_inputs={str(RETRY/'modern.cpp'):'new'})
        m=dict(complete=True,all_sources_unchanged=True,source_commit='a'*40,retry_preparation_sha256='retry',binaries=copy.deepcopy(f['binaries']))
        check_proof(f,m,'retry','old','new')
        for key,value in [('complete',False),('all_sources_unchanged',False),('source_commit','b'*40),('retry_preparation_sha256','different'),('binaries',{})]:
            bad=copy.deepcopy(m);bad[key]=value
            with self.assertRaises(ValueError):check_proof(f,bad,'retry','old','new')
    def test_binary_and_consumed_source(self):
        f=dict(preparation_commit='a'*40,binaries={'native/legacy':{'sha256':'old'}},consumed_inputs={str(RETRY/'modern.cpp'):'new'})
        m=dict(complete=True,all_sources_unchanged=True,source_commit='a'*40,retry_preparation_sha256='retry',binaries=f['binaries'])
        with self.assertRaises(ValueError):check_proof(f,m,'retry','changed','new')
        with self.assertRaises(ValueError):check_proof(f,m,'retry','old','changed')

if __name__=='__main__':unittest.main()
