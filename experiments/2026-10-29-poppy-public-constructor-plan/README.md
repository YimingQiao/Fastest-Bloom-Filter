# Poppy public constructor and byte-API plan

This is a source-only addition to the external-baseline queue. Poppy0.2.1 adds a
4096-byte bucket family and optional separate index cache. The pinned source is
`hashlookup/poppy@992a13e27e8b09b2a832333a4ba3d160545fa866`; the accompanying
source inventory records seven inspected immutable Git blobs. No
planner, compiler, filter insertion, calibration or timing has run in this stage.

Use only public `Params::new(real_n, fpp).opt(policy).try_into_v2()` and public
byte insertion/query methods. Encode the common uniformly distributed u64 hash
as eight little-endian bytes. Upstream preserves this as h1; its mandatory
xorshift bucket addressing and lazy WyHash h2 remain in the call. Generic Rust
u64 input hashes again, so it is a different API and cannot silently substitute
for the byte contract. Check every insertion Result and every inserted key.

## Finite constructor coverage before data

Fix n=2^16/2^25, byte ceilings equivalent to12/16/24/32 bits per real key, and
all four public policies None/Space/Speed/Best. Include the three ordinary
requested-FPR controls0.01/0.001/0.0001 for every policy and size, retaining
unsupported or over-budget outcomes explicitly. In addition, enumerate every
distinct probe count that the public constructor can produce at each policy's
largest fitting allocation. This avoids repeating the earlier mistake of
comparing only an accuracy-optimal default when a cheaper public choice exists.

The following rule is geometry-only, fixed before filter input generation:

1. Charge cache bytes `ceil(next_power_of_two(n)/8)` for Speed/Best, zero for
   None/Space. Subtract them from the ceiling before counting4096-byte buckets.
   If no bucket fits, preserve an unsupported point.
2. Let A be the largest fitting bucket count, reduced to the greatest power of
   two at most A for Speed. Let c0=`ceil(n/A)`. The source-derived ordinary count
   is `ceil(n/c)` for integer per-bucket capacity c; Speed rounds that count up
   to a power of two. Compute the actual count at c0 and enumerate the finite
   contiguous integer-c interval that leaves that actual count unchanged.
   For ordinary count G>1 its upper endpoint is `floor((n-1)/(G-1))`; for
   Speed G>1 it is `ceil(2*n/G)-1`. Handle one-bucket/empty intervals explicitly
   rather than dividing by zero; those cases are outside the fixed formal grid.
3. For each c choose the public fpp argument
   `exp(-32768*ln(2)^2/(c+0.5))`. Reproduce the pinned constructor's floating-point
   capacity/K derivation in the planner, including the cache-policy formula and
   rounded bits-per-entry. Require its resulting integer capacity to equal c;
   a mismatch is a planning failure, not permission to search data-dependent
   alternatives. Persist fpp as exact f64 bits plus round-trip decimal text.
4. Deduplicate identical actual bucket/cache/K geometries within each named
   policy, keeping the smallest c as the deterministic representative. Retain
   every distinct K, including inaccurate or slow outcomes. Keep public-policy
   labels separate; None/Space aliases must not inflate an accuracy denominator.
   Freeze the complete ledger and its size before any Bloom workload executes.

This does not enumerate every possible smaller allocation in the library.
Nested-cap rankings must admit all already selected smaller configurations,
including the ordinary requested-FPR controls. The coverage claim remains this
finite public configuration set, not an exhaustive or universal external optimum.

## Public geometry, allocation and semantic checks

The planner predicts geometry; actual public constructors must independently
confirm it. Track constructor-owned live allocation bytes outside timers and
compare them with `size_in_bytes()`. Include the entire bucket vector and cache;
fresh attached user data must remain empty. Inline object fields, allocator
metadata and temporary inspection scratch are reported separately. Do not
silently subtract the optional cache from the baseline's memory charge.

At this immutable version, inspect the public streaming serializer with a bounded
state machine: retain the initial48-byte header containing K and cache bit length,
discard exactly the indicated cache byte body, then capture the following8-byte
bucket count. It is not one contiguous metadata prefix: that would unnecessarily
retain the full cache, up to4MiB in this grid. Retain only56 metadata bytes and
discard the remaining body, without allocating another bitmap. Inspect only:
never mutate an opaque serialized header to set K. Verify the streaming parser
against public getters and ordinary public round trips in correctness fixtures;
record any serializer buffer allocation as transient inspection scratch. This
inspection stays outside timing and does not replace a public hot method.

Correctness should cover full input presence, incremental and duplicate inserts,
all insertion errors, byte-slice versus independently constructed public index
iterator behavior, complete dense query output, zero/short/tail batches and
unchanged inputs. Compare serialized logical bitmap contents where useful,
while keeping policy metadata distinct. Prove real n remains unchanged in the
constructor and that shared geometry observations are never pooled as new data.

Only after a finite reviewed constructor ledger and actual allocation/semantic
proof should a separate quality/timing protocol be frozen. Reuse the established
common-hash workload and balanced public-call contracts with the existing
Rust native/external controls. Do not graft a private Poppy probe kernel into
that harness or omit internal h2 work. This stage authorizes source preparation,
not a new throughput claim or an open-ended parameter sweep.
