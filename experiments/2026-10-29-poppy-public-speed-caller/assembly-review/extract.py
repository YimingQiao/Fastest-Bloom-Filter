#!/usr/bin/env python3
"""Extract review text from the captured binary, with no disassembler/BF run."""
import hashlib,json,re,struct
from pathlib import Path
HERE=Path(__file__).resolve().parent;CAP=HERE.parent/'assembly-recovery-v2/capture-v2'
BINARY=Path('/tmp/fastest-bf-poppy-public-caller-v1-cpu2/normal/release/compare_benchmark')
EXPECTED='637f176ddc93c486677dbe2a1ad70a77560336d03b4df92dc1f9eefc8316b40b'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def store(name,text):
    path=HERE/name
    if path.exists():assert path.read_text()==text,'Preserve earlier excerpt'
    else:path.write_text(text)
def main():
    assert sha(BINARY)==EXPECTED
    text=(CAP/'full.stdout').read_text();lines=text.splitlines(True);heads=[]
    for i,line in enumerate(lines):
        match=re.match(r'^([0-9a-f]{16}) <(.+)>:\n$',line)
        if match:heads.append((i,int(match[1],16),match[2]))
    functions={address:''.join(lines[index:heads[j+1][0]if j+1<len(heads)else len(lines)])for j,(index,address,name)in enumerate(heads)}
    names={address:name for _,address,name in heads}
    selected={0x56060:'run44.asm',0x17a680:'constructor44.asm',0xfcbe0:'insert.asm',0xfdb50:'dense.asm',0x34430:'visible-pure.asm',0x344f0:'visible-raw.asm',0xff3a0:'upstream-contains8.asm',0xfefd0:'upstream-insert8.asm'}
    for address,name in selected.items():
        body=functions[address];pcs=[int(m[1],16)for line in body.splitlines()if(m:=re.match(r'^\s*([0-9a-f]+):\s+\S',line))]
        assert pcs and pcs[0]==address;store(name,body)
    run=functions[0x56060]
    for name,start,end in [('build-pure-clock.asm',0x569b0,0x56cc0),('build-hash-clock.asm',0x56cec,0x57190),('query-clock.asm',0x578c0,0x57e22)]:
        body=''.join(line for line in run.splitlines(True)if(m:=re.match(r'^\s*([0-9a-f]+):',line))and start<=int(m[1],16)<end)
        assert body;store(name,body)
    # ELF64 little-endian R_X86_64_RELATIVE relocations bind the two indirect
    # clock slots to actual linked symbols, not guessed _DYNAMIC labels.
    data=BINARY.read_bytes();assert data[:6]==b'\x7fELF\x02\x01'
    shoff=struct.unpack_from('<Q',data,40)[0];stride,count=struct.unpack_from('<HH',data,58);relocations={}
    for i in range(count):
        sh=struct.unpack_from('<IIQQQQIIQQ',data,shoff+i*stride)
        if sh[1]!=4:continue
        for offset in range(sh[4],sh[4]+sh[5],sh[9]):
            target,info,addend=struct.unpack_from('<QQq',data,offset)
            if info&0xffffffff==8:relocations[target]=addend
    clocks={hex(a):{'addend':hex(relocations[a]),'symbol':names[relocations[a]]}for a in [0x1d6100,0x1d6110]}
    assert clocks['0x1d6100']['symbol']=='std::time::Instant::now'
    assert clocks['0x1d6110']['symbol']=='std::time::Instant::elapsed'
    store('clock-relocations.json',json.dumps(clocks,indent=2)+'\n')
    store('EXTRACTION.json',json.dumps({'binary':str(BINARY),'binary_sha256':EXPECTED,'full_capture_sha256':sha(CAP/'full.stdout'),'functions':{hex(a):{'name':names[a],'artifact':n,'sha256':sha(HERE/n)}for a,n in selected.items()},'compiler_runs':0,'filter_runs':0},indent=2)+'\n')
if __name__=='__main__':main()
