"""Extract exact retained text; never invoke disassembler/compiler/filter."""
import csv,hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent;SOURCE=HERE.parent/'validation-v2'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
meta=json.loads((SOURCE/'metadata.json').read_text());assert meta['complete']
for c in meta['commands']:
 for stream in ['stdout','stderr']:assert sha(SOURCE/c[stream])==c[stream+'_sha256']
assert sha(SOURCE/'assembly-spans.json')==meta['assembly']['sha256']
a=json.loads((SOURCE/'assembly-spans.json').read_text());rel={}
for line in (SOURCE/'asm-relocations.stdout').read_text().splitlines():
 c=line.split()
 if len(c)>=4 and c[2]=='R_X86_64_RELATIVE':rel[int(c[0],16)]=int(c[3],16)
assert rel[0x2638e0]==0x23c8e0 and rel[0x2638f0]==0x23c8f0
rows=[]
for r in a['spans']:
 names=r['demangled_names'];match=next((re.fullmatch(r'poppy_raw_benchmark::report::<poppy_raw_benchmark::poppy_raw::PoppyRaw<(\d+), (false|true)>>',n)for n in names if 'report::<'in n and 'PoppyRaw<'in n),None)
 if not match:continue
 lines=r['instructions'];address=lambda line:int(re.match(r'\s*([0-9a-f]+):',line)[1],16)
 clocks=[l for l in lines if 'call' in l and '# 2638e0 'in l];elapsed=[l for l in lines if 'call'in l and '# 2638f0 'in l]
 assert len(clocks)==4 and len(elapsed)==1
 start,ready,done,query=map(address,clocks);end=address(elapsed[0])
 within=lambda lo,hi:[l for l in lines if lo<address(l)<hi]
 ctor=[l for l in within(start,ready)if 'call'in l and 'RawFilter>::new' in l];insert=[l for l in within(ready,done)if 'call'in l and 'raw_contract::raw_insert' in l]
 batch=[l for l in within(query,end)if 'call'in l and 'raw_contract::raw_batched' in l];visible=[l for l in within(query,end)if 'call'in l and 'raw_contract::raw_visible' in l]
 assert len(ctor)==len(insert)==len(batch)==len(visible)==1
 poison=[l for l in lines if address(l)<query and 'movl   $0xfffffffe' in l];assert poison
 assert not any('posix_memalign' in l or 'memset' in l for l in within(start,done)), 'Unexpected direct scratch alloc in build window'
 target=lambda l:int(re.search(r'call\s+([0-9a-f]+)',l)[1],16)
 rows.append(dict(id=int(match[1]),typed=match[2],report=hex(r['address']),bytes=r['size'],allocate_start=hex(start),constructor_call=hex(address(ctor[0])),constructor_target=hex(target(ctor[0])),insert_ready=hex(ready),insert_call=hex(address(insert[0])),insert_target=hex(target(insert[0])),build_done=hex(done),poison_scalar=hex(address(poison[-1])),query_start=hex(query),batched_call=hex(address(batch[0])),batched_target=hex(target(batch[0])),visible_call=hex(address(visible[0])),visible_target=hex(target(visible[0])),query_elapsed=hex(end)))
assert len(rows)==28 and len({r['id']for r in rows})==14
for id in {r['id']for r in rows}:
 pair=[r for r in rows if r['id']==id];assert len(pair)==2 and pair[0]['constructor_target']==pair[1]['constructor_target']
with (HERE/'clock-map.csv').open('w')as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
functions=[]
for line in (SOURCE/'asm-elf.stdout').read_text().splitlines():
 c=line.split(None,7)
 if len(c)==8 and c[0].endswith(':')and c[0][:-1].isdigit()and c[3]=='FUNC'and c[6]not in ['UND','ABS']:functions.append(dict(address=int(c[1],16),size=int(c[2],0),name=c[7],binding=c[4],section=c[6]))
ins=[]
for l in (SOURCE/'asm-disassembly.stdout').read_text().splitlines():
 m=re.match(r'^\s*([0-9a-f]+):\s+(\S+)',l)
 if m and not m[2].startswith('R_'):ins.append((int(m[1],16),l))
constructors=[]
for line in (SOURCE/'asm-nm-demangled.stdout').read_text().splitlines():
 c=line.split(None,3)
 if len(c)!=4 or 'poppy_raw::PoppyRaw'not in c[3]or 'RawFilter>::new'not in c[3]:continue
 addr,size=int(c[0],16),int(c[1],16);symbols=[f for f in functions if(f['address'],f['size'])==(addr,size)];body=[l for n,l in ins if addr<=n<addr+size]
 assert symbols and body and address(body[0])==addr
 constructors.append(dict(address=addr,size=size,demangled_name=c[3],elf_symbols=symbols,folded_aliases=[f for f in functions if f['address']==addr],instructions=body))
assert len(constructors)==14
value=dict(binary=a['binary'],binary_sha256=a['binary_sha256'],source_text_sha256={p.name:sha(p)for p in [SOURCE/'assembly-spans.json',SOURCE/'asm-elf.stdout',SOURCE/'asm-nm-demangled.stdout',SOURCE/'asm-disassembly.stdout',SOURCE/'asm-relocations.stdout']},clock_rows=len(rows),clock_map_sha256=sha(HERE/'clock-map.csv'),clock_relocations={'0x2638e0':'0x23c8e0 Instant::now','0x2638f0':'0x23c8f0 Instant::elapsed'},constructor_spans=constructors,scope='Extraction from existing actual ELF text only; no new disassembly, compiler or filter execution')
(HERE/'EXTRACT.json').write_text(json.dumps(value,indent=2)+'\n');print(json.dumps({'clock_rows':len(rows),'constructor_spans':len(constructors)}))
