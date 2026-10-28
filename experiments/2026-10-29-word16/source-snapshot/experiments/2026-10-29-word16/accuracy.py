#!/usr/bin/env python3
"""Run the existing comparison runner, retaining a separate accuracy-only summary."""
import argparse
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
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--mode', choices=('initial', 'confirmation'), required=True)
args = parser.parse_args()
protocol = json.loads((HERE / 'protocol.json').read_text())
freeze = json.loads((HERE / 'freeze.json').read_text())
def verify():
    for name, digest in freeze['source_sha256'].items():
        assert sha(ROOT / name) == digest, name
        assert sha(HERE / 'source-snapshot' / name) == digest, name
    for name, digest in freeze['binaries'].items():
        assert sha(ROOT / name) == digest, name
verify()
if args.mode == 'confirmation':
    initial = json.loads((HERE / 'initial/accuracy.json').read_text())
    assert initial['gate_passed'] and initial['freeze_sha256'] == sha(HERE / 'freeze.json')
output = HERE / args.mode
command = [
    'python3', str(ROOT / 'scripts/run_comparison.py'),
    '--executable', str(ROOT / freeze['binary']), '--output-dir', str(output),
    '--key-powers', ','.join(map(str, protocol['key_powers'])),
    '--bits-per-key', ','.join(map(str, protocol['requested_bpk'])),
    '--hits', str(protocol['hit_percent']), '--batches', str(protocol['batch']),
    '--seeds', ','.join(map(str, protocol[args.mode + '_seeds'])),
    '--query-power', str(protocol['query_power']), '--repeats', str(protocol['repeats']),
    '--cpu', '2', '--filters', ','.join(protocol['filters']), '--insert-batch', '0',
    '--calibration-power', str(protocol['calibration_power']),
]
subprocess.run(command, cwd=ROOT, check=True)
rows = list(csv.DictReader((output / 'results.csv').open()))
seeds = protocol[args.mode + '_seeds']
assert len(rows) == len(protocol['key_powers']) * len(protocol['requested_bpk']) * len(seeds) * len(protocol['filters'])
fields = ('filter', 'keys', 'requested_bpk', 'actual_bpk', 'filter_bytes', 'seed', 'result_checksum', 'false_positives', 'calibration_false_positives', 'calibration_absent_queries')
summary = []
for row in rows:
    n = int(row['calibration_absent_queries'])
    x = int(row['calibration_false_positives'])
    assert n == 1 << protocol['calibration_power'] and 0 <= x <= n
    assert int(row['filter_bytes']) <= int(row['keys']) * int(row['requested_bpk']) // 4
    p = x / n
    z = 1.6448536269514722
    upper = (p + z*z/(2*n) + z*math.sqrt(p*(1-p)/n + z*z/(4*n*n))) / (1+z*z/n)
    item = {field: row[field] for field in fields}
    item.update(fpr=p, one_sided95_upper=upper, strict_0_01pct_eligible=upper <= 0.0001)
    summary.append(item)
candidates = [r for r in summary if r['filter'] == protocol['candidate']]
assert len(candidates) == len(protocol['key_powers']) * len(protocol['requested_bpk']) * len(seeds)
for row in candidates:
    assert float(row['actual_bpk']) == 2 * int(row['requested_bpk'])
    print('candidate', row['keys'], 'keys, actual', row['actual_bpk'], 'bpk, seed', row['seed'], ':', row['calibration_false_positives'], '/', row['calibration_absent_queries'], 'FP; point', format(row['fpr'], '.8%'), 'upper', format(row['one_sided95_upper'], '.8%'), flush=True)
strict = [r for r in candidates if float(r['actual_bpk']) == 32]
assert len(strict) == len(protocol['key_powers']) * len(seeds)
qualified = all(r['strict_0_01pct_eligible'] for r in strict)
verify()
with (output / 'accuracy.csv').open('w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=list(summary[0]), lineterminator='\n')
    writer.writeheader(); writer.writerows(summary)
result = dict(utc=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), mode=args.mode, gate_passed=qualified,
              freeze_sha256=sha(HERE / 'freeze.json'), source_and_binary_unchanged=True,
              candidate_accuracy=candidates, rows=len(rows), command=command,
              timing_scope='Raw results.csv is archival only; accuracy.csv removes all incidental timing columns. No throughput or latency claim.',
              selection='Both key counts must pass the pointwise one-sided95 Wilson upper <=0.0001 at actual32bpk. Both allocations are retained; each confirmation seed must pass separately.')
(output / 'accuracy.json').write_text(json.dumps(result, indent=2) + '\n')
print('Accuracy gate:', qualified, '; all evidence retained; no timing claim', flush=True)
