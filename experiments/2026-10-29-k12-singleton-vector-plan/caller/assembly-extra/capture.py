#!/usr/bin/env python3
"""Add actual public callees to a passed proof; no compiler or BF invocation."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys

HERE=Path(__file__).resolve().parent
CALLER=HERE.parent
sys.path.insert(0,str(CALLER))
from contract import need
from lease import require

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def main():
    placement=require();target=HERE/'results'
    need(not target.exists() and not target.is_symlink(),'fresh capture directory required')
    original=CALLER/'validation-v1/metadata.json';original_hash=sha(original)
    metadata=json.loads(original.read_text());need(metadata['complete'] and metadata['manual_review_pending'],'functional proof state')
    for path,expected in metadata['all_binary_sha256'].items():need(sha(path)==expected,'binary changed')
    for path,expected in metadata['tools_sha256'].items():need(sha(path)==expected,'tool changed')
    target.mkdir();captures=[]
    nm_records={profile:CALLER/record['stdout']for profile in ('normal','minimal-f')
        for record in json.loads((CALLER/'validation-v1/commands.json').read_text())if record['label']==profile+'-nm'}
    for profile,path in nm_records.items():
        binary=Path(metadata['assembly'][profile]['binary'])
        for text in path.read_text().splitlines():
            fields=text.split()
            if len(fields)!=4:continue
            name,kind,address,size=fields
            if not name.startswith('_ZNK13bloom_filters') or 'FourSectorRange12'not in name:continue
            if not any(marker in name for marker in ('6LookupEj','12LookupScalarEj','12LookupVectorI')):continue
            start,count=int(address,16),int(size,16)
            need(count>0,'empty callee')
            out=target/f'{len(captures):02d}-{profile}.stdout';err=out.with_suffix('.stderr')
            command=[shutil.which('objdump'),'-d','--no-show-raw-insn',f'--start-address={start}',f'--stop-address={start+count}',str(binary)]
            with out.open('wb')as stdout,err.open('wb')as stderr:
                completed=subprocess.run(command,stdout=stdout,stderr=stderr)
            need(completed.returncode==0 and not err.read_bytes(),'callee capture failed')
            pcs=[int(match.group(1),16)for match in re.finditer(r'^\s*([0-9a-f]+):\s+\S',out.read_text(),re.M)]
            need(pcs and pcs[0]==start and all(start<=p<start+count for p in pcs),'invalid callee instruction span')
            captures.append(dict(profile=profile,binary=str(binary),binary_sha256=sha(binary),raw_symbol=name,
                start=start,size=count,instructions=len(pcs),command=command,exit_code=completed.returncode,
                stdout=str(out.relative_to(CALLER)),stderr=str(err.relative_to(CALLER)),stdout_sha256=sha(out),stderr_sha256=sha(err)))
    need(len(captures)==16,'expected two public/scalar/vector-pair closures per mode')
    for path,expected in metadata['all_binary_sha256'].items():need(sha(path)==expected,'binary changed during capture')
    for path,expected in metadata['tools_sha256'].items():need(sha(path)==expected,'tool changed during capture')
    need(sha(original)==original_hash and require()==placement,'proof or lease changed')
    result=dict(complete=True,operation='read-only ELF disassembly; no compiler/BF',original_metadata_sha256=original_hash,
                placement=placement,captures=captures,manual_review_pending=True)
    (target/'CAPTURE.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Captured16 actual public/scalar/vector callees without rebuild or BF.')

if __name__=='__main__':main()
