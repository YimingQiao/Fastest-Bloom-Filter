#!/usr/bin/env python3
"""Additive correctness/allocator preflight only; never rank emitted smoke timings."""
if not __debug__:
    raise ValueError('Run without Python -O')
import argparse
import csv
import io
import itertools
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import time

from checks import (SEMANTICS, compare_retained, require, select_grid, source_registry,
                    validate_cli, validate_dense, validate_plan)
from lease import require_lease
from source_guard import HERE, ROOT, STAGE, sha, verify

CPUS=[3,5,7]
NODE=1
BUILD=ROOT/'build/split64-range-parallel-preflight-v3'
REFERENCE=ROOT/'build/exact-budget-range-native/benchmark'


def save(path,value):path.write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')


def parse(text):return list(csv.DictReader(io.StringIO(text)))


def canonical_dependency(token,directory):
    path=Path(token)
    return (path if path.is_absolute() else directory/path).resolve()


def placement_prefix(cpus):
    # libnuma validates physical CPUs against the process's current affinity.
    # Expand only this child before invoking numactl; the parent stays on CPU3.
    text=','.join(map(str,cpus))
    return ['taskset','-c',text,'numactl','--physcpubind='+text,'--membind='+str(NODE)]


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-commit',required=True)
    parser.add_argument('--execute-correctness',action='store_true',required=True)
    args=parser.parse_args()
    lease=require_lease(3)
    pins,old_binaries=verify(args.source_commit)
    out=STAGE/'validation-v3';out.mkdir(exist_ok=False)
    metadata=dict(complete=False,performance_run=False,source_commit=args.source_commit,lease=lease,
                  compiler_affinity=[3],cli_allowed_cpus=CPUS,cli_numa_node=NODE,
                  placement='Compilers pinned CPU3; correctness CLI allowed3,5,7 with explicit memory bindnode1; no timings claimed',
                  sources_sha256=pins,reference_binaries_sha256=old_binaries,commands=[],binaries_sha256={},consumed_headers_sha256={})
    save(out/'commands.json',metadata)
    environment=os.environ.copy()
    for name in ('CXXFLAGS','CFLAGS','CPPFLAGS','LDFLAGS','LD_PRELOAD'):
        require(not environment.get(name),'Unfrozen build/runtime environment: '+name)
    environment.update(ASAN_OPTIONS='detect_leaks=1:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1',TSAN_OPTIONS='halt_on_error=1')
    def run(tag,command,success=True):
        require(require_lease(3)==lease,'Parent correctness lease changed')
        command=list(map(str,command));start=time.monotonic()
        result=subprocess.run(command,cwd=ROOT,env=environment,capture_output=True)
        (out/(tag+'.stdout')).write_bytes(result.stdout);(out/(tag+'.stderr')).write_bytes(result.stderr)
        metadata['commands'].append(dict(name=tag,command=command,returncode=result.returncode,seconds=time.monotonic()-start,
                                         environment={k:environment[k] for k in ('ASAN_OPTIONS','UBSAN_OPTIONS','TSAN_OPTIONS')}))
        save(out/'commands.json',metadata)
        if success:require(result.returncode==0,'Failed '+tag+'; exact failed logs retained')
        print(tag,result.returncode,flush=True)
        return result
    def cli(binary,cap,hit,batch,workers,selection=None):
        selected=names if selection is None else selection
        return placement_prefix(CPUS)+[binary,
                '10',str(cap),str(hit),'14',str(batch),'2','731',','.join(selected),'1024','12',str(workers),','.join(map(str,CPUS[:workers]))]
    run('initial-source',[sys.executable,STAGE/'verify_source.py'])
    run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_*.py'])
    for name,command in [('clang-version',['clang++','--version']),('gcc-version',['g++','--version']),
                         ('cmake-version',['cmake','--version']),('numa-topology',['numactl','--hardware'])]:run(name,command)
    names=source_registry((STAGE/'adapters.hpp').read_text())
    require(names==json.loads((STAGE/'registry.json').read_text()),'Wrong recorded registry')
    bindings=json.loads((HERE/'bindings.json').read_text())
    cpp_fixture=[json.loads(line) for line in (ROOT/bindings['parity']['path']).read_text().splitlines()]
    require(len(cpp_fixture)==12,'Wrong native12-fixture reference')
    reuse=json.loads((HERE/'native-v2-build.json').read_text())
    cpp_source=ROOT/bindings['cpp_source_directory']
    metadata['reused_native_build']=reuse
    previous_dense,reference_rows=None,{}
    for mode in ('native','avx2','asan','tsan'):
        directory=ROOT/reuse['build_directory'] if mode=='native' else Path(str(BUILD)+'-'+mode)
        require(directory.exists() if mode=='native' else not directory.exists(),'Unexpected preflight build directory: '+str(directory))
        compiler='g++' if mode=='tsan' else 'clang++'
        configure=['cmake','-S',cpp_source,'-B',directory,'-DCMAKE_BUILD_TYPE=Release','-DCMAKE_CXX_COMPILER='+compiler,
                   '-DBF_NATIVE='+('OFF' if mode in ('avx2','tsan') else 'ON'),
                   '-DBF_SANITIZERS='+('ON' if mode=='asan' else 'OFF'),'-DBF_TSAN='+('ON' if mode=='tsan' else 'OFF'),
                   '-DBF_PAGE_AES=OFF','-DFETCHCONTENT_FULLY_DISCONNECTED=ON',
                   '-DFETCHCONTENT_SOURCE_DIR_FASTFILTER='+str(ROOT/'build/cpp-external/_deps/fastfilter-src'),
                   '-DFETCHCONTENT_SOURCE_DIR_PAGEBLOOM='+str(ROOT/'build/cpp-external/_deps/pagebloom-src')]
        if mode!='native':run(mode+'-configure',configure)
        targets=['benchmark','plan','check_adapters','check_executor'] if mode=='tsan' else ['all']
        if mode!='native':run(mode+'-build',['cmake','--build',directory,'--parallel','1','--target',*targets])
        compile_commands=directory/'compile_commands.json'
        (out/(mode+'-compile_commands.json')).write_bytes(compile_commands.read_bytes())
        consumed={}
        spellings=[]
        for dep in directory.rglob('*.o.d'):
            tokens=shlex.split(dep.read_text().replace('\\\n',' '))
            for token in tokens[1:]:
                path=canonical_dependency(token,directory)
                if path.is_relative_to(ROOT) and path.is_file():
                    name=str(path.relative_to(ROOT))
                    require(name in pins,'Unprepared repository header/source consumed: '+name)
                    require(sha(path)==pins[name],'Changed consumed header: '+name)
                    consumed[name]=pins[name]
                    spellings.append(dict(dependency_file=str(dep),original_path=token,canonical_repository_path=name))
        require(consumed and str((STAGE/'benchmark.cpp').relative_to(ROOT)) in consumed,'Missing actual compiler dependency files')
        metadata['consumed_headers_sha256'][mode]=consumed
        metadata.setdefault('consumed_dependency_spellings',{})[mode]=spellings
        test=['ctest','--test-dir',directory/'original','--output-on-failure']
        if mode=='tsan':test+=['-R','concurrent_complete_outputs|executor_contract_and_faults']
        run(mode+'-ctest',test)
        for executable in ('benchmark','plan','check_adapters','check_executor') + (() if mode=='tsan' else ('check_geometry',)):
            path=directory/'original'/executable;metadata['binaries_sha256'][str(path)]=sha(path)
        if mode!='tsan':
            fixture=run(mode+'-native-parity',[directory/'native_parity']).stdout.decode()
            require([json.loads(line) for line in fixture.splitlines()]==cpp_fixture,'Native Range complete12 fixture mismatch')
            dense={}
            for kind in ('current','reference'):
                raw=run(mode+'-dense-'+kind,[directory/('dense_'+kind)]).stdout.decode()
                dense[kind]=[json.loads(line) for line in raw.splitlines()]
            metadata.setdefault('dense_counts',{})[mode]=validate_dense(dense['current'],dense['reference'],names)
            require(previous_dense is None or previous_dense==dense,'Backend mode changed complete dense fixtures')
            previous_dense=dense
            for executable in ('native_parity','dense_current','dense_reference','allocation_actual'):
                path=directory/executable;metadata['binaries_sha256'][str(path)]=sha(path)
        plans={}
        for cap in (16,24,32):
            rows=parse(run(mode+f'-small-plan-{cap}',[directory/'original/plan','1024',str(cap)]).stdout.decode())
            validate_plan(rows,names,1024,cap);plans[cap]={r['filter']:r for r in rows}
        seen={}
        calibration_seen={}
        for cap,(hit,batch) in itertools.product((16,24,32),((0,1),(50,31),(100,4096))):
            for workers in (1,3):
                tag=f'{mode}-cli-p{cap}-h{hit}-b{batch}-t{workers}'
                rows=parse(run(tag,cli(directory/'original/benchmark',cap,hit,batch,workers)).stdout.decode())
                validate_cli(rows,names,plans[cap],cap,hit,batch,workers)
                for row in rows:
                    identity=(row['filter'],cap)
                    calibration=(row['calibration_absent_queries'],row['calibration_false_positives'])
                    require(identity not in calibration_seen or calibration_seen[identity]==calibration,'Hit/batch/T changed independent calibration')
                    calibration_seen[identity]=calibration
                key=(cap,hit,batch)
                if workers==1:
                    seen[key]=rows
                    if mode=='native':
                        aliases=['Split64RangeExperiment' if name=='Split64RangeNative' else name for name in names]
                        old=[REFERENCE,'10',str(cap),str(hit),'14',str(batch),'2','731',','.join(aliases),'1024','12','query-only','0']
                        raw=run('reference'+f'-p{cap}-h{hit}-b{batch}',['numactl','--physcpubind=3','--membind=1',*old]).stdout.decode()
                        reference_rows[key]=parse(raw)
                else:
                    a={r['filter']:r for r in seen[key]};b={r['filter']:r for r in rows}
                    require(all(a[name][field]==b[name][field] for name in names for field in SEMANTICS),'T changed query/calibration semantics')
                compare_retained(rows,reference_rows[key])
        bad=cli(directory/'original/benchmark',16,50,31,3)
        invalid=[]
        for selection in ('FastPatternBF,typo','FastPatternBF,FastPatternBF','FastPatternBF,',''):
            # Empty selection means all by contract, so use an empty item instead.
            command=list(bad);command[-5]=selection or ',FastPatternBF';invalid.append(command)
        for text in ('3,3,7','3,5','3,,7','999999,5,7','2,5,7'):
            command=list(bad);command[-1]=text;invalid.append(command)
        command=list(bad);command[-8]='16384';invalid.append(command) # workers exceed global batches
        command=list(bad);command[-2]='0';invalid.append(command)
        for index,command in enumerate(invalid):
            result=run(f'{mode}-invalid-{index}',command,False)
            require(result.returncode!=0 and not result.stdout,'Malformed CLI accepted/emitted partial CSV')
        save(out/'commands.json',metadata)
    # Actual construction validates the complete formal-size grid once; no inserts/queries.
    native=ROOT/reuse['build_directory']
    observed=[]
    for power,cap in itertools.product((16,25),(12,14,16,20,24,28,32)):
        actual=run(f'actual-k{power}-p{cap}',['numactl','--physcpubind=3','--membind=1',native/'allocation_actual',str(1<<power),str(cap)])
        rows=parse(actual.stdout.decode());validate_plan(rows,names,1<<power,cap)
        planned=parse(run(f'formal-plan-k{power}-p{cap}',[native/'original/plan',str(1<<power),str(cap)]).stdout.decode())
        require(rows==planned,'Constructor SizeInBytes disagrees with arithmetic planner')
        observed.extend(rows)
    selection=select_grid(observed,json.loads((STAGE/'selection-proposal.json').read_text()),names)
    save(out/'planned-selection.json',selection)
    final_pins,final_old=verify(args.source_commit)
    require(final_pins==pins and final_old==old_binaries,'Changed initial/additive/external sources')
    for name,digest in metadata['binaries_sha256'].items():require(sha(Path(name))==digest,'Preflight executable changed')
    metadata.update(complete=True,actual_allocation_rows=350,selected_rows=142,performance_run=False,
                    source_after_equal=True,correctness_cli_cases=72,correctness_cli_rows=1800,
                    frozen_serial_semantic_comparisons=1800,distinct_frozen_serial_rows=225,invalid_cli_cases=44)
    save(out/'commands.json',metadata)
    print('PASS native/AVX2/ASan/TSan correctness, full public outputs,350 actual allocations/142 fixed geometries; no performance matrix',flush=True)


if __name__=='__main__':main()
