# Optional native benchmark CLI integration

Source commit: `8f7bac25383f86b5510c1b50716a9756dc7e4750`.

Both ordinary C++ and Rust compare CLIs now accept explicit `Split64RangeBloomFilter` and `FourSectorRange12BloomFilter`. Parallel CLIs accept `Split64Range` and `FourSectorRange12`, with serial/partitioned modes appended as9/10 and11/12. Earlier mode IDs0..8, default selections, and the historical four-family parallel `all` remain unchanged. C++ uses the dedicated range/K12 physical-line wrappers; Rust calls the native public methods.

Unknown/empty/duplicate selections and optional budgets below128B fail before workload allocation and CSV output. The existing global `n*bpk <2^31` bound remains. Validation does not construct a bitmap to check a budget. Exact family membership replaces prefix matching in the runner/parity helper, avoiding collisions between Split64/Split64Range and FourSector/FourSectorRange12.

## Bounded correctness

All9 recorded commands passed on socket1 under one exclusive flock. Compilers ran onCPU3; the supplied CLI tests ran with explicit CPUs3,5,7. Fresh native C++ and Rust release compare/parallel binaries built, and both Rust bins passed Clippy with warnings denied. No native kernel source changed; only the two Rust bin files were formatted.

The new test checks unchanged defaults, each optional alone, mixed old/new families, duplicate/partial-unknown/empty names, invalid32B budgets after a valid legacy prefix, exact cross-family grouping, actual20-bpk allocation and realT3 counts. C++/Rust inserted-key checks and full-output checksum/FP/allocation fields agree at n=q32768, requested20bpk, seed731, hit50. Parallel serial/partitioned rows agree within each family. Additional legacy comparison selection/timed-output-fault checks, both-language legacy parallel selection, and nine runner semantic tests pass. CLI outputs are checked by the tests; this archive retains their commands/logs, not a separate full raw CSV ledger.

## Source preservation and scope

Against parent `415d1db4cfecec321d24baad11d5b25f7c44b7b1`, the C++ compare run helper (7802bytes), C++ parallel Run helper (2661bytes) and Rust comparison run helper (6547bytes) are byte-identical. All four key/query generation regions are byte-identical. The Rust parallel run adds only the four output names and two preclock accounting modes; after removing those registrations the function is byte-identical. Enum/dispatch branches for the new public types are additive. Exact helper hashes are recorded in metadata.json.

This is ordinary CLI integration and correctness evidence. Incidental test timings are not ranked or compared; added instantiations and enum branches can change compiler layout. No claim of byte-identical machine code, new quality qualification, broad performance improvement or frozen-experiment replay is made. The default suite intentionally still omits the optional layouts.
