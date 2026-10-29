Separate source-only analysis prepared while native60 measurements run. No
partial measured rows are read and no result changes the fixed selection.

`summarize.py` first runs the frozen producer’s complete raw/aggregate/source/
placement/order audit, then requires all75 raw/root-audit files and their manifest to match an exact supplied
committed revision. It emits180 same-row serial/parallel ratios,120 same-public-
API T1→T4/T8 ratios,144 equal-byte Range/Split pairs,360 metric records and20
quality records. Every regression survives; no quality-based or timing-based
candidate selection is performed. C++/Rust records remain separate and repeated
calibration streams are not pooled. Synthetic tests require no Bloom execution.

The public native query receives one whole array. It is distinct from the prior
external4096-batch shared executor and has no hash-inclusive or gated metric.
This single-seed screen has balanced within-row build/query order but fixed case
and language order, with all builds preceding queries. No production promotion
or global fastest claim follows from these descriptive summaries.

The first analysis invocation stopped before interpreting timings because its
inventory expected only the74 producer files, while the committed archive also
contains root-verification.txt. That failed invocation is preserved in
analysis.stdout/stderr. The additive guard now requires the exact75-file
committed SCREEN_ARCHIVE.json, including that independent audit artifact.
No producer, measurement, selection or latency formula changed.

The second invocation produced all numerical CSVs in report/ but stopped at
plotting because /usr/bin/python3 lacks matplotlib. An attempted isolated venv
could not bootstrap pip (ensurepip unavailable); no package was installed.
The successful report-final/ uses the already installed
/home/yiming/anaconda3/bin/python. The subsequent report-complete/ expands only
the narrative; that final text and corrected SVG are also copied to the
authoritative report-final/. All numerical CSVs are compared
byte-for-byte against the previous outputs. Plot tool versions are recorded.
Visual inspection caught clipped query curves in the first shared-axis SVG;
report-complete/scaling-large.svg now sets each column's bounds from all of its
large-input points. An offline regression checks that bound calculation. The
earlier SVG remains as report-final/scaling-large-clipped.svg and the initial
text as REPORT-initial.md; all numerical tables are unchanged.
