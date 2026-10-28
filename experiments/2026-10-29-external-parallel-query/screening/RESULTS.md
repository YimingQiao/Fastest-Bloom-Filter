# Multithreaded query screen results

All 12 prespecified cases completed: 276 rows, 23 configurations, one seed, three repeats. Source and executable hashes are unchanged. The full socket 1 matrix took 696 seconds. Results are screening evidence on the Xeon Platinum 8474C; no main README performance claim is added.

Each table cell is the fastest eligible external median divided by the fastest eligible native median. A value above 1 favors the native portfolio. Both actual allocations are considered under each byte cap. The comparisons share n, q, T, batch, hit rate, seed, insertion batch and executable; this is not a comparison of native self-scaling with an external serial row.

## Hash plus query, gated execution

| Inserted keys | Cores T | Cap16, FPR≤1% | Cap16, FPR≤0.1% | Cap32, FPR≤0.1% | Cap32, FPR≤0.01% |
|---:|---:|---:|---:|---:|---:|
| 65536 | 1 | 1.361x | 1.635x | 1.327x | 1.087x |
| 65536 | 4 | 1.409x | 1.673x | 1.352x | 1.088x |
| 65536 | 8 | 1.383x | 1.613x | 1.384x | 1.085x |
| 33554432 | 1 | 1.161x | 1.131x | 1.131x | 1.072x |
| 33554432 | 4 | 1.068x | 1.067x | 1.067x | 1.059x |
| 33554432 | 8 | 1.112x | 1.128x | 1.128x | 1.079x |

## Hash plus query, including fresh thread startup and cleanup

| Inserted keys | Cores T | Cap16, FPR≤1% | Cap16, FPR≤0.1% | Cap32, FPR≤0.1% | Cap32, FPR≤0.01% |
|---:|---:|---:|---:|---:|---:|
| 65536 | 1 | 1.361x | 1.635x | 1.327x | 1.087x |
| 65536 | 4 | 1.387x | 1.639x | 1.326x | 1.082x |
| 65536 | 8 | 1.304x | 1.498x | 1.297x | 1.068x |
| 33554432 | 1 | 1.161x | 1.131x | 1.131x | 1.072x |
| 33554432 | 4 | 1.066x | 1.066x | 1.066x | 1.058x |
| 33554432 | 8 | 1.103x | 1.118x | 1.118x | 1.072x |

The eligible native portfolio also has lower observed medians for the pure-query gated/end-to-end rows. The complete CSV records exact winners, allocations, times, sample-range overlap and confidence bounds for every metric and quality cell. This is a one-seed descriptive ranking, not a statistical proof of speed superiority. No measured configuration qualifies for the 0.01% FPR target under the 16-bpk cap.

## Which layouts win, and where native layouts lose

- At 65,536 keys, FastPattern wins the loose 16-bpk/1% tier and the 32-bpk/0.1% tier; FourSector wins the 16-bpk/0.1% and 32-bpk/0.01% tiers. The strongest external rivals are FastFilter Fixed16, Fixed64 and SimdBlock, including their versioned single controls where they win.
- At 33,554,432 keys, FastPattern wins the loose and strict tiers; Split64 wins the 0.1% target using only 16 actual bpk, including when the cap is 32. Boost Multi32K8 and Multi64K8 are the strongest qualified external rivals.
- A portfolio lead does not mean every native layout wins: ByteSplit at the large 16-bpk/1% tier has hash-gated ratios 0.981x, 0.900x and 0.930x for T=1/4/8 versus Boost Multi32K8. Split64 at the small loose tier has ratios 0.743x, 0.763x and 0.800x versus the strongest Fixed16 control. Per-family rows retain all such losses.
- Small FastPattern at actual32 fails the strict quality confidence gate in this seed: 1,606/16,777,216 false positives gives Wilson95 upper 0.0001005223683, slightly above 0.0001. It is excluded rather than rounded into eligibility; the strict small-case native winner is FourSector. Large FastPattern32 has 1,559 positives and upper 0.00009765196747, so it qualifies.

## Scaling and quality accounting

Native fixed-allocation hash-gated T=8/T=1 throughput ratios range from 6.550x to 8.158x in this screen. These ratios are reported separately from external comparisons; small excursions above T are observed timing ratios, not a claim of algorithmic superlinear scaling. End-to-end scaling includes startup and cleanup and is retained separately.

There are 92 distinct calibration streams, each with 2^24 negatives; 276 rows are not 276 independent samples. Repeated T rows agree exactly on calibration count/positives, output checksum and allocation. The summary does not pool across different timed query counts. All 10 summary regression tests pass, covering confidence gating, stream deduplication, under-cap smaller rivals, thread/metric separation and raw-only labeling.

Artifacts: `results/results.csv`, `results/metadata.json`, `results/summary.json`, `results/qualified-comparison.csv`, `results/qualified-family-comparison.csv`, and `results/native-scaling.csv`. Further claims need fresh-seed confirmation and a separately scoped small-batch protocol; this screen covers only batch4096.
