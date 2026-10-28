# Three-sector accuracy screen — rejected at the 0.1% target

Three 32-bit words in one 64-byte line reduce the number of potential query
gathers from four to three. At **16 actual bits/key**, all three tested mask
configurations exceeded the 0.1% FPR target. No speed runs or native promotion
were performed; fewer gathers alone do not establish a useful improvement.

For `hi = hash >> 32`, every variant uses:

```cpp
a = hi & word_mask;
b = (a ^ 4) ^ ((hi >> 26) & 3);
c = (a ^ 8) ^ ((hi >> 28) & 3);
```

The three words occupy distinct quarters of one cache line. The first word can
start in any quarter, so all 16 words participate. The bitmap is capped at 2^26
words; the four offset bits are then disjoint from the first address. All mask
bits come from the low 32 hash bits.

| Mode | Mask allocation | Low-hash fields |
| --- | --- | --- |
| 0 | 3/3/3 bits, 32 dictionary entries per sector | Independent 10-bit codes at shifts 0/10/20; index 5 + rotation 5 |
| 1 | 3/3/3 bits, 64 entries | 11-bit codes from rotate-right 0/11/22; index 6 + rotation 5; the last code shares hash bit 0 with the first |
| 2 | 2/3/4 bits, dictionaries 16/32/32 | Independent 9/10/10-bit codes at shifts 0/9/19 |

Mode 0 uses exactly the native FastPattern three-bit dictionary. Mode 1 extends
the same deterministic greedy objective to 64 entries. Mode 2 uses the existing
16-entry two-bit and 32-entry three/four-bit dictionaries. The objective generator
is retained and the runner verifies every generated table before accepting data.
Static active tables occupy 128/256/320 bytes for modes 0/1/2, outside the bitmap.

Each case inserts 1,048,576 unique keys, checks **every inserted key**, then tests
16,777,216 disjoint negative keys. The fresh independent seeds are 104729,130363,
and 155921. Inputs use the shared benchmark's range/shuffle scheme and
`MurmurHash64`. Each pooled result contains 50,331,648 negatives. All cases have
zero false negatives and passed output-value/boundary checks.

| Mode | False positives | Pooled FPR | Largest per-seed Wilson 95% upper endpoint |
| --- | ---: | ---: | ---: |
| 0: 3/3/3, dictionary 32 | 59,109 | 0.117439% | 0.120122% |
| 1: 3/3/3, dictionary 64 | 58,077 | 0.115389% | 0.117901% |
| 2: 2/3/4 | 63,251 | 0.125668% | 0.127605% |

Every individual case fails the 0.1% confidence-bound criterion; even the point
estimates are above it. The wider dictionary gives a small accuracy improvement
but does not close the gap. The uneven 2/3/4 allocation performs worse. This
rejects these particular candidates at this budget and workload, not every
possible three-sector design or a different memory/FPR target.

Raw data: [screen-initial/screen.csv](screen-initial/screen.csv).
Commands, compiler/CPU details, source and binary hashes:
[screen-initial/metadata.json](screen-initial/metadata.json). Accuracy runs used
CPU 3; other agents were compiling or checking correctness, so elapsed time is
not a performance measurement. Frozen four-sector, split64 and native sources
were not modified.

```sh
python3 experiments/2026-10-28-three-sector/run.py \
  --output-dir build/three-sector-reproduction --cpu 3 --compile-cpu 5 \
  --key-power 20 --query-power 24 --requested-bpk 8 \
  --seeds 104729,130363,155921 --modes 0,1,2
```

The runner creates a new output directory, records binary hashes, and removes
its temporary executables after a successful run. No external baseline download
is needed for this accuracy-only rejection.
