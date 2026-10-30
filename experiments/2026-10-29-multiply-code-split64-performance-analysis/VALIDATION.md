# Analysis verification

The producer screen is unchanged. Source commit`9e4362f1068d37d134ef8447a44146b52c1edc9f`,321 frozen input entries,39 executable hashes, all13 case commands/raw hashes, exact76-source registry/order and70 aggregate rows are checked before interpretation. All62 retained controls reproduce their non-timing fields from immutable parent data commit`fe41689efd4f283abedf066ea1416fcfbe8d9444`; no older latency is imported. The24-row accuracy pilot has a different counter interval and is not required to reproduce candidate counts.

Sixteen offline tests pass. They cover allocation caps, smaller rivals, pointwise upper bounds, aliases/no pooling, five ownership classes, raw-only unavailable pure metric, exact ties and malformed ownership, raw/aggregate cardinality and ordering, phase/trial corruption, exact source-derived shuffle draws, all62 semantic reproductions, direct pairs without invented geometries, and independent history-exclusion sensitivity. No Bloom filter or compiler was executed by this analysis.

The initial test-import attempt failed because the copied test imported the frozen order oracle before the analyzer established its source path. Only test import order was corrected; the failed stdout/stderr remain under`initial-import-*`. Fifteen guards then passed and the first complete analysis succeeded. A separate known-failure-exclusion sensitivity and its sixteenth test were added after identifying the historical FourSector16 caveat; primary rankings/counts were not changed. Final logs are`tests.*` and`analysis-final.*`; final output is`report/`. The earlier successful analysis stdout is retained, and the superseded generated report was replaced with the expanded report.

Independent read-only review by`/root/external_cpp` found no blocker in the70-row anchors/order,62 retained reproductions,64 quality records, cap nesting and ownership. The reviewer separately approved the sensitivity delta: default eligibility stays unchanged; history exclusion consistently affects leader selection and individual eligibility; no sample pooling occurs. The report discloses unequal historical coverage and postprocessing scope.

To regenerate into a new directory:

```sh
python3 -m unittest discover -s experiments/2026-10-29-multiply-code-split64-performance-analysis -p test_summary.py
python3 experiments/2026-10-29-multiply-code-split64-performance-analysis/summarize.py --output /tmp/multiply70-report-reproduction
```
