import copy,csv,io,json,unittest
from unittest.mock import patch
from contract import *
from guard import expected_order
class Guards(unittest.TestCase):
    def fixture(self):
        p,cases,source=configuration();data=rows((PRIOR/'results.csv').read_text());out=[]
        for case in cases:
            values={r['filter']:dict(r)for r in data if r['filter']in[OLD,RANGE]and int(r['keys'])==1<<case['key_power']and int(r['seed'])==case['seed']and int(r['requested_bpk'])==24 and int(r['batch'])==1}
            values[NEW]=dict(values[OLD],filter=NEW,implementation_origin='K12_inline_experiment')
            group=[values[n]for n in expected_order(case,p,source)]
            for r in group:r.update(batch=str(case['batch']),calibration_absent_queries='0',calibration_false_positives='0')
            out.append((case,group))
        return p,source,out
    def test_fixed72_full_identity(self):
        p,s,groups=self.fixture();self.assertEqual(len(groups),24)
        for case,rows in groups:validate_case(rows,case,p,s)
        q=quality_context([r for c,g in groups for r in g]);self.assertEqual(q['record_count'],12);self.assertEqual(q['new_calibration_samples'],0);self.assertFalse(q['pooled'])
    def test_changed_candidate_output_rejected(self):
        p,s,g=self.fixture();case,group=g[0];next(r for r in group if r['filter']==NEW)['result_checksum']='123'
        with self.assertRaises(ValueError):validate_case(group,case,p,s)
    def test_new_calibration_rejected(self):
        p,s,g=self.fixture();case,group=g[0];group[0]['calibration_absent_queries']='1'
        with self.assertRaises(ValueError):validate_case(group,case,p,s)
    def test_changed_order_and_trial_rejected(self):
        p,s,g=self.fixture();case,group=g[0]
        with self.assertRaises(ValueError):validate_case(list(reversed(group)),case,p,s)
        group[0]['lookup_trials']='1|1|1|1|1|1|1|1'
        with self.assertRaises(ValueError):validate_case(group,case,p,s)
    def test_diagnostic_bytes_exact(self):
        validate_stderr(expected_stderr())
        for data in [b'',expected_stderr()+b'warning']:
            with self.assertRaises(ValueError):validate_stderr(data)
    def test_metadata_identity(self):
        f=dict(binary='binary',binary_sha256='hash',host={'test':True},environment={'test':None})
        m=dict(source_commit='a'*40,proof_commit=PROOF,proposal_commit=PROPOSAL,prior_raw_commit=PRIOR_RAW,binary='binary',binary_sha256='hash',protocol_sha256='digest',order_sha256='digest',execution_freeze_sha256='digest',host=f['host'],environment=f['environment'],affinity=[3],lease=dict(cpu=3,lease='socket1',lock_path='/tmp/fastest-bf-socket1.lock',inherited_lock_descriptors=[3]),performance_run=True,measurement_sessions=1,new_calibration_samples=0)
        with patch('contract.sha',return_value='digest'):
            metadata_identity(m,'a'*40,f)
            for key,value in [('source_commit','b'*40),('proof_commit','b'*40),('binary_sha256','wrong'),('affinity',[2]),('new_calibration_samples',1)]:
                bad=copy.deepcopy(m);bad[key]=value
                with self.assertRaises(ValueError):metadata_identity(bad,'a'*40,f)
if __name__=='__main__':unittest.main()
