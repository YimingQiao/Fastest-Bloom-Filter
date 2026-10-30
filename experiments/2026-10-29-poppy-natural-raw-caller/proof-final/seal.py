"""Audit completed bounded records and seal provenance; no compiler/filter execution."""
import csv,hashlib,io,json,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1]
DRIVER='ec58efb7594ebcff31f9795e11b03f11b938733a';BASE='8d533d9711f5d4cb30f7496dcf29860b35359bca'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2,allow_nan=False)+'\n')
for source,folder in [(DRIVER,STAGE/'repair-v2'),(BASE,STAGE/'preflight')]:
 descriptor=folder/'PREPARATION.json';prep=json.loads(descriptor.read_text())
 for p in [descriptor,*[folder/n for n in prep['files']]]:
  assert p.read_bytes()==subprocess.check_output(['git','show',source+':'+str(p.relative_to(ROOT))],cwd=ROOT)
sys.path.insert(0,str(STAGE/'repair-v2'))
import contract as c
meta=json.loads((STAGE/'validation-v2/metadata.json').read_text());outcome=json.loads((STAGE/'execution-v2/execution-outcome.json').read_text())
assert meta['complete']and meta['functional_complete']and meta['source_commit']==DRIVER
assert len(meta['commands'])==50 and all(r['complete']for r in meta['commands'])
assert outcome['session_id']==42049 and outcome['terminal_result']['exit_code']==0 and outcome['terminal_result']['output']==''and 'session_id'not in outcome['terminal_result']
assert outcome['metadata_sha256']==sha(STAGE/'validation-v2/metadata.json')
for command in meta['commands']:
 for stream in ['stdout','stderr']:assert sha(STAGE/'validation-v2'/command[stream])==command[stream+'_sha256']
 case_rejection=command['expected_rejection'];c.validate_process(command['returncode'],(STAGE/'validation-v2'/command['stdout']).read_bytes(),(STAGE/'validation-v2'/command['stderr']).read_bytes(),case_rejection)
assert (meta['focused_test_executions'],meta['caller_rows'],meta['parent_control_comparisons'],meta['invalid_cli_cases'])==(8,146,90,12)
assert len(meta['binaries'])==4 and len(meta['cases'])==10
inventory=json.loads((STAGE/'repair-v2/INPUTS.json').read_text());identity={};rows_count=0
for mode in ['normal','asan']:
 for index,case in enumerate(c.cases()):
  rows=list(csv.DictReader((STAGE/'validation-v2'/f'{mode}-case-{index}.stdout').read_text().splitlines()));c.validate_rows(rows,case);rows_count+=len(rows)
  if index==0:
   old=list(csv.DictReader(Path(inventory['parent_reference'][mode]['path']).read_text().splitlines()));c.validate_reference(rows,old)
  for row in rows:assert identity.setdefault(row['filter'],c.semantic(row))==c.semantic(row)
assert rows_count==146 and len(identity)==59
for values in [meta['binaries'],meta['toolchains'],*meta['compiler_inputs'].values()]:
 for path,digest in values.items():assert sha(path)==digest,(path,'actual input/binary/tool drift')
for ccase in meta['cases']:
 assert ccase['mode']in ['normal','asan']and ccase['case']in c.cases()
normal=json.loads((STAGE/'validation-v2/assembly-spans.json').read_text());extract=json.loads((STAGE/'assembly-review/EXTRACT.json').read_text())
assert sha(STAGE/'validation-v2/assembly-spans.json')==meta['assembly']['sha256']and extract['binary_sha256']==normal['binary_sha256']
assert extract['clock_rows']==28 and len(extract['constructor_spans'])==14
for name,digest in extract['source_text_sha256'].items():assert sha(STAGE/'validation-v2'/name)==digest
assert sha(STAGE/'assembly-review/clock-map.csv')==extract['clock_map_sha256']
freeze=dict(complete=True,driver_commit=DRIVER,initial_driver_commit=BASE,source_commit=meta['caller_source_commit'],resolution_commit=meta['resolution_commit'],reference_commit=meta['reference_commit'],failed_attempt_commit='35e22898d0a4afa23113b190617a7bce09e8660d',
 session=42049,actual_terminal_result=outcome['terminal_result'],numa_evidence='execution-v2/numa.stdout',metadata_sha256=sha(STAGE/'validation-v2/metadata.json'),
 binaries=meta['binaries'],toolchains=meta['toolchains'],actual_compiler_inputs=meta['compiler_inputs'],actual_source_counts={k:len(v)for k,v in meta['compiler_inputs'].items()},prepared_package_count=87,prepared_source_files=4487,
 counts={'commands':50,'executables':4,'focused_test_invocations':8,'caller_rows':146,'parent_semantic_reproductions':90,'invalid_clis':12,'real_constructor_forms_per_profile':28,'new_small_full_load_rows_per_profile':28,'normal_asm_unique_spans':len(normal['spans']),'constructor_spans':14,'report_clock_rows':28},
 proof_scope='Bounded public semantics/allocation/lifecycle/actual caller proof; large constructors use1031 inserted fixture keys; no full-load FPR or performance selection',manual_review='assembly-review/REVIEW.md')
save(HERE/'FREEZE.json',freeze)
files={str(p.relative_to(STAGE)):{'sha256':sha(p),'bytes':p.stat().st_size}for p in sorted(STAGE.rglob('*'))if p.is_file()and '__pycache__'not in p.parts and p.name!='ARCHIVE.json'and p not in [HERE/'seal.stdout',HERE/'seal.stderr']}
# Seal logs are produced outside this invocation and added by the caller afterward.
save(HERE/'ARCHIVE.json',dict(complete=True,driver_commit=DRIVER,files=files))
print(json.dumps({'complete':True,'artifacts_before_seal_logs':len(files),'freeze_sha256':sha(HERE/'FREEZE.json'),'counts':freeze['counts']}))
