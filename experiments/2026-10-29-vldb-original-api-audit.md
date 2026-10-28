# Original VLDB artifact: input and output contracts

Source audit only; no new adapter, compilation or timing.

The reproduction repository at
[`0d2fe8e72496909cdac73c914e8f1a3dd956ac7f`](https://github.com/peterboncz/bloomfilter-repro/tree/0d2fe8e72496909cdac73c914e8f1a3dd956ac7f)
pins its `module/dtl` submodule to
[`c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf`](https://github.com/peterboncz/bloomfilter-bsd/tree/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf).
The original implementation remains a relevant external baseline; local historical
reimplementations do not establish a result against its full configuration space.

The pinned public
[`blocked_bloomfilter.hpp`](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/blocked_bloomfilter.hpp)
fixes its key and hash value types to 32 bits. Its template word type can be
32 or 64 bits, which does **not** make the public key type 64-bit. The public
object dispatches insertion, membership and batch operations through
`std::function`; its named underlying logic templates offer a separate static
API. Batch membership emits matching positions and a count, whereas our current
harness requires one dense `u32` answer per input.

The source supports register/cache blocks, sector counts, probe counts, vector
unrolling, and separate power-of-two or magic-number addressing. The constructor
reports actual length after selecting the geometry. The filter bitmap is supplied
by its caller. A future adapter must count that actual allocation and any explicit
alignment storage; requested bit length alone is insufficient.

## Fair integration proposal

Use a separate **32-bit key workload** for the original API. Generate distinct
inserted keys and disjoint negative keys with a fixed bijective 32-bit permutation
over checked, non-overlapping counter ranges. Every native and external candidate
receives the same keys. Existing 64-bit APIs can widen them losslessly and retain
their declared hash contract. Do not silently truncate our current 64-bit stream
and interpret aliasing collisions as ordinary bitmap false positives.

Keep original public raw-key hashing inside the original filter's timer. Any
common-hash preprocessing used by a native prehashed API belongs in its end-to-end
timer. A pure prehash comparison is available only where the APIs share an actual
prehashed contract; it must not omit the original implementation's internal work.

Measure the public dynamic and static logic paths as separately named controls.
Retain upstream vectorized `batch_contains`, rather than replacing it with a loop
of scalar `contains`. For the dense-output track, explicitly include positions-to-
dense conversion and report its scratch. A separate compact-position track could
instead require every candidate to produce the same compact output, including
conversion for native layouts. Neither output contract substitutes for the other.

Freeze block/sector/probe/unroll/size choices before timing, including arbitrary
capacities where supported. Check bitmap allocation, no false negatives, duplicate
and collision insertion, all tail lengths, exact dense/compact answer parity and
calibration before ranking. Small and large filters, single calls and batch calls
need distinct results. This audit neither predicts performance nor disqualifies
the original artifact from future comparison.

The local `bloomfilter-repro` checkout was read without modification. A separate
local `bloomfilter-bsd` checkout has unrelated working-tree edits; only committed
blobs were inspected there. The reproduction's exact submodule header was fetched
independently from the immutable GitHub URL above. No local edits were incorporated.
