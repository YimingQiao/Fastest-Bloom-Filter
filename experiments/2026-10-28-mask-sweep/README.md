# Mask dictionary experiments

## Denser masks — rejected

Question: can five, six, or seven bits per 32-bit sector improve FastPattern's
false-positive rate without changing the dictionary lookup/rotate hot path?

**Result: no.** All three denser dictionaries increased measured FPR at both
16 and 32 actual bits/key. They must not replace the four-bit dictionary on this
evidence. No speed advantage is claimed: this experiment screens accuracy only.

The screen inserts 2^20 unique keys and checks every one for false negatives,
then queries 2^24 distinct absent keys for each of seeds 42/43/44. The prehash
finalizer, unique integer ranges, base generation, and insertion shuffle match the
benchmark's deterministic scheme. Every variant receives exactly the same data.
Actual bitmap sizes are 2 MiB and 4 MiB. Zero false negatives were observed.

| Bits per sector | FPR, 16 actual bits/key | FPR, 32 actual bits/key |
| --- | --- | --- |
| 4 (current) | 0.202851% | 0.009193% |
| 5 | 0.265340% | 0.009704% |
| 6 | 0.386109% | 0.012239% |
| 7 | 0.597803% | 0.017228% |

Each value pools 50,331,648 negative queries. Per-seed counts and Wilson 95% upper
bounds are in [screen.csv](screen.csv). The candidate selection did not yield a
winner, so there was no promotion or held-out confirmation stage. Independent
seeds would be required before promoting any future tuned dictionary.

## Exact generator acceleration

The original `scripts/generate_patterns.py` accepts only 3/4 bits on its CLI,
although its generator function generalizes. Materializing all pair/triple
Counters for larger masks is expensive. `generate.cpp` computes exactly the same
objective using cyclic rotation orbits: 16 pair orbits and 155 triple orbits.
A normal pair orbit has 32 positions, an antipodal pair has 16, and a triple orbit
has 32. Frequencies and weights preserve the original pair weight 1 / triple
weight 8 score, divided globally by 16. Candidates are visited in the original
lexicographic combination order, so deterministic tie-breaking is preserved.
The generated four-bit dictionary was checked against the original Python output
and matched exactly. All generated dictionaries are retained in `masks*.txt`.

`fast_pattern_snapshot.h` preserves the current core implementation, including
its newly added short-tail path; only the dense mask initializer is changed to
an include of the selected dictionary. The base helper is snapshotted unchanged.
Source revision, hashes, commands, and initial measurements are in
[metadata.json](metadata.json). `screen.cpp` validates output bounds and false
negatives before recording FPR. Hash indices still use the unchanged low/high
bit allocation, and both sector reads remain in one cache line.

```sh
python3 experiments/2026-10-28-mask-sweep/run.py \
  --output-dir build/mask-sweep-reproduction --cpu 3
```

The runner regenerates every dictionary and verifies it against the saved copy,
then compiles and runs the accuracy screen. Use a new output directory for each
run. The recorded per-command elapsed times are execution metadata, not a
performance comparison between variants.

## Wider dictionaries — accuracy candidate

The second experiment keeps four bits per sector, but increases the dictionary
from 32 to 64 or 128 entries. The generator takes the same objective and chooses
more distinct cyclic patterns. The scalar reference assigns disjoint fields:

| Entries | First mask | Second mask | Partner word |
| --- | --- | --- | --- |
| 64 | index `lo & 63`, rotate `lo >> 6` | code `lo >> 11`, then index/rotate as first | `a ^ (8 + ((lo >> 22) & 7))` |
| 128 | index `lo & 127`, rotate `lo >> 7` | code `lo >> 12`, then index/rotate as first | `a ^ (8 + ((lo >> 24) & 7))` |

Rotation counts are modulo 32. The first word still uses masked high hash bits.
The bitmap payload and two-sector cache-line layout are unchanged. The active
shared dictionary grows from 128 bytes to 256/512 bytes; that extra static space
is outside the reported bitmap payload and must be disclosed in comparisons.

Initial screening at 2^20 keys and 32 actual bits/key reduced pooled FPR from
0.009193% (32 entries) to 0.008335% (64) and 0.007766% (128). At 16 actual bits/key,
improvements were smaller: 0.202851% to 0.197844% and 0.196556%. Raw results are in
[entropy-screen.csv](entropy-screen.csv).

After screening, independent seeds **731, 20261028, 8675309** were fixed before
executing held-out confirmation. Each case again uses 2^24 absent queries and
checks every inserted key. All held-out candidate runs had zero false negatives.

| Inserted keys | Entries | Pooled FPR | Largest per-seed Wilson 95% upper bound |
| --- | --- | --- | --- |
| 65,536 | 32 control | 0.009241% | 0.010144% |
| 65,536 | 64 | 0.008066% | 0.008604% |
| 65,536 | 128 | 0.007794% | 0.008445% |
| 1,048,576 | 32 control | 0.009191% | 0.009857% |
| 1,048,576 | 64 | 0.008065% | 0.008573% |
| 1,048,576 | 128 | 0.007705% | 0.008236% |

Each pooled result has 50,331,648 absent queries. See
[entropy-heldout.csv](entropy-heldout.csv) and [commands](entropy-metadata.json).
This validates an accuracy improvement, **not a performance improvement**.
The scalar reference is only an accuracy oracle. Dedicated SIMD prototypes and
speed measurements are a separate experiment. No core tables are changed here.
A short negative-query sample can leave a filter's FPR ceiling unverified even
when its true rate is below that ceiling; use enough negative queries before
classifying a strict-accuracy performance winner.

```sh
python3 experiments/2026-10-28-mask-sweep/run.py --entropy \
  --output-dir build/entropy-screen --cpu 3
python3 experiments/2026-10-28-mask-sweep/run.py --entropy \
  --output-dir build/entropy-heldout-64k --cpu 3 --key-power 16 \
  --requested-bpk 16 --seeds 731,20261028,8675309
python3 experiments/2026-10-28-mask-sweep/run.py --entropy \
  --output-dir build/entropy-heldout-1m --cpu 3 --key-power 20 \
  --requested-bpk 16 --seeds 731,20261028,8675309
```
