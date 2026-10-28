import csv
import io
import math
import subprocess
import sys

for hit in (0, 50, 100):
    checksums = set()
    for insert_batch in (1, 31, 1024):
        output = subprocess.check_output(
            [sys.argv[1], '10', '8', str(hit), '12', '31', '2', '42', '', str(insert_batch)], text=True)
        rows = list(csv.DictReader(io.StringIO(output)))
        assert len(rows) == 2
        checksums.update(row['result_checksum'] for row in rows)
        assert len({row['false_positives'] for row in rows}) == 1
        for row in rows:
            assert int(row['insert_batch']) == insert_batch
            for field in ('hash_insert_ns', 'allocate_hash_insert_ns', 'hash_lookup_ns'):
                assert math.isfinite(float(row[field])) and float(row[field]) > 0
            for field in ('insert_ns', 'allocate_insert_ns', 'lookup_ns'):
                if row['input_mode'] == 'raw_bytes':
                    assert math.isnan(float(row[field]))
                else:
                    assert math.isfinite(float(row[field])) and float(row[field]) > 0
    assert len(checksums) == 1
print('Raw/prehashed parity, no double hashing, timing labels and independent build batches passed.')
