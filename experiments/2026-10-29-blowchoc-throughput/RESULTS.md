# BlowChoc whole-array query-speed training screen

All 48 prespecified rows and 32 actual-size bitmap/factory-overwrite preflights passed. All inserted keys and complete dense query outputs were checked. This is input42/construction113 training data, with six repetitions per mode. It is not a held-out performance claim.

The four native controls use the unchanged bridge snapshot `b437791`; the external set contains all eight unmodified BlowChoc parameter choices. This is a comparison within that 12-configuration grid, not all repository baselines or exact intermediate budgets. Build throughput was not measured; CSV build columns are NaN.

Each comparison below selects the fastest measured native and external under the actual backing-allocation cap and nominal per-row Wilson95% FPR upper bound. A 32 bits/key cap also admits the 16 bits/key rows. The calibration stream has 16,777,216 negatives per row; repeated streams and different construction functions are never pooled. These are per-case intervals, not simultaneous coverage for the selected winner. Positions scratch of 16/28B and common hash scratch of 32KiB are disclosed separately from the bitmap cap.

Ratios are external ns/key divided by native ns/key: above 1 favors native. All three contracts are independent. Trial minima/maxima in `timings.csv` describe within-run spread, not paired-seed uncertainty.

## prehashed

| Keys | Cap | FPR limit | Native (actual bpk) | ns/key | BlowChoc (actual bpk) | ns/key | Ratio |
|---|---:|---:|---|---:|---|---:|---:|
| 64K | 16 | 1% | ByteSplitBloomFilter (16) | 1.034 | BlowChocC1K8Random (16) | 20.237 | 19.577× |
| 64K | 16 | 0.1% | Split64BloomFilter (16) | 1.488 | BlowChocC1K8Random (16) | 20.237 | 13.596× |
| 64K | 16 | 0.01% | ineligible | — | ineligible | — | — |
| 64K | 32 | 1% | ByteSplitBloomFilter (16) | 1.034 | BlowChocC1K8Random (16) | 20.237 | 19.577× |
| 64K | 32 | 0.1% | ByteSplitBloomFilter (32) | 1.044 | BlowChocC1K8Random (16) | 20.237 | 19.384× |
| 64K | 32 | 0.01% | Split64BloomFilter (32) | 1.497 | BlowChocC1K8Random (32) | 20.519 | 13.711× |
| 32M | 16 | 1% | ByteSplitBloomFilter (16) | 5.985 | BlowChocC1K8Random (16) | 61.993 | 10.358× |
| 32M | 16 | 0.1% | Split64BloomFilter (16) | 6.802 | BlowChocC1K8Random (16) | 61.993 | 9.115× |
| 32M | 16 | 0.01% | ineligible | — | ineligible | — | — |
| 32M | 32 | 1% | ByteSplitBloomFilter (16) | 5.985 | BlowChocC1K8Random (16) | 61.993 | 10.358× |
| 32M | 32 | 0.1% | Split64BloomFilter (16) | 6.802 | BlowChocC1K8Random (16) | 61.993 | 9.115× |
| 32M | 32 | 0.01% | Split64BloomFilter (32) | 8.054 | BlowChocC1K8Random (32) | 72.184 | 8.962× |

Native is faster in 10/10 comparable tier/cap cases; external is faster in 0/10, with 0 exact ties. These cases share filters/streams and are not independent statistical trials.

## common-fused

| Keys | Cap | FPR limit | Native (actual bpk) | ns/key | BlowChoc (actual bpk) | ns/key | Ratio |
|---|---:|---:|---|---:|---|---:|---:|
| 64K | 16 | 1% | ByteSplitBloomFilter (16) | 1.632 | BlowChocC1K8Random (16) | 23.890 | 14.636× |
| 64K | 16 | 0.1% | Split64BloomFilter (16) | 1.897 | BlowChocC1K8Random (16) | 23.890 | 12.593× |
| 64K | 16 | 0.01% | ineligible | — | ineligible | — | — |
| 64K | 32 | 1% | ByteSplitBloomFilter (16) | 1.632 | BlowChocC1K8Random (16) | 23.890 | 14.636× |
| 64K | 32 | 0.1% | ByteSplitBloomFilter (32) | 1.661 | BlowChocC1K8Random (16) | 23.890 | 14.381× |
| 64K | 32 | 0.01% | Split64BloomFilter (32) | 1.923 | BlowChocC1K8Random (32) | 24.099 | 12.535× |
| 32M | 16 | 1% | ByteSplitBloomFilter (16) | 7.819 | BlowChocC1K8Random (16) | 65.445 | 8.370× |
| 32M | 16 | 0.1% | Split64BloomFilter (16) | 7.868 | BlowChocC1K8Random (16) | 65.445 | 8.318× |
| 32M | 16 | 0.01% | ineligible | — | ineligible | — | — |
| 32M | 32 | 1% | ByteSplitBloomFilter (16) | 7.819 | BlowChocC1K8Random (16) | 65.445 | 8.370× |
| 32M | 32 | 0.1% | Split64BloomFilter (16) | 7.868 | BlowChocC1K8Random (16) | 65.445 | 8.318× |
| 32M | 32 | 0.01% | Split64BloomFilter (32) | 9.827 | BlowChocC1K8Random (32) | 75.650 | 7.698× |

Native is faster in 10/10 comparable tier/cap cases; external is faster in 0/10, with 0 exact ties. These cases share filters/streams and are not independent statistical trials.

## common-staged

| Keys | Cap | FPR limit | Native (actual bpk) | ns/key | BlowChoc (actual bpk) | ns/key | Ratio |
|---|---:|---:|---|---:|---|---:|---:|
| 64K | 16 | 1% | ByteSplitBloomFilter (16) | 1.449 | BlowChocC1K8Random (16) | 19.893 | 13.727× |
| 64K | 16 | 0.1% | Split64BloomFilter (16) | 1.926 | BlowChocC1K8Random (16) | 19.893 | 10.329× |
| 64K | 16 | 0.01% | ineligible | — | ineligible | — | — |
| 64K | 32 | 1% | ByteSplitBloomFilter (32) | 1.442 | BlowChocC1K8Random (16) | 19.893 | 13.791× |
| 64K | 32 | 0.1% | ByteSplitBloomFilter (32) | 1.442 | BlowChocC1K8Random (16) | 19.893 | 13.791× |
| 64K | 32 | 0.01% | Split64BloomFilter (32) | 1.911 | BlowChocC1K8Random (32) | 20.147 | 10.544× |
| 32M | 16 | 1% | ByteSplitBloomFilter (16) | 5.355 | BlowChocC1K8Random (16) | 61.452 | 11.475× |
| 32M | 16 | 0.1% | Split64BloomFilter (16) | 5.535 | BlowChocC1K8Random (16) | 61.452 | 11.103× |
| 32M | 16 | 0.01% | ineligible | — | ineligible | — | — |
| 32M | 32 | 1% | ByteSplitBloomFilter (16) | 5.355 | BlowChocC1K8Random (16) | 61.452 | 11.475× |
| 32M | 32 | 0.1% | Split64BloomFilter (16) | 5.535 | BlowChocC1K8Random (16) | 61.452 | 11.103× |
| 32M | 32 | 0.01% | Split64BloomFilter (32) | 7.013 | BlowChocC1K8Random (32) | 71.498 | 10.195× |

Native is faster in 10/10 comparable tier/cap cases; external is faster in 0/10, with 0 exact ties. These cases share filters/streams and are not independent statistical trials.

The full matrix held the socket1 lock on CPU3 for 761.1s including compilation, construction, validation and calibration. That wall time is not filter throughput. CPU affinity was fixed; explicit NUMA memory binding was not imposed. Source commit `e0690ef6f659e1c96478c170303e365790a9e644`, frozen native library and runtime hashes passed before/after checks.

`accuracy.csv` retains all 48 quality/allocation rows; `timings.csv` retains 144 mode rows including every configuration's losses; `comparisons.csv` retains the 36 cap/FPR/mode selections. Full raw trial timings, checksums, construction hashes and input digests remain in `results/`.
