"""Replay complete raw rows and exact fixed commands; no performance ranking."""
import argparse,csv,io,json
from pathlib import Path
from contract import HERE,CPUS,plan,command,parse,validate_complete,csv_text,need
from freeze import verify,sha,ENV_KEYS
def audit(output,commit,live=True):
 meta=json.loads((output/'metadata.json').read_text());need(meta['complete']is True and meta['source_commit']==commit,'incomplete/wrong source')
 if live:need(meta['freeze']==verify(commit),'recorded source/proof freeze differs')
 need(meta['compiler_runs']==0 and meta['partial_ranking']is False,'wrong operation scope')
 placement=meta['placement'];need(placement['parent_affinity']==[2]and placement['lock']=='/tmp/fastest-bf-socket0.lock'and placement['inherited_lock_descriptors'],'wrong archived lease')
 topology=placement['topology'];need([t['cpu']for t in topology]==CPUS and len({t['core']for t in topology})==8 and all(t['socket']==t['node']==0 for t in topology),'wrong physical placement')
 need(set(placement['runtime_environment'])==set(ENV_KEYS)and not any(placement['runtime_environment'].values()),'unfrozen runtime environment')
 ledger=plan();need(len(meta['cases'])==195,'incomplete command ledger');records=[]
 for case,record in zip(ledger,meta['cases']):
  name=f"case-{case['index']:03d}";need(record['case']==case and record['command']==command(meta['freeze']['binaries'],case)and record['complete']is True and record['returncode']==0,'changed/failed case command')
  for stream in ['stdout','stderr']:need(record[stream]==name+'.'+stream and sha(output/record[stream])==record[stream+'_sha256'],'raw stream identity differs')
  need(not(output/record['stderr']).read_bytes(),'unexpected stderr');records.append({'case':case,'row':parse((output/record['stdout']).read_text())})
 counts=validate_complete(records);need(meta['counts']==counts,'wrong complete counts');need(records==json.loads((output/'rows.json').read_text()),'raw aggregate differs')
 for track in ['shared_query','native_public']:need((output/(track+'.csv')).read_text()==csv_text(records,track),'raw CSV differs')
 return counts
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);a=p.parse_args();print(json.dumps(audit(HERE/'results-v1',a.source_commit)))
