# Production FourSector before/after confirmation

This measures the actual production class before and after the short-batch change,
compiled into one executable. `before.h` is the header from commit `bb4d21c`, with
only its class/constructor name changed to `FourSectorBefore`. `after.h` is the
working production header after applying the optimization, similarly renamed to
`FourSectorAfter`. `source-metadata.json` records both original hashes. Supporting
headers and the shared benchmark harness are snapshotted locally so later native
edits cannot change this executable's source inputs.

The frozen production comparison confirms the intended tradeoff. These results
use a larger timed query working set than the earlier prototype screen and should
be used for production performance claims instead of the earlier 1.86×/1.41×
prototype figures. This compares two versions of our own filter; it establishes
neither an external-baseline win nor a global-fastest result.

| Bitmap | Batch | Query-only speedup | Hash+query speedup |
| --- | --- | --- | --- |
| 128 KiB | 8 | 1.469× | 1.037× |
| 128 KiB | 31 | 0.993× | 0.987× |
| 128 KiB | 4096 | 1.022× | 0.995× |
| 32 MiB | 8 | 1.321× | 1.608× |
| 32 MiB | 31 | 1.147× | 1.323× |
| 32 MiB | 4096 | 0.982× | 0.993× |

Each value is the median of paired before/after speed ratios for seeds 2053 and
4099. Each CSV timing is itself the median of five repetitions. All cases use
50% hits, requested 8 / actual 16 bits/key, 2^16 or 2^24 inserted keys, 2^22 timed
queries, and full-size insertion batches. All 24 rows have identical allocations,
full-output checksums, FP counts, and hit/miss accounting between versions.

At 32 MiB/batch4096, query-only ratios were 0.966× and 0.998× for the two seeds;
the improvement therefore does not extend uniformly to long batches. Resident
batch31 hash+query loses about 1.3%. Both tradeoffs remain in the table and raw data.

Timing used Clang 23 with `-O3 -march=native -fno-strict-aliasing`, CPU 3 on socket 1.
The two versions ran in the same process with the shared harness's randomized
implementation order and identical timing boundaries. Other socket 1 builds/tests
were paused during this window. `results/metadata.json` records exact commands,
compiler/CPU details, source and binary SHA-256, and an empty changed-source list.
`results/timing.csv` retains all rows.

Before any timing, `check` compared complete outputs with the scalar old-version
oracle for all inserted keys (including a 16M-key case), mixed inserted/absent
queries, lengths 0–131, offsets 0–7, output guards, duplicate insertions, batch sizes
through 4096, and both sides of the prefetch threshold. The runner executes this
preflight again before starting the matrix and checks every measured row's output
checksum, allocation and FP counts against its counterpart.

```sh
cmake -S experiments/2026-10-28-four-sector-probe/native-confirmation \
  -B build/four-sector-native-confirmation -DCMAKE_CXX_COMPILER=clang++
cmake --build build/four-sector-native-confirmation -j1
python3 experiments/2026-10-28-four-sector-probe/native-confirmation/run.py \
  --output-dir build/four-sector-native-confirmation-new-results --cpu 3
```

Use a fresh output directory and a CPU/socket free of competing work. The script
runs the recorded twelve-case grid with the original two confirmation seeds.

The corresponding Rust port received an independent read-only review: dispatch
conditions, word addresses, dictionary masks, two-gather lane reduction, full-eight
versus masked-tail loads, output bounds, and AVX512F/AVX2 requirements match C++.
Rust tests and language parity are tracked by the production integration task;
no Rust timing is implied by this C++ table.
