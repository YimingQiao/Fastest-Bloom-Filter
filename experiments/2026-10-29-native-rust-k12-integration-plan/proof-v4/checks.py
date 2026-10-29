"""Bounded native packaging contract and actual seven-core execution topology."""
import json,os,re
from pathlib import Path
CPUS=[3,5,7,9,11,13,15]
def need(ok,message):
 if not ok:raise ValueError(message)
def topology():
 seen=set()
 for cpu in CPUS:
  p=Path(f'/sys/devices/system/cpu/cpu{cpu}/topology')
  package=int((p/'physical_package_id').read_text());core=int((p/'core_id').read_text())
  need(package==1,'Execution must stay on socket1');need((package,core)not in seen,'Seven distinct physical cores required');seen.add((package,core))
 return sorted(seen)
def artifact(text,package,test,target,packages):
 found=[]
 for line in text.splitlines():
  e=json.loads(line)
  if e.get('reason')!='compiler-artifact':continue
  need(e['package_id']in packages,'Unknown emitted package')
  p=packages[e['package_id']];need(Path(e['manifest_path']).resolve()==Path(p['manifest_path']).resolve(),'Emitted manifest identity drift')
  need(any(t['name']==e['target']['name']and t['kind']==e['target']['kind']and Path(t['src_path']).resolve()==Path(e['target']['src_path']).resolve()for t in p['targets']),'Emitted target identity drift')
  if p['name']!=package or e['profile']['test']!=test or not e.get('executable'):continue
  binary=Path(e['executable']).resolve();need(binary.is_relative_to(target.resolve())and binary.is_file(),'Actual executable outside target');found.append(binary)
 need(len(set(found))==1,'Expected exactly one actual executable');return found[0]
def fixture(text,expected_backend=None):
 lines=text.splitlines();need(len(lines)==13,'Expected12 native/reference cases and one completion line')
 rows=[]
 for i,line in enumerate(lines[:-1]):
  row=dict(s.split('=',1)for s in line.split(','));need(int(row['case'])==i+1,'Fixture order drift')
  rows.append(row)
 expected=[(b,w,hot)for b in[192,1088,2097216]for w in[3,7]for hot in['false','true']]
 for row,(b,w,hot)in zip(rows,expected,strict=True):
  need(int(row['bytes'])==b and int(row['workers_requested'])==w and row['hotspot']==hot,'Wrong fixed fixture')
  need(int(row['workers_actual'])==min(w,b//64)and int(row['words'])==b//4,'Physical owner/storage proof drift')
  need(row['backend']in['scalar','avx2','avx512'],'Invalid actual backend')
  if expected_backend:need(row['backend']==expected_backend,'Unexpected backend')
 end=dict(s.split('=',1)for s in lines[-1].split(','));need(end['complete']=='true'and end['cases']=='12'and end['timing']=='false'and end['calibration']=='0','Incomplete fixture')
 return dict(cases=rows,checksum=int(end['checksum']))
