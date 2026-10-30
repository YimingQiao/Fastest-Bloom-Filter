"""Capture actual linked symbols; manual body/clock review is still mandatory."""
from pathlib import Path
import shutil
def capture(binary,output,run,sha):
    tools={n:Path(shutil.which(n)or'/missing').absolute()for n in ['nm','objdump']}
    if not all(p.is_file()for p in tools.values()):raise ValueError('Missing disassembly tools')
    raw=run('normal-asm-nm',[tools['nm'],'--defined-only',binary])
    names=run('normal-asm-demangled',[tools['nm'],'--defined-only','--demangle',binary]);symbols={}
    for line in raw.splitlines():
        f=line.split(None,2)
        if len(f)==3:symbols.setdefault(tuple(f[:2]),[]).append(f[2])
    selected=[]
    for line in names.splitlines():
        f=line.split(None,2)
        if len(f)!=3:continue
        address,kind,name=f
        if not('PoppyPublic' in name and any(v in name for v in ['<44','::<44',', 44'])):continue
        if not any(v in name for v in ['::run<','::run::<','::insert<','::insert::<','::lookup<','::lookup::<','::visible_lookup<','::visible_lookup::<','::contains_hash','::lookup_hashes','::insert_hashes']):continue
        for symbol in symbols[(address,kind)]:
            if any(x['symbol']==symbol for x in selected):continue
            label='normal-asm-public-'+str(len(selected));text=run(label,[tools['objdump'],'-d','--demangle','--no-show-raw-insn','--disassemble='+symbol,binary])
            if not any(':'in x and '\t'in x for x in text.splitlines()):raise ValueError('Empty symbol disassembly')
            selected.append(dict(address=address,name=name,symbol=symbol,stdout=label+'.stdout'))
    # Full linked disassembly follows public calls into out-of-line upstream
    # functions. Merely finding the wrapper is never an inlining proof.
    run('normal-asm-full',[tools['objdump'],'-d','--demangle','--no-show-raw-insn',binary])
    if not selected:raise ValueError('No actual Poppy044 caller symbols captured')
    return dict(binary=str(binary),sha256=sha(binary),tools={str(p):sha(p)for p in tools.values()},selected=selected,manual_review_pending=True)
