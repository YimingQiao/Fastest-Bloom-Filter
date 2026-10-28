#!/usr/bin/env python3
"""Fresh-seed confirmation of selected asymmetric masks against current baselines."""
import csv,hashlib,io,json,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent/'confirmation';OUT.mkdir(exist_ok=False)
BIN=ROOT/'build/dictionary-free/compare_benchmark'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
files=['experiments/2026-10-29-dictionary-free/masks.hpp','experiments/2026-10-29-dictionary-free/adapters.hpp','include/fast_pattern_BF.h','benchmarks/cpp-external/adapters.hpp','src/compare_benchmark.cpp']
metadata={'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'cpu':3,'purpose':'new-seed confirmation after mask selection','revision':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),'binary_sha256':sha(BIN),'files':{p:sha(ROOT/p)for p in files},'commands':[]}
selection='FastPatternBF,DenseTableScalar,AsymmetricPairsScalar,FastFilterFixed16,FastFilterFixed32'
with(OUT/'results.csv').open('w',newline='')as f:
 writer=None
 for power in [16,20]:
  for batch in [1,3,8,4096]:
   for seed in [820109,1760881,3670013]:
    cmd=['taskset','-c','3',str(BIN),str(power),'8','50','22',str(batch),'5',str(seed),selection,str(1<<power),'22']
    result=subprocess.run(cmd,check=True,capture_output=True,text=True)
    rows=list(csv.DictReader(io.StringIO(result.stdout)));assert len(rows)==5
    reference={r['filter']:r for r in rows}
    for field in ['filter_bytes','result_checksum','false_positives','calibration_false_positives']:
     assert reference['FastPatternBF'][field]==reference['DenseTableScalar'][field]
    if writer is None:writer=csv.DictWriter(f,fieldnames=list(rows[0]));writer.writeheader()
    writer.writerows(rows);f.flush();metadata['commands'].append(cmd)
    (OUT/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    print(f'PASS confirmation n=2^{power} batch={batch} seed={seed}',flush=True)
assert sha(BIN)==metadata['binary_sha256']
assert all(sha(ROOT/p)==h for p,h in metadata['files'].items())
print('PASS: 24 fresh-seed workloads /120rows, independent2^22-negative calibration per run')
