"""Read retained assembly text only. No binary execution or disassembly."""
import hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent;BASE=HERE.parent
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def instructions(text):
 result=[]
 for line in text.splitlines():
  match=re.match(r'\s*([0-9a-f]+):\s+(.+)',line)
  if match:result.append(dict(pc=int(match[1],16),text=match[2]))
 return result
def main():
 meta=BASE/'validation-v2/metadata.json';data=json.loads(meta.read_text());result=dict(metadata_sha256=sha(meta),scope='Existing text only; no compiler/BF/disassembler; public caller and clock inventory, not performance',profiles={})
 for mode,group in data['assembly'].items():
  output=[];windows=[]
  for symbol in group['symbols']:
   path=BASE/symbol['stdout'];assert sha(path)==symbol['sha256'];ins=instructions(path.read_text());assert ins and ins[0]['pc']==symbol['start']
   entry=dict(name=symbol['display_label'],raw_symbol=symbol['raw_symbol'],role=symbol['role'],start=hex(symbol['start']),size=symbol['size'],source=symbol['stdout'],source_sha256=symbol['sha256'],calls=[dict(pc=hex(i['pc']),instruction=i['text'])for i in ins if i['text'].startswith('call')])
   if symbol['role']=='Run<':
    clocks=[i for i in ins if i['text'].startswith('call')and 'steady_clock3nowEv' in i['text']];assert len(clocks)==2
    a,b=clocks;inside=[i for i in ins if a['pc']<i['pc']<b['pc']];queries=[i for i in inside if i['text'].startswith('call')and ('lookup_kernel' in i['text']or'inline_single_kernel'in i['text'])];assert len(queries)==4
    assert not any('Output5Check' in i['text']for i in inside)
    checks=[i for i in ins if i['pc']>b['pc']and i['text'].startswith('call')and'Output5Check'in i['text']];assert checks
    windows.append(dict(name=symbol['display_label'],source=symbol['stdout'],start_clock=hex(a['pc']),stop_clock=hex(b['pc']),first_output_check_after_stop=hex(checks[0]['pc']),query_calls=[dict(pc=hex(i['pc']),instruction=i['text'])for i in queries],hash_multiply_sites=[dict(pc=hex(i['pc']),instruction=i['text'])for i in inside if re.search(r'\b(imul|vpmullq|vpmuludq)\b',i['text'])]))
   output.append(entry)
  assert len(output)==76 and len(windows)==19
  result['profiles'][mode]=dict(binary_sha256=group['sha256'],symbols=output,clock_windows=windows)
 capture=BASE/'assembly-review/callees-v1/CAPTURE.json';callees=json.loads(capture.read_text());result['callee_capture_sha256']=sha(capture)
 for mode,group in callees['profiles'].items():
  assert group['sha256']==result['profiles'][mode]['binary_sha256']and not group['unbound_external_transfers']
  for symbol in group['callees']:assert sha(BASE/symbol['stdout'])==symbol['stdout_sha256']
  result['profiles'][mode]['callee_symbols']=[dict(start=hex(s['start']),size=s['size'],names=s['raw_symbols'],source=s['stdout'],sha256=s['stdout_sha256'],transfers=s['transfers'])for s in group['callees']]
 (HERE/'inventory.json').write_text(json.dumps(result,indent=2)+'\n')
 print('Existing text verified: 152 typed spans,38 clock windows with4 query routes each,32 extra callee spans; no execution/disassembly.')
if __name__=='__main__':main()
