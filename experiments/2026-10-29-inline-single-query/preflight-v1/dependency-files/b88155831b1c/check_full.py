#!/usr/bin/env python3
"""Validate the complete frozen registration with small T=1/3 workloads."""
import csv
import io
from pathlib import Path
import re
import subprocess
import sys

here=Path(__file__).resolve().parent
binary=str(Path(sys.argv[1]).resolve())
expected={'FastPatternBF','FourSectorBloomFilter','Split64BloomFilter','ByteSplitBloomFilter'}
for family in ('cpp-external','boost-external','rocksdb-external'):
    text=(here/'snapshot/benchmarks'/family/'adapters.hpp').read_text()
    expected.update(re.findall(r'ADD\((\w+), uint64_t\)',text))
assert len(expected)==56,len(expected)
results={}
for workers,mask in ((1,'3'),(3,'3,5,7')):
    cmd=['numactl',f'--physcpubind={mask}','--membind=1',binary,'12','8','50','12','31','1','731','','4096','12',str(workers),mask]
    rows=list(csv.DictReader(io.StringIO(subprocess.check_output(cmd,text=True))))
    assert len(rows)==56 and {r['filter'] for r in rows}==expected
    results[workers]={r['filter']:r for r in rows}
for name,left in results[1].items():
    right=results[3][name]
    for field in ('filter_bytes','result_checksum','false_positives','absent_queries','calibration_absent_queries','calibration_false_positives'):
        assert left[field]==right[field],(name,field)
print('Full 56-config registration and T=1/3 exact output/FPR/calibration parity passed (112 correctness-only rows).')
