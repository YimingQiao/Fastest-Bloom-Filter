#!/usr/bin/env python3
"""Select three additional seeds from row permutations only, before any measurements."""
import hashlib,itertools,json
from pathlib import Path
from guard import expected_filter_order,expected_names
HERE=Path(__file__).resolve().parent
ORIGINAL=(131071,524287,999983)
CANDIDATES=range(1000003,1000259)
GROUPS=((16,1),(16,3),(25,1),(25,3))
def signature(seed):
    values=[]
    for power,batch in GROUPS:
        order=expected_filter_order(seed,1<<power,1<<22,50,expected_names(batch))
        values.append(int(order.index('ByteSplitBloomFilter')<order.index('ByteLeafInlineV1')))
    return tuple(values)
def select():
    target=tuple(3-sum(signature(s)[i] for s in ORIGINAL) for i in range(len(GROUPS)))
    signatures={s:signature(s) for s in CANDIDATES}
    for triple in itertools.combinations(CANDIDATES,3):
        if tuple(sum(signatures[s][i] for s in triple) for i in range(len(GROUPS)))==target:
            return triple,target,signatures
    raise ValueError('No exact order-balanced triple in prespecified candidate range')
def main():
    triple,target,signatures=select()
    record=dict(purpose='Row-order-only seed selection; no key arrays, FPR results, or timing results read or generated',algorithm='Lexicographically first ascending triple from integers1000003..1000258 inclusive whose source-derived original-before-candidate bits complete3:3 balance in all four key-count/selected-registry groups',original_seeds=list(ORIGINAL),candidate_ids=list(CANDIDATES),group_order=[dict(key_power=p,batch=b,registry_size=3 if b==1 else 2) for p,b in GROUPS],original_signatures={str(s):signature(s) for s in ORIGINAL},required_added_original_first_counts=target,candidate_signatures={str(s):v for s,v in signatures.items()},selected_added_seeds=list(triple),selected_signatures={str(s):signature(s) for s in triple},balanced_total_original_first=[sum(signature(s)[i] for s in (*ORIGINAL,*triple)) for i in range(4)],coverage='Requested bpk does not affect RNG advances; batches3/31/4096 share two-name registry and order. Thus these four groups cover every size/budget/batch workload.',source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
    (HERE/'seed-selection.json').write_text(json.dumps(record,indent=2)+'\n')
    print('Selected only from source-derived order:',triple)
if __name__=='__main__':main()
