# Native ByteSplit integration

`ByteSplitBloomFilter` promotes only the frozen `ByteSplit128SingleExperiment`.
The independent 32-bit-sector experiment is not promoted. The native header is
[include/byte_split_bloom.h](../../include/byte_split_bloom.h); its validated
SHA-256 is `46d285a1676b0613a0759d9786d2d8afe67d75b5fc64ca839305922627fa332f`.

The bitmap owns 64-byte-aligned lines, each containing four consecutive 16-byte
buckets. The upper hash word selects `(hash >> 32) & (bucket_count - 1)`; the
physical owner index is `bucket_index >> 2`. Allocation retains the shared
strict-next-power-of-two policy, including its 128-byte minimum. Reported storage
is the allocated vector capacity in bytes. Constructors reject zero bits/key,
overflow, and the existing maximum-capacity violation.

The mask preserves FastFilter Fixed16's signed high-16-bit multiply and byte
shuffle exactly, including zero lanes when a shuffle control's high bit is set.
It is not relabeled as eight independent probes. Scalar construction uses defined
32-bit signed multiplication followed by unsigned encoding. The SIMD path needs
SSSE3 and SSE4.1; AVX2/native builds also satisfy those requirements. The public
single-query branch bypasses the general loop; larger batches retain the frozen
one-key loop. SIMD byte offsets are computed as `bucket_index * 16` within the
owned allocation. An initial nested line/slot expression left extra address
instructions in Clang output; the flat byte view removes them while preserving
the typed ownership and complete bitmap. The initial source and successful
validation remain archived separately.

`ParallelByteSplitBloomFilter` uses the existing generic parallel wrapper. Build
workers own complete lines and perform ordinary collision-safe serial OR updates
within their partition. Queries may run concurrently after construction; serial
mutation and parallel construction require exclusive access. This layout does not
add an overlapping atomic-writer API. The existing atomic FastPattern API remains
separate. The wrapper's scratch accounting and worker limits apply unchanged.

The derived implementation retains Apache-2.0 attribution and its unchanged
upstream license under [third_party/FastFilter](../../third_party/FastFilter/).
The notice identifies the pinned FastFilter source, its Apache Impala credit,
and the local changes; the derived files are distinguished from the repository's
MIT code.

## Correctness evidence

[tests/test_byte_split.cpp](../../tests/test_byte_split.cpp) compares every bitmap
byte against both the frozen prototype and an independent scalar oracle. The
oracle computes signed-high multiplication by division rounded toward negative
infinity and uses a literal byte-shuffle table. Exhausting each low hash halfword
covers every possible signed16 lane input. Other coverage includes capacities
0/1/33/65539/1048576; requested 4/8/16 bits/key; insertion/query batches 1/8/31/4096;
all inserted keys; repeated hashes and same-line writes; exact tails 0–131 with
offsets 0–7; output guards; independent copies; 1/2/3/7-worker construction and
lookup; and overlapping immutable readers. Parallel queries exceed the wrapper's
minimum-work threshold, so the multithreaded branch is exercised.

All configurations below produce checksum `907593547723554833` and exact frozen
bitmap equality. Full commands, outputs, compiler flags, source hashes, and final
binary hashes are in [validation.json](validation.json):

- Clang native and baseline portable CMake targets.
- GCC baseline x86-64 with only SSSE3/SSE4.1 enabled and AVX disabled.
- Clang SSSE3/SSE4.1 with ASan and UBSan.
- GCC portable scalar with ThreadSanitizer.

No source changed during final validation. The final single-query assembly is
retained in [native-lookup-assembly.txt](native-lookup-assembly.txt). It contains
one shift by four for the bucket byte offset, without the former split line/slot
arithmetic. This is an assembly observation, not a performance claim.

Rust's independent native/external port also matches the C++ native checksum,
false-positive counts, and calibration counts over 25 workloads/75 rows; its
separate evidence is in
[the Rust parity archive](../2026-10-29-native-rust-byte-split/parity.json).

## Baseline controls and registrations

The optional C++ adapter adds `FastFilterFixed16SingleV1` and
`FastFilterSimdBlockSingleV1`. These are versioned public-API wrappers: for one
query they invoke the original adapter with literal length one, and otherwise
invoke its unchanged general path. The original rows remain registered because
the controls can improve prehashed timing while regressing hashing-plus-query.
The names avoid collisions with the frozen experiment's `...SingleControl`
aliases. No upstream masks, address reduction, or storage are rewritten.

The expanded 26-row FastFilter/Page standalone contract passes, including
original/control checksum, false-positive, calibration, and allocation equality
at batches 1/7/31. Combined registration now has four native and 52 external
configurations. Historical binaries keep their original counts.

## Port-cost measurement

The native source is frozen before measuring port cost. This directory's
`snapshot/`, `snapshot.json`, CMake target and `run.py` retain the exact harness,
native headers, frozen prototype, and adapter controls used for that check.
The requested comparison uses existing seeds 2053/4099, key powers 16/25,
requested bits/key 8/16, batches 1/31/4096, 50% hits, 2^22 queries and five
repetitions. Both original and single-entry FastFilter Fixed16 are included.
The separately preregistered primary-confirmation seeds are not used here.

Native integration and bitmap equality alone do not establish that the frozen
prototype's measured speed advantage survives the new ownership representation.
The port-cost data and subsequent primary confirmation must be interpreted
separately from the original exploratory results.

The completed [port-cost CSV](port-cost/timing.csv) has 96 rows (24 workloads,
four variants). Every native/frozen pair matches allocation, checksum and
false-positive count; every FastFilter original/control pair also matches.
[Metadata](port-cost/metadata.json) records no source changes during the run.
The following numbers are medians of paired ratios across seeds 2053/4099.
Native/frozen below one favors native; best-FastFilter/native above one favors
native. The FastFilter reference independently takes the faster original or
SingleV1 row for each metric and seed.

| Keys | Actual bpk | Batch | Native/frozen prehashed | Native/frozen hash+query | Best FastFilter/native prehashed | Best FastFilter/native hash+query |
| --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 | 1 | 0.997 | 1.000 | 1.085 | 1.008 |
| 65,536 | 16 | 31 | 0.997 | 1.012 | 1.133 | 1.044 |
| 65,536 | 16 | 4096 | 1.002 | 1.000 | 1.099 | 1.067 |
| 65,536 | 32 | 1 | 0.995 | 1.001 | 1.077 | 1.009 |
| 65,536 | 32 | 31 | 1.000 | 1.008 | 1.123 | 1.038 |
| 65,536 | 32 | 4096 | 1.012 | 1.005 | 1.086 | 1.057 |
| 33,554,432 | 16 | 1 | 1.005 | 0.999 | 1.060 | 1.036 |
| 33,554,432 | 16 | 31 | 1.011 | 1.003 | 1.051 | 1.042 |
| 33,554,432 | 16 | 4096 | 0.999 | 1.000 | 1.061 | 1.060 |
| 33,554,432 | 32 | 1 | 1.010 | 1.012 | 1.050 | 0.992 |
| 33,554,432 | 32 | 31 | 0.993 | 1.000 | 1.101 | 1.044 |
| 33,554,432 | 32 | 4096 | 0.999 | 0.998 | 1.100 | 1.111 |

The ownership change keeps measured query cost within approximately 1.2% of the
frozen prototype in this matrix. However, the small single-key hashing-plus-query
lead over the strongest Fixed16 control is only 0.8–0.9% in this harness/binary
context, and the large 32-bpk single-key case loses approximately 0.8%. The older
experiment's roughly 7.8% single-key raw-query lead must not be carried into this
cohort. These observations reinforce the need for unchanged-mask controls and
separate primary confirmation; two seed medians do not establish a universal win.

Construction also has a tradeoff: small-bitmap native hash+insert is approximately
3–4% slower than the prototype at actual 16 bpk and 10–14% slower at actual 32 bpk
across these groups. Large-bitmap construction stays near parity. Per-seed times
and construction ratios are retained in [summary.json](port-cost/summary.json).
No native source was tuned after seeing this port-cost result.

Reproduce into a new directory after building this directory's CMake target:

```sh
python3 experiments/2026-10-29-native-byte-split/run.py --mode speed \
  --output build/byte-split-port-reproduction --cpu 3 --key-powers 16,25 \
  --requested-bpk 8,16 --seeds 2053,4099 --hits 50 --batches 1,31,4096 \
  --query-power 22 --calibration-power 0 --repeats 5
```
