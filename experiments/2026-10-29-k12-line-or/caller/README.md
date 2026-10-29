# K12 line-OR two-type caller preflight

This additive stage implements the approved source-only proposal at `5cb840406f1b4c48763bd660246e51c03bfe56c2`. It has not been compiled or executed. The fixed eight-workload performance screen is not run by this driver.

`derive.py` obtains the immutable K12 shared caller from `2263cf29ebc87d589b49ca015133312993b7db73`. It replaces its broad header/registration closure with only the unchanged control and the one candidate, and appends all four build trial vectors in the output section. The complete region from public helpers through timed builds, canonical validation, query trials and calibration is byte-identical. The input generator, shuffle and CLI are identical apart from the two registrations and added CSV column names. Both types still enter the same templated noinline public `insert` helper; no private kernel shortcut or new timer is used. The local geometry layer uses the frozen public range byte-sizing helper and reports the actual 64-byte-rounded allocation.

The focused checker has 1,642 cases per profile: 1,632 small combinations (128/192 bytes, lengths 0–67, four input offsets, three input patterns) plus ten representatives around 256 KiB/2 MiB and at 96 MiB. Each checks control and candidate using complete and incremental insertion, and checks the original scalar insertion. The oracle constructs each bit from independent position lists and reads circular hash fields one bit at a time. Complete bitmap words, all inserted keys, guarded dense vector/scalar query answers, input immutability, minimum/maximum line addresses and zero/null calls are checked. Shared-line patterns deliberately collide within groups of four. This is bounded correctness coverage, not a new quality calibration or a concurrency claim.

`validate.py` has one correctness mode. Under the granted whole-socket lock it builds native, minimal AVX512F (excluding VL/DQ/BW/BITALG/VBMI), and native ASan+UBSan configurations. Each runs the checker and only two tiny caller fixtures using old seed 74381, two build repetitions and two query repetitions. This yields 12 caller rows total. Six malformed CLI cases must reject. All six executables, exact compile commands and actual `.o.d` input closures are hashed and rechecked. Build directories and `validation-v1` must be absent, including dangling symlinks; every attempt/log is preserved on failure.

The driver archives normal raw/demangled symbol tables, complete disassembly, and the two actual noinline public insertion caller windows. Those windows must be manually reviewed before a performance freeze: verify how the compiler implements expansion/store operations, that repeated-line updates are not lost, and whether control/candidate code generation adds other material differences. An assembly archive alone is not a passed manual gate or performance evidence.

Run only after the parent has committed this exact source inventory and explicitly assigned CPU2 or CPU3. For example, a CPU3 lease uses:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 \
  python3 experiments/2026-10-29-k12-line-or/caller/validate.py \
  --source-commit FULL_REVIEWED_COMMIT --cpu 3 --execute-correctness
```

CPU2 analogously uses socket0, `taskset -c 2` and `BF_SOCKET_LEASE=socket0-cpu2`. The driver validates the actual inherited exclusive lock, CPU/socket/node identity, affinity and absence of compiler/loader/allocator overrides. This correctness-only preflight does not explicitly bind memory. Formal timing will need its separate frozen driver and explicit placement record.

No timings from these tiny fixtures will be interpreted as a speed result. The original eight formal workloads, two filters, masks, thresholds, prefetch and all failure-preservation rules remain fixed.
