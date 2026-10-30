import copy
import csv
import io
import json
import tempfile
from pathlib import Path
import unittest
from contract import CASES, METRICS, TYPES, rows
from validate import new_path

def fixture():
    case=CASES[0];n=1<<case['power'];q=1<<case['qp'];present=q//100*50+min(q%100,50)
    base=dict(keys=str(n),queries=str(q),requested_bpk='24',filter_bytes=str(n*3),actual_bpk='24',hash_bits='64',
              hit_percent='50',present_queries=str(present),absent_queries=str(q-present),false_positives='1',
              result_checksum='1234',input_mode='prehashed',calibration_absent_queries='0',calibration_false_positives='0',
              logical_bytes=str(n*3),effective_probes='12',batch=str(case['batch']),repeats='2',seed=str(case['seed']),
              insert_batch='4',query_repeats='2',build_repeats='2',filter_build_scratch_bytes='0',
              harness_hash_scratch_bytes=str(8*case['batch']),measurement_mode='full',implementation_origin='project_experiment',
              query_phase_order='H>P;P>H')
    for vector,metric in METRICS.items():base[vector]='[1.0, 3.0]';base[metric]='2.0'
    return [dict(base,filter=name)for name in TYPES]

def text(records):
    stream=io.StringIO();writer=csv.DictWriter(stream,fieldnames=list(records[0]));writer.writeheader();writer.writerows(records)
    return stream.getvalue()

class Contract(unittest.TestCase):
    def test_valid(self):self.assertEqual(len(rows(text(fixture()),CASES[0])),2)
    def rejects(self,edit):
        data=fixture();edit(data)
        with self.assertRaises((RuntimeError,ValueError,KeyError)):rows(text(data),CASES[0])
    def test_duplicate_type(self):self.rejects(lambda x:x[1].update(filter=TYPES[0]))
    def test_semantics(self):self.rejects(lambda x:x[1].update(false_positives='2'))
    def test_median(self):self.rejects(lambda x:x[1].update(insert_ns='4'))
    def test_nonfinite(self):self.rejects(lambda x:x[1].update(insert_trials_ns='[1, NaN]'))
    def test_trial_count(self):self.rejects(lambda x:x[1].update(insert_trials_ns='[2]'))
    def test_geometry(self):self.rejects(lambda x:x[1].update(filter_bytes='256'))
    def test_phase(self):self.rejects(lambda x:x[1].update(query_phase_order='P>H;H>P'))
    def test_dangling_output(self):
        with tempfile.TemporaryDirectory()as directory:
            path=Path(directory)/'dangling';path.symlink_to(Path(directory)/'missing')
            with self.assertRaises(RuntimeError):new_path(path)

if __name__=='__main__':unittest.main()
