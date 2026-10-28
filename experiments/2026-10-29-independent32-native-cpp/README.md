# Native C++ Independent32 packaging experiment

This isolates the previously measured IndependentVbmi32 probe mapping in a native
type with exclusive parallel construction and immutable parallel queries. It is
correctness preflight only, with no speed result yet. Native, AVX2 and scalar-source
builds and their ASan/UBSan variants all pass, including complete bitmap parity
and parallel checks. Production headers remain unchanged. The Rust counterpart
is being prepared independently.

Each 32-byte bucket has eight u32 sectors. Hash bits0..39 supply eight disjoint
five-bit positions; bits41..63 select the bucket with the existing power-of-two
mask. Bit40 is unused. The VBMI, AVX2 and scalar probe formulas, size rule and
serial loops are unchanged from the frozen public-call experiment. This preserves
its bitmap mapping; it does not establish the performance of this packaging.

The new backing allocator aligns the first bucket to64 bytes, so two consecutive
buckets form a complete physical cache line. The copied production parallel
builder partitions by `bucket / 2`; every worker owns whole lines. Its histogram,
scatter, scratch reporting and thread management are unchanged. Parallel builds
are exclusive operations. Concurrent readers require construction to have finished;
this type does not provide overlapping atomic updates.

`ContainsHash` exposes a compiler-visible singleton call. `Insert`, `Lookup`,
`SizeInBytes` and the parallel wrapper follow the existing C++ conventions.
`Data` and line-index accessors support independent validation in this experiment.
No new batching, prefetch or policy tuning has been added.

The correctness program compares full bitmaps against both an independent scalar
oracle and the frozen C++ parent. It covers hash-bit boundaries, repeated inserts,
essential probe bits, tails and input offsets, long batches, allocation overflow,
and complete serial/parallel bitmap equality at1/2/3/5/8 requested workers, automatic
worker selection and empty batches.
`--parity` emits nine full bitmap/output fixtures for exact comparison with Rust.

Build the `check` target with `INDEPENDENT_ISA=native`, `avx2` or `scalar` and
optionally `INDEPENDENT_SANITIZERS=ON`. Heavy work must hold the shared socket
lease throughout; `run_preflight.py` records commands and refuses an existing
validation directory. This preflight has no performance matrix.

The local sources derive from this repository's MIT-licensed native code.
`source-provenance.json` records the exact parent header hashes and changes.
`validation/summary.json` records identical check and full-fixture digests across
all six builds. The initial build stopped at an existing-header Clang warning;
its logs and the scoped warning-suppression correction remain in
`validation-initial-warning/`. No executable ran in that failed attempt.
