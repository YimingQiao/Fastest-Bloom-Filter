# FourSector range-capacity accuracy pilot

The candidate passes0.1% at16 bpk and0.01% at32 bpk on the two tested constructions. **It fails the proposed24-bpk/0.01% upper-endpoint gate at both sizes.** The retained Split64Range control passes that24-bpk gate. No throughput was measured and no production integration follows.

All six candidate cases and six controls were fixed before this run. Each uses seed42 and2^24 disjoint negatives; every inserted key is checked. The six unchanged Split64Range rows exactly reproduce the original pilot counts and checksums. Samples are not pooled.

| Keys | Actual bpk | Candidate FP /2^24 | Candidate Wilson upper (%) | Split64Range upper (%) | Candidate gate |
|---:|---:|---:|---:|---:|---|
| 65536 | 16 | 15723 | 0.09519203 | 0.09152148 | pass at 0.1% |
| 65536 | 24 | 1694 | 0.01058941 | 0.00980795 | fail at 0.01% |
| 65536 | 32 | 316 | 0.00210294 | 0.00211551 | pass at 0.01% |
| 33554432 | 16 | 16313 | 0.09873589 | 0.09185191 | pass at 0.1% |
| 33554432 | 24 | 1749 | 0.01092497 | 0.00958193 | fail at 0.01% |
| 33554432 | 32 | 329 | 0.00218465 | 0.00176253 | pass at 0.01% |

These are pointwise two-sided95% Wilson intervals. A failed upper-bound gate is not by itself proof that the true rate exceeds the target. The complete lower endpoints and estimates remain in quality.json. Neither this one seed nor the successful backend checks establish quality for other constructions.

The experiment keeps the old two-bit dictionary and cyclic mask codes, but changes the bitmap mapping. Its24-bit line address has finite resolution: at the large24-bpk geometry, each line receives10 or11 address codes. That nonuniformity and the shared mask bits were known before calibration; this pilot does not isolate their individual effect.

The counter interval is the earlier untimed q24 pilot interval, not the q22 performance-harness interval. No timed mixed-query sample or other construction is combined with it. One bitmap is alive at a time. The calibration executable contains no query timers.

[Raw output](results/results.stdout), [all intervals](results/quality.json), [run metadata](results/metadata.json), [compiled evidence](build-evidence-v1/metadata.json) and [six-backend correctness](../VALIDATION.md) are retained. Source isb4fb696730121b968535ae59a77fae3dc46f8601; the compiled freeze is6a3b666f9268ce3899bc6180f26097aad6e95e02. The complete run held the CPU2/socket0 exclusive lock, with CPU affinity only. A separate read-only check reconstructed all12 upper endpoints from the raw counts and verified every raw archive hash.

The primary24-bpk hypothesis is not supported under its fixed gate. Further geometry or mask experiments would require a separate protocol; this archive will remain unchanged.
