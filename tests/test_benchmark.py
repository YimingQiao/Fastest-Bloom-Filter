#!/usr/bin/env python3
import csv
import io
import subprocess
import sys

exe = sys.argv[1]
for hit in (0, 50, 100):
    result = subprocess.run([exe, '10', '16', str(hit), '12', '31', '2', '42'],
                            text=True, capture_output=True, check=True)
    rows = list(csv.DictReader(io.StringIO(result.stdout)))
    assert len(rows) >= 8
    for row in rows:
        assert int(row['filter_bytes']) == 4096
        assert float(row['actual_bpk']) == 32
        present = sum(i % 100 < hit for i in range(4096))
        assert int(row['present_queries']) == present
        absent = 4096 - present
        assert int(row['absent_queries']) == absent
        if absent:
            assert abs(float(row['fpr']) - int(row['false_positives']) / absent) < 1e-6
        else:
            assert row['fpr'] == 'nan'
        assert 0 < float(row['lookup_min_ns']) <= float(row['lookup_ns']) <= float(row['lookup_max_ns'])
        assert float(row['insert_ns']) > 0
for args in (['-1'], ['16x'], ['4294967312'], ['16','16','101'], ['16','16','0','22','0']):
    assert subprocess.run([exe]+args, capture_output=True).returncode != 0
print('Benchmark accounting checks passed')
