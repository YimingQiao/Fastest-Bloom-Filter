#!/usr/bin/env python3
"""Replay completed proof and recapture actual linked assembly; no BF/build."""
import argparse,csv,io,json,re,shutil,subprocess,sys,traceback
from pathlib import Path
HERE=Path(__file__).resolve().parent;CALLER=HERE.parent
sys.path.insert(0,str(CALLER/'preflight'))
from bindings import ROOT,OUTPUT,OLD,sha,save,exact,need,verify
from contract import TESTS,TINY,P,cases,argv,invalid,keyed,semantic,compare,validate_rows
from lease import require_lease
SOURCE='6fd92279f8fe98f5eef44054e3e2cabf567fa7ad'
FAILED='4a73933eba18497f6f5623a2cadab66582526304'
FAILED_SHA='6410f3e10ef5d53b61bcc3ecc763528a74901c2ab8a1fc9ed2f64dabb5c68f2d'
DEST=HERE/'capture-v2'
def frozen(commit):
    manifest=HERE/'PREPARATION.json';exact(commit,manifest)
    for name,digest in json.loads(manifest.read_text())['files'].items():
        path=HERE/name;need(path.resolve().is_relative_to(HERE),'Source path escape');exact(commit,path);need(sha(path)==digest,'Recovery source changed')
    inventory=verify(SOURCE);path=CALLER/'FAILED_V1_ARCHIVE.json';exact(FAILED,path);need(sha(path)==FAILED_SHA,'Failed-attempt manifest changed')
    for name,digest in json.loads(path.read_text())['files'].items():
        path=CALLER/name;need(path.resolve().is_relative_to(CALLER),'Failed archive escape');exact(FAILED,path);need(sha(path)==digest,'Failed-attempt artifact changed')
    meta=json.loads((OUTPUT/'metadata.json').read_text());need(meta['complete']is False and meta['error']=="ValueError('Empty symbol disassembly')",'Changed original failure')
    need(meta['source_commit']==SOURCE and len(meta['binaries'])==4,'Wrong original functional proof')
    for group in [meta['binaries'],meta['toolchains'],*meta['compiler_inputs'].values()]:
        for name,digest in group.items():need(sha(name)==digest,'Actual binary/tool/input changed')
    return inventory,meta
def replay(inventory,meta):
    source=(CALLER/'benchmark/src/main.rs').read_text();by_label={x['label']:x for x in meta['commands']}
    need(len(meta['commands'])==len(by_label)==47,'Changed command count')
    for r in meta['commands']:
        need(r['complete']and (r['returncode']==0)==r['expected_success'],'Unexpected command status')
        for stream in ['stdout','stderr']:need(sha(OUTPUT/r[stream])==r[stream+'_sha256'],'Raw command drift')
    reference={};rows_by_mode={};comparisons=0
    for mode in ['normal','asan']:
        binary=Path(meta['mode_executables'][mode]);observed=[];by_batch={}
        for test in TESTS:
            r=by_label[mode+'-test-'+test]
            need(r['command'][1:]==[test,'--test-threads=1']and r['command'][0]in meta['binaries'],'Wrong test invocation')
            need('test result: ok. 1 passed'in(OUTPUT/r['stdout']).read_text(),'Focused test did not pass')
        for i,case in enumerate(cases(source)):
            record=by_label[f'{mode}-case-{i}'];need(record['command']==argv(binary,case),'Changed actual workload')
            rows=list(csv.DictReader(io.StringIO((OUTPUT/record['stdout']).read_text())));validate_rows(rows,case,TINY,source);observed.extend(rows)
            if mode=='normal'and case['order']=='original':
                r=by_label['reference-batch-'+str(case['batch'])];need(r['command']==argv(inventory['original_binary']['path'],case,True),'Wrong original reference command')
                old=list(csv.DictReader(io.StringIO((OUTPUT/r['stdout']).read_text())));rc=dict(case,filters=[x for x in case['filters']if x!=P]);validate_rows(old,rc,TINY,source);reference[case['batch']]=old
            comparisons+=compare(rows,reference[case['batch']]);need(by_batch.setdefault(case['batch'],keyed(rows))==keyed(rows),'Reverse semantics differ')
        for i,command in enumerate(invalid(binary,source)):
            r=by_label[f'{mode}-invalid-{i}'];need(r['command']==command and not(OUTPUT/r['stdout']).read_bytes()and(OUTPUT/r['stderr']).read_bytes(),'Invalid CLI proof differs')
        rows_by_mode[mode]=observed
    need([semantic(r)for r in rows_by_mode['normal']]==[semantic(r)for r in rows_by_mode['asan']],'Backend semantics differ')
    need(len(rows_by_mode['normal'])==len(rows_by_mode['asan'])==12 and comparisons==16,'Incomplete bounded proof')
    return dict(commands=47,successes=35,expected_rejects=12,focused_tests=8,real_capacity_fixtures=16,caller_rows=24,reference_rows=4,reference_semantic_comparisons=16,binaries=4,normal_inputs=len(meta['compiler_inputs']['normal']),asan_inputs=len(meta['compiler_inputs']['asan']))
def instructions(text):
    return [int(m.group(1),16)for line in text.splitlines()if(m:=re.match(r'^\s*([0-9a-f]+):\s+\S',line))]
def main():
    need(__debug__,'Python -O forbidden');p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);args=p.parse_args()
    lease=require_lease(2);inventory,old=frozen(args.source_commit);counts=replay(inventory,old)
    need(not DEST.exists()and not DEST.is_symlink(),'Preserve previous capture');DEST.mkdir();binary=Path(old['mode_executables']['normal'])
    meta=dict(complete=False,source_commit=args.source_commit,failed_commit=FAILED,failed_manifest_sha256=FAILED_SHA,reused_functional_counts=counts,binary=str(binary),binary_sha256=sha(binary),lease=lease,commands=[],compiler_runs=0,filter_runs=0,manual_review_pending=True)
    def persist():save(DEST/'metadata.json',meta)
    def run(label,command):
        need(require_lease(2)==lease,'Lease drift');record=dict(label=label,command=list(map(str,command)),complete=False);meta['commands'].append(record);persist()
        r=subprocess.run(record['command'],cwd=ROOT,capture_output=True,pass_fds=tuple(lease['inherited_lock_descriptors']))
        for stream,data in [('stdout',r.stdout),('stderr',r.stderr)]:
            path=DEST/(label+'.'+stream);path.write_bytes(data);record[stream]=path.name;record[stream+'_sha256']=sha(path)
        record['returncode']=r.returncode;persist();need(r.returncode==0 and not r.stderr,'Failed disassembly attempt retained');record['complete']=True;persist();return r.stdout.decode()
    persist()
    try:
        tools={n:Path(shutil.which(n)or'/missing').absolute()for n in ['nm','objdump']};need(all(p.is_file()for p in tools.values()),'Missing tools');meta['tool_sha256']={str(p):sha(p)for p in tools.values()}
        names=run('symbols',[tools['nm'],'--defined-only','--print-size','--demangle',binary]);run('full',[tools['objdump'],'-d','--demangle','--no-show-raw-insn',binary])
        selected=[]
        for line in names.splitlines():
            f=line.split(None,3)
            if len(f)!=4:continue
            address,size,kind,name=f
            if 'PoppyPublic<44>'not in name or not('::run::<'in name or '::Filter>::new'in name):continue
            start=int(address,16);stop=start+int(size,16);need(stop>start,'Empty actual symbol size');label='typed-'+str(len(selected))
            text=run(label,[tools['objdump'],'-d','--demangle','--no-show-raw-insn',f'--start-address={start}',f'--stop-address={stop}',binary]);pcs=instructions(text)
            need(pcs and pcs[0]==start and all(start<=pc<stop for pc in pcs),'Actual instruction span missing/wrong')
            need(name in text,'Selected symbol header missing');selected.append(dict(name=name,start=start,stop=stop,instruction_count=len(pcs),artifact=label+'.stdout'))
        need(len(selected)==2 and sum('::run::<'in r['name']for r in selected)==1,'Expected actual Poppy44 run and constructor')
        after,old_after=frozen(args.source_commit);need(after==inventory and old_after==old and require_lease(2)==lease,'Final source/proof/lease changed')
        for name,digest in meta['tool_sha256'].items():need(sha(name)==digest,'Capture tool changed')
        meta.update(complete=True,selected=selected,scope='Disassembly capture and offline functional replay only; manual timer/public-body review remains separate');persist();print(json.dumps(counts))
    except BaseException as error:meta.update(error=repr(error),traceback=traceback.format_exc());persist();raise
if __name__=='__main__':main()
