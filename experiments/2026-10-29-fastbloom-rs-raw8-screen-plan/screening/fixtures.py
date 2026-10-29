"""Synthetic rows only; this module never executes a Bloom filter or a timer."""
import csv,hashlib,json,statistics
from pathlib import Path
import contract,pins,row_guard as guard
SOURCE='1'*40
def rows():
 result=[]
 for case in contract.cases():
  args=case['binary_arguments'];n=case['keys'];q=1<<int(args[3]);cap=case['budget_bpk'];batch=case['batch'];present=case['positive_query_count'];cal=0 if not case['calibration_exponent']else 1<<case['calibration_exponent']
  for name in case['row_order']:
   direct=name.startswith('FastbloomRsRawK');g=guard.geometry(name,n,cap)
   alias='Fastbloom017K11'if name=='Fastbloom017'and cap==16 else name
   fingerprint=int.from_bytes(hashlib.sha256(f'{alias}/{n}/{cap}'.encode()).digest()[:8],'little')
   phase=';'.join('|'.join(map(str,trial))for trial in case['phase_order'])
   row=dict(language='rust',filter=name,keys=n,queries=q,requested_bpk=cap,actual_bpk=g['filter_bytes']*8/n,hit_percent=50,present_queries=present,batch=batch,insert_batch=4096,repeats=8,seed=42,key_base=case['key_base'],raw_hash_contract='public_raw8_two_seed_xxh3_64'if direct else'public_common_hash64',build_scratch_bytes=0 if direct else 32768,query_scratch_bytes=0 if direct else batch*8,absent_queries=q-present,false_positives=fingerprint%10000,result_checksum=fingerprint,calibration_absent_queries=cal,calibration_false_positives=fingerprint%10000 if cal else 0,query_phase_order=phase,**g)
   for i,metric in enumerate(guard.METRICS):
    values=[float(10*(i+1)+j)for j in range(8)]
    row.update({metric+'_trials':'|'.join(map(str,values)),metric+'_ns':statistics.median(values),metric+'_min_ns':min(values),metric+'_max_ns':max(values)})
   result.append({key:str(value)for key,value in row.items()})
 return result
def archive(directory,values=None):
 directory=Path(directory);values=rows()if values is None else values;p=contract.protocol()
 frozen=dict(binary=p['normal_binary'],binary_sha256=p['normal_binary_sha256'],host={'synthetic':True},expected_environment={key:None for key in pins.ENV_KEYS},expected_stderr='sbbf-rs 0.2.8 backend: Avx2Filter\n')
 lease=dict(cpu=2,socket=0,lease='socket0-cpu2',lock_path=p['lease_file'],inherited_lock_descriptors=[91],fdinfo_records=[dict(fd=91,fdinfo='lock:\t1: FLOCK  ADVISORY  WRITE 123 00:00:1 0 EOF\n')])
 # The freeze marker has a synthetic SHA supplied by the caller's mock.
 meta=dict(complete=True,source_commit=SOURCE,proposal_commit=pins.PROPOSAL,proof_commit=pins.PROOF,freeze_sha256='synthetic-freeze',protocol_sha256=pins.sha(pins.PLAN/'protocol.json'),binary=frozen['binary'],binary_sha256=frozen['binary_sha256'],host=frozen['host'],environment=frozen['expected_environment'],affinity=[2],lease_environment='socket0-cpu2',lease=lease,numactl_sha256=p['numactl_sha256'],cases=[],counts=dict(case_count=18,row_count=786,calibration_rows=262,reuse_rows=524))
 def streams(rec,label,out,err):
  for stream,data in [('stdout',out),('stderr',err)]:
   path=directory/(label+'.'+stream);path.write_bytes(data);rec[stream]=path.name;rec[stream+'_sha256']=pins.sha(path)
 probe=dict(command=[*p['child_placement_prefix'],p['child_placement_prefix'][0],'--show'],complete=True,returncode=0)
 streams(probe,'placement',b'policy: bind\nphyscpubind: 2\nmembind: 0\n',b'');meta['placement_probe']=probe
 offset=0
 for case in contract.cases():
  current=values[offset:offset+case['expected_rows']];offset+=len(current)
  rec=dict(case_index=case['case_index'],command=case['command'],complete=True,returncode=0,row_count=len(current))
  streams(rec,f'case-{case["case_index"]:02d}',contract.csv_bytes(current),frozen['expected_stderr'].encode());meta['cases'].append(rec)
 (directory/'results.csv').write_bytes(contract.csv_bytes(values));pins.save(directory/'quality.json',contract.quality(values));pins.save(directory/'metadata.json',meta)
 return frozen,meta
