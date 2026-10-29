#!/usr/bin/env python3
"""Source-only checks; never invoke a compiler or Bloom executable."""
import hashlib
import json
import subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]

def main():
    if not __debug__:raise RuntimeError('Python -O is forbidden')
    pins=json.loads((HERE/'copy-source.json').read_text())['files']
    for relative,record in pins.items():
        data=(HERE/relative).read_bytes()
        if hashlib.sha256(data).hexdigest()!=record['sha256']:raise ValueError('Changed native snapshot '+relative)
        original=subprocess.check_output(['git','show',record['commit']+':'+record['source']],cwd=ROOT)
        if data!=original:raise ValueError('Snapshot differs from immutable source '+relative)
    protocol=json.loads((HERE/'protocol.json').read_text())
    if protocol['threads']!=[1,4,8] or protocol['repeats']!=4 or protocol['key_powers']!=[16,25]:raise ValueError('Changed minimal protocol')
    if len(protocol['cases'])!=18 or sum(len(c['filters'])for c in protocol['cases'])!=30:raise ValueError('Wrong per-language selection')
    for case in protocol['cases']:
        expected=['Split64Range'] if case['budget_bpk']==24 else ['Split64','Split64Range']
        if case['filters']!=expected or case['cpus']!=protocol['socket_cpus'][:case['threads']]:raise ValueError('Changed exact geometry/core selection')
    cpp=(HERE/'cpp/main.cpp').read_text();rust=(HERE/'rust/src/main.rs').read_text()
    for source in (cpp,rust):
        for required in ('serial_insert','parallel_insert','serial_allocate_insert','parallel_allocate_insert','serial_lookup','parallel_lookup',
                         'build_williams4_query_alternating','insert_cpu3_allocate_allowed_set'):
            if required not in source:raise ValueError('Missing boundary or contract '+required)
    if 'bf.InsertParallel' not in cpp or 'bf.LookupParallel' not in cpp:raise ValueError('Missing public C++ parallel APIs')
    if 'self.insert_hashes_parallel' not in rust or 'self.lookup_hashes_parallel' not in rust:raise ValueError('Missing public Rust parallel APIs')
    print(f'PASS source only: {len(pins)} exact immutable snapshots; 30 rows/language; unchanged public native kernels and partition helpers')

if __name__=='__main__':main()
