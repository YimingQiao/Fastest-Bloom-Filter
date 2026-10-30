# Actual native raw32 query boundary review

This review passes for the tested GCC12.2 native worker SHA256
`6da743aa2f31c3cbd7b713d748819b684f247408f7bcb55de3c0f334a039d7eb`.
`CAPTURE.json` records every read-only nm/objdump command and its output hash.
No compiler, filter, accuracy workload or timer ran during this review.
The original automatic `assembly/audit.json` remains unchanged: its false
manual-review flag describes that earlier capture, not this separate review.

The shared `RunObject` starts the clock at **0x3804af**, calls
`AnyFilter.query` at **0x3804d9**, and stops the clock at **0x3804dc**.
The call uses the object, mode, full query count, raw-u32 input pointer and
u32 output pointer. Output poisoning precedes the first clock. Guard and
complete-array checks begin after the stop clock (guard checks from
0x380530); checksum/input validation and sample storage remain outside.
This is one erased call per whole query array, not one erased call per key.
The Query function's own dispatch/prologue/epilogue are inside the clocks.

## New public native singleton paths

|Type|Typed Query|Bind tail-jump|DenseCall target|
|---|---:|---:|---:|
|Split64Range|0x387870|0x3879d0|0x3875f0|
|FourSectorRange12|0x3879f0|0x387bd0|0x3879e0|

Both singleton branches inline their existing public `ContainsHash` through
the minimal `ScalarContains` shim. Neither has a per-key function call or a
one-key hash scratch store/load. The raw-u32 load zero-extends the input;
GCC therefore removes the first no-op `x ^= x >> 32` of the common hash.
The two multiplications by `0xd6e8feb86659fd93`, intermediate and final
xor-shifts remain in each key loop. Range loads/hashes at0x387942/0x387945/
0x387953, performs its unsigned multiply-high address at0x387973, and stores
the dense boolean at0x3879a8. K12 loads/hashes at0x387a98/0x387a9b/0x387aa9,
performs the top24 address calculation at0x387ab7..0x387ac9, tests all four
sector masks, and stores its dense boolean at0x387ba1. These are actual
public API bodies; no private alternative query algorithm is substituted.

## Dense paths and public PImpl cost

Range DenseCall0x3875f0 includes the full common-hash loop
0x387620..0x387651, including stores to the prepared8-byte-per-key scratch,
then the public Lookup body and u32 output stores. K12 DenseCall0x3879e0
jumps to the actual Dense method0x386a90: hash loop0x386ad0..0x386b01 precedes
the unchanged public vector/scalar Lookup body. The latter retains its
four-gather vector path (for example0x386cc0/0x386cc7/0x386ce9/0x386cf0)
and dense store0x386d31. Public batch1 and batch4096 therefore include
hashing, scratch traffic, query dispatch and output production.

All14 PImpl Query paths call the genuine out-of-line public singleton
`dtl::bbf_32::contains` at0x39c1d0 or `dtl::bbf_64::contains` at0x4f5190.
Their DenseCall bodies call the genuine public batch_contains, zero every
dense answer with memset, then scatter one into each returned compact
position. Each of these steps is inside the same Query call and therefore
inside the clocks. For sector32 U1 original the three stages are
0x390e80 (batch_contains),0x390e94 (memset),0x390ea8..0x390eba (scatter).
All14 captured DenseCall bodies retain that sequence; the API U/policy
aliases remain separately registered and measured, rather than replacing
the public PImpl with a private static kernel.

The four production controls likewise retain their actual typed Query and
DenseCall bodies in the capture. Compiler layout differs between types;
this audit establishes the caller contract, not equal machine code or a
performance adjustment. There is no old-executable normalization, no
standalone one-key dependency-latency claim, and no timing observation in
this correctness proof. The six public-native singleton loops can exploit
compiler inlining across independent keys; the original PImpl boundary is
reported as its real public API boundary.
