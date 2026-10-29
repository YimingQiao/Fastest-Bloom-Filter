# Completed Poppy public semantic proof

All86 frozen constructor configurations pass the public byte/iterator fixtures
under both normal Rust and nightly ASan:172 semantic rows and1,409,196 mixed
query comparisons. Every insertion result, every serialized cache/bucket byte
and every query result agrees between the two public interfaces. All inserted
keys remain present. Duplicate insertion and uninitialized-iterator rejection
leave the complete serialization unchanged. All34 None/Space comparisons
(17 per backend) differ only in their public policy tag. Clearing leaves no
fixture key present and no bucket bit set; a fresh index-cache state is not
claimed.

Both backends also pass32 invalid-FPP,8 zero-capacity and8 full-capacity error
cases in total. The eight recorded commands all succeeded on the first run.
The entire operation used an inherited exclusive socket0 flock with parent
and children pinned to CPU2. No throughput timer, calibration negative stream,
fresh performance seed or constructor search ran. This is not evidence of
Poppy's speed or full-load FPR.

The dependency remains the original pinned public implementation. Eight-byte
little-endian slices retain the supplied first hash; generic u64 inputs have
different hashing semantics. The public xorshift bucket mapping, optional
cache and lazy secondary hash are retained. A timed adapter must include byte
or iterator preparation and all of that public query work inside its clocks.

`SEMANTIC_PROOF.json` records both executed binary hashes and actual dep-info
counts. `validation-v1/` preserves structured Cargo metadata/build messages,
tool versions and all87 output records per backend. The full byte comparisons
ran in memory; the archive retains lengths, digests and equality records, not
the large serialized payloads. Actual dependency text is retained without
claiming a resolved complete compiler input closure. The counting allocator
from the earlier constructor proof is absent from this checker.

`seal.py` verifies committed source, exact geometry identities, complete command
coverage, raw log hashes, live executable identity, dependency text and full
normal/ASan record equality without running another filter. Public semantics
are now established for this finite grid; independent quality calibration and
a fair timed comparison remain the next steps.
