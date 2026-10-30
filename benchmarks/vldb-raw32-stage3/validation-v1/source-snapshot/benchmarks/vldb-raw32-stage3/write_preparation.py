#!/usr/bin/env python3
"""Inventory this uncompiled preparation; deliberately excludes future evidence."""
import json
from contract import HERE,ROOT,need
from source_guard import sha

def main():
    target=HERE/'PREPARATION.json';need(not target.exists(),'Preserve the previous preparation; do not overwrite')
    files={str(f.relative_to(ROOT)):sha(f) for f in sorted(HERE.rglob('*')) if f.is_file()
           and '__pycache__' not in f.parts and not any(x.startswith('validation-') for x in f.relative_to(HERE).parts)
           and f.name not in ('PREPARATION.json','WORKER_FREEZE.json')}
    target.write_text(json.dumps(dict(scope='Uncompiled paired raw-u32 workers and bounded preflight; no BF data',files=files),indent=2)+'\n')
    print(len(files),sha(target))

if __name__=='__main__':main()
