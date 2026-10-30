"""Offline complete raw/source audit. Does not invoke a filter or compiler."""
import argparse,json
from freeze import HERE,verify,sha,need
from screen_contract import audit
from pathlib import Path
def load_complete(source_commit):
    directory=HERE/'results-v1';metadata=json.loads((directory/'metadata.json').read_text())
    frozen=verify(source_commit);need(frozen==metadata['freeze']and frozen['binary']==metadata['binary'],'Frozen closure changed')
    need(sha('/usr/bin/numactl')==metadata['numactl_sha256'],'Placement executable changed')
    need(sha(HERE/'ANALYSIS_RULES.json')==metadata['analysis_rules_sha256'],'Analysis rules changed')
    manifest=json.loads((directory/'RAW_ARCHIVE.json').read_text());need(manifest['source_commit']==source_commit,'Wrong raw source')
    need(set(manifest['files'])=={'metadata.json','rows.json','results.csv'}|{f'case-{i:02d}.{s}'for i in range(24)for s in ('stdout','stderr')},'Incomplete raw inventory')
    for name,item in manifest['files'].items():need(sha(directory/name)==item['sha256']and(directory/name).stat().st_size==item['bytes'],'Raw artifact changed')
    counts=audit(directory,metadata,Path(frozen['binary']['path']),source_commit,sha)
    return metadata,json.loads((directory/'rows.json').read_text()),counts
if __name__=='__main__':
    need(__debug__,'Python -O unsupported');p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);a=p.parse_args();print(json.dumps(load_complete(a.source_commit)[2]))
