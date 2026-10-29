#!/usr/bin/env python3
"""Recheck and seal completed caller evidence without executing a filter."""
import json
from pathlib import Path
import shutil
from checks import cases, parse, validate, normalized, check_aliases, need
from source_guard import HERE, ROOT, sha, verify, validate_inputs

SOURCE = '6edb78425c86209aa366a4e04311b5317ffa27c5'
PROOF = HERE / 'validation-v1'

def write(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')

def main():
    need(not (HERE / 'CALLER_ARCHIVE.json').exists(), 'Preserve existing seal')
    archives, pins, local = verify(SOURCE)
    meta = json.loads((PROOF / 'metadata.json').read_text())
    need(meta['complete'] and meta['source_commit'] == SOURCE and
         meta['frozen_sources_unchanged'] and not meta['formal160_launched'] and
         not meta['performance_run'] and meta['throughput_samples'] == 0 and
         meta['upstream_rebuilds'] == 0, 'Incomplete/wrong proof')
    need(meta['affinity'] == [2] and meta['tuner_file_before'] == meta['tuner_file_after'], 'Placement/tuner drift')
    commands = meta['commands']
    need(len(commands) == 229 and len({r['label'] for r in commands}) == 229, 'Wrong command closure')
    by_label = {r['label']: r for r in commands}
    rejected = 0
    for r in commands:
        need(r['complete'], 'Incomplete command')
        for stream in ('stdout', 'stderr'):
            need(sha(PROOF / r[stream]) == r[stream + '_sha256'], 'Raw command artifact changed')
        invalid = '-invalid' in r['label']
        need((r['returncode'] != 0) == invalid, 'Wrong recorded status')
        rejected += invalid
        if invalid:
            need((PROOF / r['stdout']).read_bytes() == b'', 'Rejected command emitted row')
    need(rejected == 12, 'Wrong rejected count')
    consumed = {}
    build_files = {}
    payload_groups = {}
    full_rows = {}
    for backend in ('native', 'native-asan'):
        headers = json.loads((PROOF / (backend + '-consumed-inputs.json')).read_text())
        validate_inputs(headers, pins, local)
        for path, digest in headers['consumed_files'].items():
            need(consumed.get(path, digest) == digest and sha(path) == digest, 'Compiler input disagreement')
            consumed[path] = digest
        build = Path(headers['build'])
        selected = [build / 'compile_commands.json', build / 'CMakeCache.txt']
        selected += sorted(build.glob('CMakeFiles/nearby_*.dir/*.o.d'))
        selected += sorted(build.glob('CMakeFiles/nearby_*.dir/link.txt'))
        selected += sorted(build.glob('CMakeFiles/nearby_*.dir/flags.make'))
        need(len(selected) == 8, 'Incomplete two-TU build provenance')
        for path in selected:
            destination = PROOF / 'build-files' / backend / path.relative_to(build)
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(path, destination)
            build_files[str(path)] = dict(artifact=str(destination.relative_to(HERE)), sha256=sha(path))
        rows = []
        for i, case in enumerate(cases()):
            row = parse((PROOF / by_label[backend + '-case' + str(i)]['stdout']).read_text())
            validate(row, case)
            rows.append(row)
            label = backend + '-reference' + str(i)
            if label in by_label:
                old = parse((PROOF / by_label[label]['stdout']).read_text())
                need(normalized(old) == normalized(row), 'Frozen reference mismatch')
        need(rows == meta['rows'][backend], 'Stored caller rows changed')
        check_aliases(rows)
        full_rows[backend] = rows
        for record in meta['public_payloads'][backend].values():
            path = PROOF / record['artifact']
            data = path.read_bytes()
            need(len(data) == record['bytes'] and sha(path) == record['sha256'], 'Public payload changed')
            key = record['mapping_identity']
            need(payload_groups.get(key, data) == data, 'U/backend full payload mismatch')
            payload_groups[key] = data
        records = []
        for i in range(8):
            row = parse((PROOF / by_label[backend + '-oracle' + str(i)]['stdout']).read_text())
            need(row['full_bitmap_equal'] == row['full_outputs_equal'] == '1', 'Native byte oracle failed')
            records.append(row)
        need(records == meta['native_oracles'][backend], 'Stored oracle rows changed')
    need(full_rows['native'] == full_rows['native-asan'], 'Backend caller mismatch')
    need(meta['native_oracles']['native'] == meta['native_oracles']['native-asan'], 'Backend oracle mismatch')
    need(len(payload_groups) == 12, 'Wrong exact public mapping count')
    for item in meta['binaries'].values():
        need(sha(item['path']) == item['sha256'], 'Binary drift')
    review = json.loads((PROOF / 'assembly-review/REVIEW.json').read_text())
    need(review['manual_review_complete'] and review['binary'] == meta['binaries']['native/worker'], 'Missing actual ASM gate')
    for name, digest in review['captures'].items():
        need(sha(PROOF / 'assembly-review' / name) == digest, 'ASM capture changed')
    freeze = dict(source_commit=SOURCE, preparation_sha256=sha(HERE / 'PREPARATION.json'),
        binaries=meta['binaries'], compiler_consumed_inputs_sha256=consumed,
        reused_archives=archives, copied_actual_build_files=build_files,
        manual_assembly_review_sha256=sha(PROOF / 'assembly-review/REVIEW.json'),
        commands=229, caller_rows=80, old_reference_rows=56, public_bitmap_payloads=56,
        native_full_bitmap_oracles=16, invalid_or_fault_cases=12,
        query_timing_samples=0, upstream_rebuilds=0, formal160_launched=False,
        scope='GCC12.2 native and ASan+UBSan; complete preflight byte fixtures, not full-size accuracy or speed')
    write(HERE / 'WORKER_FREEZE.json', freeze)
    files = [p for p in PROOF.rglob('*') if p.is_file()]
    files += [HERE / p for p in ['.gitattributes', 'capture_review.py', 'seal_proof.py',
                                'VALIDATION.md', 'preflight-v1.log', 'WORKER_FREEZE.json']]
    need(all(p.read_bytes()[:4] != b'\x7fELF' for p in files), 'Executable staging forbidden')
    archive = dict(source_commit=SOURCE, files={str(p.relative_to(HERE)): sha(p) for p in sorted(files)},
                   binary_artifacts_not_staged=True, formal160_launched=False)
    write(HERE / 'CALLER_ARCHIVE.json', archive)
    print(json.dumps(dict(artifacts=len(files), consumed_inputs=len(consumed), binaries=4,
                         archive_sha256=sha(HERE / 'CALLER_ARCHIVE.json'),
                         worker_freeze_sha256=sha(HERE / 'WORKER_FREEZE.json'))))

if __name__ == '__main__':
    main()
