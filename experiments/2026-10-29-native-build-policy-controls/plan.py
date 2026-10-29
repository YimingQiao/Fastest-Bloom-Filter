"""Source-only fixed negative-control proposal; no filter/compiler/timing entry."""
import json
from collections import Counter

SEEDS=(2694173,3819257)
FAMILIES=('Split64','Split64Range')
LANGUAGES=('cpp','rust')
REQUESTS={'cpp':4,'rust':8}
ARMS=('A0','A1','Clone','Policy')
SCHEDULE=(('A0','A1','Policy','Clone'),
          ('A1','Clone','A0','Policy'),
          ('Clone','Policy','A1','A0'),
          ('Policy','A0','Clone','A1'))
CYCLES=8
REPEATS=32

def scenario(family,index):
    above=524288 if family=='Split64'else 262208
    large=67108864 if family=='Split64'else 100663296
    return [dict(name='small_empty_uniform',bytes=262144,batch_n=65536,history_n=0,hotspot=False),
            dict(name='above_batch_empty_uniform',bytes=262144,batch_n=65537,history_n=0,hotspot=False),
            dict(name='small_prefilled_hotspot',bytes=262144,batch_n=65536,history_n=131072,hotspot=True),
            dict(name='above_bytes_empty_uniform',bytes=above,batch_n=65536,history_n=0,hotspot=False),
            dict(name='large_empty_uniform',bytes=large,batch_n=65536,history_n=0,hotspot=False)][index]

def ledger():
    base=[(family,language,index)for index in range(5)for family in FAMILIES for language in LANGUAGES]
    result=[]
    for seed_index,seed in enumerate(SEEDS):
        for family,language,index in base if seed_index==0 else reversed(base):
            row=scenario(family,index)
            row.update(case_index=len(result),scenario=index,family=family,language=language,
                       requested=REQUESTS[language],seed=seed,input_base=seed<<42,repeats=REPEATS,cycles=CYCLES,
                       contracts=['insert']+([]if row['history_n']else['allocate_insert']))
            result.append(row)
    return result

def arm_order(repeat):
    return SCHEDULE[repeat%4]

def contract_order(case,repeat):
    return ['insert']if case['history_n']else(['insert','allocate_insert']if (repeat//4+repeat)%2==0 else['allocate_insert','insert'])

def validate(cases):
    assert cases==ledger()and len(cases)==40
    assert len({(x['language'],x['family'],x['scenario'],x['seed'])for x in cases})==40
    assert all(Counter(row[i]for row in SCHEDULE)==Counter(ARMS)for i in range(4))
    transitions=Counter((row[i],row[i+1])for row in SCHEDULE for i in range(3))
    assert transitions==Counter((a,b)for a in ARMS for b in ARMS if a!=b)
    for c in cases:
        assert c['input_base']+(2<<40)+32771<(c['seed']+1)<<42<=1<<64
        if not c['history_n']:
            for position in range(2):
                assert Counter(contract_order(c,r)[position]for r in range(REPEATS))==Counter(insert=16,allocate_insert=16)
    contracts=sum(len(c['contracts'])for c in cases)
    assert contracts==72
    return dict(process_cases=40,unique_cells=20,seed_cases=2,empty_cases=32,populated_cases=8,
                contracts=contracts,arm_records=160,arm_metric_vectors=288,repeats=32,cycles=8,
                timed_fresh_bitmap_lifetimes=contracts*REPEATS*len(ARMS),untimed_oracle_lifetimes=40)

if __name__=='__main__':
    rows=ledger();print(json.dumps(dict(counts=validate(rows),cases=rows),indent=2))
