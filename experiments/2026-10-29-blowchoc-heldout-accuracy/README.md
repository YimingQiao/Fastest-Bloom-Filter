# Prespecified held-out BlowChoc accuracy

This separate stage retains every configuration from the earlier accuracy screen:
four native controls plus BlowChoc choices1/2 × probes8/14 × random/distinct bits.
The frozen bridge and first-screen archives remain untouched. No throughput is
measured or ranked.

Two input/construction pairs are fixed before data:

* Input31991, construction503.
* Input97157, construction1709.

Each pair covers n2^16/2^20 and requested8/16 (actual16/32bits/key): eight cases,
96 rows. Every case uses q2^20, batch4096, hit50% and 2^24 independent negatives.
`protocol.json` fixes all64 BlowChoc construction hash sets. The native four
filters do not use construction seed; their rows state this explicitly.

The four unique input-seed/size calibration intervals are pairwise disjoint,
disjoint from every held-out inserted/query range, and disjoint from all original
seed42 screen ranges. Requested8/16 reuse a logical stream; repetition receives
no extra sample credit. Results will report each case's raw counts/upper bound
and the worst case. Counts from different construction hash functions will never
be pooled into one confidence interval for a fixed filter.

Before accuracy in each case, all eight actual-size/hash parameter sets pass the
independent full-bitmap/full-answer oracle. Every earlier factory is rebuilt and
requeried after later factories overwrite upstream module hash names, with no
new signatures allowed. All inserted keys and complete dense outputs are checked
through the frozen prehashed/fused/staged paths. Actual backing allocation,
positions scratch, compiler/JIT settings and source/binary hashes are retained.

Preparation is standard-library-only and does not compile/JIT or query filters:

```sh
python3 experiments/2026-10-29-blowchoc-heldout-accuracy/prepare.py --screen-commit COMMITTED_SCREEN_SHA
```

Execution requires an explicit socket1 lease after the queued KTEST and SBBF
screens; the entire matrix holds the lock:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 benchmarks/blowchoc-external/.venv/bin/python experiments/2026-10-29-blowchoc-heldout-accuracy/run_matrix.py
```

Existing results are never overwritten. The runner refuses missing provenance
commits, changed source/binary hashes, different runtime/CPU settings, or any
construction hash that differs from the prespecified protocol.
