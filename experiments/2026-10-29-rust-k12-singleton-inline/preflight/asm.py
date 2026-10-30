"""Address-bounded actual caller capture; no claim that inline hints succeeded."""
from pathlib import Path
import re,shutil

def capture(binary,output,run,sha):
    nm=Path(shutil.which('nm')or '/missing-nm').absolute();objdump=Path(shutil.which('objdump')or '/missing-objdump').absolute()
    if not nm.is_file()or not objdump.is_file():raise ValueError('GNU symbol/disassembly tools required')
    raw=run('normal-asm-nm',[nm,'--defined-only',binary]);demangled=run('normal-asm-demangled',[nm,'--defined-only','--demangle',binary])
    records=[]
    for line in raw.splitlines():
        fields=line.split(None,2)
        if len(fields)==3 and re.fullmatch('[0-9a-fA-F]+',fields[0]):records.append((int(fields[0],16),fields[1],fields[2]))
    selected=[];captured=set()
    for line in demangled.splitlines():
        fields=line.split(None,2)
        if len(fields)!=3:continue
        address,kind,name=fields
        if not any(p in name for p in ['four_sector_range12_isolated','four_sector_range12_inline_isolated','Split64RangeBloomFilter']):continue
        if not any(p in name for p in ['::lookup<','::lookup::<','::visible_lookup<','::visible_lookup::<','::contains_hash','::contains_scalar','::lookup_hashes','::lookup_avx','::lookup_scalar']):continue
        begin=int(address,16)
        if begin in captured:continue
        captured.add(begin);end=min(a for a,k,s in records if a>begin)
        symbols=[s for a,k,s in records if a==begin and k==kind];label='normal-asm-query-'+str(len(selected))
        text=run(label,[objdump,'-d','--demangle','--no-show-raw-insn','--start-address='+hex(begin),'--stop-address='+hex(end),binary])
        instructions=re.findall(r'^\s*([0-9a-f]+):\s+(\S+)',text,re.M)
        if not instructions or int(instructions[0][0],16)!=begin or any(not begin<=int(a,16)<end for a,m in instructions)or name not in text:raise ValueError('Missing actual bounded instructions '+label)
        selected.append(dict(begin=begin,end=end,demangled=name,symbols=symbols,artifact=label+'.stdout',instructions=len(instructions)))
    # Require both actual visible contracts for both independent crate identities.
    for family in ['four_sector_range12_isolated','four_sector_range12_inline_isolated']:
        visible=[s for s in selected if family in s['demangled']and 'visible_lookup' in s['demangled']]
        if len(visible)!=2:raise ValueError('Missing public visible pure/raw caller inventory '+family)
    return dict(binary=str(binary),sha256=sha(binary),tools_sha256={str(nm):sha(nm),str(objdump):sha(objdump)},selected=selected,
        scope='Actual linked public-query callers and retained helpers. Successful capture is not evidence of inlining; exact hot-call review follows. No filter execution by capture.')
