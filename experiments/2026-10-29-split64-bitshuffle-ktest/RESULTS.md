# Reject the BITALG/KTEST replacement

The complete 24-case/144-row CPU3 Clang screen did not justify replacing original
Split64. HybridKtest has candidate/original latency geometric means **1.0175**
for pure lookup and **1.0160** for hash+lookup: higher is slower. It loses 22/24
pure cases and 17/24 raw cases. Its worst regressions are 7.24% pure (64K keys,
32 actual bits/key, batch 1) and 10.13% raw (64K keys,16 actual bits/key, batch 31).
The best paired gain is only about 2.45% in both metrics at 32M keys,16 bits/key,
batch 3. These are descriptive seed42 results, not confidence bounds.

The earlier V1 hybrid, narrow and wide variants regress roughly 6–8.5% in their
aggregate query metrics. KTEST therefore repairs much of V1's extra reduction
cost, but the original remains the appropriate production kernel. No fresh-seed
performance confirmation or Rust/production port was undertaken.

[The full report](timing-full/README.md) includes every case and all four candidate
policies for both metrics. All 172 positive-regression metric rows remain in
`timing-full/losses.csv`; complete raw data, ranges, commands, source/binary hashes
and individual extrema remain archived. Every Split64 row matches original
bytes, checksum and FP counts; all 24 filter/size/allocation groups match those
fields across the six batch sizes. The preflight oracle and sanitizer evidence
remain unchanged. `preflight-record/` preserves the pre-timing README/manifest.
