#!/usr/bin/env python3
"""Read-only equality audit for selected AVX2 regions of the frozen executable."""
import hashlib,json,pathlib,re,subprocess
HERE=pathlib.Path(__file__).resolve().parent
BIN=pathlib.Path('/tmp/fastest-bf-rust-byte-inline-only/release/compare_benchmark')
EXPECTED='e07494fceb045dacea9942e03a9edbb850e49a56a701616ce78dea0a320cac12'
assert hashlib.sha256(BIN.read_bytes()).hexdigest()==EXPECTED
OUT=HERE/'assembly/byte-equality';OUT.mkdir(exist_ok=True)
def region(name,start,size,active):
    text=subprocess.check_output(['objdump','-d','-C','--no-show-raw-insn',f'--start-address={start}',f'--stop-address={start+size}',str(BIN)],text=True)
    (OUT/(name+'.asm')).write_text(text)
    result=[]
    for line in text.splitlines():
        m=re.match(r'\s*([0-9a-f]+):\s+(.*)',line)
        if not m:continue
        offset=int(m[1],16)-start
        if not active(offset):continue
        asm=m[2];ref=re.search(r'#\s+([0-9a-f]+)',asm)
        asm=asm.split('#',1)[0].rstrip();asm=re.sub(r'\s+<.*','',asm)
        if '(%rip)' in asm:
            assert ref
            asm=re.sub(r'-?0x[0-9a-f]+\(%rip\)',f'RIP_TARGET_0x{int(ref[1],16):x}',asm)
        jump=re.match(r'(j\w+)\s+([0-9a-f]+)$',asm)
        if jump:
            target=int(jump[2],16);assert start<=target<start+size
            asm=f'{jump[1]} LOCAL_0x{target-start:x}'
        assert not asm.startswith('call'), 'Unexpected call in selected active AVX2 region'
        result.append((offset,asm))
    (OUT/(name+'.normalized.txt')).write_text('\n'.join(f'{offset:03x}: {asm}' for offset,asm in result)+'\n')
    return result
bulk_starts={'original':0x39160,'byte_only':0x39a00,'triple_hint':0x3a2a0}
bulk={name:region('bulk-'+name,start,0x1f4,lambda off:off<0x33 or 0x85<=off<0x166 or 0x19f<=off<0x1ae) for name,start in bulk_starts.items()}
assert bulk['original']==bulk['byte_only']==bulk['triple_hint']
visible={}
for mode,starts,size,active in [('prehashed',{'byte_only':0x19f90,'triple_hint':0x1a540},0x1b0,lambda off:off<0x53 or 0x84<=off<0x161),('fused',{'byte_only':0x1a140,'triple_hint':0x1a6f0},0x260,lambda off:off<0x4f or 0xb9<=off<0x212)]:
    values={name:region('visible-'+mode+'-'+name,start,size,active) for name,start in starts.items()}
    assert values['byte_only']==values['triple_hint']
    visible[mode]=dict(starts={k:hex(v) for k,v in starts.items()},active_instruction_count=len(values['byte_only']),normalized_equal=True)
summary=dict(binary=str(BIN),binary_sha256=EXPECTED,bulk=dict(starts={k:hex(v) for k,v in bulk_starts.items()},function_size_bytes=500,active_instruction_count=len(bulk['original']),active_n3_avx2_equal_all_three=True,hot_loop_mod64={k:(v+0xc0)%64 for k,v in bulk_starts.items()}),visible=visible,normalization='Retain relative instruction offsets, opcodes, registers and ordinary operands; resolve RIP displacements to exact constant addresses; represent local branch destinations as offsets. No call targets normalized.',scope='Active AVX2 regions only; scalar fallback and cold panic code are excluded and retained in full disassembly. Equality is codegen evidence, not a timing result.')
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
