# External Bloom filter baselines

The release compares against the following upstream libraries. Versions and adapter contracts come from the frozen research snapshot; benchmark identifiers in JSON/CSV remain unchanged.

| Library | Measured version | Interface used |
| :--- | :--- | :--- |
| [Boost.Bloom](https://github.com/boostorg/bloom/tree/0909b9955e2dc02a0356351a2dfb567d4d5af772) | Boost 1.92.0 | Public range insertion and callback bulk query, with an identity hasher for the common prehashed contract |
| [RocksDB](https://github.com/facebook/rocksdb/tree/ef3dd12e9a6314aaf08fba6d5d445494eac9b253) | v11.12, `ef3dd12` | FastLocalBloom64 core, direct and upstream-derived batch32 schedules; fixed probe counts are explicit adapter configurations |
| [FastFilter](https://github.com/FastFilter/fastfilter_cpp/tree/7c5bf187d5096ccbcec6a16e02975d0af3328b01) | `7c5bf18` | Classic and SIMD block families, including Fixed16/32/64 and explicitly named batch variants |
| [PageBloomFilter](https://github.com/PeterRK/PageBloomFilter/tree/bcf10622ab740b4dfd99631b27484ecedb96646a) | `bcf1062` | Measured compact/default page configurations |
| [fastbloom](https://docs.rs/fastbloom/0.17.0/fastbloom/) | 0.17.0 | Public hash membership methods; the raw-key benchmark pays common hashing inside each batch |
| [fastbloom-rs](https://github.com/yankun1992/fastbloom/tree/ea18d38eca9cb3a48f395f28ab67004b6f1ab83e) | 0.5.10, `ea18d38` | Public raw-byte API receives each original key as eight little-endian bytes, with no redundant common prehash |
| [Bloomsday](https://github.com/sidd-27/Bloomsday/tree/11f16a91a1c8a20344cd263e908f957dac7cf5d0) | `11f16a9` | Public membership API; common hashing included for raw-key queries |
| [sbbf-rs-safe](https://docs.rs/sbbf-rs-safe/0.3.2/sbbf_rs_safe/) | 0.3.2, with sbbf-rs 0.2.8 | Public safe filter API; actual aligned backing allocation counted |

The README's strict C++ table includes the complete five-API confirmation: our K12 and Range, FastFilter Fixed64, Boost Multi64 K8, and RocksDB FastLocalBloom64 K8 Batch32. No external row is hidden for finishing outside the top three. The strict Rust table includes the best qualifying measured fastbloom and fastbloom-rs configurations; Bloomsday and sbbf do not qualify at the measured allocations under the 24-bit/key and 0.01% limits. Their measured results remain visible under the 16-bit/key and 1% condition.

Probe counts and allocation choices are measured configurations, not necessarily upstream defaults. An adapter using a batch schedule or compile-time probe count is labeled explicitly. RocksDB timings exclude SST I/O, DB lookups, virtual reader calls and its default byte-key hashing. External sources are optional research dependencies; the native Rust library remains dependency-free.

## Frozen source and dependency records

- [C++ upstream revisions and source hashes](https://github.com/YimingQiao/Fastest-Bloom-Filter/blob/551a3a4c648df223e29305cf89418e48a553c577/benchmarks/all-external/upstreams.json)
- [Rust caller manifest](https://github.com/YimingQiao/Fastest-Bloom-Filter/blob/551a3a4c648df223e29305cf89418e48a553c577/experiments/2026-10-29-fastbloom-rs-raw8-caller/dependency-preparation/manifest-v2.toml)
- [Rust resolved dependency lock](https://github.com/YimingQiao/Fastest-Bloom-Filter/blob/551a3a4c648df223e29305cf89418e48a553c577/experiments/2026-10-29-fastbloom-rs-raw8-caller/dependency-preparation/resolved-Cargo-v2.lock)
- [Rust source and adapter preparation](https://github.com/YimingQiao/Fastest-Bloom-Filter/blob/551a3a4c648df223e29305cf89418e48a553c577/experiments/2026-10-29-fastbloom-rs-raw8-caller/README.md)

See [performance methodology](performance.md) for hardware, quality gates and timing contracts. The tables below are generated from the unchanged [publication dataset](../benchmarks/results/batch4096.json).

<!-- BEGIN LIBRARY_CONFIGURATIONS -->
## Configurations behind the README library tables

Each library contributes its fastest qualifying measured configuration at each size, under 16 actual bits/key and a 1% FPR ceiling. This is a same-data selection within each panel, not a new confirmation. All queries use batch4096. Hashing is included. Exact bytes and method identifiers below resolve every README cell.

### C++

| Library | Keys | Exact measured method | Actual bytes | Actual bits/key | ns/key |
| :--- | ---: | :--- | ---: | ---: | ---: |
| Our best measured layout | 65,536 | `FastPatternBF` | 131,072 | 16.000000 | 1.2137 |
| Our best measured layout | 33,554,432 | `Split64RangeExperiment` | 50,331,648 | 12.000000 | 4.0411 |
| Boost.Bloom 1.92.0 | 65,536 | `Boost192Multi32K8` | 114,687 | 13.999878 | 2.1938 |
| Boost.Bloom 1.92.0 | 33,554,432 | `Boost192Multi32K8` | 50,331,647 | 12.000000 | 4.1937 |
| RocksDB v11.12 | 65,536 | `RocksDBFastLocalBloom64K8` | 98,304 | 12.000000 | 2.8761 |
| RocksDB v11.12 | 33,554,432 | `RocksDBFastLocalBloom64K8Batch32` | 50,331,648 | 12.000000 | 5.5560 |
| FastFilter | 65,536 | `FastFilterFixed16SingleV1` | 114,688 | 14.000000 | 1.6069 |
| FastFilter | 33,554,432 | `FastFilterFixed32Bulk` | 50,331,648 | 12.000000 | 4.5468 |
| PageBloomFilter | 65,536 | `PageBloom6Compact` | 98,304 | 12.000000 | 7.3062 |
| PageBloomFilter | 33,554,432 | `PageBloom6Compact` | 50,331,648 | 12.000000 | 16.0819 |

### Rust

| Library | Keys | Exact measured method | Actual bytes | Actual bits/key | ns/key |
| :--- | ---: | :--- | ---: | ---: | ---: |
| Our best measured layout | 65,536 | `FastPatternBF` | 131,072 | 16.000000 | 1.0868 |
| Our best measured layout | 33,554,432 | `FastPatternBF` | 67,108,864 | 16.000000 | 4.2319 |
| fastbloom 0.17.0 | 65,536 | `Fastbloom017K3` | 131,072 | 16.000000 | 9.4548 |
| fastbloom 0.17.0 | 33,554,432 | `Fastbloom017K3` | 67,108,864 | 16.000000 | 16.5559 |
| fastbloom-rs 0.5.10 | 65,536 | `FastbloomRsRawK3` | 131,072 | 16.000000 | 18.9280 |
| fastbloom-rs 0.5.10 | 33,554,432 | `FastbloomRsRawK3` | 67,108,864 | 16.000000 | 31.8312 |
| Bloomsday | 65,536 | `BloomsdayPinned` | 131,072 | 16.000000 | 1.9035 |
| Bloomsday | 33,554,432 | `BloomsdayPinned` | 67,108,864 | 16.000000 | 5.4982 |
| sbbf-rs-safe 0.3.2 | 65,536 | `SbbfSafePinned` | 131,072 | 16.000000 | 2.7863 |
| sbbf-rs-safe 0.3.2 | 33,554,432 | `SbbfSafePinned` | 67,108,864 | 16.000000 | 6.9245 |

<!-- END LIBRARY_CONFIGURATIONS -->
