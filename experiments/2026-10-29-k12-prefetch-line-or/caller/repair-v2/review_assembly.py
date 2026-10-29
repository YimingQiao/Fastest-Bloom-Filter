#!/usr/bin/env python3
"""Read captured disassembly only; no disassembler/compiler/BF execution."""
import hashlib,importlib.util,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]
OLD=ROOT/'experiments/2026-10-29-k12-line-or/caller/order-v3'
spec=importlib.util.spec_from_file_location('old_text_helpers',OLD/'review_assembly.py');helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
def normalized(rows):
    return [re.sub(r'K12(?:ScalarOrControl|LineOrCandidate|PrefetchLineOrCandidate)','TYPE',s)for s in helper.normalized(rows)]
def main():
    new=HERE/'validation-v1';out=HERE/'assembly-review';assert not out.exists();out.mkdir()
    old_symbols=helper.symbols(OLD/'validation-v1/native-symbols.stdout');new_symbols=helper.symbols(new/'native-symbols.stdout')
    old_text=(OLD/'validation-v1/native-assembly.stdout').read_text();new_text=(new/'native-assembly.stdout').read_text();records=[]
    for name,(address,size)in new_symbols.items():
        if 'Split64RangeBloomFilter'in name:continue
        reference=name.replace('K12PrefetchLineOrCandidate','K12ScalarOrControl')
        if 'K12PrefetchLineOrCandidate::InsertVector<true>'in name:reference=name.replace('K12PrefetchLineOrCandidate','K12LineOrCandidate')
        assert reference in old_symbols
        before=helper.body(old_text,*old_symbols[reference]);after=helper.body(new_text,address,size)
        index=len(records)
        for label,rows in [('old',before),('new',after)]:(out/f'{label}-{index}.asm').write_text('\n'.join(x[0]for x in rows)+'\n')
        records.append(dict(symbol=name,reference=reference,old_address=hex(old_symbols[reference][0]),new_address=hex(address),old_instructions=len(before),new_instructions=len(after),normalized_equal=normalized(before)==normalized(after)))
    assert len(records)==8
    windows=[('control-pure',0xaf99,0xafb8,0xaffd,0xb017,0xe220),('control-hash',0xb249,0xb267,0xb47e,0xb670,0xe220),('conditional-pure',0x12429,0x12448,0x1248d,0x124a7,0x156b0),('conditional-hash',0x126d9,0x126f7,0x1290e,0x12b00,0x156b0),('range-pure',0x188a9,0x188c8,0x1890d,0x18927,0x1bb30),('range-hash',0x18b59,0x18b77,0x18d8e,0x18f80,0x1bb30)]
    timing=[]
    for label,start,ready,call,end,target in windows:
        rows=helper.body(new_text,start,end-start+1);mapping={int(re.match(r'\s*([0-9a-f]+):',raw)[1],16):instruction for raw,instruction in rows}
        assert all('steady_clock::now' in mapping[p] for p in (start,ready,end))
        assert f'call   {target:x} <void insert<' in mapping[call]
        (out/(label+'.asm')).write_text('\n'.join(r[0]for r in rows)+'\n')
        timing.append(dict(label=label,allocate_clock=hex(start),ready_clock=hex(ready),public_helper_call=hex(call),stop_clock=hex(end),actual_helper=hex(target)))
    for name,(address,size)in new_symbols.items():
        if 'void insert<'in name and 'Split64RangeBloomFilter'in name:
            (out/'range-public-helper.asm').write_text('\n'.join(r[0]for r in helper.body(new_text,address,size))+'\n')
    meta=json.loads((new/'metadata.json').read_text())
    report=dict(binary=meta['profiles']['native']['executables']['compare_benchmark'],source_assembly_sha256=hashlib.sha256(new_text.encode()).hexdigest(),normalization='Remove addresses/RIP relocations/comments and substitute class names only; preserve all instructions/registers/immediates/relative offsets.',comparisons=records,all_eight_equal=all(r['normalized_equal']for r in records),timing_windows=timing,new_tools_executed=False)
    (out/'REVIEW.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
