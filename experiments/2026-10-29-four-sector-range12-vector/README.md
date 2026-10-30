# Vector port of the calibrated range K12 mapping

The [fixed scalar pilot](../2026-10-29-four-sector-range-probe-pilot/RESULTS.md)
qualified K12 at 24 bpk for both tested sizes, with pointwise upper FPR
0.009380276% and 0.009667457%. K9 failed both and K10 failed the larger size.
This source-only port keeps that exact K12 mapping. It makes no speed claim,
changes no production default, and does not improve the failed 16-bpk quality.

`derive.py` reconstructs the header from the frozen K8 range parent. All
addressing, word selection, scalar/batch dispatch, prefetch distances, SIMD
loads/gathers/stores and sequential insertion ORs remain unchanged. Every
sector uses the historical three-bit dictionary. AVX-512 keeps one 16-entry
register table; matching source structure is not yet an assembly result.

AVX2 cannot reuse K8's arithmetic two-bit shortcut. It loads two eight-entry
register tables, permutes both by the low three code bits, then selects the
half using code bit 3. The selection bit is sign-extended across the whole
32-bit lane before byte-granularity blending. Remaining mask rotation and
word gathers are inherited unchanged. This extra work may regress AVX2.

The checker derives from the completed scalar pilot's independent bit-position
oracle. It adds calibrated scalar-K12 full-bitmap parity and null/zero lookup,
while retaining incremental insertion, all inserted keys, every cyclic mask
code, repeated/hotspot keys, exact complete outputs for 548 offset/tail cases,
invalid budgets and unchanged-input checks. Seven requested budgets exercise
128-byte minimum/floor rounding, arbitrary line counts, the prefetch-size
boundary and a 96-MiB non-power-of-two bitmap. Six builds cover native AVX-512,
AVX2-only and scalar, each optimized and ASan/UBSan: 42 fixtures in total.
No correctness result has run at this source-preparation stage.

The validation entry requires a committed preparation inventory and the actual
inherited socket lock, with the entire runner pinned to the corresponding CPU:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 env BF_SOCKET_LEASE=socket0-cpu2 \
  python3 experiments/2026-10-29-four-sector-range12-vector/validate.py \
  --source-commit FULL --cpu 2
```

Binaries remain local, while compiler commands, actual dependency hashes,
all outcomes and the final source checks are retained. Existing paths are not
reused after failures. This driver runs correctness only. A separate public-API
performance protocol, with equal actual-byte/FPR gates and strong external
configurations, must be frozen before any throughput run. Fresh-seed evidence
is required before promoting the selected mapping; the scalar pilot's confidence
bounds and finite 24-bit addressing limitations still apply.
