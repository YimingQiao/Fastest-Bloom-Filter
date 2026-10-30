#!/usr/bin/env python3
"""Materialize the fixed source-defined ledger; never import a caller or read timing."""
import argparse
import hashlib
import json
from pathlib import Path
from summarize import build_ledger, validate_sources

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--selection', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    raw = args.selection.read_bytes()
    selection = json.loads(raw)
    ledger = build_ledger(selection['points'])
    validate_sources(selection, ledger)
    assert sum(len(c['point_ids']) for c in ledger) == 192
    assert not args.output.exists() and not args.output.is_symlink(), 'preserve existing ledger'
    args.output.write_text(json.dumps(ledger, indent=2) + '\n')
    print(json.dumps(dict(processes=24,rows=192,selection_sha256=hashlib.sha256(raw).hexdigest(),
        ledger_sha256=hashlib.sha256(args.output.read_bytes()).hexdigest()),sort_keys=True))

