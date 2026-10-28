#!/usr/bin/env python3
"""Prepared Clang inline61 preflight; run only with an approved socket lease/flock."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--cpu',type=int,default=3)
args=parser.parse_args()
expected=json.loads((HERE/'registry.expected.json').read_text())
provenance=json.loads((HERE/'parent-provenance.json').read_text())
parent_freeze=json.loads((ROOT/provenance['inline60_freeze']).read_text())
assert sha(ROOT/provenance['inline60_freeze'])==provenance['inline60_freeze_sha256']
for name in provenance['untouched_parent_files']:
    assert sha(HERE/name)==provenance['copied_parent_files'][name]['source_sha256'],name
assert sha(HERE/'word16.hpp')==provenance['word16_local_sha256']
records=[];binaries=[]
for label,count,options in (
    ('native',19,['-DBF_INLINE_REPRESENTATIVE=ON']),
    ('asan',19,['-DBF_INLINE_REPRESENTATIVE=ON','-DBF_SANITIZERS=ON']),
    ('full',61,['-DBF_INLINE_REPRESENTATIVE=OFF']),
):
    build=ROOT/('build/word16-clang-inline-'+label)
    for step,command in (
        ('configure',['cmake','-S',str(HERE),'-B',str(build),'-DCMAKE_CXX_COMPILER=clang++',*options]),
        ('build',['cmake','--build',str(build),'--parallel','1']),
        ('ctest',['ctest','--test-dir',str(build),'--output-on-failure','-V']),
        ('cli',['python3',str(HERE/'check_benchmark.py'),str(build),'--expected',str(count),*(['--registry',str(HERE/'registry.json')] if label=='full' else [])]),
    ):
        argv=['taskset','-c',str(args.cpu),*command];started=time.monotonic()
        with (HERE/(label+'-'+step+'.log')).open('w') as log:
            result=subprocess.run(argv,cwd=ROOT,stdout=log,stderr=subprocess.STDOUT)
        records.append(dict(label=label,step=step,cpu=args.cpu,argv=argv,returncode=result.returncode,seconds=time.monotonic()-started))
        (HERE/'validation.json').write_text(json.dumps(records,indent=2)+'\n')
        print(label,step,result.returncode,flush=True);result.check_returncode()
    checksums=re.findall(r'word16 oracle and tail checksum (\d+)',(HERE/(label+'-ctest.log')).read_text())
    assert checksums==['9063729662564169232','9063729662564169232'],checksums
    binaries.extend(build/name for name in ('benchmark','check','fault_pure','fault_raw','word16_check','word16_check_scalar'))
observed=json.loads((HERE/'registry.json').read_text())
assert observed['count']==61 and observed['filters']==expected['filters']
# The original 60-config source and binaries must still match their parent freeze.
for name,digest in {**parent_freeze['source_sha256'],**parent_freeze['binary_sha256']}.items():
    assert sha(ROOT/name)==digest,name
sources={p for p in HERE.iterdir() if p.suffix in ('.cpp','.hpp','.py') or p.name in ('CMakeLists.txt','registry.json','registry.expected.json','parent-provenance.json')}
for name in parent_freeze['source_sha256']:
    sources.add(ROOT/name)
freeze=dict(cpu=args.cpu,source_sha256={str(p.relative_to(ROOT)):sha(p) for p in sorted(sources)},
            binary_sha256={str(p.relative_to(ROOT)):sha(p) for p in binaries},
            original_inline60_sources_and_binaries_unchanged=True,word16_oracle_checksum=9063729662564169232,
            note='Clang representative19/ASan19/full61 preflight passed; assembly audit required before any timing.')
(HERE/'freeze.json').write_text(json.dumps(freeze,indent=2)+'\n')
print('PASS inline61 and include-only Word16 oracle; assembly audit still required',flush=True)
