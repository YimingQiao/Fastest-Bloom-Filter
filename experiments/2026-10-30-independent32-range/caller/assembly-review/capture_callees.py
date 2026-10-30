"""Add only actual out-of-line query targets to the original nonempty ELF spans."""
import json
from pathlib import Path
import re
import subprocess
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from source_guard import HERE,ROOT,sha,verify,recheck
from contract import need
from lease import require

OUT=Path(__file__).resolve().parent/'callees'
def main():
    placement=require();need(not OUT.exists(),'fresh callee output required')
    meta=json.loads((HERE/'validation-v1/metadata.json').read_text());need(meta['complete'],'functional proof required')
    prepared=verify(meta['source_commit']);recheck(meta['compiler_consumed_input_sha256']);recheck(meta['tools_sha256'])
    recheck(meta['all_binary_sha256']);binary=Path(meta['assembly']['binary']);objdump='/usr/bin/objdump'
    OUT.mkdir();commands=[]
    funcs={}
    for line in (HERE/meta['assembly']['elf']).read_text().splitlines():
        c=line.split()
        if len(c)>=8 and c[3]=='FUNC' and c[6]!='UND':
            try:a,z=int(c[1],16),int(c[2],0)
            except ValueError:continue
            if z:funcs.setdefault(a,[]).append((z,c[7]))
    def targets(text,start,size):
        result=[]
        for line in text.splitlines():
            m=re.search(r'\b(?:call|jmp)\s+([0-9a-f]+)\s+<([^>]+)>',line)
            if m:
                target=int(m[1],16)
                if not start<=target<start+size and '@plt'not in m[2]:
                    need(target in funcs,'unbound direct query target '+m[1]);result.append(target)
        return result
    queue=[];edges=[];known={s['start']for s in meta['assembly']['symbols']}
    for s in meta['assembly']['symbols']:
        if s['role']=='Run<':continue
        for target in targets((HERE/s['stdout']).read_text(),s['start'],s['size']):
            edges.append([s['start'],target]);queue.append(target)
    need(set(queue)=={0x28e90,0x2a800,0x2e470},'reviewed initial tail set differs')
    captures=[]
    while queue:
        start=queue.pop(0)
        if start in known:continue
        need(len(captures)<16,'bounded query closure exceeded')
        aliases=sorted(set(funcs[start]));sizes={z for z,_ in aliases};need(len(sizes)==1,'ambiguous FUNC span')
        size=next(iter(sizes));label='callee-'+str(len(captures));out=OUT/(label+'.stdout');err=OUT/(label+'.stderr')
        argv=[objdump,'-d','--no-show-raw-insn','--start-address='+str(start),'--stop-address='+str(start+size),str(binary)]
        need(require()==placement,'lease drift');recheck(meta['all_binary_sha256']);recheck(meta['tools_sha256'])
        with out.open('wb')as stdout,err.open('wb')as stderr:
            result=subprocess.run(argv,cwd=ROOT,stdout=stdout,stderr=stderr,pass_fds=tuple(map(int,placement['fd_evidence'])))
        commands.append(dict(argv=argv,returncode=result.returncode,stdout=out.name,stderr=err.name,stdout_sha256=sha(out),stderr_sha256=sha(err)))
        (OUT/'commands.json').write_text(json.dumps(commands,indent=2)+'\n')
        need(result.returncode==0 and not err.read_bytes(),'callee capture failed')
        text=out.read_text();pcs=[int(m[1],16)for m in re.finditer(r'^\s*([0-9a-f]+):\s+\S',text,re.M)]
        need(pcs and pcs[0]==start and all(start<=pc<start+size for pc in pcs),'empty/out-of-span query callee')
        known.add(start)
        for target in targets(text,start,size):edges.append([start,target]);queue.append(target)
        captures.append(dict(start=start,size=size,aliases=[s for _,s in aliases],stdout=out.name,sha256=sha(out),instruction_count=len(pcs)))
    need(verify(meta['source_commit'])==prepared,'source identity drift')
    recheck(meta['compiler_consumed_input_sha256']);recheck(meta['all_binary_sha256']);recheck(meta['tools_sha256'])
    result=dict(complete=True,source_commit=meta['source_commit'],binary=str(binary),binary_sha256=sha(binary),
        original_metadata_sha256=sha(HERE/'validation-v1/metadata.json'),script_sha256=sha(__file__),
        placement=placement,spans=captures,direct_edges=edges,filter_executions=0,compiler_executions=0)
    (OUT/'CAPTURE.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Captured',len(captures),'same-binary query callees; zero compiler/filter execution.')

if __name__=='__main__':main()
