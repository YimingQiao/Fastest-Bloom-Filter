#!/usr/bin/env python3
"""Additive read-only call-boundary capture from the tested native executable."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
PROOF = HERE / 'validation-v1'

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def main():
    metadata = json.loads((PROOF / 'metadata.json').read_text())
    assert metadata['complete'] and not metadata['formal160_launched']
    item = metadata['binaries']['native/worker']
    binary = Path(item['path'])
    assert sha(binary) == item['sha256']
    output = PROOF / 'assembly-review'
    output.mkdir(exist_ok=False)
    commands = []

    def capture(name, argv):
        result = subprocess.run(argv, capture_output=True, check=True)
        assert not result.stderr
        (output / name).write_bytes(result.stdout)
        commands.append(dict(command=argv, artifact=name, sha256=sha(output / name), returncode=0))
        return result.stdout.decode()

    capture('nm-version.txt', ['nm', '--version'])
    capture('objdump-version.txt', ['objdump', '--version'])
    symbols = capture('symbols.txt', ['nm', '-S', '-C', '--defined-only', str(binary)])
    functions = []
    counts = {}
    for line in symbols.splitlines():
        match = re.match(r'^([0-9a-f]+) ([0-9a-f]+) ([A-Za-z]) (.*)$', line)
        if not match:
            continue
        start, length, symbol = int(match[1], 16), int(match[2], 16), match[4]
        category = None
        if symbol.startswith('void vldb_stage2::DenseCall<'):
            category = 'dense'
        elif symbol.startswith('raw32_stage3::RunObject('):
            category = 'run-object'
        elif 'VisibleRawHash<nearby_raw32::' in symbol and '>::Dense(' in symbol:
            category = 'visible-dense'
        elif ('AnyFilter::Bind<raw32_stage3::VisibleRawHash<nearby_raw32::' in symbol
              and 'lambda(void*, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)#6}' in symbol):
            category = 'query-thunk'
        if category is None:
            continue
        i = counts.get(category, 0)
        counts[category] = i + 1
        name = category + '-' + str(i).zfill(2) + '.asm'
        argv = ['objdump', '-dC', '--no-show-raw-insn', '--start-address=' + str(start),
                '--stop-address=' + str(start + length), str(binary)]
        text = capture(name, argv)
        functions.append(dict(category=category, symbol=symbol, start=hex(start), bytes=length,
                              artifact=name, calls=[x.strip() for x in text.splitlines()
                                                    if re.search(r'\bcall\b', x)]))
    assert counts == {'run-object': 1, 'visible-dense': 1, 'query-thunk': 2, 'dense': 20}, counts
    assert sha(binary) == item['sha256']
    record = dict(binary=item, source_commit=metadata['source_commit'], commands=commands,
                  functions=functions, counts=counts, compiler_or_filter_executed=False)
    (output / 'CAPTURE.json').write_text(json.dumps(record, indent=2) + '\n')
    print(json.dumps(counts))

if __name__ == '__main__':
    main()
