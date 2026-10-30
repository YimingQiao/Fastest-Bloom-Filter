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

In the NEW six-seed confirmation, FourSector has 1 failed upper-endpoint gate(s), independently of its old diagnostic label. This makes the main and restricted eligible sets coincide here if all other APIs pass. The new interval does not establish the unknown true FPR is above the target; its lower endpoint must be considered too. Five or six individually passing constructions are not a universal bound.

| Fresh FourSector seed | FP /2^24 | Point FPR (%) | Wilson95 low–high (%) | Current gate |
|---:|---:|---:|---:|:---:|
| 1207963405401966250 | 16444 | 0.09801388 | 0.09652793–0.09952268 | True |
| 1262581121544068856 | 16803 | 0.10015368 | 0.09865149–0.10167873 | False |
| 1882864631949045521 | 16304 | 0.09717941 | 0.09569984–0.09868184 | True |
| 4003307244032938740 | 16104 | 0.09598732 | 0.09451691–0.09748058 | True |
| 16961083496135856660 | 16495 | 0.09831786 | 0.09682959–0.09982898 | True |
| 17762540211900286710 | 16431 | 0.09793639 | 0.09645103–0.09944460 | True |

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

### External and native comparisons

The external result is limited to these four prespecified APIs. Native Split64 and original Range remain separate competitors; FourSector timings remain visible even when its all-six-seed gate fails.

| Query contract | Batch | Versus fastest eligible external | External win/loss/tie | Versus native Split64 | Versus original Range | Versus FourSector (timing only) |
|---|---:|---:|---:|---:|---:|---:|
| lookup_ns | 1 | 1.0357× | 6/0/0 | 0.8410× | 0.8541× | 1.5495× |
| lookup_ns | 31 | 1.5369× | 6/0/0 | 1.1070× | 1.1291× | 0.8784× |
| lookup_ns | 4096 | 1.4103× | 6/0/0 | 1.0882× | 1.1022× | 0.6928× |
| hash_lookup_ns | 1 | 1.0927× | 6/0/0 | 0.8927× | 0.9759× | 1.4871× |
| hash_lookup_ns | 31 | 1.3012× | 6/0/0 | 0.9990× | 1.0118× | 0.9419× |
| hash_lookup_ns | 4096 | 1.2987× | 6/0/0 | 1.0683× | 1.0802× | 0.7539× |

Under the separate per-seed current gate, Multiply wins 3 and loses 33 of the36 comparisons. This difference matters: FourSector can be a faster bulk-query rival on constructions that pass the current gate, even when it is excluded by the stricter all-six-seed rule. Both views are reported; neither the historical precision audit nor the newly failing endpoint is suppressed.

## Every named rival and both order strata

pair-summary.csv keeps all42 named-rival/batch/contract groups and every per-seed ratio remains in pairs.csv (252 comparisons). order-summary.csv keeps84 groups split into three Multiply-first and three Multiply-last seeds. The design balances candidate-relative order, not all eight absolute positions. Geometric means remain descriptive; inspecting both strata does not remove allocation-placement or sequential-execution effects.

| Query contract | Batch | Versus native Split64: Multiply first | Multiply last |
|---|---:|---:|---:|
| lookup_ns | 1 | 0.8415× | 0.8405× |
| lookup_ns | 31 | 1.1018× | 1.1122× |
| lookup_ns | 4096 | 1.0849× | 1.0914× |
| hash_lookup_ns | 1 | 0.8922× | 0.8932× |
| hash_lookup_ns | 31 | 1.0097× | 0.9885× |
| hash_lookup_ns | 4096 | 1.0703× | 1.0662× |

Near-parity results whose sign changes between order strata are fragile and should not support an unconditional speed claim. Every named-rival minimum, maximum and individual loss remains in the CSVs; a favorable mean does not replace those observations.

All864 API/policy/seed/batch/contract alternatives, including losses and ineligible APIs, are in alternatives.csv. The raw144 rows preserve every trial and min/max; no candidate mapping, allocation, hash, insertion method or timer changed after the seed42 training screen.

## Reproduction and limits

Driver commit `8a77b5d9190872b3cf06be8946650bd6e4fd8e0d`; compiled source `9e4362f1068d37d134ef8447a44146b52c1edc9f`; binary SHA `cc316deee30c6738bdd8a2bbfec5a7d2c2be020397fc888dbaa0bc0e7a1a6615`. CPU3/socket1 was held under one inherited exclusive flock for the matrix. Only CPU affinity was applied; no NUMA memory-binding claim is made.

The analysis requires all18 cases complete and rechecks336 source/evidence hashes,39 executables, committed local archive bytes, exact commands, source-derived row/phase order, all trial vectors, raw/aggregate equality, checksums and calibration alias identity. It verifies the raw archive manifest before interpreting results. Separate prior accuracy samples are contextual evidence only; neither old timing nor repeated-stream negative counts enters the current ratios or endpoints.
