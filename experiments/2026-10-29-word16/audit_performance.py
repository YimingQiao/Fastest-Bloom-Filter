#!/usr/bin/env python3
"""Check all training rows and cross-batch semantic identity without timing selection."""
import csv
import hashlib
import json
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
protocol=json.loads((HERE/'performance-protocol.json').read_text())
freeze=json.loads((HERE/'freeze.json').read_text())
launch=json.loads((HERE/'performance-freeze.json').read_text())
for name,digest in {**freeze['source_sha256'],**freeze['binaries'],**launch['runner_inputs_sha256']}.items():
    assert sha(ROOT/name)==digest,name
rows=list(csv.DictReader((HERE/'performance-training/results.csv').open()))
assert len(rows)==108
by_filter={}
for row in rows:
    key=tuple(row[k] for k in ('filter','keys','requested_bpk','seed'))
    by_filter.setdefault(key,[]).append(row)
fields=('filter_bytes','actual_bpk','present_queries','absent_queries','false_positives','result_checksum','calibration_absent_queries','calibration_false_positives')
assert len(by_filter)==36
for key,group in by_filter.items():
    assert len(group)==3 and {int(r['batch']) for r in group}=={1,31,4096},key
    for field in fields:
        assert len({r[field] for r in group})==1,(key,field)
result=dict(all_108_rows_present=True,groups_checked=36,batches=[1,31,4096],
            cross_batch_fields_equal=list(fields),all_frozen_inputs_and_binaries_unchanged=True,
            result_sha256=sha(HERE/'performance-training/results.csv'),
            analysis_script_sha256=sha(Path(__file__)),
            scope='Additional cross-batch checksum/FP/bytes/calibration identity; timed full-vector checks are performed by the frozen shared harness.')
(HERE/'performance-training/semantic-audit.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS all 36 filter/size/allocation groups have identical outputs and quality counts across batches1/31/4096')
