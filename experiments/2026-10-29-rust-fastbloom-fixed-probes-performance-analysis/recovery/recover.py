#!/usr/bin/env python3
"""Additive restoration of the observed exact ledger; never edit original evidence."""
import copy
import hashlib
import json
from pathlib import Path
import sys

HERE=Path(__file__).resolve().parent
STAGE=HERE.parents[1]/'2026-10-29-rust-fastbloom-fixed-probes-screen'
sys.path.insert(0,str(STAGE/'screening'))
from freeze import verify
from run import audit
from bindings import PUBLIC,need,save,sha

COMMIT='571186b420bf7e5fc08269ed4a65feab42ac8400'
IMMUTABLE=('source_commit','preflight_source_commit','executable','executable_sha256','freeze_sha256','host',
    'environment','lease','affinity','numa_policy','compiler_flags','input_sha256','started_utc')


def restore(final,checkpoint):
    need(final['complete']is True and type(final['cases'])is int and final['cases']==18,'Require original completed overwritten metadata')
    need(final['source_commit']==COMMIT,'Wrong producer source')
    ledger=checkpoint['cases']
    need(isinstance(ledger,list)and len(ledger)==18 and all(c.get('complete')is True and c.get('returncode')==0 for c in ledger),'Require observed complete18 checkpoint')
    need(checkpoint['complete']is False,'Checkpoint must predate final summary')
    for field in IMMUTABLE:need(checkpoint[field]==final[field],'Checkpoint producer identity changed: '+field)
    recovered=copy.deepcopy(final)
    recovered['case_count']=final['cases']
    recovered['cases']=copy.deepcopy(ledger)
    return recovered


def main():
    final_path=STAGE/'screen/metadata.json'
    final=json.loads(final_path.read_text())
    observed=[]
    for line in (HERE/'inotify.stdout').read_text().splitlines():
        if not line.startswith('{'):continue
        event=json.loads(line)
        if event.get('cases')==event.get('complete_cases')==18:observed.append(event)
    need(len(observed)==1,'One observed complete18 inotify checkpoint required')
    event=observed[0];checkpoint=HERE/'inotify-checkpoints'/event['file']
    need(sha(checkpoint)==event['sha256']and checkpoint.stat().st_size==event['bytes'],'Observed checkpoint byte/hash drift')
    recovered=restore(final,json.loads(checkpoint.read_text()))
    frozen,compiled=verify(COMMIT)
    protocol=json.loads((STAGE/'protocol.json').read_text())
    registry=json.loads((PUBLIC/'registry.json').read_text())
    source=(PUBLIC/'benchmark/src/main.rs').read_text()
    rows,counts=audit(STAGE/'screen',recovered,protocol,source,registry,Path(compiled['performance_executable']))
    need(counts['rows']==336 and counts['cases']==18 and counts['family_geometry_size_seed_quality_records']==112,'Wrong recovered complete coverage')
    recovered['recovery']=dict(original_metadata_path=str(final_path),original_metadata_sha256=sha(final_path),
        exact_observed_checkpoint=str(checkpoint),checkpoint_sha256=sha(checkpoint),observation_utc=event['observed_utc'],
        action='Restore cases from exact observed complete18 checkpoint; retain original cases summary as case_count. No commands, timings or raw output invented/recomputed.',
        producer_source_unchanged=True,benchmark_rerun=False)
    output=HERE/'recovered-metadata.json'
    need(not output.exists(),'Preserve existing recovery')
    save(output,recovered)
    print('Recovered exact observed18-case ledger; all336 raw rows/order/trials/semantics and complete source pins verified')


if __name__=='__main__':main()
