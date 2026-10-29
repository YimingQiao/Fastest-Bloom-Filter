#!/usr/bin/env python3
"""Extend only registry/probe metadata/cardinalities in the reviewed Rust120 guard."""
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = '2c7b1668880ab5a1e3ea0c73f2034b89da0d8650'


def generate():
    source = subprocess.check_output(['git', 'show', PARENT + ':experiments/2026-10-29-split64-range-rust-screen/screening/guard.py'], cwd=ROOT, text=True)
    if (HERE / 'parent-guard.py').read_text() != source: raise ValueError('Changed reviewed parent guard')
    def replace(old, new):
        nonlocal source
        if source.count(old) != 1: raise ValueError(('Unexpected guard derivation', old))
        source = source.replace(old, new)
    replace("EXTERNAL = {'Fastbloom017', 'BloomsdayPinned', 'SbbfSafePinned'}", "FIXED = {f'Fastbloom017K{k}' for k in range(1, 13)}\nEXTERNAL = {'Fastbloom017', 'BloomsdayPinned', 'SbbfSafePinned'} | FIXED")
    replace("len(names) == len(set(names)) == 8", "len(names) == len(set(names)) == 20")
    replace("        require(info == dict(owner=owner, public_api=api, capacity_policy=policy, mapping_family=name), 'Wrong registry metadata')", """        if name in FIXED:
            k = int(name.removeprefix('Fastbloom017K'))
            expected = dict(owner='external', public_api='contains_hash', constructor='with_num_bits(exact_bits).hashes(K)',
                fixed_K=k, capacity_policy='exact_words', mapping_family='Fastbloom017',
                calibration_alias='Fastbloom017 default at16bpk only' if k == 11 else None)
        else:
            expected = dict(owner=owner, public_api=api, capacity_policy=policy, mapping_family=name)
        require(info == expected, 'Wrong registry metadata')""")
    replace("protocol['expected_rows'] == 120", "protocol['expected_rows'] == 336")
    replace("protocol['quality_records'] == 40", "protocol['quality_records'] == 112 and protocol['known_mapping_records'] == 110")
    replace("    elif name == 'BloomsdayPinned':", """    elif name in FIXED:
        unit, kind, probes = 8, 'classical_words', int(name.removeprefix('Fastbloom017K'))
        policy, argument = 'public_fixed_hash_count', backing * 8
    elif name == 'BloomsdayPinned':""")
    return source


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    target = HERE / 'guard.py'
    value = generate()
    if args.write:
        if target.exists(): raise ValueError('Refuse guard overwrite')
        target.write_text(value)
    elif target.read_text() != value:
        raise ValueError('Guard differs beyond the declared registry/probe/count delta')
    print('PASS exact Rust120 guard derivation;20 APIs,336 rows,112 API quality identities')
