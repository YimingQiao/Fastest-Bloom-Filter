#!/usr/bin/env python3
"""Same-process native bulk/single-API/inline controls with unchanged baselines."""
import argparse
import csv
import hashlib
import io
import json
import subprocess
import time
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
EXP = Path(__file__).resolve().parent
sha = lambda f: hashlib.sha256(f.read_bytes()).hexdigest()
p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--mode', choices=['smoke', 'confirmation'], required=True)
p.add_argument('--cpu', type=int, default=2)
p.add_argument('--output', type=Path, required=True)
a = p.parse_args()
protocol = json.loads((EXP/'strong-protocol.json').read_text())
freeze = json.loads((EXP/'strong-freeze.json').read_text())
exe = Path(freeze['binary'])
def verify():
    assert sha(exe)==freeze['binary_sha256']
    for name, value in freeze['source_sha256'].items():
        assert sha(ROOT/name)==value, name
verify()
config=protocol[a.mode].copy()
selected=protocol['registered_filters' if a.mode=='smoke' else 'confirmation_filters']
a.output.mkdir(parents=True,exist_ok=False)
metadata={'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'cpu':a.cpu,'config':config,'freeze_sha256':sha(EXP/'strong-freeze.json'),'protocol_sha256':sha(EXP/'strong-protocol.json'),'commands':[]}
groups=[['ByteSplitBloomFilter','ByteNativeSingleApiV1','ByteInlineLookupV1','ByteShortEntryV2'],['Split64BloomFilter','SplitNativeSingleApiV1','SplitInlineLookupV1','Split64Experimental','SplitShortEntryV2'],['FourSectorBloomFilter','FourSector16K8Experimental'],['BloomsdayPinned','BloomsdaySingleApiV1'],['Fastbloom017','FastbloomSingleApiV1']]
groups=[[name for name in group if name in selected] for group in groups]
groups=[group for group in groups if len(group)>1]
fields=['filter_bytes','actual_bpk','hash_bits','result_checksum','false_positives','absent_queries','calibration_false_positives','calibration_absent_queries']
rows_all=[]
for power in config['key_powers']:
    for bpk in config['requested_bpk']:
        for batch in config['batches']:
            for seed in config['seeds']:
                cmd=['taskset','-c',str(a.cpu),str(exe),str(power),str(bpk),str(config['hit_percent']),str(config['query_power']),str(batch),str(config['repeats']),str(seed),','.join(selected),str(1<<power),str(config['calibration_power'])]
                result=subprocess.run(cmd,capture_output=True,text=True,check=True)
                rows=list(csv.DictReader(io.StringIO(result.stdout)))
                assert len(rows)==len(selected) and {r['filter'] for r in rows}==set(selected),cmd
                by_name={r['filter']:r for r in rows}
                for group in groups:
                    for field in fields:
                        assert len({by_name[name][field] for name in group})==1,(cmd,group,field)
                assert all(int(r['calibration_absent_queries'])==1<<config['calibration_power'] for r in rows)
                (a.output/f'k{power}-p{bpk}-b{batch}-s{seed}.csv').write_text(result.stdout)
                rows_all.extend(rows)
                with (a.output/'results.csv').open('w',newline='') as f:
                    w=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');w.writeheader();w.writerows(rows_all)
                metadata['commands'].append(cmd)
                (a.output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
                print(f'keys2^{power} requested{bpk} batch{batch} seed{seed}: {len(rows)}rows, family outputs/bytes/calibration match',flush=True)
verify()
print(f'PASS: {len(metadata["commands"])} workloads/{len(rows_all)} rows; source and binary unchanged')
