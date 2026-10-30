# Correctness gate passed; accuracy still pending

All six C++ backend/check combinations passed: native, AVX2 and scalar, each
normally and with ASan/UBSan. Each full-bitmap oracle run produced checksum
`8034663427509506935`, with dense output comparisons, essential-bit removal,
high32 range boundaries, input-bit boundaries, collision/duplicate checks,
tail guards and invalid/overflowing constructor rejection. Empty null batches
also passed. The consumed shared `include/base.h` and both parent headers were
hashed before and after each preflight.

The initial complete check run is retained in `validation-initial-contract/`.
Independent review then requested explicit constructor and null-batch checks;
those were added to the test source, with the old source retained. The second
complete run in `validation-v1/` passed. Filter kernels and the calibration
executable source were unchanged between those correctness runs.

The native assembly archive contains the intended broadcast, variable qword
shift and `vprolvq` mask path. This establishes code generation, not speed or
acceptable false-positive rates. Correlated positions are a deliberate semantic
change, so none of the parent Split64 calibration evidence transfers to this type.

`calibrate.py --source-commit COMMIT` will verify the exact committed archive,
all frozen sources and twelve binaries, require the inherited socket0 lock and
CPU2 affinity, then run the fixed sixteen-row accuracy matrix. It reports every
configuration, observed FPR and pointwise Wilson upper endpoint without timing
or selecting configurations. No accuracy data had run when this gate was frozen.
