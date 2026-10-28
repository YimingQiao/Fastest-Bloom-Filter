"""Synthetic candidate fixtures from pinned controls; no candidate execution/data."""
import copy,csv,subprocess,sys,unittest
from pathlib import Path
from quality_guard import HERE,NAMES,validate,wilson

def fixture():
    with (HERE/'parent-quality-reference.csv').open() as stream:
        parents=list(csv.DictReader(stream))
    out=[]
    for i in range(0,len(parents),2):
        out.extend(copy.deepcopy(parents[i:i+2]))
        synthetic=copy.deepcopy(parents[i]);synthetic['filter']=NAMES[-1];out.append(synthetic)
    return out

class Guards(unittest.TestCase):
    def test_synthetic_contract_and_cardinality(self):self.assertEqual(len(validate(fixture())),24)
    def test_missing_duplicate_reordered_rows(self):
        rows=fixture()
        for broken in (rows[:-1],rows+[rows[0]],rows[1:]+rows[:1]):
            with self.assertRaises(ValueError):validate(broken)
    def test_wrong_geometry_quality_or_timing_columns(self):
        for key,value in [('filter','Unknown'),('keys','1'),('actual_bpk','8'),('filter_bytes','1'),('seed','43'),('calibration_negatives','1'),('false_positives',str((1<<24)+1)),('checksum','-1'),('lookup_ns','2')]:
            rows=fixture();rows[2][key]=value
            with self.assertRaises(ValueError):validate(rows)
    def test_control_changed_without_candidate_data(self):
        rows=fixture();rows[0]['false_positives']=str(int(rows[0]['false_positives'])^1)
        with self.assertRaisesRegex(ValueError,'pinned semantic'):validate(rows)
    def test_exact_wilson_endpoints_and_bad_counts(self):
        self.assertEqual(wilson(0,100)[0],0);self.assertEqual(wilson(100,100)[1],1)
        for fp,n in [(0,0),(-1,10),(11,10)]:
            with self.assertRaises(ValueError):wilson(fp,n)
    def test_optimized_runner_rejected_before_artifacts(self):
        r=subprocess.run([sys.executable,'-O',str(HERE/'calibrate.py')],capture_output=True,text=True)
        self.assertNotEqual(r.returncode,0);self.assertIn('without Python -O',r.stderr);self.assertEqual(r.stdout,'')
if __name__=='__main__':unittest.main()
