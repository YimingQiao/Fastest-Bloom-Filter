#!/usr/bin/env python3
"""Record every final v2-direct optimizer-visible loop and genuine out-of-line call boundary."""
import hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
BINARY=ROOT/'build/inline-single-v2-direct-full/benchmark'
OUT=HERE/'assembly-v2-direct'
OUT.mkdir(exist_ok=True)
text=subprocess.check_output(['objdump','-d','-C','--no-show-raw-insn',str(BINARY)],text=True)
sections=re.split(r'(?m)^([0-9a-f]+ <[^\n]+>:)\n',text)
functions=[]
for i in range(1,len(sections),2):
 symbol=sections[i]
 if '<void inline_single_kernel<' not in symbol:continue
 body=sections[i+1]
 calls=[line.strip() for line in body.splitlines() if re.search(r'\bcallq?\s',line)]
 address=symbol.split()[0]
 (OUT/(address+'.asm')).write_text(symbol+'\n'+body)
 functions.append({'symbol':symbol,'calls':calls,'assembly_file':address+'.asm'})
assert len(functions)==120, len(functions)
adapter_calls=[{'symbol':f['symbol'],'call':call} for f in functions for call in f['calls']
               if (('::Lookup(' in call or '::ScalarContains(' in call) and 'bloomfilter::BloomFilter' not in call)]
boost=[f for f in functions if 'boost_baseline::Adapter<' in f['symbol']]
assert len(boost)==38,len(boost)
old=json.loads((HERE/'preflight-v1/experiment/assembly/audit.json').read_text())
old_map={f['symbol'].split(' ',1)[1]:f for f in old['functions']}
changed=[]
for f in functions:
 key=f['symbol'].split(' ',1)[1]
 before=old_map[key]
 if bool(before['calls'])!=bool(f['calls']):changed.append({'symbol':key,'v1_calls':before['calls'],'v2_calls':f['calls']})
freeze=json.loads((HERE/'freeze-v2-direct.json').read_text())
for name,expected in freeze['source_sha256'].items():
 assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==expected,name
for name,expected in freeze['binary_sha256'].items():
 assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==expected,name
archive=json.loads((HERE/'preflight-v1/path-map.json').read_text())
for name,item in archive['binaries'].items():
 assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==item['sha256'],name
intermediate=json.loads((HERE/'preflight-v2-unforced/path-map.json').read_text())
for name,item in intermediate['binaries'].items():
 assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==item['sha256'],name
result={'binary_sha256':hashlib.sha256(BINARY.read_bytes()).hexdigest(),'functions':functions,
        'outer_functions':len(functions),'functions_with_calls':sum(bool(f['calls']) for f in functions),
        'boost_outer_functions':len(boost),'boost_functions_with_calls':sum(bool(f['calls']) for f in boost),
        'adapter_level_call_sites':adapter_calls,'call_boundary_changes':changed,
        'v1_original_binaries_unchanged':True,'unforced_v2_binaries_unchanged':True,'v2_frozen_sources_and_binaries_match':True,
        'scope':'Every raw/prehash outer function is retained. Calls into genuine upstream Contain may remain; no upstream forced-inlining or storage edits were made.'}
(OUT/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ('functions','call_boundary_changes')},indent=2))
assert not adapter_calls,adapter_calls
assert not any(f["calls"] for f in boost),boost
assert all("bloomfilter::BloomFilter" in call and "::Contain(" in call for f in functions for call in f["calls"]), "Unexpected non-upstream call"
