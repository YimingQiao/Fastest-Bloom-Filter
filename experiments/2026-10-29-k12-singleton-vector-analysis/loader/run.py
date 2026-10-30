#!/usr/bin/env python3
"""Additive complete-archive entry point for the frozen singleton192 rules."""
import argparse
import hashlib
import importlib
import importlib.util
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ANALYSIS = HERE.parent
ROOT = ANALYSIS.parents[1]
PRODUCER = ROOT / 'experiments/2026-10-29-k12-singleton-vector-plan/screening'


def need(condition, message):
    if not condition:
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
    need(type(value) is str and len(value) == 40 and
         set(value) <= set('0123456789abcdef'), 'full immutable commit required')


def digest(value):
    need(type(value) is str and len(value) == 64 and
         set(value) <= set('0123456789abcdef'), 'SHA256 required')


def committed(commit, path, expected=None):
    full_commit(commit)
    path = Path(path).resolve()
    need(path.is_relative_to(ROOT), 'repository path escaped')
    data = path.read_bytes()
    if expected is not None:
        digest(expected)
        need(hashlib.sha256(data).hexdigest() == expected, 'artifact SHA mismatch')
    blob = subprocess.check_output(['git', 'show',
        commit + ':' + path.relative_to(ROOT).as_posix()], cwd=ROOT)
    need(blob == data, 'committed artifact bytes differ')


def manifest_files(stage, commit, expected_manifest, descriptor_objects):
    manifest = stage / 'PREPARATION.json'
    committed(commit, manifest, expected_manifest)
    files = read(manifest)['files']
    need(type(files) is dict and files, 'empty source inventory')
    paths = {manifest.resolve()}
    for name, descriptor in files.items():
        need(type(name) is str and not Path(name).is_absolute(), 'absolute source name')
        path = (stage / name).resolve()
        need(path.is_relative_to(stage.resolve()) and path not in paths, 'escaped/duplicate source')
        expected = descriptor['sha256'] if descriptor_objects else descriptor
        committed(commit, path, expected)
        if descriptor_objects:
            need(type(descriptor['bytes']) is int and path.stat().st_size == descriptor['bytes'],
                 'source length mismatch')
        paths.add(path)
    return paths


def validate_anchor(anchor, binding):
    need(binding.get('complete') is True, 'producer binding not finalized')
    need(type(anchor) is dict and set(anchor) == {
        'complete', 'producer_commit', 'raw_commit', 'raw_manifest_sha256', 'screen_log_sha256'},
        'raw anchor schema differs')
    need(anchor['complete'] is True and anchor['producer_commit'] == binding['producer_commit'],
         'incomplete or wrong-producer raw anchor')
    full_commit(anchor['producer_commit'])
    full_commit(anchor['raw_commit'])
    digest(anchor['raw_manifest_sha256'])
    digest(anchor['screen_log_sha256'])


def load():
    binding = read(HERE / 'binding.json')
    anchor_path = ANALYSIS / 'completed-raw-anchor.json'
    need(anchor_path.is_file(), 'complete committed raw anchor unavailable')
    anchor = read(anchor_path)
    validate_anchor(anchor, binding)
    analysis_paths = manifest_files(ANALYSIS, binding['analysis_commit'],
                                    binding['analysis_manifest_sha256'], False)
    producer_paths = manifest_files(PRODUCER, binding['producer_commit'],
                                    binding['producer_manifest_sha256'], True)
    # Import only source that has already passed exact committed-blob checks.
    for required in ('audit.py', 'pins.py', 'screen_contract.py', 'placement.py'):
        need((PRODUCER / required).resolve() in producer_paths, 'missing producer import source')
    need((ANALYSIS / 'summarize.py').resolve() in analysis_paths, 'missing frozen analysis source')
    local_python = {p.resolve() for p in PRODUCER.glob('*.py')}
    need(local_python <= producer_paths, 'unprepared local producer Python source')
    raw_manifest = PRODUCER / 'results-v1/RAW_ARCHIVE.json'
    committed(anchor['raw_commit'], raw_manifest, anchor['raw_manifest_sha256'])
    committed(anchor['raw_commit'], PRODUCER / 'screen-run.log', anchor['screen_log_sha256'])
    old_path = list(sys.path)
    local_names = {p.stem for p in local_python}
    previous = {name: sys.modules[name] for name in local_names if name in sys.modules}
    before_modules = set(sys.modules)
    try:
        for name in local_names:
            sys.modules.pop(name, None)
        sys.path.insert(0, str(PRODUCER))
        audit = importlib.import_module('audit')
        need(Path(audit.__file__).resolve() == (PRODUCER / 'audit.py').resolve(), 'wrong audit module')
        metadata, records = audit.load_complete(anchor['raw_commit'], anchor['raw_manifest_sha256'])
        need(metadata['complete'] is True and metadata['source_commit'] == binding['producer_commit'],
             'producer returned incomplete or different-source records')
        for name, module in tuple(sys.modules.items()):
            if name in before_modules and name not in local_names:
                continue
            filename = getattr(module, '__file__', None)
            if filename and Path(filename).resolve().is_relative_to(ROOT):
                need(Path(filename).resolve() in producer_paths, 'unexpected repository import')
    finally:
        sys.path[:] = old_path
        for name in local_names:
            sys.modules.pop(name, None)
        sys.modules.update(previous)
    spec = importlib.util.spec_from_file_location('singleton192_frozen_analysis', ANALYSIS / 'summarize.py')
    analysis = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(analysis)
    return analysis, metadata, records, anchor


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    need(not args.output.exists(), 'preserve previous output')
    analysis, metadata, records, anchor = load()
    result = analysis.calculate(records, analysis.ledger())
    args.output.mkdir(parents=True)
    for name, rows in result.items():
        analysis.write_csv(args.output / (name.replace('_', '-') + '.csv'), rows)
    summary = dict(complete=True, raw_anchor=anchor, analysis_binding=read(HERE / 'binding.json'),
                   counts={name: len(rows) for name, rows in result.items()},
                   placement=metadata['placement'],
                   scope='fixed per-condition observations; no pooled independent win rate')
    (args.output / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    (args.output / 'REPORT.md').write_text(analysis.render(result))
    print(json.dumps(summary))


if __name__ == '__main__':
    main()
