# A finite public-constructor control for MAGIC capacities

Source-only proposal, prepared while the fixed Page240 caller experiment was
running. No planner, compiler, filter, quality or timing run has been performed
for this proposal. The original MAGIC results and pinned upstream sources remain
unchanged. This is a follow-up to the [source mechanism audit](2026-10-29-vldb-magic-source-audit.md),
not a measured causal decomposition or a claim that an odd divisor is optimal.

The proposed change is solely the requested capacity of the same original
public constructor. It does not replace the original hash family, address
operator, probes, public PImpl facade, tuner, or compact-output conversion.
Original archives and their Boost1.83 context can be reused if the eventual
build proves the same source and archive identities. No private kernel is a
substitute for the public artifact.

## One fixed selection rule

For a bitmap ceiling `B` and block width `W` bytes, use integer arithmetic:

1. Let `C = floor(B / 64) * 64`, `M = C / W`, and
   `L = max(3, ceil(99 * M / 100))`. The checked domain is the existing
   128-byte through 256-MiB capacity range and block widths 8, 32, or 64.
2. Examine odd integers `d` from the largest odd integer at most `M` down to
   `L`, in descending order. Accept the first for which the pinned upstream
   `dtl::next_cheap_magic(d).divisor == d` and `round_up_64(d * W) <= C`.
3. Request exactly `8 * d * W` bits from the public constructor. Verify its
   actual block count, MAGIC address mode, logical bytes, rounded backing bytes,
   probe configuration and requested/observed U before insertion.
4. If the finite interval has no accepted divisor, retain an explicit
   unsupported geometry. Do not widen the interval, accept an even divisor,
   select another rule, or replace a failed quality point after observing data.

This selects one candidate per eligible cap/family using source geometry only.
The lower bound limits discarded logical capacity to one percent of the maximum
fitting block count. The smallest block widths may need explicit 64-byte tail
padding; both this padding and any otherwise unused capacity are reported.
Tests must use checked products and ceiling arithmetic even though the fixed
domain fits a 64-bit size_t. The planner calls the upstream divisor routine;
it does not implement another modulus algorithm.

Only the non-power-of-two 12/24-bits-per-key caps receive this new candidate in
the first pilot. The original greatest-fitting MAGIC points at those caps and
the original POW2 points at 16/32 remain controls. This avoids changing a
known POW2 address policy merely to force the hypothesis onto every cap.
All candidates remain under the same actual-byte ceiling; a smaller logical
bitmap is not silently labelled as having the full cap's usable bits.

## Bounded correctness, then accuracy only

The proposed first accuracy grid is fixed to the existing three original
families (sector32, sector64, register64), n=2^16/2^25, and seed42. It contains
24 original geometries (three families, two n, four caps) and 12 nearby odd
geometries (three families, two n, two caps), at most 36 rows. Unsupported
points remain in the ledger rather than being replaced. The shared raw-u32
construction and query streams stay unchanged; the old seed42 counts and
checksums are exact reproduction controls, not independent confirmation.

Use the original public PImpl API in one fresh process per configured row:
sector families U=1, register family U=0, with the existing mandatory metadata
check and untouched tuner-file fingerprints. Build once, validate every
inserted key, retain the full mixed-query checksum at q=2^22/hit50, and run
exactly 2^24 separate negative calibration keys. Record no throughput samples
and perform no quality-based adaptive extension. Report every count and the
pointwise two-sided Wilson95 upper endpoint at 1%, 0.1%, and 0.01%; API aliases
must never add calibration denominators. Any later independent-seed or
performance protocol must be fixed and reviewed separately before execution.

Before this pilot, a small additive correctness target must prove exact
geometry and full bitmap/output parity across the existing public PImpl,
DirectDynamic and StaticLogic surfaces at each new accepted divisor, preserving
their separate API labels. Include old/new keys, duplicates, zero-length
null-pointer calls, unaligned input, compact scratch capacity n with guards
after n (not after returned hits), and all established scalar/unroll/SIMD tail
boundaries. The existing native, AVX2-only and sanitizer scope is sufficient;
the upstream pure-scalar public artifact remains unsupported, as already
recorded. Do not rebuild the heavy original library unless a concrete
compatibility issue requires it.

Required pre-data artifacts are the exact accepted-or-unsupported geometry
table, constructor/metadata agreement, source/archive/compiler inventory,
guarded correctness logs, immutable accuracy planner and an explicit CPU lease.
There is no compile or measurement authorization in this proposal. A quality
improvement would support investigating the geometry mechanism; it would not
isolate the contributions of address/probe correlations versus the changed
block count or establish a timing advantage.
