#!/usr/bin/env python3
"""Additive complete-only CPP616 loader; no filter, compiler or timer invocation."""
if not __debug__:
    raise RuntimeError('Python -O is unsupported')
import argparse
import hashlib
import importlib
import importlib.util
import json
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ANALYSIS = HERE.parent
ROOT = ANALYSIS.parents[1]
PRODUCER = ROOT / 'experiments/2026-10-29-k12-singleton-external-plan/screening'


def need(value, message):
    if not value:
        raise ValueError(message)


def unique(pairs):
    result = {}
    for key, value in pairs:
        need(key not in result, 'duplicate JSON field')
        result[key] = value
    return result


def read(path):
    return json.loads(Path(path).read_text(), object_pairs_hook=unique)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def full_commit(value):
    need(type(value) is str and re.fullmatch('[0-9a-f]{40}', value), 'full immutable commit required')


def digest(value):
    need(type(value) is str and re.fullmatch('[0-9a-f]{64}', value), 'SHA256 required')


def committed(commit, path, expected=None, size=None):
    full_commit(commit)
    path = Path(path)
    need(not path.is_symlink() and path.resolve().is_relative_to(ROOT), 'escaped or symlink artifact')
    data = path.read_bytes()
    if expected is not None:
        digest(expected)
        need(hashlib.sha256(data).hexdigest() == expected, 'artifact SHA mismatch')
    if size is not None:
        need(type(size) is int and size >= 0 and len(data) == size, 'artifact byte count mismatch')
    raw = subprocess.check_output(['git', 'show', commit + ':' + path.relative_to(ROOT).as_posix()], cwd=ROOT)
    need(raw == data, 'committed/live artifact mismatch')
    return data


def manifest_files(stage, commit, expected=None):
    manifest = stage / 'PREPARATION.json'
    values = json.loads(committed(commit, manifest, expected), object_pairs_hook=unique)
    need(type(values['files']) is dict and values['files'], 'empty source inventory')
    paths = {manifest.resolve()}
    for name, record in values['files'].items():
        need(type(name) is str and not Path(name).is_absolute(), 'absolute source name')
        path = stage / name
        need(path.resolve().is_relative_to(stage.resolve()) and path.resolve() not in paths,
             'escaped or duplicate source path')
        committed(commit, path, record['sha256'], record['bytes'])
        paths.add(path.resolve())
    need({p.resolve() for p in stage.glob('*.py')} <= paths, 'uninventoried local Python source')
    return paths


def validate_anchor(anchor, binding):
    need(binding['complete'] is True, 'unfinished source binding')
    need(type(anchor) is dict and set(anchor) == {'complete', 'producer_commit', 'raw_commit',
        'raw_manifest_sha256', 'screen_log_sha256', 'execution_outcome_sha256', 'session_id'}, 'wrong raw anchor schema')
    need(anchor['complete'] is True and anchor['producer_commit'] == binding['producer_commit'],
         'incomplete or different producer anchor')
    full_commit(anchor['producer_commit'])
    full_commit(anchor['raw_commit'])
    for key in ('raw_manifest_sha256', 'screen_log_sha256', 'execution_outcome_sha256'):
        digest(anchor[key])
    need(type(anchor['session_id']) is int and anchor['session_id'] > 0, 'actual session ID required')


def raw_paths():
    return {'metadata.json', 'records.json', 'quality.json'} | {
        f'case-{i:03d}.{stream}' for i in range(48) for stream in ('stdout', 'stderr')}


def validate_raw_manifest(manifest):
    need(type(manifest) is dict and set(manifest) == {'files', 'files_count'}, 'wrong raw manifest schema')
    need(type(manifest['files_count']) is int and manifest['files_count'] == 99 and
         type(manifest['files']) is dict and set(manifest['files']) == raw_paths(), 'raw inventory incomplete or extra')
    for record in manifest['files'].values():
        need(type(record) is dict and set(record) == {'sha256', 'bytes'}, 'wrong raw member schema')
        digest(record['sha256'])
        need(type(record['bytes']) is int and record['bytes'] >= 0, 'invalid raw byte count')


def expected_log():
    lines = [f'{i}/48 processes complete' for i in range(1, 49)]
    lines.append('Complete48 processes/616 rows; all final source/raw/semantic guards passed.')
    return ('\n'.join(lines) + '\n').encode()


def validate_terminal(outcome, anchor, binding, log):
    need(log == expected_log(), 'incomplete, extra or unexpected launcher log')
    need(type(outcome) is dict and set(outcome) == {'complete', 'producer_commit', 'session_id',
        'exit_code', 'screen_log_sha256', 'terminal_tool_result'}, 'wrong terminal outcome schema')
    need(outcome['complete'] is True and outcome['producer_commit'] == binding['producer_commit'],
         'incomplete or different terminal producer')
    need(type(outcome['session_id']) is int and outcome['session_id'] == anchor['session_id'], 'terminal session mismatch')
    need(type(outcome['exit_code']) is int and outcome['exit_code'] == 0, 'launcher did not exit0')
    need(outcome['screen_log_sha256'] == anchor['screen_log_sha256'] == hashlib.sha256(log).hexdigest(),
         'terminal log identity mismatch')
    terminal = outcome['terminal_tool_result']
    need(type(terminal) is dict and type(terminal.get('exit_code')) is int and terminal['exit_code'] == 0,
         'missing successful terminal tool result')
    need('session_id' not in terminal or terminal['session_id'] is None,
         'terminal result still reports a running session')
    need(terminal.get('output') == '', 'unexpected unredirected launcher output')


def verify_new_imports(before, allowed, local_names=()):
    for name, module in tuple(sys.modules.items()):
        if name in before and name not in local_names:
            continue
        filename = getattr(module, '__file__', None)
        if filename and Path(filename).resolve().is_relative_to(ROOT):
            need(Path(filename).resolve() in allowed, 'unexpected repository import: ' + str(filename))


def load(loader_commit, anchor_commit):
    full_commit(loader_commit)
    full_commit(anchor_commit)
    manifest_files(HERE, loader_commit)
    binding = read(HERE / 'binding.json')
    need(binding['producer_path'] == PRODUCER.relative_to(ROOT).as_posix(), 'producer path changed')
    producer_paths = manifest_files(PRODUCER, binding['producer_commit'], binding['producer_manifest_sha256'])
    analysis_paths = manifest_files(ANALYSIS, binding['analysis_commit'], binding['analysis_manifest_sha256'])
    source_inputs = read(ANALYSIS / 'source_inputs.json')
    need(source_inputs['proposal_commit'] == binding['proposal_commit'] and
         source_inputs['proof_commit'] == binding['proof_commit'], 'analysis ancestry differs')
    for name, record in source_inputs['files'].items():
        committed(binding['proposal_commit'], ROOT / name, record['sha256'], record['bytes'])
    for name in ('audit.py', 'pins.py', 'screen_contract.py', 'row_guard.py', 'placement.py'):
        need((PRODUCER / name).resolve() in producer_paths, 'missing producer import source')
    need((ANALYSIS / 'summarize.py').resolve() in analysis_paths, 'missing analysis implementation')

    anchor_path = ANALYSIS / 'completed-raw-anchor.json'
    anchor = json.loads(committed(anchor_commit, anchor_path), object_pairs_hook=unique)
    validate_anchor(anchor, binding)
    manifest_path = PRODUCER / binding['raw_manifest']
    raw = json.loads(committed(anchor['raw_commit'], manifest_path, anchor['raw_manifest_sha256']), object_pairs_hook=unique)
    validate_raw_manifest(raw)
    for name, record in raw['files'].items():
        committed(anchor['raw_commit'], manifest_path.parent / name, record['sha256'], record['bytes'])
    log = committed(anchor['raw_commit'], PRODUCER / binding['launcher_log'], anchor['screen_log_sha256'])
    outcome = json.loads(committed(anchor['raw_commit'], PRODUCER / binding['terminal_outcome'],
        anchor['execution_outcome_sha256']), object_pairs_hook=unique)
    validate_terminal(outcome, anchor, binding, log)

    old_path = list(sys.path)
    local_names = {p.stem for p in PRODUCER.glob('*.py')}
    previous = {name:sys.modules[name] for name in local_names if name in sys.modules}
    before = set(sys.modules)
    try:
        for name in local_names:
            sys.modules.pop(name, None)
        sys.path.insert(0, str(PRODUCER))
        audit = importlib.import_module('audit')
        need(Path(audit.__file__).resolve() == PRODUCER / 'audit.py', 'wrong audit import')
        metadata, records = audit.load_complete(anchor['raw_commit'], anchor['raw_manifest_sha256'])
        need(metadata['complete'] is True and metadata['source_commit'] == binding['producer_commit'],
             'audit returned incomplete or different producer')
        verify_new_imports(before, producer_paths, local_names)
    finally:
        sys.path[:] = old_path
        for name in local_names:
            sys.modules.pop(name, None)
        sys.modules.update(previous)
    before_analysis = set(sys.modules)
    spec = importlib.util.spec_from_file_location('cpp616_frozen_analysis', ANALYSIS / 'summarize.py')
    analysis = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(analysis)
    verify_new_imports(before_analysis, analysis_paths)
    return analysis, metadata, records, read(manifest_path.parent / 'quality.json'), dict(
        loader_commit=loader_commit, anchor_commit=anchor_commit, source_binding=binding,
        completed_raw_anchor=anchor, terminal_outcome=outcome)


def validate_quality_agreement(result, links):
    need(links['api_record_count'] == 128 and links['known_mapping_record_count'] == 108 and
         links['calibration_rows'] == 128 and links['reuse_rows'] == 488 and links['pooling'] is False,
         'producer quality counts changed')
    producer = {(r['point_id'], r['seed']):r for r in links['api_records']}
    calculated = {(r['point_id'], r['seed']):r for r in result['quality']}
    need(len(producer) == len(links['api_records']) == len(calculated) == len(result['quality']) == 128 and
         set(producer) == set(calculated), 'analysis/producer quality sets differ')
    fields = ('point_id', 'mapping_id', 'keys', 'seed', 'actual_bytes', 'calibration_negatives',
              'calibration_fp', 'calibration_digest', 'source_case_index', 'source_row_index', 'reuse_case_indices')
    for key, original in producer.items():
        actual = calculated[key]
        need(all(actual[k] == original[k] for k in fields), 'analysis/producer quality links differ')
        need(all(actual['insertion_identity'][k] == original[k] for k in actual['insertion_identity']),
             'analysis/producer construction identity differs')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--loader-commit', required=True)
    parser.add_argument('--anchor-commit', required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    need(not args.output.exists() and not args.output.is_symlink(), 'preserve prior report')
    analysis, metadata, records, links, provenance = load(args.loader_commit, args.anchor_commit)
    result = analysis.calculate(records, analysis.sources())
    validate_quality_agreement(result, links)
    summary = analysis.write_report(result, args.output)
    provenance.update(placement=metadata['placement'], producer_counts=metadata['counts'])
    (args.output / 'provenance.json').write_text(json.dumps(provenance, indent=2, allow_nan=False) + '\n')
    print(json.dumps(summary, sort_keys=True))


if __name__ == '__main__':
    main()
