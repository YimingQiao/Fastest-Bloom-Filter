#!/usr/bin/env python3
"""Check identical native Rust/C++ answers through all parallel construction modes."""
import csv
import io
import subprocess

for threads in [1,3,8]:
    for bpk in [4,16]:
        for hit in [0,50,100]:
            params=['16',str(bpk),'16',str(threads),'1','42',str(hit)]
            def run(exe):
                result=subprocess.run([exe]+params,text=True,capture_output=True,check=True)
                return list(csv.DictReader(io.StringIO(result.stdout)))
            rows=run('build/native/parallel_benchmark')+run('rust/target/release/parallel_benchmark')
            for field in ['result_checksum','false_positives','absent_queries','filter_bytes']:
                assert len({r[field] for r in rows})==1,(params,field,rows)
print('All three modes agree within and across C++/Rust for 18 parallel workloads.')
