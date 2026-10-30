#!/usr/bin/env python3
"""Small source-identity check; never compiles or runs a filter."""
import difflib
import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def body(text, start):
    assert text.count(start) == 1, start
    begin = text.index('{', text.index(start))
    depth = 0
    for end in range(begin, len(text)):
        depth += text[end] == '{'
        depth -= text[end] == '}'
        if not depth:
            return text[begin:end + 1]
    raise AssertionError('unterminated body')


def main():
    assert __debug__
    info = json.loads((HERE / 'source-provenance.json').read_text())
    for item in info['inputs']:
        committed = subprocess.check_output(['git', 'show', item['commit'] + ':' + item['path']], cwd=ROOT)
        assert committed == (HERE / item['copy']).read_bytes()
        assert hashlib.sha256(committed).hexdigest() == item['sha256']
    old = (HERE / 'control.hpp').read_text()
    new = (HERE / 'candidate.hpp').read_text()
    assert (HERE / 'CHANGE.patch').read_text() == ''.join(difflib.unified_diff(
        old.splitlines(True), new.splitlines(True), fromfile='control.hpp', tofile='candidate.hpp'))
    for start in ['static __m256i Mask(', 'void InsertOne(', 'uint32_t LookupOne(',
                  'bool ContainsHash(', 'void Insert(', 'uint32_t Lookup(']:
        assert body(old, start) == body(new, start), start
    assert '#include "split64_range_size.h"' in new
    assert '((hash >> 40) * uint64_t(bucket_count_)) >> 24' in new
    assert 'if (SizeInBytes() > budget.bytes)' in new
    print('PASS: four committed source copies, exact delta, six unchanged query/insert bodies')


if __name__ == '__main__':
    main()
