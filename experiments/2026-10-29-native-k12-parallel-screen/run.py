#!/usr/bin/env python3
"""Execute the fixed195 plan once; no compilation, tuning or partial ranking."""
import argparse,json,subprocess,traceback
from datetime import datetime,timezone
from pathlib import Path
from contract import HERE,ROOT,plan,command,parse,validate_complete,csv_text,need
from freeze import verify,placement,sha
def now():return datetime.now(timezone.utc).isoformat()
def main():
 need(__debug__,'Python -O forbidden');p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);p.add_argument('--execute-frozen',action='store_true');a=p.parse_args();need(a.execute_frozen,'explicit frozen execution required')
 lease=placement();frozen=verify(a.source_commit);ledger=plan();need(ledger==json.loads((HERE/'ledger.json').read_text()),'frozen195 order changed')
 output=HERE/'results-v1';need(not output.exists()and not output.is_symlink(),'preserve previous outputs');output.mkdir()
 metadata={'complete':False,'source_commit':a.source_commit,'freeze':frozen,'placement':lease,'tool_sha256':{p:sha(p)for p in ['/usr/bin/taskset','/usr/bin/numactl']},'started':now(),'cases':[],'compiler_runs':0,'partial_ranking':False}
 def save():(output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
 save();records=[]
 try:
  for case in ledger:
   need(placement()==lease,'parent placement/environment drift');name=f"case-{case['index']:03d}";record={'case':case,'command':command(frozen['binaries'],case),'stdout':name+'.stdout','stderr':name+'.stderr','started':now(),'complete':False};metadata['cases'].append(record);save()
   with(output/record['stdout']).open('wb')as out,(output/record['stderr']).open('wb')as err:result=subprocess.run(record['command'],cwd=ROOT,stdout=out,stderr=err,pass_fds=tuple(lease['inherited_lock_descriptors']))
   record.update(returncode=result.returncode,finished=now(),stdout_sha256=sha(output/record['stdout']),stderr_sha256=sha(output/record['stderr']));save()
   need(result.returncode==0 and not(output/record['stderr']).read_bytes(),'failed command retained')
   row=parse((output/record['stdout']).read_text());records.append({'case':case,'row':row});validate_complete(records,complete=False);record['complete']=True;save();print(f"{len(records)}/195 complete",flush=True)
  counts=validate_complete(records);(output/'rows.json').write_text(json.dumps(records,indent=2)+'\n')
  for track in ['shared_query','native_public']:(output/(track+'.csv')).write_text(csv_text(records,track))
  need(verify(a.source_commit)==frozen and placement()==lease,'final source/binary/placement drift')
  for path,h in metadata['tool_sha256'].items():need(sha(path)==h,'placement tool changed')
  metadata.update(complete=True,counts=counts,finished=now());save()
  from audit import audit
  need(audit(output,a.source_commit,live=False)==counts,'final raw replay differs')
  files={p.name:sha(p)for p in sorted(output.iterdir())if p.is_file()};(output/'RAW_ARCHIVE.json').write_text(json.dumps({'complete':True,'source_commit':a.source_commit,'files':files},indent=2)+'\n')
  print(json.dumps(counts))
 except BaseException as error:
  metadata.update(complete=False,error=repr(error),finished=now());save();(output/'FAILURE.txt').write_text(traceback.format_exc());raise
if __name__=='__main__':main()
