# Split64 with an explicit byte budget

`Split64RangeBloomFilter` is an optional native C++/Rust filter for capacities
between powers of two. It places eight probes in one 64-byte cache line and
uses multiply-high addressing across the allocated lines. Its bitmap mapping
is different from `Split64BloomFilter`, including at equal allocations.

The byte-budget constructor accepts 128 bytes through 256 MiB and rounds down
to a complete cache line. It never rounds above the supplied ceiling. The
`n, bits_per_key` constructor uses `floor(n * bits_per_key / 8)` as that ceiling,
so it differs from the older types' strict next-power-of-two sizing rule.
Inspect the actual size returned by the object; allocator metadata and the
small inline object are separate from its reported bitmap storage.

```cpp
#include "parallel_split64_range_bloom.h" // compile/link with -pthread

bloom_filters::ParallelSplit64RangeBloomFilter filter(
    bloom_filters::RangeBytes{3 * 1024 * 1024});
filter.InsertParallel(num_keys, hashes, 8);
filter.LookupParallel(num_queries, query_hashes, out, 8);
// The serial type is Split64RangeBloomFilter in split64_range_bloom.h.
```

```rust
use fastest_bloom_filter::Split64RangeBloomFilter;

let mut filter = Split64RangeBloomFilter::with_byte_budget(3 * 1024 * 1024)?;
filter.insert_hashes_parallel(&hashes, 8);
filter.lookup_hashes_parallel(&query_hashes, &mut out, 8);
```

Inputs are uniformly hashed 64-bit keys. Insertion is incremental and duplicate
insertion is idempotent. Construction requires exclusive access; immutable
queries can run concurrently. The builder partitions complete physical cache
lines, including when the line count is not divisible by the worker count.
It does not allocate a bitmap per worker. `BuildWorkers` / `build_workers` and
`BuildScratchBytes` / `build_scratch_bytes` expose the effective build workers
and explicit scratch estimate. Requested workers of zero use each language's
existing automatic-selection behavior.

This type supplies another capacity choice. It does not imply that its queries
or construction are faster at equal allocation. The
[complete Rust public-probe comparison](../experiments/2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/report/INTERPRETATION.md)
retains those losses, and the
[native scaling comparison](../experiments/2026-10-29-split64-range-native-scaling-analysis/report-final/REPORT.md)
reports its parallel API separately from external-query rankings.

The integrated kernels and partitioning come from the
[validated native prototype](../experiments/2026-10-29-split64-range-native/VALIDATION.md).
Packaging changes rename the C++ serial type and headers, export the Rust type
from the main crate, and remove the experiment-only Rust bitmap-copy accessor.
Independent full-bitmap, boundary, tail, and serial/parallel tests accompany
the public implementation. Native integration validation is recorded separately
from the prototype's performance evidence.
