# Exact backing-byte capacity grid V2 with two project range experiments

This isolated harness removes the old adapter-imposed power-of-two restriction
from external implementations whose public constructors support arbitrary sizes.
The four native layouts and FastFilter SimdBlock retain their inherent power-of-two
addressing. No upstream query/insert kernel or production source is changed.

**Preflight only. No performance screen has run.** This is a new measurement
contract, so results must not be treated as a bitmap-only speedup over old tracks.

The registry contains74 configurations: four production natives, the original52 external,
12 additional FastFilter Classical controls (K10/14/17/19, each direct/Branchless/
Bulk), four additional Rocks core controls (K11/K12, each direct/Batch32), and
two explicitly labeled project experiments: `ByteSplitRangeExperiment` and
`Split64RangeExperiment`.
These are public template/core API specializations, not new upstream algorithms
or a RocksDB SST factory measurement.

## Capacity and allocation

`budget.hpp` checks `B=floor(real_n*budget_bpk/8)` before constructing anything.
`geometry.hpp` records the exact constructor argument, backing/logical bytes,
range/bucket/page geometry, and probe policy. The post-construction allocation
must match that pure plan and fit B. Explicit Boost alignment/tail bytes count
against B. PageBloom stays a raw-byte API with no extra common hash. All fast
paths are copied byte-for-byte from their parent adapters; only size helpers
and constructor checks change. See `unchanged-hot-paths.json`.

Native factories pass the real n and a fitting legacy constructor bpk. In this
grid, native actual8/16/32 use legacy4/8/16. Thus FastPattern's sparse6 versus
dense8 mask choice still uses real item density. ByteSplit/Fixed16 masks have
variable popcounts; metadata uses `effective_probes=-1` and an explicit variable
policy, not a fictitious fixed K. Native `unit_bytes=64` describes owned lines;
the filter name identifies the intra-line sector/bucket layout.

`make_plan.py` deduplicates the same alias and actual geometry before timing.
Direct/Bulk/Branchless/SingleV1 aliases remain separate query API controls.
For each n, the seven budgets produce494 unique rows, rather than518 duplicate
nominal rows. Actual native8 is included once. `represented_budget_bpk` maps the
repeated native/Simd allocations back to every nominal ceiling. Identical bitmap
API controls share a calibration identity so their samples cannot be pooled as
independent trials. The complete two-size grid has14 cases and988 rows.

`plan REAL_N BUDGET_BPK` performs no filter allocation or query timing. Unsupported
minimum sizes are explicit rows with reasons; zero/overflow ceilings fail.
The exact formulas and source audit are in the neighboring
[design document](../2026-10-29-exact-budget-design.md).

## Query-only contract

The copied harness retains the existing positional arguments and appends mode
and optional construction repeats:

```
benchmark key_power budget_bpk hit_percent query_power batch query_repeats seed filters insert_batch calibration_power [full|query-only] [build_repeats]
```

Full construction mode remains the default, with `build_repeats=query_repeats`
when omitted. It preserves the previous timed prehashed and hash+insert build
phases. Explicit query-only requires `build_repeats=0` and an even positive query
repeat count. It builds one complete filter, validates every inserted key, then
runs warmup, queries and independent negative calibration. All four disabled
construction summaries are NaN. The setup cost is neither timed nor ranked.
The declared filter build scratch still counts because the single setup uses it;
query-only harness hash scratch is exactly `8*batch` bytes. Full mode retains
`8*max(batch,insert_batch)` scratch for timed hash+insert.

Both query phases call the same noinline batch kernel. Their order alternates
by `(seed+trial)&1`; six repeats balance each phase's position and precedence.
Every timed phase is followed, outside the timer, by dense0/1 checks, complete
reference-vector equality, checksum verification and output guard checks.
The CSV includes both numeric JSON trial arrays and the exact phase schedule.
Page's P slot performs equivalent raw-byte queries but is never ranked: pure
summaries are NaN and pure JSON trial entries are null. Its H slot is the public
raw-byte measurement. Full mode permits odd repeats for compatibility; those
incomplete two-trial blocks are only partially balanced.

The copied generic benchmark now retains a complete reference output vector to
validate every phase. That uniform working-set change and the new balanced
phase order are reasons to compare candidates within this new binary, not to
attribute differences against older binaries to a filter algorithm.

## Reproduction and preflight

Use a recent Clang and the existing pinned dependencies. The build fetches the
same FastFilter/PageBloom revision or can use the already verified checkout:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 cmake -S experiments/2026-10-29-exact-budget-range -B build/exact-budget-range-native -DCMAKE_CXX_COMPILER=clang++
flock /tmp/fastest-bf-socket0.lock taskset -c 2 cmake --build build/exact-budget-range-native -j1
flock /tmp/fastest-bf-socket0.lock taskset -c 2 ctest --test-dir build/exact-budget-range-native --output-on-failure
```

`BF_NATIVE=OFF` tests the genuine AVX2 fallback; this is not a scalar-only claim,
because the pinned Fixed32/64 family requires AVX2. `BF_SANITIZERS=ON` enables
ASan+UBSan. Tests cover all74 registrations at odd/non-power-of-two capacities,
all inserted keys, duplicate inserts, tails0..131 and4096/4097/4127, input offsets,
full output/guards, added direct/bulk/branchless controls, native density and
Rocks auto K. CLI tests compare complete query-only/full/partial builds and
calibration, reject partial/duplicate/empty selections before output, enforce
NaN/phase/trial metadata, and verify988-row plan deduplication. Contract-only
fixtures prove one complete query-only construction and reject second-trial
pure/hash answer corruption and output guard writes. They are absent from the
performance registry.

The original72 preflight at commit `2c3bac9b274751e5e62ad033bbbec1135f8383ec`
and its binaries remain immutable; provenance copies are in `parent72-record/`.
The range headers and independent full-bitmap oracle are copied unchanged from
commit `0a25fe8` into `range-layouts/`. Their full source hashes are recorded in
`v2-provenance.json`.

The range experiments fit complete64-byte lines and use multiply-high addressing.
Their masks, public query dispatch and prefetch policies are unchanged from the
range preflight. ByteSplitRange restores FastFilter Fixed16's address/probe
mapping; Split64Range matches Fixed64 up to a fixed sector permutation. They
are capacity/API controls, not claims of a new filter family. They currently
support serial construction and immutable concurrent reads, not the production
parallel build wrapper. No Rust port or promotion is implied.

`implementation_origin` and `registry.json` separate four production natives,
68 external controls and two project experiments. Range API timings stay separate,
but their calibration identities match the equivalent Fixed16/Fixed64 bitmap
when actual allocations match. The row validator requires identical output/FP
samples for these identities instead of treating them as independent evidence.

`validation/` records correctness only; incidental tiny-fixture times do not
support performance claims. `protocol.json` prespecifies the future seed42
training grid and Wilson quality rule. After root review and a source commit,
the future command is:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-exact-budget-range/run_screen.py --source-commit FULL_COMMITTED_SHA --lease socket0 --cpu 2 --output-dir NEW_OUTPUT_DIRECTORY
```

The driver requires an inherited whole-matrix flock descriptor and CPU2-only
affinity. It verifies that the exact full git commit contains every frozen local
source blob and the exact freeze/inventory/protocol/plan artifacts, then verifies
all fetched dependency and binary hashes before every case and after the matrix.
It requires the exact planned row set/geometry/trials and refuses to
overwrite previous evidence. Ranking must use charged bytes, admit all measured
allocations under each cap, and retain losses. Training is not held-out proof.

## Attribution

The native snapshot preserves its source notices. In particular ByteSplit's
Apache2 FastFilter-derived mask retains `snapshot/third_party/FastFilter/`.
FastFilter (Apache2), PageBloom (BSD3), Boost (BSL1) and RocksDB dual-license source
pins/licenses are unchanged; copies and manifests are under `licenses/` and
`upstreams/`. This repository's MIT license does not replace those notices.
