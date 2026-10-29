"""Extract exact reviewed addresses from the captured native disassembly only."""
import hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent
HEADER=re.compile(r'^([0-9a-f]+) <(.*)>:$')
INSN=re.compile(r'^\s*([0-9a-f]+):')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def functions(text):
 result={};current=None
 for line in text.splitlines():
  match=HEADER.match(line)
  if match:current=int(match[1],16);result[current]=[line]
  elif current is not None:result[current].append(line)
 return result
def main():
 texts={n:(HERE/(n+'.stdout')).read_text()for n in ['public','query']};all_functions={k:functions(v)for k,v in texts.items()};records={}
 windows={
  'split-build':(0xba40,0xbaa0,[0xba50,0xba69,0xba83,0xba92]),
  'range-build':(0xe710,0xe7b0,[0xe730,0xe777,0xe796,0xe7a3]),
  'k12-build':(0x11290,0x11330,[0x112b0,0x112f7,0x11316,0x11323]),
  'split-query':(0xbed0,0xbf80,[0xbeef,0xbf60,0xbf65]),
  'split-query-reverse':(0xc0a0,0xc150,[0xc0bf,0xc138,0xc13d]),
  'range-query':(0xebe0,0xec90,[0xec05,0xec79,0xec7e]),
  'range-query-reverse':(0xedb0,0xee70,[0xedd9,0xee55,0xee5a]),
  'k12-query':(0x11770,0x11830,[0x11795,0x11809,0x11813]),
  'k12-query-reverse':(0x11950,0x11a10,[0x11979,0x119f5,0x119fe]),
 }
 for label,(begin,end,addresses)in windows.items():
  lines=[l for l in texts['public'].splitlines()if(m:=INSN.match(l))and begin<=int(m[1],16)<end]
  by_address={int(INSN.match(l)[1],16):l for l in lines};assert lines
  assert all(a in by_address and '\tcall' in by_address[a]for a in addresses)
  clocks=addresses[:2]+addresses[-1:]if label.endswith('build')else[addresses[0],addresses[-1]]
  assert all('steady_clock::now' in by_address[a]for a in clocks)
  target=addresses[-2];assert ('InsertParallel'if label.endswith('build')else'LookupParallel')in by_address[target]
  (HERE/(label+'.txt')).write_text('\n'.join(lines)+'\n');records[label]={'source':'public.stdout','begin':hex(begin),'end_exclusive':hex(end),'ordered_calls':[by_address[a].strip()for a in addresses]}
 bodies={
  'range-lookup-wrapper':('query',0x464c8),'k12-lookup-wrapper':('query',0x4dc10),
  'range-worker':('query',0x48850),'k12-worker':('query',0x51260),
  'range-executor':('query',0x48010),'k12-executor':('query',0x50a20),
  'split-public-query-body':('public',0x17ed0),'range-public-query-body':('public',0x1d060),'k12-public-query-body':('public',0x21500),
 }
 for label,(source,address)in bodies.items():
  lines=all_functions[source][address];assert len(lines)>1
  (HERE/(label+'.txt')).write_text('\n'.join(lines)+'\n');records[label]={'source':source+'.stdout','address':hex(address),'symbol':lines[0],'instruction_count':sum(INSN.match(l)is not None for l in lines)}
  if label.endswith('lookup-wrapper'):assert any('\tjmp' in l and '::Lookup('in l for l in lines)
  if label.endswith('worker'):assert any('0xd6e8feb86659fd93' in l for l in lines)and any('lookup_kernel<'in l and '\tcall'in l for l in lines)
  if label.endswith('executor'):assert sum('steady_clock::now' in l and '\tcall'in l for l in lines)==4 and any('std::thread::join' in l for l in lines)
  if label.endswith('public-query-body'):assert any('std::thread::join' in l for l in lines)
 capture=json.loads((HERE/'capture.json').read_text())
 (HERE/'REVIEW.json').write_text(json.dumps({'status':'manual caller/timer boundary review passed','capture':capture,'disassembly_sha256':{n:sha(HERE/(n+'.stdout'))for n in texts},'excerpts':records,'new_compiler_or_BF_runs':0},indent=2)+'\n')
 print('PASS',len(records),'nonempty actual native assembly excerpts; no compiler/BF')
if __name__=='__main__':main()
