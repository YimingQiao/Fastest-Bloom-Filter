# Rust singleton API and entry-shape experiment

This experiment studies native public API code generation, not a new Bloom layout. Production sources and previous benchmark executables are unchanged. All variants preserve their family's bitmap allocation, insertion mapping and returned answers.

The frozen primary Rust executable (`primary-asm/provenance.json`) forwards ByteSplit and Split64 through a six-byte GOT-indirect tail jump to their public `lookup_hashes`. Both public functions save six callee-saved registers and reserve 72 stack bytes before the singleton/backend checks. This is an additional branch, **not an additional call/return pair**. The primary Bloomsday wrapper contains its SIMD loop directly and has no callee-saved pushes. These observations suggest API costs; they do not assign the whole C++/Rust performance gap to one instruction or compiler choice.

## Controls and stages

The original `benchmark/` crate retains all eight prior native/external/experimental configurations and adds four controls. `ByteNativeSingleApiV1` and `SplitNativeSingleApiV1` use each original library's public `contains_hash` for length one and its original bulk API otherwise. `ByteInlineLookupV1` and `SplitInlineLookupV1` use a separate copied crate with only `#[inline]` added to the public bulk method. `inline.patch` contains those two source changes; package names distinguish the copy from the unchanged production dependency.

Byte's public singleton API retains its SIMD mask/address construction. Split's public singleton API uses scalar source, which the native compiler auto-vectorizes to AVX512DQ `vpmullq` and shifts in this executable. **The Split controls therefore change the generated kernel as well as entry overhead.** Portable builds remain compiler-target dependent; the scalar source does not imply scalar machine instructions.

The first screen (`initial/`) completed eight workloads and 96 rows: key counts 2^16/2^25, requested 8/16 bits per key (actual 16/32), batches 1/4096, seed 42, 2^22 queries, five repetitions, 50% hits, full-input insertion and 2^24 independent calibration negatives. Native SingleApiV1 improved small Byte singleton prehashed queries by 1.264× and hash plus query by 1.176×. Large Byte gains were 1.124–1.142× prehashed but only 1.003–1.034× including hashing. At batch 4096, small Byte hash plus query regressed 2.2–3.2%. Inline-only removed the forwarding branch but retained the six-register prologue and did not deliver the same gain. Every result and regression is retained in `initial/summary.csv`.

These initial results are API/codegen evidence, not a final claim against Bloomsday: its original adapter still used a generic loop for singleton queries. The later `benchmark-strong/` therefore retains all twelve configurations and adds equal `BloomsdaySingleApiV1`/`FastbloomSingleApiV1` controls using their existing public singleton APIs, plus two production-shaped candidates. The registry has sixteen configurations.

`ByteShortEntryV2` and `SplitShortEntryV2` use a separate copied `native-short/` crate. Their public `#[inline] lookup_hashes` only checks lengths, uses existing `contains_hash` at length one, and otherwise calls a private `#[inline(never)]` copy of the complete original bulk method. The original body's assertion and singleton branch are retained, even though redundant through this entry, to isolate entry shape from edits to the bulk implementation. `short-entry.patch` shows the change. Split retains the scalar-source kernel distinction above. This design transfers the experiment to the shape of a public library API without changing production code.

The strong binary has no callee-saved pushes in either ShortEntryV2 singleton wrapper. Its Byte mask still uses signed16 high multiplication, byte shuffle and test; Split is auto-vectorized scalar source. The inline-only wrappers still have six pushes. Exact regions, relocations and binary hashes are archived in `strong-asm/`, with the verified map in `verified-map.json`.

## Validation and confirmation protocol

The first controls pass three focused tests under normal, `disable-avx512`, and AddressSanitizer builds. The strong controls pass five focused tests under each mode. Tests compare complete original/control outputs, payload sizes, duplicate/collision insertion behavior, all inserted keys, lengths 0..131 plus4096/4097, eight input offsets, output guard words, and mismatched-length rejection before writes. Tests include both external singleton controls and both production-shaped entries. Actual logs and commands are retained.

Strong semantic smoke completed twelve workloads /192 rows across both allocations and batches 1/3/4/8/31/4096. All sixteen exact registry names ran. Corresponding family query checksums, measured false positives, calibration counts and bytes match. Smoke timings are incidental and unclaimed.

`strong-protocol.json` preregisters the held-out matrix before it runs: seeds 7919/104729, key powers 16/25, requested 8/16, batches 1/4096, query power 22, five repeats, 50% hits, full insertion and calibration power 24. It selects ten configurations: original/SingleApi/ShortEntry for Byte and Split, plus original/singleton for both external families. Earlier experimental layouts, other native layouts and inline-only controls remain registered and retain their original evidence; this confirmation focuses on the entry-shape question. No original corresponding native or external path is hidden. Native promotion is a separate decision after all regressions are reviewed.

Both runners use the common strict filter selector, seeded same-process job order, shared workload and timing boundaries, full warm-up no-false-negative checks, and full first-repetition query validation outside the timers. Original and strong source/binary freezes are separate. The runners verify source/binary identity before and after each matrix and exact family outputs/bytes/calibration fields. Whole-input insertion is independent of query batch size.

All heavy work is pinned to CPU2 under `/tmp/fastest-bf-socket0.lock`, after the parent releases that socket. The machine is a Xeon Platinum 8474C; the native executable uses Rust 1.92/LLVM 21, thin LTO, one codegen unit and `-C target-cpu=native`. Normal/feature/sanitizer tests use their recorded separate target directories. The earlier primary results retain their original scope and are not replaced by this exploratory matrix.

## Reproduction

Use a fresh output directory and preserve old evidence. Compiler/CPU/source changes require a new freeze and clearly named series; do not rewrite archived hashes to make a different executable pass.

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 env CARGO_TARGET_DIR=/tmp/fastest-bf-rust-single-api-strong RUSTFLAGS='-C target-cpu=native' cargo build --release --manifest-path experiments/2026-10-29-rust-single-api/benchmark-strong/Cargo.toml
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-rust-single-api/run-strong.py --mode confirmation --output experiments/2026-10-29-rust-single-api/confirmation-reproduction
python3 experiments/2026-10-29-rust-single-api/summarize-strong.py experiments/2026-10-29-rust-single-api/confirmation-reproduction/results.csv experiments/2026-10-29-rust-single-api/confirmation-reproduction/summary.csv
```

The original target is `/tmp/fastest-bf-rust-single-api`; the strong target is `/tmp/fastest-bf-rust-single-api-strong`. Native and external primary executables are never rebuilt by these commands. CSV attributes preserve exact archived bytes and logs are explicitly unignored. Dependencies remain pinned to Fastbloom 0.17.0 and Bloomsday 11f16a91a1c8a20344cd263e908f957dac7cf5d0 in Cargo manifests/locks. Apache-derived ByteSplit attribution and package-local licenses are retained in both copied native crates.

## Held-out result and regression guard

The held-out run completed sixteen workloads / 160 rows with source and binary hashes unchanged. Both ShortEntryV2 entries reproduce their family's full checksums, allocation and calibration counts. The table reports median paired-seed speedup (`original native / ShortEntryV2`); all paired minima/maxima and external controls remain in `confirmation/summary.csv`. Values below 1 are losses.

| Keys | Actual bits/key | Batch | Byte prehashed | Byte hash + query | Split prehashed | Split hash + query |
|---:|---:|---:|---:|---:|---:|---:|
| 65,536 | 16 | 1 | 1.263× | 1.176× | 1.109× | 1.067× |
| 65,536 | 16 | 4096 | 1.008× | 0.997× | 1.012× | 1.018× |
| 65,536 | 32 | 1 | 1.264× | 1.176× | 1.097× | 1.086× |
| 65,536 | 32 | 4096 | 1.005× | 0.998× | 1.001× | 1.004× |
| 33,554,432 | 16 | 1 | 1.129× | 1.035× | 1.170× | 1.033× |
| 33,554,432 | 16 | 4096 | 1.009× | 1.011× | 1.009× | 1.003× |
| 33,554,432 | 32 | 1 | 1.110× | 1.019× | 1.190× | 1.017× |
| 33,554,432 | 32 | 4096 | 1.002× | 0.991× | 1.003× | 1.000× |

At small actual 16 bits/key and batch 1, experimental Byte ShortEntryV2 measures about 2.92 ns prehashed and 5.52 ns including hashing, versus the symmetric Bloomsday singleton control's 3.24 ns and 5.86 ns. Both satisfy the loose 1% FPR ceiling. This scoped experimental improvement does not imply a general fastest filter or a win at stricter FPR limits. The quality table pools only one original-family row per seed and allocation: repeated controls and batch sizes are not additional independent calibration samples. `confirmation/quality.csv` retains the pointwise one-sided 95% Wilson bounds; they are not simultaneous selection guarantees.

The subsequent four-row guard retained the two original native paths and both V2 entries, avoiding redundant slow external construction. Sixteen workloads / 64 rows used seed 42, batches 3/4/8/31, the same two key counts/allocations, query power 22, five repetitions and calibration power 24. All semantic checks and source hashes pass. It nevertheless exposes material short-batch regressions: small Byte batch 3 prehashed speedups 0.929–0.932× and hash-plus-query 0.958–0.961×; small Split batch 3 approximately 0.95× and 0.967×. Small batches 4–31 often lose 2–4.5% in pure query. Large actual 16 Split batch 3 hash plus query is 0.940×. Every case remains in `guard/summary.csv`.

**V2 is not promoted.** Its positive singleton evidence and all regressions remain intact. The next isolated hypothesis is to keep the checked inline public entry but remove redundant checks and the unreachable singleton branch from the private bulk body; actual kernels for lengths other than one must retain their semantics. That hypothesis requires separate source freeze, validation and timing. Production remains unchanged at this stage.

`native-before/` archives all fifteen original native package files, including complete source/binaries/support and licenses, exactly as git `c4b6a08`; `before-source-provenance.json` verifies every byte and maps old root paths to their snapshots. Original/strong frozen runners intentionally reject a changed production source tree. A later core integration must use this archived original for port-cost controls rather than silently pointing an old name at new source.


## Later isolated V3 screen

[V3 report](README-v3.md) retains the CPU3 same-process original/V2/V3 guard. It did not resolve Byte's short-batch regressions and was not promoted. Earlier [V2 evidence](README-v2.md), source snapshots and binaries remain unchanged.
