# Rust K12 SIMD singleton: bounded proof passed

The exact candidate and safe SingleLine control pass native-host, portable-runtime, AVX512-disabled and portable ASan checks. This completes correctness and actual-caller assembly proof only. No formal performance or calibration run was performed, and incidental check timings are not ranked.

| Evidence | Complete coverage |
|---|---:|
| Actual retained executables | 12 |
| Focused test executions | 16 |
| Controlled required-bit hashes | 73,792 across arms/profiles |
| Guarded tail cases | 17,024 across arms/profiles |
| Public caller rows | 96 |
| Rejected CLI cases / injected faults | 24 / 8 |
| Commands | 87 successful + 32 expected exit-1 rejections |
| Actual source-input closure | 30 unique files |

Each arm/profile covers 9,224 controlled hashes and 2,128 tails, including non-power-of-two physical-line counts, missing each required bit, duplicate/incremental insertion, full bitmap equality, empty input, offsets, output guards, immutable inputs and length mismatch before writes. Large fixtures reset one line per controlled hash and check the full bitmap once per construction. Caller cases use the fixed seen seed 74381, 256 inserted keys, 4096 queries, 24 actual bits/key, hit rates 0/50/100 and batches 1/3/31/4096. All four profiles preserve complete semantic fingerprints; native, portable and ASan explicitly execute AVX512, while the disabled build explicitly executes AVX2.

The native and portable ABI costs differ. Native visible loops hoist the runtime feature branch and inline the SIMD body, retaining six saved registers and 72/104-byte frames. Portable visible loops call the public trait facade per key; that facade checks the runtime flag and tail-jumps to the AVX512 target helper. Portable generic lookup enters its tiny helper only for lengths 1–3. Both profiles keep the common hash, public query and dense stores inside clocks; poisoning and complete output validation are outside. The retained [assembly review](../assembly-review/REVIEW.md) supplies exact ELF address/size maps, GOT resolutions and clock boundaries. Unchanged bulk source is not evidence of unchanged machine code or latency. No C++ speed result is assumed to transfer to Rust.

The proposal is frozen at `5ac4b63414d94f63b7f61304c09b7eb8d0459f0e`, with caller/native source at `1f409288eb288bae109cd9bcfce99977631efd99`. V1 compiled three native executables but stopped before any BF/test runtime because its dep-info collector interpreted workspace-relative paths against a member manifest. Its incomplete metadata, original six dep-info records, commands and three binary identities remain unchanged in failure commit `4f7e55823f0d8a61776650d7ef471dc6b85c1755` and `FAILED_V1_ARCHIVE.json`.

Recovery source `4a31f93725212e08be1bc127e956c53c94f588e9` selects the unique dependency base by structured Cargo target-source identity. It does not use file-existence fallback. V2 reused all three successful native executables and original Cargo metadata without rebuilding them, proved their actual closure before runtime, then ran previously unexecuted tests and the remaining three profiles. No Rust kernel, caller clock or query source changed between attempts.

Original V2 capture metadata retains its historical `manual_assembly_review_pending` fields. Final closure is recorded separately in `COMPILED_PROOF.json`, after parent and baseline_survey independently reviewed the actual native/portable bodies. The missing narrow portable facade span was extracted by ELF address/size from the already-captured full disassembly, without new disassembly, compiler or BF execution. Parent also independently verified all 12 binary hashes, command stream hashes, 96 semantic rows and required backend flags. A field-name typo in the parent's first independent checker was corrected in that checker only; measured artifacts were unchanged.

`COMPLETE_PROOF_ARCHIVE.json` covers the complete V2 logs and dependency records, original assembly captures, additive text extraction, this report and the final audit/descriptor. Executables remain at their recorded paths and are SHA-bound, not committed. The older failed archive is referenced by its exact commit and hash rather than relabeled as successful. CPU3/socket1 was explicitly released after the bounded proof.
