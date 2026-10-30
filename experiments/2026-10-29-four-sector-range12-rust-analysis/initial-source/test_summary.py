import copy,importlib.util,unittest
from pathlib import Path
import summarize as s
from contract import configuration,quality
spec=importlib.util.spec_from_file_location('synthetic_source',s.STAGE/'screening/test_contract.py');fixture=importlib.util.module_from_spec(spec);spec.loader.exec_module(fixture)

def sample():return [r for c in configuration()[1]['cases']for r in fixture.synthetic(c)]
class SummaryGuards(unittest.TestCase):
    def test_fixed_cardinality_and_no_pool(self):
        rows=sample();result=s.analyze(rows,quality(rows))
        self.assertEqual({k:len(result[k])for k in ['pairs','conditions','views','alternatives','api_ratios','order_strata']},dict(pairs=720,conditions=240,views=288,alternatives=1728,api_ratios=216,order_strata=48))
        self.assertEqual(len(result['quality']['api_geometry_seed_records']),36);self.assertEqual(len(result['quality']['all_three_seed_gates']),12)
    def test_cap32_admits_actual24_and_cap24_excludes32(self):
        result=s.analyze(sample(),quality(sample()));views=result['views']
        small=next(x for x in views if x['keys']==65536 and x['cap_bpk']==32)
        self.assertEqual(len(small['leaders']['main_all_three']['all']['ties']),7)
        narrow=next(x for x in views if x['keys']==65536 and x['cap_bpk']==24)
        self.assertEqual(len(narrow['leaders']['main_all_three']['all']['ties']),3)
        self.assertIn('cross processes',small['scope'])
    def test_single_failed_seed_preserves_unconditional_candidate(self):
        rows=sample();seed=configuration()[0]['seeds'][0]
        for r in rows:
            if r['filter']==s.CANDIDATE and int(r['keys'])==65536 and int(r['seed'])==seed:r['calibration_false_positives']='10000'
        result=s.analyze(rows,quality(rows));v=next(x for x in result['views']if x['keys']==65536 and x['seed']!=seed)
        self.assertIsNone(v['leaders']['main_all_three']['K12_experiment']);self.assertIsNotNone(v['leaders']['current_seed']['K12_experiment']);self.assertIsNotNone(v['leaders']['unconditional']['K12_experiment'])
        self.assertEqual(len(result['pairs']),720)
    def test_each_contract_ranks_independently(self):
        rows=sample()
        for r in rows:
            if r['filter']=='Fastbloom017K7':r['lookup_ns']='0.5';r['insert_ns']='20'
            if r['filter']==s.CANDIDATE:r['insert_ns']='0.25'
        result=s.analyze(rows,quality(rows));small=[v for v in result['views']if v['keys']==65536 and v['cap_bpk']==24]
        lookup=next(v for v in small if v['metric']=='lookup_ns');build=next(v for v in small if v['metric']=='insert_ns')
        self.assertEqual(lookup['leaders']['main_all_three']['all']['ties'][0]['filter'],'Fastbloom017K7')
        self.assertEqual(build['leaders']['main_all_three']['all']['ties'][0]['filter'],s.CANDIDATE)
    def test_build_rows_do_not_invent_trials(self):
        result=s.analyze(sample(),quality(sample()))
        self.assertTrue(all(not x['candidate_trials']and not x['rival_trials']for x in result['pairs']if x['metric_kind']=='build'))
        self.assertTrue(all(x['candidate_trials']for x in result['pairs']if x['metric_kind']=='query'))
    def test_owner_and_tie_loss_scope(self):
        result=s.analyze(sample(),quality(sample()))
        self.assertEqual({x['owner']for x in result['alternatives']},set(s.OWNERS))
        self.assertTrue(all(x['unconditional_outcome']=='tie'for x in result['pairs']))
        self.assertTrue(all(x['ties']==3 for x in result['conditions']))
        self.assertTrue(all(x['candidate_primary_position']in [0,1,2]for x in result['order_strata']))
    def test_missing_candidate_or_seed_rejected(self):
        rows=sample();q=quality(rows)
        with self.assertRaises(ValueError):s.analyze([r for r in rows if r['filter']!=s.CANDIDATE],q)
        with self.assertRaises(ValueError):s.analyze(rows[:-3],q)
    def test_raw_revision_must_be_immutable_before_read(self):
        with self.assertRaises(ValueError):s.load('main')
if __name__=='__main__':unittest.main()
