"""Bind unchanged V1, exact failed attempt and the additive include repair."""
import json,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;PARENT=HERE.parent
sys.path.insert(0,str(PARENT))
from source_guard import BASE,ROOT,OLD,sha,exact,verify as parent_verify
from contract import need
SOURCE='b7bec22fe6b88fe0b0382c6fb53a939dcf97f211'
FAILURE_SHA='e9e902f2db6dc768ff8b191d0f2228f74bf46f240cb189310efa89c801c2b29c'
def verify(commit):
 pins=parent_verify(SOURCE)
 for directory,name in [(HERE,'PREPARATION.json'),(PARENT/'validation-v1','FAILURE_ARCHIVE.json')]:
  manifest=directory/name;exact(commit,manifest)
  if name=='FAILURE_ARCHIVE.json':need(sha(manifest)==FAILURE_SHA,'First failure changed')
  pins[str(manifest)]=sha(manifest)
  for relative,item in json.loads(manifest.read_text())['files'].items():
   path=directory/relative;need(path.resolve().is_relative_to(directory),'Artifact escaped')
   need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Repair/failure artifact changed');exact(commit,path);pins[str(path)]=sha(path)
 meta=json.loads((PARENT/'validation-v1/metadata.json').read_text());need(not meta['complete']and len(meta['commands'])==5 and meta['commands'][-1]['label']=='native-build'and meta['commands'][-1]['returncode']!=0,'Wrong preserved failure')
 return pins
