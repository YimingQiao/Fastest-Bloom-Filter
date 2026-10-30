# Native ByteSplit confirmation — 2026-10-29

This stage measures the production C++ and Rust implementations against external
filters under the [preregistered protocol](byte-split-confirmation-protocol-2026-10-29.md).
The C++ suite has **276 rows, 23 configurations × 12 cases**; Rust has **96 rows,
eight configurations × 12 cases**. Each language retains its own timing results.
The selected native leader may be any of the four public layouts; the frozen
Rust prototypes remain controls and are excluded from the external reference.

The native port does not win every single-key workload. C++ ByteSplit improves
small-filter prehashed query by 7–8%, but hash+query is within 0.5–0.9% of the
stronger FastFilter single-call control. Split64 leads the 0.1% FPR band in C++
hash+query by 1.10–1.20×; the selected native leaders lose the strict 0.01% band
and the large-filter 1% band in that metric. Rust retains small-filter losses
against Bloomsday despite some large-filter end-to-end gains. Those losses are
the next optimization targets, not omitted outliers.

Xeon Platinum 8474C, CPU 2, Clang 23/Rust 1.92 with native instructions; matrices run
serially. Sizes are 65K/32M keys, actual native allocations 16/32 bits per key,
50% hits, count 1 through the shared batch API, 2^22 queries and seven repetitions.
Whole-input insertion is independent of query batch size. Seeds 2309/6311/10007
were held out from implementation tuning. Query arrays are warmed and repeated.
This is throughput through that API, not serialized latency or a fused raw-key
single-query API. No new timing-stage output checks are inside the timers.

Each candidate has three disjoint 2^24-negative calibration streams, pooled to
50,331,648 probes. Eligibility requires a pointwise one-sided 95% Wilson upper FPR
bound below the cap and payload allocation at or below the memory ceiling, with
zero slack. Both tested allocations compete when eligible. Bounds are not
simultaneous winner-selection guarantees or per-insertion-set guarantees.

Tables use median-of-seed medians and retain the full range of paired-seed ratios
for the selected native/external configurations. Speedup is external/native;
values below one are native losses. Pure query and hash+query are separate
outcomes; a faster pure kernel need not improve end-to-end work by the same ratio.
Construction includes hashing/insertion, excludes bitmap allocation/zeroing,
and is reported separately. Allocation-inclusive construction is in the raw CSV.

The earlier ByteSplit prototype's approximately 8% end-to-end gain is not reused
as a production claim. Stronger FastFilter single-call controls are retained along
with original paths. The [same-process port check](../experiments/2026-10-29-native-byte-split/integration-report.md)
found native query time within roughly 1.2% of the frozen prototype, while small
construction cases regressed. Compiler/caller context and benchmark changes can
alter these close comparisons. Scoped wins and losses are both retained below.

## C++: Hash plus query

| Keys | Bits/key cap / FPR cap | Native leader | ns/key | External leader | ns/key | Speedup | Paired-seed range |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 / 1.00% | ByteSplitBloomFilter | 4.195 | FastFilterFixed16SingleV1 | 4.215 | 1.005× | 1.004–1.010× |
| 65,536 | 16 / 0.10% | Split64BloomFilter | 4.510 | FastFilterFixed64 | 5.412 | 1.200× | 1.199–1.202× |
| 65,536 | 32 / 0.10% | ByteSplitBloomFilter | 4.210 | FastFilterFixed16SingleV1 | 4.246 | 1.009× | 1.004–1.009× |
| 65,536 | 32 / 0.01% | Split64BloomFilter | 4.534 | FastFilterSimdBlockSingleV1 | 4.323 | 0.953× | 0.949–0.977× |
| 33,554,432 | 16 / 1.00% | ByteSplitBloomFilter | 11.554 | FastFilterSimdBlockSingleV1 | 11.165 | 0.966× | 0.941–0.972× |
| 33,554,432 | 16 / 0.10% | Split64BloomFilter | 11.704 | RocksDBFastLocalBloom64K8 | 12.837 | 1.097× | 1.091–1.122× |
| 33,554,432 | 32 / 0.10% | Split64BloomFilter | 11.704 | RocksDBFastLocalBloom64K8 | 12.837 | 1.097× | 1.091–1.122× |
| 33,554,432 | 32 / 0.01% | Split64BloomFilter | 18.896 | FastFilterSimdBlockSingleV1 | 18.745 | 0.992× | 0.986–0.997× |

## C++: Prehashed query

| Keys | Bits/key cap / FPR cap | Native leader | ns/key | External leader | ns/key | Speedup | Paired-seed range |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 / 1.00% | ByteSplitBloomFilter | 2.037 | FastFilterFixed16SingleV1 | 2.196 | 1.078× | 1.077–1.082× |
| 65,536 | 16 / 0.10% | Split64BloomFilter | 2.638 | Boost192Multi64K8 | 3.232 | 1.225× | 1.223–1.229× |
| 65,536 | 32 / 0.10% | ByteSplitBloomFilter | 2.084 | FastFilterFixed16SingleV1 | 2.235 | 1.073× | 1.070–1.075× |
| 65,536 | 32 / 0.01% | Split64BloomFilter | 2.648 | FastFilterSimdBlockSingleV1 | 2.383 | 0.900× | 0.894–0.902× |
| 33,554,432 | 16 / 1.00% | Split64BloomFilter | 7.350 | FastFilterSimdBlock | 7.402 | 1.007× | 1.007–1.043× |
| 33,554,432 | 16 / 0.10% | Split64BloomFilter | 7.350 | RocksDBFastLocalBloom64K8 | 8.452 | 1.150× | 1.150–1.195× |
| 33,554,432 | 32 / 0.10% | Split64BloomFilter | 7.350 | RocksDBFastLocalBloom64K8 | 8.452 | 1.150× | 1.150–1.195× |
| 33,554,432 | 32 / 0.01% | Split64BloomFilter | 11.330 | FastFilterSimdBlockSingleV1 | 12.413 | 1.096× | 1.093–1.096× |

## C++: Hash plus construction

| Keys | Bits/key cap / FPR cap | Native leader | ns/key | External leader | ns/key | Speedup | Paired-seed range |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 / 1.00% | ByteSplitBloomFilter | 1.427 | FastFilterFixed16 | 1.436 | 1.006× | 0.977–1.029× |
| 65,536 | 16 / 0.10% | Split64BloomFilter | 1.990 | Boost192Multi64K8 | 2.304 | 1.157× | 1.137–1.179× |
| 65,536 | 32 / 0.10% | ByteSplitBloomFilter | 1.591 | FastFilterFixed16 | 1.617 | 1.016× | 1.001–1.017× |
| 65,536 | 32 / 0.01% | Split64BloomFilter | 1.977 | FastFilterSimdBlock | 1.748 | 0.884× | 0.882–0.886× |
| 33,554,432 | 16 / 1.00% | FastPatternBF | 5.323 | Boost192Multi32K8 | 5.561 | 1.045× | 1.045–1.046× |
| 33,554,432 | 16 / 0.10% | Split64BloomFilter | 5.385 | Boost192Multi64K8 | 5.679 | 1.055× | 1.051–1.055× |
| 33,554,432 | 32 / 0.10% | Split64BloomFilter | 5.385 | Boost192Multi64K8 | 5.679 | 1.055× | 1.051–1.055× |
| 33,554,432 | 32 / 0.01% | Split64BloomFilter | 6.750 | Boost192Multi32K8 | 6.883 | 1.020× | 1.018–1.025× |

## Rust: Hash plus query

| Keys | Bits/key cap / FPR cap | Native leader | ns/key | External leader | ns/key | Speedup | Paired-seed range |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 / 1.00% | ByteSplitBloomFilter | 6.174 | BloomsdayPinned | 5.953 | 0.964× | 0.963–0.966× |
| 65,536 | 16 / 0.10% | Split64BloomFilter | 6.512 | Fastbloom017 | 21.450 | 3.294× | 3.290–3.301× |
| 65,536 | 32 / 0.10% | ByteSplitBloomFilter | 6.174 | BloomsdayPinned | 5.971 | 0.967× | 0.967–0.968× |
| 65,536 | 32 / 0.01% | Split64BloomFilter | 6.520 | BloomsdayPinned | 5.971 | 0.916× | 0.916–0.916× |
| 33,554,432 | 16 / 1.00% | ByteSplitBloomFilter | 13.638 | BloomsdayPinned | 15.097 | 1.107× | 1.090–1.127× |
| 33,554,432 | 16 / 0.10% | Split64BloomFilter | 14.308 | Fastbloom017 | 46.574 | 3.255× | 3.218–3.290× |
| 33,554,432 | 32 / 0.10% | Split64BloomFilter | 14.308 | BloomsdayPinned | 25.472 | 1.780× | 1.763–1.817× |
| 33,554,432 | 32 / 0.01% | Split64BloomFilter | 23.209 | BloomsdayPinned | 25.472 | 1.098× | 1.092–1.114× |

## Rust: Prehashed query

| Keys | Bits/key cap / FPR cap | Native leader | ns/key | External leader | ns/key | Speedup | Paired-seed range |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 / 1.00% | ByteSplitBloomFilter | 3.647 | BloomsdayPinned | 3.272 | 0.897× | 0.895–0.897× |
| 65,536 | 16 / 0.10% | Split64BloomFilter | 4.079 | Fastbloom017 | 16.166 | 3.963× | 3.960–3.964× |
| 65,536 | 32 / 0.10% | ByteSplitBloomFilter | 3.651 | BloomsdayPinned | 3.266 | 0.894× | 0.892–0.902× |
| 65,536 | 32 / 0.01% | Split64BloomFilter | 4.083 | BloomsdayPinned | 3.266 | 0.800× | 0.798–0.805× |
| 33,554,432 | 16 / 1.00% | ByteSplitBloomFilter | 8.574 | BloomsdayPinned | 8.251 | 0.962× | 0.958–0.981× |
| 33,554,432 | 16 / 0.10% | Split64BloomFilter | 9.191 | Fastbloom017 | 40.927 | 4.453× | 4.308–4.509× |
| 33,554,432 | 32 / 0.10% | Split64BloomFilter | 9.191 | BloomsdayPinned | 14.707 | 1.600× | 1.547–1.641× |
| 33,554,432 | 32 / 0.01% | Split64BloomFilter | 16.075 | BloomsdayPinned | 14.707 | 0.915× | 0.910–0.924× |

## Rust: Hash plus construction

| Keys | Bits/key cap / FPR cap | Native leader | ns/key | External leader | ns/key | Speedup | Paired-seed range |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 / 1.00% | ByteSplitBloomFilter | 1.389 | BloomsdayPinned | 1.688 | 1.215× | 1.213–1.243× |
| 65,536 | 16 / 0.10% | Split64BloomFilter | 2.255 | Fastbloom017 | 11.544 | 5.120× | 5.085–5.122× |
| 65,536 | 32 / 0.10% | ByteSplitBloomFilter | 1.569 | BloomsdayPinned | 1.725 | 1.099× | 1.096–1.137× |
| 65,536 | 32 / 0.01% | FastPatternBF | 2.040 | BloomsdayPinned | 1.725 | 0.846× | 0.805–0.878× |
| 33,554,432 | 16 / 1.00% | Split64BloomFilter | 5.547 | BloomsdayPinned | 5.977 | 1.078× | 1.078–1.079× |
| 33,554,432 | 16 / 0.10% | Split64BloomFilter | 5.547 | Fastbloom017 | 41.689 | 7.516× | 7.511–7.524× |
| 33,554,432 | 32 / 0.10% | Split64BloomFilter | 5.547 | BloomsdayPinned | 7.995 | 1.441× | 1.440–1.447× |
| 33,554,432 | 32 / 0.01% | Split64BloomFilter | 6.966 | BloomsdayPinned | 7.995 | 1.148× | 1.129–1.153× |

Rust has two external families; large Rust-only speedups do not imply equivalent
wins against the broader C++ baseline set. PageBloom's optional AES mode and the
full 56-configuration combined suite are outside this 23-candidate C++ shortlist.
Short batches, hit-rate extremes and multithreaded performance are separate
screens. No finite suite proves an unrestricted fastest Bloom filter.

Both executables were built from sources committed in `c4b6a08`. The C++ launch
mistakenly supplied the preceding commit as a metadata flag; the correction keeps
that original flag and records the source/binary digest evidence. The executable
was never rebuilt during timing. See its provenance-correction.json.

[C++ raw data and rankings](../results/2026-10-29-byte-confirmation-cpp/),
[Rust raw data and rankings](../results/2026-10-29-byte-confirmation-rust/),
[complete validation](../experiments/2026-10-29-byte-integration-checks.json).
Regenerate with `python3 scripts/summarize_byte_confirmation.py`.
