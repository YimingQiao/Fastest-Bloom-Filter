# Native Split64 range correctness completed

The initial preparation README is retained in the preflight input inventory.
This report records the subsequent completed validation; no throughput has
been measured for this new native Rust/parallel packaging.

All six C++ combinations passed: native, AVX2 and scalar, each normally and
with AddressSanitizer plus UndefinedBehaviorSanitizer. Rust passed the new
five tests with runtime native dispatch, `disable-avx512`, and AddressSanitizer;
the tests also force scalar insertion/query paths. The complete library test
suite and Clippy with warnings denied passed. Thirty-two commands and their
stdout/stderr are retained in `validation-v1/`, with exact source and binary
hashes, actual compiler command lines and toolchain versions.

Every C++ and Rust configuration emits the same twelve fixtures: complete
u64 word arrays and 1,055 dense query outputs at six capacities, each with
31 and 2,048 inserted hashes. The common fixture SHA-256 is
`511faca6e2b3933b5cf607e3b753e803be7877d03f9b7bda2bb8c90d5531f075`.
These are exact bitmaps and answers, not checksum-only semantic comparisons.

The independent oracle covers arbitrary line counts, unsigned mask products,
full bitmaps, duplicates, cleared essential bits, source-state boundaries,
tails and shifted output guards. Parallel tests cover 0, 17, 16,384 and
32,768 inputs; 2/3/5/7/31/257/4,097 lines; and requested worker counts
0/1/2/3/5/8. Effective workers retain the production minimum-work threshold.
Full serial/parallel bitmaps and dense outputs match. Ownership tests exercise
the proved divisible shortcut and nondivisible fallback, including boundaries
near the maximum capacity. Maximum Rust allocation, invalid/overflowing sizes
and scratch overflow checks pass.

The whole operation held `/tmp/fastest-bf-socket0.lock` and used physical cores
2,4,6,8,10,12,14,16. This is a correctness run, not a scaling result or NUMA
placement claim. The initial run's tests passed but Clippy rejected ambiguous
operator formatting and a manual divisibility expression. Its logs and exact
affected sources remain in `validation-initial-lint/`. Parentheses and the
standard integer divisibility method fixed those warnings; final validation
then passed. No warning suppression was introduced for the new Rust code.

Independent source review checked the ownership proof, Rust exclusive slices
and global-index rebasing, allocation charging, and preserved kernels. C++
serial kernel bodies are unchanged from the prior range prototype; Rust's
mask, dispatch and prefetch bodies preserve the production Split64 operations
apart from range addressing. The original six Rust modules remain byte-for-byte
unchanged, and its library root adds only the new modules/export. The complete
delta is retained in `candidate.patch`.

Remaining work is performance: fresh-seed external confirmation of the earlier
C++ range candidate, same-contract Rust comparisons, and full allocation-inclusive
parallel construction/query timings. Correctness results alone do not establish
that this packaging is faster or justify replacing the production layouts.
