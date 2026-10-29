#!/usr/bin/env python3
"""Fetch exact upstream Git objects into isolated repositories; never copy local worktrees."""
import hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
PINS={'reproduction':('https://github.com/peterboncz/bloomfilter-repro.git','0d2fe8e72496909cdac73c914e8f1a3dd956ac7f'),'dtl':('https://github.com/peterboncz/bloomfilter-bsd.git','c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf')}
def git(path,*args):return subprocess.check_output(['git','-C',str(path),*args],text=True).strip()
def main():
    result={}
    for name,(url,revision) in PINS.items():
        dest=HERE/'.deps'/name
        if not (dest/'.git').exists():
            dest.mkdir(parents=True,exist_ok=True)
            subprocess.run(['git','init','-q',str(dest)],check=True)
            git(dest,'remote','add','origin',url)
        if git(dest,'remote','get-url','origin')!=url:raise ValueError('Unexpected upstream URL')
        if git(dest,'status','--porcelain'):raise ValueError('Refuse to overwrite a modified dependency')
        try:git(dest,'cat-file','-e',revision+'^{commit}')
        except subprocess.CalledProcessError:git(dest,'fetch','--depth=1','origin',revision)
        git(dest,'checkout','--detach',revision)
        if git(dest,'rev-parse','HEAD')!=revision:raise ValueError('Wrong revision')
        result[name]=dict(url=url,commit=revision,tree=git(dest,'rev-parse',revision+'^{tree}'))
    link=git(HERE/'.deps/reproduction','ls-tree',PINS['reproduction'][1],'module/dtl').split()
    if link[:3]!=['160000','commit',PINS['dtl'][1]]:raise ValueError('Artifact submodule gitlink differs')
    result['gitlink']=' '.join(link)
    files={}
    dep=HERE/'.deps/dtl'
    for name in git(dep,'ls-files').splitlines():
        path=dep/name
        if path.is_file():files[name]=hashlib.sha256(path.read_bytes()).hexdigest()
    result['dtl_files_sha256']=files
    (HERE/'source-lock.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Fetched and verified exact artifact/DTL commits and gitlink; files:',len(files))
if __name__=='__main__':main()
