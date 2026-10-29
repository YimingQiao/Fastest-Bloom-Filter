"""Complete-only producer replay and immutable raw interface for analysis."""
import json
from screen_contract import need,read,ledger,arguments,parse,validate_records
from pins import HERE,ROOT,sha,blob,verify
import placement

RESULTS=HERE/'results-v1'

def command(binary,case):
    return ['/usr/bin/taskset','-c','3','/usr/bin/numactl','--physcpubind=3','--membind=1',binary,*arguments(case)]

def validate_directory(source_commit,live=True):
    metadata=read(RESULTS/'metadata.json');records=read(RESULTS/'records.json')
    need(metadata['complete'] and metadata['source_commit']==source_commit,'incomplete/wrong-source run')
    closure=verify(source_commit,live=live)
    need(metadata['initial_freeze']==metadata['final_freeze']==closure,'recorded closure differs')
    placement.validate(metadata['placement'])
    need(metadata['final_placement']==metadata['placement'],'placement changed')
    cases=ledger();need(len(metadata['cases'])==len(records)==96,'incomplete command ledger')
    for index,(entry,case,record) in enumerate(zip(metadata['cases'],cases,records,strict=True)):
        descriptor=closure['executables'][case['profile']]
        need(json.dumps(entry['case'],sort_keys=True)==json.dumps(case,sort_keys=True) and entry['argv']==command(descriptor['path'],case),'wrong command/profile')
        need(entry['inherited_lock_fds']==[int(fd) for fd in metadata['placement']['fd_evidence']],'missing inherited lock descriptor')
        need(entry['exit_code']==0 and entry['binary_sha256']==descriptor['sha256'],'failed/different executable')
        for field in ['stdout','stderr']:
            need(entry[field]==f'case-{index:03d}.{field}','unexpected raw filename')
            need(sha(RESULTS/entry[field])==entry[field+'_sha256'],'raw stream hash differs')
        need((RESULTS/entry['stderr']).read_bytes()==b'','unexpected caller diagnostic')
        rows=parse((RESULTS/entry['stdout']).read_text(),case)
        need(record==dict(case=case,rows=rows),'raw/aggregate disagreement')
    counts=validate_records(records);need(metadata['counts']==counts,'counts differ')
    return metadata,records

def load_complete(raw_commit,raw_manifest_sha256):
    manifest=RESULTS/'RAW_ARCHIVE.json'
    need(sha(manifest)==raw_manifest_sha256,'raw manifest hash differs')
    need(manifest.read_bytes()==blob(raw_commit,manifest.relative_to(ROOT)),'raw manifest Git mismatch')
    files=read(manifest)['files']
    expected={'metadata.json','records.json'}|{f'case-{i:03d}.{stream}' for i in range(96) for stream in ['stdout','stderr']}
    need(set(files)==expected and len(files)==194,'incomplete/extra raw inventory')
    for name,record in files.items():
        path=RESULTS/name;data=path.read_bytes()
        need(len(data)==record['bytes'] and sha(path)==record['sha256'],'raw artifact hash differs')
        need(data==blob(raw_commit,path.relative_to(ROOT)),'raw artifact Git mismatch')
    metadata=read(RESULTS/'metadata.json')
    return validate_directory(metadata['source_commit'],live=True)
