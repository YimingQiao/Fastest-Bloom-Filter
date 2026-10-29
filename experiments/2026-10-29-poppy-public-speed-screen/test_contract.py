"""Synthetic bounded row/order/calibration guards; no actual filter invocation."""
import copy,unittest
import screen_contract as s
from guard import expected_geometry,expected_phases
def fixture(case):
    source=s.SOURCE.read_text();proto=s.row_protocol(case);q=1<<22;n=case['keys'];present=q//100*50+min(q%100,50)
    points={s.POINTS[i]['filter']:s.POINTS[i]for i in case['configuration_ids']};rows=[]
    for name in s.expected_order(case,proto,source):
        row={k:'0'for k in s.csv_fields(source)}
        row.update(language='rust',filter=name,keys=str(n),queries=str(q),requested_bpk=str(case['budget_bpk']),hash_bits='64',hit_percent='50',
          present_queries=str(present),absent_queries=str(q-present),batch=str(case['batch']),repeats='8',seed='42',result_checksum='123',input_mode='prehashed',
          insert_batch=str(n),calibration_absent_queries=str((1<<26)if case['calibration_power']else 0),calibration_false_positives='0',
          scalar_track='optimizer_visible_public_single',query_phase_order=expected_phases(42,8))
        row.update({k:str(v)for k,v in expected_geometry(name,n,case['budget_bpk']).items()})
        if points[name]['owner']=='poppy_external':
            prior=points[name]['prior_observation'];row.update(false_positives=str(prior['mixed_false_positives']),result_checksum=str(prior['result_checksum']),
                calibration_false_positives=str(prior['false_positives']if case['calibration_power']else 0),fpr=str(prior['mixed_false_positives']/(q-present)))
        for key in row:
            if key.endswith('_ns'):row[key]='1'
            if key.endswith('_trials'):row[key]='|'.join(['1']*8)
        rows.append(row)
    return dict(case=case,rows=rows)
def all_records():return [fixture(case)for case in s.plan()['cases']]
class Guards(unittest.TestCase):
    def test_exact_finite_ledger_and_counts(self):
        records=all_records();counts,quality,refs=s.validate_records(records)
        self.assertEqual((counts['rows'],len(quality),len(refs)),(486,81,486))
        self.assertTrue(all(q['absent']==1<<26 for q in quality))
    def test_opposite_complete_orders(self):
        cases=s.plan()['cases']
        for a,b in zip(cases[:18],reversed(cases[18:])):
            self.assertEqual((a['keys'],a['budget_bpk'],a['batch'],a['filters']),(b['keys'],b['budget_bpk'],b['batch'],b['filters']))
            self.assertEqual(s.expected_order(a,s.row_protocol(a),s.SOURCE.read_text())[::-1],s.expected_order(b,s.row_protocol(b),s.SOURCE.read_text()))
    def test_calibration_count_reject(self):
        r=all_records();r[0]['rows'][0]['calibration_absent_queries']=str(1<<24)
        with self.assertRaises(ValueError):s.validate_records(r)
    def test_reused_output_reject(self):
        r=all_records();r[1]['rows'][0]['result_checksum']='0'
        with self.assertRaises(ValueError):s.validate_records(r)
    def test_wrong_order_and_missing_case_reject(self):
        r=all_records();r[0]['rows'].reverse()
        with self.assertRaises(ValueError):s.validate_records(r)
        with self.assertRaises(ValueError):s.validate_records(all_records()[:-1])
    def test_no_quality_pruning(self):
        points=s.POINTS.values();self.assertEqual(sum(p['owner']=='poppy_external'for p in points),47)
        self.assertTrue(any(p['prior_observation']['false_positives']/(1<<26)>.0001 for p in points if p['owner']=='poppy_external'))
    def test_calibration0_no_new_denominator(self):
        r=all_records();r[1]['rows'][0]['calibration_false_positives']='1'
        with self.assertRaises(ValueError):s.validate_records(r)
    def test_public_cache_accounting(self):
        r=all_records();selected=next((record,row)for record in r for row in record['rows']if row['filter'].startswith('Poppy')and int(row['filter_bytes'])>int(row['logical_bytes']))
        selected[1]['filter_bytes']=selected[1]['logical_bytes']
        with self.assertRaises(ValueError):s.validate_records(r)
if __name__=='__main__':unittest.main()
