"""Immutable V1 source/failure and exact namespace-only V2 derivation."""
import difflib
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
PARENT = HERE.parent / 'caller'
ROOT = HERE.parents[2]
SOURCE_COMMIT = 'd0b9a90ab75efa63c866fd4f4ffdd8ef27885d06'
FAILURE_COMMIT = '2d23a3860f3dd9abc67657f2b8c0e6d6da90b3f0'
FAILURE_SHA = '39ddd4f41d8dc6c7c87aa2aeb8e1f994d3315486065c230c64ef420f2264da5e'
NATIVE_HEADERS = ('fast_pattern_BF.h', 'four_sector_bloom.h', 'split64_bloom.h',
                  'byte_split_bloom.h', 'split64_range_bloom.h', 'control.h', 'candidate.h')
NATIVE_NAMES = ('FourSectorBloomFilter', 'Split64BloomFilter', 'ByteSplitBloomFilter',
                'FourSectorRange12BloomFilter', 'FourSectorRange12SingletonVectorExperiment',
                'Split64RangeBloomFilter')


def need(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def blob(commit, path):
    need(bool(re.fullmatch('[0-9a-f]{40}', commit)), 'full immutable commit required')
    return subprocess.check_output(['git', 'show', commit + ':' + str(path.relative_to(ROOT))], cwd=ROOT)


def bound_manifest(folder, name, commit, digest=None):
    path = folder / name
    data = blob(commit, path)
    need(path.read_bytes() == data, 'committed manifest drift')
    need(digest is None or hashlib.sha256(data).hexdigest() == digest, 'manifest hash drift')
    result = {str(path.resolve()): hashlib.sha256(data).hexdigest()}
    for relative, record in json.loads(data)['files'].items():
        member = folder / relative
        need(member.resolve().is_relative_to(folder.resolve()), 'manifest path escape')
        raw = blob(commit, member)
        need(member.read_bytes() == raw and len(raw) == record['bytes'] and
             hashlib.sha256(raw).hexdigest() == record['sha256'], 'committed member drift: ' + relative)
        result[str(member.resolve())] = record['sha256']
    return result


def parents():
    result = bound_manifest(PARENT, 'PREPARATION.json', SOURCE_COMMIT)
    result.update(bound_manifest(PARENT, 'FAILED_V1_ARCHIVE.json', FAILURE_COMMIT, FAILURE_SHA))
    failed = json.loads((PARENT / 'validation-v1/metadata.json').read_text())
    commands = json.loads((PARENT / 'validation-v1/commands.json').read_text())
    need(failed['source_commit'] == SOURCE_COMMIT and failed['complete'] is False, 'wrong failed attempt')
    need([item['label'] for item in commands] ==
         ['derive-source', 'compiler-version', 'normal-configure', 'normal-build'], 'unexpected V1 commands')
    need([item['returncode'] for item in commands] == [0, 0, 0, 2], 'unexpected V1 outcomes')
    need(failed['formal_workloads'] == 0 and not failed.get('all_binary_sha256'), 'V1 must have no successful binary')
    return result


def wrapper():
    return ('// Namespace binding only. Preserve the original native-header include order.\n' +
            ''.join('#include "../caller/' + name + '"\n' for name in NATIVE_HEADERS) +
            ''.join('using bloom_filters::' + name + ';\n' for name in NATIVE_NAMES) +
            '#include "../caller/main.cpp"\n')


def driver(parent):
    # These exact textual substitutions change provenance/routing only.
    changes = [
        ('from contract import CASES',
         'PARENT_IMPORT = Path(__file__).resolve().parent.parent / "caller"\n'
         'sys.path.insert(0, str(PARENT_IMPORT))\n'
         'import repair_guard\n'
         'from contract import CASES'),
        ("OUT=HERE/'validation-v1'", "PARENT=HERE.parent/'caller'\nOUT=HERE/'validation-v2'"),
        ('fastest-bf-k12-singleton-external-v1-cpu3', 'fastest-bf-k12-singleton-external-v2-cpu3'),
        ('    result={}\n    for folder,anchor in ((HERE,commit),(HERE.parent,PLAN_COMMIT)):',
         '    result=repair_guard.parents()\n'
         '    for folder,anchor in ((HERE,commit),(HERE.parent,PLAN_COMMIT)):'),
        ("upstream=json.loads((HERE/'upstream-pins.json').read_text())",
         "upstream=json.loads((PARENT/'upstream-pins.json').read_text())"),
        ("need(str((HERE/name).resolve()) in canonical,'required actual input absent: '+name)",
         "need(str((PARENT/name).resolve()) in canonical,'required actual input absent: '+name)\n"
         "    need(str((HERE/'main.cpp').resolve()) in canonical,'V2 namespace entry absent')"),
        ('metadata=dict(complete=False,source_commit=args.source_commit,plan_commit=PLAN_COMMIT,',
         'metadata=dict(complete=False,source_commit=args.source_commit,plan_commit=PLAN_COMMIT,\n'
         '                  parent_source_commit=repair_guard.SOURCE_COMMIT,\n'
         '                  failed_v1_commit=repair_guard.FAILURE_COMMIT,'),
    ]
    for old, new in changes:
        need(parent.count(old) == 1, 'unexpected parent driver substitution: ' + old)
        parent = parent.replace(old, new)
    return parent


def products():
    main = wrapper()
    old_driver = (PARENT / 'validate.py').read_text()
    new_driver = driver(old_driver)
    return {
        'main.cpp': main.encode(),
        'CMakeLists.txt': (PARENT / 'CMakeLists.txt').read_bytes(),
        'validate.py': new_driver.encode(),
        'BINDING.patch': ''.join(difflib.unified_diff([], main.splitlines(True),
            fromfile='/dev/null', tofile='caller-v2/main.cpp')).encode(),
        'DRIVER.patch': ''.join(difflib.unified_diff(old_driver.splitlines(True), new_driver.splitlines(True),
            fromfile='immutable-caller/validate.py', tofile='caller-v2/validate.py')).encode(),
    }


def verify_products():
    for name, expected in products().items():
        need((HERE / name).read_bytes() == expected, 'derived source drift: ' + name)
