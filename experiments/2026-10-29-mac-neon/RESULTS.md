# Apple M5 Pro bulk Bloom filters — 2026-10-29

C++17 / Apple Clang 21, `-O3 -mcpu=native -fno-strict-aliasing`, single thread. All primary queries are absent. Each row uses five repetitions, 4,194,304 queries, batch 4096 for both insertion and lookup, and 4,194,304 separate FPR calibration negatives. Seeds 6007, 7001 and 8009 were held out from tuning. Job order is shuffled inside the same executable; case order is shuffled by the runner. No benchmark processes ran concurrently.

The comparison ceiling is 16 actual bitmap bits/key and a pointwise 95% Wilson FPR upper bound below 1%. All reported candidates pass. Object fields, allocator metadata and shared read-only constants are excluded from bitmap bytes for every implementation. Word64 additionally shares a 512-byte dictionary. This is a measured comparison against the retained shortlist, not a claim of universal superiority.

## Primary results

Times are ns/key: lower is better. Values below are medians across three seed medians. The external column takes the fastest eligible external separately per seed, not one fixed external layout.

| Bitmap | Word64 insert | Split16 insert | External insert | Word64 query | Split16 query | External query |
|---|---:|---:|---:|---:|---:|---:|
| 128 KiB | 0.516 | 0.529 | 0.518 | 0.439 | 0.491 | 0.508 |
| 2 MiB | 0.746 | 0.758 | 0.747 | 0.592 | 0.596 | 0.650 |
| 8 MiB | 0.818 | 0.836 | 0.816 | 0.738 | 0.698 | 0.766 |
| 32 MiB | 1.530 | 1.584 | 1.624 | 1.553 | 1.672 | 1.717 |
| 64 MiB | 2.526 | 2.548 | 2.580 | 2.507 | 2.380 | 2.387 |

## Wins, ties and losses

A ±3% band is used for classification, not a statistical confidence interval. The native leader is selected per case from all five eligible native layouts; this does not imply that one layout is fastest everywhere. Hash-inclusive metrics include the same MurmurHash64 batch pass.

| Metric | Native wins | Within ±3% | Native losses | Native/external speedup range |
|---|---:|---:|---:|---:|
| insert_ns | 4 | 11 | 0 | 0.976–1.104× |
| allocate_insert_ns | 4 | 11 | 0 | 0.976–1.103× |
| hash_insert_ns | 4 | 11 | 0 | 0.973–1.083× |
| allocate_hash_insert_ns | 4 | 11 | 0 | 0.973–1.082× |
| lookup_ns | 12 | 3 | 0 | 0.970–1.157× |
| hash_lookup_ns | 10 | 4 | 1 | 0.964–1.132× |

## Accuracy and preservation

- Word64BloomFilter: measured FPR 0.5584–0.5747%; maximum Wilson upper bound 0.5820%.
- Split16BloomFilter: measured FPR 0.2417–0.2521%; maximum Wilson upper bound 0.2569%.
- ByteSplitBloomFilter: measured FPR 0.5463–0.5569%; maximum Wilson upper bound 0.5641%.
- FastPatternBF: measured FPR 0.1987–0.2065%; maximum Wilson upper bound 0.2109%.

All ByteSplit/FastPattern checksums, timed and calibration FPR counts, and bitmap bytes exactly match their frozen pre-optimization controls in every primary case.

## Limits and reproducibility

- This machine is an Apple M5 Pro with 48 GiB RAM and 128-byte hardware cache lines. Other M-series and Intel Macs have not been timed. macOS scheduling and clock variation remain; cores were not pinned.
- The 19-configuration Boost 1.92 screen selected five external leaders, then FastFilter’s pinned ARM implementation was added. The final shortlist is not a survey of every current Bloom filter library.
- FastFilter ARM exposes Add/Find but its AddAll is only declared; its wrapper uses its real public per-key methods. Boost uses its public iterator batch APIs. Neither upstream implementation was patched.
- Word64 and Split16 are new C++ layouts with different bitmaps. ByteSplit’s NEON path and FastPattern’s prefetch retain their existing mappings. The Rust implementation has not received the new layouts.
- `confirmation.csv` contains all 195 primary rows, including losses and allocation/hash-inclusive timing. `confirmation.json` records binary hash, commands, hardware and compiler. Earlier screens and rejected prefetch/unroll alternatives remain alongside it.

Run `python3 experiments/2026-10-29-mac-neon/run_confirmation.py` after building the local confirmation CMake project. Run this script to regenerate the tables. See `docs/mac-bulk.md` for build and API instructions.
