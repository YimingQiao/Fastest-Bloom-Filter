#!/usr/bin/env python3
"""Source-only natural-form quality identities; no observations or execution."""
import argparse,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PROOF='7e5daaccd1c981cffd097b06825f526f6ad789db';STAGE='experiments/2026-10-29-poppy-natural-raw-caller'
def blob(path):
 value=subprocess.check_output(['git','show',PROOF+':'+path],cwd=ROOT)
 assert (ROOT/path).read_bytes()==value
 return value
def points():
 union=json.loads(blob(STAGE+'/geometry-union.json'));assert len(union)==14
 result=[]
 for p in sorted(union,key=lambda x:int(x['filter'].removeprefix('PoppyPublic'))):
  c=p['canonical_constructor'];number=int(p['filter'].removeprefix('PoppyPublic'))
  for form,label,contract in [('byte8','Byte','public_poppy_natural_byte8'),('typed_u64','Typed','public_poppy_natural_typed_u64')]:
   result.append(dict(id=f'{p["keys"]}:PoppyRaw{label}{number:03d}:{p["actual_bytes"]}',filter=f'PoppyRaw{label}{number:03d}',
    source_constructor_id=p['configuration_id'],form=form,hash_contract=contract,keys=p['keys'],requested_bpk=p['run_budget_bpk'],actual_bytes=p['actual_bytes'],
    bucket_bytes=p['bucket_bytes'],cache_bytes=p['cache_bytes'],fpp_bits=c['fpp_bits'],policy=c['policy'],effective_probes=c['probes'],constructor_n=p['keys'],
    required_hash_scratch_bytes=0,calibration_negatives=1<<26,quality_status='unmeasured',prior_counts_imported=False))
 assert len(result)==28 and len({p['id']for p in result})==28 and sum(p['keys']==1<<25 for p in result)==14
 return result
def windows():
 # Exact first SplitMix draw and the unchanged raw caller counter domains.
 mask=(1<<64)-1;z=(42+0x9e3779b97f4a7c15)&mask;z=((z^(z>>30))*0xbf58476d1ce4e5b9)&mask;z=((z^(z>>27))*0x94d049bb133111eb)&mask;z^=z>>31
 rows=[]
 for n in [1<<16,1<<25]:
  q=1<<22;base=z%((1<<32)-n-q)
  rows.append(dict(keys=n,seed=42,key_base=base,inserted_half_open=[base,base+n],mixed_absent_envelope_half_open=[base+n,base+n+q],calibration_half_open=[base+n+q,base+n+q+(1<<26)]))
 return rows
def main():
 p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');args=p.parse_args()
 binding={name:{'commit':PROOF,'sha256':hashlib.sha256(blob(STAGE+'/'+name)).hexdigest()}for name in ['proof-final/ARCHIVE.json','proof-final/FREEZE.json','geometry-union.json','benchmark/src/main.rs','benchmark/src/reporter.rs','benchmark/src/raw_contract.rs','benchmark/src/poppy_raw.rs','benchmark/src/poppy_geometry.rs','benchmark/Cargo.lock']}
 values={'points.json':points(),'input-domains.json':windows(),'source-binding.json':{'directory':STAGE,'files':binding}}
 for name,value in values.items():
  data=json.dumps(value,indent=2,allow_nan=False)+'\n';path=HERE/name
  if args.write:
   assert not path.exists()or path.read_text()==data,'Refuse changed existing source artifact';path.write_text(data)
  else:assert path.read_text()==data
 print('PASS source-only28 forms/14 constructors/two fixed raw domains; no compiler/filter/quality observations')
if __name__=='__main__':main()
