# Rust benchmark validation fixes, 2026-10-29

Both the native and external Rust comparison binaries now reject an invalid
filter list before allocating workloads or printing CSV. Empty overall selection
still selects all filters. Empty tokens, duplicates, unknown names, case changes,
and whitespace around exact names are errors; a valid subset cannot hide a typo.
Registration order remains unchanged before the seeded shuffle.

Both harnesses compare the complete output checksum after the first timed
prehashed query and first timed hash-plus-query with the validated warmup output.
Checks run after the timer stops, preserving measured boundaries. Later repetitions
still consume their outputs. This closes a gap where only prehashed warmup results
were checked and the hash-plus-query path was merely consumed.

Shared support modules live under `rust/src/bin/support/`, keeping the native
crate self-contained. Six tests pass in each executable: two selection tests,
two full-output helper tests, and two fault-injection tests through the actual
`run<F>` harness. The latter corrupt only the last answer on the first timed
prehashed or hash-plus-query pass; each must be rejected by its corresponding
validation. The CLI script also passes 32 cases: 24 malformed selections produce
nonzero status and no CSV; eight valid cases produce exactly the requested rows,
including omitted/empty selection, a one-filter subset, reversed lists, independent
insertion batches, and calibration.

Portable debug builds, Clippy with tests and formatting checks pass for both
crates. These debug timings are not performance evidence. Actual commands, logs,
source hashes, Cargo fingerprints and CLI outputs are retained. All three recorded
native/frozen release binary hashes remain unchanged; validation builds use
separate `/tmp/fastest-bf-rust-cli-*` targets.

Reproduce the CLI checks after the builds recorded in `metadata.json`:

```sh
python3 experiments/2026-10-29-rust-benchmark-validation/check_cli.py --cpu 3 --native /tmp/fastest-bf-rust-cli-native/debug/compare_benchmark --external /tmp/fastest-bf-rust-cli-external/debug/compare_benchmark --output /tmp/rust-cli-results.json
```
