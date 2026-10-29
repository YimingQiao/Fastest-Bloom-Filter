# FourSector range probe-count accuracy pilot

This adds a fixed scalar accuracy screen for K8/K9/K10/K12 using the existing
FourSector range mapping and the historical 16-entry two/three-bit dictionaries.
It is not a speed result, a SIMD implementation, or a replacement for the failed
[K8 range pilot](../2026-10-29-four-sector-range24/accuracy/RESULTS.md).

The prior power-of-two experiment tested these masks at 8/16/32 actual bpk.
It did not test this new range mapping or 24 bpk. K9 showed little benefit at
16 bpk, while more bits improved the older 32-bpk quality estimates. The question
here is whether one of these existing choices meets 0.01% at 24 bpk. More bits
can increase saturation; success is not assumed. Every configuration still
accesses four distinct 32-bit words in one 64-byte line. K9 uses three bits in
sector 3, K10 in sectors 2/3, and K12 in all sectors; the remaining sectors use
two bits. No new dictionary is searched or trained.

The address is floor(top24 * line_count / 2^24), followed by the unchanged
8-bit quarter-word selection and correlated cyclic 9-bit codes from low32.
Finite address resolution and mask correlations remain: this is not an
independent-probe model or an assumption that old accuracy carries forward.
Static dictionary bytes are outside the variable bitmap payload metric;
K8/K12 use 64 active bytes, K9/K10 use 128. The two dictionaries appear in the
source for every template, but only the selected ones are accessed.

The fixed pilot has 24 rows: n=2^16/2^25, actual 16/24/32 bpk, K8/9/10/12,
seed 42, and 2^24 negatives per row. It exactly reuses the prior pilot's
streaming bijective hash, positive and disjoint negative domains, all-insert
checks, guarded dense outputs and checksums. Six K8 rows must reproduce the
old counts and checksums. A K8 replay is not a new independent accuracy sample.
The other 18 rows are new configurations, each with its own pointwise 95%
Wilson interval. No pooling or simultaneous confidence claim is made.
The useful quality gate is upper <= 0.0001 at 24 bpk; all three standard gates,
all capacities and all failures remain reported. This pilot does not use any
latency values or modify a running baseline benchmark.

Before calibration, native optimized and ASan/UBSan builds run 28 cases each:
K8/9/10/12 at requested 128/129/192/320/262208/2097216/100663296 bytes. An independent
bit-position oracle verifies full bitmaps, every inserted key, incremental
insertion, repeated/hotspot keys, all cyclic mask codes, full outputs for
548 offset/tail cases per fixture, and unchanged input. K8 additionally matches
the frozen optimized parent's full bitmap. Invalid byte budgets are rejected.
The 96 MiB fixture exercises the large non-power-of-two address range; no
performance measurement occurs. Existing unchanged-address backend evidence
remains in the parent experiment; this new candidate only offers scalar APIs.

`driver.py --source-commit FULL --cpu 2 --correctness` builds and checks both
modes, and compiles (but does not execute) the fixed calibration executable.
The complete operation must inherit the socket lock and affinity. Commit the
resulting preflight archive, then use the same source commit plus
`--accuracy --freeze-commit FULL`. All actual compiler inputs and binaries are
hashed before/after. Output directories are exclusive and failures are retained.

Only a completed accuracy screen can justify preparing SIMD performance
candidates. Their performance would need a separate frozen protocol against
strong public external baselines, followed by fresh-seed confirmation. Neither
an extra probe nor passing this seed alone makes a filter faster or production-ready.
