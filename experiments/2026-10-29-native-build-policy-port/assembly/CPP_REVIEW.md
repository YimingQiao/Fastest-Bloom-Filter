# Exact C++ caller timing review

The reviewed normal executable has SHA256
`7493d49a4e4baa4f63849c811a37cb2201050841751eecc6d96a25d3244f083f`.
`capture-v1/CAPTURE.json` records the disassembler, command and binary/output
hashes. No compiler or Bloom filter was run for this inspection.

| Candidate family | Contract | Start clock | OriginalT load | Public call | Stop clock |
|---|---|---|---|---|---|
| Split64Range | allocation + insertion | 0xa9f6 | 0xaa18 | 0xaa21 | 0xaa26 |
| Split64Range | insertion | 0xbce8 | 0xbcfc | 0xbd05 | 0xbd0a |
| Split64 | allocation + insertion | 0xf578 | 0xf5a1 | 0xf5ab | 0xf5b0 |
| Split64 | insertion | 0x1085f | 0x10874 | 0x1087d | 0x10882 |

Each load reads `Case+0x18` into the fourth argument register `rcx`, after
start. The called methods are actual native-after public `InsertParallel`
implementations. Their two inclusive policy comparisons execute in the callees:
Range at0x1bda1/0x1bdb1, Split at0x22d4a/0x22d59. Comparisons against0x40001
bytes and0x10001 hashes preserve the inclusive256KiB/65536 gates. The fixed
ledger's n>=65536 traverses these comparisons after the preexisting n<16384
fallback. The public methods' worker selection, call/prologue and insertion
remain timed; no effective request is precomputed and passed by the caller.
The allocation paths also call the actual native constructor after start.

`cpp-review-v2/` contains four candidate windows, four original-control
windows, both native-after callee prefixes and `REVIEW.json`. The control
paths branch to a shared `vzeroupper` followed immediately by their stop clock.
The initial extractor asserted that the branch target itself was a clock;
that offline assertion failed. Its source, partial candidate extracts and
failure note remain. V2 records the exact clock PC three bytes later and
checks both the branch destination and actual clock. No executable changed.

Root and external_cpp independently inspected these windows and reported no
blocker. This review proves these exact compiled paths only. The control arm
shares some branches with the serial arm; candidate/control layout and worker
selection instruction differences remain part of the actual measurement.
Equal effective worker counts outside the gate do not establish equal speed.
