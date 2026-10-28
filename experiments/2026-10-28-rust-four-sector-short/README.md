# Rust FourSector short-batch scheduling, 2026-10-28

The native Rust short-batch port improves the measured hash-plus-query time for
batch 8 by **1.40× at 64K keys** and **2.14× at 16M keys**, compared with the frozen
original Rust FourSector prototype in the same executable. At 16M keys, batch 31
improves by **1.36×**. Batch4096 remains within 0.4% in this confirmation.
These are scoped development measurements on this machine, not a universal
performance claim.

## Implementation and validation

The AVX-512 path uses two gathers for up to eight keys, placing two sectors per
key in the lower/upper halves of the vector. It combines the sector match masks
before writing one 0/1 answer per key. A full eight-key group uses a length-checked
unmasked input load; shorter groups use masked loads/stores.

Dispatch follows the independently tested C++ policy: 4–8 keys use this kernel
at every bitmap size; 4–63 keys use it above 2 MiB, after prefetching every queried
cache line. Other lengths retain the previous path. Scalar/AVX2 dispatch and
`disable-avx512` remain intact. Bitmap mapping, allocation, insertion and parallel
ownership are unchanged by this scheduling patch.

Seven FourSector tests pass in each of the normal, `disable-avx512`, and nightly
AddressSanitizer configurations; their actual logs are retained. The focused new
test compares **every output** with scalar and the prior vector kernel for lengths
0–131, input offsets 0–15, and bitmaps below/exactly/above the 2 MiB threshold.
It includes hits, misses, 0/u64::MAX and output sentinels; input allocations end at
the logical tail to expose accidental full-width tail loads to sanitizers.
Existing tests cover collision-safe insertion and serial/partitioned bitmap parity.
Clippy, formatting and native release builds pass. A separate read-only review
checked dispatch, lane masks, integer ranges, bounded addresses and feature gates.

`base-four-sector.rs` and `base.json` retain the prior native source and the hash
of `build/native-layout-base/parallel_benchmark-rust`. That frozen parallel binary
and the external Rust benchmark were not changed. `validation.json` records
current source/binary hashes and exact validation commands. This evidence is
separate from the earlier native integration/scratch-overflow archive.

## Same-process confirmation

The standalone crate in `benchmark/` copies the shared native comparison harness
and the frozen `FourSector16K8Experimental` source. Both old and new implementations
run in each process, with seeded filter order and identical inputs, allocation,
hashing, timing boundaries and verification. The new implementation uses the
native `FourSectorBloomFilter` library. The before implementation is the frozen
prototype's AVX-512 code, not a separate-language baseline.

The matrix matches the C++ confirmation: key powers16/24, requested8 bits/key
(actual16), 50% hits, query power22, batches8/31/4096, five repetitions, seeds2053
and4099, all keys in one insertion batch, calibration disabled. CPU3 was reserved
for these 12 sequential workloads. Other repository work continued on socket0.
The table takes the median of the two per-seed timing medians; speedup is old/new.

| Keys | Batch | Old query ns | New query ns | Old hash+query ns | New hash+query ns | Hash+query speedup |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 65,536 | 8 | 2.667 | 1.602 | 5.484 | 3.929 | 1.396× |
| 65,536 | 31 | 1.231 | 1.237 | 1.990 | 1.985 | 1.002× |
| 65,536 | 4096 | 1.092 | 1.082 | 1.616 | 1.621 | 0.997× |
| 16,777,216 | 8 | 7.553 | 5.539 | 13.682 | 6.383 | 2.144× |
| 16,777,216 | 31 | 5.326 | 4.784 | 6.548 | 4.799 | 1.365× |
| 16,777,216 | 4096 | 3.810 | 3.801 | 3.771 | 3.764 | 1.002× |

All 24 rows have paired identical bytes, query checksums, negative counts and
false positives. The allocation and bitmap layout are identical, so this change
does not buy speed through extra space or different accuracy. Raw per-case CSV,
aggregate rows, commands, compiler information and hashes are in `confirmation/`.
The two seeds and narrow hit-rate matrix limit any broader claim.

## Reproduce

Use a separate Cargo target directory to preserve the original external binary.
Reserve the selected CPU before running:

```sh
RUSTFLAGS="-C target-cpu=native" CARGO_TARGET_DIR=/tmp/fastest-bf-rust-short-confirmation cargo build --release --locked --manifest-path experiments/2026-10-28-rust-four-sector-short/benchmark/Cargo.toml
python3 experiments/2026-10-28-rust-four-sector-short/run.py --cpu 3 --output-dir /tmp/rust-short-confirmation-new
```

The runner refuses an existing output directory and verifies source/executable
hashes remain unchanged during the run. Validation commands:

```sh
RUST_TEST_THREADS=1 taskset -c 3 cargo test --manifest-path rust/Cargo.toml --lib four_sector::tests
RUST_TEST_THREADS=1 taskset -c 3 cargo test --manifest-path rust/Cargo.toml --features disable-avx512 --lib four_sector::tests
RUSTFLAGS="-Zsanitizer=address" RUST_TEST_THREADS=1 CARGO_TARGET_DIR=/tmp/fastest-bf-native-rust-asan taskset -c 3 cargo +nightly test --manifest-path rust/Cargo.toml --target x86_64-unknown-linux-gnu --lib four_sector::tests
cargo clippy --manifest-path rust/Cargo.toml --all-targets -- -D warnings
cargo fmt --manifest-path rust/Cargo.toml -- --check
```
