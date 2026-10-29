"""Offline exact36 command/stdout replay; no benchmark execution."""
import json
from pathlib import Path
from plan import HERE,need
from screen_contract import plan,command,parse,validate_records,aggregate_csv,row_protocol,raw_intervals,PREFIX,expected_stderr
from placement import validate as validate_placement
def audit(directory,metadata,binary,source_commit,sha):
    need(metadata['complete']is True and metadata['source_commit']==source_commit,'Incomplete/wrong source result')
    need(metadata['ledger']==plan()and metadata['child_prefix']==PREFIX,'Changed fixed placement/ledger')
    validate_placement(metadata['lease']);need(metadata['compiler_runs']==0 and metadata['binary']['path']==str(binary),'Unexpected compiler or binary')
    need(len(metadata['cases'])==36,'Incomplete command ledger');records=[]
    for case,record in zip(plan()['cases'],metadata['cases']):
        label=f"case-{case['index']:02d}"
        need(record['case']==case and record['command']==command(binary,case)and record['returncode']==0 and record['complete']is True,'Changed/failed invocation')
        need(record['source_derived_intervals']==raw_intervals(case,row_protocol(case)),'Changed source intervals')
        for stream in ('stdout','stderr'):
            path=directory/(label+'.'+stream);need(record[stream]==path.name and sha(path)==record[stream+'_sha256'],'Changed raw stream')
        need((directory/record['stderr']).read_bytes()==expected_stderr(),'Unexpected stderr')
        records.append(dict(case=case,rows=parse((directory/record['stdout']).read_text(),case)))
    counts,quality,references=validate_records(records)
    need(counts==metadata['counts'],'Changed summary counts')
    need(records==json.loads((directory/'records.json').read_text()),'Raw/aggregate record mismatch')
    need(aggregate_csv(records)==(directory/'results.csv').read_text(),'Raw/CSV mismatch')
    need(quality==json.loads((directory/'quality.json').read_text())and references==json.loads((directory/'quality-links.json').read_text()),'Changed calibration reuse')
    return counts
def load_complete(source_commit):
    from pins import verify,sha
    directory=HERE/'results-v1';metadata=json.loads((directory/'metadata.json').read_text());frozen=verify(source_commit)
    need(frozen==metadata['freeze']and frozen['binary']==metadata['binary'],'Frozen input drift')
    need(metadata['analysis_rules_sha256']==sha(HERE/'ANALYSIS_RULES.json')and metadata['numactl_sha256']==sha('/usr/bin/numactl'),'Changed rules/placement executable')
    manifest=json.loads((directory/'RAW_ARCHIVE.json').read_text());need(manifest['source_commit']==source_commit,'Wrong raw source')
    names={'metadata.json','records.json','results.csv','quality.json','quality-links.json'}|{f'case-{i:02d}.{s}'for i in range(36)for s in ('stdout','stderr')}
    need(set(manifest['files'])==names,'Wrong complete raw inventory')
    for name,item in manifest['files'].items():need(sha(directory/name)==item['sha256']and(directory/name).stat().st_size==item['bytes'],'Changed raw artifact')
    counts=audit(directory,metadata,Path(frozen['binary']['path']),source_commit,sha);return metadata,json.loads((directory/'records.json').read_text()),counts
