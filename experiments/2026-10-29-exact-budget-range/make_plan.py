#!/usr/bin/env python3
"""Allocation-only grid planning: no filters or query workloads are constructed."""
import argparse,csv,hashlib,io,json,re,subprocess
from pathlib import Path

def bitmap_family(name):
    if name=='ByteSplitRangeExperiment': return 'FastFilterFixed16'
    if name=='Split64RangeExperiment': return 'FastFilterFixed64'
    if name.startswith('FastFilterClassic'):
        return re.sub(r'(Branchless|Bulk)$','',name)
    if name.startswith('RocksDBFastLocalBloom64'):
        return 'RocksDBFastLocalBloom64Core'  # effective K is part of the identity
    return re.sub(r'(SingleV1|Bulk)$','',name)

GEOMETRY=('filter_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count','effective_probes','probe_policy','page_level')
def identities(row):
    geometry=tuple(row[k] for k in GEOMETRY)
    calibration_row=dict(row)
    if row['filter'] in ('ByteSplitRangeExperiment','Split64RangeExperiment'):
        # Frozen oracle proves the same address/probe mapping as these pinned
        # FastFilter families (Split64 differs only by fixed sector permutation).
        calibration_row['geometry_kind']='fixed_range_buckets'
    calibration=tuple(calibration_row[k] for k in GEOMETRY)
    return (row['filter'],row['keys'])+geometry,(bitmap_family(row['filter']),row['keys'])+calibration

def generate(binary,powers,budgets):
    planned=[];by_id={};unsupported=[];cases=[];registry=None
    for power in powers:
        for budget in budgets:
            proc=subprocess.run([str(binary),str(1<<power),str(budget)],text=True,capture_output=True,check=True)
            rows=list(csv.DictReader(io.StringIO(proc.stdout)))
            names=[row['filter'] for row in rows]
            assert len(names)==74 and len(set(names))==74, names
            assert registry is None or registry==names
            registry=names
            selected=[]
            for row in rows:
                assert None not in row and None not in row.values(),row
                if row['status']!='supported':
                    unsupported.append(row);continue
                assert int(row['filter_bytes'])<=int(row['budget_bytes'])
                key,calibration=identities(row)
                if key in by_id:
                    by_id[key]['represented_budget_bpk'].append(budget)
                    continue
                record=dict(row)
                record.update(key_power=power,represented_budget_bpk=[budget],
                    configuration_id=hashlib.sha256(json.dumps(key).encode()).hexdigest()[:24],
                    calibration_identity=hashlib.sha256(json.dumps(calibration).encode()).hexdigest()[:24])
                by_id[key]=record;planned.append(record);selected.append(row['filter'])
            if selected:cases.append(dict(key_power=power,budget_bpk=budget,filters=selected))
    return dict(schema=1,registry=registry,key_powers=powers,budget_bpk=budgets,
        configurations=planned,cases=cases,unsupported=unsupported,
        deduplication='Same API alias, real n, actual bytes, geometry and effective probes measured once; calibration identities identify identical samples and must not be pooled across API rows.')

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--binary',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--key-powers',default='16,25');p.add_argument('--budgets',default='12,14,16,20,24,28,32');a=p.parse_args()
    result=generate(a.binary.resolve(),list(map(int,a.key_powers.split(','))),list(map(int,a.budgets.split(','))))
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(f"Planned {len(result['configurations'])} unique configurations in {len(result['cases'])} cases; unsupported {len(result['unsupported'])}")
