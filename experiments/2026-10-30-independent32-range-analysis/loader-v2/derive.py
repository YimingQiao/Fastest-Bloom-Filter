#!/usr/bin/env python3
"""Exact source-only derivation of the narrowly repaired complete loader."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PARENT_COMMIT = 'f692681654ea68c31870d9684c8c90c839a629f6'
PARENT = HERE.parent / 'loader'
FAILURE_COMMIT = '00b921170b72e3deef06624f41b5645b1ae6db3f'

def blob(path):
    data = subprocess.check_output(['git', 'show', PARENT_COMMIT + ':' + path.relative_to(ROOT).as_posix()], cwd=ROOT)
    assert path.read_bytes() == data, 'parent loader changed'
    return data

def replace_once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old, new)

def products():
    original = blob(PARENT / 'run.py').decode()
    revised = replace_once(original,
        'def manifest_files(stage, commit, expected=None):',
        'def manifest_files(stage, commit, expected=None, proof_python=()):')
    revised = replace_once(revised,
        "    need({p.resolve() for p in stage.glob('*.py')} <= paths, 'uninventoried local Python source')",
        """    proof_python = set(proof_python)
    need(not proof_python or (stage.resolve() == CALLER.resolve() and
         proof_python == {(CALLER / 'seal.py').resolve()}), 'unexpected proof Python allowance')
    need({p.resolve() for p in stage.glob('*.py')} <= paths | proof_python,
         'uninventoried local Python source')""")
    revised = replace_once(revised, '    return proof\n',
        """    python_names = {name for name in archive['files']
                    if Path(name).parent == Path('.') and Path(name).suffix == '.py'}
    need(python_names == {'seal.py'}, 'unexpected caller proof Python inventory')
    return proof, {(CALLER / name).resolve() for name in python_names}
""")
    revised = replace_once(revised,
        "    manifest_files(CALLER, binding['caller_commit'], binding['caller_manifest_sha256'])",
        """    proof, proof_python = verify_proof(binding)
    manifest_files(CALLER, binding['caller_commit'], binding['caller_manifest_sha256'], proof_python)""")
    revised = replace_once(revised, "    proof = verify_proof(binding)\n", '')
    patch = ''.join(difflib.unified_diff(original.splitlines(True), revised.splitlines(True),
        fromfile='loader/run.py@' + PARENT_COMMIT, tofile='loader-v2/run.py'))
    descriptor = dict(parent_commit=PARENT_COMMIT,
        parent_run_sha256=hashlib.sha256(original.encode()).hexdigest(),
        failure_commit=FAILURE_COMMIT,
        failure_archive_sha256='0f1d225da8ceaa8045c7c8b1d58d816522392de647f893006dcb75129e26e4b4',
        change='Verify the complete caller proof first; allow only its exact committed top-level seal.py in the caller directory. All imported source inventories remain strict.',
        calculation_changed=False, producer_changed=False, binary_changed=False, raw_changed=False, anchor_changed=False)
    return {'run.py': revised.encode(), 'binding.json': blob(PARENT / 'binding.json'),
            'REPAIR.patch': patch.encode(),
            'DERIVATION.json': (json.dumps(descriptor, indent=2) + '\n').encode()}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    for name, content in products().items():
        path = HERE / name
        if args.write:
            assert not path.exists() and not path.is_symlink(), 'preserve derived source'
            path.write_bytes(content)
        else:
            assert path.read_bytes() == content, name
    print('PASS exact parent derivation; only proof-first caller Python allowance changed')

if __name__ == '__main__':
    main()

