"""Commit, geometry, sample, and execution-lease guards for confirmation."""
import fcntl
import hashlib
import importlib.util
import json
import os
import re
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = ROOT/'experiments/2026-10-29-exact-budget-range'


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def verify_git_blob(root, path, commit, expected):
    require(bool(re.fullmatch('[0-9a-f]{40}', commit)), 'Exact lowercase 40-character commit required')
    root, path = Path(root).resolve(), Path(path).resolve()
    require(path.is_relative_to(root), 'Archive path escapes repository')
    actual = sha(path)
    require(actual == expected, 'Archive hash mismatch: ' + str(path))
    blob = subprocess.check_output(['git', 'show', commit+':'+path.relative_to(root).as_posix()], cwd=root)
    require(hashlib.sha256(blob).hexdigest() == expected, 'Committed blob mismatch: ' + str(path))


def verify_confirmation_commit(commit):
    require(bool(re.fullmatch('[0-9a-f]{40}', commit)), 'Exact confirmation commit required')
    resolved = subprocess.check_output(['git','rev-parse','--verify',commit+'^{commit}'],cwd=ROOT,text=True).strip()
    require(resolved == commit, 'Confirmation source commit did not resolve exactly')
    manifest = json.loads((HERE/'manifest.json').read_text())
    required = {'protocol.json','selection.json','seeds.json','training-inputs.json','selected-geometries.csv',
                'make_plan.py','guards.py','run_confirmation.py','summarize.py','test_contract.py','README.md','freeze.json'}
    require(required <= set(manifest['files_sha256']), 'Incomplete confirmation manifest')
    for name, digest in manifest['files_sha256'].items():
        path = (HERE/name).resolve()
        require(path.is_relative_to(HERE), 'Manifest path escapes experiment')
        verify_git_blob(ROOT, path, commit, digest)
    verify_git_blob(ROOT, HERE/'manifest.json', commit, sha(HERE/'manifest.json'))
    return {'source_commit': commit, 'inventory_artifacts': len(manifest['files_sha256']),
            'manifest_sha256': sha(HERE/'manifest.json'), 'freeze_sha256': sha(HERE/'freeze.json')}


def verify_training():
    inputs = json.loads((HERE/'training-inputs.json').read_text())['inputs']
    for name, entry in inputs.items():
        verify_git_blob(ROOT, ROOT/name, entry['commit'], entry['sha256'])
    return {'input_artifacts': len(inputs), 'training_inputs_sha256': sha(HERE/'training-inputs.json')}


def verify_parent(protocol, *, live=True):
    freeze = json.loads((PARENT/'freeze.json').read_text())
    anchor = json.loads((HERE/'freeze.json').read_text())
    require(sha(PARENT/'freeze.json') == anchor['parent_freeze_sha256'], 'Parent freeze changed')
    require(sha(PARENT/'manifest.json') == anchor['parent_manifest_sha256'], 'Parent inventory changed')
    require(protocol['binary'] in freeze['binary_sha256'], 'Executable absent from parent freeze')
    require(freeze['binary_sha256'][protocol['binary']] == anchor['binary_sha256'], 'Executable hash anchor mismatch')
    if live:
        for group in ('source_sha256','binary_sha256'):
            for name, digest in freeze[group].items():
                require(sha(ROOT/name) == digest, 'Frozen parent input drift: ' + name)
    parent_guard = module('exact74_source_guard', PARENT/'source_guard.py')
    result = parent_guard.verify_commit_inputs(ROOT, PARENT, protocol['parent_source_commit'], freeze)
    return result | {'live_dependency_and_binary_verification': live}


def require_lease(cpu, lease):
    require(cpu == 3 and lease == 'socket1', 'This confirmation requires --lease socket1 --cpu 3')
    require(os.sched_getaffinity(0) == {3}, 'Pin the entire process to CPU3 using taskset')
    lock = '/tmp/fastest-bf-socket1.lock'
    descriptors = []
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+name) == lock:
                fd = int(name)
                fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
                descriptors.append(fd)
        except FileNotFoundError:
            pass
    require(bool(descriptors), 'The entire matrix must inherit its flock lock descriptor')
    return {'cpu': cpu, 'lease': lease, 'lock_path': lock, 'inherited_lock_descriptors': descriptors}


def command_for(root, protocol, case):
    return ['taskset','-c',str(protocol['cpu']),str(Path(root)/protocol['binary']),str(case['key_power']),str(case['budget_bpk']),
            str(protocol['hit_percent']),str(protocol['query_power']),str(protocol['batch']),str(protocol['query_repeats']),
            str(case['seed']),','.join(case['filters']),str(1 << case['key_power']),str(protocol['calibration_power']),'query-only','0']


def validate_cases(rows, plan, protocol, *, complete):
    """Validate whole cases and shared mapping samples, including across budgets."""
    require(__debug__, 'Parent assertion-based row checks require Python without -O')
    validate = module('exact74_rows', PARENT/'validate_rows.py').validate
    by_id = {r['configuration_id']: r for r in plan['configurations']}
    cases = {(c['seed'],c['key_power'],c['budget_bpk']): c for c in plan['cases']}
    grouped = {}
    seen = set()
    samples = {}
    for r in rows:
        key = (int(r['seed']), int(r['keys']).bit_length()-1, int(r['requested_bpk']))
        require(key in cases, 'Unexpected confirmation seed/workload')
        cid = r['configuration_id']
        require(cid in by_id, 'Unselected effective geometry')
        identity = (int(r['seed']),cid)
        require(identity not in seen, 'Repeated seed/effective configuration')
        seen.add(identity)
        expected = by_id[cid]
        require(r['calibration_identity'] == expected['calibration_identity'], 'Calibration identity changed')
        require(r['filter'] == expected['filter'] and cid in cases[key]['configuration_ids'], 'Configuration placed in wrong case')
        grouped.setdefault(key, []).append(r)
        mapping = (int(r['keys']),int(r['seed']),r['calibration_identity'])
        sample = tuple(r[k] for k in ('calibration_absent_queries','calibration_false_positives','result_checksum','false_positives','absent_queries'))
        require(mapping not in samples or samples[mapping] == sample, 'Equivalent mappings disagree across API/budget cases')
        samples[mapping] = sample
    for key, case_rows in grouped.items():
        case = cases[key]
        expected = {by_id[c]['filter']: by_id[c] for c in case['configuration_ids']}
        validate(case_rows, expected, power=case['key_power'], budget=case['budget_bpk'],
                 query_power=protocol['query_power'], batch=protocol['batch'], repeats=protocol['query_repeats'],
                 seed=case['seed'], calibration_power=protocol['calibration_power'])
    if complete:
        require(set(grouped) == set(cases), 'Missing confirmation cases')
        require(seen == {(s,c) for s in plan['seeds'] for c in by_id}, 'Missing confirmation configuration/seed')
        require(len(rows) == protocol['expected_rows'], 'Wrong completed row count')
    return {'rows': len(rows), 'cases': len(grouped), 'unique_mapping_seed_samples': len(samples)}
