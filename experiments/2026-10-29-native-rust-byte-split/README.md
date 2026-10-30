# Native Rust ByteSplit integration validation, 2026-10-29

`ByteSplitBloomFilter` exposes the exact frozen ByteSplit128Single mask and
address mapping through native Rust scalar/runtime AVX2 APIs, exclusive parallel
construction, and parallel immutable queries. Four 16-byte buckets share one
64-byte-aligned owned line. Workers own whole physical lines, including all four
buckets; they never independently write adjacent buckets in the same line.
The strict-next-power-of-two payload rule, shuffle zero lanes, and explicit
single-query dispatch are preserved.

The signed 16-bit multiplication and byte-shuffle mask is adapted from pinned
FastFilter Fixed16. Source attribution, Apache-2.0 license and NOTICE are retained.
The Rust package declares `MIT AND Apache-2.0`, includes package-local MIT/Apache
licenses and NOTICE, and `cargo package --list` verifies they are packaged along
with benchmark support modules. This derived source does not relabel the rest of
the project's MIT implementation as an unchanged upstream filter.

## Validation

Five targeted tests pass in each of normal, `disable-avx512`, and nightly
AddressSanitizer configurations. They cover 65,542 mask comparisons with an
independent signed-product floor-division oracle, complete byte-level bitmap
parity, zero-mask lanes, duplicate/same-line collisions, 12,672 tail/offset query
cases, guards and mismatch rejection before writing. Parallel tests compare
serial/full bitmap/output results with 1/2/3/7 workers for both normal and deliberately
same-line inputs. Actual logs are retained. A separate read-only review checked
arithmetic, feature gates, allocation provenance, alignment and partition rebasing.

The first Rust AVX2 implementation expressed the address as line plus in-line
slot. LLVM kept four extra instructions instead of reducing that expression.
The final SIMD path uses the equivalent flat `bucket * 16` byte offset (and a
rebased relative bucket for an owned line slice), retaining typed line storage.
The archived `byte_split_one_before.s` and `byte_split_one.s` show that reduction;
all three test configurations were rerun after it. This assembly change alone is
not a measured speedup claim.

Twenty-five workloads / 75 rows agree exactly across native C++, native Rust and
the expanded external Rust harness: allocations, full checksums, false positives,
present/absent counts, independent calibration and insertion batches. The 44 CLI
checks reject 32 malformed selectors before CSV and accept 12 exact valid row sets.
The new native comparison has five rows by default; the Rust external comparison
has eight (the old five plus native ByteSplit/FourSector/Split64). Parallel `all`
has nine rows, while the default remains the original three FastPattern modes.
Clippy with all targets and formatting checks pass for both crates.

`validation.json` records source/binary hashes and full commands; `parity.json`
and `cli-results.json` retain the actual correctness rows. These correctness
runs are not performance evidence. Native Rust performance confirmation is
reserved for the parent's preregistered primary matrix; no new performance
confirmation seeds were consumed here. The C++ prototype's small-filter result
must not be presented as a measured Rust result.

All original/frozen native and external release binaries remain byte-identical.
New release targets live under `/tmp/fastest-bf-rust-byte-native` and
`/tmp/fastest-bf-rust-byte-external`; their hashes are retained. Reproduce using
the exact commands in `validation.json` after reserving the chosen CPU for any
new speed measurement. Initial Clippy diagnostics and pre-flat-pointer validation
logs are retained separately rather than overwritten as final evidence.
