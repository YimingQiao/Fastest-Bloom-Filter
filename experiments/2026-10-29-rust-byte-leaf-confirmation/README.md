# Unchanged Byte leaf hint: order-balanced confirmation

Source-only preparation. No new compilation or performance run. The original seed42 screen and its large actual32-bpk batch3 regression remain archived. The subsequent machine-code audit found identical active AVX2 bulk instructions for the original and candidate, including the two-key loop and odd tail; code addresses and loop alignment differ. This motivates confirmation, not a production decision.

The original 108-row proposal is preserved byte-for-byte under `pre-data-108/`, including its manifest and 15 passing offline checks. It was superseded before any performance data. Its source files and freeze describe the prior locations and form a historical snapshot; relocated scripts are not an independently runnable package. The active protocol now adds three seeds chosen only to balance filter order.

Use the exact leaf executable SHA256 `0caf0d3ff982ffdc295b6bb7010ae148bd5ffa240426573429e2ae2e92036926`, built from the source archived at commit `9011d5228118373f89786d3a1a304f83ea689a85`. The clone still contains the same three original annotation changes, but this registry selects only Byte's unchanged original and experimental types. No new hints, rebuild or routing change is allowed. Bloomsday is the shortlisted strongest visible external baseline; this is not an exhaustive external comparison.

The fixed grid is key powers 16/25, requested 8/16 (actual 16/32 bpk), batches 1/3/31/4096, query power 22, 50% hits, eight balanced four-mode repetitions, whole-input insertion and calibration power 24. The original seeds 131071/524287/999983 remain, with 1000003/1000004/1000018 added. Batch1 selects original Byte, candidate Byte and Bloomsday. Other batches select only the two Byte types. This gives **96 workloads / 216 rows**.

`seed_selection.py` declares the candidate integers 1000003 through 1000258 before measuring any of them. It chooses the lexicographically first ascending triple that completes a 3:3 original-before-candidate split in all four independent order groups: small/large key counts, each with the three-row or two-row registry. It reads no timing, FPR or key data. `seed-selection.json` records all 256 candidate IDs and signatures, the original signatures, target counts and selected triple. The new values were absent from earlier repository protocol seed fields at preparation time.

The RNG advance count is derived directly from the unchanged producer: one base draw, n−1 insertion shuffles, one draw per hit, q−1 query shuffles, then the short job shuffle. The derived order matches all 16 retained initial workloads. Requested bpk does not affect those advances, and batches 3/31/4096 use the same two-name registry. Thus all 16 size/budget/batch groups have both relative orders exactly three times. `filter-order-plan.json` records all 96 expected orders. Bloomsday's absolute row position is recorded without claiming it is balanced. Changing selection-string order cannot change the producer's canonical registration order.

The four query contracts remain separate: original batch prehashed, original batch staged common hashing, whole-array public singleton prehashed, and whole-array public singleton fused common hashing. The driver checks exact seed-derived Williams phase order, all trial medians/ranges, workload and byte counts, clone semantic parity, cross-batch consistency and actual filter row order. Dense-output and calibration validation stay inside the frozen executable.

CPU2/socket0 is planned. The whole matrix must inherit the actual exclusive `/tmp/fastest-bf-socket0.lock` descriptor, use `BF_SOCKET_LEASE=socket0-cpu2`, and have CPU2-only affinity. Python `-O` fails at entry. No explicit NUMA memory binding is claimed. Initial CPU3 and confirmation CPU2 timings are not pooled; conclusions use original/candidate pairs in the same new process.

Retain every seed's gains and losses, including the initial seed42 failure. Use actual-byte caps 16/32 and FPR ceilings 1%/0.1%/0.01%; report each seed's pointwise two-sided 95% Wilson endpoint and the worst endpoint. Across-seed eligibility requires every endpoint to pass. Do not pool reused batch, clone or query-mode calibration. Native-only bulk guards cannot establish external leadership. No numeric promotion threshold or statistical speed confidence interval is implied; retain all trial ranges and paired ratios for review.

Source, dependency and executable hashes are checked before and after the full matrix, with lighter source/executable checks before each workload. Committed blobs must match the reviewed protocol commit. Existing result directories cannot be overwritten or resumed.

Proposed command, only after commit and explicit lease:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 env BF_SOCKET_LEASE=socket0-cpu2 \
  python3 experiments/2026-10-29-rust-byte-leaf-confirmation/run.py \
  --source-commit FULL_REVIEWED_COMMIT
```

The 17 offline row/order/lease checks use preserved earlier rows and temporary real lock files. They neither execute the benchmark nor consume the six confirmation seeds in a measured workload.
