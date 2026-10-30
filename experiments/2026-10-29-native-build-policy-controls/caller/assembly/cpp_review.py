#!/usr/bin/env python3
"""Extract/check already captured C++ text; no disassembler or executable run."""
import hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent
CAPTURE=HERE/'capture-v2'
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def need(ok,message):
 if not ok:raise ValueError(message)
def main():
 meta=json.loads((CAPTURE/'CAPTURE.json').read_text());item=next(c for c in meta['commands']if c['label']=='cpp-disassembly')
 source=CAPTURE/'cpp-disassembly.stdout';need(sha(source)==item['stdout_sha256'],'Capture text changed')
 lines=source.read_text().splitlines();starts=[i for i,line in enumerate(lines)if re.match(r'^[0-9a-f]+ <',line)]
 functions={}
 for begin,end in zip(starts,starts[1:]+[len(lines)]):
  match=re.match(r'^([0-9a-f]+) <(.*)>:$',lines[begin]);functions[int(match[1],16)]=(match[2],lines[begin:end])
 out=HERE/'cpp-review';need(not out.exists(),'Preserve review');out.mkdir()
 def instruction(line):
  match=re.match(r'^\s*([0-9a-f]+):\s+(?:(?:[0-9a-f]{2})\s+)+\s*(.*)$',line)
  return (int(match[1],16),match[2])if match else None
 trials={};windows=[]
 for address,(name,body)in functions.items():
  match=re.search(r'::Trial<(true|false), ([012])u>',name)
  if not match:continue
  family='Split64Range'if match[1]=='true'else'Split64';variant=int(match[2]);side=['before','clone','after'][variant]
  trials[family+'/'+side]=hex(address);calls=[i for i,line in enumerate(body)if re.search(r'\bcall\s',line)and '::InsertParallel('in line]
  need(len(calls)==2,'Expected allocation and insertion calls')
  for contract,index in zip(['allocate_insert','insert'],calls):
   call=instruction(body[index]);target=int(re.search(r'\bcall\s+([0-9a-f]+)',call[1])[1],16)
   need('native_'+side+'::'in functions[target][0],'Wrong native public callee')
   start=max(i for i in range(index)if re.search(r'\bcall\s',body[i])and 'steady_clock::now()'in body[i])
   stop=next(i for i in range(index+1,len(body))if re.search(r'\bcall\s',body[i])and 'steady_clock::now()'in body[i])
   segment=body[start:stop+1]
   requests=[instruction(line)[0]for line in segment if '0x18(%r13),%rcx'in line]
   need(len(requests)==1,'Original Case.requested missing inside clocks')
   constructors=[instruction(line)[0]for line in segment if re.search(r'\bcall\s',line)and '::'+family+'BloomFilter::'+family+'BloomFilter('in line]
   need(len(constructors)==(1 if contract=='allocate_insert'else 0),'Wrong constructor placement')
   filename=family+'-'+side+'-'+contract+'.txt';(out/filename).write_text('\n'.join(segment)+'\n')
   windows.append(dict(family=family,variant=side,contract=contract,trial=hex(address),start=hex(instruction(body[start])[0]),request_load=hex(requests[0]),native_call=hex(call[0]),native_target=hex(target),stop=hex(instruction(body[stop])[0]),constructor_calls=[hex(x)for x in constructors],artifact=filename))
 need(len(trials)==6 and len(set(trials.values()))==6 and len(windows)==12,'Wrong actual typed entry count')
 dispatch={}
 for family,lo,hi in [('Split64',0xd2e0,0xd3b1),('Split64Range',0xebbc,0xec87)]:
  selected=[line for line in lines if instruction(line)and lo<=instruction(line)[0]<hi]
  calls=[instruction(line)for line in selected if re.search(r'\bcall\s',line)and '::Trial<'in line]
  before=[(pc,text)for pc,text in calls if ', 0u>'in text]
  need(len(calls)==3 and len(before)==1 and 'call   '+trials[family+'/before'][2:]in before[0][1],'A0/A1 must share one exact callsite')
  need(any('cmp    $0x2'in line for line in selected)and any('cmp    $0x3'in line for line in selected),'Missing clone/policy branch tests')
  filename=family+'-dispatch.txt';(out/filename).write_text('\n'.join(selected)+'\n')
  dispatch[family]=dict(shared_a0_a1_callsite=hex(before[0][0]),shared_trial=trials[family+'/before'],artifact=filename)
 gates={}
 for family,target in [('Split64Range',0x20e70),('Split64',0x2b230)]:
  body=functions[target][1];head=[]
  for line in body:
   head.append(line)
   if 'hardware_concurrency()'in line:break
  need(any('$0x40001'in line for line in head)and any('$0x10001'in line for line in head),'Inclusive byte/n gate missing')
  need(sum('cmovae %rcx,%rax'in line for line in head)==2,'Original requested T not retained outside either bound')
  filename=family+'-policy-callee.txt';(out/filename).write_text('\n'.join(head)+'\n')
  gates[family]=dict(public_entry=hex(target),artifact=filename)
 result=dict(binary=meta['selected_normal_executables']['cpp'],capture_sha256=sha(source),trials=trials,windows=windows,shared_dispatch=dispatch,policy_gates=gates,
  clone_trial_folded=False,clone_public_insert_folded=False,scope='Measured Trial and native public insertion entries are distinct. No exhaustive claim about every internal helper.',compiler_or_filter_executed=False)
 (out/'REVIEW.json').write_text(json.dumps(result,indent=2)+'\n')
 print('PASS6 distinct CPP typed Trial entries, shared A0/A1 sites,12 native clock windows and2 actual gates')
if __name__=='__main__':main()
