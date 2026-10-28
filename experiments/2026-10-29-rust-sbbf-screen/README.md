# Rust SBBF14 initial screen

This protocol is frozen before performance data. The independent [adapter correctness archive](../../benchmarks/rust-sbbf-external/README.md) passed normal/disable-AVX512/ASan tests, exact CLI selection, allocation accounting and full-output smoke checks. The performance matrix uses that existing binary unchanged. No native source change or promotion is proposed.

The initial grid is 12 workloads / 168 rows: key powers 16 and 25; requested8/16 (actual16/32 bpk); batches1/31/4096; 50% requested hits; query power22; five repetitions; seed42; whole-input insertion batches; and 2^24 independent negative calibration queries. Every process runs all14 configurations, with deterministic filter-order shuffling. This is throughput over independent keys, not a dependency-chain latency measurement. The frozen harness measures prehashed queries before hash-plus-query in each repetition; it does not claim balanced query-phase ordering.

The 14 rows are seven original implementations plus seven symmetric public singleton controls: native FastPattern/ByteSplit/FourSector/Split64 and external Fastbloom/Bloomsday/SBBF. Controls call the existing public singleton method only for length1 and preserve the original wrapper otherwise. Native controls remain native experiments, never external rivals. Split64/FourSector public scalar-source singleton paths can change generated kernels. SBBF retains its public trait-object dispatch. The explicit registry prevents classification by loose name matching.

All comparisons use exact actual-byte caps16/32 with **zero padding allowance** and FPR ceilings1%/0.1%/0.01%. Eligibility uses the upper endpoint of a pointwise two-sided95% Wilson interval (`z=1.959963984540054`) from independent calibration. Identical controls and batch repeats do not multiply sample counts: `quality.csv` must contain28 distinct family/size/seed calibrations. The four API tracks are:

- `original_only`: original native APIs against original external APIs.
- `original_native_vs_best_external`: original native APIs against either measured public path of each external implementation.
- `singleton_controls`: explicit singleton-control rows on both sides.
- `best_public_paths`: either public path on both sides, with native controls still labeled experiments.

`rankings.csv` and `summary.json` retain every track, each individual native configuration against the external leader, and every external family comparison, including no-qualifier cases and losses. `api-ratios.csv` preserves all original/control query and construction ratios. Ratios describe medians; query min/max ranges are not speed confidence intervals, and the pointwise FPR bounds are not simultaneous guarantees after selection. Seed42 is exploratory; any later confirmation requires a separate fresh-seed frozen protocol. No globally fastest claim follows from this screen.

The runner checks the full committed adapter SHA, its archive, the executable, native/shared-harness inputs, external package sources and this protocol before/after the matrix. Each case must emit exactly14 unique expected rows with correct workload fields, finite ordered timing ranges, actual allocation, independent calibration count, and identical family/control semantics. Partial or failed runs remain archived and cannot be summarized as a complete matrix.

CPU3/socket1 is reserved only after the preceding Ktest and BlowChoc work has explicitly released it. Do not run this command merely because the file exists:

```
flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 python3 experiments/2026-10-29-rust-sbbf-screen/run.py --source-commit FULL_40_HEX_COMMIT
python3 experiments/2026-10-29-rust-sbbf-screen/summarize.py
```

Run `python3 -m unittest discover -s experiments/2026-10-29-rust-sbbf-screen -p test_guard.py` during the leased validation window before the matrix. These synthetic guard tests consume no performance/calibration seeds. The runner refuses to reuse an existing output directory. `freeze.json` is the source freeze; `adapter-freeze.json` is a byte-for-byte copy of the adapter's earlier freeze. The complete adapter commit is in `protocol.json`.
