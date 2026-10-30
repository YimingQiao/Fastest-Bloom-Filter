# Fixed accuracy pilot, without query timers

After all six correctness profiles passed, this additive stage prepares one
untimed native calibration executable. The fixed six candidate cases from the
initial proposal are unchanged: n2^16/2^25,16/24/32 actual bits/key, seed42,
2^24 negatives. An unchanged Split64Range public-API control runs beside each
case, making12 rows. No outcome-dependent extension or layout change is allowed.

`calibrate.cpp` is derived from the committed Multiply pilot, replacing only
the candidate registrations and omitting its28-bpk points. The unchanged
64-bit bijection hashes insertion counters0..n-1 and calibration counters
n+2^24..n+2^25-1 after the same seed XOR. They are disjoint by construction.
Every inserted key must be found; every negative result and output guard is
checked. Each bitmap is destroyed before the next allocation. Public bulk
insert/query methods execute unchanged; no private kernel is called.

These counter intervals differ from the later q2^22 throughput harness.
Do not pool the samples or require the candidate's count to match that screen.
The six retained Split64Range rows must reproduce the corresponding original
pilot counts/checksums exactly. A new candidate mapping has separate quality
evidence, even where its size matches another filter.

First compile and freeze the calibration binary and its actual dependencies.
Run no formal accuracy until that freeze is committed. After all12 fixed rows
complete, report every point estimate and two-sided95% Wilson interval, with
the upper endpoint evaluated at1%/0.1%/0.01%. No timing column or speed claim is
permitted. A separate full comparison protocol is needed if quality justifies it.
