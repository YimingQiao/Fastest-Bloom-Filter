#!/usr/bin/env python3
"""Offline complete raw/aggregate audit; never rank partial data."""
import sys
if not __debug__:raise SystemExit('Python -O is forbidden before any execution')
import argparse
import json
from contract import cases,command,complete,need,parse,validate
import placement
from run import case_name
from source_guard import HERE,STAGE,sha,verify

def load_complete(live=True):
    out=STAGE/'screen';meta=json.loads((out/'metadata.json').read_text());protocol=json.loads((HERE/'protocol.json').read_text())
    need(meta['complete']and not meta.get('failure'),'Matrix did not complete successfully')
    need(meta['protocol_sha256']==sha(HERE/'protocol.json'),'Changed protocol')
    frozen=verify(meta['source_commit'],live=live)
    need(meta['frozen_before']==meta['frozen_after']==frozen,'Wrong initial/final frozen evidence')
    placement.validate(meta['placement_before']);placement.validate(meta['placement_after']);need(meta['placement_before']==meta['placement_after'],'Placement changed')
    ledger=cases(protocol);need(len(meta['commands'])==len(ledger)==36,'Missing/extra workload commands')
    rows=[]
    for i,(case,record)in enumerate(zip(ledger,meta['commands'])):
        name=case_name(i,case);binary=frozen['selected_normal_executables'][case['language']]
        need(record['index']==i and record['case']==case and record['argv']==command(binary['path'],case,protocol)and record['returncode']==0,'Wrong command ledger/result')
        for stream in ('stdout','stderr'):
            need(record[stream]==name+'.'+stream,'Wrong raw output path')
            need(sha(out/record[stream])==record[stream+'_sha256'],'Changed raw output')
        rows.extend(validate(parse((out/record['stdout']).read_text()),case,protocol))
    need(meta['results_sha256']==sha(out/'results.csv'),'Changed aggregate CSV')
    need(rows==parse((out/'results.csv').read_text()),'Raw/aggregate ordered rows differ')
    coverage=complete(rows,protocol);need(meta['coverage']==coverage,'Wrong coverage metadata')
    return rows,meta,coverage

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--skip-live-binaries',action='store_true');args=parser.parse_args()
    rows,metadata,coverage=load_complete(live=not args.skip_live_binaries);print(json.dumps(coverage,sort_keys=True))
