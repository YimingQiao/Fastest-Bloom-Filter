"""Actual compiler dependencies for nested CMake targets; exact Boost root."""
import json,re,shlex
from pathlib import Path
from checks import need
from source_guard import sha

def inputs(build,target):
    build=Path(build).resolve()
    depfiles=sorted(build.glob('**/'+target+'.dir/**/*.o.d'))
    need(depfiles,'Missing actual target dependency files')
    consumed=set()
    for dep in depfiles:
        _,separator,body=dep.read_text().replace('\\\n',' ').partition(':')
        need(separator,'Malformed dependency file')
        for name in shlex.split(body):
            p=Path(name);p=(p if p.is_absolute()else build/p).resolve()
            need(p.is_file(),'Consumed dependency missing');consumed.add(p)
    headers=[p for p in consumed if '/boost/'in str(p)]
    roots={str(p).partition('/boost/')[0]for p in headers}
    need(len(roots)==1,'Mixed or absent Boost root')
    root=Path(next(iter(roots)));version=root/'boost/version.hpp'
    need('#define BOOST_LIB_VERSION "1_92"'in version.read_text(),'Expected complete Boost1.92')
    database=json.loads((build/'compile_commands.json').read_text())
    commands=[c for c in database if 'CMakeFiles/'+target+'.dir/'in c.get('command','')]
    need(len(commands)==len(depfiles),'Compile command/dependency count mismatch')
    return dict(target=target,boost_include_root=str(root),boost_version='1_92',
       compile_commands=commands,dependency_files={str(p):sha(p)for p in depfiles},
       consumed_inputs={str(p):sha(p)for p in sorted(consumed)})

def macro_command(entry):
    args=entry.get('arguments')or shlex.split(entry['command']);result=[];i=0
    while i<len(args):
        if args[i]=='-o':i+=2;continue
        if args[i]not in ('-c',entry['file']):result.append(args[i])
        i+=1
    return result+['-dM','-E','-x','c++','/dev/null']
