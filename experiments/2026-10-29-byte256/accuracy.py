#!/usr/bin/env python3
"""Frozen-source calibration screen. Incidental harness timings are not claims."""
import argparse
import csv
import hashlib
import io
import json
import math
import subprocess
import time
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
EXP = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--mode', choices=['initial', 'confirmation'], required=True)
parser.add_argument('--cpu', type=int, default=2)
parser.add_argument('--output', type=Path, required=True)
args = parser.parse_args()
protocol = json.loads((EXP / 'protocol.json').read_text())
freeze = json.loads((EXP / 'freeze.json').read_text())
exe = ROOT / freeze['binary']
def verify():
    assert sha(exe) == freeze['binary_sha256']
    for name, value in freeze['source_sha256'].items():
        assert sha(ROOT / name) == value, name
verify()
args.output.mkdir(parents=True, exist_ok=False)
metadata = {'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'cpu':args.cpu,'mode':args.mode,'freeze_sha256':sha(EXP/'freeze.json'),'protocol_sha256':sha(EXP/'protocol.json'),'commands':[],'timing_scope':'Accuracy-only; all incidental timed columns are retained but unclaimed.'}
all_rows = []
for power in protocol['key_powers']:
    for bpk in protocol['requested_bpk']:
        for seed in protocol[args.mode+'_seeds']:
            cmd = ['taskset','-c',str(args.cpu),str(exe),str(power),str(bpk),'50','12','4096','1',str(seed),'',str(1<<power),'24']
            result = subprocess.run(cmd,capture_output=True,text=True,check=True)
            rows = list(csv.DictReader(io.StringIO(result.stdout)))
            assert len(rows)==len(protocol['filters']) and {r['filter'] for r in rows}==set(protocol['filters']),cmd
            assert all(int(r['calibration_absent_queries'])==1<<24 for r in rows)
            assert all(int(r['filter_bytes']) <= (1<<power)*bpk//4 for r in rows)
            candidate = next(r for r in rows if r['filter']=='ByteSplit256Experiment')
            assert float(candidate['actual_bpk'])==2*bpk
            (args.output/f'k{power}-p{bpk}-s{seed}.csv').write_text(result.stdout)
            all_rows.extend(rows)
            with (args.output/'results.csv').open('w',newline='') as f:
                w=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');w.writeheader();w.writerows(all_rows)
            metadata['commands'].append(cmd)
            (args.output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
            x=int(candidate['calibration_false_positives']); n=1<<24; z=1.6448536269514722;p=x/n
            upper=(p+z*z/(2*n)+z*math.sqrt(p*(1-p)/n+z*z/(4*n*n)))/(1+z*z/n)
            print(f'keys2^{power} actual{2*bpk} seed{seed}: FP={x}/{n}, FPR={p:.8%}, one-sided95upper={upper:.8%}, strict0.01eligible={upper<=0.0001}',flush=True)
verify()
print(f'PASS: {len(metadata["commands"])} workloads/{len(all_rows)} rows; source and binary unchanged; timings not claimed')
