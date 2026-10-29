"""Capture actual public-query caller symbols; inspection is not a speed claim."""
from pathlib import Path
import re,shutil

def capture(binary,output,run,sha):
    nm=Path(shutil.which('nm')or '/missing-nm').absolute();objdump=Path(shutil.which('objdump')or '/missing-objdump').absolute()
    if not nm.is_file()or not objdump.is_file():raise ValueError('GNU symbol/disassembly tools required')
    raw=run('normal-asm-nm',[nm,'--defined-only',binary]);demangled=run('normal-asm-demangled',[nm,'--defined-only','--demangle',binary])
    symbols={}
    for line in raw.splitlines():
        fields=line.split(None,2)
        if len(fields)==3:symbols.setdefault((fields[0],fields[1]),[]).append(fields[2])
    selected=[]
    for line in demangled.splitlines():
        fields=line.split(None,2)
        if len(fields)!=3:continue
        address,kind,name=fields
        if 'four_sector_range12_isolated'not in name:continue
        if not any(part in name for part in ['::lookup<','::lookup::<','::visible_lookup<','::visible_lookup::<','::contains_hash','::contains_scalar','::lookup_hashes','::lookup_avx','::lookup_scalar']):continue
        for mangled in symbols[(address,kind)]:
            if any(x['symbol']==mangled for x in selected):continue
            text=run('normal-asm-query-'+str(len(selected)),[objdump,'-d','--demangle','--no-show-raw-insn','--disassemble='+mangled,binary])
            selected.append(dict(address=address,demangled=name,symbol=mangled,artifact='normal-asm-query-'+str(len(selected))+'.stdout'))
    if not selected:raise ValueError('No K12 public-query symbols captured; inspect retained symbol inventories')
    return dict(binary=str(binary),sha256=sha(binary),tools_sha256={str(nm):sha(nm),str(objdump):sha(objdump)},selected=selected,
        scope='Actual linked public-query symbols, preserved for read-only hot-call review; no timing or inlining assumption')
