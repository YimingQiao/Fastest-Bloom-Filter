# Exact-layout lookup experiments

These experiments retain FastPattern's bitmap size, hash-to-bit mapping, dictionaries,
and answers. They compare query kernels with the original kernel from commit
`2182592`; `current.h` is an exact snapshot. No external-library ranking is implied.

The selected change is **candidate 6**, an eight-key AVX-512 tail after the existing
16-key loop. Both sectors of each key occupy adjacent 32-bit vector lanes. A single
16-lane gather followed by a 64-bit equality comparison tests both sectors together,
then writes eight results. This uses AVX-512F and AVX instructions; AVX-512VL is not
required. The large-batch loop is unchanged. The change is integrated into both
`include/fast_pattern_BF.h` and `rust/src/lib.rs`.

## Measurements

CPU **3**, on the second socket of the Xeon Platinum 8474C; Clang 23,
`-O3 -std=c++17 -march=native -DNDEBUG`. Each case uses 2^20 queries, nine timed
repetitions, prehashed inputs, warmed queries, and an alternating pseudorandom order
between original and candidate. The output checksum is consumed after timing.
Every queried output is compared with the original, and all inserted keys are checked.

Below: median of per-case speedups across seeds 42/43/44 and hit rates 0/50/100%
(nine cases per cell), requested 8 bits/key, actual 16 bits/key. Ratios above 1 favor
the tail kernel. Measurements are C++ only; the Rust port is verified for parity but
has not been separately performance-measured here.

| Batch | 8 KiB bitmap | 2 MiB bitmap | 32 MiB bitmap |
| --- | --- | --- | --- |
| 8 | 1.86× | 1.45× | 1.21× |
| 15 | 1.39× | 1.28× | 1.07× |
| 31 | 1.33× | 1.14× | 1.05× |
| 4096 | 1.00× | 1.01× | 1.00× |

`tail-confirm.csv` contains all 108 cases; `metadata.json` records source hash,
compiler and CPU information. This is a local same-process kernel comparison, not
a performance guarantee on other hardware or under cold-cache conditions.

## Rejected alternatives

- **1:** replace every 16-key iteration with paired eight-key gathers. It improves
  some tails but loses about 6% on an 8 KiB bitmap at batch 4096; retained only as
  the short-tail specialization in candidate 6.
- **2:** mask the second sector's gather by first-sector successes. Adds a dependent
  gather and loses roughly 12–16% in the resident-filter cases screened.
- **3:** also branch to skip an entirely rejected vector. Strong all-miss and
  mixed-hit regressions in the screening matrix; not selected.
- **4:** short-circuit the scalar second-sector test. Helps all-miss single-key
  calls but loses roughly 30–40% on mixed-hit small batches. Not selected.
- **5:** change prefetch distance from 64 to 16/32/96/128/192/256. No consistent
  improvement across 64 MiB and 128 MiB filters. Distance remains 64.

`screen.csv`, `small-screen.csv`, and `prefetch-screen.csv` retain these trials,
including losses. Screening uses seed 42; the selected tail kernel is confirmed
with three seeds. No choice changes FPR or hides memory costs.

## Reproduce

Run from the repository root. Build artifacts stay under ignored `build/`.

```sh
clang++ -O3 -std=c++17 -march=native -DNDEBUG -DBF_CANDIDATE=6 \
  -Iinclude experiments/2026-10-28-next/probe.cpp -o build/probe6
# key power, requested bits/key, hit percent, batch, seed
taskset -c 3 build/probe6 20 8 50 31 42
python3 experiments/2026-10-28-next/run.py --output /tmp/tail-confirm.csv
```

`run.py` runs the confirmation matrix serially. Build candidates 1–4 by changing
`BF_CANDIDATE`. Candidate 5 additionally accepts `-DBF_DISTANCE=...`.

```sh
clang++ -O1 -g -std=c++17 -march=native -fsanitize=address,undefined \
  -fno-omit-frame-pointer -DBF_CANDIDATE=6 -Iinclude \
  experiments/2026-10-28-next/check.cpp -o build/probe6_check
taskset -c 3 build/probe6_check
```

The dedicated sanitizer test covers lengths 0–131, offsets 0–7, sparse and dense
masks, duplicate insertions, and output canaries. The integrated C++ native CTest
suite, Rust tests/clippy, and native cross-language and parallel parity checks are
also run before handing the change back for external benchmarking.
