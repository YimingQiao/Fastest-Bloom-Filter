# Fixed86 full-load public accuracy execution

Run the exact normal worker from the passed normal/ASan caller proof, once per
constructor in `ledger.json`. The ledger is the complete original86-row public
geometry selection, including all controls above allocation ceilings. Each row
runs in a fresh process under one inherited whole-operation socket lease. The
worker inserts the real65,536 or33,554,432 keys and checks every inserted key,
then executes the fixed mixed dataset and67,108,864 independent negatives.

All source, proof and executable identities are checked before and after the
complete sequence. Every stdout/stderr and exit is retained immediately. An
unexpected diagnostic, failed insertion, false negative or contract mismatch
stops the attempt and preserves it. There is no automatic rerun, adaptive
sample extension, quality pruning, compiler invocation or throughput timer.
The runner seals the raw archive before any quality analysis.

The fixed analysis reports one pointwise two-sided95% Wilson interval for each
constructor, then all alternatives under actual12/16/24/32-bit ceilings and
1%/0.1%/0.01% FPR ceilings. The17 proven None/Space aliases must reproduce their
counts and checksums, but no repeated denominator is pooled. Other mappings
may be labelled from the existing source selection; they add no independent
sample. Seed42 is seen training data. This stage cannot establish a speed win.

Run after freezing this directory's source commit:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 \
  experiments/2026-10-29-poppy-public-accuracy/screening/run.py \
  --cpu 2 --source-commit FULL_RUNNER_COMMIT
```
