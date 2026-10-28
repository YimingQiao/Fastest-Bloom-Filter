#!/usr/bin/env python3
"""Archive native public-entry assembly for each same-process control."""
from pathlib import Path
import subprocess,json
HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
BINARY=REPO/'build/cpp-pattern-tail-paired4/compare_benchmark'
lines=subprocess.check_output(['nm','-S','-C',str(BINARY)],text=True).splitlines()
out=HERE/'assembly';out.mkdir(exist_ok=False)
records=[]
for cls in ('FastPatternBeforeTailBF','FastPatternPair4TailBF'):
 for line in lines:
  if ('bloom_filters::'+cls+'::Lookup(' not in line and 'bloom_filters::'+cls+'::LookupImpl<' not in line and 'lookup_kernel<bloom_filters::'+cls+',' not in line): continue
  fields=line.split(maxsplit=3)
  if len(fields)!=4:continue
  address,size=int(fields[0],16),int(fields[1],16)
  cmd=['objdump','-d','-C','--no-show-raw-insn',f'--start-address={address}',f'--stop-address={address+size}',str(BINARY)]
  text=subprocess.check_output(cmd,text=True)
  kind='wrapper' if 'lookup_kernel<' in line else ('prefetch' if 'LookupImpl<true>' in line else ('resident' if 'LookupImpl<false>' in line else 'public'))
  name=cls+'-'+kind+'.txt'
  (out/name).write_text(text)
  records.append({'class':cls,'kind':kind,'file':name,'symbol':fields[3],'size':size,'address':address,'command':cmd})
(out/'symbols.json').write_text(json.dumps(records,indent=2)+'\n')
print('Archived',len(records),'symbols')
