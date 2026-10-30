#!/usr/bin/env python3
"""Tiny semantic/CLI checks only, including frozen old public API output parity."""
import argparse,csv,hashlib,io,itertools,json,subprocess
from pathlib import Path
from phase_oracle import validate_row
NAMES=('ByteSplitBloomFilter','ByteTripleHintControl','ByteOnlyInlineV1')
SEMANTICS=('keys','queries','requested_bpk','filter_bytes','actual_bpk','hash_bits','hit_percent','present_queries','batch','repeats','seed','absent_queries','false_positives','result_checksum','input_mode','insert_batch','calibration_absent_queries','calibration_false_positives')
REFERENCE_SHA='0caf0d3ff982ffdc295b6bb7010ae148bd5ffa240426573429e2ae2e92036926'
def main():
    if not __debug__:raise SystemExit('Run without Python -O')
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--binary',type=Path,required=True);p.add_argument('--reference',type=Path,required=True);p.add_argument('--cpu',type=int,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
    assert sha(a.reference)==REFERENCE_SHA,'Frozen old leaf binary changed'
    start=sha(a.binary);records=[]
    for bpk,hit,batch in itertools.product((8,16),(0,50,100),(1,3,31,4096)):
        results=[]
        for binary,names in [(a.binary,NAMES),(a.reference,('ByteSplitBloomFilter','ByteLeafInlineV1'))]:
            cmd=['taskset','-c',str(a.cpu),str(binary.resolve()),'10',str(bpk),str(hit),'12',str(batch),'4','42',','.join(names),'37','12']
            r=subprocess.run(cmd,capture_output=True,text=True,check=True);rows=list(csv.DictReader(io.StringIO(r.stdout)))
            assert len(rows)==len(names) and {x['filter'] for x in rows}==set(names)
            for x in rows:validate_row(x)
            results.append({x['filter']:x for x in rows});records.append(dict(command=cmd,stdout=r.stdout,stderr=r.stderr))
        for name in NAMES:
            ref='ByteSplitBloomFilter' if name==NAMES[0] else 'ByteLeafInlineV1'
            assert all(results[0][name][f]==results[1][ref][f] for f in SEMANTICS),(name,bpk,hit,batch)
    invalid=[('0','4',NAMES[0]),('1','5',NAMES[0]),('1','4','ByteSplit'),('1','4',NAMES[0]+',Missing'),('1','4',NAMES[0]+','),('1','4',NAMES[0]+','+NAMES[0])]
    for batch,reps,names in invalid:
        cmd=[str(a.binary.resolve()),'10','8','50','12',batch,reps,'42',names]
        r=subprocess.run(cmd,capture_output=True,text=True)
        assert r.returncode and not r.stdout and r.stderr.strip()
        records.append(dict(command=cmd,returncode=r.returncode,stdout=r.stdout,stderr=r.stderr))
    assert sha(a.binary)==start and sha(a.reference)==REFERENCE_SHA
    a.output.parent.mkdir(exist_ok=True)
    a.output.write_text(json.dumps(dict(timings_claimed=False,workloads=24,current_rows=72,old_reference_rows=48,invalid_cli_cases=6,binary_sha256=start,reference_sha256=REFERENCE_SHA,records=records),indent=2)+'\n')
    print('PASS:24 workloads/72 current rows,48 old-reference rows,6 invalid CLI cases; no timing claim')
if __name__=='__main__':main()
