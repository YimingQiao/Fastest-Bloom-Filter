#!/usr/bin/env python3
"""Replay the complete240 raw ledger; never rank partial observations."""
import argparse,json
from pathlib import Path
from screen_contract import HERE,SOURCE,need,audit
from screen_guard import verify,baseline,sha,validate_placement,PROOF_COMMIT

def check(output,commit,live=False):
    _,freeze=verify(commit,live=live);old,provenance=baseline()
    metadata=json.loads((output/'metadata.json').read_text())
    need(metadata['complete']is True and metadata['all_sources_and_binaries_unchanged']is True,'Incomplete matrix')
    need(metadata['source_commit']==commit and metadata['proof_commit']==PROOF_COMMIT,'Wrong source/proof anchor')
    need(metadata['worker_freeze_sha256']==sha(SOURCE/'WORKER_FREEZE.json')and metadata['preparation_sha256']==sha(HERE/'PREPARATION.json'),'Source inventory drift')
    need(metadata['caller_protocol_sha256']==sha(SOURCE/'protocol.json')and metadata['planned_grid_sha256']==sha(HERE/'planned-grid.json'),'Protocol/planner drift')
    need(metadata['old_context_latency_comparison']is False and metadata['old_context_semantic_provenance']==provenance,'Unexpected old-context comparison')
    need(metadata['unpooled_quality_identities']==72 and metadata['tuner_file_before']==metadata['tuner_file_after'],'Quality/tuner contract changed')
    validate_placement(metadata)
    binary=freeze['binaries']['native/page_pointer_control']
    need(metadata['executable']==binary['path']and metadata['executable_sha256']==binary['sha256'],'Wrong measured executable')
    need(len(metadata['commands'])==240,'Incomplete launch ledger')
    raws=[]
    for i,record in enumerate(metadata['commands']):
        raw={}
        for stream in ('stdout','stderr'):
            p=output/f'row{i:03d}.{stream}';need(sha(p)==record[stream+'_sha256'],'Raw observation changed');raw[stream]=p.read_text()
        raws.append(raw)
    return audit(metadata,raws,old,binary['path'])

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--verify-live',action='store_true');a=p.parse_args()
    need(len(check(a.output,a.source_commit,a.verify_live))==240,'Wrong complete count')
    print('Complete240 raw rows/commands, both rounds, all three clocks and72 unpooled identities verified')

if __name__=='__main__':main()
