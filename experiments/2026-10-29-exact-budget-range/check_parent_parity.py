#!/usr/bin/env python3
"""Semantics-only comparison to the immutable72 preflight binary."""
import csv,hashlib,io,json,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
old=ROOT/'build/exact-budget-native/benchmark'
freeze=json.loads((HERE/'parent72-record/freeze.json').read_text())
expected=freeze['binary_sha256'][str(old.relative_to(ROOT))]
assert hashlib.sha256(old.read_bytes()).hexdigest()==expected
names=json.loads((HERE/'parent72-record/registry.json').read_text())['filters']
fields=('filter_bytes','actual_bpk','logical_bytes','effective_probes','probe_policy','unit_bytes','unit_count',
        'result_checksum','false_positives','calibration_false_positives','absent_queries','calibration_absent_queries',
        'constructor_argument','native_constructor_bpk','page_level','input_mode')
count=0
for budget in (12,14,16,20,24,28,32):
    args=['10',str(budget),'50','12','31','2','2053',','.join(names),'1024','12','query-only','0']
    results=[]
    for binary in (old,Path(sys.argv[1])):
        result=subprocess.run([str(binary)]+args,text=True,capture_output=True,check=True)
        rows=list(csv.DictReader(io.StringIO(result.stdout)))
        assert len(rows)==72 and {r['filter'] for r in rows}==set(names)
        results.append({r['filter']:r for r in rows})
    for name in names:
        for field in fields:assert results[0][name][field]==results[1][name][field],(budget,name,field)
        count+=1
assert hashlib.sha256(old.read_bytes()).hexdigest()==expected
print(f'PASS: {count} original72 configuration/budget outputs, geometry and calibration match the immutable parent; incidental timings discarded.')
