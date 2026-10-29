# Source-only A/A and actual-native policy control proposal

The completed native96 result is positive inside the gate but inconclusive
about small outside-gate differences:56/112 individual outside records lose,
and15/56 two-seed cells lose twice. Fourteen twice-losing cells would be the
expectation under a simple independent symmetric-sign noise model. That is
not a fitted statistical test, but it makes treating every loss as a
confirmed policy penalty inappropriate. This proposal fixes the next study
before new data; it neither changes the policy nor authorizes a build/run.

Use four arms in each language's same process:

* A0 and A1 execute the same old public native type through the same typed
  measurement function and machine-code path. This is the true no-change
  control for timing, order and thread-start variability.
* Clone uses a third complete copy of the same old native snapshot, changing
  only C++ namespace or Rust package identity. It is one limited code-placement
  control. Record whether the compiler/linker merges its actual public code;
  if merged, report that limitation instead of forcing artificial differences.
* Policy uses the unchanged native-after snapshot2b3469f. It receives originalT
  inside the clock and retains the exact65536/256KiB gate. No policy search,
  alternate threshold, private call or input-dependent adapter shortcut.

A0/A1 must share an actual call path, not merely identical source text. A
single typed before-helper dispatch branch serves both labels. One deliberate `noinline` hint is applied symmetrically to every whole
measurement helper before any data; that helper call sits outside the clock.
Do not change native public inline hints. An assembly preflight must establish
actual identity/addresses, originalT, and all native gates inside clocks.
Separate snapshots/build commands/consumed inputs remain fully pinned.

The fixed20 cells use two families and two languages. C++ usesT4 and RustT8,
selected to retain the two named investigation targets, not to compare
languages. Include scenarios0/1/2/3/4 from native96: active empty,65537-key
boundary, active prefilled hotspot, next-above-byte boundary, and large empty
bitmap with the same64K insertion batch. Both families follow the same rule.
Omit large-prefilled and the other language/T combinations from this focused
study; conclusions cannot be extended to those unmeasured combinations.

Two new-to-this-policy-study seeds2694173/3819257 are fixed independently of
results. Their input domains remain disjoint with the existing SplitMix
stream convention. The second seed reverses the entire20-cell process order.
The exact ledger is40 processes/72 contracts. Four arms each get32 trials:
eight complete four-row Williams cycles, balanced for absolute position and
within-row directed predecessor. Each complete four-row block contains every
ordered pair once inside rows. Across-row/process boundary carryover is not
claimed balanced; all inter-trial setup gaps and chronological order remain
recorded. Empty contract ordering is also balanced.
This yields9216 fresh timed bitmap lifetimes and40 untimed serial oracles.
No optional stopping, post-result extensions or reruns-until-winning.

Each timed arm retains the previous public insertion and allocation+insertion
boundaries, one live bitmap, identical streamed history, full old/new presence
and complete guarded mixed outputs outside clocks. Populated cells expose
insertion only. Setup is separate. Serial remains the untimed oracle; this
study makes no new direct-serial performance claim. Affinity expands before
clocks to the allowedT physical cores and restores afterward; whole-socket
lock/NUMA placement and the language-specific worker/coordinator contracts
remain explicit. No query throughput, FPR or cross-language ranking.

Keep every trial and all six arm-pair contrasts for each cell/contract/seed.
The prespecified contrasts are A1/A0, Policy/A0, Policy/A1, Clone/A0 and
Clone/A1; Policy/Clone is also retained among the full six pair contrasts.
An optional within-block geometric A0/A1 reference is a secondary descriptive
summary, never another independent sample. Analyze the eight complete
Williams cycles as blocks, retain cycle/order trends, and never pool different
cells or seeds. Proposed descriptive uncertainty is a fixed10000-replicate
cycle-block bootstrap with analysis seed20261029. It assumes cycles adequately
represent variation and is not a familywise causal guarantee.

Root accepted the prespecified3% engineering latency-ratio band[0.97,1.03].
Every named ratio is numerator latency/denominator latency, so above1 is
slower for its numerator; these are not old speedup ratios. Report policy costs as consistent across the two seeds only when both
individual Policy/A0 and Policy/A1 contrasts lie outside that band with their
prespecified block intervals, while the full pointwise block intervals for A/A and both Clone contrasts
are inside it at both seeds. Otherwise label the
cell unresolved or practically within the band; retain every number. The two
primary target contracts are C++ Split64/scenario1/T4/insert and Rust
Split64/scenario1/T8/allocation+insert. All remaining contrasts are retained
controls, with no post-result leader selection. No default merge follows
solely from this restricted confirmation or from negative controls appearing
quiet; this experiment cannot completely isolate every possible layout effect.

The exact estimator is the exponentiated mean of eight four-repeat cycle
log-ratio means. Bootstrap resamples whole cycles with shared indices for all
contrasts, retaining common-reference dependence. All32 individual trials
and eight cycle summaries remain visible. A full interval inside the3% band
is a practical descriptive classification, not proof of no effect.

Current status: reviewed source-only plan and ledger generation only. No native source change,
compiler, Bloom execution, performance sample or automatic run entry.
