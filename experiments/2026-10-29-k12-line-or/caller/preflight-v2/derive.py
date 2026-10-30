#!/usr/bin/env python3
"""Preserve clang++ driver spelling; do not change any C++ source or flags."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
if not __debug__:raise SystemExit('Python -O unsupported')
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]
PARENT='dd13d1e829d4482d70093497b8d470bd09be22ac'
SOURCE='experiments/2026-10-29-k12-line-or/caller/validate.py'
def expected():
    original=subprocess.check_output(['git','show',PARENT+':'+SOURCE],cwd=ROOT).decode()
    changes=[
      ('from pathlib import Path\n','from pathlib import Path\nimport sys\nsys.path.insert(0, str(Path(__file__).resolve().parents[1]))\n'),
      ('from source_guard import HERE, ROOT, sha, verify','from source_guard import HERE, ROOT, sha\nfrom repair_guard import verify'),
      ("output=HERE/'validation-v1'","output=HERE/'validation-v2'"),
      ("compiler=Path('/usr/bin/clang++').resolve();meta['compiler']=dict(path=str(compiler),sha256=sha(compiler))", "compiler=Path('/usr/bin/clang++');meta['compiler']=dict(path=str(compiler),resolved_path=str(compiler.resolve()),sha256=sha(compiler))"),
      ("f'k12-line-or-v1-cpu{args.cpu}-{profile}'","f'k12-line-or-v2-cpu{args.cpu}-{profile}'"),
    ]
    revised=original
    for old,new in changes:
        assert revised.count(old)==1,old
        revised=revised.replace(old,new)
    restored=revised
    for old,new in reversed(changes):restored=restored.replace(new,old)
    assert restored==original
    patch=''.join(difflib.unified_diff(original.splitlines(True),revised.splitlines(True),fromfile='committed-v1/validate.py',tofile='preflight-v2/validate.py'))
    return revised,patch
def main():
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args();source,patch=expected()
    for name,value in [('validate.py',source),('DRIVER.patch',patch)]:
        if a.write:(HERE/name).write_text(value)
        else:assert (HERE/name).read_text()==value,name
    print('PASS driver-only repair; original C++/flags/checks unchanged')
if __name__=='__main__':main()
