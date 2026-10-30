"""Additive one-case completion; never repair or rerun the original17 cases."""
import copy
import csv
import hashlib
import io
import json
from pathlib import Path
import re
import sys

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
sys.path.insert(0,str(STAGE/'screening'))
import run as producer
import freeze as parent_freeze
from bindings import PUBLIC,ROOT,blob,need,save,sha
from guard import expected_order,raw_intervals,validate_protocol,validate_rows
from anchor import compare
from source_guard import require_lease

ORIGINAL='571186b420bf7e5fc08269ed4a65feab42ac8400'
INTERRUPTED='ab98c241a1ca71c8a502806c013949276e06d67d'
BINARY_SHA='f499f5daa354f3db31c5cfa1e84640c890f96c81e2724456aa64bf7b6bc7ef05'
RECOVERY=ROOT/'experiments/2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/recovery'

def verified_manifest(root,name,commit):
    path=root/name
    need(path.read_bytes()==blob(commit,path),'Uncommitted archive descriptor')
    document=json.loads(path.read_text())
    for name,entry in document['files'].items():
        target=root/name
        need(sha(target)==entry['sha256'] and target.stat().st_size==entry['bytes'],'Archived evidence drift '+name)
        need(hashlib.sha256(blob(commit,target)).hexdigest()==entry['sha256'],'Uncommitted archived bytes '+name)
    return document

def validate_original(output,metadata,protocol,source,binary):
    need(metadata['complete']is False and metadata['source_commit']==ORIGINAL,'Original attempt must remain interrupted')
    need(metadata['executable']==str(binary) and metadata['executable_sha256']==BINARY_SHA,'Wrong original binary')
    need(isinstance(metadata['cases'],list) and len(metadata['cases'])==18,'Original ledger must contain18 entries')
    rows=[];files={'metadata.json','results.csv'}
    for i,(case,record)in enumerate(zip(protocol['cases'],metadata['cases'],strict=True)):
        need(record['case']==case and record['command']==producer.command_for(case,protocol,binary),'Changed original command')
        need(record['expected_filter_order']==expected_order(case,protocol,source) and record['raw_input_intervals']==raw_intervals(case,protocol),'Changed original order/domains')
        need(record['stdout']==f'case-{i:02d}.stdout' and record['stderr']==f'case-{i:02d}.stderr','Changed original raw paths')
        if i==17:
            need(record['complete']is False and 'returncode'not in record,'Pending case was already completed')
            need((case['key_power'],case['budget_bpk'],case['batch'])==(25,32,4096),'Wrong pending workload')
            need(not(output/record['stdout']).exists() and not(output/record['stderr']).exists(),'Unexpected pending raw output')
            continue
        need(record['complete']is True and record['returncode']==0,'Original completed case failed')
        for stream in ['stdout','stderr']:
            files.add(record[stream]);need(sha(output/record[stream])==record[stream+'_sha256'],'Original raw drift')
        need((output/record['stderr']).read_text().strip()=='sbbf-rs 0.2.8 backend: Avx2Filter','Wrong original backend')
        current=list(csv.DictReader(io.StringIO((output/record['stdout']).read_text())))
        validate_rows(current,case,protocol,source);compare(current)
        need(record['rows']==len(current),'Changed original row count');rows.extend(current)
    need({p.name for p in output.iterdir()if p.is_file()}==files,'Unexpected original raw inventory')
    need(len(rows)==316 and rows==list(csv.DictReader(io.StringIO((output/'results.csv').read_text()))),'Original raw/aggregate mismatch')
    return rows

def verify(source_commit=None):
    frozen,compiled=parent_freeze.verify(ORIGINAL)
    need(compiled['performance_executable_sha256']==BINARY_SHA,'Changed timing executable')
    verified_manifest(STAGE,'INTERRUPTED_ARCHIVE.json',INTERRUPTED)
    verified_manifest(RECOVERY,'ARCHIVE.json',INTERRUPTED)
    descriptor=json.loads((HERE/'PREPARATION.json').read_text())
    for name,entry in descriptor['files'].items():
        path=HERE/name
        need(sha(path)==entry['sha256'] and path.stat().st_size==entry['bytes'],'Resume source drift '+name)
        if source_commit:need(path.read_bytes()==blob(source_commit,path),'Uncommitted resume source '+name)
    if source_commit:
        need(re.fullmatch(r'[0-9a-f]{40}',source_commit),'Exact committed resume source required')
        need((HERE/'PREPARATION.json').read_bytes()==blob(source_commit,HERE/'PREPARATION.json'),'Changed resume source descriptor')
    protocol=json.loads((STAGE/'protocol.json').read_text())
    source=(PUBLIC/'benchmark/src/main.rs').read_text()
    registry=json.loads((PUBLIC/'registry.json').read_text())
    validate_protocol(protocol,registry,source)
    binary=Path(compiled['performance_executable'])
    original=json.loads((STAGE/'screen/metadata.json').read_text())
    need(original['input_sha256']==frozen['inputs_sha256'],'Changed original consumed-source inventory')
    rows=validate_original(STAGE/'screen',original,protocol,source,binary)
    declaration=json.loads((HERE/'protocol.json').read_text())
    need(declaration['original_source_commit']==ORIGINAL and declaration['interrupted_archive_commit']==INTERRUPTED,'Wrong resume ancestry')
    need(declaration['command']==producer.command_for(protocol['cases'][17],protocol,binary),'Wrong sole resume command')
    need(declaration['case']==protocol['cases'][17] and declaration['completed_rows_reused']==316 and declaration['new_rows']==20,'Changed resume scope')
    return frozen,compiled,protocol,source,registry,binary,original,rows

def combine_metadata(original,resume,record,counts):
    """Derived ledger keeps18 list entries; summary counts cannot overwrite it."""
    need(original['complete']is False and len(original['cases'])==18,'Wrong interrupted parent')
    need(record['complete']is True and record['returncode']==0 and record['rows']==20,'Resume did not complete')
    cases=copy.deepcopy(original['cases']);cases[17]=copy.deepcopy(record)
    need(len(cases)==18 and all(c['complete']for c in cases),'Incomplete combined ledger')
    result={k:v for k,v in counts.items()if k!='cases'}
    result.update(complete=True,case_count=18,cases=cases,original_attempt_completed=False,
        original_source_commit=ORIGINAL,resume_source_commit=resume['source_commit'],
        interrupted_archive_commit=INTERRUPTED,executable=original['executable'],executable_sha256=BINARY_SHA,
        reused_completed_cases=17,reused_completed_rows=316,new_completed_cases=1,new_completed_rows=20,
        sessions=[dict(kind='interrupted',tool_session_id=9721,metadata_path=str((STAGE/'screen/metadata.json').relative_to(ROOT)),
                       metadata_sha256=sha(STAGE/'screen/metadata.json'),observed_exit_code=143,termination_cause='unknown',
                       started_utc=original['started_utc'],complete=False),
                  dict(kind='resume',metadata_path=resume['metadata_path'],source_commit=resume['source_commit'],
                       session_label=resume['session_label'],started_utc=resume['started_utc'],finished_utc=resume['finished_utc'],complete=True)],
        interpretation='Two measurement sessions, same immutable executable/workloads. Original17 cases reused unchanged; only unfinished case rerun. No universal same-process matrix claim.')
    return result
