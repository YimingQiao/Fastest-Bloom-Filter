#!/usr/bin/env python3
"""One-time inventory of source-only preparation; never rebuild or benchmark."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = ROOT/'experiments/2026-10-29-exact-budget-range'


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if (HERE/'freeze.json').exists() or (HERE/'manifest.json').exists():
        raise RuntimeError('Archive already frozen; do not overwrite it')
    protocol = json.loads((HERE/'protocol.json').read_text())
    parent = json.loads((PARENT/'freeze.json').read_text())
    sources = sorted(p for p in HERE.iterdir() if p.is_file())
    freeze = {'scope':'Source-only confirmation preparation; no new binaries or measured observations',
              'parent_source_commit':protocol['parent_source_commit'],
              'parent_freeze_sha256':digest(PARENT/'freeze.json'),'parent_manifest_sha256':digest(PARENT/'manifest.json'),
              'binary':protocol['binary'],'binary_sha256':parent['binary_sha256'][protocol['binary']],
              'source_sha256':{p.relative_to(ROOT).as_posix():digest(p) for p in sources}}
    (HERE/'freeze.json').write_text(json.dumps(freeze,indent=2)+'\n')
    files = sorted(p for p in HERE.iterdir() if p.is_file())
    (HERE/'manifest.json').write_text(json.dumps({'scope':freeze['scope'],'files_sha256':{p.name:digest(p) for p in files}},indent=2)+'\n')
    print(f'Inventoried {len(files)} artifacts plus manifest; parent binary hash copied from original freeze, binary not executed')


if __name__=='__main__':
    main()
