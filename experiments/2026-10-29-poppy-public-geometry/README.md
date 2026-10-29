# Poppy finite public constructor geometry

This implements the source-only constructor plan committed as
`d3f15378fc0e18522e16c2b62b013e73f6b3bc9d`. The pinned public dependency remains
`hashlookup/poppy@992a13e27e8b09b2a832333a4ba3d160545fa866`. No Bloom construction,
insertion, query, calibration or timing has run in this stage yet.

The geometry-only planner enumerated all 25,318 integer capacities in the 32
fixed largest-fitting intervals. Deduplication by bucket/cache/K within each
policy retains 62 representatives. All 24 ordinary requested-FPR controls are
also retained, giving 86 constructor rows, including controls that exceed every
tested cap. None and Space keep distinct public labels and a source-derived
mapping-alias group, to be checked with later semantic fixtures; repeated labels
or later query batches must not enlarge a quality sample.
This finite search does not cover every possible smaller allocation.

`candidate-ledger.csv` preserves every candidate, its exact public f64 argument,
derived geometry and deterministic first-capacity representative. The public
inspector reads `constructors.tsv` and reconstructs arguments from their exact
f64 bits. It only calls `Params::new(real_n,fpp).opt(policy).try_into_v2()`.
Rust independently verifies the argument-derived capacity; actual constructor
metadata, public getters and allocation counters must agree with the planner.
The real input capacity is never replaced with a tuning surrogate.

The global allocator delegates to `System` and counts requested allocation bytes
for every allocation/deallocation. A single-threaded construction phase records
new live bytes and peak bytes. Cache and bucket allocations are both charged.
The filter must release exactly its measured allocation when dropped. Inline
object size and constructor peak are separate; allocator bookkeeping is outside
requested allocation sizes and is explicitly labeled. This counting executable
will never be used as a performance binary.

The public streaming serializer feeds a stack-only sink. It retains the first
48 header bytes, skips exactly the cache byte body, and retains the subsequent
8-byte bucket count. Total retained metadata is 56 bytes even when the cache is
4 MiB. The remaining body is discarded. Serialization's temporary heap peak is
measured separately and its final live allocation must be zero. Parser tests
split writes at arbitrary boundaries and reject a truncated bucket count.

Five offline planner tests cover interval endpoints, independent control values, every
selected K and first representative, exact argument round trips, retained
over-budget controls and None/Space aliases. Two additional synthetic audit tests
reject missing or reordered constructors, hidden cache bytes, altered geometry,
incorrect serializer accounting and work outside the untimed empty-constructor
scope. Cargo lock resolution initially
failed offline because `wyhash` was not cached; the separate online resolution
is archived. Dependency resolution did not compile or execute a Bloom filter.

After source review and a committed source freeze, a separately leased run may
compile the inspector, run its two parser tests and validate the fixed 86 empty
constructors. This gives allocation/geometry evidence only. Public byte/iterator
semantics, insertion errors, independent accuracy calibration and any timed
comparison require later evidence and a separate frozen workload protocol.
`validate.py` uses a new build/output directory and the exact committed source
manifest, records structured Cargo artifacts and preserves actual dep-info text.
It does not guess relative Cargo dependency ownership or claim the configuration
inventory is an exact consumed-file closure. Both whole-process affinity and an
inherited socket write lock are required.

Reproduce the source-only ledger and checks without a compiler or Bloom filter:

```sh
python3 experiments/2026-10-29-poppy-public-geometry/plan.py
(cd experiments/2026-10-29-poppy-public-geometry && python3 -m unittest test_plan.py test_validation.py)
```
