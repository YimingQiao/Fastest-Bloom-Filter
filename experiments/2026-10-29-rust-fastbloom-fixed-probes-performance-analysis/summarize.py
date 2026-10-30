#!/usr/bin/env python3
"""Analyze the completed complete Rust336 fixed-public-probe training screen, never partial data."""
if not __debug__:
    raise RuntimeError("Do not use Python -O")

import argparse
from collections import defaultdict
import csv
import hashlib
import io
import itertools
import json
import math
from pathlib import Path
import statistics
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
STAGE = HERE.parent / "2026-10-29-rust-fastbloom-fixed-probes-screen"
COMMIT = "571186b420bf7e5fc08269ed4a65feab42ac8400"
sys.path.insert(0, str(STAGE / "screening"))
import freeze as frozen_source
import guard
from run import audit as producer_audit
from bindings import PUBLIC
sys.path.pop(0)

require = guard.require
RANGE = guard.RANGE
QUERY = tuple(m + "_ns" for m in guard.METRICS)
BUILD = guard.BUILD
CAPS = (16, 24, 32)
CEILINGS = (.01, .001, .0001)
OWNERS = ("production_native", "external", "native_experimental")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def committed_archive(directory,manifest_name,commit):
    require(len(commit)==40 and all(c in '0123456789abcdef'for c in commit),'Exact raw/recovery commit required')
    manifest=directory/manifest_name
    descriptor=json.loads(manifest.read_text())
    expected=set(descriptor['files'])
    actual={str(p.relative_to(directory))for p in directory.rglob('*')if p.is_file()and '__pycache__'not in p.parts and p!=manifest}
    require(actual==expected,'Unexpected complete raw/recovery archive inventory')
    for name,info in descriptor['files'].items():
        path=directory/name
        require(sha(path)==info['sha256'] and path.stat().st_size==info['bytes'],'Changed raw/recovery artifact')
    for path in [manifest]+[directory/name for name in sorted(expected)]:
        blob=subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
        require(hashlib.sha256(blob).hexdigest()==sha(path),'Archive differs from exact committed blob')
    return descriptor


def load(raw_commit):
    # Source and interrupted evidence stay anchored to their own exact commits.
    # New raw output is separately committed before any performance analysis.
    sys.path.insert(0,str(STAGE/'resume-v1'))
    import contract as resume_contract
    resume_commit="504e1a27ccdb9d8ed61ebd5e5d1657b1a1f6e2da"
    frozen,compiled,protocol,source,registry,binary,original,prior_rows=resume_contract.verify(resume_commit)
    out=STAGE/'resume-results-v1';combined=out/'combined'
    manifest=committed_archive(out,'archive-manifest.json',raw_commit)
    full_archive=resume_contract.verified_manifest(STAGE,'COMPLETE_ARCHIVE.json',raw_commit)
    require(set(full_archive['files'])=={'resume-results-v1/'+name for name in manifest['files']}|
        {'resume-results-v1/archive-manifest.json','RESUME_COMPLETION.json'},'Wrong complete44-file inventory')
    completion=json.loads((STAGE/'RESUME_COMPLETION.json').read_text())
    require(completion['exit_code']==0 and completion['tool_session_id']==17819 and
        completion['resume_metadata_sha256']==sha(out/'metadata.json') and
        completion['combined_metadata_sha256']==sha(combined/'metadata.json') and
        completion['raw_manifest_sha256']==sha(out/'archive-manifest.json'),'Changed observed resume completion')
    resumed=json.loads((out/'metadata.json').read_text())
    meta=json.loads((combined/'metadata.json').read_text())
    require(resumed['complete']is True and resumed['source_commit']==resume_commit,'Require completed committed one-case resume')
    require(resumed['original_source_commit']==COMMIT and resumed['interrupted_archive_commit']==resume_contract.INTERRUPTED,'Wrong interrupted ancestry')
    require(resumed['original_metadata_sha256']==sha(STAGE/'screen/metadata.json'),'Original metadata changed')
    require(resumed['executable']==compiled['performance_executable'] and resumed['executable_sha256']==compiled['performance_executable_sha256'],'Wrong actual timer')
    for observed in [original,resumed]:
        require(observed['affinity']==[3] and observed['lease']['cpu']==3 and observed['lease']['lock_path']=='/tmp/fastest-bf-socket1.lock'
            and observed['lease']['inherited_lock_descriptors'],'Wrong recorded placement')
        require(observed['environment']==original['environment'] and observed['host']==original['host'],'Changed host/environment')
        require(all(not value for key,value in observed['environment'].items()if key!='BF_SOCKET_LEASE') and
            observed['environment']['BF_SOCKET_LEASE']=='socket1-cpu3','Changed loader/compiler/allocator contract')
        require(observed['input_sha256']==frozen['inputs_sha256'],'Missing original source proof')
    require(original['compiler_flags']==protocol['compiler_flags'] and original['numa_policy']==protocol['numa_policy'],'Changed compilation/placement contract')
    require(resumed['final_sources_dependencies_binaries_equal'] and meta['final_sources_dependencies_binaries_equal'],'Missing final source proof')
    require(meta['complete']is True and meta['original_attempt_completed']is False,'Wrong combined/interrupted state')
    require(len(frozen['inputs_sha256'])==592,'Wrong frozen source cardinality')
    for index,record in enumerate(meta['cases']):
        origin=STAGE/'screen' if index<17 else out
        for stream in ['stdout','stderr']:
            require((combined/record[stream]).read_bytes()==(origin/record[stream]).read_bytes(),'Combined raw is not an exact original/resumed copy')
    require(meta['cases'][:17]==original['cases'][:17] and meta['cases'][17]==resumed['case'],'Changed reused/resumed ledger')
    rows,counts=producer_audit(combined,meta,protocol,source,registry,binary)
    require(rows[:316]==prior_rows,'Original316 rows changed in derived aggregate')
    reconstructed=resume_contract.combine_metadata(original,resumed,resumed['case'],counts)
    reconstructed.update(known_mapping_records=110,results_sha256=sha(combined/'results.csv'),quality_sha256=sha(combined/'quality.json'),
        original_raw_unchanged=True,final_sources_dependencies_binaries_equal=True)
    require(meta==reconstructed,'Derived metadata differs from the two preserved sessions')
    require(meta['rows']==336 and meta['case_count']==18 and meta['known_mapping_records']==110 and
        meta['family_geometry_size_seed_quality_records']==112 and meta['pooled']is False,'Wrong complete count metadata')
    require(sha(combined/'results.csv')==meta['results_sha256'] and sha(combined/'quality.json')==meta['quality_sha256'],'Changed aggregate/quality pin')
    return rows,protocol,registry,meta,{name:info['sha256']for name,info in manifest['files'].items()}


def wilson(fp, n):
    require(type(fp) is int and type(n) is int and n > 0 and 0 <= fp <= n, "Invalid sample")
    z = 1.959963984540054
    z2, p = z * z, fp / n
    denominator = 1 + z2 / n
    center = (p + z2 / (2 * n)) / denominator
    half = z * math.sqrt(p * (1 - p) / n + z2 / (4 * n * n)) / denominator
    return (0.0 if fp == 0 else max(0, center - half), 1.0 if fp == n else min(1, center + half))


def identity(row):
    return (row["filter"], int(row["keys"]), int(row["filter_bytes"]), int(row["seed"]))


def quality(rows):
    groups = {}
    semantic_fields = ("result_checksum", "false_positives", "absent_queries", "present_queries",
                       "calibration_false_positives", "calibration_absent_queries", "effective_probes",
                       "probe_policy", "logical_bytes", "unit_count", "constructor_argument")
    for row in rows:
        key, semantic = identity(row), tuple(row[k] for k in semantic_fields)
        entry = groups.setdefault(key, dict(semantic=semantic, batches=set(), row=row))
        require(entry["semantic"] == semantic and int(row["batch"]) not in entry["batches"], "Cross-batch drift or repeated sample")
        entry["batches"].add(int(row["batch"]))
    require(len(groups) == 112 and all(v["batches"] == {1, 31, 4096} for v in groups.values()), "Wrong112 API quality records")
    records = []
    for (name, n, size, seed), entry in sorted(groups.items()):
        row = entry["row"]
        fp, probes = int(row["calibration_false_positives"]), int(row["calibration_absent_queries"])
        low, high = wilson(fp, probes)
        records.append(dict(filter=name, keys=n, filter_bytes=size, actual_bpk=8 * size / n, seed=seed,
                            false_positives=fp, negatives=probes, point_fpr=fp / probes,
                            wilson95_low=low, wilson95_high=high, family_record=True,
                            cross_family_alias_assumed=False, proven_mapping=("Fastbloom017" if name=="Fastbloom017K11" and float(row["actual_bpk"])==16 else name)))
    return records


def owner(row):
    name, origin = row["filter"], row["implementation_origin"]
    expected = "production_native" if name in guard.NATIVE else "external" if name in guard.EXTERNAL else "native_experimental"
    require(name in guard.NAMES and origin == expected, "Wrong ownership")
    return expected


def outcome(ratio):
    return "win" if ratio > 1 else "loss" if ratio < 1 else "tie"


def leaders(rows, metric):
    if not rows:
        return [], None
    best = min(float(r[metric]) for r in rows)
    return [dict(filter=r["filter"], filter_bytes=int(r["filter_bytes"]), actual_bpk=float(r["actual_bpk"]))
            for r in rows if float(r[metric]) == best], best


def rank(rows, q, metrics):
    quality_map = {(r["filter"], r["keys"], r["filter_bytes"], r["seed"]): r for r in q}
    by_case = defaultdict(list)
    for row in rows:
        by_case[(int(row["keys"]), int(row["batch"]))].append(row)
    require(len(by_case) == 6 and all(len(v) == 56 for v in by_case.values()), "Wrong allocation choice set")
    views, alternatives, range_alternatives = [], [], []
    for (n, batch), options in sorted(by_case.items()):
        for cap, ceiling, metric in itertools.product(CAPS, CEILINGS, metrics):
            base = dict(keys=n, batch=batch, cap_bpk=cap, fpr_ceiling=ceiling, metric=metric,
                        policy="current_seed42_two_sided_wilson95_upper")
            def admitted(row):
                return int(row["filter_bytes"]) * 8 <= cap * n and quality_map[identity(row)]["wilson95_high"] <= ceiling
            feasible = [r for r in options if admitted(r)]
            selections = {kind: leaders([r for r in feasible if owner(r) == kind], metric) for kind in OWNERS}
            selections["overall"] = leaders(feasible, metric)
            view = dict(base, feasible_allocations=len(feasible))
            for kind, (chosen, ns) in selections.items():
                view[kind + "_leaders"], view[kind + "_ns"] = chosen, ns
            candidate_ns = selections["native_experimental"][1]
            for kind in ("external", "production_native"):
                rival_ns = selections[kind][1]
                ratio = rival_ns / candidate_ns if rival_ns is not None and candidate_ns is not None else None
                view["range_vs_" + kind] = ratio
                view["range_vs_" + kind + "_outcome"] = outcome(ratio) if ratio is not None else "ineligible_or_missing"
            prod,ext=selections['production_native'][1],selections['external'][1]
            view['production_vs_external']=ext/prod if prod is not None and ext is not None else None
            view['production_vs_external_outcome']=outcome(view['production_vs_external'])if view['production_vs_external']is not None else 'ineligible_or_missing'
            views.append(view)
            for row in options:
                qr = quality_map[identity(row)]
                ns = float(row[metric])
                require(math.isfinite(ns) and ns > 0, "Invalid latency")
                record = dict(base, filter=row["filter"], owner=owner(row), requested_bpk=int(row["requested_bpk"]),
                              filter_bytes=int(row["filter_bytes"]), actual_bpk=float(row["actual_bpk"]),
                              budget_pass=int(row["filter_bytes"]) * 8 <= cap * n,
                              quality_pass=qr["wilson95_high"] <= ceiling, eligible=admitted(row),
                              wilson95_high=qr["wilson95_high"], latency_ns=ns)
                if metric in QUERY:
                    prefix = metric.removesuffix("_ns")
                    record.update(trials=[float(x) for x in row[prefix + "_trials"].split("|")],
                                  minimum_ns=float(row[prefix + "_min_ns"]), maximum_ns=float(row[prefix + "_max_ns"]),
                                  phase_order=row["query_phase_order"])
                else:
                    record["build_trial_vectors_recorded"] = False
                for kind in ("external", "production_native", "overall"):
                    rival_ns = selections[kind][1]
                    record["ratio_vs_" + kind + "_leader"] = rival_ns / ns if rival_ns is not None else None
                alternatives.append(record)
                if row["filter"] == RANGE:
                    range_alternatives.append(dict(record))
    require((len(views), len(alternatives), len(range_alternatives)) == (216, 12096, 648), "Wrong complete nested ranking counts")
    return dict(views=views, alternatives=alternatives, range_alternatives=range_alternatives)


def same_allocation_controls(rows):
    by_case = {(r["filter"], int(r["keys"]), int(r["filter_bytes"]), int(r["batch"])): r for r in rows}
    pairs = []
    for row in rows:
        if row["filter"] != RANGE or float(row["actual_bpk"]) not in (16, 32):
            continue
        control = by_case[("Split64BloomFilter", int(row["keys"]), int(row["filter_bytes"]), int(row["batch"]))]
        for metric in QUERY + BUILD:
            ratio = float(control[metric]) / float(row[metric])
            pairs.append(dict(keys=int(row["keys"]), actual_bpk=float(row["actual_bpk"]), batch=int(row["batch"]),
                              metric=metric, range_ns=float(row[metric]), production_split64_ns=float(control[metric]),
                              speedup=ratio, outcome=outcome(ratio), same_byte_budget=True,
                              identical_hash_mapping_assumed=False))
    require(len(pairs) == 96, "Wrong same-allocation controls")
    return pairs


def api_ratios(rows):
    result = []
    for row in rows:
        for staged, visible in (("lookup_ns", "inline_lookup_ns"), ("hash_lookup_ns", "inline_hash_lookup_ns")):
            ratio = float(row[staged]) / float(row[visible])
            result.append(dict(filter=row["filter"], owner=owner(row), keys=int(row["keys"]),
                               actual_bpk=float(row["actual_bpk"]), batch_tag=int(row["batch"]),
                               original_contract=staged, visible_contract=visible,
                               original_ns=float(row[staged]), visible_ns=float(row[visible]),
                               visible_speedup=ratio, outcome=outcome(ratio),
                               visible_loop_scope="whole-array public singleton loop; batch tag does not change this API contract"))
    require(len(result) == 672, "Wrong four-mode API pair count")
    return result


def write_csv(path, records):
    with path.open("w", newline="") as stream:
        fields = list(dict.fromkeys(k for row in records for k in row))
        writer = csv.DictWriter(stream, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows({k: json.dumps(v, separators=(",", ":")) if isinstance(v, (list, dict)) else v
                          for k, v in row.items()} for row in records)


def save_json(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + "\n")


def fixed_default_pairs(rows,q):
    indexed={(r['filter'],int(r['keys']),int(r['requested_bpk']),int(r['batch'])):r for r in rows}
    quality_index={identity(r):r for r in q}
    pairs=[]
    for row in rows:
        if row['filter']not in guard.FIXED:continue
        original=indexed[('Fastbloom017',int(row['keys']),int(row['requested_bpk']),int(row['batch']))]
        require(row['filter_bytes']==original['filter_bytes'],'Fixed/default allocated bytes differ')
        current_q,default_q=quality_index[identity(row)],quality_index[identity(original)]
        for metric in QUERY+BUILD:
            ratio=float(original[metric])/float(row[metric])
            pairs.append(dict(filter=row['filter'],keys=int(row['keys']),actual_bpk=float(row['actual_bpk']),batch=int(row['batch']),
                fixed_K=int(row['effective_probes']),default_K=int(original['effective_probes']),metric=metric,
                fixed_ns=float(row[metric]),default_ns=float(original[metric]),default_over_fixed=ratio,outcome=outcome(ratio),
                fixed_wilson_upper=current_q['wilson95_high'],default_wilson_upper=default_q['wilson95_high'],
                equal_payload_bytes=True,equal_quality_assumed=False))
    require(len(pairs)==1728,'Incomplete fixed/default comparison grid')
    return pairs


def baseline_expansion(rows,q,query):
    quality_map={identity(r):r for r in q}
    grouped=defaultdict(list)
    for r in rows:grouped[(int(r['keys']),int(r['batch']))].append(r)
    result=[]
    for view in query['views']:
        n,cap,ceiling,metric=view['keys'],view['cap_bpk'],view['fpr_ceiling'],view['metric']
        old=[r for r in grouped[(n,view['batch'])]if r['filter']in {'Fastbloom017','BloomsdayPinned','SbbfSafePinned'}
            and int(r['filter_bytes'])*8<=cap*n and quality_map[identity(r)]['wilson95_high']<=ceiling]
        selected,ns=leaders(old,metric);expanded=view['external_ns']
        result.append(dict(keys=n,batch=view['batch'],cap_bpk=cap,fpr_ceiling=ceiling,metric=metric,
            default_only_external_leaders=selected,default_only_external_ns=ns,
            all_public_K_external_leaders=view['external_leaders'],all_public_K_external_ns=expanded,
            external_baseline_speedup=ns/expanded if ns is not None and expanded is not None else None,
            same_screen=True,all_allocations_same_process=False,older_screen_timings_imported=False))
    require(len(result)==216,'Wrong baseline expansion views')
    return result


def scores(records,key):
    values=[r[key]for r in records]
    return '/'.join(str(values.count(x))for x in ('win','loss','tie')),values.count('ineligible_or_missing')


def describe(query,build,q,meta,pairs,expanded):
    lines=['# Complete public Fastbloom probe-count performance screen','',
        'This is the complete seed42 training screen of production4, Range, and the three public external families, including every Fastbloom K1…12 plus its original automatic11/17/22-probe controls. All336 rows are retained. It is not held-out confirmation or a global fastest claim.','',
        'Each of216 query views fixes key count, batch tag, actual-byte ceiling16/24/32, Wilson95 upper-bound FPR ceiling1%/0.1%/0.01%, and one of four API contracts. Every view sees all56 measured allocations for that size/batch. Smaller allocations compete under larger caps; all12096 alternatives retain failures, losses and exact ties. No diagnostic minimum-K selection removes a timing row.','',
        '| Query contract | Best production vs expanded external W/L/T | Missing | Range vs expanded external W/L/T | Missing |',
        '|---|---:|---:|---:|---:|']
    for metric in QUERY:
        records=[r for r in query['views']if r['metric']==metric]
        prod,pm=scores(records,'production_vs_external_outcome');rang,rm=scores(records,'range_vs_external_outcome')
        lines.append(f'| {metric} | {prod} | {pm} | {rang} | {rm} |')
    lines+=['','These are descriptive nested comparisons of measured medians. They are not independent statistical victories. Ownership classes remain explicit; the native experimental Range is never counted as an external baseline. Each mode selects its own fastest eligible allocation.','',
        '## What the public K grid changes','',
        'The earlier default constructor selected11/17/22 probes at actual16/24/32 bpk. This screen calls the pinned public `.hashes(K)` builder for every K1…12 without changing upstream storage, hashing or query kernels. Every configuration uses real n and the same exact allocated byte ceiling. All mixed and independent calibration counts reproduce the previously frozen112-row accuracy matrix.','',
        'baseline-expansion.csv compares the original three external configurations against their expanded set in this same screen. Each exact size/cap/batch executes all its APIs in one process; nested-cap choices can span separate case processes. It imports no older latency and retains all216 views. The fixed/default table additionally keeps1728 equal-byte query/build pairs, including unqualified fixed-K settings and losses; equal bytes are not assumed to mean equal FPR.','',
        '| Keys | Contract | Batch | Cap | FPR ceiling | Best expanded external | External ns/key | Best production | Production ns/key | Range ns/key |',
        '|---:|---|---:|---:|---:|---|---:|---|---:|---:|']
    for n in (1<<16,1<<25):
        for metric,batch in [('lookup_ns',1),('lookup_ns',4096),('inline_hash_lookup_ns',1)]:
            for cap,ceiling in [(16,.001),(24,.0001),(32,.0001)]:
                v=next(x for x in query['views']if (x['keys'],x['metric'],x['batch'],x['cap_bpk'],x['fpr_ceiling'])==(n,metric,batch,cap,ceiling))
                def labels(kind):return ', '.join(f"{x['filter']}@{x['actual_bpk']:g}"for x in v[kind+'_leaders'])or 'none'
                def ns(kind):return f"{v[kind+'_ns']:.4f}"if v[kind+'_ns']is not None else '—'
                lines.append(f"| {n} | {metric} | {batch} | {cap} | {ceiling:g} | {labels('external')} | {ns('external')} | {labels('production_native')} | {ns('production_native')} | {ns('native_experimental')} |")
    lines+=['','The complete tables retain the other thresholds, batch31, visible prehashed and staged common-hash modes. Visible public singleton loops remain whole-array calls: the batch tag does not change those loops. SBBF public dispatch and each library’s public method remain intact. No private external kernel is substituted.','',
        '## Quality, construction and controls','',
        'The112 API/geometry/size/seed observations each use the same2^24 independent negative keys as frozen calibration. Repeated batch tags and four query modes do not increase the denominator. Only the proven default16/K11 constructor aliases are collapsed, yielding110 known mapping records; other public families are not pooled even if counts happen to match. Every point rate and two-sided95% Wilson bound remains in the quality files.','',
        'The minimum qualified fixed K for1%/0.1%/0.01% is3/6/none at16 bpk,2/4/7 at24 bpk, and2/3/5 at32 bpk, at both tested sizes. These are quality outcomes, not assumptions about the fastest K. A Wilson upper bound crossing a target is a precision gate failure, not proof that the true rate exceeds that target. Current seed42 gates govern this training ranking; historical FourSector precision studies are separate context and do not silently exclude current rows.','',
        'All four build metrics have their own216 views and12096 alternatives: insertion, allocation+insertion, common-hash insertion and allocation+common-hash insertion. Original fixed build ordering is retained. Only build medians are recorded by the frozen CSV; no per-trial dispersion is invented. Query trial vectors, minimum/maximum and exact phase order are retained in every query alternative.','',
        'same-allocation-controls.csv retains96 Range versus production Split64 query/build pairs at actual16/32 bpk. Equal allocation does not imply identical address mapping. api-ratios.csv retains672 original-staged versus visible-public comparisons. All individual losses remain in these tables and the full alternatives; this is a serial benchmark, not a parallel-build comparison.','',
        '## Provenance and interrupted-workload completion','',
        f"Measured source `{COMMIT}`; real timed executable SHA `{meta['executable_sha256']}`. The new executable comes from the original committed timed package, not the untimed accuracy entry. Complete preflight passed native/ASan actual timed-output fault checks, phase checks,336 tiny semantic rows and14 malformed CLIs; fixed-K bitmap/allocation validation was reused from the prior pinned evidence.",'',
        'The original matrix was interrupted during its last workload: the process tool returned143, with an unknown termination cause. Its first17 cases/316 rows and original complete=false metadata are retained at commit ab98c241. A source-review issue in the future finalizer would have overwritten the command ledger, but that overwrite never occurred. The read-only observer retained25 exact inotify checkpoints; none contained18 completed cases. Only the unfinished final20-row workload was restarted under the separately committed504e1a27 driver, using the identical f499 executable and full original arguments. The first17 completed cases were not rerun. The derived336 archive copies their raw bytes exactly and explicitly records the interrupted and resumed sessions, while leaving the original metadata unchanged. A separate case_count avoids the future finalization bug. Every command, order, raw hash, trial, interval and semantic count is checked with the frozen producer audit before analysis.','',
        'The source audit verifies592 frozen input hashes and committed blobs, exact compiled anchors, all dependency trees and executable hashes. Each session held an exclusive CPU3/socket1 inherited flock; CPU affinity was applied without explicit NUMA memory binding. Case/filter ordering, allocator placement and one training seed remain practical limits. The four query phases are balanced within each row; unrelated rows and build phases do not acquire extra statistical independence from that schedule.','']
    return '\n'.join(lines)


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--raw-commit',required=True);p.add_argument('--output',type=Path,default=HERE/'report');args=p.parse_args()
    rows,protocol,registry,meta,raw_hashes=load(args.raw_commit)
    q=quality(rows);query=rank(rows,q,QUERY);build=rank(rows,q,BUILD)
    pairs=fixed_default_pairs(rows,q);controls=same_allocation_controls(rows);apis=api_ratios(rows);expanded=baseline_expansion(rows,q,query)
    require(not args.output.exists()and not args.output.is_symlink(),'Preserve previous report')
    args.output.mkdir()
    for label,result in [('query',query),('build',build)]:
        for key,name in [('views','views'),('alternatives','alternatives'),('range_alternatives','range-alternatives')]:write_csv(args.output/(label+'-'+name+'.csv'),result[key])
    for name,data in [('fixed-vs-default',pairs),('same-allocation-controls',controls),('api-ratios',apis),('baseline-expansion',expanded)]:write_csv(args.output/(name+'.csv'),data)
    save_json(args.output/'api-quality.json',q)
    save_json(args.output/'known-mapping-quality.json',json.loads((STAGE/'resume-results-v1/combined/quality.json').read_text()))
    save_json(args.output/'verified.json',dict(source_commit=COMMIT,combined_raw_commit=args.raw_commit,interrupted_raw_commit='ab98c241a1ca71c8a502806c013949276e06d67d',resume_source_commit='504e1a27ccdb9d8ed61ebd5e5d1657b1a1f6e2da',rows=336,cases=18,API_quality_records=112,known_mapping_records=110,
        source_evidence_inputs=592,raw_sha256=raw_hashes,query_counts={k:len(v)for k,v in query.items()},build_counts={k:len(v)for k,v in build.items()},
        fixed_default_pairs=len(pairs),same_allocation_pairs=len(controls),API_pairs=len(apis),baseline_expansion_views=len(expanded),
        completed_cases_rerun=False,unfinished_case_restarted=True,quality_pooling=False,measurement_sessions=meta['sessions']))
    (args.output/'REPORT.md').write_text(describe(query,build,q,meta,pairs,expanded))
    print('Complete336 analysis:216 query/build views each; all12096 alternatives each;112API/110mapping quality; all1728 fixed/default pairs')


if __name__=='__main__':main()
