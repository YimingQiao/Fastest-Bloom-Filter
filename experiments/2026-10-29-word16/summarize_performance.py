#!/usr/bin/env python3
"""Report all focus-tier results, including losses, from retained GCC training rows."""
import csv,hashlib,json,math
from pathlib import Path
H=Path(__file__).resolve().parent
rows=list(csv.DictReader((H/'performance-training/results.csv').open()))
for r in rows:
    x=int(r['calibration_false_positives']);n=int(r['calibration_absent_queries']);p=x/n;z=1.6448536269514722
    r['upper']=(p+z*z/(2*n)+z*math.sqrt(p*(1-p)/n+z*z/(4*n*n)))/(1+z*z/n)
report=[]
for cap,ceiling in ((16,.01),(32,.0001)):
    for n in (1<<16,1<<25):
        for batch in (1,31,4096):
            candidates=[r for r in rows if int(r['keys'])==n and int(r['batch'])==batch and float(r['actual_bpk'])<=cap and r['upper']<=ceiling]
            own=next(r for r in candidates if r['filter']=='Word16Split256Experiment' and float(r['actual_bpk'])==cap)
            external=[r for r in candidates if r['filter'].startswith('FastFilter')]
            native=[r for r in candidates if r['filter'] in ('FastPatternBF','ByteSplitBloomFilter','Split64BloomFilter')]
            for metric in ('lookup_ns','hash_lookup_ns'):
                e=min(external,key=lambda r:float(r[metric]));b=min(native,key=lambda r:float(r[metric]))
                report.append(dict(keys=n,memory_ceiling_bpk=cap,fpr_ceiling=ceiling,batch=batch,metric=metric,
                    candidate_ns=float(own[metric]),external=e['filter'],external_actual_bpk=float(e['actual_bpk']),external_ns=float(e[metric]),
                    candidate_over_external_latency=float(own[metric])/float(e[metric]),
                    native_control=b['filter'],native_control_actual_bpk=float(b['actual_bpk']),native_control_ns=float(b[metric]),
                    candidate_over_native_latency=float(own[metric])/float(b[metric]),candidate_quality_upper=own['upper']))
result=dict(decision='Retain unpromoted: small32-bpk batch31 raw improvement is limited training evidence. No overall win; validate Clang and stronger native FourSector/full modern externals before held-out performance.',
    scope='CPU3, GCC native, seed42, hit50, shared batch API. No ratios to CPU2 or optimizer-visible inline track.',
    fullpanel_gap='This nine-config screen omits FourSector and most modern external configurations; best means fastest eligible row within this panel only.',
    ratio='candidate/control latency; <1 is faster. Every focus-tier workload and both metrics are shown, including losses.',
    quality='Pool all measured allocations <= memory ceiling, qualify via pointwise one-sided95 Wilson from cal24. These focus tiers have no cheaper allocation changing the previously archived same-requested-budget winner.',
    comparisons=report,results_sha256=hashlib.sha256((H/'performance-training/results.csv').read_bytes()).hexdigest(),
    analysis_script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
(H/'performance-training/report.json').write_text(json.dumps(result,indent=2)+'\n')
s='''# Word16 GCC training result: retain unpromoted

All 12 workloads/108 rows completed with frozen source/binary hashes. The 36
filter/size/allocation groups have identical checksum, bytes, FP and calibration
counts across batches 1/31/4096. This is one training seed, 50% hits, CPU3 and GCC.
No timing is compared across sockets, compilers or API tracks.

At 32 actual bits/key and a 0.01% ceiling, the small batch31 raw path is promising:
5.7% lower latency than the fastest eligible external in this panel and 23.0%
lower than its best eligible native control. Pure lookup is 20.2% slower than
FastPattern there. Large-table results are near parity with external baselines,
with several regressions; native FastPattern is substantially faster for bulk
queries. Single-key raw lookup has no meaningful lead. At 16 bits/key/1%, there
is no consistent advantage over the existing native layouts.

**No promotion.** FourSector and much of the modern external panel are absent.
Before fresh-seed performance confirmation, use a separate Clang build with the
stronger native/external set. No Rust port is justified by this screen alone.

The table pools every measured allocation within the memory ceiling and applies
the per-row cal24 quality bound. `new/external` and `new/native` are latency ratios;
lower is faster. Native controls here mean FastPattern, ByteSplit and Split64.

| Keys | Memory cap | FPR cap | Batch | Metric | Word16 ns | Best external | External ns | New/external | Best native | New/native |
|---:|---:|---:|---:|---|---:|---|---:|---:|---|---:|
'''
for r in report:
    s+=f"| {r['keys']:,} | {r['memory_ceiling_bpk']} | {r['fpr_ceiling']:.2%} | {r['batch']} | {'pure' if r['metric']=='lookup_ns' else 'hash+query'} | {r['candidate_ns']:.3f} | {r['external']} | {r['external_ns']:.3f} | {r['candidate_over_external_latency']:.3f} | {r['native_control']} | {r['candidate_over_native_latency']:.3f} |\n"
s+='''
The complete 108 raw rows, every filter's calibration counts, protocol, commands,
and source/binary hashes remain alongside this report. `summary.json` retains
all three FPR ceilings for each requested-allocation cohort; this report's focus
tiers additionally pool cheaper measured allocations under the memory ceiling.
No rows or slower outcomes were removed.
'''
(H/'performance-training/README.md').write_text(s)
print('Wrote full 24-row focus-tier report with all losses and bounded scope')
