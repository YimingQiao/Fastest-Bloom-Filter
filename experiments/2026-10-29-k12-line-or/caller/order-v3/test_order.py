import csv,io,unittest
from derive import expected
from guards import CALLER,CASES,expected_order,validate

def text(records):
    out=io.StringIO();writer=csv.DictWriter(out,fieldnames=list(records[0]));writer.writeheader();writer.writerows(records);return out.getvalue()

class Order(unittest.TestCase):
    def fixture(self,index=0):return list(csv.DictReader(io.StringIO((CALLER/'validation-v2'/f'native-caller-{index}.stdout').read_text())))
    def test_prefix_unchanged(self):
        before,after,_=expected();self.assertEqual(before[:before.index('int main(')],after[:after.index('int main(')])
    def test_original(self):
        for i in range(2):self.assertEqual([r['filter']for r in validate(text(self.fixture(i)),i,False)],expected_order(CASES[i],False))
    def test_reverse(self):
        for i in range(2):self.assertEqual([r['filter']for r in validate(text(list(reversed(self.fixture(i)))),i,True)],expected_order(CASES[i],True))
    def test_wrong_flag_order_rejects(self):
        with self.assertRaises(RuntimeError):validate(text(self.fixture()),0,True)
    def test_semantic_corruption_rejects(self):
        data=self.fixture();data[0]['result_checksum']='0'
        with self.assertRaises(RuntimeError):validate(text(data),0,False)
if __name__=='__main__':unittest.main()
