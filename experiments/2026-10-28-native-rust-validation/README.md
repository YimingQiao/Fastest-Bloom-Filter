# Production Rust validation, 2026-10-28

This archive records correctness validation of `Split64BloomFilter` and
`FourSectorBloomFilter`, including scalar, AVX2, AVX-512 and exclusive partitioned
construction. It is not a performance report: parity runs use one repetition,
and other development work shared the machine.

## Retained evidence

- `single-parity-retained.json`: the original 186 rows from 31 workloads × two
  layouts × native C++, native Rust and frozen experimental Rust. The associated
  original script is preserved verbatim as `original-parity-script.py`.
- `fixed-parity/`: a fresh reproduction after checked scratch-size arithmetic was
  added. It contains 186 single-thread rows, 84 parallel rows, exact commands and
  executable SHA-256 values checked before/after the run. `fixed-parity.log`
  retains the actual successful summary output.
- `scratch-debug-test.log` and `scratch-release-test.log`: both new overflow
  regression tests pass in debug and optimized release. They check element-byte
  multiplication, metadata addition, the largest representable estimate, and
  both public candidate methods. An overflowing multiworker estimate now panics
  explicitly with `build scratch size overflow` instead of wrapping in release.
- `native-build.log`, `clippy.log`, `runner-test.log`: actual retained output from
  the final native build, Clippy, and offline runner checks.
- `metadata.json`: current Rust source hashes, source revision/patch information,
  executable hashes and validation commands. `source.patch` preserves the Rust
  changes relative to the recorded revision.

Before the overflow-only follow-up, **19 library tests passed** in the normal,
`disable-avx512`, and nightly AddressSanitizer configurations. Formatting and
Clippy also passed. Their complete console logs were not saved to files; this
archive records the observed result and exact commands, without reconstructing
those logs. The two added overflow tests bring the library total to 21; the final
follow-up ran those two focused tests in debug/release, then repeated all parity
cases. It did not rerun the entire 21-test sanitizer suite.

Native runtime tests compare forced scalar, AVX2 and detected AVX-512 paths;
serial and partitioned bitmaps match for worker requests 1/2/3/7/8. Tests cover
zero/tiny inputs, tails and offsets, duplicates, same-line collisions, 0/u64::MAX,
all inserted keys, and owned slices above the 2 MiB prefetch threshold. This is
scalar fallback validation on x86-64, not a non-x86 cross-compilation claim.

## Exact parity cases

The single-thread argument order is:

```text
KEY_POWER BPK HIT_PERCENT QUERY_POWER QUERY_BATCH REPEATS SEED FILTERS INSERT_BATCH CALIBRATION_POWER
```

| Cases | Key power | Requested bpk | Hit % | Query power | Query/insertion batches | Seed | Calibration power |
| ---: | ---: | --- | --- | ---: | --- | ---: | ---: |
| 27 | 16 | 4, 8, 16 | 0, 50, 100 | 14 | (1,1), (17,3), (4096,65536) | 731 | 16 |
| 4 | 20 | 16 | 50 | 16 | (3,4), (15,7), (31,17), (4096,1048576) | 20261028 | 18 |

Each case runs both native names against frozen Rust
`FourSector16K8Experimental` / `Split64Experimental`. It compares actual bitmap
bytes, result checksum, timed negative/false-positive counts, and separate
negative-calibration/false-positive counts. All calibration probes are enabled,
including the all-hit timed cases.

The parallel argument order is:

```text
KEY_POWER BPK QUERY_POWER THREADS REPEATS SEED HIT_PERCENT [FAMILIES]
```

Nine cases use key power 16, bpk 8, query power 16, one repetition, seed 731,
50% hits, worker requests 1/3/7, and family selections omitted / `all` /
`FourSector,Split64`. Native C++ and Rust emit respectively 3/7/4 rows per case.
The check compares names, actual bitmap bytes, checksums, false positives,
negative counts and effective build/query workers. Each layout's serial and
parallel modes have matching answers. Scratch allocations are retained but not
required to match between languages: Rust's safe scatter uses additional slice
and cursor storage. All these correctness runs were pinned to CPU 3, so they do
not establish multi-core scaling.

## Reproduce without replacing the archived evidence

Build the native C++ and Rust executables using the desired recorded source
revision. The frozen experimental Rust executable used in `fixed-parity` was
not rebuilt or modified during validation; its hash is recorded there. If it is
rebuilt, treat that as a new comparison and retain the new hash.

```sh
cmake -S . -B build/native -DCMAKE_BUILD_TYPE=Release -DBF_NATIVE=ON -DCMAKE_CXX_COMPILER=clang++
cmake --build build/native --target compare_benchmark parallel_benchmark -j2
RUSTFLAGS="-C target-cpu=native" cargo build --manifest-path rust/Cargo.toml --release --bins
python3 experiments/2026-10-28-native-rust-validation/check_parity.py --cpu 3 --output-dir /tmp/native-rust-parity-new
```

The reproduction script creates a new output directory and refuses to reuse an
existing one. It saves both languages' rows and commands. Run it only after
reserving the selected core; it never needs CPU 2.

Validation commands used for the original 19-test suite:

```sh
RUST_TEST_THREADS=1 taskset -c 3 cargo test --manifest-path rust/Cargo.toml --lib
RUST_TEST_THREADS=1 taskset -c 3 cargo test --manifest-path rust/Cargo.toml --features disable-avx512 --lib
RUSTFLAGS="-Zsanitizer=address" RUST_TEST_THREADS=1 CARGO_TARGET_DIR=/tmp/fastest-bf-native-rust-asan taskset -c 3 cargo +nightly test --manifest-path rust/Cargo.toml --target x86_64-unknown-linux-gnu --lib
```

The sanitizer run used `rustc 1.100.0-nightly (809936eac 2026-09-12)`; normal builds
used the compiler recorded in `metadata.json`. Focused follow-up commands:

```sh
RUST_TEST_THREADS=1 taskset -c 3 cargo test --manifest-path rust/Cargo.toml --lib layout_parallel::tests
RUSTFLAGS="-C target-cpu=native" RUST_TEST_THREADS=1 taskset -c 3 cargo test --manifest-path rust/Cargo.toml --release --lib layout_parallel::tests
cargo clippy --manifest-path rust/Cargo.toml --all-targets -- -D warnings
cargo fmt --manifest-path rust/Cargo.toml -- --check
python3 experiments/2026-10-28-native-rust-validation/check_parallel_runner.py
```

## Parallel runner review

The new runner checks the exact expected mode set and rejects missing,
duplicate or unexpected rows. It compares answers and allocation within each
layout; different layouts may legitimately have different checksums/FPR.
Its family prefixes are disjoint for the three supported names.

`check_parallel_runner.py` uses mocked subprocess output and executes no
benchmark. Five test methods cover 27 subcases: six valid selections/orderings,
four invalid family arguments, four missing/duplicate/unknown-mode cases, and
12 within-family checksum/size/negative-count/false-positive disagreements,
and rejection of duplicate CPU IDs.
It also verifies that default FastPattern omits the optional argument for older
three-mode binaries. All pass.

Review additionally identified duplicate CPU IDs as misleading for scaling
(e.g. two requested workers pinned to one unique CPU); the root agent added
that input check, and the archived offline test confirms rejection.
Physical-core/socket topology remains a
caller-selected benchmarking constraint recorded by the runner.
