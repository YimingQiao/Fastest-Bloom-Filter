# Unchanged Byte leaf hint: paired confirmation protocol

Source-only preparation. No new compilation or performance run. The original seed42 screen and its large actual32-bpk batch3 regression remain archived. The post-screen disassembly check found identical active AVX2 bulk instructions for the original and candidate, including their two-key loop and odd tail; code addresses and loop alignment differ. This motivates confirmation, not a production decision.

Use the exact leaf executable SHA256 `0caf0d3ff982ffdc295b6bb7010ae148bd5ffa240426573429e2ae2e92036926`, built from the source archived at commit `9011d5228118373f89786d3a1a304f83ea689a85`. The clone still contains the same three original annotation changes, but this registry selects only Byte's unchanged original and experimental types; no new hints, source rebuild or routing change is allowed. Bloomsday is retained only as the shortlisted strongest visible external baseline, not as evidence of exhaustive external coverage.

The fixed grid is key powers16/25, requested8/16 (actual16/32 bpk), batches1/3/31/4096, fresh seeds131071/524287/999983, query power22, 50% hits, eight balanced four-mode repetitions, whole-input insertion and calibration power24. Batch1 selects original Byte, candidate Byte and Bloomsday. Other batches select only the two Byte types. This gives48 workloads /108 rows.

All four contracts remain separate: original batch prehashed, original batch staged common hashing, whole-array public singleton prehashed, and whole-array public singleton fused common hashing. Dense-output and calibration checks stay inside the frozen executable. The driver checks each complete row, exact seed-derived Williams phase order, medians/ranges/trial vectors, clone semantic parity, cross-batch consistency and exact seeded filter row order. The latter is derived independently by counting input-generation SplitMix draws and replaying the short job shuffle. Phase order is balanced; filter row order is seed-varied but is not guaranteed balanced. The actual order is retained per command. Changing selection-string order cannot change the producer's canonical registration order. The source-derived plan shows original Byte before its candidate in all three large-table batch1 seeds; the two-row bulk guards include both relative orders. This limitation remains explicit in interpretation.

CPU2/socket0 is planned. The whole matrix must inherit the actual exclusive `/tmp/fastest-bf-socket0.lock` descriptor, use `BF_SOCKET_LEASE=socket0-cpu2`, and have CPU2-only affinity. Python `-O` is rejected at entry. No explicit NUMA memory binding is claimed. Initial CPU3 and confirmation CPU2 timings must not be pooled or directly treated as a controlled CPU comparison; conclusions use original/candidate pairs in the same new process.

Every seed's gains and losses remain in the report, including the initial seed42 failure. Use actual-byte caps16/32 and FPR ceilings1%/0.1%/0.01%; report each seed's pointwise two-sided95% Wilson endpoint and the worst endpoint. A configuration qualifies across seeds only if every endpoint passes. Do not pool reused batch, clone or query-mode calibration. Native-only batch guards cannot establish external leadership. No predeclared numeric promotion threshold or statistical speed confidence interval is implied; report all trial ranges and all paired ratios for review.

The frozen source/dependency/executable check runs before and after the full matrix, with lighter source/executable checks before each workload. The committed-source guard must match the final protocol commit supplied by the parent. No overwrite/resume is allowed into an existing result directory.

Proposed command, only after commit and explicit lease:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 env BF_SOCKET_LEASE=socket0-cpu2 \
  python3 experiments/2026-10-29-rust-byte-leaf-confirmation/run.py \
  --source-commit FULL_REVIEWED_COMMIT
```

Offline row/order/lease regressions use preserved earlier rows and temporary real lock files. They neither execute the benchmark nor consume the new confirmation seeds in a measured workload.
