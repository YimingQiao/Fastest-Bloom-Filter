"""Synthetic guards only: no raw files, producer import, filter or compiler."""
import copy
import hashlib
import json
import unittest
import types
from unittest.mock import patch
import run


class LoaderGuards(unittest.TestCase):
    def binding(self):
        return dict(complete=True,producer_commit='ffffffffffffffffffffffffffffffffffffffff')

    def anchor(self):
        return dict(complete=True,producer_commit=self.binding()['producer_commit'],raw_commit='1'*40,
            raw_manifest_sha256='2'*64,screen_log_sha256=hashlib.sha256(run.expected_log()).hexdigest(),
            execution_outcome_sha256='3'*64,session_id=12345)

    def outcome(self):
        a=self.anchor()
        return dict(complete=True,producer_commit=a['producer_commit'],session_id=a['session_id'],
            exit_code=0,screen_log_sha256=a['screen_log_sha256'],
            terminal_tool_result=dict(exit_code=0,output='',wall_time_seconds=0.1,chunk_id='example'))

    def manifest(self):
        return dict(files_count=51,files={p:dict(sha256='0'*64,bytes=0)for p in run.raw_paths()})

    def test_exact51_inventory(self):
        run.validate_raw_manifest(self.manifest())
        self.assertEqual(len(run.raw_paths()),51)
        for kind in ('missing','extra','count','bad_size','bad_hash'):
            m=self.manifest()
            if kind=='missing':m['files'].pop('case-023.stdout')
            elif kind=='extra':m['files']['extra']=dict(sha256='0'*64,bytes=0)
            elif kind=='count':m['files_count']=50
            elif kind=='bad_size':m['files']['metadata.json']['bytes']=-1
            else:m['files']['metadata.json']['sha256']='0'*63
            with self.assertRaises(ValueError):run.validate_raw_manifest(m)

    def test_anchor_full_refs_and_fixed_producer(self):
        run.validate_anchor(self.anchor(),self.binding())
        for key,value in [('complete',False),('raw_commit','HEAD'),('producer_commit','1'*40),
                          ('session_id',True),('session_id',0),('screen_log_sha256','0'*63)]:
            a=self.anchor();a[key]=value
            with self.assertRaises(ValueError):run.validate_anchor(a,self.binding())
        a=self.anchor();a['unexpected']=1
        with self.assertRaises(ValueError):run.validate_anchor(a,self.binding())
        with patch.object(run.subprocess,'check_output') as git:
            for ref in ('HEAD','4beef700','A'*40):
                with self.assertRaises(ValueError):run.committed(ref,run.HERE/'run.py')
            git.assert_not_called()

    def test_complete_log_and_actual_successful_terminal_result(self):
        run.validate_terminal(self.outcome(),self.anchor(),self.binding(),run.expected_log())
        self.assertEqual(len(run.expected_log().splitlines()),25)
        for log in (run.expected_log().split(b'\n',1)[1],run.expected_log()+b'extra\n',
                    run.expected_log().replace(b'24/24 processes complete\n',b''),
                    run.expected_log().replace(b'216 rows',b'215 rows')):
            with self.assertRaises(ValueError):run.validate_terminal(self.outcome(),self.anchor(),self.binding(),log)
        for mutate in (lambda o:o.update(exit_code=1),lambda o:o.update(complete=False),
                       lambda o:o.update(session_id=987),lambda o:o.update(screen_log_sha256='0'*64),
                       lambda o:o['terminal_tool_result'].update(exit_code=143),
                       lambda o:o['terminal_tool_result'].update(session_id=12345),
                       lambda o:o['terminal_tool_result'].update(output='unexpected'),
                       lambda o:o['terminal_tool_result'].pop('exit_code')):
            o=self.outcome();mutate(o)
            with self.assertRaises(ValueError):run.validate_terminal(o,self.anchor(),self.binding(),run.expected_log())

    def test_duplicate_json_rejected(self):
        with self.assertRaisesRegex(ValueError,'duplicate'):
            json.loads('{"exit_code":0,"exit_code":1}',object_pairs_hook=run.unique)

    def test_independent_quality_link_agreement(self):
        fields=dict(mapping_id='m',keys=65536,actual_bytes=131072,calibration_negatives=1<<26,
            calibration_fp=123,calibration_digest=999,source_case_index=0,source_row_index=0,
            reuse_case_indices=[24],key_base=1,inserted_digest=2,inserted_hash_digest=3,bitmap_available=False,bitmap_digest=None)
        entries=[dict(fields,point_id='p'+str(i),seed=982451653)for i in range(36)]
        result=dict(quality=[dict(e,insertion_identity={k:e[k]for k in
            ('keys','actual_bytes','key_base','inserted_digest','inserted_hash_digest','bitmap_available','bitmap_digest')})for e in entries])
        links=dict(api_records=entries,api_record_count=36,known_mapping_record_count=34,
            calibration_rows=36,reuse_rows=180,pooling=False)
        run.validate_quality_agreement(result,links)
        for mutate in (lambda r:r['quality'][0].update(source_row_index=1),
                       lambda r:r['quality'][0].update(calibration_fp=124),
                       lambda r:r['quality'][0].update(reuse_case_indices=[25]),
                       lambda r:r['quality'][0]['insertion_identity'].update(inserted_hash_digest=4),
                       lambda r:r['quality'].pop()):
            r=copy.deepcopy(result);mutate(r)
            with self.assertRaises(ValueError):run.validate_quality_agreement(r,links)

    def test_audited_closure_and_completeness(self):
        proof=dict(all_binary_sha256={'normal':'a'*64,'asan':'b'*64},
                   compiler_consumed_input_sha256={'source':'c'*64},tools_sha256={'tool':'d'*64},
                   normal_executable={'path':'normal','sha256':'a'*64})
        metadata=dict(complete=True,source_commit=self.binding()['producer_commit'],cases=[{}]*24,
            counts=dict(processes=24,rows=216),initial_freeze=copy.deepcopy(proof),
            final_freeze=copy.deepcopy(proof),placement={'node':1},final_placement={'node':1})
        run.validate_audit_metadata(metadata,self.binding(),proof)
        for mutate in (lambda m:m.update(complete=False),lambda m:m['cases'].pop(),
                       lambda m:m['counts'].update(rows=215),lambda m:m['final_placement'].update(node=0),
                       lambda m:m['final_freeze']['all_binary_sha256'].update(normal='e'*64)):
            changed=copy.deepcopy(metadata);mutate(changed)
            with self.assertRaises(ValueError):run.validate_audit_metadata(changed,self.binding(),proof)
        changed=copy.deepcopy(metadata)
        for name in ('initial_freeze','final_freeze'):
            changed[name]['compiler_consumed_input_sha256']['source']='e'*64
        with self.assertRaises(ValueError):run.validate_audit_metadata(changed,self.binding(),proof)

    def test_unbound_producer_and_import_escape_rejected(self):
        with self.assertRaisesRegex(ValueError,'unfinished producer'):
            run.validate_binding(dict(complete=False))
        name='unverified_repository_module_for_guard'
        fake=types.SimpleNamespace(__file__=str(run.ROOT/'unverified.py'))
        before=set(run.sys.modules)
        with patch.dict(run.sys.modules,{name:fake}):
            with self.assertRaisesRegex(ValueError,'unexpected repository import'):
                run.verify_new_imports(before,set())


if __name__=='__main__':
    unittest.main()
