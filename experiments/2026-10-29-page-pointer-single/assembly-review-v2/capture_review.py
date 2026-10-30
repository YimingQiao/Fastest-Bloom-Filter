"""Supporting exact instruction observations after manual typed-CFG review."""
from pathlib import Path
import json,re,subprocess,hashlib
HERE=Path(__file__).resolve().parent
PARENT=HERE.parent
VALIDATION=PARENT/'validation-v1'

def main():
    a=json.loads((VALIDATION/'assembly/audit.json').read_text());binary=a['binary']
    symbols=(VALIDATION/'assembly/symbols.txt').read_text()
    callees=[];pairs=[]
    for line in symbols.splitlines():
        m=re.match(r'^([0-9a-f]+) ([0-9a-f]+) ([A-Za-z]) (.*)$',line)
        if not m or m[3]not in ('t','T')or not re.fullmatch(r'pbf::PageBloomFilter<(4|6|8)u>::test\(unsigned char const\*, unsigned int\) const \[clone \.constprop\.0\]',m[4]):continue
        start,size=int(m[1],16),int(m[2],16)
        cmd=['taskset','-c','4','objdump','-dC','--no-show-raw-insn','--start-address='+str(start),'--stop-address='+str(start+size),binary]
        text=subprocess.check_output(cmd,text=True);name='test'+str(len(callees))+'.asm';(HERE/name).write_text(text)
        callees.append(dict(symbol=m[4],artifact=name,command=cmd,sha256=hashlib.sha256(text.encode()).hexdigest()))
    assert len(callees)==3
    for i in range(6):
        pointer=(VALIDATION/'assembly'/f'query{i:02d}.asm').read_text()
        value=(VALIDATION/'assembly'/f'query{i+10:02d}.asm').read_text()
        assert re.search(r'mov\s+%rcx,%rbx',pointer) and re.search(r'mov\s+%rbx,%rsi',pointer)
        assert re.search(r'add\s+\$0x4,%rbx',pointer)
        assert not re.search(r'mov\s+%e\w+,0x[0-9a-f]+\(%rsp\)',pointer)
        assert re.search(r'mov\s+%eax,0x1c\(%rsp\)',value)
        calls=lambda t:[m.group(1)for m in re.finditer(r'call\s+[a-f0-9]+ <(.*)>',t)]
        pc,vc=calls(pointer),calls(value);assert len(pc)==len(vc)==2 and pc==vc
        assert pc[1]in [x['symbol']for x in callees]
        pairs.append(dict(pointer_artifact=f'validation-v1/assembly/query{i:02d}.asm',value_artifact=f'validation-v1/assembly/query{i+10:02d}.asm',public_test_target=pc[1],identical_densecall_target=pc[0],input_pointer_register='rbx initialized from incoming rcx, advanced4 bytes per key',public_key_pointer_argument='rsi <- rbx',pointer_key_stack_copy=False,value_key_stack_copy='mov eax,0x1c(rsp)',pointer_outer_stack_reservation_bytes=24,value_outer_stack_reservation_bytes=40))
    obj=dict(scope='Manual review of all six typed pointer and six value branches; supporting exact instruction observations; no performance claim',binary=binary,binary_sha256=a['binary_sha256'],review_complete=True,all_six_pointer_branches_use_input_address=True,all_six_densecall_targets_match_value=True,underlying_public_test_remains_out_of_line=True,timing_authorized=False,pairs=pairs,public_callees=callees,limitations=['Outer prologue/register/branch/code-layout differs, so unchanged dense semantic contract does not imply identical dense performance.','Constprop public test retains unchanged upstream implementation; this is a caller-contract control, not an algorithm change.'])
    (HERE/'review.json').write_text(json.dumps(obj,indent=2)+'\n')
    print('All6 pointer branches pass original input addresses; all6 Base DenseCall targets match; no timing claim')
if __name__=='__main__':main()
