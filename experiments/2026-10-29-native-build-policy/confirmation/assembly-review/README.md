# C++ policy selection is inside the compiled clock boundaries

The normal executable SHA is
`586fcceb6a9540187e2f9915053682ded6ec91775800e0695ebcb5a25c3c20ef`.
The compiler inlined `Trial` into the two family-specific `Run` functions.
All four candidate paths reload the actual bitmap extent and current input
count, compare them with `0x40001` and `0x10001`, then use conditional moves to
select the original request or1 after the first clock call and before the
native `InsertParallel` call. The second clock call follows that complete call.
Allocation paths also construct the bitmap after the first clock call.

`review.json` records exact instruction addresses. `cpp-call-windows.txt`
includes candidate and disabled-control calls, and `cpp-normal.txt` is the
complete disassembly. `capture.json` binds the binary, command and objdump tool.
Preclock metadata observation did not hoist or eliminate the two policy
conditions in this executable. This is a binary-specific observation, not a
claim that source placement alone controls compiler motion. No opaque-call
variant, rebuild or repeat measurement was introduced.
