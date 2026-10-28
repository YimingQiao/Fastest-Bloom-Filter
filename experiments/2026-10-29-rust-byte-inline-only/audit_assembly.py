#!/usr/bin/env python3
"""Retain typed whole-array loops and public/private callees without timing them."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--binary', type=Path, required=True)
    args = parser.parse_args()
    binary = args.binary.resolve()
    out = HERE/'assembly'
    out.mkdir(exist_ok=True)
    symbols = subprocess.check_output(['nm','-C',str(binary)], text=True)
    disassembly = subprocess.check_output(['objdump','-d','--no-show-raw-insn','-C',str(binary)], text=True)
    (out/'symbols.txt').write_text(symbols)
    blocks = {}
    for body in re.split(r'(?m)(?=^[0-9a-f]+ <)', disassembly):
        match = re.match(r'^([0-9a-f]+) <(.+)>:\n', body)
        if match:
            blocks[int(match.group(1),16)] = (match.group(2),body)
    loops = []
    for line in symbols.splitlines():
        match = re.match(r'^([0-9a-f]+) [tT] (.+)$',line)
        if match and '::visible_lookup::<' in match.group(2):
            loops.append((int(match.group(1),16),match.group(2)))
    if len(loops) != 6:
        raise ValueError(f'Expected6 visible monomorphized symbols; observed {len(loops)} (inspect possible compiler folding)')
    kept, inventory = {}, []
    for address, name in loops:
        label,body = blocks[address]
        kept[address] = body
        calls = []
        for line in body.splitlines():
            match = re.search(r'\bcall\s+(.+)',line)
            if match:
                calls.append(dict(line=line.strip(),kind='indirect' if match.group(1).startswith('*') else 'direct'))
        inventory.append(dict(address=hex(address),symbol=name,body_symbol=label,experimental=('fastest_bloom_filter_leaf_inline' in name or 'fastest_bloom_filter_byte_inline_only' in name),
                              calls=calls,mask_instructions=sorted(set(re.findall(r'\b(vpmulhw|vpshufb|vptest|vpmulld|vpsllvd|vpsllvq|vprolvd|vptestnmq|rol|rorx)\b',body)))))
    for address,(name,body) in blocks.items():
        if ('fastest_bloom_filter' in name and any(key in name for key in ('contains_hash','contains_scalar','lookup_one_avx2','lookup_one_avx512'))
                or 'sbbf_rs' in name and 'contains_hash' in name):
            kept[address]=body
    (out/'public-query-kernels.txt').write_text('\n'.join(kept[a] for a in sorted(kept)))
    value=dict(binary=str(binary),binary_sha256=hashlib.sha256(binary.read_bytes()).hexdigest(),compiler_flags='-C target-cpu=native -C symbol-mangling-version=v0',
               visible_symbols=len(loops),unique_visible_bodies=len({a for a,_ in loops}),kernels=inventory,
               note='Calls include cold panic/bounds paths; manually distinguish hot per-key calls before drawing conclusions. No timing has run.')
    (out/'inventory.json').write_text(json.dumps(value,indent=2)+'\n')
    print(f'Archived {len(loops)} typed loops / {value["unique_visible_bodies"]} unique bodies and relevant callees')


if __name__ == '__main__':
    main()
