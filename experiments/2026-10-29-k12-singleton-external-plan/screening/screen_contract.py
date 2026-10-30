"""Fixed48 processes/616 rows and unpooled calibration links; no rankings."""
import json
from pathlib import Path
import row_guard as guard

HERE = Path(__file__).resolve().parent
need = guard.need
FIELDS = set('point_id filter owner keys requested_bpk actual_bytes budget_bytes logical_bytes unit_bytes unit_count effective_probes constructor_argument native_constructor_bpk geometry_kind probe_policy queries hit batch repeats seed reverse_jobs measure key_base inserted_digest query_digest inserted_hash_digest query_hash_digest result_digest present absent false_positives calibration_negatives calibration_fp calibration_digest bitmap_digest query_scratch_bytes phase_order samples'.split())
INSERT_IDENTITY = ('point_id', 'filter', 'owner', 'keys', 'requested_bpk', 'actual_bytes',
    'budget_bytes', 'logical_bytes', 'unit_bytes', 'unit_count', 'effective_probes',
    'constructor_argument', 'native_constructor_bpk', 'geometry_kind', 'probe_policy',
    'seed', 'key_base', 'inserted_digest', 'inserted_hash_digest', 'bitmap_digest')
QUERY_IDENTITY = ('queries', 'hit', 'query_digest', 'query_hash_digest', 'result_digest',
                  'present', 'absent', 'false_positives')
CALIBRATION = ('calibration_negatives', 'calibration_fp', 'calibration_digest')


def read(path):
    return json.loads(Path(path).read_text(), object_pairs_hook=guard.unique)


def ledger():
    value = read(HERE / 'ledger.json')
    need(len(value) == 48 and [v['index'] for v in value] == list(range(48)), 'fixed ledger changed')
    need(sum(len(v['point_ids']) for v in value) == 616, 'fixed row count changed')
    return value


def caller_case(case):
    return dict(power=case['key_power'], hit=case['hit'], query_power=22,
        batch=case['batch'], repeats=8, seed=case['seed'], order=int(case['reverse_jobs']),
        calibration_power=case['calibration_power'])


def arguments(case):
    return guard.arguments(caller_case(case), '--measure')


def parse(text, case):
    c = caller_case(case)
    actual = guard.parse(text, c)
    need({r['point_id'] for r in actual} == set(case['point_ids']), 'case point list changed')
    for row in actual:
        need(set(row) == FIELDS, 'missing or unexpected row fields')
    return actual


def tuple_of(row, fields):
    return tuple(row[k] for k in fields)


def validate_records(records, complete=True):
    need((len(records) == 48) if complete else (0 < len(records) <= 48), 'incomplete process count')
    points = guard.POINTS
    insert_seen, query_seen = {}, {}
    quality = {}
    aliases = {}
    total_rows = total_vectors = total_samples = reuse_rows = 0
    domains = {(d['keys'], d['seed']): d for d in read(HERE / 'input-domains.json')}
    need(len(domains) == 4, 'wrong input domain count')
    for expected, record in zip(ledger()[:len(records)], records, strict=True):
        need(record['case'] == expected, 'case order or command parameters changed')
        rows = parse('\n'.join(json.dumps(r, allow_nan=False) for r in record['rows']), expected)
        for row_index, row in enumerate(rows):
            total_rows += 1
            total_vectors += sum(bool(v) for v in row['samples'].values())
            total_samples += sum(len(v) for v in row['samples'].values())
            key = (row['point_id'], row['seed'])
            insertion = tuple_of(row, INSERT_IDENTITY)
            need(key not in insert_seen or insert_seen[key] == insertion, 'construction identity changed across scenarios')
            insert_seen[key] = insertion
            # Hit rate changes the query stream, while batch and round do not.
            qkey = (*key, row['hit'])
            query = tuple_of(row, QUERY_IDENTITY)
            need(qkey not in query_seen or query_seen[qkey] == query, 'same-input query identity changed')
            query_seen[qkey] = query
            domain = domains[(row['keys'], row['seed'])]
            need(row['key_base'] == domain['key_base'], 'source-defined input domain changed')
            need(domain['insert_interval'] == [row['key_base'], row['key_base'] + row['keys']], 'insert interval changed')
            need(domain['calibration_interval'] == [row['key_base'] + row['keys'] + (1 << 22),
                row['key_base'] + row['keys'] + (1 << 22) + (1 << 26)], 'calibration interval changed')
            if expected['calibration_power']:
                need(expected['round'] == 1 and expected['phase'] == 'primary_singleton' and key not in quality,
                     'unexpected or duplicate calibration source')
                need(row['calibration_negatives'] == 1 << 26, 'wrong fresh calibration denominator')
                entry = {k:row[k] for k in ('point_id', 'keys', 'seed', 'actual_bytes', 'key_base',
                    'inserted_digest', 'inserted_hash_digest', 'bitmap_digest', *CALIBRATION)}
                entry.update(mapping_id=points[row['point_id']]['mapping_id'],
                    source_case_index=expected['index'], source_row_index=row_index, reuse_case_indices=[])
                quality[key] = entry
                alias_key = (entry['mapping_id'], row['seed'])
                evidence = tuple_of(row, ('keys', 'actual_bytes', 'key_base', 'inserted_digest',
                    'inserted_hash_digest', 'bitmap_digest', *QUERY_IDENTITY, *CALIBRATION))
                need(alias_key not in aliases or aliases[alias_key] == evidence, 'known mapping alias differs')
                aliases[alias_key] = evidence
            else:
                need(key in quality, 'reuse precedes fresh calibration source')
                need(row['calibration_negatives'] == 0 and row['calibration_fp'] == 0 and
                     row['calibration_digest'] is None, 'uncalibrated row contains new calibration')
                quality[key]['reuse_case_indices'].append(expected['index'])
                reuse_rows += 1
    if complete:
        need((total_rows, total_vectors, total_samples) == (616, 2032, 16256), 'wrong full vector/sample counts')
        need(len(quality) == 128 and len(aliases) == 108 and reuse_rows == 488, 'wrong quality source/reuse counts')
    for n in (1 << 16, 1 << 25):
        intervals = sorted(d['calibration_interval'] for d in domains.values() if d['keys'] == n)
        need(len(intervals) == 2 and intervals[0][1] <= intervals[1][0], 'same-size fresh negative intervals overlap')
    counts = dict(processes=len(records), rows=total_rows, query_vectors=total_vectors, query_samples=total_samples,
                  calibration_rows=len(quality), reuse_rows=reuse_rows, api_quality_records=len(quality), known_alias_records=len(aliases))
    links = dict(api_records=list(quality.values()), api_record_count=len(quality),
                 known_mapping_record_count=len(aliases), calibration_rows=len(quality), reuse_rows=reuse_rows, pooling=False)
    return counts, links
