"""Keep original caller sources immutable; only fix driver spelling/fresh outputs."""
import difflib
import json
from pathlib import Path
import sys
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'preflight'))
from source_guard import verify as original_verify,ROOT,sha,need,blob
BASE='0783b780a67d1f2449ec0912d81e13fd168f8565'
def derived():
    old=(HERE.parent/'preflight/validate.py').read_text()
    prefix='import sys\nfrom pathlib import Path\nsys.path.insert(0,str(Path(__file__).resolve().parent.parent/"preflight"))\n'
    return old.replace('import argparse\n',prefix+'import argparse\n',1).replace('from lease import require_lease','from revision_guard import verify\nfrom lease import require_lease',1).replace("out=STAGE/'caller-validation-v1';build_root=Path('/tmp/fastest-bf-k12-actual-caller-v1')","out=STAGE/'caller-validation-v2';build_root=Path('/tmp/fastest-bf-k12-actual-caller-v2')",1).replace("Path(shutil.which('clang++')).resolve()","Path(shutil.which('clang++')).absolute()",1)
def verify(commit):
    pins=original_verify(BASE)
    old=(HERE.parent/'preflight/validate.py').read_text();new=derived()
    need((HERE/'validate.py').read_text()==new,'Changed bounded driver delta')
    patch=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='preflight/validate.py',tofile='preflight-v2/validate.py'))
    need((HERE/'validate.py.patch').read_text()==patch,'Changed driver patch')
    failed=HERE.parent/'caller-validation-v1/ARCHIVE.json'
    need(failed.read_bytes()==blob(failed,commit),'Changed committed failed evidence descriptor')
    pins[str(failed.relative_to(ROOT))]=sha(failed)
    for name,item in json.loads(failed.read_text())['files'].items():
        path=failed.parent/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,commit),'Changed preserved failure evidence');pins[str(path.relative_to(ROOT))]=item['sha256']
    prep=HERE/'PREPARATION.json';need(prep.read_bytes()==blob(prep,commit),'Changed new driver descriptor')
    for name,item in json.loads(prep.read_text())['files'].items():
        path=HERE/name;need(sha(path)==item['sha256']and path.stat().st_size==item['bytes']and path.read_bytes()==blob(path,commit),'Changed new driver source '+name);pins[str(path.relative_to(ROOT))]=item['sha256']
    pins[str(prep.relative_to(ROOT))]=sha(prep);return pins
