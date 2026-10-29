# Actual four-arm caller source

This additive source stage derives from the committed actual-native proof
`26232ad9b1412e64346e09f40de15f8ef77c52f7` and reviewed plan
`9f0ebb2f5b75c3be493e562024d01bbfc4a4c749`. No compiler, filter or timing has
run here. Production and every previous measured source stay untouched.

`derive.py` recreates103 source artifacts. Before/after C++ closures and Rust
libraries remain byte-exact copies of the prior proof. Clone is a complete
before copy: only the C++ namespace token and Rust package identity change.
Licenses/NOTICE remain with every Rust copy. `NATIVE_ORIGINS.json` binds every
copy to its original committed bytes. Caller changes are explicit in
`changes/{cpp,rust}-caller.patch`; native public inline attributes are unchanged.

The timer helper has one symmetric noinline annotation for each native type
specialization. A0/A1 enter the exact same before specialization through one
shared branch/call site; labels affect only which output sample vector receives
the result. Clone and Policy enter their statically typed specializations.
The helper call occurs before its internal clocks. Public parallel insertion
still receives original requestedT inside both insert and allocation+insert
intervals. There is no policy in a benchmark wrapper. Metadata observation is
outside clocks and is not used to prove compiled selection placement.

The old source's untimed serial oracle, full streamed old/new membership,
guarded dense serial/parallel output checks, fresh single bitmap per arm,
input digests and lifetime boundaries are retained. Serial is not a timed arm.
Populated allocation remains unavailable. C++ accepts only T4, Rust only T8,
and both accept scenarios 0..4. `--measure` accepts only the two fresh fixed
seeds 2694173/3819257 and executes 32 trials. `--caller-check` and the explicit
`--check-bad-output` mode accept only the previously observed seed 74381 and
execute one complete four-trial Williams cycle. This switch changes only the
outer loop and CLI; the same Trial function, public call and clocks execute
in both stages. Every trial and the full chronological phase/arm order are
emitted. Contract order follows the fixed plan.

Before any performance approval, normal and ASan caller correctness must pass
for both languages; source hashes and actual compiler dependencies must be
captured. Reuse the earlier unchanged-kernel proofs instead of repeating the
entire backend matrix. Inspect both binaries to establish the common A0/A1
machine-code path, originalT/native gate inside clocks, and Clone folding or
distinct addresses. No Clone-layout effect is presumed from source names.
Any failed build/guard must be preserved in an additive repair. The focused
`preflight/` stage checks 24 records across normal and ASan builds, using only
the old seed and three representative scenarios. No formal performance entry
is present yet, and no compilation is authorized by this source preparation.
