#!/usr/bin/env python3
"""Read-only observation of producer metadata; never alter the active source/run."""
import hashlib
import json
from pathlib import Path
import time

HERE=Path(__file__).resolve().parent
SOURCE=HERE.parents[1]/'2026-10-29-rust-fastbloom-fixed-probes-screen/screen/metadata.json'
seen=set()
while True:
    raw=SOURCE.read_bytes()
    try:meta=json.loads(raw)
    except json.JSONDecodeError:
        time.sleep(.5);continue
    cases=meta['cases']
    if isinstance(cases,list):
        complete=sum(case.get('complete',False)for case in cases)
        key=(len(cases),complete)
        if key not in seen:
            name=f'ledger-cases{len(cases):02d}-complete{complete:02d}.json'
            target=HERE/name
            if not target.exists():target.write_bytes(raw)
            elif target.read_bytes()!=raw:raise RuntimeError('Preserve previous observer checkpoint')
            seen.add(key)
            print(name,hashlib.sha256(raw).hexdigest(),flush=True)
        if len(cases)==complete==18:
            print('Captured exact complete18 producer ledger before final summary overwrite; no producer changes',flush=True)
            break
    elif meta.get('complete'):
        print('Producer finalized before next observation; inspect preserved checkpoints',flush=True)
        break
    time.sleep(.5)
