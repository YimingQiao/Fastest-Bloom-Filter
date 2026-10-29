#!/usr/bin/env python3
"""Source-only derivation from the proof-first complete loader; no data imports."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PARENT_COMMIT = '515f6c0c17db7b8d3db382ef2643a05e97f9aeab'
PARENT_PATH = 'experiments/2026-10-30-independent32-range-analysis/loader-v2/run.py'

def products():
    original = subprocess.check_output(['git','show',PARENT_COMMIT+':'+PARENT_PATH],cwd=ROOT)
    assert (ROOT/PARENT_PATH).read_bytes() == original, 'parent loader source changed'
    text = original.decode()
    replacements = [
        ('Independent32Range216 loader', 'Independent32Range prefetch64 loader'),
        ('2026-10-30-independent32-range/screening', '2026-10-30-independent32-range-prefetch64/screening'),
        ('== (51, 24, 216)', '== (51, 24, 192)'),
        ("len(archive['files']) == 173", "len(archive['files']) == binding['expected_proof_artifacts']"),
        ("len(proof['all_binary_sha256']) == 2", "len(proof['all_binary_sha256']) == 3"),
        ("len(proof['compiler_consumed_input_sha256']) == 570", "len(proof['compiler_consumed_input_sha256']) == 572"),
        ('Complete24 processes/216 rows;', 'Complete24 processes/192 rows;'),
        ("metadata['counts']['rows'] == 216", "metadata['counts']['rows'] == 192"),
        ("links['api_record_count'] == 36", "links['api_record_count'] == 32"),
        ("links['known_mapping_record_count'] == 34", "links['known_mapping_record_count'] == 26"),
        ("links['calibration_rows'] == 36", "links['calibration_rows'] == 32"),
        ("links['reuse_rows'] == 180", "links['reuse_rows'] == 160"),
        ("len(result['quality']) == 36", "len(result['quality']) == 32"),
    ]
    for old,new in replacements:
        assert text.count(old) == 1, old
        text = text.replace(old,new)
    old = "         'fixed run cardinalities changed')\n"
    assert text.count(old)==1
    text = text.replace(old, old + """    need(type(binding['expected_proof_artifacts']) is int and binding['expected_proof_artifacts'] > 0,
         'fixed committed proof inventory required')
""")
    patch = ''.join(difflib.unified_diff(original.decode().splitlines(True),text.splitlines(True),
        fromfile=PARENT_PATH+'@'+PARENT_COMMIT, tofile='prefetch64-analysis/loader/run.py'))
    descriptor = dict(parent_loader_commit=PARENT_COMMIT,parent_path=PARENT_PATH,
        parent_sha256=hashlib.sha256(original).hexdigest(),
        preserved='Exact proof-first sole caller seal.py allowance, strict imported-source closures, complete raw/log/terminal requirements, unchanged pure calculation invocation.',
        changes='Prefetch64 paths and fixed192/32/26/160/3binary/572input counts; committed proof-artifact count in binding.',
        no_data_loaded=True)
    return {'run.py':text.encode(),'LOADER.patch':patch.encode(),
            'DERIVATION.json':(json.dumps(descriptor,indent=2)+'\n').encode()}

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--write',action='store_true');args=parser.parse_args()
    for name,data in products().items():
        path=HERE/name
        if args.write:
            assert not path.exists() and not path.is_symlink()
            path.write_bytes(data)
        else:
            assert path.read_bytes()==data,name
    print('PASS exact repaired-parent derivation; no raw data/caller imports')

