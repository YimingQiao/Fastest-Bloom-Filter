# Bounded public build-request policy — source-only prototype

The native60 screen shows slower parallel construction for a64K insertion into
a128–256KiB filter, and faster parallel construction at32M keys. Its large-table
query gains do not justify changing query dispatch. The insertion API accepts
incremental slices:64K input keys can also be inserted into a64/96MiB filter or
an already populated filter. Input length is not constructor real_n.

Exactly one candidate is proposed, with no threshold search:

```text
effective_build_request = 1 if batch_n <= 65536 and actual_bitmap_bytes <= 262144
                          else original_requested_threads
```

The condition executes inside the wrapper's public parallel insertion call.
All constructor, bitmap, mask, partition, scheduler and ISA code remains the
exact native60 source at5fd487fe3381ce05be2ba823a6137107f4108854. Both languages
have a thin typed wrapper with a compile-time disabled control and enabled
candidate. Both call the same public underlying insertion method. The Rust
trait uses monomorphization; no dynamic per-key dispatch is introduced. Query
methods forward the original requested T unchanged. Native serial insert is
also unchanged. No wrapper allocates extra storage or introduces a thread pool.

The candidate reports actual workers and native scratch through the same
effective request. Requested physical-core budget T remains visible separately.
When effective request is1, native W1 fallback and scratch0 are reported, without
claiming that T workers executed. A requested0 still means native automatic
selection outside the bounded region; inside the region it intentionally selects1.

The future validation and workload proposal is in protocol.json. No C++/Rust
compiler, Bloom filter, throughput test or quality calibration has run in this
stage. Source copies and wrapper forwarding must be reviewed before a focused
correctness lease; a new frozen runner and explicit lease are needed before any
performance. Both current socket leases belong to unrelated formal baselines.

Use actual bytes, not requested bits/key, at the threshold. Range can represent
256KiB+64B precisely. Power-of-two Split jumps from256KiB to512KiB, so its nearest
above-bound control is512KiB and must not be labeled256KiB+64B. A constructor may
round a requested byte budget down; only SizeInBytes/size_in_bytes decides.

All future comparisons remain within a language and same workload/history,
using the disabled wrapper as control. Existing serial and whole public calls,
first-touch policy, affinity expansion, allocation accounting and full output
checks remain explicit. Small incremental writes into large bitmaps, dense
prehistory and line hotspots are required controls, not optional post-hoc cases.
