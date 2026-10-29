# Page pointer caller: complete fixed240 results

The direct-pointer public singleton control did not show a stable latency
improvement. All48 small-table singleton pairs were slower; the large-table
results include both gains and losses. The original and pointer facades produced
identical bitmaps, answers and calibration observations in every paired
geometry. No production filter or PageBloom algorithm was changed.

Raw evidence was committed as `fb323c1494d8d6b7d4f885997cec309f2b95d13b`
before analysis. The eight synthetic tests passed, and the guarded loader
reconstructed all240 rows. Measured source is
`82fe0322fb2a761ece241fc89635e126bc80a590`; analysis rules were committed
before complete results as `75a2677cf666db9cbde7129488196f3c0114f01d`.
All482 raw artifacts and483 Git blobs including their manifest were verified.

This is seed42 training on CPU2 with one unchanged executable, a fresh process
per row, two fixed forward/reverse launch rounds, and six balanced query trials.
Each mode retains raw hashing and output materialization. The pointer singleton
passes the original four-byte input address to the same public PageBloom test
function; the value facade passes a stack copy. Dense paths call the same Base
DenseCall specialization. There is no old modern23 latency normalization or
claim of a same-process paired measurement.

## Caller pairs, with both rounds separate

Ratio is pointer/value latency: below1 favors the pointer caller. Each row
describes24 mapping/allocation pairs, not independent statistical victories.
Medians and ranges summarize those pairs without replacing individual results
or combining launch rounds.

| Round | Keys | Mode | Pointer lower / higher | Median ratio | Minimum | Maximum |
|---:|---:|---|---:|---:|---:|---:|
| 0 | 65536 | raw_single | 0 / 24 | 1.004705 | 1.002088 | 1.036810 |
| 0 | 65536 | raw_batch1 | 10 / 14 | 1.001142 | 0.998055 | 1.004936 |
| 0 | 65536 | raw_batch4096 | 16 / 8 | 0.999640 | 0.998290 | 1.004123 |
| 0 | 33554432 | raw_single | 10 / 14 | 1.002476 | 0.971415 | 1.031078 |
| 0 | 33554432 | raw_batch1 | 15 / 9 | 0.999025 | 0.975769 | 1.029075 |
| 0 | 33554432 | raw_batch4096 | 13 / 11 | 0.999279 | 0.960486 | 1.011521 |
| 1 | 65536 | raw_single | 0 / 24 | 1.006310 | 1.000940 | 1.034074 |
| 1 | 65536 | raw_batch1 | 10 / 14 | 1.000417 | 0.998540 | 1.004738 |
| 1 | 65536 | raw_batch4096 | 15 / 9 | 0.999877 | 0.998421 | 1.001717 |
| 1 | 33554432 | raw_single | 10 / 14 | 1.002911 | 0.943262 | 1.029540 |
| 1 | 33554432 | raw_batch1 | 14 / 10 | 0.998933 | 0.951177 | 1.015536 |
| 1 | 33554432 | raw_batch4096 | 10 / 14 | 1.001952 | 0.966751 | 1.016647 |

The largest observed singleton reduction was round1, PageBloom8Default at
large24bpk:109.099461→102.909383ns (ratio0.943262). The largest singleton
regression was round0, PageBloom4Default at small12bpk:17.449263→18.091568ns
(ratio1.036810). These are descriptive endpoints, not selected winners for
another experiment. Every singleton regression and dense-path change remains
in paired-callers.csv.

The unchanged dense-call controls also vary: the large-table ratio ranges span
0.951177–1.029075 for batch1 and0.960486–1.016647 for batch4096 across the
separately retained rounds. Their semantics and callee identity are unchanged,
but outer code layout and measurement context can still differ. The mixed
large singleton gains therefore do not establish that removing the stack copy
alone explains the changes.

## Native controls and nested byte caps

All84 views having both an eligible native and an eligible Page configuration
had lower observed native latency. The other60 views are not wins:24 have no
eligible native, and36 have neither an eligible native nor an eligible Page.
No view has an eligible native but no eligible Page. Eligibility is actual bitmap
bytes≤cap and the pointwise Wilson95 upper endpoint≤1%/0.1%/0.01%; smaller
allocations are admitted under larger caps.

| Round | Mode | Native lower | Native higher | No comparable pair |
|---:|---|---:|---:|---:|
| 0 | raw_single | 14 | 0 | 10 |
| 0 | raw_batch1 | 14 | 0 | 10 |
| 0 | raw_batch4096 | 14 | 0 | 10 |
| 1 | raw_single | 14 | 0 | 10 |
| 1 | raw_batch1 | 14 | 0 | 10 |
| 1 | raw_batch4096 | 14 | 0 | 10 |

This is a Page caller comparison, not a new full-modern-baseline ranking. It
does not erase the previously recorded Boost, FastFilter or RocksDB losses.
Native controls remain individual rows and do not subtract a context correction.
Missing native qualifiers at a tighter cap remain visible even when a native
wins at a larger cap.

## Quality and complete evidence

All72 canonical quality identities retain one2^24-negative sample each.
Pointer/value callers and repeated rounds reproduce that observation exactly;
they do not enlarge its denominator. Of24 Page geometries per size, all24 satisfy
1%;15 small and16 large satisfy0.1%;6 at each size satisfy0.01%. Every failed point
remains in the nested alternatives. This is not independent-seed confirmation.

The complete analysis contains288 caller pairs,144 nested views,8640 alternatives
and144 native control records. report/summary.json retains every pair trial
vector, phase order, range and quality identity; report/all-alternatives.csv
retains every budget/quality failure and timing loss. No measured row was
removed, rerun or replaced in response to these results. Source/binary/tuner
checks completed successfully; the whole socket0 lease was released before
analysis.
