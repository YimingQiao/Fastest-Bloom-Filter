"""Record actual GCC/Clang dependency files, including the complete Boost root."""
import hashlib,json,re,shlex
from pathlib import Path

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def capture(build):
    build=Path(build).resolve()
    database=json.loads((build/'compile_commands.json').read_text())
    files=set()
    depfiles=sorted(build.rglob('*.o.d'))
    if not depfiles:raise ValueError('No actual compiler dependency files')
    for dependency in depfiles:
        text=dependency.read_text().replace('\\\n',' ')
        _,sep,body=text.partition(':')
        if not sep:raise ValueError('Malformed dependency file: '+str(dependency))
        for name in shlex.split(body):
            path=Path(name)
            if not path.is_absolute():path=build/path
            path=path.resolve()
            if not path.is_file():raise ValueError('Consumed dependency missing: '+str(path))
            files.add(path)
    boost_files=sorted(p for p in files if '/boost/' in str(p))
    roots={str(p).partition('/boost/')[0] for p in boost_files}
    if len(roots)!=1:raise ValueError('Mixed or absent Boost include roots: '+str(roots))
    root=Path(next(iter(roots)));version=root/'boost/version.hpp'
    text=version.read_text()
    numeric=re.search(r'^#define BOOST_VERSION (\d+)$',text,re.M)
    label=re.search(r'^#define BOOST_LIB_VERSION "([^"]+)"$',text,re.M)
    if not numeric or not label:raise ValueError('Unrecognized Boost version')
    return dict(scope='Actual compiler .o.d inputs; version.hpp also queried explicitly',
                build=str(build),compile_commands=database,
                dependency_files={str(p):digest(p) for p in depfiles},
                consumed_files={str(p):digest(p) for p in sorted(files)},
                boost=dict(include_root=str(root),numeric_version=int(numeric.group(1)),
                           version=label.group(1),version_header_sha256=digest(version),
                           consumed_headers={str(p):digest(p) for p in boost_files}))
