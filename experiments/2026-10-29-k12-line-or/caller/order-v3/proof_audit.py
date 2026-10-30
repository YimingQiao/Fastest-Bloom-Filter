"""Offline order-caller proof audit; no compiler or BF execution."""
import json
from pathlib import Path
from guards import HERE, verify, sha, need, CASES, validate

SOURCE = '7546719bf38b77b4d12ca8d9cc829a09a96e459b'

def audit(live=True):
    out = HERE/'validation-v1'
    meta = json.loads((out/'metadata.json').read_text())
    need(meta['complete'] is True and meta['source_commit'] == SOURCE, 'Wrong proof')
    need(meta['kernel_matrix_rerun'] is False and meta['formal_workloads_run'] is False, 'Unexpected work')
    need(len(meta['commands']) == 19, 'Wrong command count')
    for row in meta['commands']:
        need(row['complete'] and ((row['returncode'] == 0) == row['expected_success']), 'Command failure')
        for stream in ('stdout','stderr'):
            need(sha(out/row[stream]) == row[stream+'_sha256'], 'Raw evidence changed')
        if not row['expected_success']:
            need(row['returncode'] == 1 and not (out/row['stdout']).read_bytes() and (out/row['stderr']).read_bytes(), 'Bad CLI accepted')
    rebuilt = []
    for profile in ('native','asan'):
        for i in range(len(CASES)):
            for flag in ('original','reverse'):
                records = validate((out/f'{profile}-case{i}-{flag}.stdout').read_text(), i, flag == 'reverse')
                rebuilt.extend(dict(profile=profile,case=i,flag=flag,**r) for r in records)
    need(len(rebuilt) == 16 and rebuilt == json.loads((out/'rows.json').read_text()), 'Raw aggregate mismatch')
    review = json.loads((HERE/'assembly-review/REVIEW.json').read_text())
    need(review['new_binary_sha256'] == meta['profiles']['native']['executable']['sha256'], 'ASM binary mismatch')
    need(review['all_eight_equal'] and len(review['records']) == 8 and all(r['normalized_equal'] for r in review['records']), 'Compiled insertion body changed')
    if live:
        need(verify(SOURCE) == meta['source_sha256'], 'Source closure changed')
        for group in ('all_binary_sha256','compiler_consumed_input_sha256'):
            for path,digest in meta[group].items():
                need(sha(path) == digest, 'Consumed binary/source changed')
    return dict(commands=19,profiles=2,caller_rows=16,invalid_cli=4,binaries=2,compiler_inputs=len(meta['compiler_consumed_input_sha256']),normalized_insertion_bodies=8,formal_workloads_run=False)

if __name__ == '__main__':
    print(json.dumps(audit(), sort_keys=True))
