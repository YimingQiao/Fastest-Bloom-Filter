import copy
import json
import unittest
from checks import NATIVE,GEOMETRY,cases,command,names,validate,check_aliases,normalized,parse
from derive import derive,HERE

def mock(case):
    n=1<<case['power'];cap=case['cap'];name=case['filter'];public=name not in NATIVE
    row={key:'0'for key in GEOMETRY}
    row.update(worker='nearby_legacy',filter=name,key_domain='raw_u32',keys=str(n),requested_bpk=str(cap),
        budget_bytes=str(n*cap//8),queries='4096',seed='42',hit_percent='50',present_queries='2050',
        absent_queries='2046',calibration_absent_queries='1024',false_positives='5',calibration_false_positives='2',
        result_checksum='13',inserted_checksum='17',query_checksum='19',calibration_checksum='23',
        repeats='0',build_repeats='0',query_phase_order='untimed',filter_build_scratch_bytes='0',
        build_hash_scratch_bytes=str(0 if public else 8*n),adapter_object_bytes='320',probe_policy='fixed')
    if public:
        config,_,policy=name.split('/');u=int(config.split('-u')[1]);word=4 if config.startswith('sector32')else 8;w=1 if config.startswith('register')else 8
        unit=word*w;count=n*cap//8//unit-(policy=='nearby_odd');logical=count*unit;backing=(logical+63)//64*64
        row.update(surface='artifact_pimpl',implementation_origin='external',filter_bytes=str(backing),logical_bytes=str(logical),
            unit_bytes=str(unit),unit_count=str(count),constructor_argument=str(logical*8),effective_probes='8',address='magic',
            geometry_kind='original_blocked_bloom_nearby_odd'if policy=='nearby_odd'else'original_blocked_bloom',
            public_metadata=json.dumps(dict(size=logical,u=u,k=8,addr='magic')))
    else:
        production=name in NATIVE[:4];size=n*(8 if cap==12 else 16)//8 if production else n*cap//8
        row.update(filter_bytes=str(size),logical_bytes=str(size),unit_bytes='64',unit_count=str(size//64),
            implementation_origin='production_native'if production else'optional_native_range'if name==NATIVE[4]else'project_experiment',
            surface='public_native_lookup'if production else'public_contains_hash_and_lookup',public_metadata='{}')
    for mode,count in [('raw_single',0),('raw_batch1',1),('raw_batch4096',4096)]:
        for suffix in ['_ns','_min_ns','_max_ns','_trials_ns']:row[mode+suffix]='nan'
        row[mode+'_scratch_bytes']=str(count*(4 if public else 8))
    for key in ['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:row[key]='nan'
    return row

class Checks(unittest.TestCase):
    def test_fixed_coverage_and_no_timer_commands(self):
        self.assertEqual(len(names()),20);self.assertEqual(len(set(names())),20);self.assertEqual(len(cases()),40)
        rows=[validate(mock(c),c)for c in cases()];self.assertEqual(len(check_aliases(rows)),24)
        for c in cases():self.assertEqual(command('/fixed/bin',c)[1],'--check');self.assertEqual(command('/fixed/bin',c)[-1],'0')
    def test_native_sizing_and_public_U_are_checked(self):
        for index,key,value in [(0,'filter_bytes','999999999'),(0,'public_metadata','{"u":4,"k":8,"size":98304,"addr":"magic"}'),
                                (14,'filter_bytes','98304'),(18,'filter_bytes','65536')]:
            case=cases()[index];row=mock(case);row[key]=value
            with self.assertRaises(ValueError):validate(row,case)
    def test_raw_counts_timing_and_scratch_are_checked(self):
        case=cases()[0]
        for key,value in [('present_queries','2048'),('raw_single_ns','1.0'),('raw_batch1_scratch_bytes','8'),('repeats','6'),('build_hash_scratch_bytes','8')]:
            row=mock(case);row[key]=value
            with self.assertRaises(ValueError):validate(row,case)
    def test_alias_disagreement_is_not_pooled(self):
        rows=[mock(c)for c in cases()];rows[2]['calibration_false_positives']='3'
        with self.assertRaises(ValueError):check_aliases(rows)
    def test_reference_normalization_removes_only_labels(self):
        row=mock(cases()[0]);other=dict(row,worker='legacy',filter='old-label')
        self.assertEqual(normalized(row),normalized(other));other['adapter_object_bytes']='321'
        self.assertNotEqual(normalized(row),normalized(other))
    def test_incomplete_and_multiple_csv_rows_rejected(self):
        for text in ('a,b\n1\n','a,b\n1,2\n3,4\n',''):
            with self.assertRaises(ValueError):parse(text)
    def test_derived_sources_exact_and_timed_body_unchanged(self):
        outputs,inputs=derive()
        descriptor=json.loads((HERE/'DERIVED.json').read_text());self.assertEqual(descriptor['source'],inputs)
        for name,data in outputs.items():self.assertEqual((HERE/name).read_bytes(),data)
        self.assertEqual(len(outputs),7)
if __name__=='__main__':unittest.main()
