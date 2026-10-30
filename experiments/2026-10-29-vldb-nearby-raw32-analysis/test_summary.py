import copy,sys,unittest
from pathlib import Path
from summarize import *
sys.path.insert(0,str(SCREEN))
from test_contract import fake
from screen_contract import plan

def rows():return [dict(round=item['round'],**fake(item))for item in plan()]
def all_quality(data,fp):
    for row in data:row['calibration_false_positives']=str(fp)

def set_time(row,value):
    for mode in MODES:row[mode+'_ns']=str(value)

class Tests(unittest.TestCase):
    def test_complete_counts(self):
        result=calculate(rows())
        self.assertEqual((len(result['quality_api']),len(result['quality_mapping']),len(result['views']),len(result['alternatives']),len(result['paired']),len(result['paired_rounds'])),(80,48,72,2160,168,84))
        self.assertTrue(all(r['negatives']==1<<24 and not r['pooled']for r in result['quality_mapping']))
    def test_nested_actual_allocation(self):
        data=rows();all_quality(data,0)
        for row in data:set_time(row,10)
        for row in data:
            if row['filter']=='FastPatternBF'and row['requested_bpk']=='12':set_time(row,1)
        result=calculate(data)
        for view in result['views']:
            self.assertEqual(view['leaders']['overall']['leaders'][0]['filter'],'FastPatternBF')
            self.assertEqual(view['leaders']['overall']['leaders'][0]['actual_bpk'],8)
    def test_ineligible_fast_config_retained(self):
        data=rows();all_quality(data,0)
        for row in data:
            set_time(row,10)
            if row['filter']=='FourSectorRange12Experiment':
                set_time(row,1);row['calibration_false_positives']=str(1<<24)
        result=calculate(data)
        k12=[r for r in result['alternatives']if r['filter']=='FourSectorRange12Experiment']
        self.assertTrue(k12 and all(not r['eligible']for r in k12))
        self.assertTrue(all(v['leaders']['project_experiment']is None for v in result['views']))
    def test_alias_corruption(self):
        data=rows();data[2]['calibration_false_positives']=str(int(data[2]['calibration_false_positives'])+1)
        with self.assertRaises(ValueError):calculate(data)
    def test_latency_ratio_and_both_rounds(self):
        data=rows()
        for row in data:
            set_time(row,2 if row['filter'].endswith('/original')else 1 if row['round']==0 else 4)
        result=calculate(data)
        self.assertTrue(all(p['nearby_over_original_latency']==(.5 if p['round']==0 else 2)for p in result['paired']))
        self.assertTrue(all(p['outcome']=='mixed'and p['worst_latency_ratio']==2 for p in result['paired_rounds']))
    def test_no_comparable_not_win(self):
        data=rows();all_quality(data,1<<24);result=calculate(data)
        self.assertEqual(result['view_outcomes'],{'no_comparable':72})
        self.assertEqual(len(result['paired']),168)
    def test_wilson_endpoints(self):
        lo,hi=wilson(0,1<<24);self.assertAlmostEqual(lo,0);self.assertGreater(hi,0)
        lo,hi=wilson(1<<24,1<<24);self.assertLess(lo,1);self.assertAlmostEqual(hi,1)
        with self.assertRaises(ValueError):wilson(2,1)
    def test_immutable_anchor(self):
        with self.assertRaises(ValueError):exact('HEAD',HERE/'README.md')
if __name__=='__main__':unittest.main()
