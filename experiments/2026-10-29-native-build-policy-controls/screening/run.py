#!/usr/bin/env python3
"""Execute exactly40 frozen four-arm processes; no training or rebuilding."""
if not __debug__:
    raise SystemExit('Python -O is forbidden before execution')
import argparse,json,subprocess,time
from screen_contract import HERE,ROOT,CALLER,PLAN,need,sha,original,command,parse,tables,csv_text,counts,audit
from freeze import PROOF,placement,verify


def dump(path,value):path.write_text(json.dumps(value,indent=2)+'\n')


def protocol():
    record=parse((HERE/'protocol.json').read_text());parent=parse((HERE.parent/'protocol.json').read_text())
    need(record['cases']==PLAN.ledger()and record['counts']==PLAN.validate(PLAN.ledger()),'Formal ledger changed')
    need(record['proof_commit']==PROOF and record['analysis_definition']==parent['analysis_definition'],'Proof/analysis prescription changed')
    need(record['engineering_latency_band']==[0.97,1.03]and record['ratio_direction']==parent['ratio_direction'],'Changed ratio or engineering band')
    need(record['primary_contrasts']==parent['primary_contrasts']and record['additional_retained_contrast']=='Policy/Clone','Changed contrasts')
    need(record['uncertainty']==parent['uncertainty']and record['primary_targets']==parent['primary_targets'],'Changed fixed estimator scope')
    return record


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True)
    parser.add_argument('--execute-frozen',action='store_true');args=parser.parse_args()
    need(args.execute_frozen,'Explicit reviewed execution flag required')
    placed=placement();sources,compiled=verify(args.source_commit);fixed=protocol()
    binaries=compiled['selected_normal_executables'];cases=fixed['cases'];output=HERE/'results-v1'
    need(not output.exists()and not output.is_symlink(),'Preserve every previous attempt');output.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,proof_commit=PROOF,source_sha256=sources,
              compiled_proof_sha256=sha(CALLER/'COMPILED_PROOF.json'),protocol_sha256=sha(HERE/'protocol.json'),
              binaries=binaries,placement=placed,started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),cases=[],counts=None)
    dump(output/'metadata.json',meta);records=[]
    try:
        for index,case in enumerate(cases):
            argv=command(binaries[case['language']]['path'],case,placed['lease'])
            saved=dict(case=case,command=argv,stdout=f'case-{index:03d}.stdout',stderr=f'case-{index:03d}.stderr',complete=False)
            meta['cases'].append(saved);dump(output/'metadata.json',meta);start=time.monotonic()
            process=subprocess.run(argv,cwd=ROOT,capture_output=True,pass_fds=tuple(placed['lease']['inherited_lock_descriptors']))
            for kind,data in [('stdout',process.stdout),('stderr',process.stderr)]:
                (output/saved[kind]).write_bytes(data);saved[kind+'_sha256']=sha(output/saved[kind])
            saved.update(returncode=process.returncode,diagnostic_process_seconds=time.monotonic()-start);dump(output/'metadata.json',meta)
            need(process.returncode==0 and not process.stderr,'Four-arm case failed; preserve all evidence')
            row=original.validate(parse(process.stdout.decode()),case,placed['lease']['child_cpus'][:case['requested']])
            records.append(row);saved['complete']=True
            need(placement()==placed,'Placement/environment changed');dump(output/'metadata.json',meta)
            print(f'{index+1}/40 complete cases validated; no partial ranking',flush=True)
        observed=counts(records,placed['lease'])
        dump(output/'four-arm-records.json',records);(output/'arm-results.csv').write_text(csv_text(tables(records)))
        final_sources,final_compiled=verify(args.source_commit)
        need(final_sources==sources and final_compiled==compiled and placement()==placed,'Final artifact/placement drift')
        meta.update(complete=True,counts=observed,final_frozen_inputs_equal=True,finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
        dump(output/'metadata.json',meta)
        audited,audited_counts=audit(output,meta,binaries,placed['lease'])
        need(audited==records and audited_counts==observed,'Final exact raw reconstruction failed')
        print('PASS40 processes/72 contracts/160 arms/288 vectors/9216 fresh lifetimes; no partial selection',flush=True)
    except BaseException as error:
        meta.update(complete=False,failure=repr(error));dump(output/'metadata.json',meta);raise


if __name__=='__main__':main()
