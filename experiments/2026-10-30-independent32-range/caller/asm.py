"""Actual ELF-sized caller spans; manual clock/callee interpretation is a later gate."""
import re
from pathlib import Path
from contract import need
from source_guard import HERE,sha

def capture(binary,tools,run):
    elf,_=run('normal-elf',[tools['readelf'],'-Ws',binary])
    functions={}
    for line in elf.read_text().splitlines():
        c=line.split()
        if len(c)>=8 and c[3]=='FUNC' and c[6]!='UND':
            try:start,size=int(c[1],16),int(c[2],0)
            except ValueError:continue
            if size>0:functions[c[7]]=(start,size)
    nm,_=run('normal-nm',[tools['nm'],'-S','--defined-only','--format=posix',binary])
    symbols=[]
    for line in nm.read_text().splitlines():
        c=line.split()
        if len(c)==4 and c[1] in ('t','T','w','W'):
            try:start,size=int(c[2],16),int(c[3],16)
            except ValueError:continue
            if size>0 and c[0] in functions:
                need(functions[c[0]]==(start,size),'nm/ELF size disagreement');symbols.append((c[0],start,size))
    displays,_=run('normal-demangle',[tools['c++filt']],input_text='\n'.join(s[0]for s in symbols)+'\n')
    names=displays.read_text().splitlines();need(len(names)==len(symbols),'symbol demangle count')
    captures=[];spans={}
    for (raw,start,size),display in zip(symbols,names,strict=True):
        role=next((r for r in ('Run<','lookup_kernel<','inline_single_kernel<')if r in display),None)
        if role is None or '.cold' in display:continue
        key=(start,size)
        if key not in spans:
            output,_=run('normal-asm-'+str(len(spans)),[tools['objdump'],'-d','--no-show-raw-insn',
                '--start-address='+str(start),'--stop-address='+str(start+size),binary])
            pcs=[int(m.group(1),16)for m in re.finditer(r'^\s*([0-9a-f]+):\s+\S',output.read_text(),re.M)]
            need(pcs and pcs[0]==start and all(start<=pc<start+size for pc in pcs),'empty/out-of-bounds actual ASM')
            spans[key]=dict(stdout=str(output.relative_to(HERE)),sha256=sha(output),instruction_count=len(pcs),
                aliases=[r for r,(a,z)in functions.items()if(a,z)==key])
        captures.append(dict(raw_symbol=raw,display_label=display,role=role,start=start,size=size,**spans[key]))
    for role,count in (('Run<',9),('lookup_kernel<',9),('inline_single_kernel<',18)):
        need(sum(x['role']==role for x in captures)==count,'missing typed actual role: '+role)
    reloc,_=run('normal-relocations',[tools['readelf'],'-rW',binary])
    return dict(binary=str(binary),sha256=sha(binary),symbols=captures,elf=str(elf.relative_to(HERE)),
        relocations=str(reloc.relative_to(HERE)),manual_review_pending=True,
        scope='Nine selected types only; exact aliases retained. Follow hot tail targets before closing manual gate.')
