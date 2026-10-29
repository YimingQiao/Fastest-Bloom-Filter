# Optional FourSectorRange12

`FourSectorRange12BloomFilter` is an optional twelve-probe layout with four32-bit sectors in one64-byte line. It supports arbitrary whole-line capacities and consumes uniformly distributed64-bit hashes. It preserves the tested experimental single-thread kernel. It does not change the default filter or benchmark selection.

```cpp
#include "four_sector_range12_bloom.h"
#include "parallel_four_sector_range12_bloom.h"

// A literal byte budget, rounded down to complete64-byte lines.
bloom_filters::FourSectorRange12BloomFilter serial(
    bloom_filters::RangeBytes{3 * 1024 * 1024});
serial.Insert(count, hashes);
serial.Lookup(query_count, query_hashes, answers); // one uint32_t0/1 per input
bool present = serial.ContainsHash(one_hash);

bloom_filters::ParallelFourSectorRange12BloomFilter parallel(
    bloom_filters::RangeBytes{3 * 1024 * 1024});
parallel.InsertParallel(count, hashes, 7);
parallel.LookupParallel(query_count, query_hashes, answers, 7);
```

Both classes also accept `(expected_keys, bits_per_key)`. The permitted byte budget is128 bytes through256MiB. `SizeInBytes()` reports actual backing, and `BuildWorkers`/`BuildScratchBytes` on the parallel wrapper report effective construction workers and explicit partition scratch. Caller buffers, thread infrastructure and allocator bookkeeping are separate. The parallel wrapper retains the existing worker policy and includes partitioning and thread creation in its public operation; it introduces no bounded Split64 policy.

A key's line is `floor((hash >> 40) * line_count / 2^24)`. Construction owns exactly `floor(physical_line * workers / line_count)`, with logical boundaries `ceil(part * line_count / workers)`. Replacing this with a high32 hash partition is incorrect near boundaries. The wrapper uses the filter's actual line index and keeps every probe in its exclusive line. Non-power-of-two line counts and worker counts are supported.

Construction calls require exclusive mutation. After they return, immutable queries may run concurrently. A second construction batch preserves previous insertions. Overlapping writes and reads, simultaneous independent construction calls, resizing and destruction during access require external synchronization. This wrapper does not provide atomic concurrent insertion.

Measured evidence supports considering this layout for bulk queries. Its public-singleton and batch1 paths have substantial losses against Split64Range in the tested GCC/raw-u32 context; it is not a universal replacement. False-positive rates depend on the construction and query distribution. Neither twelve probes nor a requested bits-per-key value is a guaranteed error bound. Use the empirical quality results and actual allocation when choosing a layout.

The [fixed195-row multithread comparison](../experiments/2026-10-29-native-k12-parallel-analysis/INTERPRETATION.md)
now measures both a common eight-core executor against external public APIs and
actual native T1/T8 calls. K12 leads all24 tested strict24 query views, including
thread startup/join. The wider panel retains75 K12 external-query losses;
all72 same-byte construction comparisons against Range lose. Small parallel
builds also lose to serial. These seen-seed results support an optional query
choice, with distinct construction and singleton tradeoffs.
