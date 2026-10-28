# Optional external comparison

This separate, unpublished crate adapts [fastbloom 0.17.0](https://docs.rs/fastbloom/0.17.0/fastbloom/)
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
