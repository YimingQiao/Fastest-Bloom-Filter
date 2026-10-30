# Design and API

The library stores uniformly distributed 64-bit hashes. Hash the original key consistently before insertion and lookup. A zero result means absent; one means possibly present. The filters are append-only and do not support deletion or automatic resizing. Completed insertions have no false negatives when the same hashes are queried.

## FourSectorRange12

The line index is `floor((hash >> 40) * line_count / 2^24)`. Other hash bits select four distinct 32-bit words within that line and three-bit masks within each word. A 16-entry pattern dictionary and rotations generate the masks. SIMD batch queries process multiple independent keys. This layout targets bulk throughput; the twelve probes do not themselves guarantee an error rate.

| Operation | C++ | Rust |
| :--- | :--- | :--- |
| Construct with a byte limit | `FourSectorRange12BloomFilter(RangeBytes{bytes})` | `FourSectorRange12BloomFilter::with_byte_budget(bytes)` |
| Insert hashes | `Insert(count, hashes)` | `insert_hashes(&hashes)` |
| Query into dense 0/1 output | `Lookup(count, hashes, output)` | `lookup_hashes(&hashes, &mut output)` |
| Query one hash | `ContainsHash(hash)` | `contains_hash(hash)` |
| Actual bitmap allocation | `SizeInBytes()` | `size_in_bytes()` |

C++ types live in `bloom_filters`; Rust exports types from `fastest_bloom_filter`. C++ count parameters in serial operations are `uint32_t`; split larger inputs into calls. Rust requires output slices of exactly the input length. Empty batches are supported. The API accepts arbitrary batch lengths; the published performance report evaluates only 4096.

## Byte budgets

FourSectorRange12 and Split64Range support budgets from 128 bytes through 256 MiB, rounded down to complete 64-byte lines. They also accept `(expected_keys, bits_per_key)` constructors. At 65,536 keys, a literal `196608`-byte budget uses 24 bits/key. Check reported allocation rather than inferring it from a constructor argument.

FastPattern, FourSector, Split64 and ByteSplit retain their historical strict-next-power-of-two sizing. At a power-of-two boundary, actual bits/key can be twice the requested value. They use different mappings from the range layouts. Bitmaps are not interchangeable, and no stable serialization format is promised.

The reported filter size covers bitmap backing allocation. Input hashes, query output, allocator metadata and OS thread stacks are separate. Parallel construction also needs explicit partition scratch, approximately eight bytes per input hash plus worker metadata. Inspect `BuildScratchBytes(n, workers)` in C++ or `build_scratch_bytes(n, workers)` in Rust, along with the effective worker count.

## Parallel execution

C++ provides wrappers in `parallel_bloom.h`, `parallel_layout_bloom.h`, `parallel_split64_range_bloom.h`, and `parallel_four_sector_range12_bloom.h`. Rust provides parallel methods directly on the filter types.

Construction partitions by each filter's actual physical cache-line index. A worker exclusively owns each assigned line, including all of its words. Non-power-of-two line counts and worker counts are supported. Additional construction calls preserve previous insertions. Public parallel methods include partitioning or query chunking and thread creation/join. Tiny inputs may use fewer workers; a request of zero selects available parallelism.

Construction requires exclusive mutation. After it returns, immutable queries may overlap. Synchronize independent writes, writes overlapping queries, and destruction. Rust's insertion methods require `&mut self`. The separate AtomicFastPattern implementation supports atomic updates; a query during an unfinished insertion can miss it, and its relaxed atomics do not publish application data.

## Choosing a layout for predicate transfer

For bulk predicate filtering, measure the full cost of hashing, membership queries, and processing false positives. FourSectorRange12 at 24 actual bits/key is a strong starting point when a 0.01% target matters. The published 4096-batch Rust large-table measurement slightly favors Split64Range. A looser target may favor the smaller FastPattern, FourSector, or Split64 configurations in the performance report.

These kernel results do not measure join execution, selection-vector compaction, a complete robust predicate transfer pipeline, or adversarial inputs. Choose using the actual key distribution and downstream false-positive cost.
