"""Descriptive instruction-text identity for unchanged private query bodies."""
import hashlib
import json
from pathlib import Path
import re
HERE=Path(__file__).resolve().parent
CALLER=HERE.parent
captures=json.loads((CALLER/'assembly-extra/results/CAPTURE.json').read_text())['captures']
def normalized(item):
    lines=[]
    for line in (CALLER/item['stdout']).read_text().splitlines():
        match=re.match(r'^\s*([0-9a-f]+):\s+(.*)',line)
        if not match:continue
        text=match.group(2).split('#',1)[0].strip()
        text=text.replace('42FourSectorRange12SingletonVectorExperiment','28FourSectorRange12BloomFilter')
        text=re.sub(r'\b[0-9a-f]+(?= <)','TARGET',text)
        text=re.sub(r'-?0x[0-9a-f]+\(%rip\)','RIP',text)
        lines.append(text)
    return lines
records=[]
for left,right in ((0,4),(1,5),(2,6),(8,12),(9,13),(10,14)):
    before,after=normalized(captures[left]),normalized(captures[right])
    if before!=after:raise ValueError('unexpected private-body instruction difference')
    text='\n'.join(before)+'\n';name=f'body-{len(records)}.txt';(HERE/name).write_text(text)
    records.append(dict(control=captures[left]['raw_symbol'],candidate=captures[right]['raw_symbol'],
        profile=captures[left]['profile'],instructions=len(before),normalized_file=name,
        sha256=hashlib.sha256(text.encode()).hexdigest(),equal=True))
(HERE/'normalized.json').write_text(json.dumps({'scope':'instruction text only after class/address/RIP relocation normalization; not full ELF identity or whole-Lookup layout identity','pairs':records},indent=2)+'\n')
