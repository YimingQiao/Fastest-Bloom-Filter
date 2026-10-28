#!/usr/bin/env python3
"""Verify or restore the exact minimal RocksDB source set from its immutable manifest."""
import argparse
import hashlib
import json
from pathlib import Path
import urllib.request

ROOT = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fetch', action='store_true', help='Download missing or mismatched files from the pinned official commit')
    args = parser.parse_args()
    manifest = json.loads((ROOT / 'manifest.json').read_text())
    total = 0
    for entry in manifest['files']:
        destination = ROOT / 'vendor' / entry['path']
        data = destination.read_bytes() if destination.exists() else b''
        if hashlib.sha256(data).hexdigest() != entry['sha256'] and args.fetch:
            expected = f"https://raw.githubusercontent.com/facebook/rocksdb/{manifest['commit']}/{entry['path']}"
            if entry['url'] != expected:
                raise ValueError('Unexpected upstream source URL')
            with urllib.request.urlopen(expected) as response:
                data = response.read()
            if hashlib.sha256(data).hexdigest() != entry['sha256']:
                raise ValueError(f"Upstream SHA-256 mismatch: {entry['path']}")
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(data)
        if hashlib.sha256(data).hexdigest() != entry['sha256']:
            raise ValueError(f"Missing or changed vendored file: {entry['path']}; rerun with --fetch")
        total += len(data)
    print(f"Verified {len(manifest['files'])} unmodified RocksDB files ({total} bytes), {manifest['release']} @ {manifest['commit']}")


if __name__ == '__main__':
    main()
