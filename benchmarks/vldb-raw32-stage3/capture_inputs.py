"""Capture actual dependencies PER TARGET; two complete Boost roots stay apart."""
import json,re,shlex
from pathlib import Path
from contract import need
from source_guard import sha

def capture(build,target,version):
    build=Path(build).resolve();directory=build/'CMakeFiles'/(target+'.dir')
    depfiles=sorted(directory.rglob('*.o.d'));need(depfiles,'Missing actual target dependency files')
    inputs=set()
    for dep in depfiles:
        text=dep.read_text().replace('\\\n',' ');_,sep,body=text.partition(':');need(sep,'Malformed dependency file')
        for name in shlex.split(body):
            p=Path(name);p=(p if p.is_absolute() else build/p).resolve();need(p.is_file(),'Missing consumed header');inputs.add(p)
    headers=sorted(p for p in inputs if '/boost/' in str(p));roots={str(p).partition('/boost/')[0] for p in headers}
    need(len(roots)==1,'Mixed or absent Boost root in '+target)
    root=Path(next(iter(roots)));v=root/'boost/version.hpp';label=re.search(r'^#define BOOST_LIB_VERSION "([^"]+)"$',v.read_text(),re.M)
    need(label and label.group(1)==version,'Wrong target Boost version')
    database=json.loads((build/'compile_commands.json').read_text())
    entries=[r for r in database if ('CMakeFiles/'+target+'.dir/') in r.get('command','')]
    need(entries and len(entries)==len(depfiles),'Missing or ambiguous target compile commands')
    return dict(target=target,boost_version=version,boost_include_root=str(root),version_header_sha256=sha(v),
                compile_commands=entries,dependency_files={str(p):sha(p) for p in depfiles},
                consumed_inputs={str(p):sha(p) for p in sorted(inputs)})
