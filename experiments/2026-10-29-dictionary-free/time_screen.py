#!/usr/bin/env python3
"""Training-only timing of candidates that pass1%FPR at16 actual bits/key."""
import csv,hashlib,io,json,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent/'timing-screen';OUT.mkdir(exist_ok=False)
BIN=ROOT/'build/dictionary-free/compare_benchmark'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
metadata={'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'cpu':3,'purpose':'training timing; confirm selected candidates with new seeds','binary_sha256':sha(BIN),'files':{p:sha(ROOT/p)for p in ['experiments/2026-10-29-dictionary-free/masks.hpp','experiments/2026-10-29-dictionary-free/adapters.hpp','src/compare_benchmark.cpp']},'commands':[]}
with(OUT/'results.csv').open('w',newline='')as f:
 writer=None
 for power in [16,20]:
  for batch in [1,3,8,4096]:
   for seed in [195023,1048583,2900017]:
    cmd=['taskset','-c','3',str(BIN),str(power),'8','50','22',str(batch),'3',str(seed),'FastPatternBF,DenseTableScalar,AdjacentPairsScalar,AsymmetricPairsScalar,NonperiodicPair8Scalar,NonperiodicPair4Scalar,TriadOddSingletonScalar,FastFilterFixed16',str(1<<power)]
    result=subprocess.run(cmd,check=True,capture_output=True,text=True)
    rows=list(csv.DictReader(io.StringIO(result.stdout)))
    assert len(rows)==8
    reference={r['filter']:r for r in rows}
    for field in ['filter_bytes','result_checksum','false_positives']:
     assert reference['FastPatternBF'][field]==reference['DenseTableScalar'][field]
    if writer is None:writer=csv.DictWriter(f,fieldnames=list(rows[0]));writer.writeheader()
    writer.writerows(rows);f.flush();metadata['commands'].append(cmd)
    (OUT/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    print(f'PASS timing screen n=2^{power} batch={batch} seed={seed}: dense reference matches native',flush=True)
assert sha(BIN)==metadata['binary_sha256']
print('PASS: 24 training workloads /192 rows')
