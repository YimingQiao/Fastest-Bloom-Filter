# Benchmark records — 2026-10-28

The [historical report](../docs/results-2026-10-28.md) uses 2,772 aggregate rows
across the original main, external, scaling, and ablation runs listed below.
New modern-baseline results are recorded separately; they are not silently folded
into that historical total.
Every directory contains `results.csv`, individual case output, `metadata.json`,
`source.patch`, and CMake compile commands when applicable. Metadata contains exact
commands, source revision, binary SHA-256, CPU/compiler details, and Rust build
fingerprints. Empty patches mean no tracked source changes at measurement start.
For a frozen executable, `binary_source_revision` identifies the compiled sources;
`revision`, `status` and `source.patch` retain the workspace state at launch.
The binary SHA-256 is retained independently of later source edits.

| Modern directory | Purpose | Cases | Rows |
| --- | --- | --- | --- |
| [modern-screen](2026-10-28-modern-screen) | 43 C++ configurations, exploratory seed 42 | 18 | 774 |
| [page-aes-screen](2026-10-28-page-aes-screen) | PageBloom optional AES hashing, separate cohort | 4 | 28 |
| [modern-confirmation-cpp](2026-10-28-modern-confirmation-cpp) | Frozen 13-candidate large-batch shortlist, three new seeds | 18 | 234 |
| [modern-confirmation-rust](2026-10-28-modern-confirmation-rust) | Five native Rust candidates on the same confirmation inputs | 18 | 90 |

See the [modern confirmation report](../docs/modern-confirmation-2026-10-28.md).
Generate its rankings with `scripts/rank_external.py` at 16/32 bits/key and zero
allocation slack, then render the report/figure with `scripts/summarize_modern.py`
(matplotlib required). Single-key screening and new-layout scaling are separate
stages and must not be represented as completed by the large-batch result.

| Directory | Purpose | Cases | Rows |
| --- | --- | --- | --- |
| [cpp](2026-10-28-cpp) | Original nine filters + FastPattern, native AVX-512 | 135 | 1,350 |
| [rust](2026-10-28-rust) | Two independent native Rust layouts, AVX-512 | 135 | 270 |
| [parallel-cpp](2026-10-28-parallel-cpp) | Serial / partitioned / atomic, 1–32 cores | 54 | 162 |
| [parallel-rust](2026-10-28-parallel-rust) | Same scaling matrix in Rust | 54 | 162 |
| [small-batches-cpp](2026-10-28-small-batches-cpp) | Batch sizes 1 and 31 | 36 | 108 |
| [small-batches-rust](2026-10-28-small-batches-rust) | Same small-batch matrix in Rust | 36 | 72 |
| [avx2-cpp](2026-10-28-avx2-cpp) | Dedicated AVX2 kernels, GCC | 27 | 81 |
| [avx2-rust](2026-10-28-avx2-rust) | Dedicated AVX2 kernels, Rust x86-64-v3 | 27 | 54 |
| [external](2026-10-28-external) | Native Rust FastPattern / pinned fastbloom 0.17.0 | 54 | 108 |
| [before-alignment-cpp](2026-10-28-before-alignment-cpp) | Initial parallel histograms, padded but not aligned | 54 | 162 |
| [before-alignment-rust](2026-10-28-before-alignment-rust) | Same initial experiment in Rust | 54 | 162 |
| [before-avx2-cpp](2026-10-28-before-avx2-cpp) | Original scalar fallback in AVX2 build | 27 | 81 |

The `before-*` directories were renamed when archiving ablations; metadata retains
the original command paths. Their measurements are not silently replaced.
The first C++ native run recorded unpublished local commit `0dc51d7`; its published
equivalent is `fa8fe3d`. Only an identical CI YAML was relocated during that amendment,
with no compiled-source changes. The measured revision is preserved, and metadata
adds the published equivalence note. Later runs use subsequent recorded revisions.

Regenerate tables with `python3 scripts/summarize_results.py`. Regenerate figures
with `python3 scripts/plot_results.py` (matplotlib 3.10 tested). The table generator
uses only Python's standard library. See the root README for benchmark commands.
The external adapter has a separate lockfile and does not add a core-library dependency.
