#!/usr/bin/env python3
"""Correctness/accounting only. Requires an explicit inherited CPU2 lease."""
import argparse,csv,io,json,shlex,subprocess,time
from pathlib import Path
import sys
RETRY=Path(__file__).resolve().parent
BASE=RETRY.parent
sys.path.insert(0,str(BASE))
from contract import HERE,ROOT,NATIVES,SURFACES,need,names,check_cases,arguments,parse_one,validate,parity,integer
from source_guard_v2 import verify,startup,sha,reused_legacy
from capture_inputs import capture
from capture_assembly import capture as capture_assembly

def accounting(raw,config,cap):
    rows=list(csv.DictReader(io.StringIO(raw)));need(len(rows)==3,'Expected three original accounting surfaces')
    need([r['filter'] for r in rows]==['public_dynamic','public_static','artifact_pimpl'],'Accounting surface order')
    for r in rows:
        need(None not in r and None not in r.values(),'Malformed accounting row')
        for k,v in r.items():
            if k not in ('filter','address','owned_heap_released'):integer(v)
        budget=(1<<25)*cap//8
        for k in ('budget_bytes','logical_bitmap_bytes','backing_bitmap_bytes','bitmap_heap_live_bytes'):need(integer(r[k])==budget,'Large bitmap not fully charged')
        need(integer(r['constructor_bits'])==budget*8 and r['address']==('pow2' if cap==16 else 'magic'),'Accounting geometry drift')
        need(integer(r['inserted_fixture_keys'])==65536 and integer(r['position_scratch_bytes'])==16384,'Accounting fixture/scratch drift')
        need(integer(r['api_requested_total_bytes'])==0 and r['owned_heap_released']=='true','API scratch or leaked owned allocation')
        need((integer(r['control_heap_live_bytes'])>0)==(r['filter']!='public_static'),'Wrong control allocation class')
    return rows

def stripped_compile(entry):
    command=entry.get('arguments') or shlex.split(entry['command']);out=[];i=0
    while i<len(command):
        if command[i]=='-o':i+=2;continue
        if command[i] not in ('-c',entry['file']):out.append(command[i])
        i+=1
    return out

def main():
    need(__debug__,'Python -O unsupported')
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source-commit',required=True);p.add_argument('--cpu',type=int,required=True);p.add_argument('--lease',required=True)
    p.add_argument('--build',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();held,tuner_file=startup(a.cpu,a.lease,a.build);inventory=verify(a.source_commit)
    need(not a.output.exists() and not a.output.is_symlink(),'Output must be new')
    a.build.mkdir(parents=True,exist_ok=False);a.output.mkdir(parents=True,exist_ok=False)
    initial=tuner_file();metadata=dict(scope='Stage3 worker correctness/accounting; no throughput or FPR gate',source_commit=a.source_commit,
      preparation_sha256=sha(HERE/'PREPARATION.json'),retry_preparation_sha256=sha(RETRY/'PREPARATION.json'),lease=held,tuner_file_before=initial,commands=[],binaries={},rows={},accounting_rows=[],complete=False)
    for rel in inventory['files']:
        dest=a.output/'source-snapshot'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes((ROOT/rel).read_bytes())
    def save():(a.output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    def run(label,cmd,fail=False,diagnostic=None):
        cmd=list(map(str,cmd));start=time.monotonic();r=subprocess.run(cmd,cwd=ROOT,text=True,capture_output=True)
        (a.output/(label+'.stdout')).write_text(r.stdout);(a.output/(label+'.stderr')).write_text(r.stderr)
        metadata['commands'].append(dict(label=label,command=cmd,returncode=r.returncode,diagnostic_elapsed_seconds=time.monotonic()-start));save()
        if fail:
            need(r.returncode==2 and not r.stdout,'Rejected CLI/fault emitted success/CSV')
            if diagnostic:need(diagnostic in r.stderr,'Wrong injected-failure diagnostic')
        else:need(r.returncode==0,label+' failed; logs retained')
        need(tuner_file()==initial,'Existing tuner file changed')
        return r.stdout
    save();run('compiler',['g++','--version']);archives=json.loads((HERE/'archives.json').read_text())['archives'];allrows=[]
    for backend in ('native','native-asan'):
        build=a.build/backend;archive=archives[backend]
        run(backend+'-configure',['cmake','-S',RETRY,'-B',build,'-DCMAKE_CXX_COMPILER=g++','-DVLDB_BACKEND='+backend,
             '-DVLDB_ARCHIVE='+str(ROOT/archive['path']),'-DVLDB_ARCHIVE_SHA256='+archive['sha256']])
        run(backend+'-build',['cmake','--build',build,'-j1'])
        database=json.loads((build/'compile_commands.json').read_text());expected=3 if backend=='native' else 2
        need(len(database)==expected and all(Path(x['file']).name in ('legacy.cpp','modern.cpp','accounting.cpp','allocation_audit.cpp') for x in database),'Unexpected original library rebuild')
        targets=['legacy','modern']+(['large_accounting'] if backend=='native' else [])
        for target in targets:
            binary=(reused_legacy() if backend=='native' and target=='legacy' else (build/target).resolve());retained=a.output/'binaries'/backend/target;retained.parent.mkdir(parents=True,exist_ok=True);retained.write_bytes(binary.read_bytes());retained.chmod(binary.stat().st_mode)
            metadata['binaries'][backend+'/'+target]=dict(path=str(binary),sha256=sha(binary),retained=str(retained.resolve()))
            inputs=capture(binary.parent if backend=='native' and target=='legacy' else build,target,'1_92' if target=='modern' else '1_83')
            (a.output/(backend+'-'+target+'-consumed-inputs.json')).write_text(json.dumps(inputs,indent=2)+'\n')
            macros=run(backend+'-'+target+'-macros',stripped_compile(inputs['compile_commands'][0])+['-dM','-E','-x','c++','/dev/null'])
            need('#define __AVX2__ 1' in macros and '#define __AVX512F__ 1' in macros,'Wrong native ISA')
            need(('__SANITIZE_ADDRESS__' in macros)==(backend=='native-asan'),'Wrong sanitizer boundary')
        rows=[]
        for worker in ('legacy','modern'):
            binary=reused_legacy() if backend=='native' and worker=='legacy' else (build/worker).resolve()
            need(run(backend+'-'+worker+'-names',[binary,'--names']).splitlines()==names(worker),'Registry mismatch')
            invalid=[[],['--plan','Unknown',10,16],['--plan',NATIVES[0],0,16],['--plan',NATIVES[0],10,0],
              ['--check',NATIVES[0],10,16,13,101,42,0,0],['--check',NATIVES[0],10,16,13,50,42,0,6],
              ['--measure',NATIVES[0],10,16,13,50,42,0,5]]
            for i,args in enumerate(invalid):run(backend+'-'+worker+'-invalid'+str(i),[binary,*args],fail=True)
            run(backend+'-'+worker+'-bad-output',[binary,'--check-bad-output',NATIVES[0],10,16,8,50,42,0,0],fail=True,diagnostic='full output mismatch')
        for i,c in enumerate(check_cases(backend)):
            raw=run(backend+'-case'+str(i).zfill(3),[reused_legacy() if backend=='native' and c['worker']=='legacy' else (build/c['worker']).resolve(),*arguments(c)])
            rows.append(validate(parse_one(raw),c))
        need(len(rows)==(158 if backend=='native' else 48),'Worker preflight coverage drift')
        allrows.extend(rows);parity(allrows);metadata['rows'][backend]=rows;save()
        if backend=='native':
            for worker in ('legacy','modern'):
                capture_assembly(reused_legacy() if worker=='legacy' else (build/worker).resolve(),a.output/'assembly'/worker)
            for config in ('sector32-u1','sector64-u1','register64-u0'):
                for cap in (16,24):
                    raw=run('accounting-'+config+'-'+str(cap),[(build/'large_accounting').resolve(),config,cap])
                    metadata['accounting_rows'].extend(dict(config=config,**r) for r in accounting(raw,config,cap));save()
        # End each backend with an exact source/archive/dependency check. Inputs
        # discovered by GCC are retained separately per complete Boost context.
        verify(a.source_commit)
    need(len(metadata['accounting_rows'])==18,'Incomplete large accounting')
    for name,record in metadata['binaries'].items():need(sha(Path(record['path']))==record['sha256'],'Binary changed: '+name)
    for f in a.output.glob('*-consumed-inputs.json'):
        for name,want in json.loads(f.read_text())['consumed_inputs'].items():need(sha(Path(name))==want,'Consumed header changed')
    metadata.update(complete=True,tuner_file_after=tuner_file(),all_sources_unchanged=True,alias_identities_checked=parity(allrows));save()
    print('Stage3 native/ASan workers and large accounting passed; no performance conclusion')

if __name__=='__main__':main()
