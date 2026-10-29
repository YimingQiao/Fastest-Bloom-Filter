"""Capture every typed Query from the actual native worker; no query execution."""
import json
from pathlib import Path
import re
import subprocess
from checks import need
from source_guard import sha

def capture(binary,directory):
    directory=Path(directory);directory.mkdir(parents=True,exist_ok=False)
    command=['nm','-S','-C','--defined-only',str(binary)]
    symbols=subprocess.check_output(command,text=True);(directory/'symbols.txt').write_text(symbols)
    functions=[];seen={}
    for line in symbols.splitlines():
        m=re.match(r'^([0-9a-f]+) ([0-9a-f]+) ([A-Za-z]) (.*)$',line)
        if not m or 'vldb_stage2::Query<'not in m[4]:continue
        start,size=int(m[1],16),int(m[2],16)
        if(start,size)not in seen:
            name='query-'+str(len(seen)).zfill(2)+'.asm';seen[start,size]=name
            argv=['objdump','-dC','--no-show-raw-insn','--start-address='+str(start),'--stop-address='+str(start+size),str(binary)]
            text=subprocess.check_output(argv,text=True);(directory/name).write_text(text)
        else:name=seen[start,size];text=(directory/name).read_text()
        functions.append(dict(symbol=m[4],start=start,bytes=size,artifact=name,
                              call_lines=[x.strip()for x in text.splitlines()if re.search(r'\bcall',x)]))
    need(len(functions)>=20,'Incomplete typed query assembly capture')
    result=dict(binary=str(binary),binary_sha256=sha(binary),nm_command=command,functions=functions,
        manual_review_complete=False,scope='Capture only; manual public singleton/dense/hash/compact boundary review required before timing')
    (directory/'audit.json').write_text(json.dumps(result,indent=2)+'\n');return result
