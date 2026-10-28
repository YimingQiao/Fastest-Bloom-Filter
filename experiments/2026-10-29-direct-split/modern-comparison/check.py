#!/usr/bin/env python3
"""Same-input contracts for the frozen modern comparison, before timing."""
import csv
import io
import hashlib
import json
from pathlib import Path
import subprocess
import sys
from run import FILTERS

here = Path(__file__).resolve().parent
snapshot = json.loads((here/'snapshot.json').read_text())
for file, item in snapshot['files'].items():
    assert hashlib.sha256((here/file).read_bytes()).hexdigest() == item['sha256'], file
binary = str(Path(sys.argv[1]).resolve())
cases = 0
for requested in (8, 16):
    for hit in (0, 50, 100):
        for batch in (1, 31, 4096):
            cmd = ['taskset','-c','3',binary,'10',str(requested),str(hit),'12',str(batch),'1','731',FILTERS,'31','12']
            rows = {r['filter']:r for r in csv.DictReader(io.StringIO(subprocess.check_output(cmd,text=True)))}
            assert len(rows) == len(FILTERS.split(',')) == 18
            assert len({r['filter_bytes'] for r in rows.values()}) == 1
            pairs = [('FastFilterFixed16','FastFilterFixed16SingleControl'),
                     ('FastFilterSimdBlock','FastFilterSimdBlockSingleControl'),
                     ('RocksDBFastLocalBloom64','RocksDBFastLocalBloom64Batch32')]
            pairs += [(f'RocksDBFastLocalBloom64K{k}',f'RocksDBFastLocalBloom64K{k}Batch32') for k in (8,9,14)]
            pairs += [('RocksDBFastLocalBloom64',f'RocksDBFastLocalBloom64K{9 if requested == 8 else 14}')]
            for a,b in pairs:
                for field in ['filter_bytes','result_checksum','false_positives','calibration_absent_queries','calibration_false_positives']:
                    assert rows[a][field] == rows[b][field], (requested,hit,batch,a,b,field)
            cases += 1
print(f'{cases} same-input cases, all 18 rows, exact expected baseline/control/calibration equivalences passed.')
