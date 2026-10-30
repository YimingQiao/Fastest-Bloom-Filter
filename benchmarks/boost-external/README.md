# Boost.Bloom baseline

This adapter uses the unmodified Boost 1.92.0 release, including its native bulk
insert/query pipelines. Archive checksums and the Bloom module's immutable commit
are recorded in [upstream.json](upstream.json). The dependency stays optional.

```sh
python3 benchmarks/boost-external/fetch_boost.py
cmake -S benchmarks/boost-external -B build/boost-external -DCMAKE_CXX_COMPILER=clang++
cmake --build build/boost-external -j
python3 scripts/run_comparison.py --executable build/boost-external/compare_benchmark \
  --output-dir results/boost --cpu 2 --key-powers 12,20,24 --bits-per-key 4,8,16 \
  --hits 0,50,100 --batches 1,31,4096 --seeds 42,43,44
```

`BF_NATIVE=ON` is the default and applies the host instruction set to all filters.
`BF_NATIVE=OFF` selects AVX2; `BF_SANITIZERS=ON` enables ASan/UBSan. This standalone
executable reuses `src/compare_benchmark.cpp`; it does not maintain a copied timer,
workload generator, or validation path. To embed these adapters in a combined
external executable, include `BoostHeaders.cmake`, link `bf_boost_baseline`, and
invoke `BF_REGISTER_BOOST_FILTERS(ADD)` from the combined registration macro.

The adapter consumes precomputed, uniformly distributed 64-bit hashes through an
identity hasher explicitly marked avalanching, so Boost does not silently remix
those hashes. Single-key calls use `insert`/`may_contain`; batches use Boost's
public range insertion and callback-based range query APIs. The native bulk
prefetch pipeline is preserved. All callback outputs are written in input order.

Row names expose the exact probe count and layout. `Multi32K8` means one SIMD
multiblock containing eight 32-bit sectors and eight probes, not eight probes per
sector. `Block64K6` is six probes in one 64-bit block. `Block512K8` is eight probes
in one cache-line block. `ClassicK11` accesses eleven independently located byte
blocks. Every configuration remains visible; the adapter does not choose a winner
based on the workload's measured timings or observed FPR.

Constructors fit Boost's bitmap **inside the native benchmark's complete rounded
byte budget**. The adapter inverts the pinned implementation's alignment, stride
and tail-allocation formula, without allocating trial filters. A counting-allocator
postcondition checks that the allocated bytes do not exceed that budget. Actual
bytes can be slightly smaller than the budget due to whole-subarray rounding.
**`filter_bytes` reports actual bytes requested
from the allocator**, including Boost's explicit alignment/tail padding; this is
measured with an injected counting allocator. It is intentionally not just
`capacity()/8`. The adapter also exposes `PayloadBytes()` for the usable bitmap.
Allocator bookkeeping, object fields, and OS heap fragmentation remain excluded,
as for the native filter. Compare reported bytes and measured FPR rather than
assuming identical `requested_bpk` means identical memory or accuracy.

Sources: [Boost 1.92 documentation](https://www.boost.org/doc/libs/1_92_0/libs/bloom/doc/html/bloom.html),
[pinned implementation](https://github.com/boostorg/bloom/tree/0909b9955e2dc02a0356351a2dfb567d4d5af772).
