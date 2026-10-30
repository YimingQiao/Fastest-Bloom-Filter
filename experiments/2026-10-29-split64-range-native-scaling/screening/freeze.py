#!/usr/bin/env python3
"""Seal additive driver and unchanged completed preflight before any timing."""
import sys
if not __debug__:raise SystemExit('Python -O is forbidden before any execution')
import json
from contract import cases,need
from source_guard import HERE,ROOT,STAGE,PREFLIGHT_COMMIT,committed,sha

def main():
    need(not(HERE/'freeze.json').exists(),'Never overwrite a frozen driver')
    compiled=json.loads((STAGE/'COMPILED_FREEZE.json').read_text());archive=json.loads((STAGE/'PREFLIGHT_ARCHIVE.json').read_text())
    for rel,value in archive['files'].items():
        path=STAGE/rel;need(sha(path)==value['sha256'],'Changed completed preflight artifact');committed(PREFLIGHT_COMMIT,path,value['sha256'])
    committed(PREFLIGHT_COMMIT,STAGE/'PREFLIGHT_ARCHIVE.json',sha(STAGE/'PREFLIGHT_ARCHIVE.json'))
    cases(json.loads((HERE/'protocol.json').read_text()))
    files={str(path.relative_to(ROOT)):sha(path)for path in sorted(STAGE.rglob('*'))if path.is_file()and not({'__pycache__','target','screen'}&set(path.relative_to(STAGE).parts))and path.suffix!='.pyc'and path.name!='freeze.json'}
    data=dict(scope='Frozen native public-API scaling driver; performance awaits reviewed commit and explicit lease',preflight_commit=PREFLIGHT_COMMIT,
      selected_normal_executables=compiled['selected_normal_executables'],local_files_sha256=files)
    (HERE/'freeze.json').write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(dict(local_artifacts=len(files),freeze_sha256=sha(HERE/'freeze.json')),sort_keys=True))

if __name__=='__main__':main()
