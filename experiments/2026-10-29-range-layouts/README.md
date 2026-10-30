# Arbitrary-capacity ByteSplit and Split64 prototypes

Correctness preflight complete; see [validation](VALIDATION.md). Production
C++/Rust files are unchanged; no throughput or calibrated accuracy result exists
for these isolated types yet. The original bitmap
mapping and constructors remain available in the production library.

`ByteSplitRange` and `Split64Range` fit an explicit byte ceiling to complete64-byte
lines. `RangeBytes{B}` preserves the128-byte minimum and256MiB maximum; `(n,bpk)`
uses `floor(n*bpk/8)` as its byte ceiling, with checked arithmetic. Actual vector
backing capacity is charged and must fit the ceiling. Hash high32 is reduced by
an unsigned multiply-high to the number of buckets/lines; all low32 mask code,
query dispatch, prefetch distances and sequential OR insertion stay unchanged.

This restores FastFilter Fixed16's address/probe mapping in ByteSplit. Split64's
mapping is equivalent to FastFilter Fixed64 up to a fixed sector permutation.
The experiment tests capacity granularity and existing native query kernels,
not a new Bloom filter family. ByteSplit's Apache notices remain in its header;
the inherited relative license reference refers to the original `include/`
location. The files are [LICENSE](../../third_party/FastFilter/LICENSE) and
[NOTICE](../../third_party/FastFilter/NOTICE).

The old power-of-two parallel-helper friendship is deliberately removed. These
experimental types currently support exclusive serial construction and concurrent
immutable reads. Arbitrary-line parallel construction and a native Rust port
require separate implementation and parity evidence before any promotion.

The preflight uses independent scalar bitmap oracles and all-byte comparison,
including non-power-of-two line counts, range-reduction boundaries, duplicates,
collisions, dense outputs, guards, tails and backend agreement. No benchmark
executable or timing loop is included at this stage.
