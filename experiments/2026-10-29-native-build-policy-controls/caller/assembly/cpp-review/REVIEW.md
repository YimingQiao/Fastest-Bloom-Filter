# C++ four-arm timing and identity gate

The read-only gate passes for normal binary SHA256
`3eecc5a4e8d11b3ee6d66adace1deec94e9e5d1ed5238ea8c9df8d4a6aa2b93f`.
The raw GNU disassembly, symbols, tool version and binary hashes are in
`../capture-v2/`. No compiler or Bloom filter ran during this review.

A0/A1 use one actual callsite per family. The caller tests arm2/arm3 and sends
both remaining labels through the same branch; only the sample-vector
address changes. Split64 calls Trial0 at `0xd3ac -> 0x1a490`; Range calls at
`0xec82 -> 0x13eb0`. The helper is a real out-of-line function, so this shared
entry, prologue and surrounding allocation/validation code are established
for this binary, not inferred only from the source annotation.

|Family|A0/A1 Trial|Clone Trial|Policy Trial|
|---|---:|---:|---:|
|Split64|0x1a490|0x19670|0x18850|
|Split64Range|0x13eb0|0x13060|0x12210|

All six measured helper entries are distinct. Before/Clone public insertion
entries are also distinct: Split64 `0x32570`/`0x2ebf0`, Range
`0x276d0`/`0x242c0`. Thus the linker has not folded these measured entries.
This does not prove that every internal helper is distinct or that different
addresses cause a performance difference. The Clone experiment retains that
layout limitation and will report it alongside A/A outcomes.

All 12 typed contract paths are extracted in `REVIEW.json` and individual
text windows. The four Policy paths are:

|Family/contract|Start clock|Original requested T load|Actual native call|Stop clock|
|---|---:|---:|---:|---:|
|Split64 allocation+insert|0x188cc|0x188f9|0x18900 -> 0x2b230|0x18905|
|Split64 insert|0x19165|0x19179|0x19182 -> 0x2b230|0x19187|
|Range allocation+insert|0x1228c|0x122b1|0x122b8 -> 0x20e70|0x122bd|
|Range insert|0x12b5d|0x12b71|0x12b7a -> 0x20e70|0x12b7f|

Every request load reads `Case+0x18` into RCX after the start clock; no
metadata-derived effective request is substituted. Constructors occur inside
both allocation windows (`0x188e8` and `0x122a0`). Prefill and affinity changes
are outside the insertion windows. The helper call itself and its prologue
precede these clocks, identically for Before, Clone and Policy.

The actual Policy native callees contain the inclusive byte/current-input
rule. Split64 compares bytes with `0x40001` at `0x2b27a` and n with `0x10001`
at `0x2b289`; Range does so at `0x20ec1` and `0x20ed1`. Each comparison retains
original RCX when outside the bound, otherwise the effective request is1.
These callees are invoked inside every measured interval. The existing
small-input native fallback precedes this gate, but every fixed case has
n>=65536. No private wrapper implements or bypasses the selection.

The initial capture attempt stopped at discovery of missing `llvm-objdump`,
before any disassembly or filter execution. Its source and failure record
are preserved in `../capture.py` and `../capture-v1/FAILURE.json`. Additive
`capture-v2.py` used installed GNU objdump successfully without changing any
source or binary under test. This is evidence of invocation and code
placement only; it makes no performance claim.
