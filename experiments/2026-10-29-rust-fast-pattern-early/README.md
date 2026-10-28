# Native Rust FastPattern tiny-query dispatch — 2026-10-29

The native public lookup now handles zero to three FastPattern hashes through
its existing scalar membership method before SIMD/backend/cache-size dispatch.
The legacy Sectorized type is unchanged. Insertion, allocation and mask dictionaries
are unchanged. The analogous C++ change was first confirmed independently in
[small-batch-kernels](../2026-10-28-small-batch-kernels/).

This is an alternating **two-executable** production before/after comparison,
not a same-process experiment. Versions are shuffled within each workload using
fixed order seed 2053; all 48 rows and 24 commands per version are retained. CPU 2,
Xeon 8474C, Rust 1.92, `-C target-cpu=native`, 2^22 queries, 50% hits, five repetitions,
full-input insertion batches, seeds 2053/4099. Ratios are medians of paired-seed
before/after nanoseconds per key. No concurrent benchmark ran on socket 0.

| Keys | Actual bits/key | Batch | Pure query speedup | Hash+query speedup |
| --- | --- | --- | --- | --- |
| 65,536 | 16 | 1 | 1.215× | 1.091× |
| 65,536 | 16 | 3 | 1.196× | 1.084× |
| 65,536 | 16 | 4096 | 0.996× | 0.990× |
| 65,536 | 32 | 1 | 1.216× | 1.092× |
| 65,536 | 32 | 3 | 1.199× | 1.086× |
| 65,536 | 32 | 4096 | 0.994× | 0.990× |
| 16,777,216 | 16 | 1 | 1.063× | 1.098× |
| 16,777,216 | 16 | 3 | 1.096× | 1.035× |
| 16,777,216 | 16 | 4096 | 0.994× | 1.002× |
| 16,777,216 | 32 | 1 | 1.106× | 1.098× |
| 16,777,216 | 32 | 3 | 1.076× | 0.980× |
| 16,777,216 | 32 | 4096 | 0.999× | 1.006× |

Single-key end-to-end speedup is about 1.09–1.10× in this matrix. Most batch 3 cases
improve, but the 64 MiB bitmap loses about 2% end to end. Long batches are near parity;
one pure-query seed varies more, so this is not evidence of a long-batch gain.
It does not establish a win over external filters.

Every paired full-query checksum, false-positive count, negative count and bitmap
allocation matches. Both normal and `disable-avx512` unit suites pass 22 tests after
the change. Those test outputs were observed in the session, not fabricated as
retained logs. `confirmation/metadata.json` retains exact commands, compiler/CPU,
full executable hashes and launch workspace patch. `lib-before.rs` is the exact
pre-change library source; `lib-after.rs` snapshots the changed source. Other
native layout source files were unchanged between the two builds.

Reproduce by building the before/after core source revisions with identical
native Rust flags, then pass both executables to `run.py --before ... --after ...
--output ... --cpu 2`. Paths are resolved from the repository root. Frozen baseline
binary was copied to `build/early-rust-base/compare_benchmark` before the edit.
