#!/usr/bin/env python3
"""Check that single-key shortcut controls preserve complete harness results."""
import csv
import io
from pathlib import Path
import subprocess
import sys

binary = Path(sys.argv[1]).resolve()
pairs = [('ByteSplit128Experiment', 'ByteSplit128SingleExperiment'),
         ('IndependentSplit32Experiment', 'IndependentSplit32SingleExperiment'),
         ('FastFilterFixed16', 'FastFilterFixed16SingleControl'),
         ('FastFilterSimdBlock', 'FastFilterSimdBlockSingleControl')]
filters = ','.join(name for pair in pairs for name in pair)
fields = ['filter_bytes', 'actual_bpk', 'hash_bits', 'false_positives', 'absent_queries',
          'result_checksum', 'calibration_absent_queries', 'calibration_false_positives',
          'filter_build_scratch_bytes']
cases = 0
for bpk in (8, 16):
    for hit in (0, 50, 100):
        for batch in (1, 7, 31, 4096):
            cmd = ['taskset', '-c', '3', str(binary), '10', str(bpk), str(hit), '12', str(batch),
                   '1', '731', filters, '31', '12']
            rows = {r['filter']: r for r in csv.DictReader(io.StringIO(subprocess.check_output(cmd, text=True)))}
            assert len(rows) == 8
            for base, control in pairs:
                for field in fields:
                    assert rows[base][field] == rows[control][field], (base, control, field)
            cases += 1
print(f'{cases} mixed-hit/batch scenarios: all four original/shortcut pairs match allocation, checksum and independent calibration.')
