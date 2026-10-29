# Additive assembly-only completion

V1 source6fd92279 completed all normal/ASan functional checks, then failed closed on an empty GNU objdump selection. The raw mangled name plus `--demangle --disassemble` did not select a body. Original failed metadata and all256 artifacts remain committed at4a73933e; this stage never rewrites them.

This recovery replays all47 recorded command statuses, eight tests,24 actual rows, four immutable-reference rows and12 CLI rejections. It verifies all four existing binaries, both compiler-input closures and toolchains before and after capture. There is no compiler, BF execution, timing sample, changed kernel, new input or automatic performance stage.

The exact actual `nm --print-size --demangle` address/size selects Poppy044's run and constructor using start/stop addresses. The first decoded instruction must match the start, every decoded instruction must lie in the span, and the actual symbol header must exist. Full linked disassembly is also captured so manual review can follow shared/out-of-line public hot bodies rather than assuming every const-ID has a distinct symbol. The capture result remains marked manual-review-pending.

After exact source commit and the granted CPU2/socket0 lease:

```sh
BF_SOCKET_LEASE=socket0-cpu2 flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 experiments/2026-10-29-poppy-public-speed-caller/assembly-recovery-v2/recover.py \
  --source-commit FULL_RECOVERY_COMMIT
```

Only the new `capture-v2/` directory is written, and it must not exist. Any capture failure remains there. Manual actual-clock/public-body review follows; it must be complete before a compiled-worker freeze or performance use.
