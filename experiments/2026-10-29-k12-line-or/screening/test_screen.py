"""Small offline corruption guards; never execute a filter."""
import csv,io,json,unittest
from pathlib import Path
from screen_contract import plan,case,order,flag,command,parse,TYPES
HERE=Path(__file__).resolve().parent

class Guards(unittest.TestCase):
    def setUp(self):
        self.item=dict(index=0,keys_power=6,actual_bpk=24,hit_percent=50,query_power=12,query_batch=31,insert_batch=4,query_repeats=2,build_repeats=2,seed=74381)
        self.text=(HERE.parent/'caller/order-v3/validation-v1/native-case0-original.stdout').read_text()
    def change(self,fn):
        rows=list(csv.DictReader(io.StringIO(self.text)));fn(rows)
        stream=io.StringIO();writer=csv.DictWriter(stream,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(rows);return stream.getvalue()
    def test_fixed_ledger(self):
        records=plan();self.assertEqual(len(records),8)
        self.assertEqual({(r['keys_power'],r['insert_chunk'],r['seed']) for r in records}, {(n,c,s) for n in (16,25) for c in (4,'whole_input') for s in (5011,6011)})
    def test_balanced_order(self):
        groups={}
        for item in plan():
            groups.setdefault((item['keys_power'],item['insert_batch']),[]).append(order(case(item)))
        self.assertEqual(len(groups),4)
        for values in groups.values():self.assertEqual(values,[list(TYPES),list(reversed(TYPES))])
    def test_flag_and_command(self):
        for item in plan():
            self.assertEqual(command('/fixed/executable',item)[-1], 'reverse' if item['seed']==6011 else 'original')
        with self.assertRaises(RuntimeError):flag(self.item)
    def test_passed_tiny(self):self.assertEqual(len(parse(self.text,self.item)),2)
    def test_order_corruption(self):
        with self.assertRaises(RuntimeError):parse(self.change(lambda rows:rows.reverse()),self.item)
    def test_duplicate_filter(self):
        with self.assertRaises(RuntimeError):parse(self.change(lambda rows:rows[1].update(filter=rows[0]['filter'])),self.item)
    def test_bad_trial_summary(self):
        with self.assertRaises(RuntimeError):parse(self.change(lambda rows:rows[0].update(insert_ns='1e9')),self.item)
    def test_changed_output(self):
        with self.assertRaises(RuntimeError):parse(self.change(lambda rows:rows[0].update(result_checksum='0')),self.item)
    def test_trial_count(self):
        with self.assertRaises(RuntimeError):parse(self.change(lambda rows:rows[0].update(insert_trials_ns='[1]')),self.item)

if __name__=='__main__':unittest.main()
