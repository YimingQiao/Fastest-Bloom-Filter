# Fixed K12 line-OR screen with balanced relative filter order

This runner uses the already checked normal caller from proof commit `422e2512932ac2d23b21ade9ae45e58e93bce6f2`, binary SHA256 `46c593a4740f161fac09e78e2b745f9b2aba7f2ea34ac6f4d7e06ec0061461cf`. It does not compile or change a filter. The original eight workloads remain exact: n16/n25, actual24 bpk, insertion chunks4/all, seeds5011/6011, five build repetitions, q18/hit50/batch4096 and two semantic-control query repetitions. All64 construction vectors/320 metric samples are retained. Insert and allocation-plus-insert are nested intervals of the same build and are not independent observations.

Before formal data, the parent corrected an avoidable order imbalance: after the original source shuffle, seed5011 uses `original` and seed6011 uses `reverse`. Each size/chunk therefore has control-first and candidate-first once. The strict final flag consumes no RNG and changes no timed helper or input. The old all-control-first proposal/proof remains archived. Normal/ASan both-order callers match old outputs, and all8 actual insertion function bodies match the old binary after address normalization. No formal data was used to pick a variant, seed or order.

The second seed reverses the outer four-case order as already specified. Pure-before-common-hash build phase order remains fixed. Relative filter position is balanced across two seeds, but phase, code placement and temporal effects are not independently isolated. These are descriptive training results, not a significance test or general performance guarantee.

Each case runs both actual public types in one process under CPU3 with explicit NUMA1 binding. The full matrix holds the inherited exclusive socket1 flock. The earlier138-artifact native/minimal-F/ASan kernel proof and new84-artifact order proof are committed and verified, along with all8 old/new binaries and404 consumed compiler inputs. No repeated1642-case matrix is needed or executed. Source/raw order, complete vectors, exact workload/geometry/FP/checksums and command ledger are audited before interpretation. No partial ranking changes later cases.

Timed bitmap lifetimes remain symmetric:160 fresh build objects and16 subsequent canonical validation objects across16 rows. Only one bitmap is live during construction. Allocation belongs to its total boundary; validation/destruction are outside timers. First prehashed/common-hash builds and canonical filters check all inserted keys. The independent full-word checker is the mapping evidence, not a checksum alone. Query metrics remain semantic controls and are not ranked.

After the parent grants the committed runner, execute:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 \
  python3 experiments/2026-10-29-k12-line-or/screening/run.py \
  --source-commit FULL_REVIEWED_RUNNER_COMMIT --execute-frozen
```

The output path must be absent; failures stop and remain preserved. Seal complete raw data before analysis. Report all32 candidate/control construction ratios as **candidate latency / control latency**, with values greater than1 slower, all trials and per-cell seed ranges. Whole allocation-plus-build takes priority over insertion-only gains. There is no query, FPR, multithread or strongest-external claim. A promising result requires separately fixed confirmation; a loss ends this variant without parameter search.

Offline guards pass9 tests. The first offline run used a nonexistent test-only ledger key and failed; its output is preserved. Correcting the assertion to the actual frozen `insert_chunk` field changed no producer, plan or filter.
