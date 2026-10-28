# Direct-split versus current native and RocksDB implementations

This is a separate comparison after the initial direct-split archive was frozen.
It contains the two preselected single-key prototypes; latest native FastPattern,
FourSector and Split64; pinned FastFilter Fixed16/Fixed32/SimdBlock; the explicit
Fixed16/SimdBlock single-key shortcut controls; and all eight pinned RocksDB
FastLocalBloom configurations. The parent archive and production files are unchanged.

`snapshot.json` records byte-identical snapshots of the shared benchmark source,
all native headers, and both external adapters. The original files are named and
SHA256-checked. The benchmark timer, input generation, allocation lifetime, output
contract, warmups and calibration are unchanged. `snapshot/compare_benchmark.cpp`
is an exact archived copy of the common source, not a separate timing implementation.
The FastFilter/RocksDB dependencies use the repository's existing pinned manifests
and retained licenses. All rows compile with identical `-march=native` flags and
`-fno-strict-aliasing`; the RocksDB dependency adds platform macros only.

The preflight `check.py` verifies source hashes and all 18 expected row names,
equal bitmap bytes, FastFilter original/shortcut output equivalence, and RocksDB
automatic/fixed/direct/prepared equivalence across 18 mixed-hit/batch cases. All
shared-harness runs validate every inserted key, all dense output bounds, output
consistency outside timing, and independent calibration. The experimental kernels'
full scalar-reference and sanitizer tests are frozen in the parent archive.

The matrix uses CPU 3 (socket 1), n=2^16/2^24, requested 8/16 (actual 16/32 bpk),
50% hits, batch 1, q=2^22, five repetitions, seeds731/8675309 and independent
calibration 2^24. Each scenario runs every candidate in the same executable and
process. No concurrent compilation or timing is permitted on that socket. Results
are specific to this CPU/compiler, batch API and scenario; they are not latency
measurements or a fully fused raw-key API comparison.

`summarize.py` gates every candidate/rival with the two-sided Wilson 95% upper
bound from independent calibration. It reports both equal-byte and memory-cap
comparisons. For cap 32 it considers all qualifying actual 16 and actual 32 rows:
ByteSplit128 at 32 must therefore beat a lower-memory Split64 or RocksDB 16-bpk row
when the target is 0.1%. The fastest eligible native/external/control row is selected
separately per metric and seed; no candidate gets credit for a deliberately weak
adapter path. The two prototype selections are fixed before this matrix.

The archived CLI predates strict selection validation added in the main harness
while this run was in flight. This matrix explicitly selects `FastPatternBF` and
asserts all 18 expected rows, so the independently discovered misspelled-name issue
does not omit any requested implementation here.

```sh
cmake -S experiments/2026-10-29-direct-split/modern-comparison -B build/direct-split-modern -DCMAKE_CXX_COMPILER=clang++
taskset -c 3 cmake --build build/direct-split-modern --parallel 1
python3 experiments/2026-10-29-direct-split/modern-comparison/check.py build/direct-split-modern/compare_benchmark
python3 experiments/2026-10-29-direct-split/modern-comparison/run.py --mode speed --output /tmp/direct-split-modern-heldout --key-powers 16,24 --requested-bpk 8,16 --seeds 731,8675309 --hits 50 --batches 1 --query-power 22 --calibration-power 24 --repeats 5
python3 experiments/2026-10-29-direct-split/modern-comparison/summarize.py /tmp/direct-split-modern-heldout/timing.csv
```

## Results and decisions

All 144 rows completed with no snapshotted-source drift. All expected
FastFilter original/shortcut and RocksDB direct/prepared checksum, false-positive,
allocation and calibration equivalences hold. The table reports median paired
seed speedups versus the fastest qualifying native/external/control row **under
the byte cap**, so numbers above 1 favor the prototype.

| Prototype / FPR target | Keys | Cap (bpk) | Hash + query speedup | Prehashed speedup | Decision |
|---|---:|---:|---:|---:|---|
| ByteSingle / 1% | 65,536 | 16 | 1.078x | 1.067x | Clear small-filter improvement |
| ByteSingle / 0.1% | 65,536 | 32 | 1.081x | 1.060x | Clear small-filter improvement |
| ByteSingle / 1% | 16,777,216 | 16 | 1.007x | 1.017x | Near parity; pure seed range 0.995–1.039x |
| ByteSingle / 0.1% | 16,777,216 | 32 | 0.904x | 0.859x | Reject as replacement; native Split64 at 16 bpk wins |
| IndependentSingle / 0.01% | 65,536 | 32 | 1.011x | 1.017x | Small gain only |
| IndependentSingle / 0.01% | 16,777,216 | 32 | 0.986x | 1.006x | No raw-query improvement over latest Split64 |

The memory-cap result is decisive. For the large 0.1% case, equal-byte comparison
would show ByteSingle raw throughput almost tied with Split64 (1.0015x). Permitting
the already-quality-eligible 16-bpk Split64 makes the prototype clearly slower,
while using twice the bitmap memory. No broad replacement or overall fastest
claim follows. ByteSingle remains worth exploring for small bitmaps; the independent
40-bit mask has not justified production integration. No native files were changed.

The faster small-filter rival is FastFilter Fixed16 for raw queries and its explicit
single-key control for prehashed queries. In large cases, the latest native Split64
replaces the older baseline as the strongest rival. All eight RocksDB configurations
are measured and quality-gated; none is the fastest qualifying query row in these
specific scenarios. This does not rank RocksDB's full database/SST behavior.

The earlier archive's larger wins over its frozen older Split64 must not be quoted
as wins over the current native implementation. This matrix supersedes that inference.
The data and `heldout/summary.json` retain equal-byte and under-cap selections,
individual seeds, calibration confidence bounds and the chosen rival for each metric.
There are only two timing seeds and no speed confidence intervals; sub-percent
movement is treated as near parity.
