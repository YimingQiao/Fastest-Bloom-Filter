# Rust FastPattern masked-tail experiment

This isolated experiment changes AVX512 query tails without changing insertion or filter bitmaps. Production files are unchanged. `native-lib-before.rs` is the exact native Rust source at the revision and SHA in `base.json`; `isolation.patch` removes unrelated modules only. The original two-variant crate and its binary remain separate from the later three-variant crate.

`FastPatternBefore` is the original kernel. `FastPatternMaskedTail` uses a masked eight-u64 input load, paired-sector masked gather and masked low-u32 output for every remaining four to seven keys. `FastPatternGroupedTail` requires a preceding eight- or sixteen-key vector group (`i != 0`), preserving scalar handling for standalone four-to-seven-key calls. At most three remaining keys stay scalar. The instructions require AVX512F, without AVX512VL.

The initial 56-workload / 112-row screen is retained under `initial/`, including all regressions. Always-masked tails improve prehashed standalone queries but substantially regress hash-plus-query for large filters at batches four through seven. The grouped policy was selected before the confirmation seeds were run. Sensitivity to scratch-store forwarding is an inference, not established instruction-level causality.

`protocol.json` records the initial design. `selected-protocol.json` records the later policy and independent seeds 1019/4093 before confirmation. The selected matrix includes both requested 8/16 bits per key (actual 16/32), key counts 2^16/2^24, batches 1/3/4/7/8/15/31/63/4096, five repetitions, 2^22 queries, 50% hits and all-at-once insertion. Independent calibration is disabled because filter bitmaps do not change; paired measured false positives, full query checksums and actual bytes must match in every workload. The third row retains the rejected always-masked policy as a control.

Each runner shuffles filter order within the shared process through the common harness, uses identical inputs, checks full timed query outputs after the first prehashed and first hash-plus-query repetition outside timers, and rejects source/binary drift. `summarize.py` reports median paired-seed speedup ratios and their minimum/maximum; no regressing scenarios are dropped. CPU affinity, compiler and immutable source/binary hashes are recorded in each result directory metadata; `host.json` records machine identity after the initial screen and before confirmation. These are experiments on this machine, not global speed claims.

## Correctness

Both candidate policies pass six tests each in normal, `disable-avx512`, and AddressSanitizer builds. The added focused test compares full outputs to the frozen original and scalar membership, tests lengths 0..131 plus 4096/4097/4100/4103, sixteen input offsets and three bitmap sizes/densities (6,528 combinations per policy), checks output guard words, inserted-key no-false-negative behavior and bitmap immutability. Input allocations end at the logical tail. The other five tests are copied core tests. Actual logs are retained; selected commands are in `selected-validation-commands.json`.

## Reproduction

Run from the repository root. Fresh output directories are required; preserve prior evidence.

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 env CARGO_TARGET_DIR=/tmp/fastest-bf-rust-pattern-tail-selected RUSTFLAGS='-C target-cpu=native' cargo build --release --manifest-path experiments/2026-10-29-rust-pattern-tail/benchmark-selected/Cargo.toml
flock /tmp/fastest-bf-socket1.lock taskset -c 3 python3 experiments/2026-10-29-rust-pattern-tail/confirm.py --mode confirmation --output experiments/2026-10-29-rust-pattern-tail/confirmation-reproduction
python3 experiments/2026-10-29-rust-pattern-tail/summarize.py experiments/2026-10-29-rust-pattern-tail/confirmation-reproduction/results.csv experiments/2026-10-29-rust-pattern-tail/confirmation-reproduction/summary.csv
```

Original build target: `/tmp/fastest-bf-rust-pattern-tail`. Selected build target: `/tmp/fastest-bf-rust-pattern-tail-selected`. The native, external-baseline and previous experiment binaries are not overwritten. Local `*.csv -text` attributes preserve exact archived bytes, and `!*.log` retains validation output.

## Confirmation result
The fresh-seed confirmation completed 72 workloads / 216 rows with identical actual bytes, measured false positives and full query checksums. Source and binary hashes matched before and after. The grouped policy improves batches 15/31 clearly and large-filter batch 63, while retaining some short-batch regressions. Production remains unchanged; promotion requires an explicit decision accepting or resolving these tradeoffs. The Rust result differs from the independent C++ experiment, so a C++ policy change should not be assumed to transfer unchanged.
The following are medians of the two paired-seed speedup ratios (`before / grouped`), not ratios of independently selected best runs. Values below 1 are regressions. All 36 selected scenarios and the rejected always-masked control are in `confirmation/summary.csv`, including per-seed ranges.
| Keys | Actual bits/key | Batch | Prehashed query speedup | Hash + query speedup |
|---:|---:|---:|---:|---:|
| 65,536 | 16 | 4 | 0.980× | 0.996× |
| 65,536 | 16 | 8 | 0.960× | 0.979× |
| 65,536 | 16 | 15 | 1.848× | 1.469× |
| 65,536 | 16 | 31 | 1.393× | 1.310× |
| 65,536 | 16 | 63 | 1.311× | 0.994× |
| 65,536 | 16 | 4096 | 1.009× | 0.997× |
| 65,536 | 32 | 4 | 0.983× | 0.996× |
| 65,536 | 32 | 8 | 0.974× | 0.989× |
| 65,536 | 32 | 15 | 1.857× | 1.455× |
| 65,536 | 32 | 31 | 1.273× | 1.328× |
| 65,536 | 32 | 63 | 1.208× | 1.000× |
| 65,536 | 32 | 4096 | 1.004× | 0.997× |
| 16,777,216 | 16 | 4 | 0.973× | 0.984× |
| 16,777,216 | 16 | 8 | 1.001× | 0.998× |
| 16,777,216 | 16 | 15 | 1.328× | 1.103× |
| 16,777,216 | 16 | 31 | 1.161× | 1.107× |
| 16,777,216 | 16 | 63 | 1.118× | 1.074× |
| 16,777,216 | 16 | 4096 | 1.014× | 1.005× |
| 16,777,216 | 32 | 4 | 0.948× | 0.984× |
| 16,777,216 | 32 | 8 | 1.017× | 1.015× |
| 16,777,216 | 32 | 15 | 1.330× | 1.101× |
| 16,777,216 | 32 | 31 | 1.176× | 1.129× |
| 16,777,216 | 32 | 63 | 1.116× | 1.079× |
| 16,777,216 | 32 | 4096 | 1.002× | 1.002× |

Batch 1/3 hash-plus-query controls range from 0.989× to 1.010×; batch 7 ranges 0.993× to 1.002×. The lowest median prehashed short-control speedup is 0.948× at large actual 32-bit batch 4; its individual paired-seed ratios span 0.906–0.991×. Do not describe unchanged source branches as guaranteed performance-neutral. Batch 4096 hash-plus-query ranges 0.997–1.005× across the four scenarios. No causal attribution to store forwarding was established.

Run `python3 experiments/2026-10-29-rust-pattern-tail/verify.py` to verify archived hashes, validation log counts and paired semantic invariants without benchmarking.
