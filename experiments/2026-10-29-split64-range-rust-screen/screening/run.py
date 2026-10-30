#!/usr/bin/env python3
"""Execute only the frozen120-row exact-capacity training protocol, after approval."""
if not __debug__:
    raise ValueError('Run without Python -O')
import argparse
import csv
import io
import json
import os
from pathlib import Path
import platform
import subprocess
import time

from freeze import ARCHIVE, FROZEN, HERE, ROOT, STAGE, save, sha, verify, verify_archive, verify_commit
from guard import expected_order, raw_intervals, require, validate_all, validate_protocol, validate_rows
from source_guard import require_lease


def command_for(case, protocol):
    return ['taskset', '-c', str(protocol['cpu']), protocol['binary'], str(case['key_power']),
            str(case['budget_bpk']), str(protocol['hit_percent']), str(protocol['query_power']),
            str(case['batch']), str(protocol['repeats']), str(case['seed']), ','.join(case['filters']),
            str(1 << case['key_power']), str(protocol['calibration_power'])]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit', required=True)
    parser.add_argument('--execute-frozen', action='store_true', required=True)
    args = parser.parse_args()
    protocol = json.loads((HERE / 'protocol.json').read_text())
    registry = json.loads((STAGE / 'registry.json').read_text())
    source = (STAGE / 'benchmark/src/main.rs').read_text()
    validate_protocol(protocol, registry, source)
    frozen = json.loads(FROZEN.read_text())
    require(frozen['binaries'][0]['path'] == protocol['binary'] and frozen['binaries'][0]['sha256'] == protocol['binary_sha256'], 'Wrong timing executable')
    verify(frozen)
    verify_archive()
    verify_commit(args.source_commit, frozen)
    lease = require_lease(protocol['cpu'], protocol['socket_lock'])
    output = STAGE / 'screen'
    output.mkdir(parents=True, exist_ok=False)
    frozen_sha, archive_sha = sha(FROZEN), sha(ARCHIVE)
    metadata = dict(complete=False, source_commit=args.source_commit, freeze_sha256=frozen_sha,
                    archive_sha256=archive_sha, binary_sha256=protocol['binary_sha256'],
                    protocol_sha256=sha(HERE / 'protocol.json'), lease=lease,
                    affinity=sorted(os.sched_getaffinity(0)), numa_policy=protocol['numa_policy'],
                    host=platform.uname()._asdict(), compiler_flags=protocol['compiler_flags'],
                    command_environment={k: os.environ.get(k) for k in ('BF_SOCKET_LEASE', 'LD_PRELOAD', 'LD_LIBRARY_PATH', 'MALLOC_CONF', 'MALLOC_ARENA_MAX', 'RUSTFLAGS')},
                    started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), commands=[])
    require(not metadata['command_environment']['LD_PRELOAD'], 'Unfrozen preload may alter execution')
    save(output / 'metadata.json', metadata)
    all_rows = []
    for case in protocol['cases']:
        verify(frozen, dependencies=False, all_binaries=False)
        tag = 'k{key_power}-p{budget_bpk}-b{batch}-s{seed}'.format(**case)
        command = command_for(case, protocol)
        record = dict(case=case, command=command, complete=False,
                      expected_filter_order=expected_order(case, protocol, source), raw_input_intervals=raw_intervals(case, protocol))
        metadata['commands'].append(record)
        save(output / 'metadata.json', metadata)
        started = time.monotonic()
        result = subprocess.run(command, cwd=ROOT, capture_output=True)
        raw = output / (tag + '.csv')
        stderr = output / (tag + '.stderr.log')
        raw.write_bytes(result.stdout)
        stderr.write_bytes(result.stderr)
        record.update(returncode=result.returncode, elapsed_seconds=time.monotonic()-started,
                      csv_sha256=sha(raw), stderr_sha256=sha(stderr))
        save(output / 'metadata.json', metadata)
        require(result.returncode == 0, 'Benchmark failed: ' + tag)
        require(result.stderr.decode().strip() == 'sbbf-rs 0.2.8 backend: Avx2Filter', 'Unexpected backend/diagnostic')
        rows = list(csv.DictReader(io.StringIO(result.stdout.decode())))
        validate_rows(rows, case, protocol, source)
        all_rows.extend(rows)
        with (output / 'results.csv').open('w', newline='') as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator='\n')
            writer.writeheader()
            writer.writerows(all_rows)
        record.update(complete=True, rows=len(rows), filter_order=[row['filter'] for row in rows])
        save(output / 'metadata.json', metadata)
        print(tag + ': ' + str(len(rows)) + ' exact ordered rows; geometry and four-mode vectors passed', flush=True)
    counts = validate_all(all_rows, protocol, registry, source)
    # Re-read each raw case and aggregate before marking a complete run.
    observed = []
    for record in metadata['commands']:
        tag = 'k{key_power}-p{budget_bpk}-b{batch}-s{seed}'.format(**record['case'])
        raw, stderr = output / (tag + '.csv'), output / (tag + '.stderr.log')
        require(sha(raw) == record['csv_sha256'] and sha(stderr) == record['stderr_sha256'], 'Changed raw artifact')
        require(record['command'] == command_for(record['case'], protocol), 'Changed recorded command')
        observed.extend(csv.DictReader(io.StringIO(raw.read_text())))
    aggregate = list(csv.DictReader(io.StringIO((output / 'results.csv').read_text())))
    require(observed == aggregate == all_rows, 'Raw/aggregate exactness mismatch')
    verify(frozen)
    verify_archive()
    verify_commit(args.source_commit, frozen)
    require(sha(FROZEN) == frozen_sha and sha(ARCHIVE) == archive_sha, 'Freeze/archive changed')
    metadata.update(complete=True, **counts, results_sha256=sha(output / 'results.csv'),
                    final_sources_dependencies_binaries_equal=True,
                    finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()))
    save(output / 'metadata.json', metadata)
    print('PASS120 rows /18 cases;40 family/geometry/size/seed calibration records, no pooling', flush=True)


if __name__ == '__main__':
    main()
