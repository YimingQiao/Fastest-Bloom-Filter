# Bounded multithreaded query screen

This is a prespecified screen of the same 23 configurations used in the native
ByteSplit primary C++ comparison, selected from the frozen 56-config executable.
It is not a new universal-fastest claim or a held-out confirmation. The framework
source commit is `b437791b6edf23fe8725f87e62d21d638216861a`; the protocol records its
source/archive and executable hashes before measurements.

`protocol.json` specifies 12 cases: 2^16/2^25 inserted keys, requested 8/16 bpk
(nominal actual caps 16/32 bpk), T=1/4/8, batch 4096, 50% hits, seed 42,
2^22 timed queries, three repeats and 2^24 independent negative calibration
queries. Serial insertion consumes the whole inserted set in one call. All 276
rows use the same frozen executable. The complete matrix holds the socket 1
flock, uses physical CPUs 3,5,7,9,11,13,15,17 as needed, and binds memory to NUMA
node 1. Caller worker zero is included in T; only T-1 threads are spawned.

`run_screen.py` verifies the original framework freeze before execution and
checks it again afterward. Every filter validates all inserted keys and every
parallel/serial query output outside timing. The runner verifies exact selected
names, row counts and workload dimensions, writes LF CSV, and records commands,
CPU topology, compile flags and source/executable preservation metadata.

## Summary rules

`summarize.py` keeps pure-query and hash-plus-query measurements separate, and
also separates gated query time from fresh-thread end-to-end time. Rankings are
paired by n, q, T, batch, hit rate, repeats, seed and insertion batch. They select
the fastest eligible native configuration and the fastest eligible external
configuration independently, considering **both** measured allocations under
each actual-byte cap. A 32-bpk cap therefore also admits qualifying 16-bpk rows.
Actual bytes, rather than requested-bpk labels, determine eligibility.

FPR eligibility uses the two-sided 95% Wilson upper bound of the independent
negative calibration. The same filter/n/allocation/seed/timed-q/insertion-batch
has the same bitmap and calibration stream across T and query batch sizes.
Those repeated entries must match and count once; they do not provide extra
negative samples. Different timed query counts are distinct source streams and
are never pooled. These are per-configuration confidence bounds, not a global
multiple-comparison confidence statement.

The analysis rejects duplicate timing rows, changing allocation or answers for
the same configuration, mismatched repeated calibration, malformed raw timing
samples, and incomplete launch/query/join timing decompositions. Raw-key-only
PageBloom remains in hash-plus-query comparisons and is excluded from pure-query
comparisons. The tests cover these rules and the smaller-allocation rival case.

Outputs after completion:

- `results/qualified-comparison.csv`: native versus strongest eligible external,
  by T, metric, memory cap and FPR target. Selection uses observed medians; sample
  min/max overlap is reported without claiming statistical speed significance.
- `results/native-scaling.csv`: each fixed native filter/allocation versus its
  own T=1 result. This scaling evidence is separate from external superiority.
- `results/qualified-family-comparison.csv`: each native family separately versus
  the strongest eligible external, so a portfolio win does not hide individual
  native layouts that lose.
- `results/summary.json`: full quality counts, deduplication and comparisons.

The default quality grid includes 16/32-bpk caps and 1%/0.1%/0.01% targets. A
target with no qualifying native or external row is stated explicitly. There is
one screening seed and three timing repeats; results can motivate a later
confirmation but do not establish a hardware-independent ranking.

```sh
flock /tmp/fastest-bf-socket1.lock python3 \
  experiments/2026-10-29-external-parallel-query/screening/run_screen.py
python3 experiments/2026-10-29-external-parallel-query/screening/test_summary.py
python3 experiments/2026-10-29-external-parallel-query/screening/summarize.py
```

The runner refuses to overwrite its output directory. No performance result is
promoted to the main README by this experiment.
