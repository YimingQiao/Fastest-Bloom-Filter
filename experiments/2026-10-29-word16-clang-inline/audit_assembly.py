#!/usr/bin/env python3
"""Prepared read-only audit for all 122 Clang inline61 outer loops."""
import hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
BINARY=ROOT/'build/word16-clang-inline-full/benchmark'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
freeze=json.loads((HERE/'freeze.json').read_text())
for name,digest in {**freeze['source_sha256'],**freeze['binary_sha256']}.items():
    assert sha(ROOT/name)==digest,name
OUT=HERE/'assembly';OUT.mkdir(exist_ok=True)
text=subprocess.check_output(['objdump','-d','-C','--no-show-raw-insn',str(BINARY)],text=True)
sections=re.split(r'(?m)^([0-9a-f]+ <[^\n]+>:)\n',text)
functions=[]
for i in range(1,len(sections),2):
    symbol=sections[i]
    if '<void inline_single_kernel<' not in symbol:continue
    body=sections[i+1];address=symbol.split()[0]
    calls=[line.strip() for line in body.splitlines() if re.search(r'\bcallq?\s',line)]
    (OUT/(address+'.asm')).write_text(symbol+'\n'+body)
    functions.append(dict(symbol=symbol,calls=calls,assembly_file=address+'.asm',
        word16_instruction_counts={op:len(re.findall(r'\b'+op+r'\b',body)) for op in ('vpmullw','vpsrlw','vpsllvw','vptest')} if 'Word16Split256Experiment' in symbol else {}))
assert len(functions)==122,len(functions)
word16=[f for f in functions if 'Word16Split256Experiment' in f['symbol']]
assert len(word16)==2 and not any(f['calls'] for f in word16),word16
boost=[f for f in functions if 'boost_baseline::Adapter<' in f['symbol']]
assert len(boost)==38 and not any(f['calls'] for f in boost),boost
adapter_calls=[call for f in functions for call in f['calls'] if '::Lookup(' in call or '::ScalarContains(' in call]
assert not adapter_calls,adapter_calls
result=dict(binary_sha256=sha(BINARY),outer_functions=len(functions),functions_with_calls=sum(bool(f['calls']) for f in functions),
            boost_outer_functions=len(boost),boost_functions_with_calls=0,word16_outer_functions=word16,
            adapter_call_sites=adapter_calls,functions=functions,frozen_sources_and_binaries_unchanged=True,
            scope='Genuine upstream Contain boundaries may remain; record them without forcing upstream inline annotations. Opcode counts describe generated code only, not timings.')
(OUT/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='functions'},indent=2))
