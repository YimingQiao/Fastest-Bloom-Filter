#!/usr/bin/env python3
"""Read-only exact ELF-span closure from already captured generic/visible roots."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[2]
sys.path.insert(0, str(STAGE.parent / 'caller'))
from lease import require


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def need(value, message):
    if not value:
        raise ValueError(message)


def transfers(text, start, size):
    result = []
    for line in text.splitlines():
        match = re.match(r'\s*([0-9a-f]+):\s+(call|jmp|j[a-z]+)\s+([0-9a-f]+)\s+<(.*?)>', line)
        if match:
            pc, op, target, label = match.groups()
            target = int(target, 16)
            if not start <= target < start + size:
                result.append(dict(pc=int(pc, 16), operation=op, target=target, raw_label=label))
    return result


def main():
    lease = require()
    metadata_path = STAGE / 'validation-v2/metadata.json'
    metadata = json.loads(metadata_path.read_text())
    commands_path = STAGE / 'validation-v2/commands.json'
    commands = json.loads(commands_path.read_text())
    need(metadata['complete'], 'functional proof incomplete')
    objdump = '/usr/bin/objdump'
    need(sha(objdump) == metadata['tools_sha256'][objdump], 'objdump changed')
    output = HERE / 'callees-v1'
    need(not output.exists() and not output.is_symlink(), 'preserve prior capture')
    output.mkdir()
    proof = dict(complete=False, no_filter_or_compiler_execution=True,
        source_commit=metadata['source_commit'], metadata_sha256=sha(metadata_path),
        commands_sha256=sha(commands_path), capture_script_sha256=sha(__file__),
        placement=lease, objdump_sha256=sha(objdump), profiles={})
    for profile in ('normal', 'minimal-f'):
        capture = metadata['assembly'][profile]
        binary = Path(capture['binary'])
        need(sha(binary) == capture['sha256'], 'actual executable changed')
        command = next(c for c in commands if c['label'] == profile + '-nm')
        nm_path = STAGE / command['stdout']
        need(sha(nm_path) == command['stdout_sha256'], 'archived nm changed')
        all_symbols = {}
        for line in nm_path.read_text().splitlines():
            fields = line.split()
            if len(fields) == 4 and fields[1] in ('t', 'T', 'w', 'W'):
                try:
                    start, size = int(fields[2], 16), int(fields[3], 16)
                except ValueError:
                    continue
                if size:
                    all_symbols.setdefault(start, []).append(dict(raw_symbol=fields[0], start=start, size=size))
        seen = set()
        queue = []
        roots = []
        external = []
        for symbol in capture['symbols']:
            if symbol['role'] == 'Run<':
                continue
            path = STAGE / symbol['stdout']
            need(sha(path) == symbol['sha256'], 'root capture changed')
            seen.add(symbol['start'])
            roots.append(dict(start=symbol['start'], raw_symbol=symbol['raw_symbol'], path=symbol['stdout'], sha256=symbol['sha256']))
            queue.extend(transfers(path.read_text(), symbol['start'], symbol['size']))
        entries = []
        while queue:
            edge = queue.pop(0)
            target = edge['target']
            if target in seen:
                continue
            seen.add(target)
            symbols = all_symbols.get(target)
            if symbols is None:
                external.append(edge)
                continue
            sizes = {s['size'] for s in symbols}
            need(len(sizes) == 1, 'ambiguous actual symbol span')
            size = sizes.pop()
            need(require() == lease, 'capture lease changed')
            prefix = profile + '-' + format(target, 'x')
            stdout, stderr = output / (prefix + '.stdout'), output / (prefix + '.stderr')
            argv = [objdump, '-d', '--no-show-raw-insn', '--start-address=' + str(target),
                    '--stop-address=' + str(target + size), str(binary)]
            with stdout.open('wb') as out, stderr.open('wb') as err:
                result = subprocess.run(argv, cwd=ROOT, stdout=out, stderr=err,
                    pass_fds=tuple(map(int, lease['fd_evidence'])))
            need(result.returncode == 0 and not stderr.read_bytes(), 'callee capture failed')
            text = stdout.read_text()
            pcs = [int(m.group(1), 16) for m in re.finditer(r'^\s*([0-9a-f]+):\s+\S', text, re.M)]
            need(pcs and pcs[0] == target and all(target <= pc < target + size for pc in pcs), 'empty or invalid span')
            edges = transfers(text, target, size)
            entries.append(dict(start=target, size=size, raw_symbols=[s['raw_symbol'] for s in symbols],
                command=argv, returncode=result.returncode, instruction_count=len(pcs), first_edge=edge,
                stdout=str(stdout.relative_to(STAGE)), stdout_sha256=sha(stdout),
                stderr=str(stderr.relative_to(STAGE)), stderr_sha256=sha(stderr), transfers=edges))
            queue.extend(edges)
        proof['profiles'][profile] = dict(binary=str(binary), sha256=capture['sha256'],
            nm_path=str(nm_path.relative_to(STAGE)), nm_sha256=sha(nm_path), roots=roots,
            callees=entries, unbound_external_transfers=external)
        need(sha(binary) == capture['sha256'], 'executable drift after capture')
    need(require() == lease and sha(objdump) == proof['objdump_sha256'], 'final capture environment changed')
    proof['complete'] = True
    (output / 'CAPTURE.json').write_text(json.dumps(proof, indent=2) + '\n')
    print({p:len(v['callees']) for p,v in proof['profiles'].items()})


if __name__ == '__main__':
    main()
