#!/usr/bin/env python3
"""Choose seeds only from the source-derived three-row ordering, with no data/timings."""
import itertools,json
from pathlib import Path
HERE=Path(__file__).resolve().parent
NAMES=('ByteSplitBloomFilter','ByteTripleHintControl','ByteOnlyInlineV1')
CANDIDATES=range(2000003,2000515)
def order(seed,power,qpower=22,hit=50):
    n,q=1<<power,1<<qpower
    present=q//100*hit+min(q%100,hit)
    mask=(1<<64)-1;gamma=0x9e3779b97f4a7c15
    state=(seed+gamma*(n+present+q-1))&mask
    jobs=list(NAMES)
    for width in (3,2):
        state=(state+gamma)&mask
        x=((state^(state>>30))*0xbf58476d1ce4e5b9)&mask
        x=((x^(x>>27))*0x94d049bb133111eb)&mask
        x^=x>>31
        j=x%width;jobs[width-1],jobs[j]=jobs[j],jobs[width-1]
    return jobs

def select():
    orders={s:[order(s,p) for p in (16,25)] for s in CANDIDATES}
    for a,b in itertools.combinations(CANDIDATES,2):
        if all(orders[a][i]==list(reversed(orders[b][i])) for i in (0,1)):
            return [a,b],orders
    raise ValueError('No reverse-order seed pair in fixed source-only candidate range')
if __name__=='__main__':
    seeds,orders=select()
    value=dict(algorithm='Lexicographically first ascending pair from 2000003..2000514 whose three-row permutations are exact reversals at both n16 and n25; no measurements or FPR data read',candidate_ids=list(CANDIDATES),candidate_orders={str(s):v for s,v in orders.items()},selected_seeds=seeds,selected_orders={str(s):orders[s] for s in seeds},coverage='Requested bpk and batch do not advance workload RNG. All three filters are present at every batch, so both powers cover all16 size/budget/batch groups.',pair_order_balance='Each original/triple/one-hint pair appears first once and second once at each group',limitation='Two reverse permutations leave the middle configuration in the middle; absolute position is not balanced. Same-binary three-way controls and all losses remain visible.')
    (HERE/'seed-selection.json').write_text(json.dumps(value,indent=2)+'\n')
    print(seeds)
