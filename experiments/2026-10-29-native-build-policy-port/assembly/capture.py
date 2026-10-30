#!/usr/bin/env python3
"""Read-only disassembly after the combined correctness proof is sealed."""
import argparse,hashlib,json,os,shutil,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def need(ok,message):
    if not ok:raise ValueError(message)
def main():
    p=argparse.ArgumentParser();p.add_argument('--proof',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    need(os.sched_getaffinity(0)=={4},'Read-only capture is fixed to CPU4')
    proof=json.loads(a.proof.read_text());need(proof['complete']and proof['functional_complete']and proof['provenance_complete'],'Require sealed complete combined proof')
    need(not a.output.exists()and not a.output.is_symlink(),'Preserve every capture');a.output.mkdir()
    tool=shutil.which('llvm-objdump')or shutil.which('objdump');need(tool is not None,'Disassembler missing')
    commands=[]
    for language,item in proof['selected_normal_executables'].items():
        binary=Path(item['path']);need(sha(binary)==item['sha256'],'Frozen normal binary changed')
        command=[tool,'-d','--demangle',str(binary)];result=subprocess.run(command,capture_output=True)
        (a.output/(language+'.txt')).write_bytes(result.stdout);(a.output/(language+'.stderr')).write_bytes(result.stderr)
        need(result.returncode==0,'Disassembler failed');need(sha(binary)==item['sha256'],'Binary changed during capture')
        commands.append({'language':language,'command':command,'binary_sha256':item['sha256'],'output_sha256':sha(a.output/(language+'.txt')),'returncode':0})
    version=subprocess.check_output([tool,'--version'],text=True)
    (a.output/'CAPTURE.json').write_text(json.dumps({'proof_path':str(a.proof.resolve()),'proof_sha256':sha(a.proof),'tool':tool,'tool_sha256':sha(tool),'version':version,'commands':commands,'compiler_or_filter_executed':False,'timing_claim':False},indent=2)+'\n')
    print('Captured both actual native callers read-only; manual clock/policy review still required')
if __name__=='__main__':main()
