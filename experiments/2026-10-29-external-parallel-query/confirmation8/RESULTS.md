# Eight-core confirmation results

All 12 prespecified cases completed: 276 rows, 23 configurations, fresh seeds19867/45631/93187 and five repeats. The matrix took 958 seconds under one socket1 lock. Framework source and executable hashes are unchanged. **This confirmation covers eight physical cores and batch4096 only; T1/T4 remain screening results.**

Quality was recomputed from the new data: 276 distinct seed streams become 92 exact filter/allocation configurations, each with 50,331,648 negatives. No seed42 observations were included. The three raw calibration intervals are pairwise disjoint for each n. Eligibility uses the pooled Wilson95 upper, and every selected native/external portfolio pair also passes the target in each individual seed.

Tables show external/native speedup: the aggregate ratio of the medians of three seed medians, followed by the paired-seed range in brackets. Each chosen native/external configuration is fixed across the three seeds. Both measured allocations compete under each actual-byte cap. All measured qualified portfolio cells favor native on every seed; no configuration on either side qualifies for the 16-bpk/0.01% cell. This statement concerns this fixed shortlist and workload grid, not all Bloom filters or hardware.

## Pure prehashed query, gated

| Inserted keys | Cap16 / FPR≤1% | Cap16 / FPR≤0.1% | Cap32 / FPR≤0.1% | Cap32 / FPR≤0.01% |
|---:|---:|---:|---:|---:|
| 65536 | 1.626x [1.626, 1.652] | 2.022x [2.019, 2.056] | 1.507x [1.483, 1.546] | 1.680x [1.672, 1.724] |
| 33554432 | 1.157x [1.157, 1.173] | 1.232x [1.232, 1.248] | 1.232x [1.232, 1.248] | 1.097x [1.083, 1.103] |

The conservative check against the fastest pooled-quality-eligible external separately in each seed remains above 1.083x across these cells. Rival names, allocations and quality bounds for every seed are retained in `results/paired-seed-comparison.csv`.

## Hashing plus query, gated

| Inserted keys | Cap16 / FPR≤1% | Cap16 / FPR≤0.1% | Cap32 / FPR≤0.1% | Cap32 / FPR≤0.01% |
|---:|---:|---:|---:|---:|
| 65536 | 1.474x [1.465, 1.494] | 1.696x [1.625, 1.712] | 1.422x [1.384, 1.439] | 1.422x [1.384, 1.439] |
| 33554432 | 1.104x [1.079, 1.133] | 1.150x [1.123, 1.189] | 1.150x [1.123, 1.189] | 1.068x [1.061, 1.068] |

The conservative check against the fastest pooled-quality-eligible external separately in each seed remains above 1.061x across these cells. Rival names, allocations and quality bounds for every seed are retained in `results/paired-seed-comparison.csv`.

## Pure prehashed query, fresh-thread end-to-end

| Inserted keys | Cap16 / FPR≤1% | Cap16 / FPR≤0.1% | Cap32 / FPR≤0.1% | Cap32 / FPR≤0.01% |
|---:|---:|---:|---:|---:|
| 65536 | 1.383x [1.378, 1.408] | 1.746x [1.716, 1.753] | 1.340x [1.321, 1.343] | 1.440x [1.434, 1.441] |
| 33554432 | 1.144x [1.144, 1.157] | 1.221x [1.215, 1.230] | 1.221x [1.215, 1.230] | 1.088x [1.075, 1.095] |

The conservative check against the fastest pooled-quality-eligible external separately in each seed remains above 1.075x across these cells. Rival names, allocations and quality bounds for every seed are retained in `results/paired-seed-comparison.csv`.

## Hashing plus query, fresh-thread end-to-end

| Inserted keys | Cap16 / FPR≤1% | Cap16 / FPR≤0.1% | Cap32 / FPR≤0.1% | Cap32 / FPR≤0.01% |
|---:|---:|---:|---:|---:|
| 65536 | 1.380x [1.354, 1.384] | 1.553x [1.525, 1.589] | 1.323x [1.306, 1.344] | 1.323x [1.306, 1.344] |
| 33554432 | 1.096x [1.071, 1.118] | 1.147x [1.114, 1.170] | 1.147x [1.114, 1.170] | 1.064x [1.060, 1.064] |

The conservative check against the fastest pooled-quality-eligible external separately in each seed remains above 1.060x across these cells. Rival names, allocations and quality bounds for every seed are retained in `results/paired-seed-comparison.csv`.

## Winners and quality changes

Hash-gated selected configurations:

| Inserted keys | Byte cap / FPR target | Native (actual bpk) | External (actual bpk) | Native pooled FPR upper |
|---:|---|---|---|---:|
| 65536 | 16 bpk / 1% | FastPatternBF (16.000) | FastFilterSimdBlockSingleV1 (16.000) | 0.002044242 |
| 65536 | 16 bpk / 0.1% | FourSectorBloomFilter (16.000) | FastFilterFixed64 (16.000) | 0.000981917 |
| 65536 | 32 bpk / 0.1% | FastPatternBF (32.000) | FastFilterSimdBlock (32.000) | 0.000094355 |
| 65536 | 32 bpk / 0.01% | FastPatternBF (32.000) | FastFilterSimdBlock (32.000) | 0.000094355 |
| 33554432 | 16 bpk / 1% | FastPatternBF (16.000) | Boost192Multi32K8 (16.000) | 0.002041850 |
| 33554432 | 16 bpk / 0.1% | FourSectorBloomFilter (16.000) | Boost192Multi64K8 (16.000) | 0.000985749 |
| 33554432 | 32 bpk / 0.1% | FourSectorBloomFilter (16.000) | Boost192Multi64K8 (16.000) | 0.000985749 |
| 33554432 | 32 bpk / 0.01% | FastPatternBF (32.000) | Boost192Multi32K8 (32.000) | 0.000094134 |

Fresh quality qualification changes the portfolio without changing any code. Small FastPattern32 now has 4,614/50,331,648 positives, pooled upper0.00009435537413 and worst-seed upper0.00009771305056, so it qualifies for 0.01%. Its seed42 screen upper0.0001005223683 remains recorded as a failure in the earlier archive. Large FourSector16 now has 49,178 positives, pooled upper0.0009857486214 and worst-seed upper0.0009957072985, so it qualifies for 0.1% and replaces Split64 as the selected native in that tier. Its earlier seed42 upper0.0010023738005 also remains recorded.

## Individual native losses

- Large ByteSplit16 at the loose 1% tier loses to Boost Multi32K8: hash-gated paired ratios0.935–0.954x.
- Small Split64 at the loose 1% tier loses to the strongest SimdBlock single control: hash-gated paired ratios0.802–0.820x.
- Small ByteSplit16 is near parity rather than a strong batch4096 win: hash-gated ratios1.001–1.030x against the selected external.

These are separate from choosing the best member of the native portfolio. `qualified-family-comparison.csv` and the complete JSON preserve all per-family wins, losses, ineligible cells and conservative rival checks.

## Same-row serial controls

Each ratio below uses the direct serial-loop column from the same T8 row and seed. No T1 timing from the initial screen is reused. Ranges cover the fixed native filter/allocation configurations, rather than comparing a parallel native row with an external serial row.

| Mode | Range of three-seed median serial/parallel ratios | Range of individual seed ratios |
|---|---:|---:|
| Pure prehashed query, gated | 7.410–7.896x | 7.378–8.164x |
| Hashing plus query, gated | 6.964–8.114x | 6.932–8.225x |
| Pure prehashed query, fresh-thread end-to-end | 4.675–7.309x | 4.642–7.567x |
| Hashing plus query, fresh-thread end-to-end | 5.726–7.529x | 5.709–7.573x |

The gated interval includes common start/completion synchronization; end-to-end additionally includes creating T−1 threads, pinning and cleanup. Ratios slightly above eight are observed elapsed-time ratios, not proof of algorithmic superlinear scaling. Construction remains serial and is reported separately.

Eleven analysis regression tests pass. Independent review identified and fixed a malformed raw-only-row guard in the confirmation analysis: every raw seed and scalar summary field must retain NaN for pure query. The frozen benchmark and measured data were unchanged. All raw trial decompositions, complete outputs, calibration counts, expected seeds and source/executable hashes validate. Sample ranges do not overlap for the selected pairs, but no formal speed-significance test or global-fastest claim is made.

Artifacts: `results/results.csv`, `results/metadata.json`, `results/summary.json`, `results/qualified-comparison.csv`, `results/qualified-family-comparison.csv`, `results/paired-seed-comparison.csv`, and `results/serial-ratios.csv`.
