# Actual before/after code generation

Release executable SHA256:
`4f2395141ed9a893f74abed06aa3548c33d958117f5ec56aab6cb3b7e29fe16c`.
`inventory.json` records24 typed public visible loops and24 distinct bodies.
`generic-batch-before-after.txt` adds both actual generic entries and full
public batch functions from that same executable; it is a read-only extraction.

The unchanged Independent32 generic entry at0x24930 and candidate entry at
0x24970 both retain an indirect tail jump. The public before function begins
at0x76a80; the candidate begins at0x77600. The candidate checks length1 at
0x7762d, enters the direct VBMI mask at0x7763e, tests at0x7770f and writes the
single u32 result at0x77752. It bypasses modulo4/remainder-loop setup.
Backend selection and constant loads remain per call. The shared noinline
benchmark boundary is unchanged.

There is a material caveat: the candidate saves six callee-saved registers and
uses a0x48-byte stack frame, versus the before function's one saved register
and0x40-byte frame. Its scalar fallback is now a call loop (call0x77b40), while
the before scalar batch loop was compiled inline. These changes arise despite
the exact four-line source delta and can affect both singleton and bulk cost.
No extra hint was added to hide or fix this within the current candidate.

For VBMI batches of at least4, the candidate's inline four-key loop starts at
0x777b0. AVX2 also retains its four-key loop. The operations still use the same
mask and address mapping, but registers, prologue and code placement differ.
Source equality of the bulk body is therefore not a performance guarantee.

Visible before loops start at0x211a0/0x21600 and visible candidate loops at
0x21f10/0x22370. Both retain backend checks outside their key loops and inline
VBMI/AVX2 hot paths, with portable scalar helper calls. Public singleton source
is unchanged, but those metrics remain regression controls because layout can
still change. All speed conclusions await the separately authorized screen.
