#!/usr/bin/env python3
"""Seal only this reviewed finite source preparation; never builds/runs a BF."""
import ast,hashlib,json
from pathlib import Path
from derive_plan import derive
from screen_contract import plan
HERE=Path(__file__).resolve().parent
assert not(HERE/'PREPARATION.json').exists(),'Preserve prior source seal'
outputs,inputs=derive()
for name,value in outputs.items():assert json.loads((HERE/name).read_text())==value
assert json.loads((HERE/'DERIVATION.json').read_text())==dict(inputs=inputs,old_timing_fields_imported=False)
assert plan()==json.loads((HERE/'planned-grid.json').read_text())
files=sorted(p for p in HERE.iterdir()if p.is_file()and p.name!='PREPARATION.json')
for p in files:
 if p.suffix=='.py':ast.parse(p.read_text())
value=dict(scope='Source-only fixed160 performance preparation; no compiler/filter/timing execution',
           files={p.name:hashlib.sha256(p.read_bytes()).hexdigest()for p in files},
           proof_commit='7b260fe8830ac93d73eb81bd42a32257e04fa72e',
           binary_sha256='6da743aa2f31c3cbd7b713d748819b684f247408f7bcb55de3c0f334a039d7eb')
(HERE/'PREPARATION.json').write_text(json.dumps(value,indent=2)+'\n')
print(len(files),hashlib.sha256((HERE/'PREPARATION.json').read_bytes()).hexdigest())
