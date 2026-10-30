#!/usr/bin/env python3
"""Seal successful correctness evidence; does not run any BF or timing."""
import argparse,json
from pathlib import Path
from contract import HERE,ROOT,need
from source_guard import verify,sha

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True);p.add_argument('--proof',type=Path,required=True)
    a=p.parse_args();verify(a.source_commit);proof=a.proof.resolve();m=json.loads((proof/'metadata.json').read_text())
    need(m['complete'] and m['all_sources_unchanged'] and m['source_commit']==a.source_commit,'Incomplete or different correctness proof')
    need(set(m['rows'])=={'native','native-asan'} and len(m['rows']['native'])==158 and len(m['rows']['native-asan'])==48 and len(m['accounting_rows'])==18,'Wrong proof coverage')
    dest=HERE/'WORKER_FREEZE.json';need(not dest.exists(),'Worker freeze already exists')
    binaries={k:v for k,v in m['binaries'].items()}
    for r in binaries.values():need(sha(Path(r['path']))==r['sha256'],'Compiled binary drift')
    inputs={}
    for f in proof.glob('*-consumed-inputs.json'):
        for name,want in json.loads(f.read_text())['consumed_inputs'].items():
            need(name not in inputs or inputs[name]==want,'Conflicting compiler input hashes');inputs[name]=want
    for name,want in inputs.items():need(sha(Path(name))==want,'Consumed input drift')
    artifacts={str(f.relative_to(ROOT)):sha(f) for f in sorted(proof.rglob('*')) if f.is_file() and 'binaries' not in f.relative_to(proof).parts}
    freeze=dict(scope='Passed worker correctness/accounting; no Stage3 performance data',preparation_commit=a.source_commit,
      preparation_sha256=sha(HERE/'PREPARATION.json'),proof_metadata=str((proof/'metadata.json').relative_to(ROOT)),
      proof_artifacts=artifacts,binaries=binaries,consumed_inputs=inputs)
    dest.write_text(json.dumps(freeze,indent=2)+'\n');print(sha(dest))

if __name__=='__main__':main()
