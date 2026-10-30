"""Offline runner corruption checks, no compiler or Bloom execution."""
import copy
import csv
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import run
from bindings import PUBLIC,save,sha
from guard import expected_order,raw_intervals
from test_guard import PROTOCOL,REGISTRY,SOURCE,mock_rows


class Runner(unittest.TestCase):
    def setUp(self):
        self.rows=mock_rows();self.binary=Path('/frozen/performance')
        self.temp=tempfile.TemporaryDirectory();self.output=Path(self.temp.name)
        self.addCleanup(self.temp.cleanup)
        self.meta=dict(cases=[]);offset=0
        for i,case in enumerate(PROTOCOL['cases']):
            rows=self.rows[offset:offset+len(case['filters'])];offset+=len(rows)
            stdout,stderr=f'case-{i:02d}.stdout',f'case-{i:02d}.stderr'
            with(self.output/stdout).open('w',newline='')as stream:
                w=csv.DictWriter(stream,fieldnames=list(rows[0]),lineterminator='\n');w.writeheader();w.writerows(rows)
            (self.output/stderr).write_text('sbbf-rs 0.2.8 backend: Avx2Filter\n')
            self.meta['cases'].append(dict(case=case,command=run.command_for(case,PROTOCOL,self.binary),complete=True,
                returncode=0,stdout=stdout,stderr=stderr,stdout_sha256=sha(self.output/stdout),stderr_sha256=sha(self.output/stderr),
                rows=len(rows),expected_filter_order=expected_order(case,PROTOCOL,SOURCE),raw_input_intervals=raw_intervals(case,PROTOCOL)))
        with(self.output/'results.csv').open('w',newline='')as stream:
            w=csv.DictWriter(stream,fieldnames=list(self.rows[0]),lineterminator='\n');w.writeheader();w.writerows(self.rows)
        save(self.output/'quality.json',dict(synthetic=True))

    def audit(self):
        with patch('run.compare'),patch('run.quality',return_value=dict(synthetic=True)):
            return run.audit(self.output,self.meta,PROTOCOL,SOURCE,REGISTRY,self.binary)

    def test_complete336(self):self.assertEqual(len(self.audit()[0]),336)

    def test_changed_command_and_order(self):
        self.meta['cases'][0]['command'][-3]='Fastbloom017K6'
        with self.assertRaises(ValueError):self.audit()

    def test_failed_missing_and_duplicate_case(self):
        original=copy.deepcopy(self.meta)
        for mode in ['failed','missing','duplicate']:
            self.meta=copy.deepcopy(original)
            if mode=='failed':self.meta['cases'][0]['returncode']=1
            elif mode=='missing':self.meta['cases'].pop()
            else:self.meta['cases'][1]=self.meta['cases'][0]
            with self.assertRaises(ValueError):self.audit()

    def test_changed_raw_and_aggregate(self):
        original=(self.output/'results.csv').read_text()
        (self.output/'results.csv').write_text(original.replace('Fastbloom017K1,','Unknown,',1))
        with self.assertRaises(ValueError):self.audit()
        (self.output/'results.csv').write_text(original)
        (self.output/'case-00.stdout').write_text('corrupted')
        with self.assertRaises(ValueError):self.audit()

    def test_exact_quality112_no_batch_pooling(self):
        with(PUBLIC/'calibration-results/results.csv').open()as stream:reference=list(csv.DictReader(stream))
        rows=[]
        for batch in [1,31,4096]:rows.extend(dict(row,batch=str(batch))for row in reference)
        result=run.quality(rows)
        self.assertEqual(len(result['api_records']),112);self.assertEqual(len(result['mapping_records']),110)
        rows[0]['calibration_false_positives']=str(int(rows[0]['calibration_false_positives'])+1)
        with self.assertRaises(ValueError):run.quality(rows)

    def test_optimized_python_rejected_before_work(self):
        for name in ['run.py','freeze.py']:
            p=subprocess.run([sys.executable,'-O',str(run.HERE/name),'--help'],capture_output=True,text=True)
            self.assertNotEqual(p.returncode,0);self.assertFalse(p.stdout);self.assertIn('without -O',p.stderr)


if __name__=='__main__':unittest.main()
