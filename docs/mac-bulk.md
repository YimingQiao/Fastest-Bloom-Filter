# Bloom filters on Apple Silicon

The C++ library builds natively on arm64 macOS. `Word64BloomFilter` and
`Split16BloomFilter` target bulk insertion and membership queries. All accept
uniformly prehashed 64-bit values and write one `uint32_t` result per query.
Insertion requires exclusive access; completed filters support concurrent readers.

```bash
cmake -S . -B build/mac -G Ninja -DBF_NATIVE=ON
cmake --build build/mac -j 8
ctest --test-dir build/mac --output-on-failure
```

`BF_NATIVE=ON` uses `-mcpu=native` on arm64; omit it for the compiler's default
architecture target. ARM builds skip the legacy x86/Impala benchmark types.
Intel builds retain the original AVX2/AVX-512 options. `BF_DISABLE_NEON=ON`
selects the scalar source kernels for ByteSplit and Split16; compiler automatic
vectorization remains enabled. `BF_SANITIZERS=ON` enables ASan/UBSan for both
native and portable test targets.

## Choosing a layout

| C++ type | Per-key bitmap access | Accuracy at 16 actual bitmap bits/key on the M5 Pro run |
|---|---|---|
| `Word64BloomFilter` | One 64-bit word; four-bit cyclic mask | About 0.56% FPR |
| `Split16BloomFilter` | One 16-byte bucket; eight 16-bit sectors | About 0.25% FPR |
| `ByteSplitBloomFilter` | One 16-byte bucket; signed-high byte mask | About 0.55% FPR |
| `FastPatternBF` | Two 32-bit words in one 64-byte storage line | About 0.20% FPR |

Word64 uses a shared 512-byte read-only dictionary. Split16 has a native NEON
kernel and a portable scalar fallback, preserving FastFilter's ARM eight-u16
mask construction while changing address reduction and bulk scheduling.
ByteSplit now has a NEON backend with exact x86/scalar mask parity. FastPattern
now prefetches its scalar ARM bulk path. Existing bitmap mappings are retained
for ByteSplit and FastPattern; the two new types have their own mappings.

These are empirical FPR values for uniform hashes, not bounds for arbitrary or
adversarial inputs. The [complete M5 Pro results](../experiments/2026-10-29-mac-neon/RESULTS.md)
retain external wins as well as native wins, hash-inclusive metrics, allocations
and the full benchmark contract. No single layout wins every case. Tune on the
deployment Mac; M5 Pro results are not measurements of other M-series chips.

```cpp
#include "word64_bloom.h"  // or split16_bloom.h
#include <vector>

using namespace bloom_filters;
const size_t count = size_t{1} << 20;
Word64BloomFilter bf(count, 8);
// The legacy constructor rounds to the STRICT next power of two:
// count=2^20, requested bpk=8 allocates 2 MiB, or 16 actual bits/key.
std::vector<uint64_t> hashes(count);
for (size_t i = 0; i < count; ++i) hashes[i] = MurmurHash64(i);
bf.Insert(static_cast<uint32_t>(hashes.size()), hashes.data());
std::vector<uint32_t> present(count);
bf.Lookup(static_cast<uint32_t>(hashes.size()), hashes.data(), present.data());
```

Check `SizeInBytes()` for the actual bitmap allocation. Hashing is explicit so
applications that already have uniform hashes do not hash twice. Zero-length
Insert/Lookup accepts null pointers. Batch lengths are `uint32_t`; split larger
arrays into multiple calls. Copying owns a separate bitmap.

Include `parallel_layout_bloom.h` for `ParallelWord64BloomFilter` and
`ParallelSplit16BloomFilter`. Their `InsertParallel` partitions complete 64-byte
storage lines, preserving colliding OR updates, and `LookupParallel` partitions
the input/output arrays. Partition scratch and fresh thread creation can dominate
small jobs. A storage line is 64 bytes even though this M5 Pro's hardware line
is 128 bytes. These methods are not concurrent-writer APIs.

## Reproducing the comparisons

The regular comparator runs without external dependencies:

```bash
# keys=2^24, requested bpk=8 (32 MiB actual), 0% hits, queries=2^22,
# query batch=4096, repetitions=5, seed=6007, insert batch=4096,
# independent calibration negatives=2^22.
build/mac/compare_benchmark 24 8 0 22 4096 5 6007 \
  Word64BloomFilter,Split16BloomFilter,ByteSplitBloomFilter,FastPatternBF 4096 22

# Prehashed whole-array parallel API, including partitioning/thread startup:
build/mac/parallel_benchmark 24 8 22 4 5 6007 0 Word64,Split16
```

For pinned Boost 1.92 and FastFilter ARM comparisons and frozen original controls:

```bash
python3 benchmarks/boost-external/fetch_boost.py
cmake -S experiments/2026-10-29-mac-neon -B build/mac-confirm -G Ninja
cmake --build build/mac-confirm -j 4
python3 experiments/2026-10-29-mac-neon/run_confirmation.py
python3 experiments/2026-10-29-mac-neon/run_confirmation.py --guardrails \
  --output experiments/2026-10-29-mac-neon/guardrails.csv
python3 experiments/2026-10-29-mac-neon/summarize.py
```

The external archive versions and SHA-256 checks are pinned. Both implementations
run unchanged through their public APIs. The runner never starts benchmark
processes concurrently. Keep other CPU-intensive jobs idle for timing. Sanitized
executables are for correctness only, not performance comparison.

Word64 and Split16 are currently C++ additions. The four shared C++/Rust layouts
can still be checked on ARM with:

```bash
cargo build --release --manifest-path rust/Cargo.toml
python3 scripts/check_cross_language.py --cpp build/mac/compare_benchmark \
  --rust rust/target/release/compare_benchmark \
  --filters FastPatternBF,FourSectorBloomFilter,Split64BloomFilter,ByteSplitBloomFilter
```
