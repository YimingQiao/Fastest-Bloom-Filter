# Optional external comparison

This separate, unpublished crate compares native Rust implementations of
[fastbloom 0.17.0](https://docs.rs/fastbloom/0.17.0/fastbloom/),
[Bloomsday](https://github.com/sidd-27/Bloomsday/tree/11f16a91a1c8a20344cd263e908f957dac7cf5d0),
FastPattern, and the experimental Split64 and FourSector layouts. The core
library remains dependency-free.
`Cargo.lock` pins the dependency graph; build with `--locked`.

```sh
RUSTFLAGS="-C target-cpu=native" cargo build --release --locked --manifest-path benchmarks/rust-external/Cargo.toml
python3 scripts/run_comparison.py --cpu 2 --output-dir results/external \
  --executable benchmarks/rust-external/target/release/compare_benchmark \
  --key-powers 16,24 --bits-per-key 4,8,16 --hits 0,50,100 --seeds 42,43,44
```

All filters receive identical prehashed 64-bit inputs and the same allocated
bitmap bytes. `fastbloom` selects its probe count via `expected_items`; we call
its public `insert_hash` / `contains_hash` API in the timed batch kernel. Its
source-hasher configuration is irrelevant to these prehashed APIs. The hash-plus-query
column uses the common benchmark hash, not fastbloom's default raw-key hasher.

**Equal space is not equal accuracy.** fastbloom's ordinary Bloom layout generally
provides lower false-positive rates at this space budget, at the cost of more
random bit probes. This comparison describes a speed/space/accuracy tradeoff; it
does not establish superiority at equal FPR. Native SIMD batch queries and scalar
public-API loops are different execution paths; their API granularity is explicit.

The workload, validation, output consumption, timing boundaries, alignment, and
common CSV fields follow the shared C++/Rust comparison contract. All inserted
keys are checked for false negatives before results are accepted. The C++ harness
also emits construction/hashing scratch-allocation fields; the Rust external
harness does not currently emit those fields.

## Experimental configurations

| Exact filter name | Configuration | Native batch implementation |
| --- | --- | --- |
| `FastPatternBF` | Native library's adaptive six/eight-bit, two-word pattern layout | AVX-512, AVX2 or scalar |
| `Fastbloom017` | Pinned fastbloom 0.17.0, probe count chosen from expected items | Loop over upstream scalar public methods |
| `BloomsdayPinned` | Pinned eight-sector, 32-byte split-block layout | Loop over upstream public methods |
| `Split64Experimental` | Eight 64-bit sectors, eight bits/key, Parquet multiply-shift salts, prefetch distance 32 | Horizontal AVX-512 or scalar |
| `FourSector16K8Experimental` | Four 32-bit words in one cache line, two bits/word from a 16-entry rotation dictionary | Four-gather AVX-512 queries and prepared four-key insertion, or scalar |

Split64 matches C++ `Split64P32`; FourSector matches C++ `FourSector16K8`.
Both remain private benchmark modules, with no new native-library API.
They use runtime CPU detection. Their current alternative to AVX-512 is scalar;
the native library's `disable-avx512` feature does not control these private
modules. FourSector prefetches 64 future keys only when its bitmap exceeds 2 MiB.
Insertion uses sequential ORs after mask preparation, retaining colliding updates.

Both prototypes use the same strict-next-power-of-two sizing as FastPattern:
at power-of-two key counts, requested 4/8/16 bits/key become actual 8/16/32.
The CSV's `filter_bytes` and `actual_bpk` describe actual space.
The [Split64 experiment](../../experiments/2026-10-28-split64/README.md) explains
its public algorithm origin and scope; the
[FourSector Rust parity record](../../experiments/2026-10-28-rust-four-sector/README.md)
retains exact C++/Rust answer and calibration checks.

## Arguments and independent accuracy calibration

```text
compare_benchmark KEY_POWER BPK HIT_PERCENT QUERY_POWER QUERY_BATCH REPEATS SEED FILTERS [INSERT_BATCH [CALIBRATION_POWER]]
```

`FILTERS` is a comma-separated list of exact names from the table; an empty string
selects all. `INSERT_BATCH` defaults to `QUERY_BATCH`. The direct executable
requires a positive insertion batch; the runner's `--insert-batch 0` expands to
all inserted keys. `CALIBRATION_POWER` defaults to 0 (disabled), or accepts 12–27.

Calibration performs `2^CALIBRATION_POWER` additional absent queries **after**
timing. Its key range is disjoint from insertion keys and timed queries, and it
reuses one batch of scratch instead of enlarging the timed query working set.
`calibration_absent_queries` and `calibration_false_positives` contain its counts.
The original `fpr` column still describes the timed query stream and is `nan` for
an all-hit workload. `rank_external.py` prefers calibration counts, counts each
seed once across repeated batch/hit cases, and uses a one-sided 95% Wilson bound.

## Standalone Rust comparison and report

No C++ executable is needed for this report. Run the following only when the
benchmark CPU is available; replace `--cpu 2` with an allowed isolated core.

```sh
RUSTFLAGS="-C target-cpu=native" cargo build --release --locked --manifest-path benchmarks/rust-external/Cargo.toml
python3 scripts/run_comparison.py --cpu 2 --output-dir results/rust-heldout \
  --executable benchmarks/rust-external/target/release/compare_benchmark \
  --key-powers 16,20,24 --bits-per-key 4,8,16 --hits 0,50,100 \
  --batches 1,17,4096 --insert-batch 0 --query-power 20 --repeats 3 \
  --seeds 731,20261028,8675309 --calibration-power 24
python3 scripts/rank_external.py results/rust-heldout/results.csv \
  --max-bpk 16 --allocation-slack 0 --fpr-targets 0.01,0.001 \
  --metric hash_lookup_ns --output results/rust-heldout/ranking-hash-query.csv
```

The runner forwards both `--insert-batch` and `--calibration-power` to this
external Rust executable. The original native Rust benchmark may expose a
different argument set. Repeat ranking with
`lookup_ns`, `insert_ns`, or `hash_insert_ns` for the corresponding metric.
The report ranks only configurations meeting the specified actual-memory cap
and measured accuracy bound. It preserves data size, hit rate and query/insertion
batch differences; it does not establish a universal fastest filter.

Keep the result directory's raw CSV, commands and provenance. `source.patch`
captures tracked changes only, so commit experimental sources before a published
run or separately retain their snapshots/hashes. Candidate selection and
confirmation should use separate seeds; the example seeds must be changed if
they have already been used to choose a configuration.

## Bloomsday adapter

`BloomsdayPinned` uses the unmodified native Rust dependency at commit
`11f16a91a1c8a20344cd263e908f957dac7cf5d0`; its public `insert_hash` and
`may_match_hash` APIs consume the same prehashed inputs as the other filters.
The upstream code implements eight multiply/shift probes into a 32-byte split
block; it relies on compiler vectorization. There is no upstream batch API, so
the adapter loops over those public methods in the timed batch kernel.

The pinned constructor accepts expected entries and a sizing-FPR parameter,
not a byte count. It computes `ceil(-ln(fpr)/ln(2)^2)` bits per key and allocates
`ceil(entries * bits_per_key / 256)` blocks of exactly 32 bytes. The adapter
chooses the midpoint of the rounding interval that produces the requested
rounded bitmap budget, and asserts the inverse calculation. `filter_bytes`
is derived from that exact pinned constructor formula because upstream exposes
no allocation-size getter. It excludes the Vec/object fields and allocator
metadata, consistently with other native bitmap sizes. **The sizing parameter
is not used as the measured FPR**; actual absent-query false positives determine
whether a row qualifies for an accuracy budget.

The Rust external harness also reports `input_mode=prehashed`, `hash_insert_ns`,
`allocate_hash_insert_ns`, and `insert_batch`, matching the current shared C++
harness. Optional positional argument 9 sets insert batch size independently
from query batch size (argument 5); absence retains the original behavior.
