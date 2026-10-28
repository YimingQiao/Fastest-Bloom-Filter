# Native layout scaling — 2026-10-28

Both new native layouts support exclusive parallel construction and parallel
immutable membership queries. This measures scaling against each layout's own
serial implementation, not a multithreaded victory over an external library.
Overlapping insertion/query remains a separate FastPattern atomic API.

Each language has 24 cases and 96 rows: 16M/32M keys, 1/2/4/8 physical cores,
three seeds, and serial/partitioned modes for FourSector and Split64. Native actual
allocation is 16 bits/key (32/64 MiB bitmaps), with 2^22 prehashed queries, 50% hits
and three repetitions. CPU affinity is the first T CPUs in 2,4,6,8,10,12,14,16 on
one Xeon Platinum 8474C socket. C++ and Rust matrices ran serially. These tests use
the frozen native implementations before the subsequent short-batch query change.

Speedups below are medians of paired-seed ratios to the one-core serial row.
Build timing includes partitioning, scratch allocation and thread startup; initial
bitmap allocation/zeroing and source hashing are outside this parallel timer.
Query timing includes thread startup and output stores, with hashing excluded.
All inserted keys are checked, and complete query checksums match serial and
partitioned modes in every case. Three-seed medians are not guarantees on other
machines, sizes or query distributions.

| Language | Keys | Layout | 8-core build speedup | 8-core query speedup | Build ns/key | Query ns/key |
| --- | --- | --- | --- | --- | --- | --- |
| C++ | 16,777,216 | FourSector | 2.64× | 7.38× | 1.879 | 0.552 |
| C++ | 16,777,216 | Split64 | 2.27× | 7.41× | 1.717 | 0.578 |
| C++ | 33,554,432 | FourSector | 3.01× | 7.12× | 1.740 | 0.610 |
| C++ | 33,554,432 | Split64 | 2.53× | 6.97× | 1.618 | 0.645 |
| Rust | 16,777,216 | FourSector | 2.75× | 7.41× | 1.967 | 0.547 |
| Rust | 16,777,216 | Split64 | 2.30× | 7.60× | 1.901 | 0.571 |
| Rust | 33,554,432 | FourSector | 3.30× | 7.07× | 1.740 | 0.605 |
| Rust | 33,554,432 | Split64 | 2.69× | 7.17× | 1.692 | 0.643 |

Partitioning needs eight bytes per input hash plus aligned counters and worker
metadata, about 128/256 MiB scratch at these input sizes. It does not allocate one
bitmap per worker. C++ and Rust report their own partitioning data scratch bytes;
Rust's safe scatter-slice descriptors add a small amount. Allocator metadata,
thread launch bookkeeping, and OS thread stacks are excluded. The CSV retains
exact values and trial minimum/maximum times.

This stage does not compare atomic and exclusive-build semantics as interchangeable.
It also does not establish a speedup for tiny filters, where startup can dominate.

[C++ raw data/provenance](../results/2026-10-28-layout-parallel-cpp/),
[Rust raw data/provenance](../results/2026-10-28-layout-parallel-rust/),
[all 1–8 core summaries](../results/layout-parallel-summary.csv).

Reproduce with `scripts/run_parallel.py --filters FourSector,Split64` and the
recorded metadata arguments. Use `scripts/summarize_layout_parallel.py` to regenerate
this report. The frozen binary source revisions are recorded separately from any
later workspace changes.
