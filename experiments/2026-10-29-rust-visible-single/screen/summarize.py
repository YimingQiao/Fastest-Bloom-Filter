#!/usr/bin/env python3
"""Report all four frozen public-API contracts independently, retaining every loss."""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import sys


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def wilson(fp, n):
    if not (n > 0 and 0 <= fp <= n):
        raise ValueError('Invalid calibration count')
    z = 1.959963984540054
    p, zz = fp / n, z*z
    center = p + zz/(2*n)
    spread = z*math.sqrt((p*(1-p)+zz/(4*n))/n)
    return (0 if fp == 0 else max(0, (center-spread)/(1+zz/n)),
            1 if fp == n else min(1, (center+spread)/(1+zz/n)))


def write_csv(path, rows):
    with path.open('w', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator='\n')
        writer.writeheader()
        writer.writerows(rows)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--experiment', type=Path, required=True)
    args = parser.parse_args()
    here = args.experiment.resolve()
    sys.path.insert(0, str(here))
    from freeze import verify
    from guard import validate_all
    from run import verify_commit
    screen = here/'screen'
    metadata = json.loads((screen/'metadata.json').read_text())
    protocol = json.loads((here/'protocol.json').read_text())
    registry = json.loads((here/'registry.json').read_text())
    frozen = json.loads((here/'validation/freeze.json').read_text())
    verify(frozen)
    verify_commit(metadata['source_commit'], frozen)
    assert metadata['complete'] is True and metadata['rows'] == 28 and metadata['workloads'] == 4
    assert metadata['freeze_sha256'] == sha(here/'validation/freeze.json')
    assert metadata['protocol_sha256'] == sha(here/'protocol.json')
    assert metadata['results_sha256'] == sha(screen/'results.csv')
    assert metadata['cpu'] == protocol['cpu'] == 2 and metadata['affinity'] == [2]
    for entry in metadata['commands']:
        power, bpk, seed = entry['workload']
        assert entry['complete'] and entry['returncode'] == 0
        assert entry['csv_sha256'] == sha(screen/f'k{power}-p{bpk}-b1-s{seed}.csv')
    rows = list(csv.DictReader((screen/'results.csv').open()))
    validate_all(rows, registry, protocol)
    quality = []
    for row in rows:
        fp, n = int(row['calibration_false_positives']), int(row['calibration_absent_queries'])
        lower, upper = wilson(fp, n)
        quality.append(dict(filter=row['filter'], owner=registry[row['filter']]['owner'], keys=int(row['keys']),
                            requested_bpk=int(row['requested_bpk']), actual_bpk=float(row['actual_bpk']),
                            filter_bytes=int(row['filter_bytes']), seed=int(row['seed']),
                            calibration_negatives=n, calibration_fp=fp, fpr=fp/n,
                            wilson_lower=lower, wilson_upper=upper))
    write_csv(screen/'quality.csv', quality)
    def picked(owner, n, cap, ceiling, metric):
        eligible = [r for r in rows if registry[r['filter']]['owner'] == owner and int(r['keys']) == n
                    and int(r['filter_bytes'])*8 <= n*cap
                    and wilson(int(r['calibration_false_positives']), int(r['calibration_absent_queries']))[1] <= ceiling]
        if not eligible:
            return None
        row = min(eligible, key=lambda r:(float(r[metric]), int(r['filter_bytes']), r['filter']))
        prefix = metric[:-3]
        return dict(filter=row['filter'], actual_bpk=float(row['actual_bpk']), filter_bytes=int(row['filter_bytes']),
                    median_ns=float(row[metric]), min_ns=float(row[prefix+'_min_ns']), max_ns=float(row[prefix+'_max_ns']),
                    wilson_upper=wilson(int(row['calibration_false_positives']), int(row['calibration_absent_queries']))[1])
    comparisons, flat, individual = [], [], []
    for metric in protocol['ranking']['metrics']:
        for power in protocol['key_powers']:
            n = 1 << power
            for cap in protocol['ranking']['memory_caps_bpk']:
                for ceiling in protocol['ranking']['fpr_ceilings']:
                    native, external = picked('native',n,cap,ceiling,metric), picked('external',n,cap,ceiling,metric)
                    ratio = external['median_ns']/native['median_ns'] if native and external else None
                    item = dict(metric=metric,keys=n,memory_cap_bpk=cap,fpr_ceiling=ceiling,
                                native=native,external=external,external_over_native=ratio)
                    comparisons.append(item)
                    fields = dict(metric=metric,keys=n,memory_cap_bpk=cap,fpr_ceiling=ceiling)
                    for label, entry in (('native',native),('external',external)):
                        for key in ('filter','actual_bpk','filter_bytes','median_ns','min_ns','max_ns','wilson_upper'):
                            fields[label+'_'+key] = entry[key] if entry else None
                    fields['external_over_native'] = ratio
                    flat.append(fields)
                    for candidate in rows:
                        if registry[candidate['filter']]['owner'] != 'native' or int(candidate['keys']) != n:
                            continue
                        qualifies = int(candidate['filter_bytes'])*8 <= n*cap and wilson(int(candidate['calibration_false_positives']),int(candidate['calibration_absent_queries']))[1] <= ceiling
                        individual.append(dict(metric=metric,keys=n,cap_bpk=cap,fpr_ceiling=ceiling,
                                               candidate=candidate['filter'],requested_bpk=int(candidate['requested_bpk']),
                                               qualifies=qualifies,candidate_ns=float(candidate[metric]),external=external,
                                               external_over_candidate=external['median_ns']/float(candidate[metric]) if qualifies and external else None))
    assert len(flat) == 48 and len(quality) == 28
    write_csv(screen/'rankings.csv',flat)
    ratios=[]
    for row in rows:
        for mode, original, visible in (('prehashed','lookup_ns','inline_lookup_ns'),('raw','hash_lookup_ns','inline_hash_lookup_ns')):
            a,b=float(row[original]),float(row[visible])
            ratios.append(dict(filter=row['filter'],owner=registry[row['filter']]['owner'],keys=int(row['keys']),
                               requested_bpk=int(row['requested_bpk']),actual_bpk=float(row['actual_bpk']),mode=mode,
                               original_ns=a,visible_ns=b,original_over_visible=a/b))
    assert len(ratios)==56
    write_csv(screen/'api-ratios.csv',ratios)
    summary=dict(scope='Seed42 CPU2 initial independent-key throughput screen, unchanged natural public libraries; no promotion or global fastest claim',
                 rows=28,workloads=4,configurations=7,query_contracts=4,rankings=comparisons,individual=individual,
                 api_ratios=56,quality_records=28,analysis_sha256=sha(Path(__file__)),
                 note='Caps/ceilings reuse samples; query contracts share each bitmap/calibration, and no query-mode calibration samples are pooled. Speed ratios are descriptive.')
    (screen/'summary.json').write_text(json.dumps(summary,indent=2,allow_nan=False)+'\n')
    lines=['# Rust public singleton: unchanged natural API screen','',
           'Four workloads / 28 rows on CPU2 compare seven original implementations under four separately reported query contracts. The whole-array modes expose the actual public singleton API to the compiler; they do not force every probe body to inline. Dense outputs, hashing, all four eight-trial vectors and the exact seed-derived Williams schedule were checked. Source and executable hashes were unchanged.','',
           'Seed42, key powers 16/25, actual 16/32 bpk, 50% hits, query power 22, eight balanced repetitions, whole-input insertion and 2^24 independent calibration negatives. This is independent-key throughput, not serial dependent latency. No CPU NUMA binding was applied; CPU2 was pinned. These initial results are not held-out confirmation.','',
           'FastPattern, Fastbloom and Bloomsday probe logic is present inside their visible loops. ByteSplit retains a public contains_hash call per key; FourSector/Split64 retain out-of-line scalar helpers; SBBF retains its public runtime-selected trait-object call. See the pre-data assembly audit. Visible Split/Four paths also differ from their batch SIMD kernels. The measurements must not be attributed solely to removing call overhead.','',
           'Each table uses exact allocated-byte caps and pointwise two-sided 95% Wilson upper endpoints. A ratio above 1 favors the native layout. All individual candidates, including losses, remain in summary.json.','']
    for metric in protocol['ranking']['metrics']:
        lines += ['## '+metric,'','| Keys | Cap bpk | FPR ceiling | Native | ns/key | External | ns/key | External/native |',
                  '| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |']
        for item in comparisons:
            if item['metric'] != metric:continue
            a,b=item['native'],item['external'];r=item['external_over_native']
            values=[str(item['keys']),str(item['memory_cap_bpk']),f"{item['fpr_ceiling']:.2%}",a['filter'] if a else 'No qualifier',
                    f"{a['median_ns']:.3f}" if a else '—',b['filter'] if b else 'No qualifier',f"{b['median_ns']:.3f}" if b else '—',f'{r:.3f}×' if r else '—']
            lines.append('| '+' | '.join(values)+' |')
        lines.append('')
    lines += ['api-ratios.csv retains all 56 within-family original/visible ratios. An improvement in a visible mode does not replace an original-mode loss. The 28 family/size calibration records are shared across all four query modes, and all families use the same inputs. Nested caps and ceilings are not independent performance trials. Min/max ranges are descriptive, with no speed confidence interval or simultaneous FPR-selection guarantee. The tested 16/32 bpk grid does not cover finer upstream capacities.','']
    (screen/'RESULTS.md').write_text('\n'.join(lines))
    print('Wrote 48 separate-mode rankings, 56 API ratios, 28 quality records and all individual comparisons')


if __name__ == '__main__':
    main()
