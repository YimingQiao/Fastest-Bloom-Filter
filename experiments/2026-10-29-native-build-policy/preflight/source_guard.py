"""Initial wrapper and native sources remain byte-exact; additive guards are committed."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
from contract import need

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=STAGE.parents[1]
INITIAL='07746e17f82e3fa48adf3bbd1f6fed00daf71514'

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
def verify(commit):
    need(re.fullmatch('[0-9a-f]{40}',commit),'Exact reviewed source commit required')
    initial=STAGE/'PREPARATION.json';need(initial.read_bytes()==blob(INITIAL,initial),'Initial source manifest changed')
    sources={str((STAGE/name).relative_to(ROOT)):entry['sha256']for name,entry in json.loads(initial.read_text())['files'].items()}
    sources[str(initial.relative_to(ROOT))]=sha(initial)
    for name,digest in sources.items():need(sha(ROOT/name)==digest and hashlib.sha256(blob(INITIAL,ROOT/name)).hexdigest()==digest,'Initial source bytes changed '+name)
    native=json.loads((STAGE/'source-pins.json').read_text())
    for name,digest in native['files_sha256'].items():
        need(sha(ROOT/name)==digest and hashlib.sha256(blob(native['commit'],ROOT/name)).hexdigest()==digest,'Native library bytes changed '+name);sources[name]=digest
    prep=HERE/'PREPARATION.json'
    for name,entry in json.loads(prep.read_text())['files'].items():sources[str((HERE/name).relative_to(ROOT))]=entry['sha256']
    sources[str(prep.relative_to(ROOT))]=sha(prep)
    for name,digest in sources.items():need(sha(ROOT/name)==digest and hashlib.sha256(blob(commit,ROOT/name)).hexdigest()==digest,'Uncommitted prepared input '+name)
    return sources
