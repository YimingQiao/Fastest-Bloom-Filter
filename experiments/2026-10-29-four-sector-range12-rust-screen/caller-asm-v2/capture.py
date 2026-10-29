#!/usr/bin/env python3
"""Correct archive-only GNU demangled disassembly by frozen symbol address ranges."""
import argparse,hashlib,importlib.util,json,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1]

def need(ok,why):
    if not ok:raise ValueError(why)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,value):p.write_text(json.dumps(value,indent=2)+'\n')
def main():
    p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);args=p.parse_args();need(__debug__ and re.fullmatch('[0-9a-f]{40}',args.source_commit),'Immutable source commit required')
    declaration=HERE/'PREPARATION.json'
    need(declaration.read_bytes()==subprocess.check_output(['git','show',args.source_commit+':'+str(declaration.relative_to(ROOT))],cwd=ROOT),'Uncommitted capture manifest')
    prep=json.loads(declaration.read_text())
    for name,digest in prep['inputs_sha256'].items():
        path=ROOT/name;need(sha(path)==digest,'Changed capture input');need(hashlib.sha256(subprocess.check_output(['git','show',args.source_commit+':'+name],cwd=ROOT)).hexdigest()==digest,'Uncommitted capture input')
    spec=importlib.util.spec_from_file_location('lease',STAGE/'caller/preflight/source_guard.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);lease=module.require_lease(3)
    raw=STAGE/'caller/validation-v1';meta=json.loads((raw/'metadata.json').read_text());binary=Path(meta['assembly']['binary']);need(sha(binary)==meta['assembly']['sha256'],'Original executable changed')
    records=[]
    for line in (raw/'normal-asm-nm.stdout').read_text().splitlines():
        fields=line.split(None,2)
        if len(fields)==3 and re.fullmatch('[0-9a-fA-F]+',fields[0]):records.append((int(fields[0],16),fields[2]))
    output=HERE/'capture-v2';need(not output.exists()and not output.is_symlink(),'Preserve older capture attempt');output.mkdir()
    report=dict(complete=False,source_commit=args.source_commit,lease=lease,binary=str(binary),binary_sha256=sha(binary),correctness_rerun=False,compiler_runs=0,filter_runs=0,commands=[])
    save(output/'CAPTURE.json',report)
    for index,item in enumerate(meta['assembly']['selected']):
        begin=int(item['address'],16);need((begin,item['symbol'])in records,'Frozen raw symbol mismatch');end=min(a for a,s in records if a>begin)
        command=['/usr/bin/objdump','-d','--demangle','--no-show-raw-insn','--start-address='+hex(begin),'--stop-address='+hex(end),str(binary)]
        need(sha(Path(command[0]))==meta['assembly']['tools_sha256'][command[0]],'Disassembler changed')
        result=subprocess.run(command,capture_output=True);stdout=output/f'query-{index}.stdout';stderr=output/f'query-{index}.stderr';stdout.write_bytes(result.stdout);stderr.write_bytes(result.stderr)
        row=dict(command=command,returncode=result.returncode,begin=begin,end=end,symbol=item['symbol'],demangled=item['demangled'],stdout=stdout.name,stderr=stderr.name,stdout_sha256=sha(stdout),stderr_sha256=sha(stderr));report['commands'].append(row);save(output/'CAPTURE.json',report)
        need(result.returncode==0,'Disassembly failed; retained attempt');text=result.stdout.decode();instructions=re.findall(r'^\s*([0-9a-f]+):\s+(\S+)',text,re.M)
        need(instructions and int(instructions[0][0],16)==begin and all(begin<=int(a,16)<end for a,m in instructions),'Missing/bad actual instruction body')
        need(item['demangled']in text,'Expected demangled symbol label missing')
        row['instructions']=len(instructions);row['complete']=True;save(output/'CAPTURE.json',report)
    need(len(report['commands'])==5 and sha(binary)==report['binary_sha256'],'Incomplete capture or changed binary')
    need(module.require_lease(3)==lease,'Lease changed');report['complete']=True;save(output/'CAPTURE.json',report);print('PASS: five bounded actual instruction bodies, no compile/BF')
if __name__=='__main__':main()
