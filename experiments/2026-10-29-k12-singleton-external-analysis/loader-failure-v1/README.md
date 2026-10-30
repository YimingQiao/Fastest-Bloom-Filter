# Preserved first offline-analysis failure

The completed 48-process / 616-row benchmark is unchanged at raw commit
8fa1dee7f7cb8387e577592eb2b5305988c569bb. The first frozen offline loader
attempt (session 82115) exited 1 before creating report-v1.

The producer/raw/source audits passed before the pure-analysis row guard rejected
public bitmap availability. The frozen guard admitted non-null bitmap digests
only for candidate, old K12 and native Range owners. Both measured Rocks public
adapters also expose Data() through FastLocalBloom64; the unchanged caller's
HasData trait therefore correctly emitted their bitmap digests.

bitmap-availability.json records only digest presence by all 19 measured types
and exact committed source references. Five types have public digests: candidate,
old K12, Range, Rocks K8 and Rocks K8 Batch32. The production four layouts, Boost
and FastFilter rows have null digests. No latency values or rankings were used to
diagnose this guard mismatch.

The two original launcher streams and actual tool terminal result are preserved.
The old analysis, loader, raw archive and anchor remain identified by immutable
commits. This record does not repair them or authorize a retry. No benchmark,
compiler or filter was executed during diagnosis.
