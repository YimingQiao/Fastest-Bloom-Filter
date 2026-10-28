#!/usr/bin/env python3
"""Frozen nine-config CPU3 training screen after independent accuracy gates."""
import csv
import hashlib
import json
import math
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
protocol = json.loads((HERE / 'performance-protocol.json').read_text())
freeze = json.loads((HERE / 'freeze.json').read_text())
confirmation = json.loads((HERE / 'confirmation/accuracy.json').read_text())
assert confirmation['gate_passed'] and confirmation['freeze_sha256'] == sha(HERE / 'freeze.json')
assert sha(HERE / 'freeze.json') == protocol['accuracy_freeze_sha256']
assert protocol['binary_sha256'] == freeze['binary_sha256']
assert protocol['cpu'] == 3 and len(protocol['filters']) == len(set(protocol['filters'])) == 9
inputs = {str(p.relative_to(ROOT)): sha(p) for p in (HERE / 'performance.py', HERE / 'performance-protocol.json', HERE / 'freeze.json')}
def verify():
    for name, digest in {**freeze['source_sha256'], **freeze['binaries'], **inputs}.items():
        assert sha(ROOT / name) == digest, name
verify()
output = HERE / 'performance-training'
assert not output.exists(), 'Refusing to overwrite training evidence'
command = [
    'python3', str(ROOT / 'scripts/run_comparison.py'),
    '--executable', str(ROOT / protocol['binary']), '--output-dir', str(output),
    '--key-powers', ','.join(map(str, protocol['key_powers'])),
    '--bits-per-key', ','.join(map(str, protocol['requested_bpk'])),
    '--hits', str(protocol['hit_percent']), '--batches', ','.join(map(str, protocol['batches'])),
    '--seeds', str(protocol['seed']), '--query-power', str(protocol['query_power']),
    '--repeats', str(protocol['repeats']), '--cpu', str(protocol['cpu']),
    '--filters', ','.join(protocol['filters']), '--insert-batch', '0',
    '--calibration-power', str(protocol['calibration_power']),
]
manifest = dict(utc=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), protocol=protocol,
                runner_inputs_sha256=inputs, command=command, cpu=3,
                no_cross_socket_timing_comparison=True, binary_sha256=freeze['binary_sha256'])
(HERE / 'performance-freeze.json').write_text(json.dumps(manifest, indent=2) + '\n')
subprocess.run(command, cwd=ROOT, check=True)
verify()
rows = list(csv.DictReader((output / 'results.csv').open()))
assert len(rows) == protocol['rows'] == 108
workloads = {}
for row in rows:
    key = tuple(int(row[field]) for field in ('keys', 'requested_bpk', 'batch'))
    workloads.setdefault(key, []).append(row)
    assert int(row['calibration_absent_queries']) == 1 << protocol['calibration_power']
    assert int(row['filter_bytes']) <= key[0] * key[1] // 4
    assert int(row['insert_batch']) == key[0]
    n = int(row['calibration_absent_queries']); x = int(row['calibration_false_positives'])
    assert 0 <= x <= n
    p = x / n; z = 1.6448536269514722
    row['quality_upper'] = (p + z*z/(2*n) + z*math.sqrt(p*(1-p)/n+z*z/(4*n*n)))/(1+z*z/n)
assert len(workloads) == protocol['workloads']
comparisons = []
for (keys, requested, batch), group in sorted(workloads.items()):
    assert len(group) == 9 and {r['filter'] for r in group} == set(protocol['filters'])
    candidate = next(r for r in group if r['filter'] == 'Word16Split256Experiment')
    assert float(candidate['actual_bpk']) == 2 * requested
    for ceiling in (0.01, 0.001, 0.0001):
        qualified = candidate['quality_upper'] <= ceiling
        rivals = [r for r in group if r['filter'].startswith('FastFilter') and r['quality_upper'] <= ceiling]
        native_controls = [r for r in group if r['filter'] in ('FastPatternBF', 'ByteSplitBloomFilter', 'Split64BloomFilter') and r['quality_upper'] <= ceiling]
        for metric in ('lookup_ns', 'hash_lookup_ns'):
            for r in group:
                assert math.isfinite(float(r[metric])) and float(r[metric]) > 0
            rival = min(rivals, key=lambda r: float(r[metric])) if rivals else None
            control = min(native_controls, key=lambda r: float(r[metric])) if native_controls else None
            comparisons.append(dict(keys=keys, actual_memory_ceiling_bpk=2*requested, batch=batch,
                fpr_ceiling=ceiling, metric=metric, candidate_qualified=qualified,
                candidate_quality_upper=candidate['quality_upper'], candidate_ns=float(candidate[metric]),
                best_external=rival['filter'] if rival else None,
                external_ns=float(rival[metric]) if rival else None,
                candidate_over_external_latency=float(candidate[metric])/float(rival[metric]) if qualified and rival else None,
                best_native_control=control['filter'] if control else None,
                candidate_over_native_control_latency=float(candidate[metric])/float(control[metric]) if qualified and control else None))
summary = dict(source_and_binary_unchanged=True, cpu=3, workloads=len(workloads), rows=len(rows),
    ratio_definition='candidate/external latency; lower is faster. Only same-workload/same-binary CPU3 times are compared.',
    scope='Training seed42, 50% hits, GCC native binary, no general fastest or held-out performance claim.',
    comparisons=comparisons)
(output / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
with (output / 'comparisons.csv').open('w', newline='') as f:
    writer=csv.DictWriter(f,fieldnames=list(comparisons[0]),lineterminator='\n');writer.writeheader();writer.writerows(comparisons)
print('PASS: frozen nine-config CPU3 training screen, 12 workloads/108 rows; same-process comparisons only', flush=True)
