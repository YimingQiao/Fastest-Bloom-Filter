#!/usr/bin/env python3
"""Pin reviewed source and a preflight-built executable; never run during source prep."""
import argparse,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
REPO=HERE.parent.parent
FROZEN=HERE/'validation/freeze.json'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def verify(frozen,dependencies=True):
    for name,want in frozen['source_sha256'].items():
        if sha(REPO/name)!=want:raise ValueError('Changed source: '+name)
    for b in frozen['binaries']:
        if sha(Path(b['path']))!=b['sha256']:raise ValueError('Changed binary: '+b['path'])
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--verify',action='store_true');a=p.parse_args()
    if a.verify:
        verify(json.loads(FROZEN.read_text()));print('Frozen sources and executable unchanged');return
    protocol=json.loads((HERE/'protocol.json').read_text())
    binary=Path(protocol['binary'])
    if protocol['binary_sha256'] is None:raise ValueError('Source-only protocol: complete preflight and pin executable first')
    if sha(binary)!=protocol['binary_sha256']:raise ValueError('Unreviewed executable')
    paths=[p for p in HERE.rglob('*') if p.is_file() and not any(x in p.parts for x in ['target','__pycache__','screen']) and p!=FROZEN and p.name!='manifest.json']
    value=dict(source_parent_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip(),source_sha256={str(p.relative_to(REPO)):sha(p) for p in sorted(paths)},binaries=[dict(path=str(binary),sha256=sha(binary))],external_dependencies=[],production_changed=False,performance_run=False)
    verify(value);FROZEN.write_text(json.dumps(value,indent=2)+'\n')
if __name__=='__main__':main()
