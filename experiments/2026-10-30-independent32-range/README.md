# Independent32 with range capacity

Source proposal and one isolated candidate; no compiler, filter execution,
accuracy measurement or timing has run. Production files remain untouched.

The complete CPP616 comparison shows a concrete capacity gap: at 32M keys and
the 1% FPR ceiling, the retained external singleton leader is
`Boost192Multi32K8` at 50,331,647 bytes (approximately12bpk), while the production
leader is ByteSplit at 67,108,864 bytes (16bpk). Byte/native latency is1.146×
external in generic pure and1.163× in visible fused common-hash queries.
Both are latency ratios (native/external), not throughput ratios. The four
seed/round cells and their fixed selections are retained in
`../2026-10-29-k12-singleton-external-analysis/report-v2/primary-summary.csv`
(`production_native/external`, n33554432, cap16, FPR0.01, the two named modes).
Those are descriptive geometric means from the completed four seed/round cells,
not an estimate of a causal memory benefit. Small16-bpk Byte already wins;
Split64Range24 already wins the strict24-bpk comparisons. Another K12-only
singleton change would miss the large loose-band gap.

Simply shrinking Byte is insufficient: the archived ByteSplitRange12 seed42
calibration had244,075/16,777,216 false positives at65K and246,699/16,777,216 at32M,
both above1%. Independent32 already has a proved C++ implementation. Its eight
32-bit sectors retain eight disjoint five-bit probe fields, with a short VBMI
mask path and AVX2/scalar alternatives. Its former power-of-two capacity rule
only exposes16/32bpk in the current size grid. This experiment changes its
capacity and address reduction, keeping those probes and serial loops.

## Exact candidate

For requested byte budget B, allocate L=floor(B/64) complete64-byte lines,
containing C=2L 32-byte buckets. Preserve the existing128B minimum and256MiB
maximum budget. The actual vector backing is reported and must not exceed B.
Use `bucket = floor((hash >> 40) * C / 2^24)`; probe lane j uses bits5j..5j+4.
The probe bits0..39 and address bits40..63 are disjoint. C<=2^23 and the product
is less than2^47. Every bucket/32B access stays within the allocation.

At all pilot sizes, this mapping differs from the original high23 masked
address even at equal power-of-two byte sizes. At the maximum256MiB, C=2^23
and both address formulas coincide at hash>>41; that endpoint is outside the
pilot. There is no candidate/control bitmap-equality claim for the pilot.
Both mappings must agree with their own independent scalar oracle. Non-power-of-
two reduction assigns either floor(2^24/C) or ceil(2^24/C) source values to each
bucket, so uniform independent input bits do not imply perfectly uniform bucket
loads. The finite-domain effect and all empirical FPR failures must be measured.

`control.hpp` is the exact committed native C++ parent. `CHANGE.patch` records
only candidate/bucket naming, range sizing and addressing. `Mask`, `InsertOne`,
`LookupOne`, `ContainsHash`, the scalar probe expressions and serial loops retain
their original bodies. No prefetch, unrolling, singleton shortcut, hint or ISA
change accompanies the new geometry. The product adds an integer multiply to
the old address path; smaller working sets might outweigh it, or might not.

Two buckets still share one physical line. `CacheLineIndex=Block/2` is exact,
but this stage supplies **no parallel wrapper**. The old power-of-two shift
scheduler must not be instantiated on this candidate. A future port would need
the proved Range physical-line ownership rule and separate validation.

## Bounded next steps

The requested first correctness proof is four small builds: native, AVX2,
scalar-source, and native ASan+UBSan. `check.cpp` compares full bitmap bytes to
an unsigned128 multiply/division and per-bit oracle, exercises every range
boundary in four small geometries,1024 missing-required-bit cases,324 guarded
tail/offset calls, complete inserted checks, duplicates and input immutability.
Both old-control geometries use their own old mapping oracle. Null0,255B→192B
round-down, zero/overflow/rejected sizing are covered. Maximum size and n25
pilot geometry are arithmetic checks, **not actual large allocations**. The
subsequent accuracy worker must construct and verify each real allocation.
Each checker prints its compiled backend; expected values are
`avx512vbmi-vl`, `avx2`, `scalar-source`, `avx512vbmi-vl` respectively on this host.
Retain actual compiler inputs/flags and public singleton/bulk assembly, without
creating another broad kernel matrix. Checker disassembly only describes the
checker; before any timing, capture and review the newly built actual public
caller and its clock boundaries. No checker address is reused as a timing proof.

`protocol.json` fixes an accuracy-only pilot: n16/n25; candidate actual
12/16/20/24/28/32bpk; exact old control actual16/32bpk; seen seed42; cal26;
16 complete constructions. No clock or timing field is needed. Build all real n,
validate every inserted hash and full mixed outputs, then calibrate a disjoint
negative range. Each row has its own Wilson endpoint; no old calibration or
cross-API sample pooling. Candidate12 must pass1% at **both** sizes before the
proposed speed screen proceeds. Candidate20/28 are prespecified secondary
quality targets at0.1%/0.01%; they cannot replace a failed primary12 point.
All six capacities, adjacent controls and failures remain archived. No capacity,
hash partition, probe count or seed is retuned after observation.

If primary12 passes, request one separately frozen216-row query-only screen:
2sizes × batches1/31/4096 ×2construction seeds ×2 reversed launch/API rounds.
Small-size panel: candidate12/candidate16, oldIndependent32 at16, all four
production natives at16, Fixed16 at16, Fixed16SingleV1 at16 and14 (10points).
Large-size panel: the same seven native points plus Boost Multi32K8 at its exact
50,331,647-byte geometry (8points). These external points are the complete union
of the relevant loose-cap16 leaders in CPP616 singleton and the prior completed
K12 bulk31/4096 screen; historical latency is not imported. Explicit table
identities are in the protocol. Fresh measurements must reconfirm eligibility.

Reuse the already-proved C++ public generic/visible caller contracts and exact
external factories. Query-only construction is untimed and complete. Batch1 has
generic pure/staged hash and visible pure/fused hash; larger batches have only
the two generic contracts. Keep all losses, including small-table regressions,
candidate16/old16 mapping controls and candidate12 versus the best actual-byte-
eligible production/external configuration. Use one same-input seed/round ratio
per contract; no cross-executable latency or pooled confidence claim. The two
seeds are the seen CPP616 constructions982451653/961748941, not fresh held-out
construction evidence. Eight
repetitions and opposite whole-ledger/API orders are fixed before timing.

The narrow hypothesis is rejected for this stage if candidate12 fails quality
at either size. If qualified, a claimed large-table gap closure requires lower
latency than the retained strongest eligible external and production rival in
all four seed/round observations for both visible singleton contracts and both
batch4096 contracts. Bulk31 and small-table outcomes remain unconditional guard
results; a failure means no blanket replacement claim. This is a finite test,
not a global-fastest claim or automatic promotion rule.

Root review and explicit compile/accuracy/timing leases are still required.
No timed screen runner is supplied or launched by this source preparation.

The four-profile proof uses fresh `validation-v1/` and
`build/independent32-range-v1-{native,avx2,scalar,native-asan}` paths. After the
source commit and granted lease, the one allowed operation is:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 numactl --physcpubind=3 --membind=1 python3 -u experiments/2026-10-30-independent32-range/preflight.py --source-commit FULL_COMMITTED_SHA
```

The driver captures configure/build/check outputs, actual dependency lists,
compile flags, binary hashes and backend labels. Any failure stops the operation
and retains its partial metadata; no retry or alternate profile is implicit.
