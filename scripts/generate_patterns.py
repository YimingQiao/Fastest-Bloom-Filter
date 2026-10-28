#!/usr/bin/env python3
"""Deterministic cyclic four-bit masks; penalize repeated pairs and triples."""
import argparse
import itertools
from collections import Counter

def generate(count,bits=4):
    candidates=[]
    for comb in itertools.combinations(range(1,32),bits-1):
        mask=1+sum(1<<x for x in comb)
        rotations=[((mask<<r)|(mask>>(32-r)))&0xffffffff for r in range(32)]
        if mask!=min(rotations):
            continue
        pairs,triples=Counter(),Counter()
        for r in range(32):
            bits=sorted((x+r)%32 for x in (0,)+comb)
            pairs.update(itertools.combinations(bits,2))
            triples.update(itertools.combinations(bits,3))
        candidates.append((mask,pairs,triples))
    used_pairs,used_triples=Counter(),Counter()
    chosen=[]
    for _ in range(count):
        def score(v):
            return sum((used_pairs[p]+f)**2-used_pairs[p]**2 for p,f in v[1].items())+8*sum((used_triples[p]+f)**2-used_triples[p]**2 for p,f in v[2].items())
        best=min(candidates,key=score)
        chosen.append(best[0]);used_pairs.update(best[1]);used_triples.update(best[2]);candidates.remove(best)
    return chosen

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--count',type=int,default=32)
    parser.add_argument('--bits',type=int,choices=[3,4],default=4)
    args=parser.parse_args()
    print(', '.join(hex(v) for v in generate(args.count,args.bits)))
