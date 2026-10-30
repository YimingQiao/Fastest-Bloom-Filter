# Byte-only follow-up is warranted; production remains unchanged

The unchanged leaf executable completed 96 workloads / 216 rows on CPU2 with six seeds and exact 3:3 original/candidate order within each size/budget/batch group. Source/dependency/binary hashes and all semantic/phase/order checks passed. The initial CPU3 seed42 evidence remains archived separately.

Visible public singleton queries improve in all 192 paired comparisons (96 workload contexts × two visible modes; these are reused contexts, not 192 independent experiments). At batch1 the six-seed geometric original/candidate ratios are about1.47× prehashed and1.37× fused hash for small tables,1.21×/1.10× for large actual16-bpk tables, and1.26×/1.23× for large actual32-bpk tables.

The original large actual32-bpk batch3 regression does not recur at its earlier magnitude. New original/candidate geometric ratios are0.9992 prehashed and0.9982 raw; both order strata stay near parity. The lowest raw ratio is0.9945. This is evidence against attributing the earlier15% loss directly to extra bulk instructions, consistent with the archived machine-code equality. It is not proof of a particular cache/allocation/frequency cause.

All generic-mode losses remain. The worst per-seed original-batch ratio is0.9492 for large actual16 bpk/batch1; the corresponding candidate is about5.35% slower. Small batch31 prehashed ratios reach about0.964. Across the six seeds, large actual16 batch1 generic raw has a geometric ratio near0.986. These cannot be replaced by the visible-mode gains.

Against shortlisted Bloomsday in the same visible public-API contracts, small actual16-bpk Byte is1.029 ns prehashed and1.655 ns with fused hash, versus1.481/2.145 ns. At large actual16 bpk, fused raw is6.908 versus7.101 ns geometrically across seeds: Byte wins five seeds and loses one by about0.6%. This small margin is not a universal result. Large actual32-bpk Byte fused raw is9.510 versus10.435 ns and is faster in all six seeds. That comparison qualifies the0.1% FPR ceiling; Byte does not qualify0.01%. Bloomsday has substantially lower false-positive rates within the same ceiling, as shown in the quality tables.

Pursue an isolated **Byte-only** single-annotation variant, with immutable original and original triple-hint controls in the same new executable. Keep algorithms, public bulk routing, masks and allocation unchanged. Validate its full outputs and generated code, then use a separately reviewed compact port-cost/regression protocol before any production edit. The current three-hint package is not promoted wholesale, and this report does not decide production integration.

All384 per-seed pairs,128 order strata,48 unpooled family/size/seed quality records and1152 external allocation alternatives remain in the adjacent tables. Rankings are descriptive postprocessing with a fixed selected allocation across seeds, not a statistical superiority test. No global-fastest claim follows.
