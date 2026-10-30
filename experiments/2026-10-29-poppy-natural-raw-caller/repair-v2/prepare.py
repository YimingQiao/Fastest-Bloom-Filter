"""Freeze only additive source/descriptor bytes; never compile or execute filters."""
import json,hashlib
from pathlib import Path
from bindings import HERE,prepared_inputs,save
save(HERE/'INPUTS.json',prepared_inputs())
files={str(p.relative_to(HERE)):{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size}
       for p in sorted(HERE.rglob('*'))if p.is_file()and '__pycache__'not in p.parts and p.name!='PREPARATION.json'}
save(HERE/'PREPARATION.json',dict(status='Source-only bounded proof; no compiler/BF execution',
    profiles=['normal','asan'],executables=4,focused_test_executions=8,caller_rows=146,parent_control_reproductions=90,
    invalid_cli=12,files=files))
print(json.dumps({'files':len(files),'manifest_sha256':hashlib.sha256((HERE/'PREPARATION.json').read_bytes()).hexdigest()}))
