#!/usr/bin/env python3
"""Separate bounded worker proof and fixed accuracy launch; never measures time."""
if not __debug__:
    raise RuntimeError('Python -O forbidden')
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import contract
import lease

HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
ROOT = PARENT.parents[1]


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path, value):
    Path(path).write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')


def read(path):
    return contract.read(Path(path).read_text())


def blob(commit, path, expected=None):
    contract.need(type(commit) is str and re.fullmatch('[0-9a-f]{40}', commit), 'immutable commit required')
    path = Path(path)
    contract.need(not path.is_symlink() and path.resolve().is_relative_to(ROOT), 'unsafe source path')
    data = subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))], cwd=ROOT)
    contract.need(data == path.read_bytes(), 'committed byte mismatch: '+str(path))
    if expected is not None:
        contract.need(hashlib.sha256(data).hexdigest() == expected, 'committed hash mismatch')
    return data


def inventory(directory, commit, filename='PREPARATION.json', expected=None):
    info = contract.read(blob(commit,directory/filename,expected).decode())
    paths = {directory/filename}
    for name, item in info['files'].items():
        path = directory/name
        contract.need(path.resolve().is_relative_to(directory), 'inventory escape')
        data = blob(commit,path,item['sha256'])
        contract.need(len(data) == item['bytes'], 'inventory length')
        paths.add(path)
    return paths


def sources(commit):
    paths = inventory(HERE,commit)
    binding = read(HERE/'source-binding.json')
    paths |= inventory(PARENT,binding['parent_source_commit'],expected=binding['parent_preparation_sha256'])
    old = blob(binding['helper_source_commit'],ROOT/binding['helper_source_path'],binding['helper_source_sha256']).decode()
    helpers = old[old.index('struct SplitMix64 {'):old.index('\n\n\nstruct Case {')]
    input_struct = old[old.index('struct Input {'):old.index('\nstruct Output {')]
    body = old[old.index('        Input d;d.inserted_raw.resize(n)'):old.index('        Shuffle(jobs,rng);')]
    header = '#pragma once\n#include "../snapshot/base.h"\n#include <algorithm>\n#include <cstdint>\n#include <numeric>\n#include <vector>\nusing bloom_filters::HashVector;\n'+helpers+'\n'+input_struct+'\ninline Input MakeInput(size_t n, size_t q) {\n    struct { uint64_t seed=42; unsigned hit=50; } c;\n'+body+'    return d;\n}\n'
    contract.need((HERE/'input.hpp').read_text() == header, 'shared input helper changed')
    old_lease = blob(binding['helper_source_commit'],ROOT/binding['lease_source_path'],binding['lease_source_sha256'])
    contract.need((HERE/'lease.py').read_bytes() == old_lease, 'lease helper changed')
    blob(binding['parent_proof_commit'],PARENT/'PROOF_ARCHIVE.json',binding['parent_proof_archive_sha256'])
    proof = contract.read(blob(binding['parent_proof_commit'],PARENT/'COMPILED_PROOF.json',binding['parent_compiled_proof_sha256']).decode())
    contract.need(proof['complete'] is True and proof['source_commit'] == binding['parent_source_commit'], 'parent proof incomplete')
    for path in (HERE/'worker.cpp',HERE/'input.hpp'):
        contract.need(not re.search(r'chrono|Clock::|clock_gettime|rdtsc|steady_clock',path.read_text()), 'timer code forbidden')
    return {str(p.resolve()):sha(p) for p in paths}


def dependencies(depfile, prepared):
    text = depfile.read_text().replace('\\\n',' ')
    contract.need(':' in text, 'invalid depfile')
    result = {}
    for token in shlex.split(text.split(':',1)[1]):
        path = Path(token)
        path = (path if path.is_absolute() else ROOT/path).resolve()
        contract.need(path.is_file(), 'missing compiler input')
        if path.is_relative_to(ROOT):
            contract.need(str(path) in prepared, 'unprepared repository input: '+str(path))
        result[str(path)] = sha(path)
    for path in (HERE/'worker.cpp',HERE/'input.hpp',PARENT/'candidate.hpp',PARENT/'control.hpp',
                 PARENT/'snapshot/base.h',PARENT/'snapshot/layout_detail.h',PARENT/'snapshot/split64_range_size.h'):
        contract.need(str(path) in result, 'missing required compiler input: '+str(path))
    return result


def archive(directory):
    files = sorted(p for p in directory.iterdir() if p.is_file() and p.name != 'ARCHIVE.json')
    save(directory/'ARCHIVE.json',{'files':{p.name:{'sha256':sha(p),'bytes':p.stat().st_size} for p in files}})


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--source-commit',required=True)
    group = ap.add_mutually_exclusive_group(required=True)
    group.add_argument('--prove-worker',action='store_true')
    group.add_argument('--execute-accuracy',action='store_true')
    ap.add_argument('--proof-commit')
    args = ap.parse_args()
    contract.need(bool(args.proof_commit) == args.execute_accuracy, 'proof commit required only for accuracy')
    prepared = sources(args.source_commit)
    placement = lease.require()
    fds = tuple(int(fd) for fd in placement['fd_evidence'])
    out = HERE/('proof-v1' if args.prove_worker else 'results-v1')
    contract.need(not out.exists() and not out.is_symlink(), 'preserve existing attempt')
    compiler = Path(shutil.which('clang++')).absolute() # Do not resolve the C++ driver spelling.
    numa = Path(shutil.which('numactl')).absolute()
    tools = {str(p):sha(p) for p in (compiler,numa,Path(sys.executable).absolute())}
    out.mkdir()
    meta = {'complete':False,'source_commit':args.source_commit,'placement':placement,
            'tools':tools,'commands':[],'binaries':{},'compiler_inputs':{},'rows':[],
            'scope':'worker correctness only' if args.prove_worker else 'fixed 16-row accuracy only'}
    save(out/'metadata.json',meta)

    def unchanged():
        contract.need(sources(args.source_commit) == prepared, 'source closure changed')
        contract.need(lease.require() == placement, 'lease or environment changed')
        for collection in (tools,meta['compiler_inputs']):
            for path,d in collection.items(): contract.need(sha(path) == d, 'tool/input changed: '+path)
        for b in meta['binaries'].values(): contract.need(sha(b['path']) == b['sha256'], 'binary changed')

    def run(label,argv,expected_error=None):
        unchanged()
        result = subprocess.run(argv,cwd=ROOT,capture_output=True,pass_fds=fds)
        stdout,stderr = out/(label+'.stdout'),out/(label+'.stderr')
        stdout.write_bytes(result.stdout); stderr.write_bytes(result.stderr)
        meta['commands'].append({'label':label,'argv':argv,'returncode':result.returncode,
            'stdout':stdout.name,'stdout_sha256':sha(stdout),'stderr':stderr.name,'stderr_sha256':sha(stderr)})
        save(out/'metadata.json',meta)
        if expected_error is None:
            contract.need(result.returncode == 0, 'command failed; retained: '+label)
        else:
            contract.need(result.returncode == 1 and not result.stdout and result.stderr == expected_error.encode(),
                          'wrong rejection; retained: '+label)
        return result

    if args.prove_worker:
        run('compiler-version',[str(compiler),'--version'])
        run('numa-policy',[str(numa),'--physcpubind=3','--membind=1','--show'])
        common = ['-std=c++17','-O3','-march=native','-fno-strict-aliasing','-Wall','-Wextra','-Werror',
                  '-I'+str(PARENT/'snapshot')]
        for profile in ('normal','asan'):
            build = ROOT/('build/independent32-range-accuracy-v1-'+profile)
            contract.need(not build.exists() and not build.is_symlink(), 'fresh build directory required')
            build.mkdir()
            executable,depfile = build/'worker',build/'worker.d'
            flags = common+(['-fsanitize=address,undefined','-fno-omit-frame-pointer'] if profile=='asan' else [])
            run(profile+'-build',[str(compiler),*flags,'-MD','-MF',str(depfile),str(HERE/'worker.cpp'),'-o',str(executable)])
            # Persist executable identity before parsing .d, preserving partial success on failure.
            meta['binaries'][profile] = {'path':str(executable),'sha256':sha(executable)}
            save(out/'metadata.json',meta)
            (out/(profile+'.d')).write_bytes(depfile.read_bytes())
            inputs = dependencies(depfile,prepared)
            for path,d in inputs.items():
                contract.need(path not in meta['compiler_inputs'] or meta['compiler_inputs'][path] == d,'profile input drift')
                meta['compiler_inputs'][path] = d
            save(out/'metadata.json',meta)
            result = run(profile+'-check',[str(numa),'--physcpubind=3','--membind=1',str(executable),'--check','12'])
            contract.need(not result.stderr, 'unexpected worker diagnostic')
            rows = contract.parse(result.stdout,12,False)
            if meta['rows']: contract.need(rows == meta['rows'],'normal/ASan semantic difference')
            else: meta['rows'] = rows
            save(out/'metadata.json',meta)
        exe = meta['binaries']['normal']['path']
        prefix = [str(numa),'--physcpubind=3','--membind=1',exe]
        run('fault',[*prefix,'--fault','12'],'public dense output mismatch\n')
        run('bad-mode',[*prefix,'--measure','12'],'fixed accuracy/check grid required\n')
        run('bad-power',[*prefix,'--accuracy','12'],'fixed accuracy/check grid required\n')
        unchanged()
        meta['complete'] = True
        save(out/'metadata.json',meta)
        save(out/'WORKER_PROOF.json',{'complete':True,'source_commit':args.source_commit,
            'source_manifest_sha256':sha(HERE/'PREPARATION.json'),'tools':tools,
            'binaries':meta['binaries'],'compiler_inputs':meta['compiler_inputs'],
            'successful_worker_records':4,'fault_rejections':1,'invalid_rejections':2})
        archive(out)
        print('Complete worker proof: 4 tiny records, 1 fault, 2 invalid; no formal accuracy',flush=True)
    else:
        inventory(HERE/'proof-v1',args.proof_commit,'ARCHIVE.json')
        proof = read(HERE/'proof-v1/WORKER_PROOF.json')
        contract.need(proof['complete'] is True and proof['source_commit'] == args.source_commit and
                      proof['source_manifest_sha256'] == sha(HERE/'PREPARATION.json'), 'different worker source')
        contract.need(proof['tools'] == tools,'worker tool environment changed')
        meta['binaries'] = proof['binaries']; meta['compiler_inputs'] = proof['compiler_inputs']
        meta['proof_commit'] = args.proof_commit
        save(out/'metadata.json',meta)
        for power in (16,25):
            result = run('n'+str(power),[str(numa),'--physcpubind=3','--membind=1',
                meta['binaries']['normal']['path'],'--accuracy',str(power)])
            contract.need(not result.stderr,'unexpected worker diagnostic')
            meta['rows'].extend(contract.parse(result.stdout,power,True))
            save(out/'metadata.json',meta)
            print('Completed '+str(len(meta['rows']))+'/16 accuracy rows',flush=True)
        decision = contract.decision(meta['rows'])
        unchanged()
        save(out/'rows.json',meta['rows']); save(out/'decision.json',decision)
        meta['complete'] = True
        meta['counts'] = {'processes':2,'rows':16,'quality_records':16,'timed_trials':0}
        save(out/'metadata.json',meta); archive(out)
        print('Complete fixed 16-row accuracy; no timing executed or authorized',flush=True)


if __name__ == '__main__':
    main()
