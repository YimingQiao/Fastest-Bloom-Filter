#!/usr/bin/env python3
"""Validate exact CLI selection and rejection of wrong timed query outputs."""
import csv
import io
import subprocess
import sys


def invoke(binary, selection=None):
    command = [binary, '10', '8', '50', '12', '4096', '1', '731']
    if selection is not None:
        command.append(selection)
    return subprocess.run(command, text=True, capture_output=True)


def valid(binary, selection=None):
    result = invoke(binary, selection)
    assert result.returncode == 0, (selection, result.stderr)
    rows = list(csv.DictReader(io.StringIO(result.stdout)))
    assert rows
    names = [row['filter'] for row in rows]
    assert len(names) == len(set(names)), names
    return rows


binary = sys.argv[1]
all_rows = valid(binary)
all_names = {row['filter'] for row in all_rows}
first = 'FastPatternBF'
assert first in all_names and len(all_names) >= 2
second = next(name for name in sorted(all_names) if name != first)
assert {row['filter'] for row in valid(binary, '')} == all_names
for selection in (first, second, f'{first},{second}', f'{second},{first}'):
    rows = valid(binary, selection)
    assert {row['filter'] for row in rows} == set(selection.split(','))
    expected = {row['filter']: row for row in all_rows}
    for row in rows:
        for field in ('result_checksum', 'false_positives', 'filter_bytes'):
            assert row[field] == expected[row['filter']][field], (selection, field)

invalid = (
    (f'{first},{first}', 'duplicate filter name'),
    (f'{first},{second},{first}', 'duplicate filter name'),
    (f',{first}', 'empty filter name'),
    (f'{first},', 'empty filter name'),
    (f'{first},,{second}', 'empty filter name'),
    (',', 'empty filter name'),
    ('FastPatternBloomFilter', 'unknown filter name'),
    (f'{first},FastPatternBloomFilter', 'unknown filter name'),
    (f'FastPatternBloomFilter,{first}', 'unknown filter name'),
    (f' {first}', 'unknown filter name'),
)
for selection, message in invalid:
    result = invoke(binary, selection)
    assert result.returncode != 0, selection
    assert message in result.stderr, (selection, result.stderr)
    # Rejection precedes every timing job and even the CSV header.
    assert result.stdout == '', (selection, result.stdout)

if len(sys.argv) > 2:
    for fixture, phase in (
        ('FaultOnPrehashedFixture', 'timed prehashed lookup'),
        ('FaultOnHashLookupFixture', 'timed hash+lookup'),
    ):
        result = invoke(sys.argv[2], fixture)
        assert result.returncode != 0
        assert f'query output mismatch in {phase}' in result.stderr, result.stderr
        assert list(csv.DictReader(io.StringIO(result.stdout))) == []

print('Exact/all filter selection, early rejection of malformed/partial suites, and timed-output checks passed.')
