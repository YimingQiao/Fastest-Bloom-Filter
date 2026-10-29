# Actual raw8 caller assembly review

The normal caller SHA256 is
`c7aa0e69cac551e177c4cc68ea9d4e190490dd312f9921a52989007519b7a6df`.
The driver captured ELF FUNC address+size, raw/demangled symbols, full disassembly
and relocations. All77 selected spans begin with a real instruction at the ELF
address. Display labels are not an identity gate; same-address aliases are
recorded where ELF retains them. A compiler-shared target is not described as
an alias when the ELF does not retain such a symbol.

`asm_inventory.py` only reads that immutable capture. It records all45 actual
report specializations, their raw-method callsites and the first three build
clock boundaries. Every one of the24 direct public K variants calls the same
three emitted raw-method bodies, which have a display name containing K16;
the constructor still sets each requested public K. This is observed compiler
sharing, not replacement of the distinct registered constructors.

## Construction windows and scratch

The relocation at GOT0x1a33c0 resolves to `Instant::now`0x17cfd0.
For native K12, the report starts at0xb7e50. The complete-build start is0xb80fe,
required hash scratch is allocated by `posix_memalign`0xb8125 and zeroed at
0xb815b, the filter constructor is called at0xb8178, readiness is0xb81ad,
raw insertion is0xb81f6 and completion is0xb8200. Thus both allocation/init
stages precede readiness and lie inside the complete-build interval.

The shared constructor target0x160810 is displayed under Range. Its checked
n*bpk/byte/64B-line geometry and actual allocation0x16086c/zeroing0x160895 are
visible. The K12 report's direct call proves consumption of that emitted
constructor; it does not imply that the two filter types are interchangeable.

The direct public K12 report starts at0x1395d0. Complete-build start0x139823
precedes constructor0x13984c, readiness0x13988e, shared raw insertion0x1398d6
and completion0x1398e0. There is no hash-scratch allocation in that interval.
The actual K12 constructor0x163940 includes upstream geometry calculations,
`exp`0x163a04 and `calloc`0x163a25, and stores K12 at0x163a83. Those public
constructor costs remain inside the clock. All21 common-hash reports retain
their required scratch allocation/zeroing before readiness; all24 direct
reports omit it. Allocator lifecycle tests independently check releases.

## Query clocks and common-hash controls

The GOT0x1a33c8 relocation resolves to `Instant::elapsed`0x17cfe0. Native K12
poisons output at0xb94e0 before query start0xb94f7; raw batched0xb959d or
visible0xb95cb executes before elapsed0xb95d8. Direct K12 poisons at0x13a810,
starts at0x13a827, calls batched0x13a8c1 or visible0x13a8fb, then elapsed
0x13a908. Full validation and result-vector bookkeeping follow the clock.

Native K12 raw insertion0x152c30 and batched query0x1553e0 execute common-hash
multiply/xor work into the actual workspace, then enter native insertion or
public lookup. The latter's GOT0x1a3298 resolves to public lookup0x3ae80.
The visible K12 loop0x156300 includes both common-hash multiplies and the
SingleLine body with one global line bounds check0x156396, four sector tests
and a dense u32 store. No successful-path per-key helper call remains; six
saved registers and104 bytes of frame space remain real costs.

Range visible0x156220 also hashes inside the loop, then calls its actual scalar
helper0x15c6b0 per key. Fastbloom0.17 fixed-K reporters, including K7 at0x66cb0,
share raw method code displayed under K1; visible0x1559c0 contains common hash,
dynamic public probe-count state and early-exit bit tests. These public/compiler
boundary differences are retained, not normalized away or hidden.

## Direct raw8 public loops

The emitted direct bodies are raw insertion0x153090 (93 bytes), batched query
0x1558e0 (218 bytes) and visible query0x1565d0 (218 bytes). Both query loops
enter the actual public-membership specialization0x15cb60 per raw key and
write a complete dense answer. They do not allocate or copy an intermediate
identity-hash array. The independent text-only review traced the insertion GOT
0x1a3260 relocation to public `Membership::add`0x359b0 (1920 bytes). The wrapper
materializes the original u64 as exactly eight stack bytes. The callee's length8
branches retain the two seeded XXH3 mixers at0x35ed2/0x35f81, reduction and bitmap
OR instructions; this byte-slice materialization is not a prepared-hash copy.

Both query loops pass the original key's two32-bit halves to the outlined
`bit_check`0x15cb60 (360 bytes). In this particular captured body, both eight-byte
XXH3 mixers and both initial divisions precede the first bitmap test; the
upstream K-loop then short-circuits. Dense answers are stored at0x155959 and
0x156649. Both query wrappers retain six saved registers,88 bytes of stack
frame and one outlined `bit_check` call per key. The public visible contract
does not force that upstream helper to inline.

The public algorithm supplies XXH3 seed0 and seed32. The source contract does
not require artificial hash evaluation, and the observation above is specific
to the captured actual code; it is not a rule for other builds or public API
implementations. All required work on the reached path remains within the raw call. Code size,
frames, calls, sharing and hash early exits are observations, not a speed
prediction, cross-library causal explanation or instruction-equivalence claim.
