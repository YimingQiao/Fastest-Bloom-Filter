"""Revalidate complete raw output, command ledger, aggregate and immutable provenance."""
import sys
if not __debug__: raise SystemExit('Python -O is forbidden')
import argparse
import csv
import json
from source_guard import HERE, STAGE, sha, require, verify
from contract import command, parse_rows, validate_case, validate_matrix, validate_placement, identity


def load_complete(source_commit):
    frozen=verify(source_commit)
    protocol=json.loads((HERE/'protocol.json').read_text())
    selection=json.loads((STAGE/'validation-v3/planned-selection.json').read_text())
    out=STAGE/'screen'; meta=json.loads((out/'metadata.json').read_text())
    validate_placement(meta,protocol)
    require(meta['complete'] is True and meta['source_commit']==frozen['commit'],'Incomplete or wrong-commit measurement')
    require(meta['frozen_before']==meta['frozen_after']==frozen,'Changed measured source/binary bindings')
    require(meta['protocol_sha256']==sha(HERE/'protocol.json'),'Changed measured protocol')
    require(len(meta['commands'])==len(protocol['cases'])==13,'Missing/extra command ledger entries')
    rows=[]
    for index,(case,entry) in enumerate(zip(protocol['cases'],meta['commands'])):
        tag=f"case-{index:02d}-n{case['key_power']}-p{case['budget_bpk']}"
        require(entry['index']==index and entry['case']==case and entry['argv']==command(frozen['benchmark'],case,protocol),'Changed command/case/order')
        require(entry['stdout']==tag+'.stdout' and entry['stderr']==tag+'.stderr' and entry['returncode']==0,'Wrong output ownership or failed case')
        for stream in ('stdout','stderr'):
            require(sha(out/entry[stream])==entry[stream+'_sha256'],'Changed raw '+stream)
        part=parse_rows((out/entry['stdout']).read_text())
        planned={r['filter']:r for r in selection['configurations'] if r['key_power']==case['key_power'] and int(r['requested_bpk'])==case['budget_bpk']}
        validate_case(part,case,planned,protocol)
        for row in part:
            config,calibration=identity(row)
            row.update(configuration_id=config,calibration_identity=calibration,case_index=str(index))
        rows.extend(part)
    validation=validate_matrix(rows,selection,protocol)
    require(meta['rows']==142 and meta['validation']==validation,'Wrong final cardinality/validation')
    require(sha(out/'results.csv')==meta['results_sha256'],'Changed aggregate digest')
    with (out/'results.csv').open(newline='') as f: aggregate=list(csv.DictReader(f))
    require(rows==aggregate,'Raw and aggregate rows differ')
    return rows,validation

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True)
    args=parser.parse_args();_,validation=load_complete(args.source_commit)
    print(json.dumps(validation,indent=2))
