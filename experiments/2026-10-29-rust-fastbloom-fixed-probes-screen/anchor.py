"""Bind every performance API/geometry to the complete112-row quality matrix."""
import csv
import io
import json
from bindings import PUBLIC, need

FIELDS = ('keys','queries','requested_bpk','filter_bytes','actual_bpk','hash_bits','hit_percent','present_queries',
    'seed','absent_queries','false_positives','result_checksum','input_mode','calibration_absent_queries',
    'calibration_false_positives','budget_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count',
    'effective_probes','probe_policy','constructor_argument','implementation_origin','size_contract')


def compare(rows, tiny=False):
    if tiny:
        reference = json.loads((PUBLIC/'accuracy-validation-v2/small-fixtures.json').read_text())['rows_by_mode']['normal']
        expected_count = 60
    else:
        reference = list(csv.DictReader(io.StringIO((PUBLIC/'calibration-results/results.csv').read_text())))
        expected_count = 112
    indexed = {(r['filter'],r['keys'],r['requested_bpk']):r for r in reference}
    need(len(reference) == len(indexed) == expected_count, 'Wrong immutable accuracy reference')
    for row in rows:
        key = row['filter'],row['keys'],row['requested_bpk']
        need(key in indexed, 'No prespecified quality anchor for performance row')
        for field in FIELDS:
            need(row[field] == indexed[key][field], 'Changed public semantic ' + '/'.join(key) + '/' + field)
    return len(rows)
