# Independent32 public singleton shortcut: CPU2 preflight

The candidate adds exactly four lines after the public batch API's existing
length assertion: one-element inputs call the unchanged public `contains_hash`
and return. The before filter and all ten other frozen Rust132 configurations
remain registered, for twelve total. Production files are unchanged. No
performance matrix has run; this archive covers correctness and code generation.

`native/` is an isolated copy with that one implementation change, separate
package/import names, and two focused tests. Its MIT/Apache licenses and NOTICE
are retained unchanged. `original-native/` and `leaf-native/` are exact copies
of the previous controls. The unchanged Independent32 before crate remains a
dependency at its separately frozen path. `verify_source.py` strips the four
new registration lines and verifies the original timer, public adapters and
all external dependency locks exactly. It also verifies the four-line native
delta and unchanged remaining library sources.

Validation ran under the inherited exclusive socket0 flock on CPU2. This
overrides the historical source-only plan's CPU3 suggestion. CPU affinity
does not impose explicit NUMA memory binding. The compiler flags for the
release executable remain `-C target-cpu=native -C symbol-mangling-version=v0`,
with ThinLTO and codegen-units1 for all configurations.

The full native normal suite passed36 tests; focused disable-avx512 and
AddressSanitizer suites passed7 each. All three harness modes passed11 tests
each, including all twelve public APIs, complete dense outputs and tail
guards, all four timed-mode corruption injections, and phase balance.
Clippy passed with warnings denied. The9-row C++ full-word/output fixture
matched in all three modes. An initial validator incorrectly compared JSON
whitespace bytes; it was corrected to compare every parsed value. No compiled
source changed, and the successful tests were retained rather than repeated.
Initial and resumed command logs are archived.

Eighteen small CLI workloads produced216 rows and198 exact comparisons against
the eleven retained configurations in the prior executable. Before/candidate
bitmaps, allocation, mixed FPR, checksums and calibration counts agree. Eight
invalid CLI cases were rejected. Seven malformed-row guard tests and four
runner/lease tests passed. Small preflight timing fields are unclaimed.

The proposed training protocol has16 workloads /192 rows: key powers16/25,
requested8/16 (actual16/32bpk), batches1/2/31/4096, query power20,50% hits,
four balanced repetitions, whole-input build and calibration power20, seed42.
All four public/generic query contracts remain separate. The visible modes
still process the entire input array regardless of the generic batch tag.
Known before/candidate and leaf aliases reuse calibration, so they are not
additional negative samples. Every original/candidate, external and native
bulk loss must remain in the report.

Generated code confirms the intended singleton branch, but also identifies a
cost that must be measured: the candidate saves six registers instead of one,
because its portable scalar fallback calls a helper. Both generic wrappers
retain the indirect tail jump to the public batch method. The native SIMD
full groups retain four-key inline loops, with different registers and code
placement. These observations do not establish a speedup or unchanged bulk
performance. See `assembly/README.md` for exact addresses.

The runner rejects Python `-O` before reading artifacts, verifies all source
blobs against an exact committed revision, verifies both executables, requires
an inherited exclusive socket0 lock descriptor and CPU2 affinity, and refuses
an existing result directory. `validation/freeze.json` and `manifest.json`
pin the executable inputs and complete local archive. A reviewed commit and
separate performance authorization are required before running192 rows.
