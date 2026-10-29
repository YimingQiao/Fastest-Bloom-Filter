"""Offline completed conditional proof audit; no filter execution."""
import csv,io,json
from pathlib import Path
from repair_guard import HERE,PARENT,OLD,verify,sha
from contract import CASES,SEMANTICS,ordered_rows,need
SOURCE='d986c17dbe496c17627164283157e5a59c112639'
def audit(live=True):
 out=HERE/'validation-v1';meta=json.loads((out/'metadata.json').read_text())
 need(meta['complete'] is True and meta['source_commit']==SOURCE and meta['formal_workloads_run'] is False and meta['kernel1642_matrix_rerun'] is False,'Wrong proof status')
 need(len(meta['commands'])==41,'Incomplete command ledger')
 for row in meta['commands']:
  need(row['complete']and((row['returncode']==0)==row['expected_success']),'Unexpected command result')
  for stream in ('stdout','stderr'):need(sha(out/row[stream])==row[stream+'_sha256'],'Changed raw log')
  if not row['expected_success']:need(row['returncode']==1 and not(out/row['stdout']).read_bytes()and(out/row['stderr']).read_bytes(),'Malformed CLI shape')
 expected=[];semantics={}
 old=next(r for r in csv.DictReader(io.StringIO((OLD/'caller/validation-v2/native-caller-0.stdout').read_text()))if r['filter']=='K12ScalarOrControl')
 for profile in ('native','minimal-f','asan'):
  oracle=json.loads((out/(profile+'-boundary-check.stdout')).read_text());need(oracle==meta['profiles'][profile]['oracle']==dict(cases=18,digest=3747184550059334374,complete=True),'Independent boundary oracle mismatch')
  for index,case in enumerate(CASES):
   for rotation in range(3):
    for row in ordered_rows((out/f'{profile}-case{index}-latin{rotation}.stdout').read_text(),case,rotation):
     key=(index,row['filter']);value=tuple(row[k]for k in SEMANTICS);need(semantics.get(key,value)==value,'Order/backend semantics drift');semantics[key]=value
     if index==0 and row['filter']=='K12ScalarOrControl':need(value==tuple(old[k]for k in SEMANTICS),'Previous tiny control mismatch')
     expected.append(dict(profile=profile,case=index,rotation=rotation,**row))
 need(len(expected)==54 and expected==json.loads((out/'rows.json').read_text()),'Raw/aggregate mismatch')
 review=json.loads((HERE/'assembly-review/REVIEW.json').read_text());need(review['binary']==meta['profiles']['native']['executables']['compare_benchmark'],'ASM binary mismatch');need(review['source_assembly_sha256']==sha(out/'native-assembly.stdout'),'ASM source drift');need(review['all_eight_equal']and len(review['comparisons'])==8 and len(review['timing_windows'])==6,'Missing compiled gate')
 if live:
  need(verify(SOURCE)==meta['source_sha256'],'Live source changed')
  for group in ('all_binary_sha256','compiler_consumed_input_sha256'):
   for path,digest in meta[group].items():need(sha(path)==digest,'Binary/compiler input drift')
 return dict(commands=41,profiles=3,boundary_cases=54,caller_rows=54,invalid_cli=9,binaries=6,compiler_inputs=len(meta['compiler_consumed_input_sha256']),compiled_reference_bodies=8,clock_windows=6,formal_workloads_run=False,first_attempt='Preserved missing-include compile failure,0executables/0BF')
if __name__=='__main__':print(json.dumps(audit(),sort_keys=True))
