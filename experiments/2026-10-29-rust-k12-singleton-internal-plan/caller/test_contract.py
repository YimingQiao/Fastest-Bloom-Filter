import copy
import json
import unittest
from unittest.mock import patch
import contract as c

def rows(batch=1):
    return [dict(filter=arm,keys=256,queries=4096,batch=batch,hit=50,seed=74381,repeats=4,
                 filter_bytes=768,backend='avx512',input_digest=11,insert_digest=12,
                 bitmap_digest=13,output_digest=14,scratch_bytes=min(batch,4096)*8,
                 phase_order=c.FOUR if batch==1 else c.TWO,
                 calibration_queries=0,round=1,stage='check',trials_ns=[[1.0]*4 for _ in range(4 if batch==1 else 2)])
            for arm in ['Control','Candidate']]

class Guards(unittest.TestCase):
    def validate(self, value, case):
        reference=rows(case['batch'])
        for row in reference:
            row.pop('round');row.pop('stage')
        with patch('pathlib.Path.read_text',return_value='\n'.join(json.dumps(r) for r in reference)):
            c.validate_rows(value,case,'native')
    def test_bounded_coverage_and_reverse(self):
        self.assertEqual(len(c.cases()),5)
        for case in c.cases():
            value=rows(case['batch'])
            if case['reverse']:
                value.reverse()
                for row in value:row['round']=2
            self.validate(value,case)
    def test_failures(self):
        for key,bad in [('backend','avx2'),('output_digest',99),('filter_bytes',769),('queries',4095),('seed',1),('stage','measure')]:
            value=rows();value[0][key]=bad
            with self.subTest(key=key),self.assertRaises(ValueError):self.validate(value,dict(batch=1,reverse=False))
    def test_missing_partial_or_nonfinite(self):
        for value in [[],rows()[:1],rows()+rows()]:
            with self.assertRaises(ValueError):self.validate(value,dict(batch=1,reverse=False))
        value=rows();value[0]['trials_ns'][0][0]=float('nan')
        with self.assertRaises(ValueError):self.validate(value,dict(batch=1,reverse=False))
    def test_reverse_is_not_relabeling(self):
        value=rows()
        for row in value:row['round']=2
        with self.assertRaises(ValueError):self.validate(value,dict(batch=1,reverse=True))
    def test_formal_rejections_are_pre_execution(self):
        invalid=c.invalid('/frozen/bin')
        self.assertEqual(len(invalid),4)
        self.assertEqual(sum(command[1]=='--measure' for command,_ in invalid),3)
        self.assertTrue(all(message.startswith('outside fixed ') for _,message in invalid))

if __name__=='__main__':unittest.main()
