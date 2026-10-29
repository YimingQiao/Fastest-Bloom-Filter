# Frozen-binary subset preflight

This additive stage reuses the exact passed native `9aceea39...` and ASan `062802b2...` binaries from `e150be33`. It does not compile, change the fixed78 plan, or execute its held-out seeds. The source-only proposal remains at `9c9cd9a3`.

Six tiny valid commands cover all eight selected API/geometry combinations: native and ASan each run the primary five at24 bits/key, BoostMulti32K8 at28, and FastPattern/FourSector at32. Each uses n=1024, q=4096, cal=4096, two balanced query repetitions, and full-input insertion. The unsigned seed is UINT64_MAX, and its complete raw counter envelope `[430443552,430452768)` is disjoint from all six held-out construction envelopes. Two native bad-seed commands test overflow and negative parsing. The resulting16 rows prove public dense-output checks, guarded tails, exact registry order, geometry and normal/ASan semantic equality; tiny timings are not selected or reported as performance.

Existing committed planner records supply24/32 geometry. For the sole28-bit Boost control, the pinned public allocator formula has32-byte stride and63 bytes overhead: floor((3584-63)/32)=110 units,3520 logical bytes,3583 actual allocated bytes. The formula is also required to reproduce both committed24/32 endpoints exactly. No sizing trial is added inside any measurement.

The original actual-caller proof, consumed source/header closure, native and ASan binary hashes, exact proposal and additive sources are checked before and after execution. CPU3 affinity, actual inherited exclusive socket1 flock, host and environment must match the passed proof. `validation-v1` is fresh-only and retains every command and failure. The formal78 accuracy/performance run requires its own later frozen runner.

Run only after this source is committed and the parent grants the CPU3 lease:

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 taskset -c 3 python3 preflight/validate.py --source-commit FULL_COMMIT
```

Six offline tests cover union/order, unsigned64 parsing command construction, fixture isolation, allocator arithmetic, malformed data/phase rejection and Python `-O` rejection. Reuse of prior algorithm, backend, allocator and full-output proof avoids rebuilding or repeating the broad validation matrix. The first source-preparation command attempted unavailable `python`; its failure log is retained. Actual tests and the run command use `python3`.
