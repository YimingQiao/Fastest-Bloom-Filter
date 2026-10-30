"""Immutable local, proposal and reused algorithm proof closure."""
import hashlib,json,re,subprocess
from pathlib import Path
from contract import need
HERE=Path(__file__).resolve().parent;BASE=HERE.parent;ROOT=HERE.parents[2]
PROPOSAL='df346951a1a66509b32074029965cef6bf9a7a2e'
OLD=ROOT/'experiments/2026-10-29-k12-line-or'
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def exact(commit,path):
 need(re.fullmatch('[0-9a-f]{40}',commit),'Full source commit required')
 need(subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)==path.read_bytes(),'Committed artifact changed '+str(path))
def verify(commit):
 pins={}
 for revision,directory,manifest_name in [(commit,HERE,'PREPARATION.json'),(PROPOSAL,BASE,'PREPARATION.json'),('422e2512932ac2d23b21ade9ae45e58e93bce6f2',OLD/'caller/order-v3','PROOF_ARCHIVE.json'),('a029583a66936b1bf061df4ee8699cb3514117ca',OLD,'COMPLETE_PROOF_ARCHIVE.json')]:
  manifest=directory/manifest_name;exact(revision,manifest);pins[str(manifest)]=sha(manifest)
  for name,item in json.loads(manifest.read_text())['files'].items():
   path=directory/name;need(path.resolve().is_relative_to(directory),'Manifest path escaped')
   need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Artifact changed');exact(revision,path);pins[str(path.resolve())]=sha(path)
 for proof in [OLD/'caller/COMPILED_PROOF.json',OLD/'caller/order-v3/COMPILED_PROOF.json']:
  meta=json.loads(proof.read_text());need(meta['complete'],'Reused proof incomplete')
  for group in ('all_binary_sha256','compiler_consumed_input_sha256'):
   for path,digest in meta[group].items():need(sha(path)==digest,'Reused compiled proof changed')
 return pins
