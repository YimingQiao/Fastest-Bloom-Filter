# Isolated native Rust leaf-inlining experiment

Status: sources prepared; no build or performance run yet. Production library files, the previous visible28 harness, and all preserved executables remain unchanged.

This copies the current native library into `native/` and changes exactly three source hints from `#[inline]` to `#[inline(always)]`: ByteSplit's public `contains_hash`, FourSector's private `contains_scalar`, and Split64's private `contains_scalar`. `verify_copy.py` checks every copied file against the original source hash and rejects any additional source change. The package/library names are changed for separate compilation and unambiguous typed assembly; copied benchmark bins remain unchanged but automatic bin discovery is disabled. Local packages are unpublished.

The copied four-mode harness retains all seven original native/external implementations and adds ByteLeafInlineV1, FourSectorLeafInlineV1 and Split64LeafInlineV1. These are native experimental controls, never external baselines. Each directly uses the cloned library's public methods. There are no adapter-only query shortcuts or private upstream calls. SBBF keeps its runtime trait-object dispatch.

No bulk routing, bit masks, feature dispatch, allocations or parallel code are changed. All original and compiler-visible pure/raw query contracts remain separate, with the same balanced four-mode schedule and exact output validation. Both original and cloned libraries receive the disable-avx512 feature in that validation configuration.

First validate cloned native tests, harness parity/tail/guard tests, exact reference CLI output and all four fault-injection modes under normal, disable-avx512 and AddressSanitizer builds. Then inspect all20 typed visible-loop bodies and the relevant public/private probe callees. If any targeted per-key call remains, report it before trying another hint. No throughput matrix is authorized by this preflight protocol.

A future performance protocol must retain the original seven families, label all experimental controls and preserve bulk-path guards. Inlining can change code layout and compiler choices outside the most obvious singleton path even though the source routing is unchanged; semantic parity alone does not establish a speed gain.
