#!/usr/bin/env python3
"""Read-only immutable native-source proof; no compiler or BF invocation."""
import hashlib
import json
from pathlib import Path
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]

def main():
    pins=json.loads((HERE/'source-pins.json').read_text())
    for name,digest in pins['files_sha256'].items():
        path=ROOT/name
        actual=hashlib.sha256(path.read_bytes()).hexdigest()
        blob=subprocess.check_output(['git','show',pins['commit']+':'+name],cwd=ROOT)
        if actual!=digest or hashlib.sha256(blob).hexdigest()!=digest:raise ValueError('Changed native source '+name)
    print('PASS',len(pins['files_sha256']),'exact frozen native inputs; source-only wrapper proposal')

if __name__=='__main__':main()
