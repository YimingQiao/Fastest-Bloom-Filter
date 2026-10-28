#!/usr/bin/env python3
"""ByteSplit native C++/Rust and Rust external harness parity; timings are not evidence."""
import argparse,csv,hashlib,io,json,subprocess
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--cpu',type=int,default=3)
p.add_argument('--cpp',type=Path,default=Path('build/byte-split-native/compare_benchmark'))
p.add_argument('--rust',type=Path,default=Path('/tmp/fastest-bf-rust-byte-native/release/compare_benchmark'))
p.add_argument('--external',type=Path,default=Path('/tmp/fastest-bf-rust-byte-external/release/compare_benchmark'))
p.add_argument('--output',type=Path,required=True)
a=p.parse_args()
cases=[(5,8,50,b) for b in [1,3,7,16,31,4096]]
cases += [(12,bpk,hit,batch) for bpk in [4,8,16] for hit in [0,100] for batch in [1,31]]
cases += [(16,bpk,50,batch) for bpk in [8,16] for batch in [1,17,4096]]
cases += [(20,8,50,31)]
fields=['keys','queries','filter_bytes','actual_bpk','result_checksum','false_positives','absent_queries','present_queries','calibration_false_positives','calibration_absent_queries','insert_batch']
records=[]
for index,(kp,bpk,hit,batch) in enumerate(cases):
 rows=[]
 for exe in [a.cpp,a.rust,a.external]:
  cmd=['taskset','-c',str(a.cpu),str(exe),str(kp),str(bpk),str(hit),'12' if kp<=12 else '16',str(batch),'1',str(701+index),'ByteSplitBloomFilter','17' if kp<=12 else '127','12' if kp<=12 else '16']
  r=subprocess.run(cmd,capture_output=True,text=True,check=True)
  rr=list(csv.DictReader(io.StringIO(r.stdout)))
  assert len(rr)==1 and rr[0]['filter']=='ByteSplitBloomFilter',(cmd,rr)
  rows.extend(rr)
  records.append({'command':cmd,'row':rr[0]})
 for field in fields:assert len({r[field] for r in rows})==1,(index,field,rows)
a.output.write_text(json.dumps({'cases':len(cases),'rows':len(records),'checked_fields':fields,'records':records,'binary_sha256':{str(f):hashlib.sha256(f.read_bytes()).hexdigest() for f in [a.cpp,a.rust,a.external]}},indent=2)+'\n')
print(f'PASS: {len(cases)} workloads / {len(records)} rows, all three binaries exactly agree')
