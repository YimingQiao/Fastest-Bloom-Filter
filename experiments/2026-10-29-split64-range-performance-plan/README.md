# Split64Range performance plan

Source-only proposal. No new executable, correctness run or timing is claimed.
The native range implementation passed cross-language bitmap, output and
parallel-ownership checks in `../2026-10-29-split64-range-native/`, committed
at `f3a9f4c6c6a4ed5f14e1d8e3145cdd3bbedadb10`. Its earlier C++ serial
range adapter has independent three-seed evidence at about 24 bits/key. That
evidence selects useful comparison points here; none of its latency values
will be imported into a new ranking.

Implement the Rust exact-capacity serial comparison first, then extend the
existing C++ shared-bitmap query executor. Keep native parallel construction
as a separate follow-up. This tests the new Rust packaging and useful
multithreaded behavior without confusing shared-query throughput with build
speed.

## Rust serial stage: 120 proposed rows

There is no frozen exact-capacity Rust harness to reuse. The SBBF, visible,
leaf and Independent32 harnesses all retain the old strict-next-power-of-two
capacity rule. Reuse the seven-public-API four-mode timing body from
`../2026-10-29-rust-visible-single/benchmark/src/main.rs`; add an independent
constructor/geometry layer and the eighth public API, Split64Range. Do not
alter its query, hashing, dense-output validation, warm-up, four-phase Williams
schedule or per-trial output consumption.

Snapshot current production Rust, including the promoted single ByteSplit
`contains_hash` inline hint. Add the unchanged validated `split64_range.rs`
and `range_parallel.rs` plus module/export declarations. The older range
crate's ByteSplit copy does not contain that hint, so it is not the current
production control. Preserve all candidate dispatch, masks, prefetches and
public/private inline annotations. No target-specific benchmark shortcut.

| Family | Constructor under byte ceiling B | Capacity/probe checks |
| --- | --- | --- |
| Current FastPattern, ByteSplit, FourSector, Split64 | Invert the existing public `(real_n, legacy_bpk)` constructor to the largest supported power-of-two allocation at most B | Keep real n, including FastPattern density policy; at the proposed caps actual sizes are 16/16/32 bpk |
| New Split64Range | `with_byte_budget(B)` | Complete 64-byte lines; actual Vec capacity charged; eight probes |
| Fastbloom 0.17 | `with_num_bits(B*8).expected_items(real_n)` | Public `num_bits`, `num_hashes`, plus separate allocator validation; expected probe counts 11/17/22 at 16/24/32 bpk |
| Pinned Bloomsday | Existing sizing-FPR inverse with real n and fixed seed 0 | Set sizing-only FPR to `exp(-(bpk-0.5)*ln(2)^2)`; verify integer rounding, 32-byte blocks and observed allocation; eight fixed probes |
| SBBF safe | Existing validated public `Filter::new(8, logical_bytes)` | Logical 32-byte blocks and backing rounded to 64 bytes; eight probes; retain upstream safe public vtable |

The Bloomsday FPR argument is only a constructor inverse, not measured quality.
The first grid is intentionally limited to powers-of-two real n and integral
16/24/32-bpk budgets, where that inverse is exact. Do not advertise a generic
arbitrary-byte inverse. Do not infer Vec capacity from length alone: use
isolated allocator preflight to check actual retained requested heap bytes for
Fastbloom and Bloomsday, then freeze the geometry contract. No allocator
instrumentation belongs in performance timing.

Use n=2^16/2^25, exact caps 16/24/32, batches 1/31/4096, q=2^22,
50% hits, seed 42, eight balanced query repetitions, whole-input serial builds
and 2^24 independent calibration negatives. Four native power-of-two families
have the same geometry under caps 16 and 24: measure that geometry once and
record both represented caps. There are 20 distinct configurations per n,
40 per batch and 120 rows overall. All four query modes remain in every row;
visible whole-array loops are still whole-array at every batch tag.

This initial grid does not cover every Rust capacity below a cap. Report the
best eligible measured allocation, allowing 16 and 24 under cap 32. Preserve
all before/after and quality failures. Before any claim, freeze a later
multi-seed confirmation and fixed rivals; do not reuse seed42 as held-out data.

## C++ shared-query stage: about 142 proposed rows at T=8

Clone `../2026-10-29-external-parallel-query/` into a new stage. Retain its
executor, global batch partition, const public kernel, placement checks and
failure/cancellation handling. Snapshot current production native headers,
the unchanged native range candidate, and the existing exact-budget adapter
constructors/geometry from `../2026-10-29-exact-budget-range/`. Replace only
the factory's `BF(n,bpk)` with the reviewed exact-budget trait factory, append
geometry/ownership metadata, and add the range type. Upstream query/insert
bodies remain unchanged.

Preserve the old 23-family MT shortlist at caps 16/24/32 and add Split64Range.
Also replay all 17 external geometry points already fixed in the serial
exact-capacity confirmation. The latter adds ten distinct points outside the
new grid, including 12/14/20/28-bpk rivals and Boost ClassicK11; it prevents a
cap32 claim from silently omitting already-known smaller rivals. Selection is
source/geometry based, not new MT timing or FPR based. The expected union is
142 configurations across both n values, after 16/24 aliases are deduplicated.
The authoritative count must come from a new allocation-only planner before
the run protocol is frozen; unsupported/mismatched geometries fail preflight.

Boost at about 24 bpk is feasible without changing its algorithm. Its already
validated constructor inverse uses
`range=floor((B-overhead)/stride)` and counts
`range*stride+overhead`, including alignment and tail bytes. Multi32/64 are
usually one byte below the nominal budget on this grid. Keep the actual count
and `CountingAllocator`; never charge only `capacity()/8`. Native Range24
therefore faces the strong Multi64K8 ~24-bpk rival as well as 16- and 32-bpk
alternatives. The complete 23-family list and 17 frozen external point IDs are
recorded in `proposal.json`.

Start with T=8, batch4096, q=2^22, 50% hits, seed42, six query repetitions,
cal24 and whole-input serial build. Keep direct serial controls in every row;
use them for own scaling. T includes caller worker0 and only T-1 spawned
threads. Use one immutable built bitmap, not one copy per worker. Preserve
the exact common global batch boundaries and separate pure/staged-hash modes.
Native `LookupParallel` is deliberately not substituted: its proportional
key splits can create different tails and change the measured API work.

Retain four timing intervals: launch, gated work, join and fresh-thread
end-to-end; rank gated and end-to-end separately for pure and hash modes.
Original direct serial and T=1 executor results are separate contracts. This
minimal stage retains the old fixed within-trial order (serial pure, serial
hash, parallel pure, parallel hash); report that limitation explicitly. A
balanced phase-order change requires a separate reviewed delta, not an
unannounced timing change. T=1/4 runs and multi-seed T=8 confirmation are
subsequent fixed protocols, not implied by this screen.

All selected cores must be distinct physical cores on one socket/node. Keep
the MT runner's explicit NUMA allocation binding and pin caller before bitmap
allocation. Whole-matrix socket flock, inherited-lock validation, actual
topology, allocator/dependency/source/binary pins and exact commands are
mandatory. The Rust serial stage must separately record whether it has only
affinity or also memory binding; do not infer NUMA policy from taskset.

## Construction and native parallel API follow-up

The existing C++ and Rust `parallel_benchmark` programs are useful scaffolds,
but allocate the filter before the build timer and measure their native
parallel-query API. They cannot be relabeled as allocation-inclusive external
comparisons. A separate small same-language native experiment should compare
current Split64 and new Range at equal 16/32 allocations, plus useful Range24,
serial versus T=1/4/8. Measure both public insert-only and total allocate+build
boundaries, including every count/scatter/insert pass, temporary allocations,
thread creation and joins. Keep raw-hash work separate if added.

Report actual effective build/query workers, retained bitmap, `8*N+O(W^2)`
explicit temporary heap and checked padding/overflow. A full-line partition
is mandatory: no two workers write a 64-byte line; duplicates are idempotent.
Retain nondivisible line/worker and skew tests. Do not add a new partition
algorithm or private per-worker filters. C++/Rust have different runtimes and
executables: compare each against its same-language serial control; exact
bitmap parity is transferable evidence, measured latency is not.

## Preflight gates and reporting

Before compiling, freeze the source-only delta and confirm factory invariants
and current-production snapshots. Before timing, require normal, AVX2-only,
forced scalar and ASan checks; C++ shared reads also require representative
TSan and executor fault tests. Retain existing twelve cross-language exact
word/output fixtures and add 16/24/32-bpk capacity/accounting checks. Query
tails 0..131/4096/4097, shifted inputs/outputs, all hits/misses, duplicate
inserts, source immutability, max/overflow sizing and every inserted hash must
pass. New Rust constructors must reproduce the prior seven APIs exactly at
old 16/32 allocations; the promoted Byte hint changes codegen, not answers.

Guard the exact row registry/order, workload, public API ownership, byte
ceilings, probe metadata, complete phase/trial vectors, all dense outputs and
disjoint calibration interval. Unknown, missing or duplicate CLI names fail.
Source/binary snapshots are checked before and after every matrix. The runner
must reject Python -O and verify its actual inherited flock descriptor.

Quality is a per-family/geometry/real-n/input-seed calibration record. Known
identical API aliases and repeated batches/T do not add independent probes;
distinct families are not assumed independent merely because names differ.
Use pointwise Wilson95 upper endpoints without pooling distinct mappings.
Caps admit every smaller measured allocation. Report pure and raw separately,
and for MT split by T and gated/end-to-end contract. Retain the historical
FourSector16 held-out quality failure as context if seed42 qualifies; never
import its old timings. This plan authorizes no performance claims or global
fastest label.
