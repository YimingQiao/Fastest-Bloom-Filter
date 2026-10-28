# Unified modern Bloom filter comparison

This executable now runs **53 configurations** by default: three native layouts
and 50 pinned FastFilter, PageBloomFilter, Boost.Bloom and RocksDB core configurations.
They run in one process, with shuffled implementation order,
identical inputs, compiler flags, timing loops and validation. It compiles the
shared `src/compare_benchmark.cpp`; it does not copy a separate timing harness.

```sh
python3 benchmarks/boost-external/fetch_boost.py
cmake -S benchmarks/all-external -B build/all-external -DCMAKE_CXX_COMPILER=clang++
cmake --build build/all-external -j 4
# query batch 4096; independent full-input build batch
python3 scripts/run_comparison.py --executable build/all-external/compare_benchmark \
  --output-dir results/external-screen --cpu 2 --key-powers 16 \
  --bits-per-key 4,8,16 --hits 0,50,100 --batches 1,4096 --insert-batch 65536 \
  --seeds 42 --repeats 3 --query-power 22
```

The default uses the build CPU instruction set for every implementation.
`BF_NATIVE=OFF` builds AVX2; `BF_PAGE_AES=ON` selects PageBloom's separately
benchmarked AES hash mode (different bitmap/FPR). Pins and archive SHA-256 hashes
are recorded in `upstreams.json` and the component manifests. Upstream sources
are fetched unchanged. Licenses are copied beside the binary.
`BF_NATIVE_LAYOUTS=OFF` omits the new native FourSector/Split64 types;
`BF_ROCKSDB=OFF` omits the eight RocksDB core configurations. The original screen
used the earlier 43-configuration executable; later additions do not alter those
historical rows or their claimed baseline set.

Use `hash_lookup_ns` and `hash_insert_ns` to compare all families end to end:
PageBloom hashes the raw 8-byte keys through its public API. Its pure prehash
columns are `nan`; its hashing is never omitted or charged twice. Prehashed
FastFilter and Boost use identity hashers after the common source hash. Boost's
avalanching identity trait suppresses an otherwise implicit remix. Native bulk
APIs are used where available, with separate explicit scalar/AddAll aliases for
FastFilter. Actual allocations, not advertised capacity alone, populate
`filter_bytes`. See each adapter's README for exact allocation accounting.

The [RocksDB adapter](../rocksdb-external/README.md) measures the unchanged
FastLocalBloom bitmap primitives and the production insertion/MultiGet schedules.
Its hash+operation columns use the common source hash and exclude SST hash queues,
serialized metadata, virtual reader calls and database I/O. They are core-filter
measurements, not complete RocksDB database or SST-building timings.

`insert_batch` is independent of query `batch` for this executable. The extra
C++ CSV columns are `input_mode`, `hash_insert_ns`, `allocate_hash_insert_ns`, and
`insert_batch`. For raw-key-only APIs, `insert_ns`, `allocate_insert_ns`, and
`lookup_ns` and its min/max are unavailable. `hash_lookup_min_ns` and
`hash_lookup_max_ns` describe the end-to-end query spread.
`filter_build_scratch_bytes` records explicit temporary heap storage inside bulk
build adapters; `harness_hash_scratch_bytes` is the common outside-timing hash
buffer. The ranker memory ceiling constrains filter allocation, not peak build RAM.

## Screening and confirmation

```sh
python3 scripts/rank_external.py results/external-screen/results.csv \
  --max-bpk 32 --allocation-slack 64 --fpr-targets 0.01,0.001,0.0001 \
  --metric hash_lookup_ns --output results/external-screen/ranking.csv
```

The memory ceiling is `floor(keys * max_bpk / 8) + allocation_slack` bytes, not a
claim of identical allocation. The 64-byte slack is explicit alignment allowance;
all exact bytes remain visible. The script requires the one-sided 95% Wilson
upper bound on observed FPR to meet the ceiling, using each all-miss seed once.
It does not count repeated batch tests as independent negative samples. FPR bounds
are per configuration, not simultaneous guarantees after searching many variants.

This is a **screening leaderboard**: selecting a configuration and measuring it
on the same seeds is exploratory. Freeze the candidates, then use new insertion
seeds for confirmation, including single-key and short batches, hit-rate extremes,
cache-resident and larger-than-LLC bitmaps. A winner under one memory/FPR ceiling
is not an equal-space/FPR dominance claim or evidence of being globally fastest.
Static xor/ribbon/fuse filters have a different construction/update contract and
must be reported as a separate approximate-membership category if included.

## Independent FPR calibration

`--calibration-power 24` adds 2^24 disjoint negative probes **after timing**. It
streams through batch-sized buffers, so improving statistical resolution does not
increase the timed query working set. The two appended CSV fields are
`calibration_absent_queries` and `calibration_false_positives`; when available,
the ranker uses these counts instead of timed all-miss workload counts. Probes
start after both inserted keys and the timed query interval. The input remains
uniformly source-hashed. Use new insertion seeds for confirmation, not merely
more negatives against the filter used to select the candidate.

## Experimental layouts and frozen confirmation

`BF_WIDE_EXPERIMENTS=ON` adds the AVX-512 64/128-entry mask dictionaries.
`BF_LAYOUT_EXPERIMENTS=ON` adds `FourSector16K8` and `Split64P32` from the
recorded experiment sources. They are candidates, not public library types.
The [confirmation protocol](../../docs/confirmation-protocol-2026-10-28.md)
freezes the shortlist and workload before measuring new seeds in this executable.
