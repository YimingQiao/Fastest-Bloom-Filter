# Throughput archive validation

Preparation was committed as `e0690ef6f659e1c96478c170303e365790a9e644` before the
first timing phase. The source freeze contains nine files, including the
correctness preflight and all construction hash strings. The driver checked
those exact committed blobs, the bridge dependencies, imported held-out oracle
helpers and unchanged native library before and after the matrix. Runtime/JIT
CPU features matched the frozen protocol.

The initial correctness preflight passed 24 exact comparisons against the frozen
original bridge driver, 16 complete bitmap/factory-overwrite checks and 10
malformed-row rejections. No throughput timings were collected in that preflight.

The measured matrix passed all 48 rows and 32 actual-size bitmap/factory-overwrite
checks. Every inserted key was queried after the single unmeasured build. All
18 query phases per row checked complete dense outputs, guards and checksums
outside the timer. All three APIs matched the same canonical results. The
independent calibration stream contained 16,777,216 absent keys per row and ran
after query timing. Prepared operations and previous bitmap ownership were
released before the next configuration.

The whole matrix held `/tmp/fastest-bf-socket1.lock` with CPU3 affinity. The
recorded 761.1-second wall time includes setup, JIT, construction, validation and
calibration; it is not a build or query throughput result. CPU affinity did not
impose an explicit NUMA memory binding.

`test_summary.py` passes 10 offline tests, covering matrix completeness, duplicate
rows/preflights, native/external ownership, unmeasured build metadata, the final
mode's trial, integer calibration counts, Wilson endpoints and selection across
both feasible allocations under the 32 bits/key cap. Synthetic test timings
never enter the result archive. A separate agent reviewed the postprocessor's
cap handling, mode separation and absence of calibration pooling; exact ties
are reported separately.

The archive contains training-speed results for input42/construction113 only.
The earlier fresh input/construction accuracy checks are separate evidence and
do not turn this speed screen into held-out timing. Source code, native library,
construction functions and filter choices were not adjusted after viewing the
timing data. Build-speed columns remain unavailable.
