#!/usr/bin/env python3
"""Freeze successful preflight inputs and binaries before any accuracy data."""
import argparse,hashlib,json,subprocess
from pathlib import Path
from verify_source import verify as verify_source
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
FROZEN=HERE/'FREEZE.json'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def verify(record):
    for name,want in record['source_sha256'].items():
        if sha(ROOT/name)!=want:raise ValueError('Source drift: '+name)
    for name,want in record['binary_sha256'].items():
        if sha(Path(name))!=want:raise ValueError('Binary drift: '+name)
def main():
    if not __debug__:raise ValueError('Run without Python -O')
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--cpu',type=int,choices=(2,3));ap.add_argument('--verify',action='store_true');a=ap.parse_args()
    if a.verify:verify(json.loads(FROZEN.read_text()));print('Frozen sources/binaries verified');return
    if a.cpu is None:raise ValueError('Specify the final accuracy CPU before source freeze')
    verify_source();summary=json.loads((HERE/'validation/summary.json').read_text());assert summary['complete']
    for name,want in summary['inputs_sha256'].items():
        if sha(ROOT/name)!=want:raise ValueError('Compiled input drift: '+name)
    protocol=json.loads((HERE/'protocol.json').read_text());protocol.update(status='Correctness passed; accuracy remains unrun until committed source and explicit lease',cpu=a.cpu,socket_lock=f'/tmp/fastest-bf-socket{a.cpu-2}.lock')
    (HERE/'protocol.json').write_text(json.dumps(protocol,indent=2)+'\n')
    paths=[p for p in HERE.rglob('*') if p.is_file() and not any(x in p.parts for x in ['__pycache__','accuracy']) and p not in (FROZEN,HERE/'manifest.json')]
    record=dict(scope='Correctness complete; fixed accuracy pilot not run',source_parent_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),source_sha256={str(p.relative_to(ROOT)):sha(p) for p in sorted(paths)},binary_sha256=summary['binary_sha256'],accuracy_executable='/tmp/fastest-bf-multiply-code-split64/native/calibrate',cpu=a.cpu,performance_run=False)
    verify(record);FROZEN.write_text(json.dumps(record,indent=2)+'\n')
    files={str(p.relative_to(HERE)):sha(p) for p in sorted(HERE.rglob('*')) if p.is_file() and not any(x in p.parts for x in ['__pycache__','accuracy']) and p!=HERE/'manifest.json'}
    (HERE/'manifest.json').write_text(json.dumps(dict(scope='Pre-accuracy immutable source and correctness evidence',files=files),indent=2)+'\n')
    print('Frozen',len(record['source_sha256']),'inputs and',len(record['binary_sha256']),'binaries; no accuracy run')
if __name__=='__main__':main()
