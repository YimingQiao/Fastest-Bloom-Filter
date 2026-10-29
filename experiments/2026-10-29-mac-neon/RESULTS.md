# Apple M5 Pro bulk Bloom filters — 2026-10-29

C++17 / Apple Clang 21, `-O3 -mcpu=native -fno-strict-aliasing`, single thread. All primary queries are absent. Each row uses five repetitions, 4,194,304 queries, batch 4096 for both insertion and lookup, and 4,194,304 separate FPR calibration negatives. Seeds 6007, 7001 and 8009 were held out from tuning. Job order is shuffled inside the same executable; case order is shuffled by the runner. No benchmark processes ran concurrently.

The comparison ceiling is 16 actual bitmap bits/key and a pointwise 95% Wilson FPR upper bound below 1%. All reported candidates pass. Object fields, allocator metadata and shared read-only constants are excluded from bitmap bytes for every implementation. Word64 additionally shares a 512-byte dictionary. This is a measured comparison against the retained shortlist, not a claim of universal superiority.

## Primary results

Times are ns/key: lower is better. Values below are medians across three seed medians. The external column takes the fastest eligible external separately per seed, not one fixed external layout.

| Bitmap | Word64 insert | Split16 insert | External insert | Word64 query | Split16 query | External query |
|---|---:|---:|---:|---:|---:|---:|
| 128 KiB | 0.519 | 0.532 | 0.516 | 0.440 | 0.494 | 0.504 |
| 2 MiB | 0.756 | 0.767 | 0.753 | 0.599 | 0.601 | 0.651 |
| 8 MiB | 0.818 | 0.839 | 0.816 | 0.740 | 0.700 | 0.740 |
| 32 MiB | 1.458 | 1.511 | 1.533 | 1.487 | 1.680 | 1.651 |
| 64 MiB | 2.428 | 2.371 | 2.438 | 2.301 | 2.327 | 2.313 |

## Wins, ties and losses

A ±3% band is used for classification, not a statistical confidence interval. The native leader is selected per case from all five eligible native layouts; this does not imply that one layout is fastest everywhere. Hash-inclusive metrics include the same MurmurHash64 batch pass.

| Metric | Native wins | Within ±3% | Native losses | Native/external speedup range |
|---|---:|---:|---:|---:|
| insert_ns | 5 | 10 | 0 | 0.986–1.082× |
| allocate_insert_ns | 5 | 10 | 0 | 0.988–1.082× |
| hash_insert_ns | 3 | 11 | 1 | 0.961–1.063× |
| allocate_hash_insert_ns | 3 | 11 | 1 | 0.961–1.062× |
| lookup_ns | 12 | 3 | 0 | 1.002–1.160× |
| hash_lookup_ns | 11 | 4 | 0 | 0.987–1.106× |

## Accuracy and preservation

- Word64BloomFilter: measured FPR 0.5584–0.5747%; maximum Wilson upper bound 0.5820%.
- Split16BloomFilter: measured FPR 0.2417–0.2521%; maximum Wilson upper bound 0.2569%.
- ByteSplitBloomFilter: measured FPR 0.5463–0.5569%; maximum Wilson upper bound 0.5641%.
- FastPatternBF: measured FPR 0.1987–0.2065%; maximum Wilson upper bound 0.2109%.

All ByteSplit/FastPattern checksums, timed and calibration FPR counts, and bitmap bytes exactly match their frozen pre-optimization controls in every primary case.

## Short batches and present-key guardrails

The secondary screen uses 128 KiB, 8 MiB and 64 MiB bitmaps, 0/50/100% hits, query batches 1/31/4096 and seed 8191. Insert batches remain 4096. These are performance guardrails, not independent proof that all hit mixes are optimal. Short-batch dispatch was adjusted after an earlier guardrail screen; its rows remain in `guardrails-before-final.csv`.

| Existing layout | Original/new insert speedup range | Original/new query speedup range |
|---|---:|---:|
| ByteSplitBloomFilter | 4.252–8.233× | 3.715–9.325× |
| FastPatternBF | 0.946–2.201× | 0.981–1.829× |

Ratios below 1 mean a regression versus the same-process frozen original. All 27 cases preserve existing output checksums, false-positive counts and bitmap bytes exactly.

For the two new layouts, the following table compares the faster of Word64/Split16 per case against FastFilter ARM only. Boost is included in the primary screen, not this secondary screen.

| Query batch | Native wins | Within ±3% | Native losses | Query speedup range |
|---|---:|---:|---:|---:|
| 1 | 6 | 1 | 2 | 0.835–1.200× |
| 31 | 7 | 2 | 0 | 1.016–1.147× |
| 4096 | 9 | 0 | 0 | 1.051–1.655× |

## Correctness and build validation

- Native Apple Silicon: 23/23 CTest checks passed.
- ASan/UBSan: 23/23 checks passed, including portable fallback targets.
- Default ARM compiler target without `BF_NATIVE`: 23/23 checks passed.
- Rust: 48 tests passed. Existing four layouts agree with C++ on checksums, FPR counts and bytes in 24 workloads. Optional Range/K12 CLI parity also passed after upstream integration.
- Intel macOS targets cross-compiled successfully; they were not executed or timed.
- Mask oracles cover all 65,536 Split16 input codes, all 4,096 Word64 cyclic masks and ByteSplit signed-high/shuffle semantics. Bitmap, collisions, duplicates, tails, copies and parallel construction/query checks are retained in the test suite.

Validation logs are stored as `validation-*.txt`. The parallel before/after-padding CSVs are exploratory one-seed screens; serial controls varied too much to attribute a speedup to padding. They are excluded from the primary performance claim.

## Limits and reproducibility

- This machine is an Apple M5 Pro with 48 GiB RAM and 128-byte hardware cache lines. Other M-series and Intel Macs have not been timed. macOS scheduling and clock variation remain; cores were not pinned.
- The 19-configuration Boost 1.92 screen selected five external leaders, then FastFilter’s pinned ARM implementation was added. The final shortlist is not a survey of every current Bloom filter library.
- FastFilter ARM exposes Add/Find but its AddAll is only declared; its wrapper uses its real public per-key methods. Boost uses its public iterator batch APIs. Neither upstream implementation was patched.
- Word64 and Split16 are new C++ layouts with different bitmaps. ByteSplit’s NEON path and FastPattern’s prefetch retain their existing mappings. The Rust implementation has not received the new layouts.
- `confirmation.csv` contains all 195 primary rows, including losses and allocation/hash-inclusive timing. `confirmation.json` records binary hash, commands, hardware and compiler. Earlier screens and rejected prefetch/unroll alternatives remain alongside it.

Run `python3 experiments/2026-10-29-mac-neon/run_confirmation.py` after building the local confirmation CMake project. Run this script to regenerate the tables. See `docs/mac-bulk.md` for build and API instructions.
