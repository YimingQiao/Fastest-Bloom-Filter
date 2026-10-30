#!/usr/bin/env python3
"""Compare only existing old/new assembly text, never execute tools or filters."""
import hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent
def symbols(path):
    result={}
    for line in path.read_text().splitlines():
        parts=line.split(maxsplit=3)
        if len(parts)==4 and ('void insert<'in parts[3]or'::InsertVector<'in parts[3]or'::InsertScalar('in parts[3]):
            result[parts[3]]=(int(parts[0],16),int(parts[1],16))
    return result
def body(text,start,size):
    result=[]
    for line in text.splitlines():
        match=re.match(r'^\s*([0-9a-f]+):\s*(.*)$',line)
        if match and start<=int(match[1],16)<start+size:result.append((line,match[2]))
    assert result
    return result
def normalized(rows):
    result=[]
    for _,line in rows:
        line=line.split('#')[0].rstrip()
        line=re.sub(r'-?0x[0-9a-f]+\(%rip\)','RELOCATION(%rip)',line)
        line=re.sub(r'^(j\w+|call)\s+[0-9a-f]+\s+<',r'\1 TARGET <',line)
        result.append(line)
    return result
def main():
    old=HERE.parent/'validation-v2';new=HERE/'validation-v1';out=HERE/'assembly-review';assert not out.exists();out.mkdir()
    old_symbols=symbols(old/'native-nm.stdout');new_symbols=symbols(new/'native-symbols.stdout')
    assert old_symbols.keys()==new_symbols.keys()and len(new_symbols)==8
    texts=[(p/'native-assembly.stdout').read_text()for p in [old,new]];records=[]
    for index,name in enumerate(sorted(new_symbols)):
        before=body(texts[0],*old_symbols[name]);after=body(texts[1],*new_symbols[name])
        equal=normalized(before)==normalized(after)
        (out/f'old-{index}.asm').write_text('\n'.join(x[0]for x in before)+'\n')
        (out/f'new-{index}.asm').write_text('\n'.join(x[0]for x in after)+'\n')
        records.append(dict(symbol=name,old_address=hex(old_symbols[name][0]),new_address=hex(new_symbols[name][0]),
                            old_instructions=len(before),new_instructions=len(after),normalized_equal=equal))
    report=dict(normalization='Remove PCs, RIP displacements/comments and named branch target addresses; preserve opcode/register/immediate/symbol/relative-offset text',
                old_binary_sha256='540be049ea355652f2aebb67d49d2476e0b751267e9fe57c3b189c7e1db4d9fb',
                new_binary_sha256='46c593a4740f161fac09e78e2b745f9b2aba7f2ea34ac6f4d7e06ec0061461cf',
                records=records,all_eight_equal=all(r['normalized_equal']for r in records),no_new_disassembler_run=True)
    (out/'REVIEW.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
