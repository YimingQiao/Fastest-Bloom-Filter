# Fixed higher-resolution audit of all eight APIs

The completed144-row confirmation found one FourSector construction whose
calibration interval straddles0.1%. This additive accuracy-only audit applies
the same extension to **every API and every one of its six constructions**.
The proposal was recorded before this driver in the confirmation analysis.
No source, binary, construction or historical result is changed.

Use the frozen76-API binary from9e4362f, n65,536, actual allocation cap16bpk,
the same six order-conditioned seeds, q2^22,50% hits and batch4096.
Run exactly12 processes: for each seed, all eight APIs at cal24, then cal27.
The first sample must exactly reproduce the old count and output semantics.
Subtract it from the nested total to retain **117,440,512 fresh disjoint
negative keys** per construction. There is no early stopping or further
extension based on results. Keep every pass and failure.

The48 API/seed rows represent36 mapping/seed samples: Range/Fixed64 and
Rocks direct/batch aliases do not create independent evidence. Do not pool
aliases, seeds, the old prefix or repeated batches. Report individual
two-sided95% Wilson intervals and each interval's upper endpoint against0.1%.
Those per-construction intervals are not simultaneous coverage or a guarantee
over random constructions. Keep the original gate and new suffix gate separate;
do not overwrite the fixed144 confirmation's eligibility or rankings.

The harness performs its mandatory two query repetitions and one untimed
construction. Preserve those raw fields but make **no timing claim** from this
audit. No build trials are requested. The runtime guards verify the committed
protocol, all321 inherited inputs and39 binaries before/after the matrix and
before every case, exact geometry, complete eight-API results, source-derived
order, lease ownership, original checksums and calibration aliases.

Run only after committing this protocol, under the assigned exclusive socket:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  env BF_SOCKET_LEASE=socket0-cpu2 python3 \
  experiments/2026-10-29-eight-api-quality-resolution/run.py \
  --source-commit FULL_COMMIT --cpu 2
```

The output directory is exclusive-create; a failed attempt is preserved.
