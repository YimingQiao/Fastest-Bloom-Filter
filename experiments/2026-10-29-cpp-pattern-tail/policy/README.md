# Separate entry and tail policy

This follow-up retains the original frozen snapshot and previous grouped-tail control. `FastPatternEntryTailBF` extends the public early scalar loop from at most 3 queries to at most 7, before SIMD setup and cache-size dispatch. It uses the masked 4–7 tail only when at least 16 queries have already been processed. Batches of 8–15 retain the original kernel, and insertion, dictionary, allocation, and full vector groups remain unchanged.

The policy was specified after the first C++ screen showed significant standalone 4–7 and large batch-15 regressions. It targets the observed batch-31 benefit without carrying those paths into production. This is a new candidate, not a revision of the retained failed variants. No production source is changed.

`protocol.json` records the decision and source hashes before timing. The same independent scalar/full-bitmap/output-boundary tests run under native, scalar, minimal AVX-512F+AVX2 without VL/DQ/BW, and ASan+UBSan. Both compilation and measurements hold `/tmp/fastest-bf-socket1.lock` for their entire stage and pin execution to CPU3.

```sh
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-cpp-pattern-tail/policy/validate.py
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-cpp-pattern-tail/policy/run.py \
  --mode speed --output experiments/2026-10-29-cpp-pattern-tail/policy/screen --cpu 3 \
  --key-powers 16,24 --requested-bpk 8,16 --seeds 42 --hits 50 \
  --batches 4,5,6,7,8,15,31,63,4096 --query-power 22 --calibration-power 0 --repeats 5
```

The initial screen has 36 workloads and three candidates in the same process. Ratios are **new/old latency**, so below 1 means faster. It is training evidence; any promotion requires fresh-seed confirmation and acceptable behavior in both prehashed and hash-plus-query measurements. Reserved ByteSplit confirmation seeds 2309/6311/10007 are excluded.

## Result: rejected

All 36 workloads / 108 rows have identical outputs, false-positive counts, and allocation, with no source changes during measurement. All native/scalar/minimal-feature/ASan+UBSan tests passed with checksum `14935109807921651589`. The new policy nevertheless worsens standalone 4–7-key latency: hash-plus-query becomes 1.134–1.417 times the original latency across the tested conditions. The public early return does not guarantee faster generated code. Large batch 15 returns near parity, but this does not compensate for the short-batch regressions. No fresh-seed promotion confirmation is justified for this candidate.

Ratios below are **new/old latency**, not speedups.

| Keys | Actual bits/key | Batch | Policy pure | Policy hash+query | Grouped pure | Grouped hash+query |
|---:|---:|---:|---:|---:|---:|---:|
| 65536 | 16 | 4 | 1.232 | 1.417 | 1.082 | 1.077 |
| 65536 | 16 | 5 | 1.205 | 1.339 | 1.089 | 1.059 |
| 65536 | 16 | 6 | 1.142 | 1.345 | 1.063 | 1.079 |
| 65536 | 16 | 7 | 1.114 | 1.135 | 1.050 | 1.004 |
| 65536 | 16 | 8 | 1.053 | 1.013 | 1.049 | 1.010 |
| 65536 | 16 | 15 | 1.050 | 1.018 | 0.827 | 0.920 |
| 65536 | 16 | 31 | 0.938 | 0.905 | 0.933 | 0.883 |
| 65536 | 16 | 63 | 0.958 | 0.988 | 0.958 | 0.975 |
| 65536 | 16 | 4096 | 1.066 | 0.993 | 0.979 | 0.984 |
| 65536 | 32 | 4 | 1.214 | 1.411 | 1.069 | 1.078 |
| 65536 | 32 | 5 | 1.198 | 1.336 | 1.086 | 1.062 |
| 65536 | 32 | 6 | 1.147 | 1.342 | 1.075 | 1.078 |
| 65536 | 32 | 7 | 1.115 | 1.134 | 1.048 | 1.008 |
| 65536 | 32 | 8 | 1.016 | 1.012 | 1.013 | 1.008 |
| 65536 | 32 | 15 | 1.038 | 1.018 | 0.828 | 0.895 |
| 65536 | 32 | 31 | 0.959 | 0.912 | 0.952 | 0.889 |
| 65536 | 32 | 63 | 0.974 | 0.987 | 0.960 | 0.973 |
| 65536 | 32 | 4096 | 1.003 | 0.998 | 0.998 | 1.007 |
| 16777216 | 16 | 4 | 1.387 | 1.390 | 1.001 | 1.020 |
| 16777216 | 16 | 5 | 1.302 | 1.295 | 1.003 | 0.987 |
| 16777216 | 16 | 6 | 1.322 | 1.319 | 1.025 | 1.087 |
| 16777216 | 16 | 7 | 1.278 | 1.232 | 1.008 | 1.053 |
| 16777216 | 16 | 8 | 0.949 | 0.997 | 1.003 | 0.998 |
| 16777216 | 16 | 15 | 1.027 | 0.999 | 0.922 | 1.081 |
| 16777216 | 16 | 31 | 0.984 | 1.005 | 0.995 | 1.000 |
| 16777216 | 16 | 63 | 0.980 | 0.987 | 0.981 | 0.984 |
| 16777216 | 16 | 4096 | 0.998 | 1.001 | 0.992 | 1.001 |
| 16777216 | 32 | 4 | 1.299 | 1.290 | 1.007 | 1.009 |
| 16777216 | 32 | 5 | 1.227 | 1.243 | 1.072 | 1.014 |
| 16777216 | 32 | 6 | 1.216 | 1.253 | 0.984 | 1.072 |
| 16777216 | 32 | 7 | 1.303 | 1.278 | 1.018 | 1.061 |
| 16777216 | 32 | 8 | 1.005 | 0.987 | 1.006 | 1.012 |
| 16777216 | 32 | 15 | 1.019 | 1.010 | 0.899 | 1.077 |
| 16777216 | 32 | 31 | 0.997 | 1.015 | 0.978 | 1.000 |
| 16777216 | 32 | 63 | 0.986 | 0.998 | 0.993 | 0.998 |
| 16777216 | 32 | 4096 | 1.013 | 1.007 | 1.011 | 1.000 |
