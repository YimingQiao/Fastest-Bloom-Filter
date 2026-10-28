# Rust Split64 short-query scheduling, 2026-10-29

The native Rust candidate improves hashing-plus-query time at 16M keys by **1.20×
for batch 4** and **1.30× for batch 8**, and by **1.055× for batch 1**, against the
previous native implementation in the same executable. The measured large-bitmap
batch 31 regresses by **2.3%**; batch 4096 is within 0.4% at both sizes. These are
scoped development results on this machine, not a universal performance claim.

## Change and causal control

The policy matches the validated [C++ mapping](../2026-10-28-small-batch-kernels/native-split-integration.md):

- Exactly one query calls the original backend's one-key lookup directly.
- AVX-512 batches 2–15 compute the same eight masks with eight widened salt
  constants, 32-bit multiplication and a 64-bit shift, avoiding a 32-to-64 conversion.
- Other batches retain the previous prefetch-32 loop; insertion remains unchanged.

Each widened salt has a zero upper 32-bit word. Multiplication therefore preserves
exactly the old wrapping 32-bit product, and shifting by 26 yields positions 0–63.
The runtime AVX2/AVX512F gates, portable scalar path and `disable-avx512` remain
intact. This changes no bitmap contents, memory allocation or false positives.

`benchmark/src/before.rs` is a byte-identical snapshot of the native pre-change
`rust/src/split64.rs`; `base.json` records its hash and repository revision.
`single.rs` adds only the single-query return. `after.rs` adds that return plus
the wide-mask short path. All three run through one copied native comparison
harness, with the same input arrays, allocation, timing boundaries and seeded
filter order. The private shared layout helper is copied with only its private
sizing dependency expanded; the sizing body itself is copied from the native
`BloomFilter::word_count`. This keeps the experiment independent of production
Split64 edits. The public hash function comes from the recorded native crate.

The **SingleOnly control** matters: most of the large-bitmap short-batch gain is
already present after that source-level control-flow change. At 16M keys the final
candidate is a further 3.6% faster for batch 4 and 5.5% for batch 8 than SingleOnly,
but is 1.4% slower for batch 15. Do not attribute the full improvement solely to
removing a widening instruction. No variants were selected from these timings;
the tested policy was fixed from the preceding C++ experiment.

## Confirmation

The matrix uses key powers 16/24, requested 8 bits/key (actual 16), query power 22,
50% hits, batches 1/4/8/15/31/4096, five repetitions, seeds 12289/65537, one insertion
batch containing all keys, and independent calibration disabled. CPU3 was reserved
for 24 sequential workloads. Other work continued on socket 0. Each table cell is
the median of two per-seed timing medians; speedup is old/new.

| Keys | Batch | Old query ns | New query ns | Old hash+query ns | New hash+query ns | SingleOnly hash+query ns | Old/new speedup |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 65,536 | 1 | 4.110 | 3.703 | 5.853 | 5.713 | 5.618 | 1.024× |
| 65,536 | 4 | 2.155 | 2.051 | 4.070 | 3.694 | 3.829 | 1.102× |
| 65,536 | 8 | 1.730 | 1.610 | 3.682 | 3.204 | 3.704 | 1.149× |
| 65,536 | 15 | 1.531 | 1.470 | 2.625 | 2.526 | 2.616 | 1.039× |
| 65,536 | 31 | 1.489 | 1.510 | 2.114 | 2.101 | 2.097 | 1.006× |
| 65,536 | 4096 | 1.641 | 1.642 | 2.086 | 2.095 | 2.112 | 0.996× |
| 16,777,216 | 1 | 8.541 | 8.186 | 12.857 | 12.185 | 12.190 | 1.055× |
| 16,777,216 | 4 | 5.093 | 5.244 | 7.239 | 6.025 | 6.241 | 1.202× |
| 16,777,216 | 8 | 5.121 | 4.983 | 7.091 | 5.450 | 5.752 | 1.301× |
| 16,777,216 | 15 | 4.757 | 4.762 | 4.775 | 4.832 | 4.765 | 0.988× |
| 16,777,216 | 31 | 5.044 | 5.146 | 4.875 | 4.987 | 4.971 | 0.977× |
| 16,777,216 | 4096 | 4.067 | 4.065 | 3.820 | 3.829 | 3.818 | 0.998× |

All 72 rows have identical paired memory, output checksums, false positives and
negative-query counts. Raw CSVs, full commands, compiler version, source/binary
hashes and aggregate results are retained under `confirmation/`; the runner
checks source and executable hashes at completion. The limited hit-rate/size/seed
matrix does not justify a broader claim.

## Validation and reproduction

The isolated candidate passes seven targeted tests each in normal,
`disable-avx512`, and nightly AddressSanitizer builds. The focused tests compare
**every output** with scalar and the old AVX-512 kernel for lengths 0–131, input
offsets 0–15, both small and large bitmaps, inserted/absent/special hashes and output
sentinels. Input allocations end at the logical tail. A separate mask oracle
checks all eight lanes against both the old intrinsic path and scalar wrapping
multiplication for 65,541 hashes. Existing tests check collision-safe insertion,
backend equality, partitioned-versus-serial bitmap parity, and mismatch rejection
before writing. A read-only review independently checked feature gates, alignment,
zero-length behavior, range bounds and arithmetic identity. Actual test logs are
retained under `logs/`; native production validation also passes seven tests in each of the same three
configurations. Clippy with all targets and formatting checks pass. Commands and
hashes for these production checks are recorded separately in `validation.json`.

The exact tested `after.rs` is copied to production `rust/src/split64.rs`.
`native-rust.patch` records the minimal production delta. Frozen external and
native-base binaries are preserved. Use a separate Cargo target directory:

```sh
RUSTFLAGS="-C target-cpu=native" CARGO_TARGET_DIR=/tmp/fastest-bf-rust-split-short cargo build --release --locked --manifest-path experiments/2026-10-29-rust-split64-short/benchmark/Cargo.toml
python3 experiments/2026-10-29-rust-split64-short/run.py --cpu 3 --output-dir /tmp/rust-split-short-new
```

Reserve the selected CPU and its physical sibling/socket before timing; the runner
refuses to reuse an existing output directory. Validation commands and actual logs are in
`validation.json` and `logs/`. The recorded source hashes describe this run; a
future dependency/compiler revision needs a fresh measurement.
