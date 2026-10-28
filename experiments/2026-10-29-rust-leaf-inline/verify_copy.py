#!/usr/bin/env python3
"""Reject native changes beyond the three explicitly requested inlining hints."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    provenance = json.loads((HERE / 'copy-source.json').read_text())
    changes = {item['file']: item for item in provenance['changes']}
    original_files = provenance['original_native_sha256']
    copied_files = {str(p.relative_to(HERE/'native')) for p in (HERE/'native').rglob('*')
                    if p.is_file() and 'target' not in p.parts}
    assert copied_files == set(original_files), 'Copied native file set changed'
    changed_sources = []
    for name, expected in original_files.items():
        original = REPO/'rust'/name
        assert sha(original) == expected, 'Original native changed: '+name
        content = original.read_text()
        if name in changes:
            change = changes[name]
            assert content.count(change['old']) == 1
            content = content.replace(change['old'], change['new'], 1)
            changed_sources.append(name)
        elif name == 'Cargo.toml':
            content = content.replace('name = "fastest-bloom-filter"', 'name = "fastest-bloom-filter-leaf-inline"', 1)
            content = content.replace('name = "fastest_bloom_filter"', 'name = "fastest_bloom_filter_leaf_inline"', 1)
            content = content.replace('edition = "2021"', 'edition = "2021"\nautobins = false\npublish = false', 1)
        elif name == 'Cargo.lock':
            content = content.replace('name = "fastest-bloom-filter"', 'name = "fastest-bloom-filter-leaf-inline"')
        assert (HERE/'native'/name).read_text() == content, 'Unapproved cloned-native change: '+name
    assert len(changed_sources) == 3
    print('PASS: all native files preserved; exactly three inline->inline(always) source hints, plus declared crate metadata')


if __name__ == '__main__':
    main()
