#!/usr/bin/env python3
"""Render every prespecified metric group; no new selection or aggregation."""
import csv,json
from pathlib import Path
HERE=Path(__file__).resolve().parent;DATA=HERE/'report'
OLD='FourSectorRange12BloomFilter';NEW='FourSectorRange12InlineV1';RANGE='Split64RangeBloomFilter'
QUERY=['lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns'];BUILD=['insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']
def main():
    conditions=json.loads((DATA/'conditions.json').read_text());pairs=list(csv.DictReader((DATA/'pairs.csv').open()));meta=json.loads((DATA/'metadata.json').read_text())
    def count(rival,candidate,metrics):
        p=[r for r in pairs if r['rival']==rival and r['candidate']==candidate and r['metric']in metrics]
        return '/'.join(str(sum(r['outcome']==v for r in p))for v in['win','loss','tie'])
    def table(rival,metrics,labels):
        s=['| Keys / batch | '+' | '.join(labels)+' |','|---|'+'---|'*4]
        for n in [65536,33554432]:
            for b in [1,3,31,4096]:
                cells=[]
                for metric in metrics:
                    r=next(x for x in conditions if x['rival']==rival and x['candidate']==NEW and x['keys']==n and x['batch']==b and x['metric']==metric)
                    cells.append(f"{r['ratio_min']:.5f}–{r['ratio_max']:.5f} ({r['wins']}/{r['losses']})")
                s.append('| '+('64K'if n==65536 else'32M')+f' / {b} | '+' | '.join(cells)+' |')
        return '\n'.join(s)
    text=f'''# Rust K12 two-hint internal screen: retain as experiment

The fixed72-row screen does **not support promoting this two-hint change**. The actual public singleton chain is expanded, but its visible gains are modest and several staged/bulk contracts regress. The unchanged Split64Range control still wins every batch1/3, visible-query and construction comparison. No production code was changed.

All24 commands completed in one measurement session onCPU3 under the whole socket1 flock. The three seeds were already observed in Rust108; this is an internal code-generation/regression comparison, not fresh validation against external libraries. Source `{meta['source_commit']}`, complete raw `{meta['raw_commit']}`, executable SHA `{meta['binary_sha256']}`. Raw52 files plus manifest were committed before numerical interpretation. Every actual payload is24 bits/key; all three filters run in the same process per case.

## All comparisons retained

The tables show the minimum–maximum ratio across all three seeds, followed by win/loss counts. Ratio=rival latency/candidate latency; **greater than1 favors the two-hint candidate**. The eight samples within each query-trial vector, full minima/maxima and individual losses remain in `report/pairs.csv`. There are576 named pairs,192 three-seed condition groups,384 pair-order strata and144 staged/visible API ratios.

| Rival / candidate | Query win/loss/tie (96) | Build win/loss/tie (96) |
|---|---:|---:|
| Original K12 / two-hint K12 | {count(OLD,NEW,QUERY)} | {count(OLD,NEW,BUILD)} |
| Split64Range / two-hint K12 | {count(RANGE,NEW,QUERY)} | {count(RANGE,NEW,BUILD)} |
| Split64Range / original K12 | {count(RANGE,OLD,QUERY)} | {count(RANGE,OLD,BUILD)} |

### Original K12 / two-hint K12: query contracts

{table(OLD,QUERY,['Staged prehashed','Staged common-hash+query','Visible prehashed','Visible fused common hash'])}

Small-table visible prehashed ratios are1.03994–1.04519 and fused ratios1.00945–1.01359 across all batch tags. Batch3 improves both staged contracts at both sizes. However, small batch1 common-hash+query loses on all three seeds, small batch31 loses both staged contracts on all seeds, and large batch4096 loses both staged contracts on all seeds (pure ratio0.96034–0.96683). Large visible prehashed results are mixed or losing; the fused changes are mostly around1%. These are descriptive ratios, not significance claims. The visible whole-array loop contract is unchanged by its batch tag.

### Split64Range / two-hint K12: query contracts

{table(RANGE,QUERY,['Staged prehashed','Staged common-hash+query','Visible prehashed','Visible fused common hash'])}

The retained narrow staged niche remains: both query contracts win on all seeds for small batches31/4096 and large batch31. Large batch4096 prehashed remains slower, while its hash+query result is mixed. Every visible and batch1/3 comparison loses. The extra nineteenth query win is one large4096 hash+query seed, not a new all-seed niche. This screen contains no external library; it does not revise external-leadership claims.

### Original K12 / two-hint K12: construction

{table(OLD,BUILD,['Insert','Allocate+insert','Hash+insert','Allocate+hash+insert'])}

### Split64Range / two-hint K12: construction

{table(RANGE,BUILD,['Insert','Allocate+insert','Hash+insert','Allocate+hash+insert'])}

Every one of the96 construction comparisons against Range loses. Original/new insertion bodies are byte-identical. Allocation-inclusive small-table variation is large and can reflect allocator placement, row order and code layout; it is not isolated evidence of a changed insertion algorithm. Build boundaries retain the original fixed ordering and stored medians only. There are no recorded build-trial vectors from which to manufacture confidence intervals.

## What the code-generation proof established

Excluding clone crate identity, the only native source delta is two existing `#[inline]` annotations becoming `#[inline(always)]`, on public `contains_hash` and private `contains_scalar`. Actual visible callers contain no hot singleton helper calls; original callers still call the scalar helper per key. This did not eliminate register pressure: candidate callers save six registers and use136/120-byte frames versus72 bytes for the old callers. Captured candidate visible symbol spans grow to656/688 bytes from192/224; public batch lookup expands from6336 to7664 bytes, including scalar/remainder paths. Repeated bounds checks and address arithmetic remain. Symbol spans include padding; they are not isolated hot-loop sizes. See [the exact proof](../2026-10-29-rust-k12-singleton-inline/proof/REPORT.md).

No further annotation or routing variant was selected after these measurements. A future separate hypothesis could take one safe cache-line reference for the four in-line words to remove repeated address/bounds work; that is not implemented or measured here. Removing a call alone was not enough to close the observed gap.

## Quality and limits

All old/new full bitmap/output fixtures passed normal and ASan. Every formal row reproduces the prior construction's mixed-query count/checksum; all new calibration counters are0. The12 historical independent size/seed/family records remain unpooled context, with the clone explicitly aliasing original K12. Their old two-sided95% Wilson upper endpoints remain below0.01%; no new FPR estimate or extra independent evidence is claimed.

The candidate occupies first/middle/last at each size, and every pair appears in both directions. With three seeds the pair counts are2:1, not exactly balanced. All384 order-stratified summaries remain available; prior inputs and repeated batch tags are not independent samples. No NUMA memory-placement policy was set. The original Rust108 losses, all current regression rows and the unchanged controls remain in the archive. The decision is to preserve the two-hint candidate as an unsuccessful general improvement experiment and retain the original implementation.
'''
    (HERE/'REPORT.md').write_text(text)
if __name__=='__main__':main()
