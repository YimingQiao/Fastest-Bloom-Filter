import json,unittest
from pathlib import Path
import plan
class Proposal(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.data=json.loads((Path(__file__).parent/'selection.json').read_text())
    def test_complete_reproduction(self):self.assertEqual(plan.derive(),self.data)
    def test_source_draw_count_including_remainder_hits(self):
        registry=['a','b','c','d'];seed=971;power=3;q=137
        # Independently walk one key-base draw, n-1 insertion swaps, every
        # positive-query draw, then q-1 query swaps; only final state matters.
        state=seed
        def draw():
            nonlocal state
            state=(state+plan.STEP)&plan.MASK
            return plan.mix(state)
        draw()
        for _ in range((1<<power)-1):draw()
        for i in range(q):
            if i%100<50:draw()
        for _ in range(q-1):draw()
        expected=registry.copy()
        for count in range(len(expected),1,-1):
            j=draw()%count;expected[count-1],expected[j]=expected[j],expected[count-1]
        self.assertEqual(plan.order(power,seed,registry,registry,q),expected)
        self.assertEqual((1<<22)//100*50+min((1<<22)%100,50),(1<<22)//2+2)
    def test_nested_capacity_and_all_leaders(self):
        d=self.data;self.assertEqual(len(d['training_decisions']),96)
        for view in d['training_decisions']:
            for kind,items in view['eligible'].items():
                self.assertTrue(all(x['filter_bytes']*8<=view['keys']*view['cap_bpk']and x['wilson95_high']<=.0001 for x in items))
                leaders=view['leaders'][kind]
                if items:self.assertEqual(min(x['ns']for x in items),min(x['ns']for x in leaders))
        self.assertTrue(any(v['cap_bpk']==32 and any(x['actual_bpk']==24 for x in v['eligible']['external'])for v in d['training_decisions']))
        self.assertEqual({x['filter']for x in d['complete_training_api_quality']},set(d['original_registry']))
    def test_seed_order_domains_and_no_outcome_selection(self):
        d=self.data;accepted=[x for x in d['seed_selection']['candidate_ledger']if x['accepted']];self.assertEqual(len(accepted),3)
        old=[x['full_counter_envelope']for x in d['seed_selection']['prior_domains']];fresh=[]
        for pos,row in enumerate(accepted):
            self.assertEqual(row['positions'],{'16':pos,'25':pos})
            for dom in row['domains']:
                new=dom['full_counter_envelope'];self.assertTrue(all(not plan.overlaps(new,x)for x in old+fresh));fresh.append(new)
        self.assertFalse(plan.overlaps([0,1],[1,2]));self.assertTrue(plan.overlaps([0,2],[1,3]))
    def test_fixed_panel_counts_and_quality_identity(self):
        d=self.data;cases=d['cases'];self.assertEqual(len(cases),36);self.assertEqual(sum(len(x['filters'])for x in cases),108)
        ids={(x['key_power'],x['budget_bpk'],x['seed'],name)for x in cases for name in x['filters']};self.assertEqual(len(ids),36)
        for power in(16,25):
            for seed in d['seed_selection']['fresh_seeds']:
                for budget in(24,32):
                    panels=[x['filters']for x in cases if x['key_power']==power and x['seed']==seed and x['budget_bpk']==budget];self.assertEqual(len(panels),3);self.assertTrue(all(x==panels[0]for x in panels))
                    if budget==24:self.assertIn(plan.CANDIDATE,panels[0])
                    else:self.assertNotIn(plan.CANDIDATE,panels[0])
if __name__=='__main__':unittest.main()
