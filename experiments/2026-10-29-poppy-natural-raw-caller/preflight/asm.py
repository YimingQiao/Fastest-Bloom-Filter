"""Address/size ELF capture; display labels are never a function-identity gate."""
import re,shutil
from pathlib import Path
from bindings import need,sha,save

def capture(binary,output,run):
    tools={name:str(Path(shutil.which(name)or'/missing').absolute())for name in ['readelf','nm','objdump']}
    for path in tools.values():need(Path(path).is_file(),'Missing ELF tool')
    tool_hashes={path:sha(path)for path in tools.values()}
    elf=run('asm-elf',[tools['readelf'],'--wide','--symbols',binary])
    raw=run('asm-nm',[tools['nm'],'--defined-only','--print-size',binary])
    dem=run('asm-nm-demangled',[tools['nm'],'--defined-only','--print-size','--demangle',binary])
    text=run('asm-disassembly',[tools['objdump'],'-drwC','--no-show-raw-insn',binary])
    run('asm-relocations',[tools['readelf'],'--relocs','--wide',binary])
    functions=[]
    for line in elf.splitlines():
        cols=line.split(None,7)
        if len(cols)==8 and cols[0].endswith(':')and cols[0][:-1].isdigit()and cols[3]=='FUNC'and cols[6]not in ['UND','ABS']:
            functions.append(dict(address=int(cols[1],16),size=int(cols[2],0),name=cols[7],binding=cols[4],section=cols[6]))
    names=[]
    for line in raw.splitlines():
        cols=line.split(None,3)
        if len(cols)==4 and re.fullmatch('[0-9a-fA-F]+',cols[0])and re.fullmatch('[0-9a-fA-F]+',cols[1]):names.append(dict(address=int(cols[0],16),size=int(cols[1],16),name=cols[3]))
    instructions=[]
    for line in text.splitlines():
        match=re.match(r'^\s*([0-9a-fA-F]+):\s+(\S+)',line)
        if match and not match.group(2).startswith("R_"):instructions.append((int(match.group(1),16),line))
    inventory=[];seen=set();categories=set()
    for line in dem.splitlines():
        cols=line.split(None,3)
        if len(cols)!=4 or not re.fullmatch('[0-9a-fA-F]+',cols[0])or not re.fullmatch('[0-9a-fA-F]+',cols[1]):continue
        address,size,name=int(cols[0],16),int(cols[1],16),cols[3]
        category=next((kind for kind in ['raw_visible','raw_batched','raw_insert']if 'poppy_raw_benchmark::raw_contract::'+kind in name),None)
        if category is None and any(part in name for part in ['poppy_raw_benchmark::reporter::run_raw','poppy_raw_benchmark::report<','poppy_raw_benchmark::report::','poppy_raw_benchmark::main']):category='construction_caller'
        # Public Poppy and its natural hash callees can inline or share bodies.
        # Capture every surviving upstream body, without requiring a symbol per K/form.
        if category is None and any(part in name for part in ['poppy_filters::','wyhash::']):category='poppy_public_or_hash_callee'
        if category is None or size==0:continue
        categories.add(category)
        raw_names={r['name']for r in names if r['address']==address and r['size']==size}
        matching=[r for r in functions if r['address']==address and r['size']==size and r['name']in raw_names]
        need(matching,'Selected method has no exact ELF FUNC address/size identity')
        key=(address,size)
        if key in seen:
            next(row for row in inventory if(row['address'],row['size'])==key)['demangled_names'].append(name);continue
        seen.add(key);body=[line for value,line in instructions if address<=value<address+size]
        need(body and int(re.match(r'^\s*([0-9a-fA-F]+):',body[0]).group(1),16)==address,'Empty or wrong address-bounded ELF body')
        inventory.append(dict(address=address,size=size,category=category,demangled_names=[name],elf_functions=matching,folded_aliases=[r for r in functions if r['address']==address],instructions=body))
    need({'raw_visible','raw_batched','raw_insert','construction_caller'}<=categories,'Missing actual caller categories')
    result=dict(binary=str(binary),binary_sha256=sha(binary),tools_sha256=tool_hashes,categories=sorted(categories),spans=inventory,manual_review_pending=True,scope='All observed caller specializations and folded aliases. No compiler/BF execution by capture; no speed or per-family codegen claim before manual review.')
    save(output/'assembly-spans.json',result)
    for path,digest in tool_hashes.items():need(sha(path)==digest,'ELF tool drift')
    return dict(path='assembly-spans.json',sha256=sha(output/'assembly-spans.json'),unique_spans=len(inventory),categories=sorted(categories),tools_sha256=tool_hashes,manual_review_pending=True)
