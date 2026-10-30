# Rust actual-native timing gate review

Read-only review passes for the exact normal binary `c9a69fbf8b96bf798d93f812dcc9fe016cfd64440542166ac7ff8dc3b1185d84`. No compiler, Bloom execution or performance measurement ran. Additional `nm` and relocation reads used CPU4; the full demangled text was already captured by the owner.

Both path dependencies have library name `fastest_bloom_filter`, so demangled names alone do not identify before/after. `cargo-artifacts.json` preserves the structured Cargo events from the pinned normal build: package `fastest-bloom-filter-before` consumes `proof/native/before/rust` and rlib suffix `829b6f2d1d9cb1e2`; package `fastest-bloom-filter-after` consumes `proof/native/after/rust` and suffix `caba01149b8dbd89`. Raw rlib symbols identify before disambiguator `CsdMQ7Sy6RKuN_` and after `Cs81Bz2QKq7PY_`. The linked raw symbols and relative relocations independently connect those libraries to these functions:

|Public parallel insertion|Before address/GOT|After address/GOT|
|---|---|---|
|Split64|0x2ab20 / 0x910c0|0x36030 / 0x91188|
|Split64Range|0x269e0 / 0x91060|0x31f10 / 0x91170|

The caller's generic trial is inlined into `policy_confirmation::main`, so these concrete intervals replace a nonexistent standalone trial symbol. `Instant::now` at0x68c80 resolves through GOT0x912f8; `Instant::elapsed` at0x68c90 through GOT0x91300.

|After-native arm|Start now call|Public insertion call|Elapsed call|Additional work inside interval|
|---|---|---|---|---|
|Split64 insert|0x455b3|0x4560b → GOT0x91188|0x45619|Original requested count loaded at0x45603 intoRCX|
|Split64 allocate+insert|0x447b2|0x448ec → GOT0x91188|0x448fa|Constructor sizing, posix_memalign0x44846, zero initialization, requested load0x448e1|
|Range insert|0x48568|0x485c0 → GOT0x91170|0x485ce|Original requested count loaded at0x485b8 intoRCX|
|Range allocate+insert|0x475d5|0x4766c → GOT0x91170|0x4767a|Public byte-budget constructor0x475fa → GOT0x91160/address0x31d90, requested load0x47661|

The forwarding source passes `c.requested` unchanged; the four call sites load that runtime request, without replacing it by the policy's serial1. The request decision occurs inside the called after-native public insertion. Split64 compares line count against0x1001 at0x3604b and current slice length against0x10001 at0x3605b. Range computes allocated bytes and compares against0x40001 at0x31f2e, then current length against0x10001 at0x31f3d. Both start with effective1 and conditionally retain originalRCX when either bound is exceeded, then invoke the native worker selection. Thus the real public policy and its dispatch/prologue are included in both measured boundaries. No wrapper-derived effective request is substituted before a clock.

Capacity observation and the separate BOUNDED metadata formula also appear outside clocks in the caller. Their presence does not remove the actual public gate: the checked after-native callees visibly contain it. This proves the placement and identity for this compiler artifact, not future timings or a speed benefit. The before/after crates and public routines have different addresses/code layout; the upcoming same-process performance comparison must retain that limitation. Source and runtime correctness evidence remain the separately sealed V3 proof.
