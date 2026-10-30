# Sixteen word-sector probes in a 32-byte block

Validated isolated experiment. The prespecified independent accuracy gate passed; limited GCC training results are archived below. No overall speed claim or production change.

The candidate splits a 32-byte block into sixteen 16-bit sectors. A key sets one
bit per sector. Sixteen frozen 16-bit salts multiply alternating low/high16 halves
of the low32 hash; the top four bits of each low16 product select the position.
The high32 hash selects a power-of-two block. Unlike the earlier Byte256 attempt,
this layout always sets sixteen bits and uses whole 16-bit sectors. It preserves
the common hash, actual allocation accounting and dense query outputs.

AVX-512BW/VL provides packed variable 16-bit shifts after a packed low16 multiply;
the scalar fallback implements the same mapping. An independent byte-level test
uses wide integer products and quotient/remainder to check every bitmap bit.
Both source halfwords traverse all 65,536 values; mixed insert/query, collisions,
duplicates, offsets, short tails, empty batches and all inserted keys are checked.

An ideal independent-sector Poisson model predicts roughly 0.003% FPR at 32 actual
bits/key, below the intended 0.01% ceiling. That is a hypothesis, not a bound:
multiply-shift positions are correlated and could invalidate it. The protocol
fixes salts before looking at data. Native/scalar/sanitizer correctness precedes
seed42 accuracy measurements at 64K/1M keys. Only if both 32-bpk cases qualify will
fresh seeds4001/9001 confirm accuracy. No throughput comparison should begin
before that independent confirmation passes. A failed gate is retained without
changing salts or removing difficult cases.

## Correctness and accuracy evidence

GCC native and forced-scalar checks and Clang native/scalar ASan+UBSan checks all
pass, with the identical oracle/output checksum `9063729662564169232`. Beyond the
original exhaustive halfword mapping checks, tests reject zero bits/key,
multiplication overflow and the layout cap before allocation, check strict
allocation boundaries and empty bitmaps, and cover lengths 0..131 plus 4096..4127
with offsets 0..7, exact input ends, output guards, collisions and duplicates.
`validation.json` and the four test logs retain commands and outcomes.

Every case uses 2^24 additional disjoint negative keys. The table reports actual
bits/key, measured FPR and its pointwise one-sided 95% Wilson upper bound. The
quality gate is an upper bound <=0.01% at 32 bits/key, separately for every size
and confirmation seed. It is not a simultaneous confidence statement.

| Keys | Seed | Actual bits/key | FPR | 95% upper |
|---:|---:|---:|---:|---:|
| 65,536 | 42 | 16 | 0.350374% | 0.352755% |
| 65,536 | 42 | 32 | 0.003368% | 0.003609% |
| 1,048,576 | 42 | 16 | 0.345713% | 0.348078% |
| 1,048,576 | 42 | 32 | 0.002861% | 0.003084% |
| 65,536 | 4001 | 16 | 0.350285% | 0.352665% |
| 65,536 | 9001 | 16 | 0.356549% | 0.358951% |
| 65,536 | 4001 | 32 | 0.003171% | 0.003405% |
| 65,536 | 9001 | 32 | 0.003392% | 0.003634% |
| 1,048,576 | 4001 | 16 | 0.341392% | 0.343742% |
| 1,048,576 | 9001 | 16 | 0.344783% | 0.347145% |
| 1,048,576 | 4001 | 32 | 0.002909% | 0.003133% |
| 1,048,576 | 9001 | 32 | 0.002956% | 0.003183% |

The initial seed42 gate passed at both sizes, so the frozen candidate was tested
on the prespecified independent seeds4001/9001, retaining both allocations. All
four independent 32-bpk cases pass. The 16-bpk cases qualify for a 1% ceiling,
but fail a 0.1% ceiling. Salts were never changed after observing accuracy data.

`initial/accuracy.csv` and `confirmation/accuracy.csv` contain all nine candidates
without timing columns. Their original runner CSVs remain archived for audit;
the small correctness workload timings are not performance evidence.
`result.json` contains the decision and all candidate accuracy counts.
`freeze.json` records source and all binary hashes, with repository-relative
source copies under `source-snapshot/`. Both stages verified all those hashes
before and after collection.

One pre-calibration export-field typo (`checksum` versus the existing
`result_checksum`) was fixed after validation. The first launch's source-drift
check rejected it before any benchmark child ran. The rejected freeze and export
script are preserved in `precalibration-*`; only that CSV export field changed,
and compiled inputs/binaries were unchanged when refrozen before data collection.

Reproduction commands, run from the repository root:

```sh
flock /tmp/fastest-bf-socket0.lock python3 experiments/2026-10-29-word16/validate.py
flock /tmp/fastest-bf-socket0.lock python3 experiments/2026-10-29-word16/accuracy.py --mode initial
flock /tmp/fastest-bf-socket0.lock python3 experiments/2026-10-29-word16/accuracy.py --mode confirmation
```

The accuracy runner refuses to overwrite an existing output directory and
refuses confirmation unless the archived initial gate passed for the same source
freeze. Restore the snapshot to a fresh checkout/output location for replay.

## Separate performance training

The approved GCC/CPU3 screen completed all 12 workloads/108 rows, using nine
explicit configurations, n=2^16/2^25, requested8/16 (actual16/32 bits/key), batches
1/31/4096, seed42, 50% hits, q=2^22, five repeats, full-input builds and cal24.
`performance-protocol.json` and `performance-freeze.json` precede data collection;
`performance-training/semantic-audit.json` verifies all cross-batch output and
quality counts as well as frozen inputs. The standalone accuracy timings above
remain unclaimed.

See [the complete training report](performance-training/README.md) for all focus
cases and both query metrics, including losses. The small strict32-bpk batch31
raw path is promising, but native FastPattern remains much faster in bulk and
large/single cases have no consistent external advantage. FourSector and most
modern external configurations are absent from this screen. Word16 remains an
experiment; a separate Clang/expanded-panel validation must precede any held-out
performance decision. No production or Rust integration is approved by these
results. CPU3 timing is never compared with earlier CPU2 accuracy-run timings.
