# Reproduce batch4096 queries

The published tables are a fixed snapshot of completed comparisons. Rebuild the current source to measure it on your machine, or use the frozen research revision to reproduce the original external panels. These two procedures use different harnesses and should not be presented as the same run.

## Build the native library and runners

```sh
cmake -S . -B build/native -DCMAKE_BUILD_TYPE=Release -DBF_NATIVE=ON
cmake --build build/native -j
ctest --test-dir build/native --output-on-failure
cargo build --release --locked --manifest-path rust/Cargo.toml
```

C++ needs a C++17 compiler, CMake 3.16+, Python 3 for harness checks, and threads. Rust needs 1.89+. `BF_NATIVE=ON` targets the build host. The C++ benchmark suite includes AVX2 baselines; the standalone native filter headers also have scalar implementations. Do not execute a native binary on an incompatible machine.

## Run a new batch4096 comparison

Choose an allowed physical CPU for `--cpu`. The commands below use CPU 2, present on our platform. Run each timing suite alone on its socket.

```sh
python3 scripts/run_comparison.py \
  --executable build/native/compare_benchmark \
  --output-dir results/local-cpp-4096 --cpu 2 \
  --key-powers 16,25 --bits-per-key 24 --hits 50 \
  --batches 4096 --query-power 22 --repeats 6 --seeds 42,43,44 \
  --calibration-power 26 \
  --filters FourSectorRange12BloomFilter,Split64RangeBloomFilter

python3 scripts/run_comparison.py \
  --executable rust/target/release/compare_benchmark \
  --output-dir results/local-rust-4096 --cpu 2 \
  --key-powers 16,25 --bits-per-key 24 --hits 50 \
  --batches 4096 --query-power 22 --repeats 6 --seeds 42,43,44 \
  --calibration-power 26 \
  --filters FourSectorRange12BloomFilter,Split64RangeBloomFilter
```

The runner records metadata and CSV output. Raw runner output also includes construction diagnostics; the publication renderer selects only query metrics. Hash-plus-query and prehashed query must remain separately labeled. These ordinary runners compare native implementations and retained legacy baselines; the complete external adapters live in the frozen research checkout below.

The native parallel wrappers can be exercised with `scripts/run_parallel.py`. Its public whole-array timing contract differs from the published common executor's 4096-key calls; use the frozen executor when reproducing that table.

## Frozen external comparisons

```sh
git fetch origin experiment/pipelined-sectorized
git worktree add --detach ../bf-evidence 551a3a4c648df223e29305cf89418e48a553c577
```

Use the panel's archived build inputs, producers, pinned dependency revisions and run metadata in that worktree. The [performance report](performance.md#data-and-frozen-evidence) links each source directory. Keep the original CPU/NUMA policy, trial counts, calibration sizes, memory accounting and API contracts when comparing results. Absolute latency will depend on the machine, compiler and system load.

The release snapshot records source SHA-256 hashes. To regenerate the exact publication slice from the frozen checkout:

```sh
python3 scripts/export_batch4096.py ../bf-evidence
python3 scripts/render_batch4096.py
python3 scripts/render_batch4096.py --check
```

To check the shipped JSON, recompute its geometric means and rankings, and confirm that README/CSV/report tables match, only the last command is needed. It does not download dependencies or run a timing benchmark.

## Interpretation

The release uses three practical conditions: at most 16 actual bits/key with 1% or 0.1% FPR, and at most 24 actual bits/key with 0.01% FPR. All are evaluated with batches of 4096. Keep unsuccessful quality gates and missing API contracts in the source evidence. Select by actual bytes and calibrated quality before ranking speed; do not compare a looser-error filter to a stricter one as if they were interchangeable.
