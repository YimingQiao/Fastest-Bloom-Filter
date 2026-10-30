# Focused bounded-policy correctness preparation

This additive stage leaves all13 source artifacts committed at
07746e17f82e3fa48adf3bbd1f6fed00daf71514 unchanged. Its wrappers still depend on
the exact36 native inputs from5fd487fe3381ce05be2ba823a6137107f4108854. No source
in either native library is copied or changed here. There is no benchmark timer,
new FPR calibration or performance authority.

The cheap Spy Native covers both enabled/disabled wrappers, seven batch-length
boundaries, six byte footprints and requests0/1/4/8:336 spy cases per executable,
each checking six complete method forwards. It verifies input/output addresses
and lengths, delegated return values, effective requests, worker/scratch
forwarding, unchanged serial insert and unchanged query request. This is not a
cartesian Bloom-filter workload.

Real filters use exactly these six cases per family:

| ID | Actual bitmap | Increment | Request | Initial history | New input |
|---:|---|---:|---:|---|---|
|0|256KiB|65,536|1|empty|uniform|
|1|256KiB|65,537|4|empty|uniform|
|2|256KiB|65,536|4|131,072 existing hashes|line0 hotspot|
|3|Split512KiB; Range256KiB+64B|65,536|8|empty|uniform|
|4|Split64MiB; Range96MiB|65,536|0/automatic|empty|uniform|
|5|Split64MiB; Range96MiB|65,536|8|bytes/2 existing hashes|line0 hotspot|

Above-footprint case3 keeps request8 so an incorrect serial fallback is visible.
Case2 exercises a real baseline multiworker build versus the bounded W1 path.
Case0 covers explicit1 without adding a separate matrix. C++ and Rust, normal
and ASan, yield48 real configurations and144 filter lifetimes (three sequential
variants per configuration). Each filter is destroyed before the next allocates.

History streams use fixed SplitMix64 finalization from state
0x243f6a8885a308d3, with the standard increment, generated in4096-key blocks.
Old indices start0; new indices start2^40; negative probes start2^41. Hotspots
zero the high32 of each new hash and preserve its independently generated low32.
No old-key array is retained. Every reference/control/candidate receives the
same complete history and new batch. After insertion, every old and new hash is
looked up and required to return1. The32,771 mixed queries retain the full dense
array and prefix/suffix guards for serial and original-request parallel lookup.
The query length supports real multiworker lookup and a non-vector-size tail.

The real automatic case compares against the original native automatic worker
getter under the same allowed affinity as insertion. C++ uses hardware_concurrency
while Rust uses available_parallelism; these existing policies can differ.
The disabled wrapper records that native observation; the enabled wrapper must
retain it outside the bound. Inside the bound, automatic build request becomes1.
Actual scratch is checked against each observed W and the language's exact
formula. Cross-language output equality does not force automatic worker counts
or scratch to match. Same-language normal/ASan accounting must match.

The driver may use an explicitly assigned CPU2/socket0 or CPU3/socket1 lease.
Its parent remains on the leased single core. Child taskset expands to the first
three physical cores on that socket before numactl validates/binds them and
node-local memory. Public worker threads inherit this unchanged three-core mask
throughout each process, including the automatic worker getters and insertion.
These are correctness runs, not core-scaling measurements; requested W may exceed
three. No claim of individual worker pinning or changed automatic scheduling is
made. Every heavy command must inherit the same full-operation exclusive flock.

After source review/commit and an explicit lease, the only execution entry is:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 \
  env BF_SOCKET_LEASE=socket1-cpu3 python3 \
  experiments/2026-10-29-native-build-policy/preflight/validate.py \
  --source-commit REVIEWED_FULL_COMMIT --cpu 3 --execute-correctness
```

For an explicitly assigned socket0 lease, replace socket1/cpu3 with socket0/cpu2
and pass `--cpu 2`. Both placement paths are guarded. The runner refuses
existing/dangling output and build targets, uses exact committed source pins,
collects all actual C++/Rust dependency files, checks representative wrapper and
native inputs were consumed, and retains every command outcome. Normal and
ASan/UBSan C++ plus normal and ASan Rust are the only build modes. Existing
kernel/backend proofs are reused. The path-only Cargo.lock is prepared without
running Cargo and will be checked by the future --locked --offline build.
