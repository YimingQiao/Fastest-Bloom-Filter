# Word16 GCC training result: retain unpromoted

All 12 workloads/108 rows completed with frozen source/binary hashes. The 36
filter/size/allocation groups have identical checksum, bytes, FP and calibration
counts across batches 1/31/4096. This is one training seed, 50% hits, CPU3 and GCC.
No timing is compared across sockets, compilers or API tracks.

At 32 actual bits/key and a 0.01% ceiling, the small batch31 raw path is promising:
5.7% lower latency than the fastest eligible external in this panel and 23.0%
lower than its best eligible native control. Pure lookup is 20.2% slower than
FastPattern there. Large-table results are near parity with external baselines,
with several regressions; native FastPattern is substantially faster for bulk
queries. Single-key raw lookup has no meaningful lead. At 16 bits/key/1%, there
is no consistent advantage over the existing native layouts.

**No promotion.** FourSector and much of the modern external panel are absent.
Before fresh-seed performance confirmation, use a separate Clang build with the
stronger native/external set. No Rust port is justified by this screen alone.

The table pools every measured allocation within the memory ceiling and applies
the per-row cal24 quality bound. `new/external` and `new/native` are latency ratios;
lower is faster. Native controls here mean FastPattern, ByteSplit and Split64.

| Keys | Memory cap | FPR cap | Batch | Metric | Word16 ns | Best external | External ns | New/external | Best native | New/native |
|---:|---:|---:|---:|---|---:|---|---:|---:|---|---:|
| 65,536 | 16 | 1.00% | 1 | pure | 2.280 | FastFilterFixed16SingleV1 | 2.157 | 1.057 | ByteSplitBloomFilter | 1.173 |
| 65,536 | 16 | 1.00% | 1 | hash+query | 3.897 | FastFilterSimdBlockSingleV1 | 3.878 | 1.005 | ByteSplitBloomFilter | 1.051 |
| 65,536 | 16 | 1.00% | 31 | pure | 1.233 | FastFilterSimdBlock | 1.346 | 0.916 | FastPatternBF | 1.239 |
| 65,536 | 16 | 1.00% | 31 | hash+query | 1.757 | FastFilterFixed16SingleV1 | 1.760 | 0.998 | ByteSplitBloomFilter | 1.045 |
| 65,536 | 16 | 1.00% | 4096 | pure | 1.243 | FastFilterSimdBlock | 1.308 | 0.950 | FastPatternBF | 1.814 |
| 65,536 | 16 | 1.00% | 4096 | hash+query | 1.764 | FastFilterSimdBlock | 1.853 | 0.952 | FastPatternBF | 1.501 |
| 33,554,432 | 16 | 1.00% | 1 | pure | 7.288 | FastFilterSimdBlockSingleV1 | 7.312 | 0.997 | ByteSplitBloomFilter | 0.991 |
| 33,554,432 | 16 | 1.00% | 1 | hash+query | 10.243 | FastFilterSimdBlock | 10.424 | 0.983 | ByteSplitBloomFilter | 1.003 |
| 33,554,432 | 16 | 1.00% | 31 | pure | 5.710 | FastFilterFixed32 | 5.637 | 1.013 | FastPatternBF | 1.142 |
| 33,554,432 | 16 | 1.00% | 31 | hash+query | 5.841 | FastFilterFixed16 | 5.780 | 1.011 | ByteSplitBloomFilter | 1.005 |
| 33,554,432 | 16 | 1.00% | 4096 | pure | 5.823 | FastFilterFixed16SingleV1 | 5.638 | 1.033 | FastPatternBF | 1.432 |
| 33,554,432 | 16 | 1.00% | 4096 | hash+query | 4.933 | FastFilterSimdBlock | 4.865 | 1.014 | FastPatternBF | 1.193 |
| 65,536 | 32 | 0.01% | 1 | pure | 2.284 | FastFilterSimdBlockSingleV1 | 2.352 | 0.971 | Split64BloomFilter | 0.926 |
| 65,536 | 32 | 0.01% | 1 | hash+query | 3.932 | FastFilterSimdBlockSingleV1 | 3.893 | 1.010 | Split64BloomFilter | 0.999 |
| 65,536 | 32 | 0.01% | 31 | pure | 1.253 | FastFilterSimdBlock | 1.350 | 0.928 | FastPatternBF | 1.202 |
| 65,536 | 32 | 0.01% | 31 | hash+query | 1.783 | FastFilterSimdBlockSingleV1 | 1.890 | 0.943 | FastPatternBF | 0.770 |
| 65,536 | 32 | 0.01% | 4096 | pure | 1.252 | FastFilterSimdBlock | 1.312 | 0.954 | FastPatternBF | 1.676 |
| 65,536 | 32 | 0.01% | 4096 | hash+query | 1.775 | FastFilterSimdBlock | 1.854 | 0.957 | FastPatternBF | 1.454 |
| 33,554,432 | 32 | 0.01% | 1 | pure | 12.462 | FastFilterSimdBlockSingleV1 | 11.933 | 1.044 | Split64BloomFilter | 1.092 |
| 33,554,432 | 32 | 0.01% | 1 | hash+query | 17.196 | FastFilterSimdBlockSingleV1 | 17.161 | 1.002 | Split64BloomFilter | 1.013 |
| 33,554,432 | 32 | 0.01% | 31 | pure | 8.109 | FastFilterFixed32 | 7.981 | 1.016 | FastPatternBF | 1.197 |
| 33,554,432 | 32 | 0.01% | 31 | hash+query | 8.085 | FastFilterSimdBlock | 8.146 | 0.992 | Split64BloomFilter | 0.998 |
| 33,554,432 | 32 | 0.01% | 4096 | pure | 7.888 | FastFilterFixed32 | 7.833 | 1.007 | FastPatternBF | 1.376 |
| 33,554,432 | 32 | 0.01% | 4096 | hash+query | 7.320 | FastFilterSimdBlock | 7.208 | 1.016 | FastPatternBF | 1.267 |

The complete 108 raw rows, every filter's calibration counts, protocol, commands,
and source/binary hashes remain alongside this report. `summary.json` retains
all three FPR ceilings for each requested-allocation cohort; this report's focus
tiers additionally pool cheaper measured allocations under the memory ceiling.
No rows or slower outcomes were removed.
