#!/usr/bin/env python3
"""Complete-only historical selector loader. Never launches a BF/compiler."""
import argparse
import csv
import hashlib
import importlib
import json
import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PRODUCER = ROOT/'experiments/2026-10-29-poppy-public-speed-screen'
ANALYSIS = ROOT/'experiments/2026-10-29-poppy-public-speed-analysis'
CALLER = ROOT/'experiments/2026-10-29-poppy-public-speed-caller'
CATALOG = ROOT/'experiments/2026-10-29-poppy-public-speed-plan/selection.json'
BRIDGE = ROOT/'experiments/2026-10-29-fastbloom-rs-raw8-screen-plan/POPPY_BRIDGE.md'
SOURCE_FILES = {'PLAN.md', 'protocol.json', 'selector.py', 'run.py', 'test_selector.py', 'test_loader.py',
                'README.md', '.gitattributes', '.gitignore', 'offline-tests.stdout', 'offline-tests.stderr'}
COMMITS = dict(raw_commit='50e08fbb1e61bc6bd2f712a7e00d74b36ddb9bb1',
               analysis_commit='13846756061ab78cbc8d9aa36b1983f6ecf38f08',
               scope_commit='92ddef80ffa4021cd6f7e9c5e53576e5cb55a731',
               producer_commit='3c2be48860b52fc55e50aff1170f30724db772da',
               catalog_commit='4d2b7f69d941991f3a9f4cebeb2c7c87514cd8f0',
               bridge_rule_commit='a52429020ae07b01c95fc33caf669b9a09162b32')


def need(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def exact(commit, path):
    need(re.fullmatch('[0-9a-f]{40}', commit) is not None, 'Full immutable commit required')
    need(path.resolve().is_relative_to(ROOT) and not path.is_symlink(), 'Source path escape/symlink')
    expected = subprocess.check_output(['git', 'show', commit+':'+str(path.relative_to(ROOT))], cwd=ROOT)
    need(path.read_bytes() == expected, 'Changed committed artifact: '+str(path))
    return expected


def inventory(commit, directory, manifest_name, count, expected_names=None):
    manifest = directory/manifest_name
    document = json.loads(exact(commit, manifest))
    need(len(document['files']) == count, 'Changed inventory cardinality')
    if expected_names is not None:
        need(set(document['files']) == expected_names, 'Changed exact inventory')
    for name, item in document['files'].items():
        path = directory/name
        need(path.resolve().is_relative_to(directory) and not path.is_symlink(), 'Inventory path escape/symlink')
        exact(commit, path)
        digest = item if isinstance(item, str) else item['sha256']
        need(sha(path) == digest, 'Inventory digest differs')
        if isinstance(item, dict):
            need(path.stat().st_size == item['bytes'], 'Inventory length differs')
    return document


def own_source(commit):
    document = inventory(commit, HERE, 'PREPARATION.json', len(SOURCE_FILES), SOURCE_FILES)
    protocol = json.loads((HERE/'protocol.json').read_text())
    need(all(protocol[k] == v for k, v in COMMITS.items()), 'Changed fixed historical anchors')
    need(protocol['raw8_partial_inputs'] is False and protocol['compiler_or_bf_execution'] is False, 'Wrong selector scope')
    return document, protocol


def load_inputs():
    # No local producer import occurs before every importable source is bound.
    producer_prep = inventory(COMMITS['producer_commit'], PRODUCER, 'PREPARATION.json', 19)
    binding = json.loads((PRODUCER/'proof-binding.json').read_text())
    need(binding['complete'] is True and binding['proof_commit'] == 'c9c8aa1905b72a88ea155ca2ff9ee9664d14f5a0', 'Wrong actual caller proof')
    proof = inventory(binding['proof_commit'], CALLER, 'COMPLETE_PROOF_ARCHIVE.json', 329)
    need(proof['complete'] is True and sha(CALLER/'COMPLETE_PROOF_ARCHIVE.json') == binding['archive_sha256'], 'Changed caller proof seal')
    for name in ('preflight/guard.py', 'preflight/bindings.py'):
        need(name in proof['files'], 'Unbound producer import')
    catalog = json.loads(exact(COMMITS['catalog_commit'], CATALOG))
    exact(COMMITS['bridge_rule_commit'], BRIDGE)

    old_analysis = inventory(COMMITS['analysis_commit'], ANALYSIS, 'ARCHIVE.json', 17)
    need(old_analysis['producer_commit'] == COMMITS['producer_commit'] and old_analysis['raw_commit'] == COMMITS['raw_commit'], 'Analysis ancestry drift')
    scope = inventory(COMMITS['scope_commit'], ANALYSIS, 'SCOPE_ARCHIVE.json', 1, {'CALLER_SCOPE.md'})
    need(scope['parent_analysis_commit'] == COMMITS['analysis_commit'], 'Scope parent drift')
    anchor = json.loads((ANALYSIS/'completed-raw-anchor.json').read_text())
    need(anchor['complete'] is True and anchor['raw_commit'] == COMMITS['raw_commit'] and anchor['producer_commit'] == COMMITS['producer_commit'], 'Incomplete/changed old raw anchor')
    rawdir = PRODUCER/'results-v1'
    raw_names = {'metadata.json', 'records.json', 'results.csv', 'quality.json', 'quality-links.json'} | {f'case-{i:02d}.{stream}' for i in range(36) for stream in ('stdout', 'stderr')}
    raw = inventory(COMMITS['raw_commit'], rawdir, 'RAW_ARCHIVE.json', 77, raw_names)
    need(raw['source_commit'] == COMMITS['producer_commit'] and sha(rawdir/'RAW_ARCHIVE.json') == anchor['raw_manifest_sha256'], 'Changed complete raw seal')
    exact(COMMITS['raw_commit'], PRODUCER/'screen-run.log')
    need(sha(PRODUCER/'screen-run.log') == anchor['screen_log_sha256'], 'Changed original whole-operation log')
    need(sha(PRODUCER/'ANALYSIS_RULES.json') == anchor['analysis_rules_sha256'], 'Changed original rules')

    # Fresh process; reject preloaded same-name modules from another experiment.
    names = {'audit', 'plan', 'pins', 'placement', 'screen_contract', 'guard', 'bindings'}
    need(not names.intersection(sys.modules), 'Ambiguous preloaded producer import')
    sys.path.insert(0, str(PRODUCER))
    audit = importlib.import_module('audit')
    metadata, records, counts = audit.load_complete(COMMITS['producer_commit'])
    for name in names:
        module = sys.modules.get(name)
        if module is not None:
            base = CALLER/'preflight' if name in ('guard', 'bindings') else PRODUCER
            need(Path(module.__file__).resolve() == base/(name+'.py'), 'Wrong actual producer import: '+name)
    contract = importlib.import_module('screen_contract')
    repeated_counts, observations, _ = contract.validate_records(records)
    need(counts == repeated_counts and counts['rows'] == 486, 'Incomplete original producer replay')
    archived = json.loads((ANALYSIS/'report-v1/all-records.json').read_text())
    provenance = dict(**COMMITS, source_inventory_sha256=sha(PRODUCER/'PREPARATION.json'),
                      raw_inventory_sha256=sha(rawdir/'RAW_ARCHIVE.json'), analysis_inventory_sha256=sha(ANALYSIS/'ARCHIVE.json'),
                      scope_inventory_sha256=sha(ANALYSIS/'SCOPE_ARCHIVE.json'), bridge_rule_sha256=sha(BRIDGE),
                      catalog_sha256=sha(CATALOG), producer_audit_counts=counts,
                      original_complete=metadata['complete'], original_finished=metadata['finished'],
                      old_contract_scope_path=str((ANALYSIS/'CALLER_SCOPE.md').relative_to(ROOT)),
                      future_qualification='unmeasured; no historical counts or latency transferred')
    return catalog, records, observations, archived, provenance


def csv_file(path, rows):
    need(bool(rows), 'Empty fixed table')
    with path.open('w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0]), lineterminator='\n')
        writer.writeheader()
        for row in rows:
            writer.writerow({k: json.dumps(v, separators=(',', ':')) if isinstance(v, (list, dict)) else v for k, v in row.items()})


def report(data):
    c = data['counts']
    lines = ['# Historical Poppy shortlist for the natural-input bridge', '',
             f"The complete historical panel selects {c['selected_geometries']} of 47 constructions across all 864 views; {c['null_views']} views have no historically eligible Poppy point. All 20,304 alternatives remain. Exactly {c['future_public_forms']} proposed input-form entries retain both natural byte8 and typed-u64 APIs.", '',
             'These old timings and cal26 gates are used only to choose a finite follow-up panel. They do not qualify either future raw-input mapping, rank it against raw8 libraries, or establish an optimum for the previously unmeasured typed path. Contracts and rounds remain separate; every exact tie is retained.', '',
             '| Configuration | n | Bucket bytes | Cache bytes | Total bytes | Supporting views |',
             '|---|---:|---:|---:|---:|---:|']
    for p in data['union']:
        lines.append(f"| {p['configuration_id']} | {p['keys']} | {p['bucket_bytes']} | {p['cache_bytes']} | {p['actual_bytes']} | {len(p['supporting_views'])} |")
    lines += ['', 'Every public constructor is copied with its exact f64 FPP bit pattern, original n, bucket/probe/cache configuration and alias provenance. The complete 47-point catalog and original over-cap exclusions remain in all-records.json. Distinct future form IDs distinguish input contracts; they do not assert pairwise mathematical mapping independence.', '',
              'Old whole-input hash scratch was allocated outside the build clocks (up to 256 MiB); later old build repetitions checked only min(n,batch) inserted keys. Those historical construction metrics are not the new raw8 complete-build contract. The future caller must retain zero common-hash scratch for both natural Poppy paths, charged upstream hashing and Result handling, all-inserted no-FN checks, poisoned dense outputs and fresh separate quality records.', '',
              'No raw8 partial or complete timing table is an input here. Its eventual strongest-control selection remains a separate complete-only stage. No compiler, filter construction, calibration or throughput run occurs in this selector.', '']
    return '\n'.join(lines)


def main():
    need(__debug__, 'Python -O forbidden')
    p = argparse.ArgumentParser()
    p.add_argument('--source-commit', required=True)
    p.add_argument('--output', type=Path, required=True)
    args = p.parse_args()
    need(not args.output.exists() and not args.output.is_symlink(), 'Preserve previous selector output')
    own_source(args.source_commit)
    from selector import calculate, compare_archived
    catalog, records, quality, archived, provenance = load_inputs()
    data = calculate(catalog, records, quality)
    compare_archived(data, archived)
    provenance['selector_commit'] = args.source_commit
    provenance['selector_inventory_sha256'] = sha(HERE/'PREPARATION.json')
    data['provenance'] = provenance
    own_source(args.source_commit)
    args.output.mkdir()
    for name in ('views', 'alternatives', 'quality', 'catalog'):
        csv_file(args.output/(name+'.csv'), data[name])
    for name in ('union', 'future_public_forms'):
        (args.output/(name+'.json')).write_text(json.dumps(data[name], indent=2, allow_nan=False)+'\n')
    (args.output/'all-records.json').write_text(json.dumps(data, indent=2, allow_nan=False)+'\n')
    (args.output/'REPORT.md').write_text(report(data))
    print(json.dumps(data['counts'], sort_keys=True))


if __name__ == '__main__':
    main()
