# Frozen two-round singleton query comparison — execution not yet authorized

This entry reuses the passed normal09fc4cb7 executable without rebuilding. Proposal42f5d62 fixes96 processes/192 rows,240 candidate/control latency contrasts,480 complete trial vectors and3840 samples. Actual caller2c85beb and proofc2cd9f7 close public APIs, mapping, minimal-F, sanitizers and manual clock/ISA review. `proof-binding.json` pins all six proof executables,396 actual compiler inputs, the complete204-artifact proof, native prepared sources and tool identities. No source/kernel/ISA parameter is selected from future data.

`ledger.json` and `protocol.json` are exact committed proposal bytes. Each n16/n25, actual24bpk, hit0/50/100, batch1/3/31/4096 and seed16057/32029 case executes in two launch rounds. The second round reverses the entire48-case ledger and each explicit A/B order after ordinary job shuffle, without extra RNG. Every same-input case sees both orders. There is no calibration between rounds; environment/history differences still prevent an isolated order-causality claim. No seed or hit-rate pooling hides a loss.

Every row retains generic prehashed/staged-common samples. Batch1 additionally retains actual public optimizer-visible prehashed/fused-common samples; other batches require empty visible vectors. Each row uses one canonical untimed serial build and has no construction metrics or FPR qualification ranking. Full expected outputs/guards and raw/hashed input digests are checked every trial in the frozen executable. The producer verifies exact control/candidate answers/bitmap and all same-input chunk/round identities, plus hit-independent construction identities. These are same-mapping checks, not independent quality observations.

`run.py` requires a reviewed committed source inventory and explicit `--execute-frozen`, parentCPU3 under an inherited exclusive socket1 flock, and each child runs with explicit `numactl --physcpubind=3 --membind=1`. Source/proof/input/binary/tool closure is checked before and after the whole matrix; the selected executable and placement are checked for every process. Each child inherits the actual whole-run lock descriptors via `pass_fds`, so it retains the lease even if its waiting parent disappears. The exact descriptor list is archived and replay-checked. Any failure stops and retains its raw logs and metadata. Only complete-process counts are printed during execution. No partial ranking, rerun, extension, threshold choice or recompilation is permitted.

`results-v1` will hold96 exact stdout/stderr pairs, ordered `records.json` and `metadata.json`. Final source/placement/raw/semantic audits precede the194-file `RAW_ARCHIVE.json`; the full outer `screen-run.log` is separately committed. Completion counts are nested under `counts`, keeping the full `cases` list intact. An offline loader must first verify exact committed raw blobs. The agreed interface is `audit.load_complete(raw_commit, raw_manifest_sha256) -> (metadata, records)`; it fails closed until complete and validates live immutable proof/input/binary/tool identity on this archive host. This requires the archived executables/inputs to remain available; a fresh clone cannot bypass the checks by substituting rebuilt binaries.

All240 paired latency ratios use candidate/control (>1 means slower). Keep every per-round/seed/hit/size/batch/contract loss and all480 vectors. Only descriptive same-cell four(seed×round) ranges are appropriate; shared samples/inputs and launch history are not independent trials. Bulk31/4096 remains an unchanged-source control, with code-placement differences allowed as measured outcomes. The candidate also changes compiler inlining/frame/unrolling relative to the original per-key scalar call, so do not attribute its whole effect solely to the64B load. No external, Rust, multithread, build-speed or new FPR claim follows.

After parent source review and an explicit socket1 performance lease, launch once:

```
flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 \
  bash -c 'set -C; exec python3 -B experiments/2026-10-29-k12-singleton-vector-plan/screening/run.py \
  --source-commit <exact-commit> --execute-frozen \
  > experiments/2026-10-29-k12-singleton-vector-plan/screening/screen-run.log 2>&1'
```

No formal execution has occurred at this source stage.
