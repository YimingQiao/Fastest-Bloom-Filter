#!/usr/bin/env python3
"""Render every fixed metric group without candidate or workload selection."""
import csv,json
from pathlib import Path
HERE=Path(__file__).resolve().parent;DATA=HERE/'report'
OLD='FourSectorRange12BloomFilter';NEW='FourSectorRange12SingleLineV1';RANGE='Split64RangeBloomFilter'
QUERY=['lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns']
BUILD=['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']
def main():
    conditions=json.loads((DATA/'conditions.json').read_text());pairs=list(csv.DictReader((DATA/'pairs.csv').open()));meta=json.loads((DATA/'metadata.json').read_text())
    def count(rival,candidate,metrics):
        selected=[r for r in pairs if r['rival']==rival and r['candidate']==candidate and r['metric']in metrics]
        return '/'.join(str(sum(r['outcome']==value for r in selected))for value in ['win','loss','tie'])
    def table(rival,metrics,labels):
        out=['| Keys / batch | '+' | '.join(labels)+' |','|---|'+'---|'*4]
        for n in [65536,33554432]:
            for batch in [1,3,31,4096]:
                values=[]
                for metric in metrics:
                    row=next(r for r in conditions if r['rival']==rival and r['candidate']==NEW and r['keys']==n and r['batch']==batch and r['metric']==metric)
                    values.append(f"{row['ratio_min']:.5f}–{row['ratio_max']:.5f} ({row['wins']}/{row['losses']})")
                out.append('| '+('64K'if n==65536 else'32M')+f' / {batch} | '+' | '.join(values)+' |')
        return '\n'.join(out)
    text=f'''# Rust K12 safe SingleLine: complete internal screen

All24 fixed commands completed, retaining72 rows and all eight metric boundaries. This compares one safe scalar-body change with original K12 and unchanged Split64Range, at equal actual24 bits/key. The three seeds were already observed in Rust108; this is an internal regression screen, not fresh validation against external libraries.

Source `{meta['source_commit']}`, committed complete raw `{meta['raw_commit']}`, executable SHA `{meta['binary_sha256']}`. Raw52 files plus manifest were committed before numerical interpretation. Each three-filter workload executes in one process on CPU3 under the whole socket1 flock; no NUMA memory-placement policy was set.

## Complete ratios

Ratio is rival latency divided by the named denominator's latency; greater than1 favors the denominator. Each table cell retains the minimum–maximum ratio across all three seeds and win/loss counts. All576 named pairs,192 three-seed groups,384 pair-order strata and144 staged/visible API ratios are archived. Query pairs retain all eight samples per trial vector and measured minima/maxima. Build measurements retain medians only; no build-trial vectors or confidence intervals are invented.

| Rival / denominator | Query win/loss/tie (96) | Build win/loss/tie (96) |
|---|---:|---:|
| Original K12 / SingleLine K12 | {count(OLD,NEW,QUERY)} | {count(OLD,NEW,BUILD)} |
| Split64Range / SingleLine K12 | {count(RANGE,NEW,QUERY)} | {count(RANGE,NEW,BUILD)} |
| Split64Range / original K12 | {count(RANGE,OLD,QUERY)} | {count(RANGE,OLD,BUILD)} |

### Original K12 / SingleLine: query contracts

{table(OLD,QUERY,['Staged prehashed','Staged common-hash+query','Visible prehashed','Visible fused common hash'])}

### Split64Range / SingleLine: query contracts

{table(RANGE,QUERY,['Staged prehashed','Staged common-hash+query','Visible prehashed','Visible fused common hash'])}

The visible whole-array query loops do not change contract with the batch tag. Repeated batch tags are retained observations, not extra independent quality samples.

### Original K12 / SingleLine: construction

{table(OLD,BUILD,['Insert','Allocate+insert','Hash+insert','Allocate+hash+insert'])}

### Split64Range / SingleLine: construction

{table(RANGE,BUILD,['Insert','Allocate+insert','Hash+insert','Allocate+hash+insert'])}

Insertion bodies and allocation policies are unchanged. Measured construction differences can reflect code layout, row order and allocator placement; this comparison does not isolate a new insertion algorithm. The original fixed ordering of build boundaries is preserved.

## Exact source and code-generation evidence

The only production-body delta in the isolated native crate borrows `self.lines[indices[0] >> 4]` once and accesses its four words through `index & 15`. Every probe differs only in the low four word-index bits; an independent u128 boundary test checks the physical-line invariant, including non-power-of-two and maximum capacities without huge allocations. Original public/private ordinary `#[inline]` hints remain unchanged. There is no new unsafe block, mask/address/dispatch change, or insertion/parallel change. The rejected two-hint implementation is not linked.

Actual candidate visible callers have one global line bound check and no successful-path scalar-helper calls. Original visible callers retain one helper call per key. Candidate callers still save six registers, with72/104-byte pure/fused frames versus72/72 for the original. Captured symbol spans are448/496 versus192/224 bytes; public batch lookup expands from6336 to7088 bytes. These spans include padding, and call removal does not establish a speed gain by itself. See [the exact passed proof](../2026-10-29-rust-k12-single-line/proof/REPORT.md).

## Quality and scope

Normal and ASan full-bitmap/output fixtures passed. Each formal row reproduces the original construction's complete mixed-query count/checksum. Calibration is0 throughout this screen. Twelve historical independent size/seed/family records remain unpooled context; SingleLine aliases original K12 and supplies no new FPR estimate. Their old Wilson upper endpoints remain below0.01%.

The candidate is first/middle/last at each size, and every pair occurs in both directions, with2:1 pair counts rather than perfect balance. All per-seed and order-stratified losses remain. There is no external library in this screen, no fresh-seed leadership claim and no production promotion implied by these tables. The previous original Rust108 and rejected two-hint losses remain separately archived.
'''
    (HERE/'REPORT.md').write_text(text)
if __name__=='__main__':main()
