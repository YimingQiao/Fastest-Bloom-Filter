"""Focused offline corruption tests; no benchmark or compiler execution."""
import copy
import json
from pathlib import Path
import subprocess
import sys
import unittest
from unittest.mock import patch
import contract
from test_run import Runner
from test_guard import PROTOCOL,SOURCE

class Resume(unittest.TestCase):
    def setUp(self):
        self.fixture=Runner();self.fixture.setUp();self.addCleanup(self.fixture.doCleanups)
        self.output=self.fixture.output;self.binary=self.fixture.binary
        self.meta=copy.deepcopy(self.fixture.meta)
        self.final=copy.deepcopy(self.meta['cases'][17])
        self.meta.update(complete=False,source_commit=contract.ORIGINAL,executable=str(self.binary),
                         executable_sha256=contract.BINARY_SHA,started_utc='synthetic')
        self.pending=self.meta['cases'][17]
        for key in ['returncode','stdout_sha256','stderr_sha256','rows']:self.pending.pop(key)
        self.pending['complete']=False
        for name in ['case-17.stdout','case-17.stderr','quality.json']:(self.output/name).unlink()
        rows=self.fixture.rows[:-20]
        import csv
        with(self.output/'results.csv').open('w',newline='')as output:
            writer=csv.DictWriter(output,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows)
        (self.output/'metadata.json').write_text(json.dumps(self.meta))

    def validate(self):
        with patch('contract.compare'):
            return contract.validate_original(self.output,self.meta,PROTOCOL,SOURCE,self.binary)

    def test_exact17(self):self.assertEqual(len(self.validate()),316)

    def test_missing_duplicate_or_changed_command(self):
        original=copy.deepcopy(self.meta)
        for mode in ['missing','duplicate','command']:
            self.meta=copy.deepcopy(original)
            if mode=='missing':self.meta['cases'].pop()
            elif mode=='duplicate':self.meta['cases'][1]=self.meta['cases'][0]
            else:self.meta['cases'][0]['command'][-1]='25'
            with self.assertRaises(ValueError):self.validate()

    def test_pending_scope_and_preexisting_output(self):
        self.pending['command'][-1]='27'
        with self.assertRaises(ValueError):self.validate()
        self.pending['command'][-1]='24'
        (self.output/'case-17.stdout').write_text('partial')
        with self.assertRaises(ValueError):self.validate()

    def test_wrong_binary_and_wrong_source(self):
        for key in ['source_commit','executable_sha256']:
            old=self.meta[key];self.meta[key]='0'*len(old)
            with self.assertRaises(ValueError):self.validate()
            self.meta[key]=old

    def test_original_must_stay_incomplete_and_aggregate_exact(self):
        self.meta['complete']=True
        with self.assertRaises(ValueError):self.validate()
        self.meta['complete']=False
        (self.output/'results.csv').write_text('corrupted')
        with self.assertRaises(ValueError):self.validate()

    def test_combined_list_not_overwritten_and_sessions_explicit(self):
        resume=dict(source_commit='a'*40,metadata_path='new/metadata.json',session_label='resume-v1',started_utc='later',finished_utc='latest')
        result=contract.combine_metadata(self.meta,resume,self.final,dict(cases=18,rows=336))
        self.assertEqual(result['case_count'],18);self.assertIsInstance(result['cases'],list)
        self.assertEqual(len(result['cases']),18);self.assertEqual(len(result['sessions']),2)
        self.assertFalse(result['original_attempt_completed']);self.assertFalse(self.meta['complete'])
        self.assertFalse(self.meta['cases'][17]['complete']);self.assertEqual(result['reused_completed_rows'],316)

    def test_optimized_python_rejected(self):
        result=subprocess.run([sys.executable,'-O',str(contract.HERE/'resume.py'),'--help'],capture_output=True,text=True)
        self.assertNotEqual(result.returncode,0);self.assertFalse(result.stdout);self.assertIn('without -O',result.stderr)

if __name__=='__main__':unittest.main()
