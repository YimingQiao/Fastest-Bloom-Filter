#!/usr/bin/env python3
"""Committed scalar correctness, then a separately frozen 24-row accuracy pilot."""
import argparse,csv,hashlib,importlib.util,io,json,math,os,re,shlex,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
LEASE=ROOT/'experiments/2026-10-29-multiply-code-small-confirmation/driver/source_guard.py'
spec=importlib.util.spec_from_file_location('range_probe_lease',LEASE)
lease_module=importlib.util.module_from_spec(spec);spec.loader.exec_module(lease_module)
def need(ok,message):
    if not ok:raise ValueError(message)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2)+'\n')
def blob(commit,p):
    need(re.fullmatch('[0-9a-f]{40}',commit),'Full immutable commit required')
    return subprocess.check_output(['git','show',commit+':'+str(p.relative_to(ROOT))],cwd=ROOT)
def verify(commit):
    p=HERE/'PREPARATION.json';need(p.read_bytes()==blob(commit,p),'Uncommitted preparation')
    d=json.loads(p.read_text());files={**d['inputs'],**d['files'],str(p.relative_to(ROOT)):sha(p)}
    for name,digest in files.items():need(sha(ROOT/name)==digest and hashlib.sha256(blob(commit,ROOT/name)).hexdigest()==digest,'Changed source '+name)
    return files
def wilson(fp,n):
    need(0<=fp<=n and n>0,'Invalid counts');z=1.959963984540054;p=fp/n;s=1+z*z/n
    r=z*math.sqrt(p*(1-p)/n+z*z/(4*n*n));m=p+z*z/(2*n)
    return max(0,(m-r)/s),min(1,(m+r)/s)
def quality(rows,old):
    columns={'filter','keys','actual_bpk','filter_bytes','seed','calibration_negatives','false_positives','checksum'}
    expected=[(f'FourSectorRangeK{k}',1<<n,b)for n in (16,25)for b in (16,24,32)for k in (8,9,10,12)]
    need([(r['filter'],int(r['keys']),int(r['actual_bpk']))for r in rows]==expected,'Incomplete/reordered24-row grid')
    controls={(r['keys'],r['actual_bpk']):r for r in old if r['filter']=='FourSectorRange24'};need(len(controls)==6,'Missing old K8 controls')
    result=[]
    for row in rows:
        need(set(row)==columns,'Changed accuracy schema');n=int(row['keys']);b=int(row['actual_bpk']);q=int(row['calibration_negatives'])
        need(int(row['filter_bytes'])==n*b//8 and int(row['seed'])==42 and q==1<<24,'Wrong allocation/sample')
        need(0<=int(row['checksum'])<1<<64,'Invalid checksum')
        if row['filter']=='FourSectorRangeK8':need(dict(row,filter='FourSectorRange24')==controls[(row['keys'],row['actual_bpk'])],'Old K8 accuracy/checksum did not replay')
        fp=int(row['false_positives']);lo,hi=wilson(fp,q)
        result.append(dict(row,point_fpr=fp/q,wilson_lower=lo,wilson_upper=hi,pass_1pct=hi<=.01,pass_0_1pct=hi<=.001,pass_0_01pct=hi<=.0001))
    return result

def main():
    need(__debug__,'Do not disable checks');p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source-commit',required=True);p.add_argument('--cpu',type=int,choices=(2,3),required=True)
    a=p.add_mutually_exclusive_group(required=True);a.add_argument('--correctness',action='store_true');a.add_argument('--accuracy',action='store_true')
    p.add_argument('--freeze-commit');args=p.parse_args();lease=lease_module.require_lease(args.cpu);sources=verify(args.source_commit)
    out=HERE/('validation-v1'if args.correctness else'accuracy-v1');need(not out.exists()and not out.is_symlink(),'Preserve prior output');out.mkdir()
    meta=dict(complete=False,performance_run=False,source_commit=args.source_commit,source_sha256=sources,lease=lease,commands=[],binaries={},consumed_inputs={})
    save(out/'metadata.json',meta)
    def run(name,command):
        env=os.environ.copy();env.update(ASAN_OPTIONS='detect_leaks=1:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
        proc=subprocess.run(list(map(str,command)),cwd=ROOT,env=env,capture_output=True,pass_fds=tuple(lease['inherited_lock_descriptors']))
        (out/(name+'.stdout')).write_bytes(proc.stdout);(out/(name+'.stderr')).write_bytes(proc.stderr)
        meta['commands'].append(dict(name=name,command=list(map(str,command)),returncode=proc.returncode));save(out/'metadata.json',meta)
        print(name,proc.returncode,flush=True);need(proc.returncode==0,'Command failed; preserved '+name);return proc.stdout.decode()
    try:
        if args.correctness:
            need(not args.freeze_commit,'Preflight has no future freeze')
            run('compiler',['clang++','--version'])
            build=ROOT/'build'/'four-sector-range-probe-pilot-v1';need(not build.exists()and not build.is_symlink(),'Preserve earlier build');build.mkdir()
            for name,source,flags in [('check-native','check.cpp',['-O3']),('check-asan','check.cpp',['-O1','-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer']),('calibrate','calibrate.cpp',['-O3'])]:
                binary=build/name;dependency=out/(name+'.d')
                run(name+'-build',['clang++','-std=c++17','-march=native',*flags,'-I',ROOT/'include','-MD','-MF',dependency,HERE/source,'-o',binary])
                meta['binaries'][name]=dict(path=str(binary),sha256=sha(binary));deps={}
                for token in shlex.split(dependency.read_text().replace('\\\n',' '))[1:]:
                    path=Path(token);path=(path if path.is_absolute()else ROOT/path).resolve();digest=sha(path)
                    if path.is_relative_to(ROOT):need(sources.get(str(path.relative_to(ROOT)))==digest,'Unprepared consumed source '+str(path))
                    deps[str(path)]=digest
                need(str(HERE/source)in deps and str(HERE/'filter.hpp')in deps,'Missing actual candidate dependencies')
                meta['consumed_inputs'][name]=deps
                if name.startswith('check-'):
                    rows=[json.loads(line)for line in run(name+'-run',[binary]).splitlines()]
                    need([(r['requested_bytes'],r['k'])for r in rows]==[(b,k)for b in (128,129,192,320,262208,2097216,100663296)for k in (8,9,10,12)],'Missing correctness case')
                    need(all(r==dict(k=r['k'],requested_bytes=r['requested_bytes'],bytes=r['requested_bytes']//64*64,inserted=20480,tail_cases=548)for r in rows),'Incomplete correctness dimensions')
                    need(not(out/(name+'-run.stderr')).read_bytes(),'Unexpected correctness stderr')
            meta.update(correctness_cases=56,calibration_executed=False)
        else:
            need(args.freeze_commit,'Require separately committed preflight')
            proof=HERE/'validation-v1';manifest=proof/'archive.json'
            need(manifest.read_bytes()==blob(args.freeze_commit,manifest),'Uncommitted preflight archive')
            for name,digest in json.loads(manifest.read_text())['files'].items():need(sha(proof/name)==digest and hashlib.sha256(blob(args.freeze_commit,proof/name)).hexdigest()==digest,'Changed preflight evidence')
            frozen=json.loads((proof/'metadata.json').read_text())
            need(frozen['complete']and frozen['source_commit']==args.source_commit and frozen['correctness_cases']==56 and not frozen['calibration_executed'],'Incomplete preflight')
            meta.update(freeze_commit=args.freeze_commit,binaries=frozen['binaries'],consumed_inputs=frozen['consumed_inputs'])
            verify_compiled(meta)
            raw=run('calibration',[meta['binaries']['calibrate']['path']]);need(not(out/'calibration.stderr').read_bytes(),'Unexpected calibration stderr')
            old=list(csv.DictReader((HERE.parent/'2026-10-29-four-sector-range24/accuracy/results/results.stdout').open()))
            result=quality(list(csv.DictReader(io.StringIO(raw))),old);save(out/'quality.json',result);meta.update(rows=24,quality_records=24,k8_replays=6)
        need(verify(args.source_commit)==sources and lease_module.require_lease(args.cpu)==lease,'Source/lease drift');verify_compiled(meta)
        meta['complete']=True;save(out/'metadata.json',meta)
        save(out/'archive.json',dict(files={f.name:sha(f)for f in sorted(out.iterdir())if f.is_file()}))
    except BaseException as error:meta['failure']=repr(error);save(out/'metadata.json',meta);raise

def verify_compiled(meta):
    for record in meta['binaries'].values():need(sha(record['path'])==record['sha256'],'Changed executable')
    for deps in meta['consumed_inputs'].values():
        for path,digest in deps.items():need(sha(path)==digest,'Changed compiler input')
if __name__=='__main__':main()
