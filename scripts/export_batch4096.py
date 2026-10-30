#!/usr/bin/env python3
"""Export the fixed batch4096 publication slice from a research checkout."""
import argparse
import hashlib
import json
from pathlib import Path

REVISION = '551a3a4c648df223e29305cf89418e48a553c577'
SOURCE = 'docs/benchmark-top3-2026-10-30/rankings.json'
SOURCE_SHA256 = 'b67918f01b0c8f762c80ba5e53c44c2c57a978342704402dbf71f949e2f763d9'
ROOT = Path(__file__).resolve().parents[1]


def selected(row):
    if row['batch'] != 4096:
        return False
    condition = (row['cap_bpk'], row['fpr_ceiling'])
    panel, metric = row['panel'], row['metric']
    if panel == 'CPP988':
        return condition in [(16, .01), (16, .001)] and metric in ['lookup_ns', 'hash_lookup_ns']
    if panel == 'CPP_K12_primary24':
        return condition == (24, .0001) and metric in ['lookup_ns', 'hash_lookup_ns']
    if panel == 'Rust786':
        return condition in [(16, .01), (16, .001), (24, .0001)] and metric == 'raw_batched_public'
    if panel == 'CPP_MT195':
        return condition in [(16, .01), (16, .001), (24, .0001)] and metric in [
            'parallel_lookup_end_to_end_ns', 'parallel_hash_lookup_end_to_end_ns']
    return False


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('research_checkout', type=Path)
    args = parser.parse_args()
    raw = (args.research_checkout / SOURCE).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == SOURCE_SHA256, "Research ranking snapshot differs"
    data = json.loads(raw)
    manifest = json.loads((args.research_checkout / 'docs/benchmark-top3-2026-10-30/INPUTS.json').read_text())
    paths = [p for p in manifest['source_sha256'] if any(part in p for part in [
        'exact-budget-range/screen/', 'fastbloom-rs-raw8-analysis/',
        'four-sector-range12-strict24-analysis/', 'native-k12-parallel-analysis/'])]
    for path in paths:
        assert hashlib.sha256((args.research_checkout / path).read_bytes()).hexdigest() == manifest['source_sha256'][path], path
    output = dict(
        schema_version=1,
        provenance=dict(research_revision=REVISION, source_path=SOURCE,
                        source_sha256=hashlib.sha256(raw).hexdigest(),
                        input_sha256={p: manifest['source_sha256'][p] for p in paths}),
        scenarios=[s for s in data['scenarios'] if selected(s)],
        all_eligible_configurations=[r for r in data['all_eligible_configurations'] if selected(r)])
    assert len(output['scenarios']) == 30
    (ROOT / 'benchmarks/results/batch4096.json').write_text(json.dumps(output, indent=2) + '\n')
    print(f"Exported {len(output['scenarios'])} scenarios, {len(output['all_eligible_configurations'])} eligible configurations")


if __name__ == '__main__':
    main()
