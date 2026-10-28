# Pinned external C++ Bloom filters

This optional build compiles the **shared** `src/compare_benchmark.cpp` harness with
unmodified upstream algorithms. No dependency is added to the native library.
Source archives are pinned by commit and SHA-256; see [upstreams.json](upstreams.json).
Full archives (including licenses) are downloaded into the build tree. CMake also
copies licenses and the pin manifest next to the executable.

```sh
cmake -S benchmarks/cpp-external -B build/cpp-external \
  -DCMAKE_CXX_COMPILER=clang++ -DBF_NATIVE=ON
cmake --build build/cpp-external -j
ctest --test-dir build/cpp-external --output-on-failure
python3 scripts/run_comparison.py --cpu 2 --output-dir results/external-cpp \
  --executable build/cpp-external/compare_benchmark \
  --key-powers 12,16,20,24 --bits-per-key 4,8,16 --hits 0,50,100 \
  --seeds 42,43,44 --batches 1,31,4096 --insert-batch 16777216
```

`--insert-batch` controls construction independently of query batch size. A value
at least as large as the key count invokes each candidate's builder once over the
whole input. This matters for upstream `AddAll`: repeatedly allocating its scratch
buffer for tiny query-sized insert chunks is a different workload. All timed
scratch allocation, initialization, and partitioning remains included in insertion.
Bitmap allocation alone is the `filter_bytes` field. AddAll adapters expose
`BuildScratchBytes()` for their exact explicit scratch allocation per call; the
harness records it separately from its hash scratch. Allocator metadata is excluded.
Fixed32 uses `(1 + bucket_count/16384) * (16384*sizeof(uint64_t)+sizeof(int))`
bytes, and classical AddAll uses
`(1 + word_count/32768) * (32768*sizeof(uint32_t)+sizeof(int))` bytes.

## Algorithms and API contract

| Prefix | Upstream algorithm | Timed input |
| --- | --- | --- |
| `FastPatternBF` | This project's native filter | Common prehashed u64 |
| `FastFilterSimdBlock` | Power-of-two split-block Bloom, eight 32-bit lanes | Common prehashed u64 |
| `FastFilterFixed16` / `Fixed32` / `Fixed64` | FastFilter's fixed 16/32/64-byte block variants | Common prehashed u64 |
| `FastFilterClassicK` | Ordinary Bloom, explicit K=4/6/8/11/16/22 | Common prehashed u64 |
| `...Branchless` | Upstream three-probe initial branchless query variant | Common prehashed u64 |
| `...Bulk` | Unchanged upstream `AddAll` builder; same query algorithm | Common prehashed u64 |
| `PageBloom{4,6,8}{Default,Compact}` | PageBloomFilter, fixed probe count and page policy | Raw 8-byte little-endian integers |

FastFilter exposes a public hash-family template parameter. The adapter supplies
an identity functor because the harness already generates common 64-bit hashes.
This changes the chosen hash-family policy, not the upstream probe algorithms.
It avoids a randomized second hash pass and makes inputs identical to native BF.
`hash_lookup_ns` and `hash_insert_ns` include the common hash finalizer for these rows.
The adapters prevent copying/moving upstream owning objects; benchmark construction
uses C++17 guaranteed copy elision.

PageBloom's public API always hashes raw bytes internally. Its rows therefore
report **`nan` for prehashed `insert_ns`, `allocate_insert_ns`, and `lookup_ns`**.
Use `hash_lookup_ns`, `hash_insert_ns`, and `allocate_hash_insert_ns` for comparisons
with PageBloom: these operate on exactly the same raw keys, and include each
implementation's hash function. No common hash is applied before PageBloom's hash.
The raw-key bounds are `hash_lookup_min_ns` and `hash_lookup_max_ns`; the prehashed
`lookup_min_ns` and `lookup_max_ns` fields are `nan`. `input_mode` records this
distinction. The underlying upstream `pbf.cc` and `hash.cc` are included
unchanged in the benchmark translation unit, giving the optimizer the same visibility
as header-only competitors and allowing specialization for the public 8-byte input.

The default PageBloom build uses upstream SpookyHash. `-DBF_PAGE_AES=ON` enables
upstream's optional AES-NI hash, with different bitmap contents. Record this option
and use separate output directories when comparing it; it changes the hash, not
just instruction selection. All candidates in each executable receive the same
compiler, optimization level, host ISA, and `-fno-strict-aliasing` setting.

## Space and accuracy

All constructors allocate **exactly the same bitmap payload as FastPattern** for
the requested `(keys,bpk)`. Its legacy strict-next-power-of-two rounding is retained;
for power-of-two key counts and requested bpk 4/8/16, actual bpk is 8/16/32.
FastFilter's constructors are translated into byte/block counts, not assumed to
interpret their parameters as bits/key. Classical Bloom's public explicit K template
argument chooses probe count independently of the payload allocation.

`PageBloomDefault` follows upstream's page-size selection rule on the matched
payload (at most 4096-byte pages). `Compact` starts at the smallest page allowed for
that K, then increases it to honor the upstream maximum page-count constraint.
Both use the public explicit page constructor; no filter kernel is modified.

Equal bytes do **not** imply equal FPR. Fixed-K and page-size variants expose a
speed/space/error-rate frontier rather than a single claimed winner. Classical
Bloom often has substantially lower FPR than blocked layouts. Compare with measured
negative-query counts and FPR ceilings before ranking speed. The harness validates
every inserted key and consumes every timed query output.

## Validation

The contract test exercises three space budgets, all-miss/mixed/all-hit queries,
short and whole-input insert batches, and all 24 registered rows. It checks actual
space, false-negative failures, FPR accounting, raw/prehash columns, and exact
query-output parity between loop and bulk builders and branch variants.
Use `-DBF_SANITIZERS=ON -DCMAKE_BUILD_TYPE=Debug` in a separate build for ASan/UBSan.
Sanitizer timings are not performance results.
