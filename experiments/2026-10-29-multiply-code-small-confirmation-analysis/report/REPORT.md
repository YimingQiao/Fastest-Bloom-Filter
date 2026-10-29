# Multiply16 fixed fresh-seed confirmation

Main competitive policy: Multiply wins 19, loses 17, ties 0 of the36 seed/batch/query-contract comparisons with an eligible candidate and rival. Ineligible comparisons remain in the tables and are not counted as wins.

This is a fixed small-table confirmation:65,536 inserted keys, actual allocation≤16 bits/key,0.1% Wilson-upper gate, batches1/31/4096, six fresh order-conditioned seeds,2^22 mixed queries and six balanced query repetitions. It does not establish a global fastest Bloom filter or a new production recommendation.

## Accuracy and qualification

48 API/seed records reduce to36 distinct mapping/seed samples. Range/Fixed64 and the two RocksDB APIs share bitmap semantics; their negatives and the three batch repeats are never pooled. All48 raw API endpoints and all36 distinct samples are retained in quality.json.

| API | Largest fresh Wilson95 upper (%) | Pass all six | Main eligible | Original restricted set |
|---|---:|:---:|:---:|:---:|
| MultiplyCodeSplit64RangeExperiment | 0.09495175 | True | True | True |
| Split64BloomFilter | 0.09440510 | True | True | True |
| Split64RangeExperiment | 0.09408672 | True | True | True |
| FourSectorBloomFilter | 0.10167873 | False | False | False |
| FastFilterFixed64 | 0.09408672 | True | True | True |
| Boost192Multi64K8 | 0.09554644 | True | True | True |
| RocksDBFastLocalBloom64K8 | 0.09464539 | True | True | True |
| RocksDBFastLocalBloom64K8Batch32 | 0.09464539 | True | True | True |

The main competitive policy includes every API passing all six fresh endpoints, including FourSector. The originally fixed restricted set excludes FourSector and is reported only as a secondary policy. A historical upper endpoint above0.1% did not prove true FPR above0.1%: a separate pre-confirmation audit measured117,440,512 new disjoint negatives on each of the two old constructions, and both new endpoints passed. That precision evidence is pinned by the runner and is never pooled into this confirmation.

## Main comparison against the fastest eligible rival

Ratios are rival latency divided by Multiply latency, so values above1 favor Multiply. Each cell summarizes six data/order observations; it is not a confidence interval or a pooling of timed queries.

| Query contract | Batch | Eligible seeds | Geomean ratio | Min–max | Wins/losses/ties |
|---|---:|---:|---:|---:|---:|
| lookup_ns | 1 | 6/6 | 0.8410× | 0.8375–0.8445 | 0/6/0 |
| lookup_ns | 31 | 6/6 | 1.1070× | 1.0967–1.1194 | 6/0/0 |
| lookup_ns | 4096 | 6/6 | 1.0882× | 1.0738–1.0936 | 6/0/0 |
| hash_lookup_ns | 1 | 6/6 | 0.8927× | 0.8902–0.8955 | 0/6/0 |
| hash_lookup_ns | 31 | 6/6 | 0.9942× | 0.9876–1.0138 | 1/5/0 |
| hash_lookup_ns | 4096 | 6/6 | 1.0683× | 1.0642–1.0800 | 6/0/0 |

Separate external-only and retained-project leaders, the original restricted set and per-seed current qualification appear in policy-views.csv and policy-summary.csv. All equal-latency leaders are retained; secondary or current-only winners must not be described as overall eligible winners.

## Every named rival and both order strata

pair-summary.csv keeps all42 named-rival/batch/contract groups and every per-seed ratio remains in pairs.csv (252 comparisons). order-summary.csv keeps84 groups split into three Multiply-first and three Multiply-last seeds. The design balances candidate-relative order, not all eight absolute positions. Geometric means remain descriptive; inspecting both strata does not remove allocation-placement or sequential-execution effects.

All864 API/policy/seed/batch/contract alternatives, including losses and ineligible APIs, are in alternatives.csv. The raw144 rows preserve every trial and min/max; no candidate mapping, allocation, hash, insertion method or timer changed after the seed42 training screen.

## Reproduction and limits

Driver commit `8a77b5d9190872b3cf06be8946650bd6e4fd8e0d`; compiled source `9e4362f1068d37d134ef8447a44146b52c1edc9f`; binary SHA `cc316deee30c6738bdd8a2bbfec5a7d2c2be020397fc888dbaa0bc0e7a1a6615`. CPU3/socket1 was held under one inherited exclusive flock for the matrix. Only CPU affinity was applied; no NUMA memory-binding claim is made.

The analysis requires all18 cases complete and rechecks336 source/evidence hashes,39 executables, committed local archive bytes, exact commands, source-derived row/phase order, all trial vectors, raw/aggregate equality, checksums and calibration alias identity. It verifies the raw archive manifest before interpreting results. Separate prior accuracy samples are contextual evidence only; neither old timing nor repeated-stream negative counts enters the current ratios or endpoints.
