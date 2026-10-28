#!/usr/bin/env python3
"""Read-only source provenance and mask-only replacement guard."""
import hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def verify():
    provenance=json.loads((HERE/'provenance.json').read_text())
    for local,record in provenance['copied'].items():
        expected=subprocess.check_output(['git','show',record['commit']+':'+record['source']],cwd=ROOT)
        assert hashlib.sha256(expected).hexdigest()==record['sha256']
        assert (HERE/local).read_bytes()==expected,'Changed pinned control: '+local
    expected=(HERE/'cpp/cyclic_split64.h').read_text().replace('CyclicSplit64Range','MultiplyCodeSplit64Range')
    for change in json.loads((HERE/'mask-changes.json').read_text()):
        assert expected.count(change['old'])==1
        expected=expected.replace(change['old'],change['new'],1)
    assert expected==(HERE/'cpp/multiply_code_split64.h').read_text(),'Change outside declared mask construction'
    assert provenance['constant']=='0x9e3779b97f4a7c15'
    assert expected.count('0x9e3779b97f4a7c15ULL')==1
    protocol=json.loads((HERE/'protocol.json').read_text())
    assert protocol['fixed_multiplier']==provenance['constant']
    assert protocol['key_powers']==[16,25] and protocol['actual_bpk']==[16,24,28,32]
    assert protocol['seed']==42 and protocol['calibration_power']==24 and protocol['rows']==24
    assert protocol['filters']==['Split64Range','CyclicSplit64Range','MultiplyCodeSplit64Range']
    print('Pinned controls and exact fixed mask-only source replacement verified; no execution')
if __name__=='__main__':
    if not __debug__:raise ValueError('Run without Python -O')
    verify()
