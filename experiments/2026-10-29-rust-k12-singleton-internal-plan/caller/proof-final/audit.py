"""Offline replay of the bounded proof; no compiler or BF execution."""
if not __debug__:raise RuntimeError('Python -O forbidden')
import json
from pathlib import Path
import sys

HERE=Path(__file__).resolve().parent
CALLER=HERE.parent
sys.path.insert(0,str(CALLER))
from guards import verify,sha,need,save,PROOF,PROPOSAL
from contract import cases,argv,validate_rows,invalid,SEMANTIC
SOURCE='23e9b075a295deb11c3073cc3b4182b5810a9057'
OUT=CALLER/'validation-v1'

def main():
    prepared=verify(SOURCE)
    meta=json.loads((OUT/'metadata.json').read_text())
    need(meta['complete'] and meta['functional_complete'] and meta['source_commit']==SOURCE,'incomplete proof')
    need(meta['formal_measurements']==meta['calibration_queries']==meta['kernel_matrix_reexecutions']==0,'wrong scope')
    need(meta['manual_assembly_review_pending'],'original metadata was changed')
    need(not any(meta['environment'].values()),'environment override')
    need(meta['affinity']==[3] and meta['lease']['cpu']==3 and meta['topology']['socket']==1 and meta['topology']['nodes']==[1],'placement differs')
    need(meta['workload_prefix'][1:3]==['-c','3'] and meta['workload_prefix'][-2:]==['--physcpubind=3','--membind=1'],'NUMA prefix differs')
    commands={r['label']:r for r in meta['commands']}
    need(len(commands)==len(meta['commands'])==43 and len(meta['binaries'])==2,'wrong finite command/bin count')
    for rec in commands.values():
        need(rec['complete'],'unfinished command')
        for stream in ['stdout','stderr']:need(sha(OUT/rec[stream])==rec[stream+'_sha256'],'log drift')
        rejection=rec['expected_rejection']
        need(rec['returncode']==(1 if rejection is not None else 0),'wrong command status')
        if rejection is not None:
            need((OUT/rec['stdout']).read_bytes()==b'' and (OUT/rec['stderr']).read_bytes()==(rejection+'\n').encode(),'rejection differs')
    actual={};signatures={};ledger=[]
    for profile in ['native','portable']:
        binary=meta['executables'][profile]
        build=commands[profile+'-caller-build']
        expected_flags='-C target-cpu='+('native' if profile=='native' else 'x86-64')+' -C symbol-mangling-version=v0'
        need(build['explicit_environment']==dict(CARGO_TARGET_DIR='/tmp/fastest-bf-rust-k12-simd-internal-v1-cpu3/'+profile,RUSTFLAGS=expected_flags),'compiler flags differ')
        need(build['command']==['cargo','build','--release','--locked','--offline','--manifest-path',str(CALLER/'Cargo.toml'),'--message-format=json','--bin','rust-k12-simd-caller'],'build command differs')
        for index,case in enumerate(cases()):
            rec=commands[f'{profile}-case-{index}']
            need(rec['command']==meta['workload_prefix']+argv(binary,case),'case command differs')
            need((OUT/rec['stderr']).read_bytes()==b'','caller stderr')
            rows=[json.loads(line) for line in (OUT/rec['stdout']).read_text().splitlines()]
            validate_rows(rows,case,profile)
            values=[{k:r[k] for k in SEMANTIC} for r in sorted(rows,key=lambda r:r['filter'])]
            key=(case['batch'],case['reverse']);need(signatures.setdefault(key,values)==values,'cross-profile semantics differ')
            ledger.append(dict(profile=profile,case=case,rows=2))
        for index,(command,diagnostic) in enumerate(invalid(binary)):
            rec=commands[f'{profile}-invalid-{index}']
            need(rec['command']==meta['workload_prefix']+command and rec['expected_rejection']==diagnostic,'invalid CLI differs')
        for fault in ['generic-skip','visible-wrong']:
            rec=commands[f'{profile}-fault-{fault}']
            need(rec['command']==meta['workload_prefix']+argv(binary,dict(batch=1,reverse=False))+['--fault',fault]
                 and rec['expected_rejection']=='full output mismatch','fault differs')
        closure=json.loads((OUT/f'{profile}-compiler-closure.json').read_text())
        need(closure['inputs_sha256']==meta['compiler_inputs'][profile],'compiler closure differs')
        for index,rule in enumerate(closure['rules']):need((OUT/f'{profile}-dependency-{index}.d').read_text()==rule['text'],'actual dep-info differs')
        for path,digest in closure['inputs_sha256'].items():need(actual.setdefault(path,digest)==digest,'inconsistent input digest')
    need(ledger==meta['cases'],'case ledger differs')
    for mapping in [meta['binaries'],meta['toolchains'],actual]:
        for path,digest in mapping.items():need(sha(Path(path))==digest,'live artifact changed: '+path)
    assembly_tools={}
    for profile,descriptor in meta['assembly'].items():
        path=OUT/descriptor['path'];need(sha(path)==descriptor['sha256'],'capture changed')
        cap=json.loads(path.read_text());need(cap['binary_sha256']==meta['binaries'][cap['binary']],'capture binary differs')
        for path,digest in cap['tools_sha256'].items():
            need(sha(Path(path))==digest and assembly_tools.setdefault(path,digest)==digest,'assembly tool differs')
        for span in cap['spans']:need(sha(OUT/span['body_file'])==span['body_sha256'],'assembly span changed')
    need(sum(r['returncode']==0 for r in commands.values())==31,'successful command count differs')
    need((meta['caller_rows'],meta['invalid_cli_cases'],meta['fault_cases'])==(20,8,4),'finite runtime count differs')
    result=dict(complete=True,source_commit=SOURCE,proposal_commit=PROPOSAL,prior_kernel_proof_commit=PROOF,
                manual_assembly_review='passed',metadata_sha256=sha(OUT/'metadata.json'),
                executables={k:dict(path=v,sha256=meta['binaries'][v]) for k,v in meta['executables'].items()},
                all_binary_sha256=meta['binaries'],actual_input_sha256=actual,prepared_input_sha256=prepared,
                toolchains_sha256=meta['toolchains'],assembly_tools_sha256=assembly_tools,
                preparation_sha256=sha(CALLER/'PREPARATION.json'),launch_log_sha256=sha(CALLER/'launch-v1.log'),
                manual_review_sha256=sha(CALLER/'assembly-review/REVIEW.md'),
                counts=dict(commands=43,success=31,rejections=12,caller_rows=20,invalid_cli=8,faults=4,
                            binaries=2,actual_inputs=len(actual)),
                formal_measurements=0,calibration_queries=0,kernel_matrix_reexecutions=0,incidental_timings_not_ranked=True)
    save(CALLER/'COMPILED_PROOF.json',result)
    summary=dict(complete=True,counts=result['counts'],proof_sha256=sha(CALLER/'COMPILED_PROOF.json'))
    save(HERE/'AUDIT.json',summary);print(json.dumps(summary,sort_keys=True))

if __name__=='__main__':main()
