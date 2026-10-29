"""Preserve the initial proposal, correct only its pre-data row-order oracle."""
import copy
import json
from bindings import HERE,STAGE,PUBLIC,load_module,need
import subset_guard

def derive():
    plan=load_module('_strict24_order_original',STAGE/'plan.py')
    initial=plan.derive()
    need(initial==json.loads((STAGE/'selection.json').read_text()),'Historical initial selection changed')
    corrected=copy.deepcopy(initial)
    source=(PUBLIC/'benchmark/src/main.rs').read_text()
    protocol=json.loads((HERE/'runtime-protocol.json').read_text())
    q=1<<protocol['query_power'];hit=protocol['hit_percent']
    present=q//100*hit+min(q%100,hit)
    need(present==2097154,'Changed exact producer hit-count formula')
    changes=[]
    for index,item in enumerate(corrected['cases']):
        case=item['case'];n=1<<case['key_power']
        state=(case['seed']+plan.guard.STEP*(1+n-1+present+q-1))&plan.guard.MASK
        order=plan.guard.shuffled(case['filters'],state)
        need(order==subset_guard.expected_order(case,protocol,source),'Corrected independent/source guard order differs')
        if item['expected_filter_order']!=order:changes.append(index)
        item['expected_filter_order']=order
    proof=[]
    for n in [16,25]:
        for batch in [1,31,4096]:
            orders=[x['expected_filter_order']for x in corrected['cases']if x['case']['key_power']==n and x['case']['batch']==batch]
            need(orders[0]==list(reversed(orders[1])),'The fixed two seeds no longer balance pair order')
            proof.append(dict(key_power=n,batch=batch,seed_orders=orders,pair_order_balanced=True))
    corrected['pair_order_proof']=proof
    corrected['pre_data_order_correction']=dict(initial_proposal_commit='87300b66d60e6f55d9b200bad10b2e0b527b5521',
        reason='Producer uses i%100<hit, so q22/hit50 produces q/2+2 positive draws; initial proposal used q/2.',
        exact_present_queries=present,changed_case_order_indices=changes,seeds_unchanged=True,workloads_and_commands_unchanged=True,
        training_selection_and_quality_support_unchanged=True,new_filter_outputs_observed=False)
    return corrected

if __name__=='__main__':
    target=HERE/'corrected-selection.json';need(not target.exists(),'Preserve previous corrected ledger')
    target.write_text(json.dumps(derive(),indent=2)+'\n')
