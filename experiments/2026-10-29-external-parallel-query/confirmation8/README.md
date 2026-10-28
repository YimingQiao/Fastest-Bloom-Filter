# Eight-core fresh-seed confirmation

This follow-up is scoped to eight physical cores and batch4096. It reuses the
unchanged full 56-config executable and the same 23-name shortlist, with source
commit `b437791b6edf23fe8725f87e62d21d638216861a`. One-core and four-core results
remain screening evidence; this run does not confirm those modes.

`protocol.json` was written before measurement. Its 12 cases cover n=2^16/2^25,
requested8/16 bpk, T=8, 50% hits, 2^22 timed queries, five repeats and fresh seeds
19867/45631/93187. Each configuration receives 2^24 independent calibration
negatives per seed. Serial insertion uses the whole input in one call. The
complete matrix holds `/tmp/fastest-bf-socket1.lock`, pins caller worker0 plus
seven new threads to CPUs3,5,7,9,11,13,15,17, and binds allocation to NUMA node1.

`run_confirmation.py` verifies the frozen framework files and executable before
and after execution. It writes LF CSV and records every command, CPU topology,
compiler command, protocol hash, runner hash and source/executable preservation
checks. No filter, adapter or benchmark-source change is part of this follow-up.

## Selection and paired evidence

The summary first deduplicates the same logical negative stream across thread
counts or query batches. It then pools the three **distinct new-seed** streams
for each exact filter/allocation/n/timed-q/insertion-batch configuration: 50,331,648
negative probes per configuration. Seed42 is excluded. It does not pool across
different timed query counts. Both pooled and per-seed Wilson95 upper bounds are
reported, so a pooled pass cannot hide an individual seed's weaker confidence
bound.

For each metric and memory/FPR tier, the summary considers every measured
allocation under the actual-byte cap. Eligible fixed configurations are ranked
by the median of their three per-seed timing medians. The selected native and
external configurations are then compared on each identical seed, retaining the
three ratios, their range and timing-sample overlap. A conservative second check
compares the selected native configuration with the fastest pooled-quality-eligible external
separately in each seed, including its identity, allocation and per-seed quality
bound. Per-seed quality is reported separately; pooled quality defines selection. This check can
reveal a lost seed even when the fixed aggregate pair wins.

Pure query and hashing-plus-query stay separate, as do gated execution and
fresh-thread end-to-end time. Individual native-family comparisons preserve
losses that a portfolio winner would hide. Native scaling uses `lookup_ns` or
`hash_lookup_ns` from the **same T8 row and seed** as its serial control. No T1/T4
timing from the earlier screen is reused.

The summary requires all three expected seeds for every configuration, rejects
duplicate timing rows and inconsistent calibration or output, and verifies the
raw launch/query/join decomposition. Tests cover deduplication before pooling,
old/missing seeds, different query sources, pooled versus per-seed confidence,
fixed versus per-seed external rivals, actual-memory caps, individual losses,
separate metrics and same-row serial controls.

```sh
flock /tmp/fastest-bf-socket1.lock python3 \
  experiments/2026-10-29-external-parallel-query/confirmation8/run_confirmation.py
python3 experiments/2026-10-29-external-parallel-query/confirmation8/test_summary.py
python3 experiments/2026-10-29-external-parallel-query/confirmation8/summarize.py
```

The runner refuses to overwrite results. Final artifacts include raw rows and
metadata, portfolio and per-family qualified comparisons, pooled calibration
with each seed retained, and direct-serial ratios. Any conclusion is limited to
this host, workload, shortlist and eight-core query protocol.
