"""Synthetic CSV/artifact/placement checks only, no compiler/BF invocation."""
import copy,json,unittest
from pathlib import Path
from unittest import mock
import bindings as b
import contract as c
import lease

def fixture(case):
    names,base,hits=c.row_order(case);n=1<<int(case[0]);q=1<<int(case[3]);batch=int(case[4]);count=int(case[5]);rows=[]
    for name in names:
        direct=name.startswith('FastbloomRsRawK');g=c.geometry(name,n,int(case[1]))
        row=dict(language='rust',filter=name,keys=n,queries=q,requested_bpk=int(case[1]),actual_bpk=g['filter_bytes']*8/n,hit_percent=int(case[2]),present_queries=hits,batch=batch,insert_batch=int(case[8]),repeats=count,seed=int(case[6]),key_base=base,raw_hash_contract='public_raw8_two_seed_xxh3_64'if direct else'public_common_hash64',build_scratch_bytes=0 if direct else min(n,int(case[8]))*8,query_scratch_bytes=0 if direct else batch*8,absent_queries=q-hits,false_positives=1,result_checksum=123,calibration_absent_queries=1<<int(case[9]),calibration_false_positives=2,query_phase_order=c.phase_order(int(case[6]),count),**g)
        for metric in c.METRICS:row.update({metric+'_ns':2.5,metric+'_min_ns':1,metric+'_max_ns':4,metric+'_trials':'1|2|3|4'})
        rows.append({k:str(v)for k,v in row.items()})
    return rows
class Guards(unittest.TestCase):
    def test_fixed_counts_and_all_metrics(self):
        cases=c.cases();self.assertEqual([len(c.row_order(x)[0])for x in cases],[45,8,8]);self.assertEqual(len(c.TESTS),6);self.assertEqual(len(c.invalid('/unused')),6)
        for case in cases:c.validate_rows(fixture(case),case)
    def test_scratch_geometry_and_schema_faults(self):
        case=c.cases()[0]
        for key,value in [('query_scratch_bytes','256'),('build_scratch_bytes','999'),('filter_bytes','1'),('effective_probes','99'),('raw_hash_contract','prehashed'),('query_phase_order','0|1')]:
            rows=fixture(case);rows[0][key]=value
            with self.assertRaises(ValueError):c.validate_rows(rows,case)
        rows=fixture(case);rows[0]['hidden_column']='0'
        with self.assertRaises(ValueError):c.validate_rows(rows,case)
    def test_order_trials_and_complete_build_faults(self):
        case=c.cases()[0];rows=fixture(case);rows.reverse()
        with self.assertRaises(ValueError):c.validate_rows(rows,case)
        for value in ['1|2|3','1|2|nan|4','1|2|inf|4']:
            rows=fixture(case);rows[0]['raw_batched_public_trials']=value
            with self.assertRaises(ValueError):c.validate_rows(rows,case)
        rows=fixture(case);row=rows[0];row.update(allocate_filter_and_scratch_raw_insert_trials='0|0|0|0',allocate_filter_and_scratch_raw_insert_ns='0',allocate_filter_and_scratch_raw_insert_min_ns='0',allocate_filter_and_scratch_raw_insert_max_ns='0')
        with self.assertRaises(ValueError):c.validate_rows(rows,case)
    def test_structured_artifact_identity_and_ambiguity(self):
        root=b.CALLER/'benchmark';target=Path('/tmp/synthetic-raw8-target');pkg='synthetic-root'
        event={'reason':'compiler-artifact','manifest_path':str(root/'Cargo.toml'),'package_id':pkg,'target':{'name':'raw8_benchmark','kind':['bin'],'src_path':str(root/'src/main.rs')},'profile':{'test':False},'executable':str(target/'raw8_benchmark')}
        with mock.patch.object(Path,'is_file',return_value=True):
            self.assertEqual(b.artifact(json.dumps(event),False,target,{pkg:{}}),target/'raw8_benchmark')
            wrong=copy.deepcopy(event);wrong['target']['src_path']=str(root/'src/other.rs')
            with self.assertRaises(ValueError):b.artifact(json.dumps(wrong),False,target,{pkg:{}})
            second=dict(event,executable=str(target/'other'))
            with self.assertRaises(ValueError):b.artifact(json.dumps(event)+'\n'+json.dumps(second),False,target,{pkg:{}})
    def test_subset_order_preserves_registry_order(self):
        case=c.cases()[1];reverse=list(case);reverse[7]=','.join(reversed(case[7].split(',')))
        self.assertEqual(c.row_order(case),c.row_order(reverse))
    def test_invalid_cli_requires_exact_exit_and_expected_reason(self):
        for rejection in c.invalid('/unused'):
            stderr=rejection['diagnostic'].encode()
            c.validate_process(rejection['expected_exit'],b'',stderr,rejection)
            for badcode in [-11,134,1]:
                with self.assertRaises(ValueError):c.validate_process(badcode,b'',stderr,rejection)
            with self.assertRaises(ValueError):c.validate_process(rejection['expected_exit'],b'',b'unrelated failure',rejection)
            with self.assertRaises(ValueError):c.validate_process(rejection['expected_exit'],b'data',stderr,rejection)
            for diagnostic in [b'AddressSanitizer:DEADLYSIGNAL',b'runtime error: bad access']:
                with self.assertRaises(ValueError):c.validate_process(rejection['expected_exit'],b'',stderr+diagnostic,rejection)
                with self.assertRaises(ValueError):c.validate_process(0,b'',diagnostic)
    def test_lease_never_accepts_name_only(self):
        with mock.patch.dict(lease.os.environ,{'BF_SOCKET_LEASE':'socket1-cpu3'}),mock.patch.object(lease.os,'sched_getaffinity',return_value={3}),mock.patch.object(lease.os,'listdir',return_value=[]):
            with self.assertRaises(ValueError):lease.require_lease(3)
        with mock.patch.dict(lease.os.environ,{'BF_SOCKET_LEASE':'wrong'}):
            with self.assertRaises(ValueError):lease.require_lease(3)
if __name__=='__main__':unittest.main()
