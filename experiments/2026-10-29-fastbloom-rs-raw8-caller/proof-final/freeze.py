"""Seal completed bounded evidence; never executes a filter or compiler."""
import csv,hashlib,io,json,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=HERE.parents[2]
SOURCE='efb5142fdc3e5cb62d68004b1f8ca1d75bd8728e'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,d):p.write_text(json.dumps(d,indent=2)+'\n')
def blob(p):return subprocess.check_output(['git','show',SOURCE+':'+str(p.relative_to(ROOT))],cwd=ROOT)
def main():
    preparation=STAGE/'preflight/PREPARATION.json'
    assert preparation.read_bytes()==blob(preparation)
    for name,record in json.loads(preparation.read_text())['files'].items():
        p=preparation.parent/name
        assert p.read_bytes()==blob(p) and sha(p)==record['sha256'] and p.stat().st_size==record['bytes']
    sys.path.insert(0,str(preparation.parent))
    from contract import cases,argv,invalid,validate_rows,validate_process,semantic
    raw=STAGE/'validation-v1'; meta=json.loads((raw/'metadata.json').read_text())
    assert meta['complete'] and meta['functional_complete'] and meta['source_commit']==SOURCE
    assert meta['affinity']==[3] and meta['performance_claim'] is False and meta['formal_workloads']==0
    assert (meta['focused_test_executions'],meta['caller_rows'],meta['invalid_cli_cases'])==(12,122,12)
    assert len(meta['commands'])==50 and len({c['label']for c in meta['commands']})==50
    by_label={c['label']:c for c in meta['commands']}
    for c in meta['commands']:
        assert c['complete']
        for stream in ['stdout','stderr']:
            p=raw/c[stream];assert sha(p)==c[stream+'_sha256']
        validate_process(c['returncode'],(raw/c['stdout']).read_bytes(),(raw/c['stderr']).read_bytes(),c['expected_rejection'])
    observed={};row_count=0
    for mode in ['normal','asan']:
        binary=Path(meta['mode_executables'][mode])
        for i,case in enumerate(cases()):
            c=by_label[f'{mode}-case-{i}'];assert c['command']==list(map(str,argv(binary,case)))
            rows=list(csv.DictReader(io.StringIO((raw/c['stdout']).read_text())))
            validate_rows(rows,case);row_count+=len(rows)
            for row in rows:assert observed.setdefault(row['filter'],semantic(row))==semantic(row)
        for i,rejection in enumerate(invalid(binary)):
            c=by_label[f'{mode}-invalid-{i}'];assert c['expected_rejection']==rejection and c['command']==list(map(str,rejection['command']))
        for i in range(6):assert 'test result: ok. 1 passed'in(raw/by_label[f'{mode}-test-{i}']['stdout']).read_text()
    assert row_count==122 and len(observed)==45
    for inputs in [meta['binaries'],meta['toolchains'],*meta['compiler_inputs'].values()]:
        for name,digest in inputs.items():assert sha(Path(name))==digest,name
    assert sha(raw/'assembly-spans.json')==meta['assembly']['sha256']
    inventory=json.loads((HERE/'asm-inventory.json').read_text())
    for name,digest in inventory['input_sha256'].items():assert sha(raw/name)==digest
    assert inventory['report_count']==45 and len(inventory['reports'])==45
    assert (HERE/'PEER_REVIEW.md').is_file()
    freeze=dict(complete=True,source_commit=SOURCE,caller_source_commit=meta['caller_source_commit'],
                metadata_sha256=sha(raw/'metadata.json'),command_count=50,caller_rows=122,distinct_apis=45,focused_test_executions=12,
                invalid_cli_cases=12,small_oracle_constructors_per_mode=144,formal_empty_constructor_checks_per_mode=12,
                binaries_sha256=meta['binaries'],toolchains_sha256=meta['toolchains'],compiler_inputs_sha256=meta['compiler_inputs'],
                prepared_inputs_descriptor_sha256=sha(STAGE/'preflight/INPUTS.json'),assembly_capture_sha256=sha(raw/'assembly-spans.json'),
                manual_review_complete=True,performance_claim=False,formal_matrix_executed=False,
                note='Original metadata remains unchanged, including its capture-time pending manual review field. Additive manual review closes that step; all tiny values remain unranked.')
    save(HERE/'freeze.json',freeze)
    paths=sorted([p for p in raw.rglob('*')if p.is_file()]+[p for p in HERE.rglob('*')if p.is_file() and p.name!='MANIFEST.json' and '__pycache__'not in p.parts])
    manifest={str(p.relative_to(STAGE)):dict(sha256=sha(p),bytes=p.stat().st_size)for p in paths}
    save(HERE/'MANIFEST.json',dict(source_commit=SOURCE,files=manifest))
    print(f'PASS: {len(manifest)} evidence artifacts; 50 commands / 122 rows / 12 focused tests / 12 exact CLI rejections; no formal performance')
if __name__=='__main__':main()
