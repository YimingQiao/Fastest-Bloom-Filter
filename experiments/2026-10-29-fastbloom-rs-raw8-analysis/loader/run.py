#!/usr/bin/env python3
"""Read only a complete immutable raw archive; never execute a measured binary."""
if not __debug__:raise RuntimeError('Python -O forbidden')
import argparse,hashlib,importlib.util,json,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;ANALYSIS=HERE.parent;ROOT=ANALYSIS.parents[1]
PLAN=ROOT/'experiments/2026-10-29-fastbloom-rs-raw8-screen-plan';SCREEN=PLAN/'screening'
PRODUCER='075b4fd88607c91e00fdf84bc3f1b87ea8d459ae'
ANALYSIS_COMMIT='ca83c8770fc054d28943e6f85fdf618e3576fe47'
PRODUCER_MANIFEST='0d8a07e21c0cfe23e206fa7e613780fae6c6118254d8b207aadcf1baa1fa331f'
ANALYSIS_MANIFEST='ac092a19efac752cfb99058d8f68dba69323cc444e391e060cc6dd03689cb1d0'
PRODUCER_FREEZE='c1baf0e5fbc4e7d39e38ebd4f997c1bf66683f6766a62cba6b439746d640ba67'
def need(ok,message):
 if not ok:raise ValueError(message)
def full_commit(value):need(re.fullmatch('[0-9a-f]{40}',value)is not None,'Full immutable commit required');return value
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def exact(path,commit,digest=None):
 path=Path(path);commit=full_commit(commit);data=subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
 need(path.read_bytes()==data,'Committed/live byte mismatch '+str(path));actual=hashlib.sha256(data).hexdigest();need(digest is None or actual==digest,'Committed hash mismatch '+str(path));return data
def source_manifest(base,commit,digest=None):
 manifest=base/'PREPARATION.json';data=json.loads(exact(manifest,commit,digest))
 for name,record in data['files'].items():
  path=base/name;need(path.resolve().is_relative_to(base),'Source manifest path escape');exact(path,commit,record['sha256']);need(path.stat().st_size==record['bytes'],'Source byte count mismatch')
 return data
def raw_paths():
 names={'metadata.json','results.csv','quality.json','MANIFEST.json','.gitattributes','placement.stdout','placement.stderr'}
 names|={f'case-{i:02d}.{stream}'for i in range(18)for stream in ['stdout','stderr']}
 return {'results-v1/'+name for name in names}|{'launch-v1.stdout','launch-v1.stderr'}
def raw_manifest(value):
 need(value['complete']is True and value['producer_commit']==PRODUCER,'Raw archive incomplete or wrong producer')
 need(set(value['files'])==raw_paths()and len(value['files'])==45,'Incomplete/extra raw archive members')
 need(value['launcher_exit_code']==0 and value['session_id']==98863,'Wrong formal session outcome')
 for name,record in value['files'].items():
  need((PLAN/name).resolve().is_relative_to(PLAN),'Raw path escape')
  need(type(record['bytes'])is int and record['bytes']>=0 and re.fullmatch('[0-9a-f]{64}',record['sha256']),'Invalid raw manifest entry')
def load(loader_commit,raw_commit):
 full_commit(loader_commit);full_commit(raw_commit)
 source_manifest(HERE,loader_commit)
 source_manifest(SCREEN,PRODUCER,PRODUCER_MANIFEST);exact(SCREEN/'freeze.json',PRODUCER,PRODUCER_FREEZE)
 source=source_manifest(ANALYSIS,ANALYSIS_COMMIT,ANALYSIS_MANIFEST)
 for name,digest in source['source_inputs_sha256'].items():exact(ROOT/name,PRODUCER,digest)
 archive_path=PLAN/'RAW_ARCHIVE.json';archive=json.loads(exact(archive_path,raw_commit));raw_manifest(archive)
 for name,record in archive['files'].items():
  path=PLAN/name;exact(path,raw_commit,record['sha256']);need(path.stat().st_size==record['bytes'],'Raw byte count mismatch')
 output=PLAN/'results-v1';runtime=json.loads((output/'MANIFEST.json').read_text())
 need(runtime['complete']is True and runtime['source_commit']==PRODUCER,'Wrong runtime manifest')
 need(set(runtime['files'])=={name.removeprefix('results-v1/')for name in raw_paths()if name.startswith('results-v1/')} - {'MANIFEST.json'},'Runtime inventory incomplete')
 for name,record in runtime['files'].items():need(record==archive['files']['results-v1/'+name],'Runtime/raw archive disagreement')
 need((PLAN/'launch-v1.stderr').read_bytes()==b'','Launcher diagnostic')
 sys.path.insert(0,str(SCREEN))
 import pins,contract
 need(Path(pins.__file__).resolve()==SCREEN/'pins.py'and Path(contract.__file__).resolve()==SCREEN/'contract.py','Unexpected producer import')
 frozen=pins.verify(PRODUCER);meta,rows=contract.audit(output,PRODUCER,frozen)
 cumulative=0;lines=[]
 for case in contract.cases():
  cumulative+=case['expected_rows'];lines.append(f'complete case {case["case_index"]+1}/18; validated rows {cumulative}/786')
 lines.append('Complete18 cases/786 rows; final source/raw/quality checks passed')
 need((PLAN/'launch-v1.stdout').read_text()=='\n'.join(lines)+'\n','Incomplete/unexpected launcher progress ledger')
 spec=importlib.util.spec_from_file_location('raw8_frozen_analysis',ANALYSIS/'summarize.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
 quality=json.loads((output/'quality.json').read_text())
 return module,rows,quality,dict(loader_commit=loader_commit,producer_commit=PRODUCER,analysis_commit=ANALYSIS_COMMIT,raw_commit=raw_commit,raw_archive_sha256=sha(archive_path),raw_manifest_sha256=sha(output/'MANIFEST.json'),row_count=len(rows),case_count=len(meta['cases']),same_binary_all_cases=True,separate_processes=18,training_seed=42)
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--loader-commit',required=True);parser.add_argument('--raw-commit',required=True);parser.add_argument('--output',required=True);args=parser.parse_args()
 output=Path(args.output);need(not output.exists()and not output.is_symlink(),'Preserve existing analysis')
 module,rows,quality,provenance=load(args.loader_commit,args.raw_commit);result=module.analyze(rows,quality);output.mkdir(parents=True)
 for name,value in result.items():(output/(name+'.json')).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
 (output/'provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
 print(json.dumps(result['counts'],sort_keys=True))
if __name__=='__main__':main()
