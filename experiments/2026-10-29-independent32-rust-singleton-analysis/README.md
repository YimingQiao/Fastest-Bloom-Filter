# Independent32 singleton192 analysis

This sidecar analyzes the frozen CPU2/socket0 screen prepared in
`../2026-10-29-independent32-rust-singleton-screen`. It changes no measured
source, executable, protocol, or timing. The source preparation was committed
as `aad7dda8b473be5020b34505cf3faad2bda9fc02` before the authorized measurement.

The frozen runner validates the exact filter set but does not independently
reconstruct the seeded row permutation. This postprocessor closes that gap:
`order_oracle.py` parses registration order from the frozen Rust source,
advances SplitMix64 past the key-base, insertion shuffle, present queries and
query shuffle, then reproduces the row shuffle. It checks every raw case
before any ranking. The offline test compares this skip-ahead calculation
with a literal small-array simulation and rejects a swapped row.

Run after all sixteen workloads have completed:

```sh
python3 experiments/2026-10-29-independent32-rust-singleton-analysis/summarize.py
python3 -m unittest discover -s experiments/2026-10-29-independent32-rust-singleton-analysis -p 'test_*.py' -v
```

The analyzer verifies committed and current source/dependency/binary hashes,
the inherited lease metadata, exact CLI/workload sequence, raw file hashes,
raw-to-aggregate row order, full producer guards and all four phase vectors.
The default report directory must not already exist; use `--output` to
regenerate elsewhere without replacing an archive.

The 64 exact shortcut/before pairs retain all size/allocation/batch/contract
combinations. Another 192 pairs retain the three existing leaf controls.
Every pair keeps trial vectors, observed min/max and execution positions.
The 192 nested allocation/FPR views select each contract separately; smaller
tested allocations remain eligible under a larger cap. The 3456 individual
native alternatives retain ineligible and losing configurations. The 384
generic/visible ratios do not equate their distinct hash contracts.

Quality uses 32 family/size/seed records. Known clone and batch/mode aliases
are deduplicated, with disagreement rejected; no confidence bound pools
distinct families, input intervals or earlier screens. Different public
families may implement the same mapping. This is a seed42 training screen
with 2^20 calibration negatives per record, not held-out confirmation or
a global-fastest claim. CPU affinity does not enforce explicit NUMA binding.

The candidate remains exactly the four-line public singleton shortcut.
The assembly caveat is retained: it saves six callee-saved registers rather
than one and calls the scalar helper from its portable remainder. All larger
batch and visible API regressions belong to the measured result.

The source-derived seed42 row schedule places the shortcut before unchanged
Independent32 at both key sizes (zero-based positions1/9 and0/9). Query phase
balance does not imply between-filter pair-order balance. Fresh-seed
confirmation should retain both pair-order strata before attributing small
differences to the shortcut.
