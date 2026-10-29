# Completed Poppy accuracy-caller checks

The actual public accuracy worker passes all eight bounded fixtures under both
normal Rust and nightly ASan:16 rows, plus eight rejected invalid CLI calls.
All30 commands completed with their expected exit status on the first attempt.
Both profiles agree on every output field. The independent Python oracle checks
the source dataset's base, insertion/query shuffles and input digests; public
iterator comparisons check every mixed and calibration answer. Every inserted
key remains present. All fixture constructors retain their full real capacity.

The complete operation held the socket0 lease on CPU2. Each row used1031 inserts,
8193 mixed queries and4096 separate calibration negatives. These are caller
checks, not full-load quality measurements. No throughput timer ran. Actual
dependency text and structured build metadata are retained, without claiming
a resolved complete compiler-input closure. The two executable hashes are in
PREFLIGHT_PROOF.json; no executable is committed.

The fixed86 full-load accuracy stage may now use the exact checked normal
binary. No public mapping, geometry, hash, seed or error threshold changed.
