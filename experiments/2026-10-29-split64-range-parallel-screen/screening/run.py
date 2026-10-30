#!/usr/bin/env python3
"""Run only the reviewed fixed142-row performance protocol under one inherited lease."""
import sys
if not __debug__:
    raise SystemExit('Python -O is forbidden for the frozen performance driver')
import argparse
import csv
import json
import os
import platform
import subprocess
import time
import traceback
from pathlib import Path
from source_guard import HERE, STAGE, ROOT, sha, require, verify
from contract import command, parse_rows, validate_case, validate_matrix, validate_placement, identity
sys.path.insert(0,str(STAGE/'preflight-v3'))
from lease import require_lease


def topology(protocol):
    result=[]
    for cpu in protocol['cpus']:
        base=Path('/sys/devices/system/cpu')/('cpu'+str(cpu))
        item=dict(cpu=cpu,core=int((base/'topology/core_id').read_text()),socket=int((base/'topology/physical_package_id').read_text()),
                  nodes=sorted(int(p.name[4:]) for p in base.glob('node[0-9]*')))
        require(item['socket']==protocol['socket'] and item['nodes']==[protocol['numa_node']], 'Wrong CPU socket/NUMA placement')
        result.append(item)
    require(len(result)==protocol['threads']==8 and len({(r['socket'],r['core']) for r in result})==8, 'Expected8 physical execution cores')
    return result


def dump(path,value):
    path.write_text(json.dumps(value,indent=2)+'\n')


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit',required=True)
    parser.add_argument('--execute-frozen',action='store_true')
    args=parser.parse_args()
    require(args.execute_frozen,'Execution requires the reviewed explicit flag')
    lease=require_lease(3)
    require(not any(os.environ.get(k) for k in ('LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','GLIBC_TUNABLES')), 'Unprepared allocator/loader environment override')
    frozen=verify(args.source_commit)
    protocol=json.loads((HERE/'protocol.json').read_text())
    selection=json.loads((STAGE/'validation-v3/planned-selection.json').read_text())
    require(sha(STAGE/'validation-v3/planned-selection.json')==protocol['fixed_selection_sha256'],'Changed fixed142 selection')
    require(protocol['cases']==selection['cases'] and len(protocol['cases'])==13,'Changed exact case order')
    cpus=topology(protocol)
    out=STAGE/'screen'
    require(not out.exists(),'Never overwrite an existing measurement attempt')
    out.mkdir()
    meta=dict(complete=False,source_commit=frozen['commit'],frozen_before=frozen,lease=lease,topology=cpus,
              protocol_sha256=sha(HERE/'protocol.json'),platform=platform.platform(),start_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),
              process_affinity=sorted(os.sched_getaffinity(0)),cpuinfo=Path('/proc/cpuinfo').read_text(),
              environment={k:os.environ[k] for k in ('BF_SOCKET_LEASE','PATH','LD_LIBRARY_PATH','LD_PRELOAD','OMP_NUM_THREADS','MALLOC_CONF','GLIBC_TUNABLES') if k in os.environ},commands=[])
    validate_placement(meta,protocol)
    dump(out/'metadata.json',meta)
    rows=[]; fieldnames=None
    try:
        for index,case in enumerate(protocol['cases']):
            tag=f"case-{index:02d}-n{case['key_power']}-p{case['budget_bpk']}"
            cmd=command(frozen['benchmark'],case,protocol)
            stdout=out/(tag+'.stdout'); stderr=out/(tag+'.stderr')
            entry=dict(index=index,case=case,argv=cmd,stdout=stdout.name,stderr=stderr.name)
            meta['commands'].append(entry);dump(out/'metadata.json',meta)
            print(f"starting {index+1}/13 {tag} ({len(case['filters'])} configurations)",flush=True)
            begin=time.monotonic()
            with stdout.open('wb') as so,stderr.open('wb') as se:
                process=subprocess.run(cmd,cwd=ROOT,stdout=so,stderr=se,pass_fds=tuple(lease['inherited_lock_descriptors']))
            entry.update(returncode=process.returncode,wall_seconds=time.monotonic()-begin,stdout_sha256=sha(stdout),stderr_sha256=sha(stderr))
            dump(out/'metadata.json',meta)
            require(process.returncode==0,'Benchmark failed: '+tag)
            part=parse_rows(stdout.read_text())
            planned={r['filter']:r for r in selection['configurations'] if r['key_power']==case['key_power'] and int(r['requested_bpk'])==case['budget_bpk']}
            validate_case(part,case,planned,protocol)
            for row in part:
                config,calibration=identity(row)
                require(config==planned[row['filter']]['configuration_id'] and calibration==planned[row['filter']]['calibration_identity'],'Changed geometry identity')
                row.update(configuration_id=config,calibration_identity=calibration,case_index=str(index))
            if fieldnames is None: fieldnames=list(part[0])
            require(all(list(row)==fieldnames for row in part),'Changed CSV schema')
            with (out/'results.csv').open('a',newline='') as f:
                writer=csv.DictWriter(f,fieldnames=fieldnames,lineterminator='\n')
                if not rows:writer.writeheader()
                writer.writerows(part)
            rows.extend(part)
            print(f"validated {len(rows)}/142 rows",flush=True)
        meta['validation']=validate_matrix(rows,selection,protocol)
        actual=list(csv.DictReader((out/'results.csv').open(newline='')))
        require(actual==rows,'Aggregate CSV differs from validated raw rows')
        meta['frozen_after']=verify(args.source_commit)
        require(meta['frozen_before']==meta['frozen_after'],'Changed before/after source or binary freeze')
        require(require_lease(3)==lease,'Changed inherited socket lease')
        meta.update(complete=True,rows=len(rows),finish_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),results_sha256=sha(out/'results.csv'))
        dump(out/'metadata.json',meta)
        print('Complete:13 cases,142 validated rows; no ranking performed',flush=True)
    except BaseException:
        meta['error']=traceback.format_exc();dump(out/'metadata.json',meta);raise

if __name__=='__main__':main()
