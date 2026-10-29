"""Committed finite plan/caller proof and unchanged already-built executables."""
import hashlib,json,os,re,subprocess,sys
from pathlib import Path
from contract import HERE,ROOT,PLAN,CALLER,CPUS,need
PROOF_COMMIT='a03a3766ac43871b13cc5fb63bbaad8e28280e0a'
PROOF_SHA='cc634351b8dba161c30b5620238efd1f5c7e4d9e680970b924cce28da2c599bf'
CALLER_SOURCE='81c97970f9a67facd0dd0a4e567097af30b9b0ae'
PLAN_COMMIT='295ff839e4f3199f05992add42f85ff54861e45c'
ENV_KEYS=['LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','ASAN_OPTIONS','UBSAN_OPTIONS']
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def exact(commit,path):
 need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'full immutable commit required')
 need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),'committed bytes differ: '+str(path))
def verify(commit):
 archive=CALLER/'ARCHIVE.json';need(sha(archive)==PROOF_SHA,'caller proof archive changed');exact(PROOF_COMMIT,archive)
 closure={str(archive):sha(archive)}
 for name,h in json.loads(archive.read_text())['files'].items():
  p=CALLER/name;need(p.resolve().is_relative_to(CALLER),'proof path escaped');need(sha(p)==h,'proof artifact drift');exact(PROOF_COMMIT,p);closure[str(p)]=h
 sys.path.insert(0,str(CALLER));import proof_audit
 need(proof_audit.SOURCE==CALLER_SOURCE,'wrong audited caller');counts=proof_audit.audit(live=True)
 descriptor=json.loads((CALLER/'PROOF.json').read_text());need(descriptor['complete']and not descriptor['timings_ranked'],'caller proof not complete')
 for name in ['PREPARATION.json','selection.json','protocol.json','plan.py','README.md']:exact(PLAN_COMMIT,PLAN/name);closure[str(PLAN/name)]=sha(PLAN/name)
 prep=HERE/'PREPARATION.json';exact(commit,prep);closure[str(prep)]=sha(prep)
 for name,h in json.loads(prep.read_text())['files'].items():
  p=HERE/name;need(p.resolve().is_relative_to(HERE),'screen path escaped');need(sha(p)==h,'screen source drift');exact(commit,p);closure[str(p)]=h
 return {'caller_source_commit':CALLER_SOURCE,'caller_proof_commit':PROOF_COMMIT,'caller_proof_sha256':PROOF_SHA,'plan_commit':PLAN_COMMIT,'proof_counts':counts,'source_sha256':closure,'binaries':descriptor['binaries'],'compiler_inputs':descriptor['compiler_inputs']}
def placement():
 need(os.sched_getaffinity(0)=={2},'formal parent must have CPU2-only affinity')
 descriptors=[];lock=Path('/tmp/fastest-bf-socket0.lock')
 for p in Path('/proc/self/fd').iterdir():
  try:
   if p.resolve()==lock and 'FLOCK  ADVISORY  WRITE'in Path('/proc/self/fdinfo',p.name).read_text():descriptors.append(int(p.name))
  except OSError:pass
 need(descriptors,'actual inherited exclusive socket0 FLOCK required')
 for k in ENV_KEYS:need(not os.environ.get(k),'unfrozen runtime environment '+k)
 topology=[]
 for cpu in CPUS:
  base=Path('/sys/devices/system/cpu')/('cpu'+str(cpu));socket=int((base/'topology/physical_package_id').read_text());core=int((base/'topology/core_id').read_text());nodes=[int(p.name[4:])for p in base.glob('node[0-9]*')]
  need(socket==0 and nodes==[0],'wrong physical socket/NUMA placement');topology.append({'cpu':cpu,'socket':socket,'core':core,'node':nodes[0]})
 need(len({(t['socket'],t['core'])for t in topology})==8,'SMT sibling used as physical core')
 return {'parent_affinity':[2],'lock':str(lock),'inherited_lock_descriptors':sorted(descriptors),'topology':topology,'runtime_environment':{k:os.environ.get(k,'')for k in ENV_KEYS}}
