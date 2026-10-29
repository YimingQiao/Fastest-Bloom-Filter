"""Exact collector repair, with all other inherited helper bytes unchanged."""
from pathlib import Path
import difflib

def check(here):
 old=here.parent/'proof-v2'
 for name in ['dependencies.py','validate.py','bindings.py']:
  actual=''.join(difflib.unified_diff((old/name).read_text().splitlines(True),(here/name).read_text().splitlines(True),fromfile='proof-v2/'+name,tofile='proof-v3/'+name))
  if actual!=(here/(name+'.patch')).read_text():raise ValueError('Unexpected additive source delta '+name)
 for name in ['checks.py','exec_affinity.py','source_guard.py']:
  if (here/name).read_bytes()!=(old/name).read_bytes():raise ValueError('Inherited helper changed '+name)
 before="""                    key='bin-stem:'+value['target']['name']
                    need(key not in roots or roots[key]==identity,'Ambiguous Cargo binary stem')
                    roots[key]=identity
"""
 after="""                    # Rustc's hashed dep-info uses the structured Cargo target's
                    # Rust crate identifier: Cargo normalizes hyphens to underscores.
                    # Register only those two exact identity-derived spellings.
                    for stem in {value['target']['name'], value['target']['name'].replace('-', '_')}:
                        key='bin-stem:'+stem
                        need(key not in roots or roots[key]==identity,'Ambiguous Cargo binary stem')
                        roots[key]=identity
"""
 text=(old/'dependencies.py').read_text()
 if text.count(before)!=1 or text.replace(before,after)!=(here/'dependencies.py').read_text():raise ValueError('Collector is not the one exact identity-derived alias repair')
