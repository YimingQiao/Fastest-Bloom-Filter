# Optional Rust SBBF comparison

This separate crate adds the public `sbbf-rs-safe 0.3.2` API, with its kernel explicitly pinned to `sbbf-rs 0.2.8`. It leaves the native library and previous benchmark archives unchanged. See the [source audit and immutable provenance](../../experiments/2026-10-29-rust-sbbf-survey.md).

The registry contains 14 rows: native FastPattern, ByteSplit, FourSector and Split64; original Fastbloom 0.17.0, pinned Bloomsday and SBBF; and an explicit public length-one query control for each of these seven configurations. Each control calls the public singleton API only when the batch length is one, otherwise preserving its original bulk wrapper. Split64/FourSector singleton APIs use scalar source, so those controls can also change kernel code generation. These controls are not production changes. The earlier experimental Split64/FourSector implementations and rejected ShortEntry candidates are outside this registry.

SBBF has no public bulk API. Both SBBF rows loop over unmodified public insert/query calls, which use the upstream selected AVX2/SSE4.1/scalar implementation through its trait object. No private implementation or new probing algorithm is imported. The selected upstream backend is printed to stderr, after exact selection validation. A generic build on an AVX2 host still selects AVX2; this crate's `disable-avx512` feature applies only to native filters.

The common strict-next-power-of-two allocation budget is preserved. `Filter::new(8, budget_bytes)` creates exactly the budget in logical bytes; these constructor arguments influence only allocation size. Upstream rounds its backing allocation to 64-byte alignment, separately from the 32-byte logical block length. The adapter reports the padded allocation; its test allocator checks both the padding and the single allocation, including odd block counts. No extra bitmap is built for sizing. The shared harness keeps one live bitmap per measured construction phase and destroys it before allocating the next.

The CSV/workloads follow the existing external Rust harness: common 64-bit source hash, prehashed and hash-plus-operation timings, independent insert/query batch sizes, full no-false-negative checks, complete timed-output checksum checks outside the first query timers, and independent negative calibration after timing. All outputs are dense `u32`. Unknown, duplicate and empty selection tokens fail before any CSV or workload generation; an empty overall selection means all.

```
cargo build --locked --release --manifest-path benchmarks/rust-sbbf-external/Cargo.toml
compare_benchmark KEY_POWER REQUESTED_BPK HIT_PERCENT QUERY_POWER BATCH REPEATS SEED FILTERS INSERT_BATCH CALIBRATION_POWER
```

Calibration power is zero (disabled) or 12–27. The empty filter argument must be quoted to select all while specifying later arguments. Example correctness smoke: `compare_benchmark 12 8 50 12 31 1 42 '' 17 12`. Its timing values are incidental; it is not a performance result.

Correctness preparation covers an independent byte-level Parquet bitmap oracle, duplicate/block-colliding hashes, no false negatives, all query lengths 0–131 plus 4096/4097 at eight input offsets, output guards, all 14 mismatched-length paths, exact original/singleton equality, actual allocation requests, and the shared deliberate timed-output corruption tests. `check_cli.py` adds 31 CLI cases and 12 complete-registry semantic workloads (168 rows), checking actual bytes, checksums and calibration counts between every original/control pair. Normal, native `disable-avx512`, and ASan runs each passed all 12 tests; clippy also passed. The CLI and 168-row semantic smoke passed. Evidence and exact commands are under `validation/`; none of these smoke timing values is a performance result.

Current state is recorded in `protocol.json`; no performance claim or production promotion follows from these correctness checks. Compile/test/timing runs on the shared machine require the agreed socket lease and the matching `/tmp/fastest-bf-socketN.lock`. Existing frozen executable paths must not be overwritten.
