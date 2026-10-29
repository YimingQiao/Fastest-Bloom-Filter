# V2 screen-entry provenance guard

This additive entry delegates to the unchanged Stage3 `run_screen.py`. It adds
exact requested-commit checks for the retry inventory and these guard sources,
then requires the successful proof to reference that same retry inventory,
the byte-exact reused native legacy binary, and the actually consumed corrected
modern source. No worker, timed loop, registry, geometry, ordering, phase,
scratch, output validation, calibration identity, or row count changes.

After the v2 preflight succeeds, the original `freeze_preflight.py` can seal its
evidence using the exact **proof** source commit recorded in `validation-v2`.
The resulting `WORKER_FREEZE.json`, proof artifacts, retry sources, and this
entry's inventory must then all be committed together before measurement.

Only after a separate timing authorization, use the original screen arguments
with `python3 benchmarks/vldb-raw32-stage3/screen-v2/run.py` under the whole
socket0 flock/taskset2. The entry retains the original runner's before/after
live binary/dependency checks and both fixed launch orders. No timing has been
performed or authorized by adding this source-only guard.
