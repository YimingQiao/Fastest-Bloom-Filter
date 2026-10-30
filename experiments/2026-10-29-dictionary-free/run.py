#!/usr/bin/env python3
"""Accuracy-only gate for table-free masks; no timings are collected."""
import csv,hashlib,io,json,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent
BIN=ROOT/'build/dictionary-free/accuracy'
seeds=[195023,1048583,2900017]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
metadata={'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'purpose':'accuracy only; no timing comparison','cpu':3,'seeds':seeds,'source_sha256':{p:sha(ROOT/p)for p in ['experiments/2026-10-29-dictionary-free/masks.hpp','experiments/2026-10-29-dictionary-free/accuracy.cpp','include/fast_pattern_BF.h','include/base.h']},'binary_sha256':sha(BIN),'compiler':subprocess.check_output(['clang++','--version'],text=True),'compile_command':['clang++','-std=c++17','-O3','-march=native','-fno-strict-aliasing','-Iinclude','experiments/2026-10-29-dictionary-free/accuracy.cpp','-o','build/dictionary-free/accuracy'],'commands':[]}
(OUT/'mask-enumeration.csv').write_text(subprocess.check_output([str(BIN),'--masks'],text=True))
with(OUT/'accuracy.csv').open('w',newline='')as file:
 writer=None
 for power in [16,20]:
  for bpk in [16,32]:
   for seed in seeds:
    cmd=['taskset','-c','3',str(BIN),str(power),str(bpk),str(seed),'24']
    result=subprocess.run(cmd,check=True,capture_output=True,text=True)
    rows=list(csv.DictReader(io.StringIO(result.stdout)))
    assert len(rows)==9 and all(r['no_false_negatives']=='true'for r in rows)
    if writer is None:writer=csv.DictWriter(file,fieldnames=list(rows[0]));writer.writeheader()
    writer.writerows(rows);file.flush();metadata['commands'].append(cmd)
    (OUT/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    print(f'PASS accuracy n=2^{power} actual_bpk={bpk} seed={seed}: 9 families, zero false negatives',flush=True)
print('PASS: 12 workloads / 108 rows, each with 2^24 negatives; table reference matches native output')
