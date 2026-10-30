# What the fixed144 confirmation supports

Keep Multiply-code as an isolated candidate for now. It passes the fixed0.1%
upper-endpoint gate on all six new small-table constructions, and it beats each
of the four selected external public APIs in every measured query condition.
That comparison is limited to this prespecified eight-API, actual16-bpk workload
on this CPU and binary.

It is not a general replacement for native Split64. Single-key query ratios
against Split64 are0.8410× prehashed and0.8927× with common hashing, consistently
losing on all six seeds. At batch31, prehashed queries improve1.1070×, while
the hash-inclusive result is near parity and sensitive to order. At batch4096,
the gains versus the fastest all-fresh-eligible rival are1.0882× prehashed and
1.0683× hash-inclusive, with all six seeds favorable in both modes.

FourSector is an important limit on the interpretation. Its new six-seed maximum
upper endpoint is0.10167873%, from16,803 positives in2^24 negatives; the same
interval's lower endpoint is0.09865149%. This fails the prespecified gate but
does not establish a true rate above0.1%. Five fresh constructions pass, and on
those constructions FourSector remains faster for the bulk-query workloads.
The separate higher-resolution audit of the two older constructions also passed.
All these observations must accompany any claim that depends on excluding
FourSector from an eligible set.

A future design could investigate a separate short-query kernel or dispatch
choice, but that is a new experiment: do not silently route singleton queries
through a different mapping or erase the current losses. Larger tables, other
budgets, insertion throughput, Rust parity and parallel behavior have not been
confirmed by this144-row workload. Any promotion needs those relevant checks
and a concrete API design that preserves each filter's construction/query
mapping. Do not tune the fixed multiplier on these confirmation seeds.

The next useful accuracy-only option is a new fixed audit of **all eight APIs on
all six constructions**, without selecting only FourSector's failing seed.
Keep the frozen76 binary, n=65,536, actual16-bpk geometries, q=2^22, batch4096
and exact same raw-key constructions. Reproduce all48 original cal24 prefix
counts, then collect all48 cal27 totals; subtract each exactly reproduced prefix
to obtain117,440,512 new disjoint negatives. Keep the original24-bit calibration
gate and the new suffix gate separately labelled. The aliases still represent
36 distinct mapping/seed suffix samples, not48 independent samples; never pool
API aliases, the old prefix or repeated batches.

This would clarify the borderline fresh FourSector construction while applying
the same accuracy protocol to every rival. It is a proposal only: no code,
workload, new quality gate or latency claim has been produced for it here. Fix
the protocol and stopping rule before any extension, retain every API/seed result,
and do not retroactively overwrite the144 confirmation's eligibility policy.
