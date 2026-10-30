"""Extract additional fixed ELF spans from existing V2 text, without tools/BF."""
import hashlib
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
INPUT = HERE.parent / 'repair-v2/validation-v1'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    inventory = {}
    records = {}
    # Native clocks are resolved from the captured RELATIVE relocations.
    # The missing portable facade is a distinct ELF FUNC, not a display alias.
    selected = {'native': [0x4b270, 0x4b280], 'portable': [0x31e40]}
    for profile, addresses in selected.items():
        paths = {role: INPUT / f'{profile}-asm-{role}.stdout'
                 for role in ['elf', 'nm', 'demangled', 'disassembly', 'relocations']}
        paths['capture'] = INPUT / f'{profile}-asm-capture.json'
        inventory.update({str(p.relative_to(HERE.parent)): sha(p) for p in paths.values()})
        capture = json.loads(paths['capture'].read_text())
        symbols = []
        for line in paths['elf'].read_text().splitlines():
            c = line.split(None, 7)
            if len(c) == 8 and c[0].endswith(':') and c[0][:-1].isdigit() and c[3] == 'FUNC' and c[6] not in ['UND', 'ABS']:
                symbols.append(dict(address=int(c[1], 16), size=int(c[2], 0), name=c[7], binding=c[4], section=c[6]))
        raw = {(int(c[0], 16), int(c[1], 16), c[3]) for line in paths['nm'].read_text().splitlines()
               if len(c := line.split(None, 3)) == 4 and re.fullmatch('[0-9a-fA-F]+', c[0]) and re.fullmatch('[0-9a-fA-F]+', c[1])}
        instructions = []
        for line in paths['disassembly'].read_text().splitlines():
            m = re.match(r'^\s*([0-9a-fA-F]+):\s+(\S+)', line)
            if m and not m[2].startswith('R_'):
                instructions.append((int(m[1], 16), line))
        spans = []
        for addr in addresses:
            aliases = [s for s in symbols if s['address'] == addr]
            sizes = {s['size'] for s in aliases}
            assert len(sizes) == 1 and next(iter(sizes)) > 0
            size = next(iter(sizes))
            assert all((addr, size, s['name']) in raw for s in aliases)
            body = [(pc, line) for pc, line in instructions if addr <= pc < addr + size]
            assert body and body[0][0] == addr
            path = HERE / f'{profile}-{addr:x}.txt'
            path.write_text('\n'.join(line for _, line in body) + '\n')
            spans.append(dict(address=addr, size=size, elf_aliases=aliases,
                              file=path.name, sha256=sha(path)))
        relocations = paths['relocations'].read_text().splitlines()
        slots = [0x6f3d8, 0x6f710, 0x6f718] if profile == 'native' else [0x6e4e0]
        resolved = {}
        for slot in slots:
            matches = [line for line in relocations if line.split() and line.split()[0] == f'{slot:016x}']
            assert len(matches) == 1 and 'R_X86_64_RELATIVE' in matches[0]
            resolved[hex(slot)] = dict(line=matches[0], target=int(matches[0].split()[-1], 16))
        records[profile] = dict(binary=capture['binary'], binary_sha256=capture['binary_sha256'],
                                spans=spans, relocations=resolved)
    assert records['native']['relocations']['0x6f3d8']['target'] == 0x192b0
    assert records['portable']['relocations']['0x6e4e0']['target'] == 0x1b6f0
    assert records['native']['relocations']['0x6f710']['target'] == 0x4b270
    assert records['native']['relocations']['0x6f718']['target'] == 0x4b280
    inventory['repair-v2/validation-v1/metadata.json'] = sha(INPUT / 'metadata.json')
    result = dict(method='Fixed ELF address/size extraction from already-captured text; no disassembler, compiler or BF execution.',
                  inputs_sha256=inventory, records=records)
    (HERE / 'EXTRA_SPANS.json').write_text(json.dumps(result, indent=2, sort_keys=True) + '\n')
    print('PASS: three exact ELF spans and four GOT relocations extracted from retained text')

if __name__ == '__main__':
    main()
