#!/usr/bin/env python3
"""Source-only preparation. Does not start the measured executable."""
import pins
if not __debug__:raise RuntimeError('Python -O forbidden')
if __name__=='__main__':
 value=pins.prepare();pins.save(pins.HERE/'freeze.json',value)
 files={p.name:dict(sha256=pins.sha(p),bytes=p.stat().st_size)for p in sorted(pins.HERE.iterdir())if p.is_file()and p.name!='PREPARATION.json'}
 pins.save(pins.HERE/'PREPARATION.json',dict(stage='Additive formal runner source; no measured process executed',proposal_commit=pins.PROPOSAL,proof_commit=pins.PROOF,files=files))
 print(f'Frozen {len(value["input_sha256"])} inputs, {len(value["committed_anchors"])} exact committed anchors, {len(files)} local files plus manifest')
