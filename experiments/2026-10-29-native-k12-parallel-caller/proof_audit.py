"""Reconstruct the bounded proof offline; never invokes compiler or Bloom filter."""
import argparse,json
from pathlib import Path
from checks import NAMES,SEMANTICS,parse,query_rows,public_row
from source_guard import HERE,sha,need,verify
SOURCE='81c97970f9a67facd0dd0a4e567097af30b9b0ae'
def audit(live=True):
 metadata=json.loads((HERE/'validation-v1/metadata.json').read_text())
 need(metadata['complete']and metadata['source_commit']==SOURCE and metadata['formal_performance_run']is False and metadata['incidental_timing_claimed']is False,'wrong proof identity')
 need(len(metadata['commands'])==32 and sum(r['returncode']==0 for r in metadata['commands'])==18,'wrong command/status coverage')
 need(metadata['compiler_cpu']==2 and metadata['execution_cpus']==[2,4,6,8,10,12,14,16]and metadata['numa_node']==0 and metadata['lease_fds'],'wrong recorded placement')
 for r in metadata['commands']:
  out=HERE/'validation-v1'/(r['label']+'.stdout');err=HERE/'validation-v1'/(r['label']+'.stderr')
  need(out.is_file()and err.is_file(),'missing command streams')
  need((r['returncode']==0)==r['expected_success'],'wrong command exit status')
  if not r['expected_success']:need(not out.read_bytes()and err.read_bytes(),'CLI failed after output')
 previous=None;public_previous={}
 for profile in ['native','asan']:
  current=query_rows(parse((HERE/'validation-v1'/(profile+'-query.stdout')).read_text()))
  if previous:
   for name in NAMES:
    for field in SEMANTICS+['calibration_absent_queries','calibration_false_positives']:need(current[name][field]==previous[name][field],'query backend disagreement')
  previous=current
  for name in ['Split64BloomFilter','Split64RangeBloomFilter','FourSectorRange12BloomFilter']:
   rows=parse((HERE/'validation-v1'/(profile+'-public-'+name+'.stdout')).read_text());need(len(rows)==1,'wrong public row count');row=rows[0];public_row(row,current[name])
   if name in public_previous:
    for field in SEMANTICS:need(row[field]==public_previous[name][field],'public backend disagreement')
   public_previous[name]=row
 need(len(metadata['binaries'])==8 and metadata['shared_query_rows']==30 and metadata['public_api_rows']==6 and metadata['invalid_cli_cases']==14,'wrong completed coverage')
 if live:
  verify(SOURCE)
  for record in metadata['binaries'].values():need(sha(record['path'])==record['sha256'],'binary drift')
  for items in metadata['compiler_inputs'].values():
   for path,h in items.items():need(sha(path)==h,'compiler input drift')
 return {'commands':32,'successful_commands':18,'expected_rejections':14,'shared_query_rows':30,'public_api_rows':6,'compiler_inputs':len({p for values in metadata['compiler_inputs'].values()for p in values}),'binaries':8,'formal_performance_run':False}
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--skip-live-inputs',action='store_true');a=p.parse_args();print(json.dumps(audit(not a.skip_live_inputs)))
