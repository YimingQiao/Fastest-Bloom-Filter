#!/usr/bin/env python3
"""Descriptive analysis of the committed fixed36 accuracy-only pilot; never runs a filter."""
import csv
import hashlib
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
STAGE = ROOT / 'experiments/2026-10-29-vldb-nearby-geometry/accuracy'
SCREEN = STAGE / 'screening'
RAW_COMMIT = 'f8d1449cb5abb41609b426229bde11f77ad03921'
SOURCE_COMMIT = '174081860f588e9a1aef8f2b016ca3c0e6523790'
ARCHIVE_SHA = '094f0e256662b3341c396436a9397956f0c8bc8f66921f4d3d8acf2ebde08aa3'
sys.path.insert(0, str(SCREEN))
from pilot_guard import audit, verify
from contract import cases, quality


def need(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def blob(path, commit):
    return subprocess.check_output(['git', 'show', commit + ':' + str(path.relative_to(ROOT))], cwd=ROOT)


def load():
    archive = SCREEN / 'RAW_ARCHIVE.json'
    need(sha(archive) == ARCHIVE_SHA and archive.read_bytes() == blob(archive, RAW_COMMIT), 'Changed raw descriptor')
    descriptor = json.loads(archive.read_text())
    need(descriptor['producer_commit'] == SOURCE_COMMIT and descriptor['observed_exit_code'] == 0 and
         descriptor['rows'] == 36 and descriptor['throughput_samples'] == 0 and len(descriptor['files']) == 76,
         'Wrong complete raw pilot')
    for name, expected in descriptor['files'].items():
        path = SCREEN / name
        need(sha(path) == expected and path.read_bytes() == blob(path, RAW_COMMIT), 'Changed raw artifact ' + name)
    # Pin the producer's analysis contract too; no current working-tree rules may silently replace it.
    for directory, manifest, commit in [
        (SCREEN, 'PREPARATION.json', SOURCE_COMMIT),
        (STAGE, 'PREPARATION.json', '61297f000468ed498d5dc12df1bd4fcf129bbf12'),
    ]:
        path = directory / manifest
        need(path.read_bytes() == blob(path, commit), 'Changed source manifest')
        entries = json.loads(path.read_text())['files']
        for name, item in entries.items():
            target = directory / name
            expected = item if isinstance(item, str) else item['sha256']
            need(sha(target) == expected and target.read_bytes() == blob(target, commit), 'Changed source rule ' + name)
    output = SCREEN / 'results-v1'
    metadata = json.loads((output / 'metadata.json').read_text())
    binary, _ = verify(SOURCE_COMMIT)
    rows, records = audit(output, metadata, binary, SOURCE_COMMIT, final=True)
    need(records == quality(rows), 'Changed pointwise quality calculations')
    return rows, records


def calculate(rows, records):
    need(len(rows) == len(records) == 36, 'Missing fixed point')
    points = []
    for case, row, q in zip(cases(), rows, records, strict=True):
        need(all(q[key] == case[key] for key in ('filter', 'power', 'cap', 'policy', 'status')), 'Changed point identity')
        item = dict(q, keys=1 << q['power'])
        if q['status'] == 'supported':
            item.update(unit_count=int(row['unit_count']), unit_bytes=int(row['unit_bytes']),
                        constructor_argument=int(row['constructor_argument']), address=row['address'],
                        actual_backing_bpk=q['filter_bytes'] * 8 / (1 << q['power']),
                        mixed_false_positives=int(row['false_positives']),
                        mixed_absent_queries=int(row['absent_queries']),
                        result_checksum=row['result_checksum'], query_checksum=row['query_checksum'],
                        calibration_checksum=row['calibration_checksum'])
        points.append(item)
    pairs = []
    for new in points:
        if new['policy'] != 'nearby_odd':
            continue
        old = [x for x in points if x['policy'] == 'original' and
               all(x[k] == new[k] for k in ('filter', 'power', 'cap'))]
        need(len(old) == 1, 'Missing unique matched original')
        old = old[0]
        pair = dict(filter=new['filter'], keys=new['keys'], cap_bpk=new['cap'], status=new['status'],
                    original=old, nearby=new, pooled=False)
        if new['status'] == 'supported':
            need(old['status'] == 'supported' and old['negatives'] == new['negatives'] and
                 old['query_checksum'] == new['query_checksum'] and
                 old['calibration_checksum'] == new['calibration_checksum'], 'Unmatched raw stream')
            pair.update(observed_fp_change=new['false_positives'] - old['false_positives'],
                        nearby_over_original_observed_fp=new['false_positives'] / old['false_positives']
                        if old['false_positives'] else None,
                        backing_byte_change=new['filter_bytes'] - old['filter_bytes'])
        pairs.append(pair)
    need(len(pairs) == 12 and sum(x['policy'] == 'original' for x in points) == 24, 'Changed fixed coverage')
    return points, pairs


def save(path, obj):
    path.write_text(json.dumps(obj, indent=2) + '\n')


def write_csv(path, records):
    fields = list(dict.fromkeys(key for row in records for key in row))
    with path.open('w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fields, lineterminator='\n')
        writer.writeheader()
        for row in records:
            writer.writerow({key: json.dumps(value, separators=(',', ':')) if isinstance(value, (dict, list)) else value
                             for key, value in row.items()})


def report(points, pairs):
    lines = ['# Fixed nearby-divisor accuracy pilot', '',
        'All 12 prespecified nearby geometries have fewer observed false positives than their matched original '
        'geometries. This is one seed and an accuracy-only experiment: it contains no speed measurement, no '
        'cross-seed confirmation, and no isolated causal decomposition of the improvement.', '',
        'At cap12, sector32 and sector64 pass the 1% pointwise Wilson gate at both sizes; register64 still fails. '
        'At cap24, sector32 passes 0.1% but fails 0.01% at both sizes. Sector64 passes 0.01% only for the small '
        'table, while the large table fails. Register64 fails 0.1% for the small table and passes it for the large '
        'table. Thus none of the new layouts passes 0.01% at both tested sizes.', '',
        'The unchanged original public PImpl API uses K8 and the fixed U shown in each name. The only selected '
        'change is the constructor capacity: largest accepted odd divisor within the fixed top 1% window, '
        'with all 64-byte backing padding charged. Unsupported points would remain unsupported; all 12 were '
        'supported here. No private kernel, new hash, probe policy, or tuner override was substituted.', '',
        'Each row uses seed42, a complete construction of 2^16 or 2^25 distinct raw-u32 keys, 2^22 mixed '
        'queries, and 2^24 distinct nonmember calibration keys. All inserted keys and complete outputs pass '
        'the frozen caller checks. The 24 original rows exactly reproduce the earlier raw728 semantic '
        'observations and are not fresh evidence. Matched points use the same raw query and calibration '
        'streams; samples are not pooled across geometries, APIs, or the two sizes.', '',
        'Wilson endpoints are two-sided 95% pointwise endpoints, not simultaneous guarantees for this '
        '36-point panel. FPR values below are percentages. The paired count change is descriptive; no '
        'paired statistical test or claim that oddness alone caused it is made.', '',
        '## All 12 fixed original/nearby comparisons', '',
        '| Public configuration | Keys | Cap bpk | Original / nearby backing bytes | Original / nearby FP counts | Original / nearby Wilson upper, % | Nearby gates passed |',
        '|---|---:|---:|---:|---:|---:|---|']
    for pair in pairs:
        old, new = pair['original'], pair['nearby']
        if new['status'] != 'supported':
            lines.append(f"| {new['filter']} | {new['keys']} | {new['cap']} | unsupported | — | — | none |")
            continue
        gates = ', '.join(label for key, label in [('passes_1pct', '1%'), ('passes_0_1pct', '0.1%'),
                                                   ('passes_0_01pct', '0.01%')] if new[key]) or 'none'
        lines.append(f"| {new['filter']} | {new['keys']:,} | {new['cap']} | {old['filter_bytes']:,} / {new['filter_bytes']:,} | "
                     f"{old['false_positives']:,} / {new['false_positives']:,} | {old['wilson95_high']*100:.7f} / {new['wilson95_high']*100:.7f} | {gates} |")
    lines += ['', 'The strict small sector64 point has 1,491/16,777,216 false positives and upper '
              '0.0093497%; its large counterpart has 1,717 false positives and upper 0.0107297%, '
              'so the latter failure is retained. Register64 cap24 has 17,207 false positives and upper '
              '0.1041048% at the small size, versus 15,497 and 0.0938344% at the large size.', '',
              '## All 36 point records', '',
              '| Public configuration | Keys | Cap bpk | Policy | Backing bytes | Logical units | FP / 2^24 | Point FPR, % | Wilson 95% interval, % |',
              '|---|---:|---:|---|---:|---:|---:|---:|---:|']
    for x in points:
        if x['status'] != 'supported':
            lines.append(f"| {x['filter']} | {x['keys']} | {x['cap']} | {x['policy']} | unsupported | — | — | — | — |")
        else:
            lines.append(f"| {x['filter']} | {x['keys']:,} | {x['cap']} | {x['policy']} | {x['filter_bytes']:,} | {x['unit_count']:,} | "
                         f"{x['false_positives']:,} | {x['point_fpr']*100:.7f} | {x['wilson95_low']*100:.7f}–{x['wilson95_high']*100:.7f} |")
    lines += ['', '## Evidence and limits', '',
              f'- Complete raw commit: `{RAW_COMMIT}`; descriptor SHA `{ARCHIVE_SHA}`.',
              f'- Frozen accuracy producer: `{SOURCE_COMMIT}`; native binary SHA `4e67b8e0351f574004c0db485ba4883d128dd8906120d49b5b0eacaab781e930`.',
              '- Caller proof `14a5a1cb7d96d41abd62ce05e82dcb29b6a42353` covers native/ASan public calls; geometry proof `11584813b8f300d0405c58d458bbf901c996468b` covers 93 native/AVX2/ASan configurations.',
              '- All 36 processes completed under the socket0 whole-operation lock and CPU2 affinity. All 76 raw artifacts and the raw descriptor were committed byte-exact before this analysis.',
              '- Every build and query timing field is unavailable (`nan`), repeats are zero, and no throughput sample is inferred from command duration.',
              '- These results add a stronger public-constructor baseline capacity choice. They do not replace the earlier original MAGIC results or establish a speed winner. Any performance comparison or fresh-seed extension requires a separately fixed protocol.',
              '', 'Reproduce without executing a filter: `taskset -c 4 python3 experiments/2026-10-29-vldb-nearby-geometry-analysis/summarize.py`.']
    return '\n'.join(lines) + '\n'


def main():
    points, pairs = calculate(*load())
    output = HERE / 'report'
    need(not output.exists(), 'Refuse to overwrite an existing analysis')
    output.mkdir()
    write_csv(output / 'all-points.csv', points)
    save(output / 'matched-pairs.json', pairs)
    save(output / 'metadata.json', dict(raw_commit=RAW_COMMIT, producer_commit=SOURCE_COMMIT,
         raw_archive_sha256=ARCHIVE_SHA, points=36, original_reproductions=24, new_points=12,
         seeds=[42], pooled=False, filter_executions=0, timing_samples=0,
         supported_new_points=sum(x['status'] == 'supported' for x in pairs)))
    (HERE / 'RESULTS.md').write_text(report(points, pairs))
    print('PASS descriptive 36-point / 12-pair report; no filter execution or timing')


if __name__ == '__main__':
    main()
