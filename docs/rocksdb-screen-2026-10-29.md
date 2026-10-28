# RocksDB-inclusive screening — 2026-10-29

This exploratory comparison adds all eight pinned RocksDB FastLocalBloom core
configurations to a 20-configuration shortlist: three current native layouts,
five FastFilter variants, three Boost.Bloom variants and PageBloom6Compact.
The complete matrix has **240 rows: 20 configurations × 12 cases**. It measures
generic batch calls with counts 1, 31 and 4096; count 1 is throughput through the
batch API, not serialized latency or a fused public raw-key single-query API.

One Xeon Platinum 8474C core (CPU 2), Clang 23, common native ISA, 65K/32M keys,
requested 8/16 bits per key, 50% hits, seed 42, 2^22 timed queries and three
repetitions. Each construction call receives the full insertion set. Independent
2^24-negative calibration follows timing. Bitmap payloads span 128 KiB–128 MiB;
queries are warmed and repeated, so a large bitmap does not imply cold accesses.

Ranking uses a payload-allocation ceiling with zero slack and a one-sided,
pointwise 95% Wilson FPR bound. Every candidate may choose either tested allocation
under the ceiling. This one-seed screen does not establish a held-out performance
win. Separate prehashed and construction rankings are retained with the raw data.
Native kernels and the new selection/output guards are frozen at `6c2eaa9`;
later ByteSplit integration is absent from this executable.

## Hash plus query

Times are median ns/key. Speedup is external/native, so values below one are
native losses. The RocksDB column shows its fastest eligible configuration in
the same cell; it measures unchanged core primitives, excluding SST/database work.

| Keys | Batch | Bits/key ceiling / FPR ceiling | Native query leader | ns/key | External query leader | ns/key | Speedup | Best RocksDB core, ns/key |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 1 | 16 / 1.00% | Split64BloomFilter | 4.511 | FastFilterFixed16 | 4.298 | 0.95× | RocksDBFastLocalBloom64K8: 5.585 |
| 65,536 | 1 | 16 / 0.10% | Split64BloomFilter | 4.511 | FastFilterFixed64 | 5.409 | 1.20× | RocksDBFastLocalBloom64K8: 5.585 |
| 65,536 | 1 | 32 / 0.01% | Split64BloomFilter | 4.521 | FastFilterSimdBlock | 4.475 | 0.99× | RocksDBFastLocalBloom64K8: 5.548 |
| 65,536 | 31 | 16 / 1.00% | FastPatternBF | 1.846 | FastFilterFixed16 | 1.655 | 0.90× | RocksDBFastLocalBloom64K8: 2.969 |
| 65,536 | 31 | 16 / 0.10% | FourSectorBloomFilter | 1.986 | FastFilterFixed64 | 2.764 | 1.39× | RocksDBFastLocalBloom64K8: 2.969 |
| 65,536 | 31 | 32 / 0.01% | FastPatternBF | 1.895 | Boost192Multi32K8 | 1.886 | 1.00× | RocksDBFastLocalBloom64K8: 3.014 |
| 65,536 | 4096 | 16 / 1.00% | FastPatternBF | 1.167 | FastFilterFixed16 | 1.575 | 1.35× | RocksDBFastLocalBloom64K8: 2.923 |
| 65,536 | 4096 | 16 / 0.10% | FourSectorBloomFilter | 1.538 | FastFilterFixed64 | 2.652 | 1.72× | RocksDBFastLocalBloom64K8: 2.923 |
| 65,536 | 4096 | 32 / 0.01% | FastPatternBF | 1.200 | FastFilterSimdBlock | 1.748 | 1.46× | RocksDBFastLocalBloom64K8: 2.857 |
| 33,554,432 | 1 | 16 / 1.00% | Split64BloomFilter | 11.515 | FastFilterSimdBlock | 11.368 | 0.99× | RocksDBFastLocalBloom64K8: 12.604 |
| 33,554,432 | 1 | 16 / 0.10% | Split64BloomFilter | 11.515 | RocksDBFastLocalBloom64K8 | 12.604 | 1.09× | RocksDBFastLocalBloom64K8: 12.604 |
| 33,554,432 | 1 | 32 / 0.01% | Split64BloomFilter | 19.091 | FastFilterFixed32 | 19.583 | 1.03× | RocksDBFastLocalBloom64K8: 20.891 |
| 33,554,432 | 31 | 16 / 1.00% | FourSectorBloomFilter | 5.631 | FastFilterFixed32 | 5.876 | 1.04× | RocksDBFastLocalBloom64K8Batch32: 6.914 |
| 33,554,432 | 31 | 16 / 0.10% | FourSectorBloomFilter | 5.631 | RocksDBFastLocalBloom64K8Batch32 | 6.914 | 1.23× | RocksDBFastLocalBloom64K8Batch32: 6.914 |
| 33,554,432 | 31 | 32 / 0.01% | FourSectorBloomFilter | 7.412 | FastFilterFixed32 | 8.252 | 1.11× | RocksDBFastLocalBloom64K8Batch32: 9.596 |
| 33,554,432 | 4096 | 16 / 1.00% | FastPatternBF | 4.023 | Boost192Multi64K8 | 4.681 | 1.16× | RocksDBFastLocalBloom64K8Batch32: 6.008 |
| 33,554,432 | 4096 | 16 / 0.10% | FourSectorBloomFilter | 4.095 | Boost192Multi64K8 | 4.681 | 1.14× | RocksDBFastLocalBloom64K8Batch32: 6.008 |
| 33,554,432 | 4096 | 32 / 0.01% | FastPatternBF | 5.677 | Boost192Multi32K8 | 6.095 | 1.07× | RocksDBFastLocalBloom64K8Batch32: 8.352 |

## Hash plus construction

These rows use the batch-4096 cases solely to select one recorded construction
measurement per configuration. Insertion batching is independently fixed to the
full input. Times include hashing and insertion, excluding bitmap allocation and
zeroing; allocate+hash+insert remains in the raw CSV. Query speed does not imply
construction speed.

| Keys | Bits/key ceiling / FPR ceiling | Native construction leader | ns/key | External construction leader | ns/key |
| --- | --- | --- | --- | --- | --- |
| 65,536 | 16 / 1.00% | Split64BloomFilter | 2.109 | FastFilterFixed16 | 1.569 |
| 65,536 | 16 / 0.10% | Split64BloomFilter | 2.109 | Boost192Multi64K8 | 2.303 |
| 65,536 | 32 / 0.01% | Split64BloomFilter | 2.002 | Boost192Multi32K8 | 1.802 |
| 33,554,432 | 16 / 1.00% | FastPatternBF | 5.320 | Boost192Multi32K8 | 5.569 |
| 33,554,432 | 16 / 0.10% | Split64BloomFilter | 5.371 | Boost192Multi64K8 | 5.681 |
| 33,554,432 | 32 / 0.01% | Split64BloomFilter | 6.780 | Boost192Multi32K8 | 6.919 |

The full combined executable had 53 configurations; this stage uses the listed
shortlist, not the whole search space. The separately measured FastFilter single
shortcut controls and optional PageBloom AES mode are not in this screen. Neither
this shortlist nor the native-only scaling study establishes a multithreaded win
over every external library. New native ByteSplit measurements are separate.

The first attempted matrix was interrupted after a misspelled filter name silently
omitted FastPattern. Its seven completed cases are retained as rejected evidence
and are excluded here. Both language harnesses now reject partial selections,
and the runner verifies exact names/workload fields. Full first-timed prehashed
and hash+query output checksums are checked outside the timers; corruption tests
exercise those guards.

[Complete raw matrix, rankings and provenance](../results/2026-10-29-rocksdb-screen/),
[RocksDB adapter contract](../benchmarks/rocksdb-external/README.md),
[rejected preliminary run](../results/2026-10-29-rocksdb-screen-rejected/REJECTED.md).
Regenerate with `python3 scripts/summarize_rocksdb.py`.
