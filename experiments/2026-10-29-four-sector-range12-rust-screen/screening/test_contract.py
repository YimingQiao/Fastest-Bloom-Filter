import copy,csv,json,math,subprocess,sys,unittest
from pathlib import Path
from unittest import mock
from pins import HERE,STAGE,PROPOSAL,PROOF,CALLER,sha,environment,ENV_KEYS
from contract import configuration,command,quality,wilson,metadata_identity,rows,expected_stderr,validate_stderr
from guard import validate_rows,expected_phases,expected_geometry,csv_fields,raw_intervals

def synthetic(case):
    p,s,c,source=configuration();n=1<<case['key_power'];q=1<<p['query_power'];hits=q//100*50+min(q%100,50);result=[]
    for name in case['expected_filter_order']:
        r={key:'0'for key in csv_fields(source)}
        r.update(language='rust',filter=name,keys=str(n),queries=str(q),requested_bpk=str(case['budget_bpk']),hash_bits='64',hit_percent='50',present_queries=str(hits),absent_queries=str(q-hits),batch=str(case['batch']),repeats='8',seed=str(case['seed']),insert_batch=str(n),calibration_absent_queries=str(1<<26),calibration_false_positives='2000',false_positives='0',fpr='0',result_checksum='123',input_mode='prehashed',scalar_track='optimizer_visible_public_single',query_phase_order=expected_phases(case['seed'],8))
        r.update({key:str(value)for key,value in expected_geometry(name,n,case['budget_bpk']).items()})
        for metric in ['lookup','hash_lookup','inline_lookup','inline_hash_lookup']:
            r[metric+'_trials']='1|2|3|4|5|6|7|8';r[metric+'_ns']='4.5';r[metric+'_min_ns']='1';r[metric+'_max_ns']='8'
        for metric in p['metrics']['build']:r[metric]='10'
        result.append(r)
    return result
class Guards(unittest.TestCase):
    def test_fixed_source_order_domains_and_108(self):
        p,s,m,source=configuration();self.assertEqual(len(s['cases']),36);self.assertEqual(sum(len(c['filters'])for c in s['cases']),108)
        for c in s['cases']:validate_rows(synthetic(c),c,m,source)
    def test_full_row_order_phase_and_output_fields(self):
        p,s,m,source=configuration();c=s['cases'][0];good=synthetic(c)
        for field,value in [('result_checksum','-1'),('calibration_false_positives',str((1<<26)+1)),('filter_bytes','1'),('query_phase_order',expected_phases(c['seed']+1,8)),('lookup_trials','1|2')]:
            bad=copy.deepcopy(good);bad[0][field]=value
            with self.assertRaises(ValueError):validate_rows(bad,c,m,source)
        with self.assertRaises(ValueError):validate_rows(list(reversed(good)),c,m,source)
    def test_36_unpooled_records_12_gates(self):
        records=[r for c in configuration()[1]['cases']for r in synthetic(c)];result=quality(records)
        self.assertEqual(len(result['api_geometry_seed_records']),36);self.assertEqual(len(result['all_three_seed_gates']),12)
        self.assertTrue(all(x['queries']==1<<26 for x in result['api_geometry_seed_records']))
    def test_reused_batch_drift_and_missing_seed_rejected(self):
        records=[r for c in configuration()[1]['cases']for r in synthetic(c)];bad=copy.deepcopy(records);bad[-1]['calibration_false_positives']='2001'
        with self.assertRaises(ValueError):quality(bad)
        with self.assertRaises(ValueError):quality([r for r in records if int(r['seed'])!=configuration()[0]['seeds'][-1]])
    def test_single_failed_seed_retained_no_pool(self):
        records=[r for c in configuration()[1]['cases']for r in synthetic(c)];seed=configuration()[0]['seeds'][0]
        for r in records:
            if r['filter']=='FourSectorRange12BloomFilter'and int(r['keys'])==65536 and int(r['seed'])==seed:r['calibration_false_positives']='10000'
        q=quality(records);g=next(x for x in q['all_three_seed_gates']if x['filter']=='FourSectorRange12BloomFilter'and x['keys']==65536)
        self.assertFalse(g['all_three_seeds_pass']);self.assertEqual(len(q['api_geometry_seed_records']),36)
    def test_wilson_exact_endpoints(self):
        self.assertEqual(wilson(0,1<<26)[0],0);self.assertEqual(wilson(1<<26,1<<26)[1],1)
        with self.assertRaises(ValueError):wilson(-1,100)
    def test_metadata_identity_fields_and_count_ledger_are_distinct(self):
        # Mock only absent future execution-freeze hash; identity rejection is
        # exercised before any filesystem/raw result access.
        freeze=dict(binary='/fixed',binary_sha256='a'*64,host={'cpu':3},environment={})
        meta=dict(source_commit='b'*40,proposal_commit=PROPOSAL,proof_commit=PROOF,caller_source_commit=CALLER,binary='/fixed',binary_sha256='a'*64,protocol_sha256='h',selection_sha256='h',execution_freeze_sha256='h',host={'cpu':3},environment={},affinity=[3],lease=dict(cpu=3,lease='socket1',lock_path='/tmp/fastest-bf-socket1.lock',inherited_lock_descriptors=[3]))
        with mock.patch('contract.sha',return_value='h'):
            metadata_identity(meta,'b'*40,freeze)
            for field,value in [('source_commit','c'*40),('proof_commit','c'*40),('binary_sha256','c'*64),('affinity',[2]),('environment',{'LD_PRELOAD':'x'}),('host',{})]:
                bad=copy.deepcopy(meta);bad[field]=value
                with self.assertRaises(ValueError):metadata_identity(bad,'b'*40,freeze)
        text=(HERE/'run.py').read_text();self.assertIn('case_count=36',text);self.assertNotIn('cases=36',text)
    def test_environment_and_success_stderr_guards(self):
        for name in ['MALLOC_ARENA_MAX','ASAN_OPTIONS','UBSAN_OPTIONS']:
            self.assertIn(name,ENV_KEYS)
            with mock.patch.dict('os.environ',{name:'unexpected'}):
                with self.assertRaises(ValueError):environment()
        expected=expected_stderr();validate_stderr(expected)
        self.assertIn(b'sbbf-rs 0.2.8 backend: Avx2Filter',expected)
        for bad in [b'',expected+b'extra diagnostic\n']:
            with self.assertRaises(ValueError):validate_stderr(bad)
        self.assertIn('validate_stderr(result.stderr)',(HERE/'run.py').read_text())
    def test_python_optimized_rejected_before_sources_or_execution(self):
        result=subprocess.run([sys.executable,'-O',HERE/'run.py','--source-commit','a'*40],capture_output=True)
        self.assertNotEqual(result.returncode,0);self.assertIn(b'Python -O is forbidden before any work',result.stderr);self.assertFalse(result.stdout)
if __name__=='__main__':unittest.main()
