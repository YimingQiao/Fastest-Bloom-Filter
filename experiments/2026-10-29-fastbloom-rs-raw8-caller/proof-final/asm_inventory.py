"""Read only the captured ELF text; no new disassembler, compiler or filter run."""
import hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent
CAPTURE=HERE.parent/'validation-v1'
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    spans=json.loads((CAPTURE/'assembly-spans.json').read_text())
    reports=[s for s in spans['spans'] if s['category']=='construction_caller' and s['demangled_names'][0].startswith('raw8_benchmark::report::<')]
    assert len(reports)==45
    rows=[]
    for s in reports:
        body=s['instructions']; calls=[]
        for line in body:
            m=re.search(r'call\s+([0-9a-f]+) <(raw8_benchmark::raw_contract::(raw_insert|raw_batched|raw_visible)::.*?)>',line)
            if m:calls.append(dict(address=line.split(':')[0].strip(),target=m[1],kind=m[3],display_name=m[2]))
        assert {r['kind']for r in calls}=={'raw_insert','raw_batched','raw_visible'}
        clocks=[i for i,line in enumerate(body) if 'call' in line and '# 1a33c0 'in line]
        assert len(clocks)>=4
        start,ready,done=clocks[:3]
        allocation=body[start+1:ready]; insertion=body[ready+1:done]
        assert any('raw_insert::'in line for line in insertion)
        direct='fastbloom_rs_adapter::FastbloomRsRaw<'in s['demangled_names'][0]
        has_scratch=any('posix_memalign' in line for line in allocation)
        assert has_scratch is not direct
        if not direct:assert any('memset' in line for line in allocation)
        rows.append(dict(name=s['demangled_names'][0],address=hex(s['address']),size=s['size'],direct_raw8=direct,raw_method_calls=calls,
                         first_build_clock_addresses=[body[i].split(':')[0].strip() for i in clocks[:3]],
                         allocation_before_ready=allocation,insertion_after_ready=insertion))
    assert sum(r['direct_raw8']for r in rows)==24
    for r in rows:
        if r['direct_raw8']:
            for c in r['raw_method_calls']:assert c['target']=={'raw_insert':'153090','raw_batched':'1558e0','raw_visible':'1565d0'}[c['kind']]
    result=dict(scope='Post-capture address inventory supporting manual review, not an independent performance or complete compiler-equivalence proof.',
                input_sha256={name:digest(CAPTURE/name) for name in ['assembly-spans.json','asm-elf.stdout','asm-nm.stdout','asm-nm-demangled.stdout','asm-disassembly.stdout','asm-relocations.stdout']},
                report_count=45,direct_raw8_count=24,common_hash_count=21,reports=rows)
    (HERE/'asm-inventory.json').write_text(json.dumps(result,indent=2)+'\n')
    print('45 construction callers;24 direct/21 common; all raw method calls and first three build clock boundaries retained')
if __name__=='__main__':main()
