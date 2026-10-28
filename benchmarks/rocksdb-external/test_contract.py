#!/usr/bin/env python3
"""Accuracy/accounting smoke only; these timings are not performance evidence."""
import csv
import io
import itertools
import math
import subprocess
import sys

FILTERS = [
    'RocksDBFastLocalBloom64', 'RocksDBFastLocalBloom64Batch32',
    'RocksDBFastLocalBloom64K8', 'RocksDBFastLocalBloom64K9', 'RocksDBFastLocalBloom64K14',
    'RocksDBFastLocalBloom64K8Batch32', 'RocksDBFastLocalBloom64K9Batch32',
    'RocksDBFastLocalBloom64K14Batch32',
]
construction_answers = {}
for bpk, hit, batch, insert_batch in itertools.product((4, 8, 16), (0, 50, 100), (1, 31, 32, 33), (9, 1024)):
    command = [sys.argv[1], '10', str(bpk), str(hit), '12', str(batch), '1', '731', ','.join(FILTERS), str(insert_batch), '12']
    rows = list(csv.DictReader(io.StringIO(subprocess.check_output(command, text=True))))
    assert len(rows) == len(FILTERS)
    by_name = {row['filter']: row for row in rows}
    assert set(by_name) == set(FILTERS)
    direct = by_name['RocksDBFastLocalBloom64']
    for suffix in ('', 'K8', 'K9', 'K14'):
        paired_direct = by_name[f'RocksDBFastLocalBloom64{suffix}']
        paired_bulk = by_name[f'RocksDBFastLocalBloom64{suffix}Batch32']
        for field in ('result_checksum', 'filter_bytes', 'false_positives', 'calibration_false_positives'):
            assert paired_direct[field] == paired_bulk[field], (command, suffix, field)
    if bpk in (8, 16):
        fixed = by_name[f'RocksDBFastLocalBloom64K{9 if bpk == 8 else 14}Batch32']
        for field in ('result_checksum', 'false_positives', 'calibration_false_positives'):
            assert fixed[field] == direct[field]
    for row in rows:
        answer_fields = tuple(row[field] for field in ('result_checksum', 'false_positives', 'calibration_false_positives'))
        key = (bpk, hit, row['filter'])
        assert construction_answers.setdefault(key, answer_fields) == answer_fields
        assert row['input_mode'] == 'prehashed' and row['hash_bits'] == '64'
        assert int(row['filter_bytes']) == 1024 * bpk // 4
        assert int(row['absent_queries']) + int(row['present_queries']) == 4096
        assert int(row['calibration_absent_queries']) == 4096
        assert int(row['filter_build_scratch_bytes']) == 0
        assert int(row['insert_batch']) == insert_batch
        for field in ('lookup_ns', 'hash_lookup_ns', 'insert_ns', 'hash_insert_ns'):
            assert math.isfinite(float(row[field])) and float(row[field]) > 0
        assert float(row['hash_lookup_min_ns']) <= float(row['hash_lookup_ns']) <= float(row['hash_lookup_max_ns'])
        if hit == 100:
            assert row['absent_queries'] == '0' and row['fpr'] == 'nan'
print('RocksDB 72 shared-harness configurations x8 rows: fixed/automatic direct/bulk equivalence, full/partial construction, memory, scratch and calibration passed.')
