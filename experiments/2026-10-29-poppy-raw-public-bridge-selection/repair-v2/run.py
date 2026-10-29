#!/usr/bin/env python3
"""One-field cache-unit repair; original historical audit/selection preserved."""
import argparse
import difflib
import hashlib
import importlib.util
import json
import re
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
ROOT = PARENT.parents[1]
ORIGINAL = '228cf5fb2d0dfc39d748c33617cd53e6b748f869'
FAILED = '3efa4a9385272f0bf1f6df38ba67f23401a34255'
FILES = {'selector.py', 'SELECTOR.patch', 'run.py', 'test_repair.py', 'README.md', 'offline-tests.stdout', 'offline-tests.stderr'}


def need(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def exact(commit, path):
    need(re.fullmatch('[0-9a-f]{40}', commit), 'Full commit required')
    need(path.resolve().is_relative_to(ROOT) and not path.is_symlink(), 'Path escape/symlink')
    data = subprocess.check_output(['git', 'show', commit+':'+str(path.relative_to(ROOT))], cwd=ROOT)
    need(path.read_bytes() == data, 'Committed bytes changed: '+str(path))
    return data


def inventory(commit, directory, name, count, names=None):
    value = json.loads(exact(commit, directory/name))
    need(len(value['files']) == count and (names is None or set(value['files']) == names), 'Inventory changed')
    for relative, item in value['files'].items():
        path = directory/relative
        need(path.resolve().is_relative_to(directory), 'Inventory escape')
        data = exact(commit, path)
        need(len(data) == item['bytes'] and hashlib.sha256(data).hexdigest() == item['sha256'], 'Artifact changed')
    return value


def derived(old, new, patch):
    needle = "[point['keys'], value['buckets'], value['cache_bits'], value['probes']]"
    need(old.count(needle) == 1, 'Ambiguous original assertion')
    need(new == old.replace(needle, "[point['keys'], value['buckets'], value['cache_bytes'], value['probes']]"), 'More than one field changed')
    need(patch == ''.join(difflib.unified_diff(old.splitlines(True), new.splitlines(True), fromfile='frozen/selector.py', tofile='repair-v2/selector.py')), 'Patch drift')


def verify(commit):
    inventory(commit, HERE, 'PREPARATION.json', 7, FILES)
    inventory(ORIGINAL, PARENT, 'PREPARATION.json', 11)
    failed = inventory(FAILED, PARENT, 'FAILED_V1_ARCHIVE.json', 4)
    need(failed['complete'] is False and failed['source_commit'] == ORIGINAL, 'Wrong preserved failure')
    outcome = json.loads((PARENT/'execution-outcome-v1.json').read_text())
    need(outcome['session_id'] == 73941 and outcome['exit_code'] == 1 and outcome['selection_directory_created'] is False, 'Wrong original terminal state')
    need(not (PARENT/'selection-v1').exists(), 'Unexpected V1 result')
    derived((PARENT/'selector.py').read_text(), (HERE/'selector.py').read_text(), (HERE/'SELECTOR.patch').read_text())


def main():
    need(__debug__, 'Python -O forbidden')
    p = argparse.ArgumentParser()
    p.add_argument('--source-commit', required=True)
    p.add_argument('--output', type=Path, required=True)
    args = p.parse_args()
    need(not args.output.exists() and not args.output.is_symlink(), 'Preserve prior outputs')
    verify(args.source_commit)
    spec = importlib.util.spec_from_file_location('frozen_poppy_bridge_loader', PARENT/'run.py')
    parent = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(parent)
    from selector import calculate, compare_archived
    catalog, records, observations, archived, provenance = parent.load_inputs()
    data = calculate(catalog, records, observations)
    compare_archived(data, archived)
    provenance.update(selector_commit=args.source_commit, original_selector_commit=ORIGINAL, failed_attempt_commit=FAILED,
                      selector_inventory_sha256=sha(HERE/'PREPARATION.json'),
                      correction='Only source_mapping cache_bytes assertion; selection/quality rules unchanged')
    data['provenance'] = provenance
    verify(args.source_commit)
    args.output.mkdir()
    for name in ('views', 'alternatives', 'quality', 'catalog'):
        parent.csv_file(args.output/(name+'.csv'), data[name])
    for name in ('union', 'future_public_forms'):
        (args.output/(name+'.json')).write_text(json.dumps(data[name], indent=2, allow_nan=False)+'\n')
    (args.output/'all-records.json').write_text(json.dumps(data, indent=2, allow_nan=False)+'\n')
    (args.output/'REPORT.md').write_text(parent.report(data))
    print(json.dumps(data['counts'], sort_keys=True))


if __name__ == '__main__':
    main()
