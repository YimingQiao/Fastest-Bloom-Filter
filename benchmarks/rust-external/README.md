# Optional external comparison

This separate, unpublished crate adapts [fastbloom 0.17.0](https://docs.rs/fastbloom/0.17.0/fastbloom/)
and [Bloomsday](https://github.com/sidd-27/Bloomsday/tree/11f16a91a1c8a20344cd263e908f957dac7cf5d0)
to the native Rust benchmark. The core library remains dependency-free.
`Cargo.lock` pins the dependency graph; build with `--locked`.

```sh
RUSTFLAGS="-C target-cpu=native" cargo build --release --locked --manifest-path benchmarks/rust-external/Cargo.toml
python3 scripts/run_comparison.py --cpu 2 --output-dir results/external \
  --executable benchmarks/rust-external/target/release/compare_benchmark \
  --key-powers 16,24 --bits-per-key 4,8,16 --hits 0,50,100 --seeds 42,43,44
```

Both filters receive identical prehashed 64-bit inputs and the same allocated
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
CSV schema match `rust/src/bin/compare_benchmark.rs`. All inserted keys are checked
for false negatives before results are accepted.

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
