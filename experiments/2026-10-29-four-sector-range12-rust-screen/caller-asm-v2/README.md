# Archive-only K12 caller ASM correction

The original bounded correctness run completed all57 commands successfully:
6focused tests,84tiny rows,76 retained semantic comparisons and12 rejected CLIs.
Its final five GNU objdump commands combined `--demangle` with raw Rust names
in `--disassemble`, returning exit0 but empty function sections. Their original
stdout/stderr and complete metadata are retained unchanged. No instruction-body
review can be based on those empty sections; this was an evidence-capture issue,
not a failed Rust correctness check or a performance observation.

This additive source uses the same frozen executable and exact raw nm inventory.
It passes the selected function's start and next-symbol addresses to the same
GNU objdump, retaining demangled labels. Every capture must contain actual
instructions starting at the expected address, remain within the bounded range,
and contain the exact selected symbol label. No annotations, Rust source,
constructor, timer or binary change; no compile, filter call or timing run.
The whole capture holds the actual inherited CPU3/socket1 flock. Start/end and
tool/binary/source/output hashes are recorded.
