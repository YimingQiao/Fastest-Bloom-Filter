#!/usr/bin/env python3
"""Read captured instructions and exact ELF relocations; no compiler or filter calls."""
from pathlib import Path
import hashlib,json,re,struct
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;RAW=STAGE/'validation-v1'
def need(ok,msg):
    if not ok:raise ValueError(msg)
def audit():
    meta=json.loads((RAW/'metadata.json').read_text());binary=Path(meta['mode_executables']['normal']);data=binary.read_bytes();need(hashlib.sha256(data).hexdigest()==meta['binaries'][str(binary)],'Binary changed')
    need(data[:6]==b'\x7fELF\x02\x01','Expected little-endian ELF64');shoff=struct.unpack_from('<Q',data,40)[0];entsize,count=struct.unpack_from('<HH',data,58)
    relocs={}
    for i in range(count):
        sec=struct.unpack_from('<IIQQQQIIQQ',data,shoff+i*entsize)
        if sec[1]!=4:continue # SHT_RELA
        for j in range(sec[4],sec[4]+sec[5],sec[9]):
            offset,info,addend=struct.unpack_from('<QQq',data,j)
            if info&0xffffffff==8:relocs[offset]=addend # R_X86_64_RELATIVE
    labels={}
    for line in (RAW/'normal-asm-demangled.stdout').read_text().splitlines():
        f=line.split(None,2)
        if len(f)==3:labels.setdefault(int(f[0],16),[]).append(f[2])
    summaries=[]
    for row in meta['assembly']['selected']:
        text=(RAW/row['artifact']).read_text();name=row['demangled'];instructions=[]
        for match in re.finditer(r'^\s*([0-9a-f]+):\s+(\S+)(.*)$',text,re.M):instructions.append((int(match[1],16),match[2],match[3].strip()))
        calls=[]
        for address,op,args in instructions:
            if op!='call':continue
            got=re.search(r'# ([0-9a-f]+) ',args);direct=re.match(r'([0-9a-f]+) ',args)
            target=relocs.get(int(got[1],16))if got else int(direct[1],16)if direct else None
            calls.append(dict(address=hex(address),args=args,target=None if target is None else hex(target),target_labels=labels.get(target,[])))
        entry_pushes=[];frame=None
        for address,op,args in instructions:
            if op=='push':entry_pushes.append(args)
            elif op=='sub'and'%rsp'in args:frame=int(re.search(r'\$0x([0-9a-f]+)',args)[1],16);break
            else:break
        one=dict(symbol=name,begin=hex(row['begin']),end=hex(row['end']),captured_span=row['end']-row['begin'],artifact=row['artifact'],entry_pushes=entry_pushes,entry_stack_subtract_bytes=frame,calls=calls)
        if 'visible_lookup' in name and 'four_sector_range12_inline_isolated'in name:
            ret=min(a for a,op,args in instructions if op=='ret');need(all(int(c['address'],16)>ret for c in calls),'Candidate has a call before successful return')
            need(all(c['target_labels']and all('core::panicking::'in label for label in c['target_labels'])for c in calls),'Unexpected candidate call target')
            one['successful_path_per_key_calls']=0;one['cold_calls_resolve_to_panic']=True
        if 'visible_lookup'in name and 'four_sector_range12_isolated'in name:
            need(sum(any('::contains_scalar'in label for label in c['target_labels'])for c in calls)==1,'Original outlined helper control disappeared')
            one['successful_path_per_key_calls']=1
        summaries.append(one)
    for family,expected in [('four_sector_range12_inline_isolated',0),('four_sector_range12_isolated',1)]:
        x=[s for s in summaries if family in s['symbol']and 'visible_lookup'in s['symbol']];need(len(x)==2 and all(v['successful_path_per_key_calls']==expected for v in x),'Visible gate incomplete')
    return dict(binary=str(binary),binary_sha256=hashlib.sha256(data).hexdigest(),complete=True,source_changed=False,compiler_or_bf_runs=0,interpretation='Both candidate public singleton chains are expanded in actual visible caller; register pressure/stack and code size remain costs, no speed claim.',symbols=summaries)
if __name__=='__main__':print(json.dumps(audit(),indent=2))
