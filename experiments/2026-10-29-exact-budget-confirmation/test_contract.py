#!/usr/bin/env python3
"""Mock-data guards only: never execute a benchmark or treat fixtures as observations."""
import copy
import csv
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from guards import HERE,PARENT,ROOT,command_for,require_lease,sha,validate_cases,verify_git_blob
from make_plan import build_plan,derive
from run_confirmation import parse_case_rows
from summarize import analyze,verify_recorded_run,wilson_upper


class Contract(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = json.loads((HERE/'selection.json').read_text())
        cls.protocol = json.loads((HERE/'protocol.json').read_text())
        with (PARENT/'screen/results.csv').open() as stream:
            cls.training = list(csv.DictReader(stream))
        source = {r['configuration_id']:r for r in cls.training}
        cls.rows = []
        for case in cls.plan['cases']:
            for cid in case['configuration_ids']:
                r = dict(source[cid])
                r['seed'] = str(case['seed'])
                r['query_phase_order'] = ';'.join('H>P' if (case['seed']+i)&1 else 'P>H' for i in range(6))
                cls.rows.append(r)

    def test_exact_selection_union_and_all_native_controls(self):
        self.assertEqual(derive(),self.plan)
        self.assertEqual(self.plan['counts']['union_unique_leaders'],37)
        self.assertEqual(self.plan['counts']['additional_native_controls'],17)
        self.assertEqual(self.plan['counts']['configurations'],54)
        self.assertEqual(self.plan['counts']['rows'],162)
        grid = json.loads((PARENT/'planned-grid.json').read_text())
        expected = {r['configuration_id'] for r in grid['configurations'] if r['implementation_origin']=='production_native'}
        actual = {r['configuration_id'] for r in self.plan['configurations'] if r['implementation_origin']=='production_native'}
        self.assertEqual(expected,actual)
        self.assertEqual(len(actual),24)

    def test_geometry_csv_matches_fixed_selection_exactly(self):
        with (HERE/'selected-geometries.csv').open() as stream:
            rows=list(csv.DictReader(stream))
        expected=[{key:str(g[key]) for key in rows[0]} for g in self.plan['configurations']]
        self.assertEqual(rows,expected)

    def test_reject_missing_or_repeated_training_cell(self):
        grid = json.loads((PARENT/'planned-grid.json').read_text())
        summary = json.loads((PARENT/'screen/summary.json').read_text())
        frontier = json.loads((PARENT/'screen/capacity-frontier.json').read_text())
        summary['rankings'][1] = copy.deepcopy(summary['rankings'][0])
        with self.assertRaises(ValueError):
            build_plan(grid,summary,frontier,self.plan['seeds'])

    def test_reject_duplicate_or_training_seed(self):
        grid = json.loads((PARENT/'planned-grid.json').read_text())
        summary = json.loads((PARENT/'screen/summary.json').read_text())
        frontier = json.loads((PARENT/'screen/capacity-frontier.json').read_text())
        for seeds in ([42,1,2],[1,1,2],[1,2,2**64],[1,2]):
            with self.subTest(seeds=seeds),self.assertRaises(ValueError):
                build_plan(grid,summary,frontier,seeds)

    def test_complete_fixture_and_balanced_phase_order(self):
        result = validate_cases(self.rows,self.plan,self.protocol,complete=True)
        self.assertEqual(result['rows'],162)
        self.assertEqual(result['cases'],39)
        for r in self.rows:
            self.assertEqual(r['query_phase_order'].split(';').count('H>P'),3)
            self.assertEqual(r['query_phase_order'].split(';').count('P>H'),3)

    def test_missing_duplicate_geometry_and_wrong_case_fail(self):
        for rows in (self.rows[:-1],self.rows+[self.rows[0]]):
            with self.subTest(count=len(rows)),self.assertRaises((ValueError,AssertionError)):
                validate_cases(rows,self.plan,self.protocol,complete=True)
        rows = copy.deepcopy(self.rows)
        rows[0]['configuration_id'] = self.rows[-1]['configuration_id']
        with self.assertRaises(ValueError):
            validate_cases(rows,self.plan,self.protocol,complete=True)

    def test_successful_empty_or_partial_case_fails_immediately(self):
        case=self.plan['cases'][0]
        for text in ('', 'filter\n', 'filter\n'+case['filters'][0]+'\n',
                     'filter\n'+'\n'.join([case['filters'][0]]*len(case['filters']))+'\n'):
            with self.subTest(stdout=text),self.assertRaises(ValueError):
                parse_case_rows(text,case)

    def test_wrong_hit_count_geometry_and_phase_fail(self):
        for key,value in (('present_queries','2097152'),('filter_bytes','17'),('query_phase_order','P>H;P>H;P>H;P>H;P>H;P>H')):
            rows = copy.deepcopy(self.rows)
            rows[0][key] = value
            with self.subTest(key=key),self.assertRaises((ValueError,AssertionError)):
                validate_cases(rows,self.plan,self.protocol,complete=True)

    def test_api_calibration_is_deduplicated_not_pooled(self):
        report = analyze(self.rows,self.plan,self.protocol)
        self.assertLess(len(report['calibration_samples']),len(self.rows))
        self.assertTrue(any(len(s['members'])>1 for s in report['calibration_samples']))
        self.assertTrue(all(s['probes']==2**24 for s in report['calibration_samples']))
        # There are separate records for each seed; counts are never summed.
        for config in report['configurations']:
            self.assertEqual(config['worst_pointwise_quality_upper'],max(s['quality_upper'] for s in config['seeds']))

    def test_conflicting_equivalent_api_samples_rejected(self):
        rows = copy.deepcopy(self.rows)
        seen = set()
        for r in rows:
            identity = (r['seed'],r['calibration_identity'])
            if identity in seen:
                r['calibration_false_positives'] = str(int(r['calibration_false_positives'])+1)
                break
            seen.add(identity)
        else:
            self.fail('Fixture lacks an equivalent API control')
        with self.assertRaises(ValueError):
            analyze(rows,self.plan,self.protocol)

    def test_quality_failure_keeps_fixed_leader_and_all_losses(self):
        rows = copy.deepcopy(self.rows)
        cell = self.plan['main_comparisons'][0]
        target = cell['leaders']['production_native']
        geometry = next(c for c in self.plan['configurations'] if c['configuration_id']==target)
        seed = self.plan['seeds'][1]
        for r in rows:
            if r['calibration_identity']==geometry['calibration_identity'] and int(r['seed'])==seed:
                r['calibration_false_positives'] = r['calibration_absent_queries']
            if r['configuration_id']==target:
                r['lookup_trials_ns'] = json.dumps([100.0]*6)
                r['lookup_ns'] = r['lookup_min_ns'] = r['lookup_max_ns'] = '100.0'
        report = analyze(rows,self.plan,self.protocol)
        result = report['main_comparisons'][0]
        self.assertEqual(result['leaders']['production_native'],target)
        quality = result['fixed_leader_quality']['production_native']
        self.assertFalse(quality['qualified_all_seeds'])
        self.assertEqual(quality['worst_pointwise_quality_upper'],1.0)
        pair = result['pairs']['production_native']
        self.assertEqual(pair['status'],'quality_failure_no_replacement')
        self.assertEqual(pair['timing_losses'],3)
        self.assertEqual(len(pair['per_seed']),3)

    def test_null_frontier_leader_stays_null(self):
        report = analyze(self.rows,self.plan,self.protocol)
        for original,result in zip(self.plan['frontier_comparisons'],report['frontier_comparisons']):
            self.assertEqual(original['leaders'],result['leaders'])
            if original['leaders']['production_native'] is None:
                self.assertEqual(result['pairs']['production_native']['status'],'no_fixed_training_pair')

    def test_strict_integer_cap_and_wilson_endpoints(self):
        self.assertEqual(wilson_upper(17,17),1.0)
        self.assertGreater(wilson_upper(0,2**24),0)
        for fp,count in ((-1,7),(8,7),(0,0),(1.0,7)):
            with self.assertRaises(ValueError):wilson_upper(fp,count)
        report = analyze(self.rows,self.plan,self.protocol)
        self.assertTrue(all(v is None or v['fits_memory_cap'] for c in report['main_comparisons'] for v in c['fixed_leader_quality'].values()))

    def test_command_and_lease_are_explicit(self):
        command = command_for(Path('/relocated/repo'),self.protocol,self.plan['cases'][0])
        self.assertEqual(len(command),16)
        self.assertEqual(command[:3],['taskset','-c','3'])
        self.assertEqual(command[-2:],['query-only','0'])
        self.assertEqual(command[9],'6')
        for cpu,lease in ((2,'socket0'),(3,'socket0')):
            with self.assertRaises(ValueError):require_lease(cpu,lease)
        with mock.patch('guards.os.sched_getaffinity',return_value={3}),mock.patch('guards.os.listdir',return_value=[]):
            with self.assertRaises(ValueError):require_lease(3,'socket1')

    def test_commit_blob_is_required_not_only_commit_existence(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); path = root/'source';path.write_bytes(b'current')
            import hashlib
            digest = hashlib.sha256(b'current').hexdigest()
            with mock.patch('guards.subprocess.check_output',return_value=b'old'):
                with self.assertRaises(ValueError):verify_git_blob(root,path,'a'*40,digest)

    def test_optimized_python_is_rejected_before_any_workload(self):
        for name in ('run_confirmation.py','summarize.py'):
            proc=subprocess.run([sys.executable,'-O',str(HERE/name),'--help'],text=True,capture_output=True)
            self.assertNotEqual(proc.returncode,0)
            self.assertIn('Do not run',proc.stderr)

    def write_mock_archive(self,directory):
        metadata = {'complete':True,'all_frozen_sources_and_binaries_unchanged':True,'protocol':self.protocol,
                    'parent_source_commit':self.protocol['parent_source_commit'],'selection_sha256':sha(HERE/'selection.json'),
                    'lease':{'cpu':3,'lease':'socket1','lock_path':self.protocol['socket_lock'],'inherited_lock_descriptors':[9]},
                    'validation':validate_cases(self.rows,self.plan,self.protocol,complete=True),'cases':[]}
        with (directory/'results.csv').open('w',newline='') as f:
            writer=csv.DictWriter(f,fieldnames=list(self.rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(self.rows)
        metadata['results_sha256']=sha(directory/'results.csv')
        for i,case in enumerate(self.plan['cases']):
            rows=[r for r in self.rows if int(r['seed'])==case['seed'] and r['configuration_id'] in case['configuration_ids']]
            stem=f'case-{i:02d}-{case["case_id"]}'
            stdout,stderr=directory/(stem+'.stdout'),directory/(stem+'.stderr')
            with stdout.open('w',newline='') as f:
                fields=[k for k in rows[0] if k not in ('configuration_id','calibration_identity')]
                writer=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore',lineterminator='\n');writer.writeheader();writer.writerows(rows)
            stderr.write_text('')
            metadata['cases'].append({'case':case,'command':command_for(Path('/original/location'),self.protocol,case),
                                      'rows':len(rows),'stdout_sha256':sha(stdout),'stderr_sha256':sha(stderr)})
        (directory/'metadata.json').write_text(json.dumps(metadata))
        return metadata

    def test_recorded_archive_is_portable_but_commands_are_exact(self):
        with tempfile.TemporaryDirectory() as d:
            path=Path(d);metadata=self.write_mock_archive(path)
            rows,_=verify_recorded_run(path,self.plan,self.protocol)
            self.assertEqual(rows,self.rows)
            for index,value in ((2,'2'),(9,'8'),(10,'42'),(14,'full')):
                bad=copy.deepcopy(metadata);bad['cases'][0]['command'][index]=value
                (path/'metadata.json').write_text(json.dumps(bad))
                with self.subTest(index=index),self.assertRaises(ValueError):
                    verify_recorded_run(path,self.plan,self.protocol)

    def test_recorded_archive_rejects_wrong_lease_missing_case_and_raw_drift(self):
        with tempfile.TemporaryDirectory() as d:
            path=Path(d);metadata=self.write_mock_archive(path)
            bad=copy.deepcopy(metadata);bad['lease']['inherited_lock_descriptors']=[]
            (path/'metadata.json').write_text(json.dumps(bad))
            with self.assertRaises(ValueError):verify_recorded_run(path,self.plan,self.protocol)
            bad=copy.deepcopy(metadata);bad['cases'].pop()
            (path/'metadata.json').write_text(json.dumps(bad))
            with self.assertRaises(ValueError):verify_recorded_run(path,self.plan,self.protocol)
            (path/'metadata.json').write_text(json.dumps(metadata))
            next(path.glob('*.stdout')).write_text('changed')
            with self.assertRaises(ValueError):verify_recorded_run(path,self.plan,self.protocol)


if __name__=='__main__':
    unittest.main(verbosity=2)
