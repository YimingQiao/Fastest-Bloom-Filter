#!/usr/bin/env python3
"""Read archived text only; never disassemble, build or execute a filter."""
from pathlib import Path
import hashlib,json,re
HERE=Path(__file__).resolve().parent;CAP=HERE.parent/'capture-v2'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2)+'\n')
c=json.loads((CAP/'CAPTURE.json').read_text());needed=['rust-disassembly','rust-symbols','rust-relocations','rust-rlib-0','rust-rlib-1','rust-rlib-2']
for label in needed:
 row=next(x for x in c['commands']if x['label']==label)
 assert row['returncode']==0 and sha(CAP/(label+'.stdout'))==row['stdout_sha256']and sha(CAP/(label+'.stderr'))==row['stderr_sha256']
text=(CAP/'rust-disassembly.stdout').read_text();lines=text.splitlines();blocks={int(b[:16],16):b for b in re.split(r'(?m)^(?=[0-9a-f]{16} <)',text)if re.match('[0-9a-f]{16} <',b)}
rel={int(a,16):int(b,16)for a,b in re.findall(r'(?m)^([0-9a-f]+) R_X86_64_RELATIVE\s+\*ABS\*\+0x([0-9a-f]+)',(CAP/'rust-relocations.stdout').read_text())}
assert rel[0xa4728]==0x7b780 and rel[0xa4730]==0x7b790 and rel[0xa4538]==0x34c20 and rel[0xa4550]==0x38d40
symbols=(CAP/'rust-symbols.stdout').read_text();packages=[];trials=[]
for item in c['rlibs']:
 raw=(CAP/item['symbol_artifact']).read_text();tag=re.search(r'_RNvMNt(Cs[A-Za-z0-9]+)_20fastest_bloom_filter13split64_range',raw)[1]
 label='clone'if'/clone/'in item['manifest_path']else'after'if'/after/'in item['manifest_path']else'before'
 ids={};pub={}
 for family,encoded in [('Split64','7split6418Split64BloomFilter'),('Split64Range','13split64_range23Split64RangeBloomFilter')]:
  pat=r'(?m)^([0-9a-f]+) t (_RINv\S*policy_confirmation5trialNtNt'+tag+'_20fastest_bloom_filter'+encoded+r'\S*)$';m=re.search(pat,symbols);assert m;addr=int(m[1],16);ids[family]=hex(addr)
  entry=re.search(r'(?m)^([0-9a-f]+) T (_RNvMNt'+tag+r'_20fastest_bloom_filter\S*'+family+r'BloomFilter22insert_hashes_parallel)$',symbols);assert entry;pub[family]=hex(int(entry[1],16))
  (HERE/(label+'-'+family+'-trial.asm')).write_text(blocks[addr]);trials.append(dict(arm=label,family=family,address=hex(addr),raw_symbol=m[2],public_insert=pub[family]))
 packages.append(dict(arm=label,manifest=item['manifest_path'],package_id=item['package_id'],rlib=item['path'],rlib_sha256=item['sha256'],mangled_crate=tag,trial_addresses=ids,public_addresses=pub))
assert len({x['address']for x in trials})==6

def section(lo,hi):
 result=[]
 for line in lines:
  m=re.match(r'\s*([0-9a-f]+):',line)
  if m and lo<=int(m[1],16)<hi:result.append(line)
 return '\n'.join(result)+'\n'
(HERE/'main-arm-dispatch.asm').write_text(section(0x5a4da,0x5a580)+'\n'+section(0x5c81a,0x5c8b3))
(HERE/'after-entry-gates.asm').write_text('\n'.join(blocks[0x34c20].splitlines()[:42])+'\n\n'+'\n'.join(blocks[0x38d40].splitlines()[:45])+'\n')
clock=[dict(family='Split64Range',boundary='allocate_insert',now='0x4fa90',original_requested_load='0x4fb6f',insert='0x4fb7c',elapsed='0x4fb87',public_entry='0x34c20',got='0xa4538'),dict(family='Split64Range',boundary='insert',now='0x502ff',original_requested_load='0x5033e',insert='0x50347',elapsed='0x50352',public_entry='0x34c20',got='0xa4538'),dict(family='Split64',boundary='allocate_insert',now='0x508d9',original_requested_load='0x511f7',insert='0x51203',elapsed='0x51211',public_entry='0x38d40',got='0xa4550'),dict(family='Split64',boundary='insert',now='0x50fef',original_requested_load='0x5102e',insert='0x51037',elapsed='0x51042',public_entry='0x38d40',got='0xa4550')]
for x in clock:
 lo=int(x['now'],16);hi=int(x['elapsed'],16)+7;assert lo<int(x['original_requested_load'],16)<int(x['insert'],16)<hi
save(HERE/'evidence.json',dict(capture_sha256=sha(CAP/'CAPTURE.json'),binary=c['selected_normal_executables']['rust'],packages=packages,trials=trials,after_clock_intervals=clock,got_bindings={hex(k):hex(rel[k])for k in[0xa4728,0xa4730,0xa4538,0xa4550]},input_text_sha256={name:sha(CAP/name)for name in['CAPTURE.json','cargo-artifacts.json']+[x+'.stdout'for x in needed]},compiler_or_filter_executed=False,disassembler_executed=False))
print('Archived text proof:3 package identities,6 distinct trials,4 after-native clock intervals; no BF/compiler/disassembler')
