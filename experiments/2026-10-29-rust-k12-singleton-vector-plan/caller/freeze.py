#!/usr/bin/env python3
"""Seal authored/derived preparation before any compiler or filter execution."""
import hashlib
import json
from pathlib import Path
HERE=Path(__file__).resolve().parent
paths=sorted(p for p in HERE.rglob('*') if p.is_file() and '__pycache__'not in p.parts
             and not any(part.startswith('validation-')for part in p.parts)
             and p.name!='PREPARATION.json')
assert not(HERE/'validation-v1').exists()
value=dict(status='source-only; no compiler/BF/performance',proposal_commit='5ac4b63414d94f63b7f61304c09b7eb8d0459f0e',
           files={p.relative_to(HERE).as_posix():hashlib.sha256(p.read_bytes()).hexdigest()for p in paths})
(HERE/'PREPARATION.json').write_text(json.dumps(value,indent=2)+'\n')
print(len(paths))
