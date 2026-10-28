# Native Rust four-sector parity, 2026-10-28

The benchmark-only `FourSector16K8Experimental` in
`benchmarks/rust-external/src/four_sector.rs` matches the experimental C++
`FourSectorBF<8>` with its 16-entry two-bit dictionary. It does not change the
native Rust library API.

Each key sets two bits in each of four separate 32-bit words within one cache
line. Upper hash bits select the line and independent within-quarter offsets;
cyclic rotations of the lower hash word supply each nine-bit dictionary/rotation
code. Runtime AVX-512 performs four gathers for sixteen query keys, uses masked
loads/stores for tails, and prepares four insertion keys before sequential ORs
that preserve colliding updates. A portable scalar path uses the same layout.
Both implementations prefetch 64 keys ahead when the bitmap exceeds 2 MiB.

`parity.csv` contains 35 paired C++/Rust workloads. Every pair has identical
allocation size, timed-query checksum, false-positive count, and independent
negative-calibration count. Cases cover requested 4/8/16 bits/key, hit rates
0/50/100, query batches 1/3/4/7/15/16/17/31/4096, insertion batches spanning
scalar/prepared tails, and bitmaps above the prefetch threshold. These are
correctness checks, not performance measurements.

Four new unit tests check sizing and alignment; distinct sector words and
two-bit masks; scalar/runtime bitmap equality with duplicate and same-line
collision-heavy inputs; query lengths 0–145 and offsets 0–7 with output
sentinels; the large-bitmap prefetch path; and rejection of mismatched output
length. All seven external-crate tests pass, including the existing Split64
tests. `cargo fmt --check` and `cargo clippy --all-targets -- -D warnings` pass.

Reproduce after building the C++ four-sector experiment:

```sh
cargo test --locked --manifest-path benchmarks/rust-external/Cargo.toml
RUSTFLAGS="-C target-cpu=native" cargo build --release --locked --manifest-path benchmarks/rust-external/Cargo.toml
python3 experiments/2026-10-28-rust-four-sector/check_parity.py
```

`metadata.json` retains exact commands, compiler version, source hashes and
both executable hashes. The Rust implementation remains experimental pending
the broader performance and accuracy comparison.
