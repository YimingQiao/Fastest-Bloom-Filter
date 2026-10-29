"""Complete-only replay shared by the producer and offline analysis."""
from pathlib import Path
from screen_contract import need,read,ledger,arguments,parse,validate_records
from pins import HERE,ROOT,sha,blob,verify
import placement
RESULTS=HERE/'results-v1'
def command(binary,case):return ['/usr/bin/numactl','--physcpubind=3','--membind=1',binary,*arguments(case)]
def validate_directory(source_commit,live=True):
    metadata=read(RESULTS/'metadata.json');records=read(RESULTS/'records.json')
    need(metadata['complete']and metadata['source_commit']==source_commit,'incomplete/wrong-source run')
    closure=verify(source_commit,live=live)
    need(metadata['initial_freeze']==metadata['final_freeze']==closure,'recorded source closure mismatch')
    placement.validate(metadata['placement']);need(metadata['final_placement']==metadata['placement'],'placement changed')
    cases=ledger();need(len(metadata['cases'])==24,'command ledger incomplete')
    binary=closure['normal_executable']['path']
    for index,(entry,case,record)in enumerate(zip(metadata['cases'],cases,records,strict=True)):
        need(entry['case']==case and entry['argv']==command(binary,case),'wrong actual command')
        need(entry['inherited_lock_fds']==[int(fd)for fd in metadata['placement']['fd_evidence']],'child did not inherit the declared lock descriptors')
        need(entry['exit_code']==0 and entry['binary_sha256']==closure['normal_executable']['sha256'],'failed/different executable')
        for field in('stdout','stderr'):
            need(entry[field]==f'case-{index:03d}.{field}','unexpected raw path')
            need(sha(RESULTS/entry[field])==entry[field+'_sha256'],'raw log hash mismatch')
        need((RESULTS/entry['stderr']).read_bytes()==b'','unexpected native diagnostic')
        actual=parse((RESULTS/entry['stdout']).read_text(),case)
        need(record==dict(case=case,rows=actual),'raw/aggregate mismatch')
    counts,quality=validate_records(records);need(metadata['counts']==counts,'final counts mismatch')
    need(read(RESULTS/'quality.json')==quality,'calibration links mismatch')
    return metadata,records
def load_complete(raw_commit,raw_manifest_sha256):
    manifest=RESULTS/'RAW_ARCHIVE.json';need(sha(manifest)==raw_manifest_sha256,'raw manifest SHA mismatch')
    need(manifest.read_bytes()==blob(raw_commit,str(manifest.relative_to(ROOT))),'raw manifest Git mismatch')
    files=read(manifest)['files'];expected={'metadata.json','records.json','quality.json'}|{f'case-{i:03d}.{kind}'for i in range(24)for kind in('stdout','stderr')}
    need(set(files)==expected and len(files)==51,'raw inventory incomplete/extra')
    for name,entry in files.items():
        path=RESULTS/name;data=path.read_bytes()
        need(len(data)==entry['bytes']and sha(path)==entry['sha256'],'raw artifact SHA mismatch')
        need(data==blob(raw_commit,str(path.relative_to(ROOT))),'raw Git bytes mismatch')
    metadata=read(RESULTS/'metadata.json')
    return validate_directory(metadata['source_commit'],live=True)
