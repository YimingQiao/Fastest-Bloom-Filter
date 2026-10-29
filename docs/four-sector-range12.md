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

## Rust API

The optional native Rust type uses the same top24 physical-line mapping and twelve probes. It preserves the safe SingleLine scalar implementation and the existing batch dispatch. Current default types and benchmark selection remain unchanged.

```rust
use fastest_bloom_filter::{hash64, FourSectorRange12BloomFilter};

let mut filter = FourSectorRange12BloomFilter::with_byte_budget(3 * 1024 * 1024).unwrap();
let hashes: Vec<u64> = (0_u64..100_000).map(hash64).collect();
filter.insert_hashes_parallel(&hashes, 7);

let mut answers = vec![0_u32; hashes.len()];
filter.lookup_hashes_parallel(&hashes, &mut answers, 7);
assert!(answers.iter().all(|&answer| answer == 1));
```

`new(expected_keys, bits_per_key)` also accepts a real expected item count. Byte budgets floor to complete 64-byte lines within 128 bytes through 256 MiB. `size_in_bytes()` reports actual bitmap backing capacity; `build_workers(n, requested)` and `build_scratch_bytes(n, requested)` report effective workers and explicit partition scratch. Request 0 follows available parallelism, while small inputs can remain serial. Caller buffers, allocator bookkeeping and thread stacks are separate.

Insertion requires an exclusive `&mut self`. The dedicated scheduler partitions the actual physical line, supports non-power-of-two line counts and three/seven-worker boundaries, and preserves prior batches. Immutable queries can run concurrently after construction. Parallel methods include partitioning or chunking and thread creation/join in the public call. Hash slices contain uniformly distributed prehashed u64 values, and every query output slice must have exactly the input length.

The [actual native packaging proof](../experiments/2026-10-29-native-rust-k12-integration-plan/proof-final/REPORT.md) passes 40 normal library tests, six disabled-AVX512 K12 tests, six ASan K12 tests and 36 full native/reference fixtures on seven physical cores. Actual public pure/fused loops retain one line bounds check and no hot per-key helper call; scalar stack frames and batch/thread costs remain. This proof contains no throughput or new FPR measurements.

The [SingleLine internal comparison](../experiments/2026-10-29-rust-k12-single-line-analysis/INTERPRETATION.md) retains 85/96 query wins and 11 regressions against original K12, plus 75/96 query losses and all 96 construction losses against Range. Its inputs were already seen, and it does not establish new external leadership. The C++ multithread results above do not establish Rust multithread speed. The optional Rust API is a capacity/bulk-query choice with explicit singleton and construction tradeoffs.

## Ordinary benchmark selection

Both languages' ordinary benchmark runners accept this layout explicitly:

```sh
python3 scripts/run_comparison.py --executable build/native/compare_benchmark \
  --output-dir results/k12-cpp --cpu 2 --key-powers 16 --bits-per-key 24 \
  --filters FourSectorRange12BloomFilter
python3 scripts/run_parallel.py --executable rust/target/release/parallel_benchmark \
  --output-dir results/k12-rust-parallel --cpus 3,5,7 --threads 1,3 \
  --key-powers 16 --bits-per-key 24 --filters FourSectorRange12
```

Choose allowed physical CPU IDs for your machine. Either runner accepts the corresponding C++ or Rust executable. Empty comparison selection keeps its historical default suite; parallel default remains FastPattern, and `--filters all` retains the original four families. Name the optional layout explicitly. Invalid names and optional budgets below 128 bytes fail before workload allocation or CSV output. The CLI also retains its older global size limit (`n * bits_per_key < 2^31`), so it does not cover the API's inclusive 256 MiB endpoint. These commands use the ordinary benchmark timing contract, separate from the frozen research experiments.
