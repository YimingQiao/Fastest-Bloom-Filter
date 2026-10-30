"""Offline close-out of completed V2 proof; no compiler, BF or timing run."""
if not __debug__:
    raise RuntimeError('Python -O forbidden')
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
CALLER = HERE.parent
sys.path.insert(0, str(CALLER / 'repair-v2'))
import bindings
from contract import cases, argv, validate_rows, SEMANTIC, invalid

SOURCE = '4a31f93725212e08be1bc127e956c53c94f588e9'
OUT = CALLER / 'repair-v2/validation-v1'
sha, need, save = bindings.sha, bindings.need, bindings.save

def main():
    prepared = bindings.verify(SOURCE)
    meta = json.loads((OUT / 'metadata.json').read_text())
    need(meta['source_commit'] == SOURCE and meta['complete'] and meta['functional_complete'], 'incomplete V2')
    need(meta['formal_measurements'] == meta['calibration_queries'] == 0, 'unexpected formal data')
    need(meta['manual_assembly_review_pending'], 'original metadata was rewritten')
    need(meta['affinity'] == [3] and meta['lease']['cpu'] == 3 and meta['lease']['lease'] == 'socket1', 'placement differs')
    need(len(meta['commands']) == 119 and len(meta['binaries']) == 12, 'wrong commands/binaries')
    commands = {r['label']: r for r in meta['commands']}
    need(len(commands) == len(meta['commands']), 'duplicate command labels')
    for rec in commands.values():
        need(rec['complete'], 'unfinished command')
        for stream in ['stdout', 'stderr']:
            need(sha(OUT / rec[stream]) == rec[stream + '_sha256'], 'command log drift')
        reject = rec['expected_rejection']
        need(rec['returncode'] == (1 if reject is not None else 0), 'wrong exit status')
        if reject is not None:
            need((OUT / rec['stdout']).read_bytes() == b'' and (OUT / rec['stderr']).read_bytes() == (reject + '\n').encode(), 'wrong rejection')
    for mapping in [meta['binaries'], meta['toolchains'], *meta['compiler_inputs'].values()]:
        for name, digest in mapping.items():
            need(sha(Path(name)) == digest, 'actual input/tool/binary changed: ' + name)
    signatures = {}
    ledger = []
    profiles = ['native', 'portable', 'disabled', 'asan']
    for profile in profiles:
        binary = meta['executables'][profile]
        for index, case in enumerate(cases()):
            rec = commands[f'{profile}-case-{index}']
            need(rec['command'] == argv(binary, case), 'caller command differs')
            need((OUT / rec['stderr']).read_bytes() == b'', 'caller stderr')
            rows = [json.loads(line) for line in (OUT / rec['stdout']).read_text().splitlines()]
            validate_rows(rows, case, profile == 'disabled')
            signature = [{k: row[k] for k in SEMANTIC} for row in rows]
            key = (case['hit'], case['batch'])
            need(signatures.setdefault(key, signature) == signature, 'cross-profile identity differs')
            ledger.append(dict(profile=profile, case=case, rows=2))
        for arm in ['control', 'candidate']:
            rec = commands[f'{profile}-focused-k12-simd-{arm}']
            need('test result: ok. 2 passed' in (OUT / rec['stdout']).read_text(), 'focused test missing')
        for index, (expected, diagnostic) in enumerate(invalid(binary)):
            rec = commands[f'{profile}-invalid-{index}']
            need(rec['command'] == expected and rec['expected_rejection'] == diagnostic, 'invalid CLI differs')
        for fault in ['generic-skip', 'visible-wrong']:
            rec = commands[f'{profile}-fault-{fault}']
            need(rec['command'] == argv(binary, dict(hit=50, batch=1)) + ['--fault', fault]
                 and rec['expected_rejection'] == 'full output mismatch', 'fault command differs')
        closure = json.loads((OUT / f'{profile}-compiler-closure.json').read_text())
        need(closure['inputs_sha256'] == meta['compiler_inputs'][profile], 'compiler closure differs')
        for index, rule in enumerate(closure['rules']):
            need((OUT / f'{profile}-dependency-{index}.d').read_text() == rule['text'], 'dep-info bytes differ')
    need(ledger == meta['cases'], 'case ledger differs')
    assembly_tools = {}
    for profile, descriptor in meta['assembly'].items():
        capture_path = OUT / descriptor['path']
        need(sha(capture_path) == descriptor['sha256'], 'assembly capture changed')
        capture = json.loads(capture_path.read_text())
        need(capture['binary_sha256'] == meta['binaries'][capture['binary']], 'assembly binary identity differs')
        for name, digest in capture['tools_sha256'].items():
            need(sha(Path(name)) == digest, 'assembly tool changed')
            need(assembly_tools.setdefault(name, digest) == digest, 'conflicting assembly tool')
        for span in capture['spans']:
            need(sha(OUT / span['body_file']) == span['body_sha256'], 'assembly span drift')
    extra = json.loads((CALLER / 'assembly-review/EXTRA_SPANS.json').read_text())
    for name, digest in extra['inputs_sha256'].items():
        need(sha(CALLER / name) == digest, 'extra span input drift')
    for record in extra['records'].values():
        need(record['binary_sha256'] == meta['binaries'][record['binary']], 'extra binary differs')
        for span in record['spans']:
            need(sha(CALLER / 'assembly-review' / span['file']) == span['sha256'], 'extra span changed')
    union = {}
    for group in meta['compiler_inputs'].values():
        for name, digest in group.items():
            need(union.setdefault(name, digest) == digest, 'conflicting input hashes')
    counts = dict(commands=119, successful_commands=87, expected_rejections=32, focused_test_executions=16,
                  caller_rows=96, invalid_cli_cases=24, fault_cases=8, required_bit_hash_cases=73792,
                  tail_cases=17024, retained_binaries=12, actual_input_files=len(union))
    need(sum(r['returncode'] == 0 for r in commands.values()) == 87, 'wrong successful command count')
    for key in ['focused_test_executions', 'caller_rows', 'invalid_cli_cases', 'fault_cases', 'required_bit_hash_cases', 'tail_cases']:
        need(meta[key] == counts[key], 'wrong finite count')
    result = dict(complete=True, functional_complete=True, manual_assembly_review='passed',
                  source_commit=SOURCE, compiled_source_commit=bindings.SOURCE,
                  proposal_commit='5ac4b63414d94f63b7f61304c09b7eb8d0459f0e',
                  failure_commit=bindings.FAILED, failure_manifest_sha256=bindings.FAILED_MANIFEST_SHA,
                  metadata_path='repair-v2/validation-v1/metadata.json', metadata_sha256=sha(OUT / 'metadata.json'),
                  normal_executable=dict(path=meta['executables']['native'], sha256=meta['binaries'][meta['executables']['native']]),
                  portable_executable=dict(path=meta['executables']['portable'], sha256=meta['binaries'][meta['executables']['portable']]),
                  all_binary_sha256=meta['binaries'], actual_input_sha256=union,
                  prepared_input_sha256=prepared, toolchains_sha256=meta['toolchains'],
                  assembly_tools_sha256=assembly_tools,
                  recovery_preparation_sha256=sha(CALLER / 'repair-v2/PREPARATION.json'),
                  reused_native=meta['reused_native'], counts=counts, formal_measurements=0,
                  calibration_queries=0, incidental_check_timings_not_ranked=True,
                  review_sha256=sha(CALLER / 'assembly-review/REVIEW.md'),
                  extra_spans_sha256=sha(CALLER / 'assembly-review/EXTRA_SPANS.json'))
    save(CALLER / 'COMPILED_PROOF.json', result)
    audit = dict(complete=True, counts=counts, proof_sha256=sha(CALLER / 'COMPILED_PROOF.json'))
    save(HERE / 'AUDIT.json', audit)
    print(json.dumps(audit, sort_keys=True))

if __name__ == '__main__':
    main()
