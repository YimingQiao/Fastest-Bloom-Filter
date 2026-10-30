# Independent review record

All reviews below were read-only. No reviewer reran a filter, compiled another
candidate, interpreted tiny timings or changed the frozen sources.

Before execution, root and external_cpp reviewed the86-artifact actual caller:
public raw8 methods, required scratch accounting and lifetime, output poison,
actual allocator observer, full bitmap oracle and post-warmup corruption tests.
Root then reviewed all12 additive driver artifacts and the exact typed failure
gate. Expected exit2/101 plus stable source diagnostic and sanitizer rejection
were corrected before source freeze; no formal attempt or filter run preceded
that correction. The registry-order guard was likewise corrected before data.

After the complete proof, root independently reviewed the native K12/Range
query and construction spans and GOT relocations. It agreed that common hashing
stays inside raw operations, one checked K12 line is used in the visible loop,
Range retains a real helper call, scratch allocation/zeroing lie inside the
complete-build clock, and both query output poison loops precede their clocks.

external_cpp independently read the captured direct API loops and callees.
It traced insertion0x153090 through GOT0x1a3260 to public Membership::add0x359b0,
including the real eight-byte input materialization, two seeded XXH3 mixers,
reduction and bitmap stores. It traced batched0x1558e0 and visible0x1565d0 to
bit_check0x15cb60, which contains both eight-byte mixers and initial reductions
before the first bitmap test in this captured build. Dense output stores,
the remaining K-loop early exit, six saved registers/88-byte query frames and
one helper call per key were retained. No identity-hash scratch/copy is present.

The peer explicitly warned against treating the one emitted Raw<K16> helper
name as24 separately retained symbols. The additive inventory instead records
the actual callsites from every one of the24 distinct K reporter/constructor
specializations to those shared helper addresses. The conclusions are limited
to correctness, actual compiler consumption and clock placement, without a
performance or universal inlining claim.
