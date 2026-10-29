"""Actual ELF FUNC address/size capture, including folded aliases."""
import re
import shutil
from pathlib import Path
from guards import need,sha,save

def capture(binary,output,run,prefix):
    tools={n:str(Path(shutil.which(n) or '/missing').absolute()) for n in ['readelf','nm','objdump']}
    hashes={p:sha(p) for p in tools.values()}
    before=sha(binary)
    elf=run(prefix+'-elf',[tools['readelf'],'--wide','--symbols',binary])
    raw=run(prefix+'-nm',[tools['nm'],'--defined-only','--print-size',binary])
    dem=run(prefix+'-demangled',[tools['nm'],'--defined-only','--print-size','--demangle',binary])
    dis=run(prefix+'-disassembly',[tools['objdump'],'-drwC','--no-show-raw-insn',binary])
    run(prefix+'-relocations',[tools['readelf'],'--relocs','--wide',binary])
    symbols=[]
    for line in elf.splitlines():
        c=line.split(None,7)
        if len(c)==8 and c[0].endswith(':') and c[0][:-1].isdigit() and c[3]=='FUNC' and c[6] not in ['UND','ABS']:
            symbols.append(dict(address=int(c[1],16),size=int(c[2],0),name=c[7],binding=c[4],section=c[6]))
    raw_keys=set()
    for line in raw.splitlines():
        c=line.split(None,3)
        if len(c)==4 and re.fullmatch('[0-9a-fA-F]+',c[0]) and re.fullmatch('[0-9a-fA-F]+',c[1]):raw_keys.add((int(c[0],16),int(c[1],16),c[3]))
    instructions=[]
    for line in dis.splitlines():
        m=re.match(r'^\s*([0-9a-fA-F]+):\s+(\S+)',line)
        if m and not m[2].startswith('R_'):instructions.append((int(m[1],16),line))
    spans={};roles=set()
    for line in dem.splitlines():
        c=line.split(None,3)
        if len(c)!=4 or not re.fullmatch('[0-9a-fA-F]+',c[0]) or not re.fullmatch('[0-9a-fA-F]+',c[1]):continue
        addr,size,name=int(c[0],16),int(c[1],16),c[3]
        role=None
        for needle,label in [('::query::lookup_kernel','generic'),('::query::visible_pure','visible_pure'),
                             ('::query::visible_fused','visible_fused'),('::query::execute','dispatch'),
                             ('rust_k12_simd_caller::run','clock'),('rust_k12_simd_caller::timed_work','work')]:
            if needle in name:role=label;break
        if role is None and 'four_sector_range12::' in name and any('::'+n in name for n in ['contains_hash','lookup_hashes','contains_single_avx512','lookup_tiny_avx512']):role='native_public_or_target'
        if role is None or not size:continue
        matches=[s for s in symbols if s['address']==addr and s['size']==size and (addr,size,s['name']) in raw_keys]
        need(matches,'selected body lacks ELF FUNC identity')
        roles.add(role);key=(addr,size)
        if key in spans:spans[key]['names'].append(name);continue
        body=[l for pc,l in instructions if addr<=pc<addr+size]
        need(body and int(re.match(r'^\s*([0-9a-fA-F]+):',body[0])[1],16)==addr,'empty or wrong ELF span')
        path=output/(prefix+f'-span-{len(spans)}.txt');path.write_text('\n'.join(body)+'\n')
        spans[key]=dict(address=addr,size=size,role=role,names=[name],elf=matches,
                        all_same_address_aliases=[s for s in symbols if s['address']==addr],
                        body_file=path.name,body_sha256=sha(path))
    need({'generic','visible_pure','visible_fused','clock'}<=roles,'required actual caller role absent')
    for path,digest in hashes.items():need(sha(path)==digest,'ELF tool changed')
    need(sha(binary)==before,'binary changed during capture')
    result=dict(binary=str(binary),binary_sha256=before,tools_sha256=hashes,roles=sorted(roles),
                spans=list(spans.values()),manual_review_pending=True,
                limitation='Outlined native symbols are retained when present; absent methods may be inlined. Manual caller/callee/relocation trace is mandatory; no named-label gate.')
    path=output/(prefix+'-capture.json');save(path,result)
    return dict(path=path.name,sha256=sha(path),manual_review_pending=True)
