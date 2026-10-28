#!/usr/bin/env python3
"""Run the committed, training-selected subset using the unchanged frozen74 binary."""
import argparse
import csv
import io
import json
import subprocess
import time
from pathlib import Path

from guards import (HERE,ROOT,PARENT,command_for,require,require_lease,sha,validate_cases,
                    verify_confirmation_commit,verify_parent,verify_training)
from make_plan import derive


def parse_case_rows(stdout, case):
    rows = list(csv.DictReader(io.StringIO(stdout)))
    require(len(rows) == len(case['filters']), 'Command returned an empty or partial case')
    names = [r.get('filter') for r in rows]
    require(len(set(names)) == len(names) and set(names) == set(case['filters']), 'Command returned duplicate or unexpected filters')
    return rows


def main():
    require(__debug__, 'Do not run the confirmation with Python -O')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit', required=True, help='Exact commit containing this complete confirmation archive')
    parser.add_argument('--lease', choices=['socket1'], required=True)
    parser.add_argument('--cpu', type=int, choices=[3], required=True)
    parser.add_argument('--output-dir', type=Path, required=True)
    args = parser.parse_args()
    lease = require_lease(args.cpu,args.lease)
    protocol = json.loads((HERE/'protocol.json').read_text())
    plan = json.loads((HERE/'selection.json').read_text())
    require(protocol['cpu'] == args.cpu and protocol['lease'] == args.lease and protocol['socket_lock'] == lease['lock_path'], 'Lease/protocol mismatch')
    committed = verify_confirmation_commit(args.source_commit)
    training = verify_training()
    parent = verify_parent(protocol)
    require(derive() == plan, 'Frozen training-only selection changed')
    require(plan['seeds'] == protocol['seeds'], 'Seed protocol mismatch')
    require(plan['counts']['configurations'] == protocol['selected_configurations'] == 54, 'Unexpected selected geometry count')
    require(plan['counts']['cases'] == protocol['planned_cases'] == 39 and plan['counts']['rows'] == protocol['expected_rows'] == 162, 'Unexpected planned workload count')
    args.output_dir.mkdir(parents=True,exist_ok=False)
    metadata = {'protocol': protocol, 'source_commit': args.source_commit,
                'parent_source_commit': protocol['parent_source_commit'], 'lease': lease,
                'committed_archive': committed, 'parent_archive': parent, 'training_archive': training,
                'selection_sha256': sha(HERE/'selection.json'), 'binary_sha256': sha(ROOT/protocol['binary']),
                'start_utc': time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()), 'cases': [], 'complete': False}
    def write_metadata():
        (args.output_dir/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    write_metadata()
    by_id = {r['configuration_id']:r for r in plan['configurations']}
    all_rows = []
    for index, case in enumerate(plan['cases']):
        # Verify the complete dependency/binary freeze, not just the executable.
        verify_parent(protocol)
        command = command_for(ROOT,protocol,case)
        proc = subprocess.run(command,cwd=ROOT,text=True,capture_output=True)
        stem = f'case-{index:02d}-{case["case_id"]}'
        (args.output_dir/(stem+'.stdout')).write_text(proc.stdout)
        (args.output_dir/(stem+'.stderr')).write_text(proc.stderr)
        require(proc.returncode == 0, f'{stem} failed: {proc.stderr}')
        rows = parse_case_rows(proc.stdout,case)
        expected = {by_id[c]['filter']:by_id[c] for c in case['configuration_ids']}
        for row in rows:
            require(row.get('filter') in expected, 'Unexpected returned filter')
            geometry = expected[row['filter']]
            row.update(configuration_id=geometry['configuration_id'], calibration_identity=geometry['calibration_identity'])
        validate_cases(all_rows+rows,plan,protocol,complete=False)
        all_rows.extend(rows)
        with (args.output_dir/'results.csv').open('w',newline='') as stream:
            writer = csv.DictWriter(stream,fieldnames=list(all_rows[0]),lineterminator='\n')
            writer.writeheader();writer.writerows(all_rows)
        metadata['cases'].append({'case':case,'command':command,'rows':len(rows),
                                  'stdout_sha256':sha(args.output_dir/(stem+'.stdout')),
                                  'stderr_sha256':sha(args.output_dir/(stem+'.stderr'))})
        write_metadata()
        print(f'Validated {index+1}/{len(plan["cases"])} cases; {len(all_rows)}/{protocol["expected_rows"]} rows',flush=True)
    final = validate_cases(all_rows,plan,protocol,complete=True)
    verify_confirmation_commit(args.source_commit);verify_training();verify_parent(protocol)
    metadata.update(complete=True, all_frozen_sources_and_binaries_unchanged=True, validation=final,
                    results_sha256=sha(args.output_dir/'results.csv'), end_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    write_metadata()


if __name__ == '__main__':
    main()
