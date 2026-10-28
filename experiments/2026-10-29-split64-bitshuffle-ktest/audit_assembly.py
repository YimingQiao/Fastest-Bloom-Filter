#!/usr/bin/env python3
"""Retain all candidate/original query wrappers and their generated call boundaries."""
import hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
BINARY=ROOT/'build/split64-bitshuffle-ktest-native/compare_benchmark'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
frozen=json.loads((HERE/'freeze.json').read_text())
for name,digest in {**frozen['source_sha256'],**frozen['binary_sha256']}.items():assert sha(ROOT/name)==digest,name
OUT=HERE/'assembly';OUT.mkdir(exist_ok=True)
text=subprocess.check_output(['objdump','-d','-C','--no-show-raw-insn',str(BINARY)],text=True)
parts=re.split(r'(?m)^([0-9a-f]+ <[^\n]+>:)\n',text)
functions=[];kernels=[]
for i in range(1,len(parts),2):
    symbol=parts[i];body=parts[i+1]
    if 'lookup_kernel<' in symbol:
        kernels.append(symbol)
    is_query=('lookup_kernel<' in symbol or '::Lookup(' in symbol or '::LookupOne' in symbol or '::TestBits<' in symbol)
    is_filter=('Split64BitShuffle' in symbol or 'FastPatternBF' in symbol)
    if not(is_query and is_filter):continue
    address=symbol.split()[0];(OUT/(address+'.asm')).write_text(symbol+'\n'+body)
    functions.append(dict(symbol=symbol,assembly_file=address+'.asm',calls=[line.strip() for line in body.splitlines() if re.search(r'\bcallq?\s',line)],instructions={op:len(re.findall(r'\b'+op+r'\b',body)) for op in ('vpshufbitqmb','vpsrlvq','vpsllvq','vpmovzxdq','vpmulld','vptestnmq','kmovq','ktestq')}))
assert len(kernels)==6,kernels
for policy in range(3):
    assert any(f'Split64BitShuffleCandidate<{policy}>' in f['symbol'] and f['instructions']['vpshufbitqmb']>0 for f in functions),policy
ktest=[f for f in functions if 'Split64BitShuffleKtestCandidate<0>' in f['symbol']]
assert ktest and any(f['instructions']['vpshufbitqmb']>0 and f['instructions']['ktestq']>0 for f in ktest),ktest
original=[f for f in functions if 'Split64BitShuffleOriginal' in f['symbol']]
assert original and not any(f['instructions']['vpshufbitqmb'] for f in original)
result=dict(binary_sha256=sha(BINARY),query_kernel_count=len(kernels),query_kernels=kernels,functions=functions,
            all_three_candidate_policies_emit_bitalg=True,original_query_has_no_bitalg=True,frozen_inputs_and_binaries_unchanged=True,
            scope='Assembly evidence only. GPR/mask transfers and any remaining variable shifts are retained; no throughput inference or timing run.')
(OUT/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ('functions','query_kernels')},indent=2))
