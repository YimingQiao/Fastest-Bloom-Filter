#!/usr/bin/env python3
"""Offline exact completed40-run reconstruction, optionally checking live pins."""
import argparse
from screen_contract import HERE,CALLER,need,sha,parse,audit
from freeze import PROOF,validate_placement,verify
from run import protocol


def load(commit,output=HERE/'results-v1',live=False):
    sources,compiled=verify(commit,live=live);protocol()
    meta=parse((output/'metadata.json').read_text())
    need(meta['complete']is True and meta['final_frozen_inputs_equal']is True,'Incomplete formal stage')
    need(meta['source_commit']==commit and meta['proof_commit']==PROOF and meta['source_sha256']==sources,'Source/proof identity mismatch')
    need(meta['compiled_proof_sha256']==sha(CALLER/'COMPILED_PROOF.json')and meta['protocol_sha256']==sha(HERE/'protocol.json'),'Descriptor drift')
    binaries=compiled['selected_normal_executables'];need(meta['binaries']==binaries,'Wrong measured executables')
    validate_placement(meta['placement'])
    return audit(output,meta,binaries,meta['placement']['lease'])


if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);parser.add_argument('--verify-live',action='store_true');args=parser.parse_args()
    records,observed=load(args.source_commit,live=args.verify_live);print('PASS complete40 raw/aggregate/freeze audit',observed)
