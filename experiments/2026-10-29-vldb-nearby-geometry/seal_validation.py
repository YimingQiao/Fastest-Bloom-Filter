#!/usr/bin/env python3
"""Reconstruct and seal the completed correctness proof, without executing a BF."""
import json
import shutil
from pathlib import Path
from nearby_contract import BACKENDS, CONFIGS, cases, need, reference_row, validate
from nearby_guard import HERE, ROOT, PARENT, sha, verify

SOURCE = '9ece4af4db5089417aac119fe5166266b2716821'
OUT = HERE / 'validation-v1'


def save(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def main():
    archives = verify(SOURCE)
    meta = json.loads((OUT / 'metadata.json').read_text())
    need(meta['complete'] is True and meta['source_commit'] == SOURCE, 'Incomplete proof')
    need(meta['actual_geometry_cases'] == 93 and meta['malformed_cli_cases'] == 9, 'Wrong coverage')
    need(meta['upstream_rebuilds'] == meta['quality_samples'] == meta['throughput_samples'] == 0,
         'Changed scope')
    need(meta['all_sources_unchanged'] is True and meta['tuner_file_before'] == meta['tuner_file_after'],
         'Input or tuner drift')
    need(meta['lease']['cpu'] == 2 and meta['lease']['lease'] == 'socket0' and
         meta['lease']['lock_path'] == '/tmp/fastest-bf-socket0.lock' and
         bool(meta['lease']['inherited_lock_descriptors']), 'Wrong recorded lease')
    records = {r['label']: r for r in meta['commands']}
    expected_labels = ['compiler']
    for backend in BACKENDS:
        expected_labels += [backend + suffix for suffix in ('-configure', '-build', '-macros')]
        expected_labels += [backend + '-case' + str(i) for i in range(31)]
        expected_labels += [backend + '-invalid' + str(i) for i in range(3)]
    need([r['label'] for r in meta['commands']] == expected_labels and len(records) == 112,
         'Changed command ledger')
    for label, record in records.items():
        need(record['complete'] is True, 'Incomplete command ' + label)
        need((record['returncode'] != 0) == ('-invalid' in label), 'Wrong command status ' + label)
        for stream in ('stdout', 'stderr'):
            path = OUT / (label + '.' + stream)
            need(record[stream] == path.name and sha(path) == record[stream + '_sha256'],
                 'Raw stream drift ' + label)
        if '-case' in label:
            need(not (OUT / record['stderr']).read_bytes(), 'Unexpected filter diagnostic')
        if '-invalid' in label:
            need(not (OUT / record['stdout']).read_bytes(), 'Invalid CLI produced a row')
    parent = json.loads((PARENT / 'validation-v1/metadata.json').read_text())
    parent_cases = [(c, n, b) for c in CONFIGS for n in (16, 25) for b in (12, 16, 24, 32)]
    consumed = {}
    reference = None
    for backend in BACKENDS:
        rows = []
        binary = meta['binaries'][backend]
        need(sha(binary['path']) == binary['sha256'], 'Tested binary drift')
        for i, case in enumerate(cases()):
            record = records[backend + '-case' + str(i)]
            need(record['command'] == [binary['path'], *map(str, case)], 'Changed case command')
            raw = (OUT / record['stdout']).read_text().splitlines()
            need(len(raw) == 1, 'Expected one geometry record')
            row = validate(json.loads(raw[0]), case)
            if case[-1] == 'original':
                need(reference_row(row) == parent['backend_rows'][backend][parent_cases.index(case[:3])],
                     'Original MAGIC control drift')
            rows.append(row)
        need(rows == meta['backend_rows'][backend], 'Raw/metadata row drift')
        if reference is None:
            reference = rows
        need(rows == reference, 'Cross-backend bitmap/output/geometry mismatch')
        headers = json.loads((OUT / (backend + '-consumed-headers.json')).read_text())
        need(headers['boost']['version'] == '1_83' and len(headers['compile_commands']) == 1,
             'Wrong compiler/header context')
        for name, digest in headers['consumed_files'].items():
            need(sha(name) == digest, 'Consumed compiler input drift ' + name)
            need(name not in consumed or consumed[name] == digest, 'Conflicting compiler input')
            consumed[name] = digest
        for name, digest in headers['dependency_files'].items():
            need(sha(name) == digest, 'Dependency file drift')
        build = Path(binary['path']).parent
        target = 'CMakeFiles/vldb_nearby_check.dir/'
        for name in ('CMakeCache.txt', 'compile_commands.json', target + 'check.cpp.o.d',
                     target + 'flags.make', target + 'link.txt', target + 'build.make'):
            dest = OUT / 'build-inputs' / backend / name
            dest.parent.mkdir(parents=True, exist_ok=True)
            if dest.exists():
                need(dest.read_bytes() == (build / name).read_bytes(), 'Archived build input drift')
            else:
                shutil.copyfile(build / name, dest)
    freeze = dict(source_commit=SOURCE, actual_geometry_cases=93, malformed_cli_cases=9,
                  completed_commands=112, backend_rows=31, supported_new_geometries=28,
                  original_control_geometries=3, binaries=meta['binaries'],
                  original_archives=archives, consumed_inputs_sha256=consumed,
                  tuner_file_unchanged=meta['tuner_file_before'],
                  upstream_rebuilds=0, independent_negative_samples=0, throughput_samples=0,
                  bitmap_fixture_insertions=65536,
                  scope='Original public PImpl/dynamic/static correctness only; no full-occupancy FPR or speed claim')
    save(HERE / 'PREFLIGHT_FREEZE.json', freeze)
    files = sorted([p for p in OUT.rglob('*') if p.is_file()] +
                   [HERE / 'preflight-v1.log', HERE / 'seal_validation.py', HERE / 'VALIDATION.md',
                    HERE / 'seal_validation.v1.py.txt', HERE / 'seal-validation-v1-error.json',
                    HERE / 'PREFLIGHT_FREEZE.json'])
    save(HERE / 'PREFLIGHT_ARCHIVE.json', dict(source_commit=SOURCE,
         files={str(p.relative_to(HERE)): sha(p) for p in files}))
    print('PASS 93 geometry cases, 9 invalid CLI, 112 commands;', len(consumed),
          'unique compiler inputs;', len(files), 'proof artifacts; no filter executed')


if __name__ == '__main__':
    main()
