#!/usr/bin/env python3
"""Verify the observed17 completed cases; do not label the partial matrix complete."""
import csv
import io
import json
from pathlib import Path
import sys
HERE=Path(__file__).resolve().parent
STAGE=HERE.parents[1]/'2026-10-29-rust-fastbloom-fixed-probes-screen'
sys.path.insert(0,str(STAGE/'screening'))
from freeze import verify
from run import command_for
from bindings import PUBLIC,need,save,sha
from guard import expected_order,raw_intervals,validate_rows
from anchor import compare

COMMIT='571186b420bf7e5fc08269ed4a65feab42ac8400'

def main():
    frozen,compiled=verify(COMMIT)
    out=STAGE/'screen';meta=json.loads((out/'metadata.json').read_text())
    protocol=json.loads((STAGE/'protocol.json').read_text());source=(PUBLIC/'benchmark/src/main.rs').read_text()
    need(meta['complete']is False and meta['source_commit']==COMMIT and isinstance(meta['cases'],list)and len(meta['cases'])==18,'Wrong interrupted shape')
    need(meta['input_sha256']==frozen['inputs_sha256'] and meta['executable_sha256']==compiled['performance_executable_sha256'],'Wrong interrupted source/binary')
    rows=[];expected_files={'metadata.json','results.csv'}
    for i,(case,record)in enumerate(zip(protocol['cases'],meta['cases'],strict=True)):
        need(record['case']==case and record['command']==command_for(case,protocol,compiled['performance_executable']),'Changed exact case/command')
        need(record['expected_filter_order']==expected_order(case,protocol,source)and record['raw_input_intervals']==raw_intervals(case,protocol),'Changed order/domains')
        need(record['stdout']==f'case-{i:02d}.stdout'and record['stderr']==f'case-{i:02d}.stderr','Wrong raw paths')
        if i==17:
            need(record['complete']is False and 'returncode'not in record and not(out/record['stdout']).exists()and not(out/record['stderr']).exists(),'Unexpected pending-case output')
            need((case['key_power'],case['budget_bpk'],case['batch'])==(25,32,4096),'Wrong missing workload')
            continue
        need(record['complete']is True and record['returncode']==0,'Prior case did not pass')
        for stream in ['stdout','stderr']:
            expected_files.add(record[stream]);need(sha(out/record[stream])==record[stream+'_sha256'],'Original raw drift')
        need((out/record['stderr']).read_text().strip()=='sbbf-rs 0.2.8 backend: Avx2Filter','Unexpected backend')
        part=list(csv.DictReader(io.StringIO((out/record['stdout']).read_text())))
        validate_rows(part,case,protocol,source);compare(part);need(len(part)==record['rows'],'Wrong row count')
        rows.extend(part)
    need({p.name for p in out.iterdir()if p.is_file()}==expected_files,'Unexpected interrupted raw inventory')
    need(rows==list(csv.DictReader(io.StringIO((out/'results.csv').read_text())))and len(rows)==316,'Partial aggregate/raw mismatch')
    events=[json.loads(line)for line in(HERE/'inotify.stdout').read_text().splitlines()if line.startswith('{')]
    for event in events:
        path=HERE/'inotify-checkpoints'/event['file'];raw=json.loads(path.read_text())
        need(sha(path)==event['sha256']and path.stat().st_size==event['bytes'],'Observed checkpoint hash/size drift')
        need(len(raw['cases'])==event['cases']and sum(r.get('complete',False)for r in raw['cases'])==event['complete_cases'],'Observed event shape mismatch')
        need(raw['source_commit']==COMMIT,'Wrong observed producer')
    need(events[-1]['cases']==18 and events[-1]['complete_cases']==17,'Missing final pending18-entry observation')
    need(not any(e['cases']==e['complete_cases']==18 for e in events),'Unexpected complete18 observation')
    report=dict(complete_matrix=False,completed_commands=17,completed_rows=316,pending_commands=1,pending_rows=20,
        source_commit=COMMIT,performance_executable_sha256=compiled['performance_executable_sha256'],
        source_dependency_binary_checks_pass=True,all_completed_raw_order_phase_trials_semantics_pass=True,
        metadata_overwrite_occurred=False,original_metadata_unchanged=True,checkpoint_events=len(events),
        final_observed_complete_cases=17,partial_performance_ranking=False)
    save(HERE/'interrupted-audit.json',report)
    save(STAGE/'INTERRUPTED_ARCHIVE.json',dict(scope='Original interrupted17-of18 attempt. No data or metadata repaired; final workload has no captured raw output.',
        files={'screen/'+name:dict(sha256=sha(out/name),bytes=(out/name).stat().st_size)for name in sorted(expected_files)}))
    print('PASS exact17 commands/316 rows, pending n25/cap32/b4096; full source/binary proofs and observed checkpoints. Matrix remains incomplete.')

if __name__=='__main__':main()
