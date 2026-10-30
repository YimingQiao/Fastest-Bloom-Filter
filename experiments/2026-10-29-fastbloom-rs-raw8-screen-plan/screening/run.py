#!/usr/bin/env python3
"""Execute only the committed fixed raw8 panel, after explicit lease authorization."""
if not __debug__:raise RuntimeError('Python -O forbidden')
import argparse,csv,datetime,io,json,os,subprocess,traceback
from pathlib import Path
import pins
from lease import require_lease
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);args=parser.parse_args()
 lease=require_lease();frozen=pins.verify(args.source_commit)
 from contract import cases,protocol,validate_case,placement,csv_bytes,quality,audit
 from row_guard import validate_process
 p=protocol();pins.need(pins.environment()==frozen['expected_environment'],'Unfrozen environment override')
 output=pins.PLAN/'results-v1';pins.need(not output.exists()and not output.is_symlink(),'Preserve earlier attempts');output.mkdir()
 (output/'.gitattributes').write_text('*.csv -text\n*.json -text\n*.stdout -text\n*.stderr -text\n')
 meta=dict(complete=False,source_commit=args.source_commit,proposal_commit=pins.PROPOSAL,proof_commit=pins.PROOF,freeze_sha256=pins.sha(pins.HERE/'freeze.json'),protocol_sha256=pins.sha(pins.PLAN/'protocol.json'),binary=frozen['binary'],binary_sha256=frozen['binary_sha256'],host=pins.host(),environment=pins.environment(),affinity=sorted(os.sched_getaffinity(0)),lease_environment=os.environ.get('BF_SOCKET_LEASE'),lease=lease,numactl_sha256=p['numactl_sha256'],started_utc=now(),cases=[],counts=dict(case_count=0,row_count=0,calibration_rows=0,reuse_rows=0))
 def persist():pins.save(output/'metadata.json',meta)
 def execute(rec,label):
  persist();done=subprocess.run(rec['command'],cwd=pins.ROOT,pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
  for stream,data in [('stdout',done.stdout),('stderr',done.stderr)]:
   path=output/(label+'.'+stream);path.write_bytes(data);rec[stream]=path.name;rec[stream+'_sha256']=pins.sha(path)
  rec['returncode']=done.returncode;rec['finished_utc']=now();persist();return done
 persist();rows=[]
 try:
  meta['placement_probe']=dict(command=[*p['child_placement_prefix'],p['child_placement_prefix'][0],'--show'],complete=False,started_utc=now())
  result=execute(meta['placement_probe'],'placement');placement(result.stdout,result.stderr,result.returncode);meta['placement_probe']['complete']=True;persist()
  for case in cases():
   pins.need(require_lease()==lease,'Whole-matrix lease changed');pins.need(pins.sha(frozen['binary'])==frozen['binary_sha256']and pins.sha(p['child_placement_prefix'][0])==p['numactl_sha256'],'Tool/binary changed')
   rec=dict(case_index=case['case_index'],command=case['command'],complete=False,started_utc=now());meta['cases'].append(rec)
   result=execute(rec,f'case-{case["case_index"]:02d}');validate_process(result.returncode,result.stdout,result.stderr);pins.need(result.stderr==frozen['expected_stderr'].encode(),'Unexpected caller stderr')
   current=list(csv.DictReader(io.StringIO(result.stdout.decode())));validate_case(current,case);rows.extend(current);(output/'results.csv').write_bytes(csv_bytes(rows))
   rec.update(complete=True,row_count=len(current));meta['counts'].update(case_count=len(meta['cases']),row_count=len(rows),calibration_rows=sum(int(r['calibration_absent_queries'])>0 for r in rows),reuse_rows=sum(int(r['calibration_absent_queries'])==0 for r in rows));persist()
   print(f'complete case {len(meta["cases"])}/18; validated rows {len(rows)}/786',flush=True)
  pins.save(output/'quality.json',quality(rows));pins.need(pins.verify(args.source_commit)==frozen and require_lease()==lease,'Final source/lease drift')
  pins.need(pins.environment()==frozen['expected_environment'],'Environment changed');meta.update(complete=True,finished_utc=now());persist();audit(output,args.source_commit,frozen)
  files={path.name:dict(sha256=pins.sha(path),bytes=path.stat().st_size)for path in sorted(output.iterdir())if path.is_file()and path.name!='MANIFEST.json'}
  pins.save(output/'MANIFEST.json',dict(source_commit=args.source_commit,complete=True,files=files));print('Complete18 cases/786 rows; final source/raw/quality checks passed',flush=True)
 except BaseException as error:
  meta.update(complete=False,error=repr(error),traceback=traceback.format_exc(),stopped_utc=now());persist();raise
if __name__=='__main__':main()
