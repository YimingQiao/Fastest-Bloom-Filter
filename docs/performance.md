# Query performance · batch4096

Every result on this page uses batches of 4096 and reports query time in **ns/key**. Lower is faster. All panels use 50% mixed-query hits and 4,194,304 queries per timed pass. The two filter sizes contain 65,536 and 33,554,432 inserted keys.

## Machine and timing contracts

Intel Xeon Platinum 8474C, two sockets with 48 physical cores per socket and 97.5 MiB LLC per socket, Linux 6.1.0-45-amd64. C++ used Clang 23 native builds; Rust used rustc 1.92 native release builds. AVX-512 was available. Single-thread runs were pinned to a physical core; the parallel executor used eight physical cores on socket 0. These are the historical binaries actually measured, not a new timing run of the release package.

| Panel | Timing samples | Construction seeds | Calibration negatives per construction | Context |
| :--- | ---: | :--- | ---: | :--- |
| CPP988 | 6 | One seen seed (42) | 2^24 | Broad capacity screen, CPU 2 |
| CPP_K12_primary24 | 6 | Three fresh confirmation seeds | 2^26 | Fixed five-API strict24 shortlist, CPU 3 |
| Rust786 | 8 | One seen seed (42) | 2^24 | Raw public APIs, CPU 2 / NUMA 0 |
| CPP_MT195 | 6 | Three seen seeds | 2^26 | Shared executor, eight physical cores / NUMA 0 |

A one-seed value is the original median. Three-seed summaries are the **geometric mean of the three per-seed medians**. Seed-level medians remain in the JSON. The tables are descriptive rankings of the measured data, without a timing significance test. Panels have different callers, selection histories and builds; do not combine them into a cross-language or cross-panel speed ratio.

Prehashed queries consume caller-prepared 64-bit hashes. Common-hash-plus-query includes the common hash within each batch. Rust raw public APIs include their required hashing; direct byte APIs receive the original key encoded as eight little-endian bytes. A native API that requires hashes pays the common hash cost. The Rust whole-array visible-loop metric is excluded because it is a different API contract.

The eight-core panel reports wall-clock time per total queried key and includes fresh thread creation/join for each whole pass. Workers issue 4096-key calls to each API. This common executor is separate from the native parallel-wrapper timings. Rust parallel APIs are available, but this page makes no Rust multithread performance claim.

The large-table common-hash result can be faster than its prehashed result. They are separately timed kernels with different work and memory schedules; subtracting these measurements does not isolate hashing cost.

## Admission and scope

Each candidate must fit the **actual bitmap byte ceiling** and pass its construction-specific two-sided 95% Wilson upper bound at the FPR ceiling. All three constructions must pass in multi-seed panels. Calibration keys are disjoint from inserted and timed-query key domains. Aliased mappings do not add independent samples. The intervals are pointwise and finite-sample; requested bits/key and probe count are not FPR guarantees. Caller buffers, hash workspace, allocator metadata and thread stacks are separate from the bitmap cap.

Top three means three public API methods, each at its fastest qualifying measured allocation. API variants remain separate even if they share a bitmap mapping. Thus some rows use fewer bits than the cap. The CSV/JSON retain every qualifying allocation. Quality failures and unavailable API contracts remain in the linked original evidence; they are not assigned zero latency or counted as wins.

The strict24 confirmation tests a prespecified shortlist from an earlier screen, not every possible external implementation. It includes K12, Range, FastFilter Fixed64, Boost Multi64 K8, and RocksDB FastLocalBloom64 K8 Batch32. All five pass at both sizes. K12's worst three-seed FPR upper endpoints are 0.00929051% (small) and 0.00952436% (large). Rust also measures Fastbloom, fastbloom-rs, and Bloomsday configurations; its one-seed results are a screen, not independent confirmation.

Display names FourSectorRange12 and Split64Range shorten the original method identifiers. JSON/CSV preserve those identifiers, including experimental names in historical binaries. The release promotes their tested native kernels; it does not claim every historical adapter or experimental layout is a shipping API.

## Top three by condition

Relative throughput is fastest ns/key divided by method ns/key: 1.000 is the leader, smaller values are slower. Actual bits/key are rounded for display; exact bytes are retained in the data.

### C++ · broad screen · one core · Prehashed query

| Keys | Cap bits/key | FPR ceiling | Method | Actual bits/key | ns/key | Relative throughput |
| ---: | ---: | ---: | :--- | ---: | ---: | ---: |
| 65,536 | 16 | 0.1% | FourSectorBloomFilter | 16.0000 | 1.0618 | 1.000 |
| 65,536 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 1.6704 | 0.636 |
| 65,536 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 1.6907 | 0.628 |
| 65,536 | 16 | 1% | FastPatternBF | 16.0000 | 0.6780 | 1.000 |
| 65,536 | 16 | 1% | ByteSplitBloomFilter | 16.0000 | 1.0262 | 0.661 |
| 65,536 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 1.0618 | 0.638 |
| 33,554,432 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 4.8496 | 1.000 |
| 33,554,432 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 5.2612 | 0.922 |
| 33,554,432 | 16 | 0.1% | Boost.Bloom · Multi64, k=8 | 16.0000 | 5.6709 | 0.855 |
| 33,554,432 | 16 | 1% | FastPatternBF | 16.0000 | 4.1881 | 1.000 |
| 33,554,432 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 4.4411 | 0.943 |
| 33,554,432 | 16 | 1% | Boost192Multi32K8 | 12.0000 | 4.7230 | 0.887 |

### C++ · broad screen · one core · Common hash + query

| Keys | Cap bits/key | FPR ceiling | Method | Actual bits/key | ns/key | Relative throughput |
| ---: | ---: | ---: | :--- | ---: | ---: | ---: |
| 65,536 | 16 | 0.1% | FourSectorBloomFilter | 16.0000 | 1.5741 | 1.000 |
| 65,536 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 2.2517 | 0.699 |
| 65,536 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 2.2748 | 0.692 |
| 65,536 | 16 | 1% | FastPatternBF | 16.0000 | 1.2137 | 1.000 |
| 65,536 | 16 | 1% | ByteSplitBloomFilter | 16.0000 | 1.5348 | 0.791 |
| 65,536 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 1.5741 | 0.771 |
| 33,554,432 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 4.2881 | 1.000 |
| 33,554,432 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 4.4659 | 0.960 |
| 33,554,432 | 16 | 0.1% | Boost.Bloom · Multi64, k=8 | 16.0000 | 4.7205 | 0.908 |
| 33,554,432 | 16 | 1% | Split64Range (ours) | 12.0000 | 4.0411 | 1.000 |
| 33,554,432 | 16 | 1% | FastPatternBF | 16.0000 | 4.1746 | 0.968 |
| 33,554,432 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 4.1831 | 0.966 |

### C++ · strict 24-bit/key confirmation · one core · Prehashed query

| Keys | Cap bits/key | FPR ceiling | Method | Actual bits/key | ns/key | Relative throughput |
| ---: | ---: | ---: | :--- | ---: | ---: | ---: |
| 65,536 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 1.1949 | 1.000 |
| 65,536 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 1.6933 | 0.706 |
| 65,536 | 24 | 0.01% | FastFilter · Fixed64 | 24.0000 | 2.1806 | 0.548 |
| 33,554,432 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 5.6188 | 1.000 |
| 33,554,432 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 6.0818 | 0.924 |
| 33,554,432 | 24 | 0.01% | Boost.Bloom · Multi64, k=8 | 24.0000 | 6.5089 | 0.863 |

### C++ · strict 24-bit/key confirmation · one core · Common hash + query

| Keys | Cap bits/key | FPR ceiling | Method | Actual bits/key | ns/key | Relative throughput |
| ---: | ---: | ---: | :--- | ---: | ---: | ---: |
| 65,536 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 1.7066 | 1.000 |
| 65,536 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 2.2606 | 0.755 |
| 65,536 | 24 | 0.01% | FastFilter · Fixed64 | 24.0000 | 2.7308 | 0.625 |
| 33,554,432 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 5.2459 | 1.000 |
| 33,554,432 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 5.4755 | 0.958 |
| 33,554,432 | 24 | 0.01% | Boost.Bloom · Multi64, k=8 | 24.0000 | 5.8004 | 0.904 |

### Rust · raw public APIs · one core · Raw-key query, including required hashing

| Keys | Cap bits/key | FPR ceiling | Method | Actual bits/key | ns/key | Relative throughput |
| ---: | ---: | ---: | :--- | ---: | ---: | ---: |
| 65,536 | 16 | 0.1% | FourSectorBloomFilter | 16.0000 | 1.5127 | 1.000 |
| 65,536 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 2.1064 | 0.718 |
| 65,536 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 2.4479 | 0.618 |
| 65,536 | 16 | 1% | FastPatternBF | 16.0000 | 1.0868 | 1.000 |
| 65,536 | 16 | 1% | ByteSplitBloomFilter | 16.0000 | 1.4286 | 0.761 |
| 65,536 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 1.5127 | 0.718 |
| 65,536 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 1.6447 | 1.000 |
| 65,536 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 2.1370 | 0.770 |
| 65,536 | 24 | 0.01% | fastbloom 0.17.0 · k=7 | 24.0000 | 11.7867 | 0.140 |
| 33,554,432 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 4.4844 | 1.000 |
| 33,554,432 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 4.5259 | 0.991 |
| 33,554,432 | 16 | 0.1% | Fastbloom017K6 | 16.0000 | 24.2059 | 0.185 |
| 33,554,432 | 16 | 1% | FastPatternBF | 16.0000 | 4.2319 | 1.000 |
| 33,554,432 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 4.3062 | 0.983 |
| 33,554,432 | 16 | 1% | FourSectorRange12 (ours) | 16.0000 | 4.4173 | 0.958 |
| 33,554,432 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 5.4348 | 1.000 |
| 33,554,432 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 5.4837 | 0.991 |
| 33,554,432 | 24 | 0.01% | fastbloom 0.17.0 · k=7 | 24.0000 | 33.3091 | 0.163 |

### C++ · shared executor · eight physical cores · Prehashed query, including launch/join

| Keys | Cap bits/key | FPR ceiling | Method | Actual bits/key | ns/key | Relative throughput |
| ---: | ---: | ---: | :--- | ---: | ---: | ---: |
| 65,536 | 16 | 0.1% | FourSectorBloomFilter | 16.0000 | 0.1876 | 1.000 |
| 65,536 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 0.2667 | 0.703 |
| 65,536 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 0.2711 | 0.692 |
| 65,536 | 16 | 1% | FastPatternBF | 16.0000 | 0.1389 | 1.000 |
| 65,536 | 16 | 1% | ByteSplitBloomFilter | 16.0000 | 0.1849 | 0.751 |
| 65,536 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 0.1876 | 0.740 |
| 65,536 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 0.2048 | 1.000 |
| 65,536 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 0.2690 | 0.761 |
| 65,536 | 24 | 0.01% | FastFilter · Fixed64 | 24.0000 | 0.3299 | 0.621 |
| 33,554,432 | 16 | 0.1% | FourSectorBloomFilter | 16.0000 | 0.6431 | 1.000 |
| 33,554,432 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 0.6837 | 0.941 |
| 33,554,432 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 0.7272 | 0.884 |
| 33,554,432 | 16 | 1% | FastPatternBF | 16.0000 | 0.6075 | 1.000 |
| 33,554,432 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 0.6431 | 0.945 |
| 33,554,432 | 16 | 1% | Boost192Multi32K8 | 12.0000 | 0.6540 | 0.929 |
| 33,554,432 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 0.7953 | 1.000 |
| 33,554,432 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 0.8531 | 0.932 |
| 33,554,432 | 24 | 0.01% | Boost.Bloom · Multi64, k=8 | 24.0000 | 0.8969 | 0.887 |

### C++ · shared executor · eight physical cores · Common hash + query, including launch/join

| Keys | Cap bits/key | FPR ceiling | Method | Actual bits/key | ns/key | Relative throughput |
| ---: | ---: | ---: | :--- | ---: | ---: | ---: |
| 65,536 | 16 | 0.1% | FourSectorBloomFilter | 16.0000 | 0.2524 | 1.000 |
| 65,536 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 0.3380 | 0.747 |
| 65,536 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 0.3431 | 0.736 |
| 65,536 | 16 | 1% | FastPatternBF | 16.0000 | 0.2076 | 1.000 |
| 65,536 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 0.2524 | 0.823 |
| 65,536 | 16 | 1% | ByteSplitBloomFilter | 16.0000 | 0.2728 | 0.761 |
| 65,536 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 0.2780 | 1.000 |
| 65,536 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 0.3392 | 0.820 |
| 65,536 | 24 | 0.01% | FastFilter · Fixed64 | 24.0000 | 0.4025 | 0.691 |
| 33,554,432 | 16 | 0.1% | FourSectorBloomFilter | 16.0000 | 0.6249 | 1.000 |
| 33,554,432 | 16 | 0.1% | Split64BloomFilter | 16.0000 | 0.6370 | 0.981 |
| 33,554,432 | 16 | 0.1% | Split64Range (ours) | 16.0000 | 0.6430 | 0.972 |
| 33,554,432 | 16 | 1% | FastPatternBF | 16.0000 | 0.6122 | 1.000 |
| 33,554,432 | 16 | 1% | Boost192Multi32K8 | 12.0000 | 0.6233 | 0.982 |
| 33,554,432 | 16 | 1% | FourSectorBloomFilter | 16.0000 | 0.6249 | 0.980 |
| 33,554,432 | 24 | 0.01% | FourSectorRange12 (ours) | 24.0000 | 0.7529 | 1.000 |
| 33,554,432 | 24 | 0.01% | Split64Range (ours) | 24.0000 | 0.7792 | 0.966 |
| 33,554,432 | 24 | 0.01% | Boost.Bloom · Multi64, k=8 | 24.0000 | 0.8228 | 0.915 |

## Data and frozen evidence

[All qualifying configurations (CSV)](../benchmarks/results/batch4096.csv) · [Seed medians and provenance (JSON)](../benchmarks/results/batch4096.json) · [Reproduction](reproduce.md)

The following immutable research sources include full calibration, trial vectors, producer details and historical work outside this publication slice. Main publishes only the batch4096 query subset.

- [C++ broad capacity screen](https://github.com/YimingQiao/Fastest-Bloom-Filter/tree/551a3a4c648df223e29305cf89418e48a553c577/experiments/2026-10-29-exact-budget-range/)
- [C++ strict24 confirmation](https://github.com/YimingQiao/Fastest-Bloom-Filter/tree/551a3a4c648df223e29305cf89418e48a553c577/experiments/2026-10-29-four-sector-range12-strict24-analysis/)
- [Rust raw public-API screen](https://github.com/YimingQiao/Fastest-Bloom-Filter/tree/551a3a4c648df223e29305cf89418e48a553c577/experiments/2026-10-29-fastbloom-rs-raw8-analysis/)
- [C++ shared eight-core executor](https://github.com/YimingQiao/Fastest-Bloom-Filter/tree/551a3a4c648df223e29305cf89418e48a553c577/experiments/2026-10-29-native-k12-parallel-analysis/)
- [Original ranking calculation and input hashes](https://github.com/YimingQiao/Fastest-Bloom-Filter/tree/551a3a4c648df223e29305cf89418e48a553c577/docs/benchmark-top3-2026-10-30/)
