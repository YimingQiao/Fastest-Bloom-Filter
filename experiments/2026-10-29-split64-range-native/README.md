# Native Split64 range capacity and parallel construction

Source preparation only; correctness builds and performance evidence are pending.
This isolated C++/Rust experiment keeps the Split64 masks, batch kernels and
prefetch policy, and uses multiply-high indexing into arbitrary complete cache
lines. It follows the promising C++ 12/24-bpk training observations, without
claiming those timings apply to this packaging or the Rust port.

`Split64Range` and `Split64RangeBloomFilter` expose an at-most byte budget;
the separate `n,bpk` constructor uses `floor(n*bpk/8)` as that budget. Actual
64-byte aligned backing capacity is reported and may not exceed the budget.
The existing native constructors and production files remain unchanged.

Both languages provide exclusive parallel construction and immutable parallel
queries. Histogram/scatter assigns whole physical lines. Nondivisible line and
worker counts use the exact ownership formula; divisible counts permit the
proved multiply-high shortcut in [OWNERSHIP.md](OWNERSHIP.md). Scratch remains
approximately eight bytes per input hash plus worker metadata. It is not a
concurrent overlapping writer/reader interface.

The Rust crate preserves the original four types as controls. Only its export
and two new modules are added; the C++ serial parent differs only in public
inspection and singleton access. `source-provenance.json` records parent files.
Validation will cover an independent full-bitmap oracle, essential bit tests,
tail/output guards, full serial/parallel parity with odd worker counts, actual
sizing, backend/sanitizer variants and twelve complete C++/Rust fixtures.

No throughput runner or speed claim is provided at this preparation stage.
