#!/usr/bin/env python3
"""Source-only ledger derivation from the adjacent caller's fixed selection."""
import json
import argparse
from pathlib import Path
from summarize import build_ledger, validate_sources
from source_guard import get_sources

HERE = Path(__file__).resolve().parent
CALLER = HERE.parent / '2026-10-30-independent32-range/caller'

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    selection, existing, _ = get_sources()
    ledger = build_ledger(selection['points'])
    validate_sources(selection, ledger)
    if args.write:
        (HERE / 'ledger.json').write_text(json.dumps(ledger, indent=2) + '\n')
    else:
        assert ledger == existing
    print('24 cases / 216 rows; exact second-round process and API reversal')
