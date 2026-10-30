#!/usr/bin/env python3
"""Extract reviewed bodies from existing text only; no binary/tool execution."""
import hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent
def main():
    source=HERE/'validation-v2/native-assembly.stdout';text=source.read_text()
    output=HERE/'assembly-review';assert not output.exists();output.mkdir()
    addresses={'control-prefetch':'dec0','control-no-prefetch':'e210',
               'candidate-prefetch':'14fd0','candidate-no-prefetch':'15370'}
    records={}
    for name,address in addresses.items():
        start=text.index('\n'+address.zfill(16)+' <');end=text.find('\n\n',start+1)
        body=text[start:end]+'\n';instructions=re.findall(r'^\s+([0-9a-f]+):\s+(.+)$',body,re.M)
        assert len(instructions)>50
        stores=[pc for pc,op in instructions if re.match(r'vmovdqa64\s+%zmm\d+,\(',op)]
        expands=[pc for pc,op in instructions if op.startswith('vpexpandd')]
        memory_or=[pc for pc,op in instructions if re.match(r'vporq\s+\(',op)]
        scalar_or=[pc for pc,op in instructions if re.match(r'or\s+%[a-z0-9]+,\(',op)]
        if name.startswith('candidate'):
            assert len(stores)==len(expands)==len(memory_or)==4
            assert all(int(a,16)<int(b,16)<int(c,16) for a,b,c in zip(expands,memory_or,stores))
            assert all(int(stores[i],16)<int(memory_or[i+1],16) for i in range(3))
        else:assert len(scalar_or)==16 and not expands and not stores
        (output/(name+'.asm')).write_text(body)
        records[name]=dict(address=address,instructions=len(instructions),expand=expands,line_memory_or=memory_or,
                           line_stores=stores,scalar_memory_or=scalar_or)
    windows={'control-pure':('9b49','9bcc'),'control-hash':('9df9','a225'),
             'candidate-pure':('10fd9','1105c'),'candidate-hash':('11289','116b5')}
    for name,(low,high)in windows.items():
        selected=[]
        for line in text.splitlines():
            match=re.match(r'^\s+([0-9a-f]+):',line)
            if match and int(low,16)<=int(match[1],16)<int(high,16):selected.append(line)
        assert sum('steady_clock::now()'in line for line in selected)==3
        target='14260'if name.startswith('candidate')else'cdd0'
        assert any('call' in line and target in line and 'insert<'in line for line in selected)
        (output/(name+'.asm')).write_text('\n'.join(selected)+'\n')
    (output/'REVIEW.json').write_text(json.dumps(dict(source=str(source.relative_to(HERE)),
        source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
        binary_sha256='540be049ea355652f2aebb67d49d2476e0b751267e9fe57c3b189c7e1db4d9fb',
        bodies=records,clock_windows=windows,no_disassembler_run=True),indent=2)+'\n')
    print('PASS nonempty actual bodies and sequential stores; manual interpretation required')
if __name__=='__main__':main()
