# Untimed worker proof

The bounded worker proof completed on its first attempt, session 41505, exit 0,
at source 779530e6026c7e9bbabdf856787d7612cb196704. The whole socket1 flock
covered the operation; parent CPU3 and explicit CPU3/NUMA1 worker placement
were recorded. CPU3/socket1 was released after completion.

Both native and ASan/UBSan workers passed n4096, q4096, cal1024 for candidate 12
and old 16, giving four successful records. Normal and sanitizer records match
exactly. The common mixed-input pattern has 2050 positives and 2046 negatives.
Every inserted key and full guarded mixed/calibration output was validated
through public Lookup and ContainsHash. One injected dense-output corruption
and two invalid CLI calls returned exactly exit 1 with empty stdout and their
expected diagnostics. All nine command outcomes and streams are retained.

The proof binds two worker binaries and 379 actual compiler inputs. Native
binary SHA256 is e047bc89f974f056d57cee1a09c60931138c3640307e79f0a2a11a9dd67a4a03;
ASan binary SHA256 is 9052b7645bc761fcc10399ad9ff375fea3ea2dc20dc2c91f9a9c293395e27d7a.
The compiled source and shared generator/hash helpers stayed unchanged.

The inner proof archive preserves all 22 runtime artifacts. The outer archive
also binds that manifest, this report, the complete launcher log and actual
tool terminal result. No ELF is staged. This proof did not execute the 16-row
formal calibration and makes no FPR qualification or timing claim. The fixed
accuracy entry still requires the committed proof and a separate root grant.
