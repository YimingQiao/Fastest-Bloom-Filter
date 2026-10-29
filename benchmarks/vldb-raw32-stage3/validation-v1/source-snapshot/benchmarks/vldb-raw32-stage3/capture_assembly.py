"""Bounded typed-query assembly capture; no filter or query is executed."""
import json,re,subprocess
from pathlib import Path
from contract import need
from source_guard import sha

def capture(binary,directory):
    binary=Path(binary);directory=Path(directory);directory.mkdir(parents=True,exist_ok=False)
    command=['nm','-S','-C','--defined-only',str(binary)]
    symbols=subprocess.check_output(command,text=True);(directory/'symbols.txt').write_text(symbols)
    functions=[];seen={}
    for line in symbols.splitlines():
        match=re.match(r'^([0-9a-f]+) ([0-9a-f]+) ([A-Za-z]) (.*)$',line)
        if not match or 'vldb_stage2::Query<raw32_stage3::' not in match[4]:continue
        start,size=int(match[1],16),int(match[2],16)
        if (start,size) not in seen:
            label='query'+str(len(seen)).zfill(2)+'.asm';seen[start,size]=label
            cmd=['objdump','-dC','--no-show-raw-insn','--start-address='+str(start),'--stop-address='+str(start+size),str(binary)]
            text=subprocess.check_output(cmd,text=True);(directory/label).write_text(text)
        else:label=seen[start,size];text=(directory/label).read_text()
        functions.append(dict(symbol=match[4],start=start,bytes=size,artifact=label,
                              call_lines=[s.strip() for s in text.splitlines() if re.search(r'\bcall',s)]))
    need(functions,'No typed public-query symbols found')
    result=dict(binary=str(binary),binary_sha256=sha(binary),nm_command=command,functions=functions,
       scope='Public-single and dense branches share each typed Query. Out-of-line public APIs and original std::function dispatch are not rewritten.')
    (directory/'audit.json').write_text(json.dumps(result,indent=2)+'\n');return result
