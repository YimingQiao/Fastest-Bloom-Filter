# Finer capacities change the external comparison

The completed 988-row screen exposes a production loss that the older16/32-bpk
allocation grid did not show. At32M keys, a32-bpk ceiling and a0.01% FPR ceiling,
Boost Multi64K8 uses about24 actual bpk and takes5.753ns/key for staged hash+query.
The fastest qualifying production native uses32 actual bpk and takes6.007ns/key.
That native is4.4% slower while using more bitmap memory. At the loose1% ceiling,
the large-table production lead over a12-bpk Boost configuration is only0.5%.
These small margins need new-seed confirmation; the original broad leads must
not be extended to this expanded capacity set.

The two isolated range-capacity types offer useful candidates. Split64Range at
24bpk takes5.521ns/key in the strict large-table setting,4.2% faster than the
best qualifying external row. It uses96MiB, versus128MiB for the production
winner. Its observed FPR is0.00875%, with a pointwise two-sided95% Wilson upper
endpoint of0.00921%; Boost's corresponding upper is0.00970%. Under the loose1%
ceiling, Split64Range at12bpk takes4.041ns/key versus Boost's4.194ns/key, a3.8%
lead. Neither narrow lead is held-out evidence, and these range prototypes have
not been promoted or given native Rust/parallel-construction support.

Across the prespecified16/32-bpk caps, production leaders win10/10 comparable
prehashed selections and9/10 staged hash+query selections in this one-seed run.
The two16-bpk/0.01% settings have no qualifier in any group. These nested settings
share data and candidates; they are not independent statistical trials. All202
qualified individual native/experimental comparisons, including losses, remain
in the JSON report. The632 calibration identities are counted once each, without
pooling repeated API mappings into extra negative probes.

The supplementary frontier also shows where lower budgets admit an external
configuration but no production native. At20bpk and0.01%, a classical external
filter qualifies; neither range prototype does. A winning32-bpk row therefore
does not establish dominance across all memory budgets. The chart deliberately
uses at least a twofold vertical span so sub-percent gaps are not exaggerated.

This run uses CPU2,65K/32M keys,50% hits,batch4096,seed42,six balanced query
repetitions and2^24 independent negative probes per mapping. Each configuration
has one complete unmeasured build. Construction speed, public-singleton speed,
multithreaded speed and other hit rates are outside this result. CPU affinity
does not impose explicit NUMA memory binding. Raw-key staged hashing can have a
different cache/dispatch cost from prehashed queries; the two metrics are ranked
separately, with the same batch lookup kernel in both.

See [all main rankings](RESULTS.md), the [supplementary capacity frontier](CAPACITY-FRONTIER.md),
[all988 rows](results.csv), and [quality identities and individual losses](summary.json).
The measured source commit is `d70077b28fb3cd5821ae471f185e98393423ec64`.
Source, binary, committed-inventory, full output, exact geometry, phase/trial and
equivalent-mapping checks passed for every case and at final completion. A second
review independently reproduced all24 main winners and ratio directions.
